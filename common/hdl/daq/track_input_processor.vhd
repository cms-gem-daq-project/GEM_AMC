----------------------------------------------------------------------------------
-- Company: Texas A&M University
-- Engineer: Evaldas Juska (Evaldas.Juska@cern.ch)
-- 
-- Create Date:    14:00:00 11-Jan-2016 
-- Design Name:    GLIB v2
-- Module Name:    Track Input Processor
-- Project Name:   GLIB v2
-- Target Devices: xc6vlx130t-1ff1156
-- Tool versions:  ISE  P.20131013
-- Description:    This module buffers track data from one OH, builds events, analyses the data for consistency and provides the events to the DAQ module for merging with other chambers and shipping to AMC13
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.gem_pkg.all;
use work.ipbus.all;

entity track_input_processor is
port(
    -- Reset
    reset_i                     : in std_logic;

    -- Config
    input_enable_i              : in std_logic; -- shuts off input for this module if 0

    -- FIFOs
    fifo_rd_clk_i               : in std_logic;
    infifo_dout_o               : out std_logic_vector(191 downto 0);
    infifo_rd_en_i              : in std_logic;
    infifo_empty_o              : out std_logic;
    infifo_valid_o              : out std_logic;
    infifo_underflow_o          : out std_logic;
    infifo_data_cnt_o           : out std_logic_vector(11 downto 0);
    evtfifo_dout_o              : out std_logic_vector(103 downto 0);
    evtfifo_rd_en_i             : in std_logic;
    evtfifo_empty_o             : out std_logic;
    evtfifo_valid_o             : out std_logic;
    evtfifo_underflow_o         : out std_logic;
    evtfifo_data_cnt_o          : out std_logic_vector(11 downto 0);

    -- Track data
    tk_data_link_i              : in t_data_link;
    
    -- Status and control
    status_o                    : out t_daq_input_status;
    control_i                   : in t_daq_input_control
);

end track_input_processor;

architecture Behavioral of track_input_processor is

    --================== COMPONENTS ==================--

    component daq_input_fifo is
        port(
            rst           : in  std_logic;
            wr_clk        : in  std_logic;
            rd_clk        : in  std_logic;
            din           : in  std_logic_vector(191 downto 0);
            wr_en         : in  std_logic;
            rd_en         : in  std_logic;
            dout          : out std_logic_vector(191 downto 0);
            full          : out std_logic;
            almost_full   : out std_logic;
            empty         : out std_logic;
            almost_empty  : out std_logic;
            valid         : out std_logic;
            underflow     : out std_logic;
            prog_full     : out std_logic;
            rd_data_count : out std_logic_vector(11 downto 0)
        );
    end component daq_input_fifo;
    
    component daq_event_fifo is
        port(
            rst           : in  std_logic;
            wr_clk        : in  std_logic;
            rd_clk        : in  std_logic;
            din           : in  std_logic_vector(103 downto 0);
            wr_en         : in  std_logic;
            rd_en         : in  std_logic;
            dout          : out std_logic_vector(103 downto 0);
            full          : out std_logic;
            almost_full   : out std_logic;
            empty         : out std_logic;
            valid         : out std_logic;
            underflow     : out std_logic;
            prog_full     : out std_logic;
            rd_data_count : out std_logic_vector(11 downto 0)
        );
    end component daq_event_fifo;
        
    --================== SIGNALS ==================--

    -- Constants (TODO: should be moved to package)
    constant vfat_block_marker      : std_logic_vector(47 downto 0) := x"a000c000e000";

    -- TTS
    signal tts_state                : std_logic_vector(3 downto 0) := "1000";
    signal tts_critical_error       : std_logic := '0'; -- critical error detected - RESYNC/RESET NEEDED
    signal tts_warning              : std_logic := '0'; -- overflow warning - STOP TRIGGERS
    signal tts_out_of_sync          : std_logic := '0'; -- out-of-sync - RESYNC NEEDED
    signal tts_busy                 : std_logic := '0'; -- I'm busy - NO TRIGGERS FOR NOW, PLEASE

    -- Counters
    signal cnt_corrupted_vfat       : unsigned(31 downto 0) := (others => '0');

    -- Error/warning flags (latched)
    signal err_infifo_full          : std_logic := '0';
    signal err_infifo_near_full     : std_logic := '0';
    signal err_infifo_underflow     : std_logic := '0'; -- Tried to read too many blocks from the input fifo when sending events to the DAQlink (indicates a problem in the vfat block counter)
    signal err_evtfifo_full         : std_logic := '0';
    signal err_evtfifo_near_full    : std_logic := '0';
    signal err_evtfifo_underflow    : std_logic := '0'; -- Tried to read too many events from the event fifo (indicates a problem in the AMC event builder)
    signal err_corrupted_vfat_data  : std_logic := '0'; -- detected at least one invalid VFAT block
    signal err_event_too_big        : std_logic := '0'; -- detected an event with too many VFAT blocks (more than 4095 blocks!)
    signal err_event_bigger_than_24 : std_logic := '0'; -- there was an event which had more than 24 VFAT blocks
    signal err_vfat_block_too_small : std_logic := '0'; -- didn't get the full 14 VFAT words for some block
    signal err_vfat_block_too_big   : std_logic := '0'; -- got more than 14 VFAT words for one block
    signal err_mixed_vfat_bc        : std_logic := '0'; -- different VFAT BCs found in one event
    signal err_mixed_vfat_ec        : std_logic := '0'; -- different VFAT ECs found in one event
    signal err_mixed_oh_bc          : std_logic := '0'; -- different OH BCs found in one event

    -- Input FIFO
    signal infifo_din               : std_logic_vector(191 downto 0) := (others => '0');
    signal infifo_wr_en             : std_logic := '0';
    signal infifo_full              : std_logic := '0';
    signal infifo_almost_full       : std_logic := '0';
    signal infifo_empty             : std_logic := '0';
    signal infifo_underflow         : std_logic := '0';

    -- Event FIFO
    signal evtfifo_din              : std_logic_vector(103 downto 0) := (others => '0');
    signal evtfifo_wr_en            : std_logic := '0';
    signal evtfifo_full             : std_logic := '0';
    signal evtfifo_almost_full      : std_logic := '0';
    signal evtfifo_empty            : std_logic := '0';
    signal evtfifo_underflow        : std_logic := '0';

    -- Event processor
    signal ep_vfat_block_data       : std_logic_vector(223 downto 0) := (others => '0');
    signal ep_vfat_block_en         : std_logic := '0';
    signal ep_vfat_word             : integer range 0 to 14 := 14;
    signal ep_zero_packet           : std_logic;
    signal ep_last_oh_ec_bc         : std_logic_vector(31 downto 0) := (others => '0');
    signal ep_last_ec               : std_logic_vector(7 downto 0) := (others => '0');
    signal ep_last_bc               : std_logic_vector(11 downto 0) := (others => '0');
    signal ep_first_ever_block      : std_logic := '1'; -- it's the first ever event
    signal ep_end_of_event          : std_logic := '0';
    signal ep_last_rx_data          : std_logic_vector(223 downto 0) := (others => '0');
    signal ep_last_rx_data_valid    : std_logic := '0';
    signal ep_last_rx_data_suppress : std_logic := '0';
    signal ep_invalid_vfat_block    : std_logic := '0';
    
    -- Event builder
    signal eb_vfat_words_64         : unsigned(11 downto 0) := (others => '0'); -- number of non-zero-suppressed VFAT 64bit words in the current event
    signal eb_vfat_zs_words_64      : unsigned(11 downto 0) := (others => '0'); -- number of zero-suppressed VFAT 64bit words in the current event
    signal eb_vfat_bc               : std_logic_vector(11 downto 0) := (others => '0');
    signal eb_oh_ec_bc              : std_logic_vector(31 downto 0) := (others => '0');
    signal eb_vfat_ec               : std_logic_vector(7 downto 0) := (others => '0');
    signal eb_counters_valid        : std_logic := '0';
    signal eb_event_num             : unsigned(23 downto 0) := x"000001";
    signal eb_event_num_short       : unsigned(7 downto 0) := x"00"; -- used to double check with VFAT EC
    signal eb_vfat_live_words_64    : unsigned(11 downto 0) := (others => '0'); -- number of non-zero-suppressed plus zero-suppressed VFAT 64bit words in the last event (for monitoring)
    signal eb_vfat_live_words_64_min: unsigned(11 downto 0) := (others => '1'); -- minimum number of non-zero-suppressed plus zero-suppressed VFAT 64bit words since last resync (for monitoring)
    signal eb_vfat_live_words_64_max: unsigned(11 downto 0) := (others => '0'); -- maximum number of non-zero-suppressed plus zero-suppressed VFAT 64bit words since last resync (for monitoring)
    
    signal eb_invalid_vfat_block    : std_logic := '0';
    signal eb_event_too_big         : std_logic := '0';
    signal eb_event_bigger_than_24  : std_logic := '0';
    signal eb_mixed_vfat_bc         : std_logic := '0';
    signal eb_mixed_vfat_ec         : std_logic := '0';
    signal eb_mixed_oh_bc           : std_logic := '0';

    -- Event processor timeout
    signal eb_timer                 : unsigned(23 downto 0) := (others => '0');
    signal eb_timeout_delay         : unsigned(23 downto 0) := x"03d090"; -- 10ms (very large)
    signal eb_timeout_flag          : std_logic := '0';
    signal eb_last_timer            : unsigned(23 downto 0) := (others => '0');
    signal eb_max_timer             : unsigned(23 downto 0) := (others => '0');

    -- Debug flags for ChipScope
--    attribute MARK_DEBUG : string;
--    attribute MARK_DEBUG of tk_data_link_i              : signal is "TRUE";
--    attribute MARK_DEBUG of eb_timer                    : signal is "TRUE";
--    attribute MARK_DEBUG of eb_last_timer               : signal is "TRUE";
--    attribute MARK_DEBUG of eb_max_timer                : signal is "TRUE";
--    attribute MARK_DEBUG of eb_timeout_flag             : signal is "TRUE";
--    attribute MARK_DEBUG of eb_invalid_vfat_block       : signal is "TRUE";
--    attribute MARK_DEBUG of eb_vfat_words_64            : signal is "TRUE";
--    attribute MARK_DEBUG of eb_vfat_bc                  : signal is "TRUE";
--    attribute MARK_DEBUG of eb_oh_bc                    : signal is "TRUE";
--    attribute MARK_DEBUG of eb_vfat_ec                  : signal is "TRUE";
--    attribute MARK_DEBUG of eb_counters_valid           : signal is "TRUE";
--    attribute MARK_DEBUG of eb_event_num_short          : signal is "TRUE";
--    attribute MARK_DEBUG of ep_vfat_block_en            : signal is "TRUE";
--    attribute MARK_DEBUG of ep_end_of_event             : signal is "TRUE";
--    attribute MARK_DEBUG of ep_last_rx_data_valid       : signal is "TRUE";
--    attribute MARK_DEBUG of tts_state                   : signal is "TRUE";
--    
--    attribute MARK_DEBUG of infifo_din                  : signal is "TRUE";
--    attribute MARK_DEBUG of infifo_wr_en                : signal is "TRUE";
--    attribute MARK_DEBUG of infifo_empty                : signal is "TRUE";
--
--    attribute MARK_DEBUG of evtfifo_din                 : signal is "TRUE";
--    attribute MARK_DEBUG of evtfifo_wr_en               : signal is "TRUE";
--    attribute MARK_DEBUG of evtfifo_empty               : signal is "TRUE";
--    
--    attribute MARK_DEBUG of fifo_rd_clk_i               : signal is "TRUE";
--    attribute MARK_DEBUG of infifo_rd_en_i              : signal is "TRUE";
--    attribute MARK_DEBUG of evtfifo_rd_en_i             : signal is "TRUE";

begin

    --================================--
    -- TTS
    --================================--
    
    tts_critical_error <= err_event_too_big or 
                          err_evtfifo_full or 
                          err_evtfifo_underflow or 
                          err_infifo_full or
                          err_infifo_underflow;
                          
    tts_warning <= err_infifo_near_full or err_evtfifo_near_full;
    
    tts_out_of_sync <= '0'; -- No condition for now for setting OOS at the chamber event builder level (this will be used in AMC event builder)
    
    tts_busy <= reset_i; -- not used for now except for reset at this level
                          
    tts_state <= x"8" when (input_enable_i = '0') else
                 x"4" when (tts_busy = '1') else
                 x"c" when (tts_critical_error = '1') else
                 x"2" when (tts_out_of_sync = '1') else
                 x"1" when (tts_warning = '1') else
                 x"8";

    --================================--
    -- Counters
    --================================--
    i_infifo_near_full_counter : entity work.counter
    generic map(
        g_COUNTER_WIDTH  => 16,
        g_ALLOW_ROLLOVER => FALSE
    )
    port map(
        ref_clk_i => tk_data_link_i.clk,
        reset_i   => reset_i,
        en_i      => err_infifo_near_full,
        count_o   => status_o.infifo_near_full_cnt
    );

    i_evtfifo_near_full_counter : entity work.counter
    generic map(
        g_COUNTER_WIDTH  => 16,
        g_ALLOW_ROLLOVER => FALSE
    )
    port map(
        ref_clk_i => tk_data_link_i.clk,
        reset_i   => reset_i,
        en_i      => err_evtfifo_near_full,
        count_o   => status_o.evtfifo_near_full_cnt
    );

    --================================--
    -- FIFOs
    --================================--
  
    -- Input FIFO
    i_input_fifo : component daq_input_fifo
    port map(
        rst           => reset_i,
        wr_clk        => tk_data_link_i.clk,
        rd_clk        => fifo_rd_clk_i,
        din           => infifo_din,
        wr_en         => infifo_wr_en,
        rd_en         => infifo_rd_en_i,
        dout          => infifo_dout_o,
        full          => infifo_full,
        almost_full   => infifo_almost_full,
        empty         => infifo_empty,
        almost_empty  => open,
        valid         => infifo_valid_o,
        underflow     => infifo_underflow,
        prog_full     => err_infifo_near_full,
        rd_data_count => infifo_data_cnt_o
    );

    infifo_empty_o <= infifo_empty;
    infifo_underflow_o <= infifo_underflow;

    -- Event FIFO
    i_event_fifo : component daq_event_fifo
    port map(
        rst           => reset_i,
        wr_clk        => tk_data_link_i.clk,
        rd_clk        => fifo_rd_clk_i,
        din           => evtfifo_din,
        wr_en         => evtfifo_wr_en,
        rd_en         => evtfifo_rd_en_i,
        dout          => evtfifo_dout_o,
        full          => evtfifo_full,
        almost_full   => evtfifo_almost_full,
        empty         => evtfifo_empty,
        valid         => evtfifo_valid_o,
        underflow     => evtfifo_underflow,
        prog_full     => err_evtfifo_near_full,
        rd_data_count => evtfifo_data_cnt_o
    );

    evtfifo_empty_o <= evtfifo_empty;
    evtfifo_underflow_o <= evtfifo_underflow;

    -- Check for underflows
    process(fifo_rd_clk_i)
    begin
        if (rising_edge(fifo_rd_clk_i)) then
            if (reset_i = '1') then
                err_infifo_underflow <= '0';
                err_evtfifo_underflow <= '0';
            else
                if (evtfifo_underflow = '1') then
                    err_evtfifo_underflow <= '1';
                end if;
                if (infifo_underflow = '1') then
                    err_infifo_underflow <= '1';
                end if;
            end if;
        end if;
    end process;

    -- InFIFO write rate counter
    i_infifo_write_rate : entity work.rate_counter
    generic map(
        g_CLK_FREQUENCY => std_logic_vector(to_unsigned(160_000_000, 32)),
        g_COUNTER_WIDTH => 15
    )
    port map(
        clk_i   => tk_data_link_i.clk,
        reset_i => reset_i,
        en_i    => infifo_wr_en,
        rate_o  => status_o.infifo_wr_rate
    );

    -- EvtFIFO write rate counter
    i_evtfifo_write_rate : entity work.rate_counter
    generic map(
        g_CLK_FREQUENCY => std_logic_vector(to_unsigned(160_000_000, 32)),
        g_COUNTER_WIDTH => 17
    )
    port map(
        clk_i   => tk_data_link_i.clk,
        reset_i => reset_i,
        en_i    => evtfifo_wr_en,
        rate_o  => status_o.evtfifo_wr_rate
    );

    --================================--
    -- Glue input data into VFAT blocks
    --================================--
    -- TODO: this should be merged with Input Processor later
    process(tk_data_link_i.clk)
    begin
        if (rising_edge(tk_data_link_i.clk)) then
        
            if (reset_i = '1') then
                ep_vfat_block_data <= (others => '0');
                ep_vfat_block_en <= '0';
                ep_vfat_word <= 14;
                err_vfat_block_too_big <= '0';
                err_vfat_block_too_small <= '0';
                ep_zero_packet <= '1';
            else
                if (tk_data_link_i.data_en = '1') then
                
                    -- receiving VFAT data
                    if (ep_vfat_word > 2) then
                        ep_vfat_block_data((((ep_vfat_word - 2) * 16) - 1) downto ((ep_vfat_word - 3) * 16)) <= tk_data_link_i.data;
                        ep_vfat_word <= ep_vfat_word - 1;
                    -- receiving OH BX data
                    elsif (ep_vfat_word > 0) then
                        ep_vfat_block_data((((ep_vfat_word + 12) * 16) - 1) downto ((ep_vfat_word + 11) * 16)) <= tk_data_link_i.data;
                        ep_vfat_word <= ep_vfat_word - 1;
                    -- still receiving data even though we expect that the block should have ended already
                    else
                        err_vfat_block_too_big <= '1';
                    end if;

                    -- channel data - check if they're all zero (for zero suppression later on)                    
                    if ((ep_vfat_word < 12) and (ep_vfat_word > 3) and (tk_data_link_i.data /= x"0000")) then
                        ep_zero_packet <= '0';
                    end if;
                    
                    -- the last word
                    if (ep_vfat_word = 1) then
                        ep_vfat_block_en <= '1';
                    else
                        ep_vfat_block_en <= '0';
                    end if;
                    
                else

                    -- get ready to read a new block
                    ep_vfat_word <= 14;
                    ep_vfat_block_en <= '0';
                    ep_zero_packet <= '1';
                
                    -- if the strobe is off and the vfat word pointer is not at 0 and not at 14 it means that it didn't finish transmitting all 14 VFAT words - not good
                    if ((ep_vfat_word /= 0) and (ep_vfat_word /= 14)) then
                        err_vfat_block_too_small <= '1';
                    end if;
                                    
                end if;
                
            end if;
        end if;
    end process;
    

    --================================--
    -- Input processor
    --================================--
    
    process(tk_data_link_i.clk)
    begin
        if (rising_edge(tk_data_link_i.clk)) then

            if (reset_i = '1') then
                ep_last_rx_data <= (others => '0');
                ep_last_rx_data_valid <= '0';
                err_infifo_full <= '0';
                infifo_din <= (others => '0');
                infifo_wr_en <= '0';
                ep_end_of_event <= '0';
                err_corrupted_vfat_data <= '0';
                cnt_corrupted_vfat <= (others => '0');
                ep_invalid_vfat_block <= '0';
                ep_last_ec <= (others => '0');
                ep_last_bc <= (others => '0');
                ep_last_oh_ec_bc <= (others => '0');
                ep_first_ever_block <= '1';
                ep_last_rx_data_suppress <= '0';
            else

                -- fill in last data
                ep_last_rx_data <= ep_vfat_block_data; -- TOTO Optimization: instead of duplicating all the data you could only retain the OH 32bits, others you can get form infifo_din
                ep_last_rx_data_valid <= ep_vfat_block_en;
                ep_last_rx_data_suppress <= ep_zero_packet and control_i.eb_zero_supression_en;
            
                if (eb_timeout_flag = '1') then
                    ep_first_ever_block <= '1';
                end if;
                
                if ((ep_vfat_block_en = '1') and (reset_i = '0')) then
                
                    -- monitor the input FIFO
                    if (infifo_full = '1') then
                        err_infifo_full <= '1';
                    end if;
                    
                    -- push to input FIFO if it's not full and we don't zero suppress it
                    if ((infifo_full = '0') and (ep_zero_packet = '0' or control_i.eb_zero_supression_en = '0')) then
                        infifo_din <= ep_vfat_block_data(191 downto 0);
                        infifo_wr_en <= '1';
                    end if;
                    
                    -- invalid vfat block? if yes, then just attach it to current event
                    if ((ep_vfat_block_data(191 downto 144) and x"f000f000f000") /= vfat_block_marker) then
                        ep_invalid_vfat_block <= '1';
                        ep_end_of_event <= '0'; -- a corrupt block will never be an end of event - just attach it to current event
                        err_corrupted_vfat_data <= '1';
                        cnt_corrupted_vfat <= cnt_corrupted_vfat + 1;
                    else -- valid block
                        ep_invalid_vfat_block <= '0';
                        ep_last_ec <= ep_vfat_block_data(171 downto 164);
                        ep_last_bc <= ep_vfat_block_data(187 downto 176);
                        ep_last_oh_ec_bc <= ep_vfat_block_data(223 downto 192);
                        
                        if (ep_first_ever_block = '1') then
                            ep_first_ever_block <= '0';
                        end if;
                        
--                        if ((ep_first_ever_block = '0') and (ep_last_ec /= ep_vfat_block_data(171 downto 164))) then
-- for now checking for end of event using BC, but later should use an L1A counter or OH orbit counter + OH BC (on VFAT2 EC is reset with BC0, so we can't use that for now)
                        if ((ep_first_ever_block = '0') and (eb_timeout_flag = '0') and
                            (((ep_last_bc /= ep_vfat_block_data(187 downto 176)) and (control_i.eb_eoe_use_oh_ec_bc = '0')) or
                             ((ep_last_oh_ec_bc /= ep_vfat_block_data(223 downto 192)) and (control_i.eb_eoe_use_oh_ec_bc = '1'))))
                        then
                            ep_end_of_event <= '1';
                        else
                            ep_end_of_event <= '0';
                        end if;
                        
                    end if;
                    
                -- no data
                else
                    infifo_wr_en <= '0';
                end if;
                
            end if;
        end if;
    end process;    
    
    --================================--
    -- Event Builder
    --================================--
    process(tk_data_link_i.clk)
    begin
        if (rising_edge(tk_data_link_i.clk)) then
        
            if (reset_i = '1') then
                evtfifo_din <= (others => '0');
                evtfifo_wr_en <= '0';
                eb_invalid_vfat_block <= '0';
                eb_vfat_words_64 <= (others => '0');
                eb_vfat_zs_words_64 <= (others => '0');
                eb_vfat_bc <= (others => '0');
                eb_oh_ec_bc <= (others => '0');
                eb_vfat_ec <= (others => '0');
                eb_counters_valid <= '0';
                eb_event_num <= (others => '0');
                eb_event_num_short <= (others => '0');
                eb_mixed_vfat_bc <= '0';
                err_mixed_vfat_bc <= '0';
                eb_mixed_vfat_ec <= '0';
                err_mixed_vfat_ec <= '0';
                eb_mixed_oh_bc <= '0';
                err_mixed_oh_bc <= '0';
                eb_event_too_big <= '0';
                err_event_too_big <= '0';
                eb_event_bigger_than_24 <= '0';
                err_event_bigger_than_24 <= '0';
                err_evtfifo_full <= '0';
                eb_timer <= (others => '0');
                eb_timeout_flag <= '0';
                eb_vfat_live_words_64 <= (others => '0');
                eb_vfat_live_words_64_min <= (others => '1');
                eb_vfat_live_words_64_max <= (others => '0');
            else
                
                if (eb_timer >= eb_timeout_delay) then
                    eb_timeout_flag <= '1';                   
                end if;
                
                -- No data coming, but we do have data in the buffer, manage the timeout timer
                if ((ep_last_rx_data_valid = '0') and (eb_vfat_words_64 /= x"000") and (eb_timeout_flag = '0')) then
                    eb_timer <= eb_timer + 1;
                end if;
                
                -- Continuation of the current event - update flags and counters
                if ((ep_last_rx_data_valid = '1') and (ep_end_of_event = '0')) then
                
                    -- collect the timer stats and reset it along with the timeout flag
                    eb_last_timer <= eb_timer;
                    if (eb_timer > eb_max_timer) then
                        eb_max_timer <= eb_timer;
                    end if; 
                    eb_timer <= (others => '0');
                    eb_timeout_flag <= '0';
                
                    -- do not write to event fifo
                    evtfifo_wr_en <= '0';

                    -- is this block a valid VFAT block?
                    if (ep_invalid_vfat_block = '1') then
                        eb_invalid_vfat_block <= '1';
                    end if;
                    
                    -- increment the word counter if the counter is not full yet and we didn't zero suppress this data
                    if (eb_vfat_words_64 = x"fff") then
                        eb_event_too_big <= '1';
                        err_event_too_big <= '1';
                    elsif (ep_last_rx_data_suppress = '0') then
                        eb_vfat_words_64 <= eb_vfat_words_64 + 3;
                    else
                        eb_vfat_zs_words_64 <= eb_vfat_zs_words_64 + 3;
                    end if;
                                        
                    -- do we have more than 24 VFAT blocks?
                    if ((eb_vfat_words_64 > x"45") and (ep_last_rx_data_suppress = '0')) then
                        eb_event_bigger_than_24 <= '1';
                        err_event_bigger_than_24 <= '1';
                    end if;
                          
                    -- if we don't have valid bc, fill them in now (this is the case of first ever vfat block or after a timeout)
                    if (eb_counters_valid = '0') then
                        eb_vfat_bc <= ep_last_rx_data(187 downto 176);
                        eb_oh_ec_bc <= ep_last_rx_data(223 downto 192);
                        eb_vfat_ec <= ep_last_rx_data(171 downto 164);
                        eb_counters_valid <= '1';
                    else -- we do have a valid bc
                        
                        -- is the current vfat bc different than the previous (in the same event)
                        if (eb_vfat_bc /= ep_last_rx_data(187 downto 176)) then
                            eb_mixed_vfat_bc <= '1';
                            err_mixed_vfat_bc <= '1';
                        end if;
                        
                        -- is the current OH bc different than the previous (in the same event)
                        if (eb_oh_ec_bc /= ep_last_rx_data(223 downto 192)) then
                            eb_mixed_oh_bc <= '1';
                            err_mixed_oh_bc <= '1';
                        end if;
                        
                        -- is the current VFAT ec different than the previous (in the same event)
                        if (eb_vfat_ec /= ep_last_rx_data(171 downto 164)) then
                            eb_mixed_vfat_ec <= '1';
                            err_mixed_vfat_ec <= '1';
                        end if;
                        
                    end if;
                    
                -- End of event - push to event fifo, reset the flags and populate the new event ids (event num, bx, etc)
                elsif (((ep_last_rx_data_valid = '1') and (ep_end_of_event = '1')) or (eb_timeout_flag = '1')) then
                
                    -- Push to event FIFO
                    if (evtfifo_full = '0') then
                        evtfifo_wr_en <= '1';
                        evtfifo_din <= std_logic_vector(eb_vfat_zs_words_64) &
                                       eb_oh_ec_bc & 
                                       std_logic_vector(eb_event_num) & 
                                       eb_vfat_bc & 
                                       std_logic_vector(eb_vfat_words_64) & 
                                       evtfifo_almost_full & 
                                       err_evtfifo_full & 
                                       err_infifo_full & 
                                       err_evtfifo_near_full & 
                                       err_infifo_near_full & 
                                       err_infifo_underflow &
                                       eb_event_too_big &
                                       eb_invalid_vfat_block & 
                                       eb_event_bigger_than_24 &
                                       eb_mixed_oh_bc & 
                                       eb_mixed_vfat_bc & 
                                       eb_mixed_vfat_ec;
                    else
                        err_evtfifo_full <= '1';
                    end if;

                    if (eb_timeout_flag = '0') then
                        eb_vfat_bc <= ep_last_rx_data(187 downto 176);
                        eb_oh_ec_bc <= ep_last_rx_data(223 downto 192);
                        eb_vfat_ec <= ep_last_rx_data(171 downto 164);
                        eb_counters_valid <= '1';
                        if (ep_last_rx_data_suppress = '0') then
                            eb_vfat_words_64 <= x"003"; -- we already have one VFAT block in the next event (that's the one that marked the end of the previous event)
                            eb_vfat_zs_words_64 <= (others => '0');
                        else
                            eb_vfat_words_64 <= x"000"; -- the current VFAT block which belongs to the next event is zero suppressed
                            eb_vfat_zs_words_64 <= x"003";
                        end if;
                    else
                        eb_counters_valid <= '0';
                        eb_vfat_words_64 <= x"000"; -- no data yet after timeout
                        eb_vfat_zs_words_64 <= (others => '0');
                    end if;
                    
                    -- Increment the event number, set bx
                    eb_event_num <= eb_event_num + 1;
                    eb_event_num_short <= eb_event_num_short + 1;
                    
                    -- reset event flags
                    eb_invalid_vfat_block <= '0';
                    eb_mixed_vfat_bc <= '0';
                    eb_mixed_vfat_ec <= '0';
                    eb_mixed_oh_bc <= '0';
                    eb_event_too_big <= '0';
                    eb_event_bigger_than_24 <= '0';
                    
                    -- reset the timeout
                    eb_timeout_flag <= '0';
                    eb_timer <= (others => '0');
                    
                    -- monitor the number of words
                    eb_vfat_live_words_64 <= eb_vfat_zs_words_64 + eb_vfat_words_64;
                    if (eb_vfat_zs_words_64 + eb_vfat_words_64 < eb_vfat_live_words_64_min) then
                        eb_vfat_live_words_64_min <= eb_vfat_zs_words_64 + eb_vfat_words_64;
                    end if;
                    
                    if (eb_vfat_zs_words_64 + eb_vfat_words_64 > eb_vfat_live_words_64_max) then
                        eb_vfat_live_words_64_max <= eb_vfat_zs_words_64 + eb_vfat_words_64;
                    end if;

                else
                
                    -- hmm
                    evtfifo_wr_en <= '0';
                    
                end if;
                
            end if;
        end if;
    end process;

    --================================--
    -- Monitoring & Control
    --================================--

    status_o.evtfifo_empty              <= evtfifo_empty;
    status_o.evtfifo_near_full          <= err_evtfifo_near_full;
    status_o.evtfifo_full               <= evtfifo_full;
    status_o.evtfifo_underflow          <= evtfifo_underflow;
    status_o.infifo_empty               <= infifo_empty;
    status_o.infifo_near_full           <= err_infifo_near_full;
    status_o.infifo_full                <= infifo_full;
    status_o.infifo_underflow           <= infifo_underflow;
    status_o.tts_state                  <= tts_state;
    status_o.err_event_too_big          <= err_event_too_big;
    status_o.err_evtfifo_full           <= err_evtfifo_full;
    status_o.err_infifo_underflow       <= err_infifo_underflow;
    status_o.err_infifo_full            <= err_infifo_full;
    status_o.err_corrupted_vfat_data    <= err_corrupted_vfat_data;
    status_o.err_vfat_block_too_big     <= err_vfat_block_too_big;
    status_o.err_vfat_block_too_small   <= err_vfat_block_too_small;
    status_o.err_event_bigger_than_24   <= err_event_bigger_than_24;
    status_o.err_mixed_oh_bc            <= err_mixed_oh_bc;
    status_o.err_mixed_vfat_bc          <= err_mixed_vfat_bc;
    status_o.err_mixed_vfat_ec          <= err_mixed_vfat_ec;

    status_o.cnt_corrupted_vfat         <= std_logic_vector(cnt_corrupted_vfat);
    status_o.eb_event_num               <= std_logic_vector(eb_event_num);
    status_o.eb_max_timer               <= std_logic_vector(eb_max_timer);
    status_o.eb_last_timer              <= std_logic_vector(eb_last_timer);

    status_o.eb_vfat_live_words_64      <= std_logic_vector(eb_vfat_live_words_64);
    status_o.eb_vfat_live_words_64_min  <= std_logic_vector(eb_vfat_live_words_64_min);
    status_o.eb_vfat_live_words_64_max  <= std_logic_vector(eb_vfat_live_words_64_max);

    status_o.ep_vfat_block_data(0)      <= ep_vfat_block_data(31 downto 0);
    status_o.ep_vfat_block_data(1)      <= ep_vfat_block_data(63 downto 32);
    status_o.ep_vfat_block_data(2)      <= ep_vfat_block_data(95 downto 64);
    status_o.ep_vfat_block_data(3)      <= ep_vfat_block_data(127 downto 96);
    status_o.ep_vfat_block_data(4)      <= ep_vfat_block_data(159 downto 128);
    status_o.ep_vfat_block_data(5)      <= ep_vfat_block_data(191 downto 160);
    status_o.ep_vfat_block_data(6)      <= ep_vfat_block_data(223 downto 192);

    eb_timeout_delay <= unsigned(control_i.eb_timeout_delay);

end Behavioral;

