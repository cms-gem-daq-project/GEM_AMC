----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Evaldas Juska (Evaldas.Juska@cern.ch)
-- 
-- Create Date:    20:18:40 09/17/2015 
-- Design Name:    GLIB v2
-- Module Name:    DAQ
-- Project Name:   GLIB v2
-- Target Devices: xc6vlx130t-1ff1156
-- Tool versions:  ISE  P.20131013
-- Description:    This module buffers track data, builds events, analyses the data for consistency and ships off the events with all the needed headers and trailers to AMC13 over DAQLink
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.gem_pkg.all;
use work.ttc_pkg.all;
use work.ipbus.all;
use work.registers.all;

entity daq is
generic(
    g_NUM_OF_OHs         : integer;
    g_DAQ_CLK_FREQ       : integer;
    g_DEBUG              : boolean := false
);
port(

    -- Reset
    reset_i                     : in std_logic;

    -- Clocks
    daq_clk_i                   : in std_logic; -- for now use 25MHz, but could try 50MHz
    daq_clk_locked_i            : in std_logic;

    -- DAQLink
    daq_to_daqlink_o            : out t_daq_to_daqlink;
    daqlink_to_daq_i            : in  t_daqlink_to_daq;
        
    -- TTC
    ttc_clks_i                  : in t_ttc_clks;
    ttc_cmds_i                  : in t_ttc_cmds;
    ttc_daq_cntrs_i             : in t_ttc_daq_cntrs;
    ttc_status_i                : in t_ttc_status;

    resync_frontend_o           : out std_logic;

    -- Track data
    tk_data_links_i             : in t_data_link_array(g_NUM_OF_OHs - 1 downto 0);
    
    -- IPbus
    ipb_reset_i                 : in  std_logic;
    ipb_clk_i                   : in std_logic;
	ipb_mosi_i                  : in ipb_wbus;
	ipb_miso_o                  : out ipb_rbus;
    
    -- Other
    board_sn_i                  : in std_logic_vector(15 downto 0) -- board serial ID, needed for the header to AMC13
    
);
end daq;

architecture Behavioral of daq is

    --================== COMPONENTS ==================--

    component daq_l1a_fifo is
        port(
            rst           : in  std_logic;
            wr_clk        : in  std_logic;
            rd_clk        : in  std_logic;
            din           : in  std_logic_vector(51 downto 0);
            wr_en         : in  std_logic;
            wr_ack        : out std_logic;
            rd_en         : in  std_logic;
            dout          : out std_logic_vector(51 downto 0);
            full          : out std_logic;
            overflow      : out std_logic;
            almost_full   : out std_logic;
            empty         : out std_logic;
            valid         : out std_logic;
            underflow     : out std_logic;
            prog_full     : out std_logic;
            rd_data_count : out std_logic_vector(12 DOWNTO 0)
        );
    end component daq_l1a_fifo;  

    component daq_output_fifo
        port(
            clk           : in  std_logic;
            rst           : in  std_logic;
            din           : in  std_logic_vector(65 DOWNTO 0);
            wr_en         : in  std_logic;
            rd_en         : in  std_logic;
            dout          : out std_logic_vector(65 DOWNTO 0);
            full          : out std_logic;
            empty         : out std_logic;
            valid         : out std_logic;
            prog_full     : out std_logic;
            data_count    : out std_logic_vector(12 DOWNTO 0)
        );
    end component;

    component ila_daq
        port(
            clk    : in std_logic;
            probe0 : in std_logic_vector(3 DOWNTO 0);
            probe1 : in std_logic_vector(3 DOWNTO 0);
            probe2 : in std_logic;
            probe3 : in std_logic;
            probe4 : in std_logic;
            probe5 : in std_logic;
            probe6 : in std_logic;
            probe7 : in std_logic;
            probe8 : in std_logic;
            probe9 : in std_logic
        );
    end component;
    
    --================== SIGNALS ==================--

    -- Reset
    signal reset_global         : std_logic := '1';
    signal reset_daq_async      : std_logic := '1';
    signal reset_daq_async_dly  : std_logic := '1';
    signal reset_daq            : std_logic := '1';
    signal reset_daqlink        : std_logic := '1'; -- should only be done once at powerup
    signal reset_pwrup          : std_logic := '1';
    signal reset_local          : std_logic := '1';
    signal reset_daqlink_ipb    : std_logic := '0';

    -- DAQlink
    signal daq_event_data       : std_logic_vector(63 downto 0) := (others => '0');
    signal daq_event_write_en   : std_logic := '0';
    signal daq_event_header     : std_logic := '0';
    signal daq_event_trailer    : std_logic := '0';
    signal daq_ready            : std_logic := '0';
    signal daq_almost_full      : std_logic := '0';
  
    signal daq_disper_err_cnt   : std_logic_vector(15 downto 0) := (others => '0');
    signal daq_notintable_err_cnt: std_logic_vector(15 downto 0) := (others => '0');
    signal daqlink_afull_cnt    : std_logic_vector(15 downto 0) := (others => '0');

    -- DAQ Error Flags
    signal err_l1afifo_full     : std_logic := '0';
    signal err_daqfifo_full     : std_logic := '0';

    -- TTS
    signal tts_state            : std_logic_vector(3 downto 0) := "1000";
    signal tts_critical_error   : std_logic := '0'; -- critical error detected - RESYNC/RESET NEEDED
    signal tts_warning          : std_logic := '0'; -- overflow warning - STOP TRIGGERS
    signal tts_out_of_sync      : std_logic := '0'; -- out-of-sync - RESYNC NEEDED
    signal tts_busy             : std_logic := '0'; -- I'm busy - NO TRIGGERS FOR NOW, PLEASE
    signal tts_override         : std_logic_vector(3 downto 0) := x"0"; -- this can be set via IPbus and will override the TTS state if it's not x"0" (regardless of reset_daq and daq_enable)
    
    signal tts_chmb_critical    : std_logic := '0'; -- input critical error detected - RESYNC/RESET NEEDED
    signal tts_chmb_warning     : std_logic := '0'; -- input overflow warning - STOP TRIGGERS
    signal tts_chmb_out_of_sync : std_logic := '0'; -- input out-of-sync - RESYNC NEEDED

    signal tts_start_cntdwn_chmb: unsigned(7 downto 0) := x"ff";
    signal tts_start_cntdwn     : unsigned(7 downto 0) := x"ff";

    signal tts_warning_cnt      : std_logic_vector(15 downto 0);

    -- Resync
    signal resync_mode          : std_logic := '0'; -- when this signal is asserted it means that we received a resync and we're still processing the L1A fifo and holding TTS in BUSY
    signal resync_done          : std_logic := '0'; -- when this is asserted it means that L1As have been drained and we're ready to reset the DAQ and tell AMC13 that we're done
    signal resync_done_delayed  : std_logic := '0';

    -- Error signals transfered to TTS clk domain
    signal tts_chmb_critical_tts_clk    : std_logic := '0'; -- tts_chmb_critical transfered to TTS clock domain
    signal tts_chmb_warning_tts_clk     : std_logic := '0'; -- tts_chmb_warning transfered to TTS clock domain
    signal tts_chmb_out_of_sync_tts_clk : std_logic := '0'; -- tts_chmb_out_of_sync transfered to TTS clock domain
    signal err_daqfifo_full_tts_clk     : std_logic := '0'; -- err_daqfifo_full transfered to TTS clock domain
    
    -- DAQ conf
    signal daq_enable           : std_logic := '1'; -- enable sending data to DAQLink
    signal input_mask           : std_logic_vector(23 downto 0) := x"000000";
    signal run_type             : std_logic_vector(3 downto 0) := x"0"; -- run type (set by software and included in the AMC header)
    signal run_params           : std_logic_vector(23 downto 0) := x"000000"; -- optional run parameters (set by software and included in the AMC header)
    signal zero_suppression_en  : std_logic;
    
    -- DAQ counters
    signal cnt_sent_events      : unsigned(31 downto 0) := (others => '0');
    signal cnt_corrupted_vfat   : unsigned(31 downto 0) := (others => '0');

    -- DAQ event sending state machine
    signal daq_state            : unsigned(3 downto 0) := (others => '0');
    signal daq_curr_vfat_block  : unsigned(11 downto 0) := (others => '0');
    signal daq_curr_block_word  : integer range 0 to 2 := 0;
        
    -- IPbus registers
    type ipb_state_t is (IDLE, RSPD, RST);
    signal ipb_state                : ipb_state_t := IDLE;    
    signal ipb_reg_sel              : integer range 0 to (16 * (g_NUM_OF_OHs + 10)) + 15;  -- 16 regs for AMC evt builder and 16 regs for each chamber evt builder   
    signal ipb_read_reg_data        : t_std32_array(0 to (16 * (g_NUM_OF_OHs + 10)) + 15); -- 16 regs for AMC evt builder and 16 regs for each chamber evt builder
    signal ipb_write_reg_data       : t_std32_array(0 to (16 * (g_NUM_OF_OHs + 10)) + 15); -- 16 regs for AMC evt builder and 16 regs for each chamber evt builder
    
    -- L1A FIFO
    signal l1afifo_din          : std_logic_vector(51 downto 0) := (others => '0');
    signal l1afifo_wr_en        : std_logic := '0';
    signal l1afifo_rd_en        : std_logic := '0';
    signal l1afifo_dout         : std_logic_vector(51 downto 0);
    signal l1afifo_full         : std_logic;
    signal l1afifo_overflow     : std_logic;
    signal l1afifo_empty        : std_logic;
    signal l1afifo_valid        : std_logic;
    signal l1afifo_underflow    : std_logic;
    signal l1afifo_near_full    : std_logic;
    signal l1afifo_data_cnt     : std_logic_vector(12 downto 0);
    signal l1afifo_near_full_cnt: std_logic_vector(15 downto 0);
    
    -- DAQ output FIFO
    signal daqfifo_din          : std_logic_vector(65 downto 0) := (others => '0');
    signal daqfifo_wr_en        : std_logic := '0';
    signal daqfifo_rd_en        : std_logic := '0';
    signal daqfifo_dout         : std_logic_vector(65 downto 0);
    signal daqfifo_full         : std_logic;
    signal daqfifo_empty        : std_logic;
    signal daqfifo_valid        : std_logic;
    signal daqfifo_near_full    : std_logic;
    signal daqfifo_data_cnt     : std_logic_vector(12 downto 0);
    signal daqfifo_near_full_cnt: std_logic_vector(15 downto 0);
            
    -- Timeouts
    signal dav_timer            : unsigned(23 downto 0) := (others => '0'); -- TODO: probably don't need this to be so large.. (need to test)
    signal max_dav_timer        : unsigned(23 downto 0) := (others => '0'); -- TODO: probably don't need this to be so large.. (need to test)
    signal last_dav_timer       : unsigned(23 downto 0) := (others => '0'); -- TODO: probably don't need this to be so large.. (need to test)
    signal dav_timeout          : std_logic_vector(23 downto 0) := x"03d090"; -- 10ms (very large)
    signal dav_timeout_flags    : std_logic_vector(23 downto 0) := (others => '0'); -- inputs which have timed out
    
    ---=== AMC Event Builder signals ===---
    
    -- index of the input currently being processed
    signal e_input_idx                : integer range 0 to 23 := 0;
    
    -- word count of the event being sent
    signal e_word_count               : unsigned(19 downto 0) := (others => '0');

    -- bitmask indicating chambers with data for the event being sent
    signal e_dav_mask                 : std_logic_vector(23 downto 0) := (others => '0');
    -- number of chambers with data for the event being sent
    signal e_dav_count                : integer range 0 to 24;
           
    ---=== Chamber Event Builder signals ===---
    
    signal chamber_infifos      : t_chamber_infifo_rd_array(0 to g_NUM_OF_OHs - 1);
    signal chamber_evtfifos     : t_chamber_evtfifo_rd_array(0 to g_NUM_OF_OHs - 1);
    signal chmb_evtfifos_empty  : std_logic_vector(g_NUM_OF_OHs - 1 downto 0) := (others => '1'); -- you should probably just move this flag out of the t_chamber_evtfifo_rd_array struct 
    signal chmb_evtfifos_rd_en  : std_logic_vector(g_NUM_OF_OHs - 1 downto 0) := (others => '0'); -- you should probably just move this flag out of the t_chamber_evtfifo_rd_array struct 
    signal chmb_infifos_rd_en   : std_logic_vector(g_NUM_OF_OHs - 1 downto 0) := (others => '0'); -- you should probably just move this flag out of the t_chamber_evtfifo_rd_array struct 
    signal chmb_tts_states      : t_std4_array(0 to g_NUM_OF_OHs - 1);
    signal chmb_infifo_underflow: std_logic;
    
    signal err_event_too_big    : std_logic;
    signal err_evtfifo_underflow: std_logic;

    --=== Input processor status and control ===--
    signal input_status_arr     : t_daq_input_status_arr(g_NUM_OF_OHs -1 downto 0);
    signal input_control_arr    : t_daq_input_control_arr(g_NUM_OF_OHs -1 downto 0);

    --=== Rate counters ===--
    signal daq_word_rate        : std_logic_vector(31 downto 0) := (others => '0');
    signal daq_evt_rate         : std_logic_vector(31 downto 0) := (others => '0');

    ------ Register signals begin (this section is generated by <gem_amc_repo_root>/scripts/generate_registers.py -- do not edit)
    signal regs_read_arr        : t_std32_array(REG_DAQ_NUM_REGS - 1 downto 0);
    signal regs_write_arr       : t_std32_array(REG_DAQ_NUM_REGS - 1 downto 0);
    signal regs_addresses       : t_std32_array(REG_DAQ_NUM_REGS - 1 downto 0);
    signal regs_defaults        : t_std32_array(REG_DAQ_NUM_REGS - 1 downto 0) := (others => (others => '0'));
    signal regs_read_pulse_arr  : std_logic_vector(REG_DAQ_NUM_REGS - 1 downto 0);
    signal regs_write_pulse_arr : std_logic_vector(REG_DAQ_NUM_REGS - 1 downto 0);
    signal regs_read_ready_arr  : std_logic_vector(REG_DAQ_NUM_REGS - 1 downto 0) := (others => '1');
    signal regs_write_done_arr  : std_logic_vector(REG_DAQ_NUM_REGS - 1 downto 0) := (others => '1');
    signal regs_writable_arr    : std_logic_vector(REG_DAQ_NUM_REGS - 1 downto 0) := (others => '0');
    ------ Register signals end ----------------------------------------------

    
    -- Debug flags for ChipScope
--    attribute MARK_DEBUG : string;
--    attribute MARK_DEBUG of reset_daq           : signal is "TRUE";
--    attribute MARK_DEBUG of daq_clk_i           : signal is "TRUE";
--
--    attribute MARK_DEBUG of dav_timer           : signal is "TRUE";
--    attribute MARK_DEBUG of max_dav_timer       : signal is "TRUE";
--    attribute MARK_DEBUG of last_dav_timer      : signal is "TRUE";
--    attribute MARK_DEBUG of dav_timeout         : signal is "TRUE";
--    attribute MARK_DEBUG of dav_timeout_flags   : signal is "TRUE";
--
--    attribute MARK_DEBUG of daq_state           : signal is "TRUE";
--    attribute MARK_DEBUG of daq_curr_vfat_block : signal is "TRUE";
--    attribute MARK_DEBUG of daq_curr_block_word : signal is "TRUE";
--
--    attribute MARK_DEBUG of daq_event_data      : signal is "TRUE";
--    attribute MARK_DEBUG of daq_event_write_en  : signal is "TRUE";
--    attribute MARK_DEBUG of daq_event_header    : signal is "TRUE";
--    attribute MARK_DEBUG of daq_event_trailer   : signal is "TRUE";
--    attribute MARK_DEBUG of daq_ready           : signal is "TRUE";
--    attribute MARK_DEBUG of daq_almost_full     : signal is "TRUE";
--    
--    attribute MARK_DEBUG of input_mask          : signal is "TRUE";
--    attribute MARK_DEBUG of e_input_idx         : signal is "TRUE";
--    attribute MARK_DEBUG of e_word_count        : signal is "TRUE";
--    attribute MARK_DEBUG of e_dav_mask          : signal is "TRUE";
--    attribute MARK_DEBUG of e_dav_count         : signal is "TRUE";
--    
--    attribute MARK_DEBUG of l1afifo_dout        : signal is "TRUE";
--    attribute MARK_DEBUG of l1afifo_rd_en       : signal is "TRUE";
--    attribute MARK_DEBUG of l1afifo_empty       : signal is "TRUE";
--    
--    attribute MARK_DEBUG of chmb_evtfifos_empty : signal is "TRUE";
--    attribute MARK_DEBUG of chmb_evtfifos_rd_en : signal is "TRUE";
--    attribute MARK_DEBUG of chmb_infifos_rd_en  : signal is "TRUE";
    
begin

    -- TODO DAQ main tasks:
    --   * Handle OOS
    --   * Implement buffer status in the AMC header
    --   * Check for VFAT and OH BX vs L1A bx mismatches
    --   * Resync handling

    --================================--
    -- DAQLink interface
    --================================--
    
    daq_to_daqlink_o.reset <= '0'; -- will need to investigate this later
    daq_to_daqlink_o.resync <= resync_done_delayed;
    daq_to_daqlink_o.trig <= x"00";
    daq_to_daqlink_o.ttc_clk <= ttc_clks_i.clk_40;
    daq_to_daqlink_o.ttc_bc0 <= ttc_cmds_i.bc0;
    daq_to_daqlink_o.tts_clk <= ttc_clks_i.clk_40;
    daq_to_daqlink_o.tts_state <= tts_state;
    daq_to_daqlink_o.event_clk <= daq_clk_i; -- TODO: check if the TTS state is transfered to the TTC clock domain correctly, if not, maybe use a different clock
    daq_to_daqlink_o.event_data <= daqfifo_dout(63 downto 0);
    daq_to_daqlink_o.event_header <= daqfifo_dout(65);
    daq_to_daqlink_o.event_trailer <= daqfifo_dout(64);
    daq_to_daqlink_o.event_valid <= daqfifo_valid;

    daq_ready <= daqlink_to_daq_i.ready;
    daq_almost_full <= daqlink_to_daq_i.almost_full;
    daq_disper_err_cnt <= daqlink_to_daq_i.disperr_cnt;
    daq_notintable_err_cnt <= daqlink_to_daq_i.notintable_cnt;
    
    i_resync_frontend : entity work.oneshot
        port map(
            reset_i   => reset_pwrup or reset_global or reset_local,
            clk_i     => ttc_clks_i.clk_40,
            input_i   => resync_done_delayed,
            oneshot_o => resync_frontend_o
        );
    
    i_resync_delay : entity work.synchronizer
        generic map(
            N_STAGES => 4
        )
        port map(
            async_i => resync_done,
            clk_i   => ttc_clks_i.clk_40,
            sync_o  => resync_done_delayed
        );
    
    --================================--
    -- Resets
    --================================--

    i_reset_sync : entity work.synchronizer
        generic map(
            N_STAGES => 3
        )
        port map(
            async_i => reset_i,
            clk_i   => ttc_clks_i.clk_40,
            sync_o  => reset_global
        );
    
    reset_daq_async <= reset_pwrup or reset_global or reset_local or resync_done_delayed;
    reset_daqlink <= reset_pwrup or reset_global or reset_daqlink_ipb;
    
    -- Reset after powerup
    
    process(ttc_clks_i.clk_40)
        variable countdown : integer := 40_000_000; -- probably way too long, but ok for now (this is only used after powerup)
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (countdown > 0) then
              reset_pwrup <= '1';
              countdown := countdown - 1;
            else
              reset_pwrup <= '0';
            end if;
        end if;
    end process;

    i_rst_delay : entity work.synchronizer
        generic map(
            N_STAGES => 4
        )
        port map(
            async_i => reset_daq_async,
            clk_i   => ttc_clks_i.clk_40,
            sync_o  => reset_daq_async_dly
        );

    i_rst_extend : entity work.pulse_extend
        generic map(
            DELAY_CNT_LENGTH => 3
        )
        port map(
            clk_i          => ttc_clks_i.clk_40,
            rst_i          => '0',
            pulse_length_i => "111",
            pulse_i        => reset_daq_async_dly,
            pulse_o        => reset_daq
        );

    --================================--
    -- DAQ output FIFO
    --================================--
    
    i_daq_fifo : component daq_output_fifo
    port map(
        clk           => daq_clk_i,
        rst           => reset_daq,
        din           => daqfifo_din,
        wr_en         => daqfifo_wr_en,
        rd_en         => daqfifo_rd_en,
        dout          => daqfifo_dout,
        full          => daqfifo_full,
        empty         => daqfifo_empty,
        valid         => daqfifo_valid,
        prog_full     => daqfifo_near_full,
        data_count    => daqfifo_data_cnt
    );

    daqfifo_din <= daq_event_header & daq_event_trailer & daq_event_data;
    daqfifo_wr_en <= daq_event_write_en;
    
    -- daq fifo read logic
    process(daq_clk_i)
    begin
        if (rising_edge(daq_clk_i)) then
            if (reset_daq = '1') then
                err_daqfifo_full <= '0';
            else
                daqfifo_rd_en <= (not daq_almost_full) and (not daqfifo_empty) and daq_ready;
                if (daqfifo_full = '1') then
                    err_daqfifo_full <= '1';
                end if; 
            end if;
        end if;
    end process;

    -- Near-full counter
    i_daqfifo_near_full_counter : entity work.counter
    generic map(
        g_COUNTER_WIDTH  => 16,
        g_ALLOW_ROLLOVER => FALSE
    )
    port map(
        ref_clk_i => daq_clk_i,
        reset_i   => reset_daq,
        en_i      => daqfifo_near_full,
        count_o   => daqfifo_near_full_cnt
    );

    -- DAQLink almost-full counter
    i_daqlink_afull_counter : entity work.counter
    generic map(
        g_COUNTER_WIDTH  => 16,
        g_ALLOW_ROLLOVER => FALSE
    )
    port map(
        ref_clk_i => daq_clk_i,
        reset_i   => reset_daq,
        en_i      => daq_almost_full,
        count_o   => daqlink_afull_cnt
    );

    -- DAQ word rate
    i_daq_word_rate_counter : entity work.rate_counter
    generic map(
        g_CLK_FREQUENCY => std_logic_vector(to_unsigned(g_DAQ_CLK_FREQ, 32)),
        g_COUNTER_WIDTH => 32
    )
    port map(
        clk_i   => daq_clk_i,
        reset_i => reset_daq,
        en_i    => daqfifo_wr_en,
        rate_o  => daq_word_rate
    );

    --================================--
    -- L1A FIFO
    --================================--
    
    i_l1a_fifo : component daq_l1a_fifo
    port map (
        rst           => reset_daq,
        wr_clk        => ttc_clks_i.clk_40,
        rd_clk        => daq_clk_i,
        din           => l1afifo_din,
        wr_en         => l1afifo_wr_en,
        wr_ack        => open,
        rd_en         => l1afifo_rd_en,
        dout          => l1afifo_dout,
        full          => l1afifo_full,
        overflow      => l1afifo_overflow,
        almost_full   => open,
        empty         => l1afifo_empty,
        valid         => l1afifo_valid,
        underflow     => l1afifo_underflow,
        prog_full     => l1afifo_near_full,
        rd_data_count => l1afifo_data_cnt
    );
    
    -- fill the L1A FIFO
    process(ttc_clks_i.clk_40)
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (reset_daq = '1') then
                err_l1afifo_full <= '0';
                l1afifo_wr_en <= '0';
            else
                if (ttc_cmds_i.l1a = '1') then
                    if (l1afifo_full = '0') then
                        l1afifo_din <= ttc_daq_cntrs_i.l1id & ttc_daq_cntrs_i.orbit & ttc_daq_cntrs_i.bx;
                        l1afifo_wr_en <= '1';
                    else
                        err_l1afifo_full <= '1';
                        l1afifo_wr_en <= '0';
                    end if;
                else
                    l1afifo_wr_en <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Near-full counter    
    i_l1afifo_near_full_counter : entity work.counter
    generic map(
        g_COUNTER_WIDTH  => 16,
        g_ALLOW_ROLLOVER => FALSE
    )
    port map(
        ref_clk_i => ttc_clks_i.clk_40,
        reset_i   => reset_daq,
        en_i      => l1afifo_near_full,
        count_o   => l1afifo_near_full_cnt
    );
    
    --================================--
    -- Chamber Event Builders
    --================================--

    g_chamber_evt_builders : for I in 0 to (g_NUM_OF_OHs - 1) generate
    begin

        i_track_input_processor : entity work.track_input_processor
        port map
        (
            -- Reset
            reset_i                     => reset_daq,

            -- Config
            input_enable_i              => input_mask(I),

            -- FIFOs
            fifo_rd_clk_i               => daq_clk_i,
            infifo_dout_o               => chamber_infifos(I).dout,
            infifo_rd_en_i              => chamber_infifos(I).rd_en,
            infifo_empty_o              => chamber_infifos(I).empty,
            infifo_valid_o              => chamber_infifos(I).valid,
            infifo_underflow_o          => chamber_infifos(I).underflow,
            infifo_data_cnt_o           => chamber_infifos(I).data_cnt,
            evtfifo_dout_o              => chamber_evtfifos(I).dout,
            evtfifo_rd_en_i             => chamber_evtfifos(I).rd_en,
            evtfifo_empty_o             => chamber_evtfifos(I).empty,
            evtfifo_valid_o             => chamber_evtfifos(I).valid,
            evtfifo_underflow_o         => chamber_evtfifos(I).underflow,
            evtfifo_data_cnt_o          => chamber_evtfifos(I).data_cnt,

            -- Track data
            tk_data_link_i              => tk_data_links_i(I),
            
            -- Status and control
            status_o                    => input_status_arr(I),
            control_i                   => input_control_arr(I)
        );
    
        input_control_arr(I).eb_zero_supression_en <= zero_suppression_en;
        chmb_evtfifos_empty(I) <= chamber_evtfifos(I).empty;
        chamber_evtfifos(I).rd_en <= chmb_evtfifos_rd_en(I);
        chamber_infifos(I).rd_en <= chmb_infifos_rd_en(I);
        chmb_tts_states(I) <= input_status_arr(I).tts_state;
        
    end generate;
        
    --================================--
    -- TTS
    --================================--

    process (tk_data_links_i(0).clk)
    begin
        if (rising_edge(tk_data_links_i(0).clk)) then
            if (reset_daq = '1') then
                tts_chmb_critical <= '0';
                tts_chmb_out_of_sync <= '0';
                tts_chmb_warning <= '0';
                tts_start_cntdwn_chmb <= x"ff";
            else
                if (tts_start_cntdwn_chmb /= x"00") then
                    for I in 0 to (g_NUM_OF_OHs - 1) loop
                        tts_chmb_critical <= tts_chmb_critical or (chmb_tts_states(I)(2) and input_mask(I));
                        tts_chmb_out_of_sync <= tts_chmb_out_of_sync or (chmb_tts_states(I)(1) and input_mask(I));
                        tts_chmb_warning <= tts_chmb_warning or (chmb_tts_states(I)(0) and input_mask(I));
                    end loop;                
                else
                    tts_start_cntdwn_chmb <= tts_start_cntdwn_chmb - 1;
                end if;
            end if;
        end if;
    end process;

    i_tts_sync_chmb_error   : entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => tts_chmb_critical,    clk_i => ttc_clks_i.clk_40, sync_o  => tts_chmb_critical_tts_clk);
    i_tts_sync_chmb_warn    : entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => tts_chmb_warning,     clk_i => ttc_clks_i.clk_40, sync_o  => tts_chmb_warning_tts_clk);
    i_tts_sync_chmb_oos     : entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => tts_chmb_out_of_sync, clk_i => ttc_clks_i.clk_40, sync_o  => tts_chmb_out_of_sync_tts_clk);
    i_tts_sync_daqfifo_full : entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => err_daqfifo_full,     clk_i => ttc_clks_i.clk_40, sync_o  => err_daqfifo_full_tts_clk);

    process (ttc_clks_i.clk_40)
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (reset_daq = '1') then
                tts_critical_error <= '0';
                tts_out_of_sync <= '0';
                tts_warning <= '0';
                tts_busy <= '1';
                tts_start_cntdwn <= x"ff";
            else
                if (tts_start_cntdwn /= x"00") then
                    tts_busy <= '0';
                    tts_critical_error <= err_l1afifo_full or tts_chmb_critical_tts_clk or err_daqfifo_full_tts_clk;
                    tts_out_of_sync <= tts_chmb_out_of_sync_tts_clk;
                    tts_warning <= l1afifo_near_full or tts_chmb_warning_tts_clk;
                else
                    tts_start_cntdwn <= tts_start_cntdwn - 1;
                end if;
            end if;
        end if;
    end process;

    tts_state <= tts_override when (tts_override /= x"0") else
                 x"8" when (daq_enable = '0') else
                 x"4" when (tts_busy = '1' or resync_mode = '1') else
                 x"c" when (tts_critical_error = '1') else
                 x"2" when (tts_out_of_sync = '1') else
                 x"1" when (tts_warning = '1') else
                 x"8"; 
        
    -- warning counter
    i_tts_warning_counter : entity work.counter
    generic map(
        g_COUNTER_WIDTH  => 16,
        g_ALLOW_ROLLOVER => FALSE
    )
    port map(
        ref_clk_i => ttc_clks_i.clk_40,
        reset_i   => reset_daq,
        en_i      => tts_warning,
        count_o   => tts_warning_cnt
    );

    -- resync handling
    process(ttc_clks_i.clk_40)
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (reset_daq = '1') then
                resync_mode <= '0';
                resync_done <= '0';
            else
                if (ttc_cmds_i.resync = '1') then
                    resync_mode <= '1';
                end if;
                
                -- wait for all L1As to be processed and output buffer drained and then reset everything (resync_done triggers the reset_daq)
                if (resync_mode = '1' and l1afifo_empty = '1' and daq_state = x"0" and daqfifo_empty = '1') then
                    resync_done <= '1';
                end if;
            end if;
        end if;
    end process;
     
    --================================--
    -- Event shipping to DAQLink
    --================================--
    
    process(daq_clk_i)
    
        -- event info
        variable e_l1a_id                   : std_logic_vector(23 downto 0) := (others => '0');        
        variable e_bx_id                    : std_logic_vector(11 downto 0) := (others => '0');        
        variable e_orbit_id                 : std_logic_vector(15 downto 0) := (others => '0');        

        -- event chamber info; TODO: convert these to signals (but would require additional state)
        variable e_chmb_l1a_id              : std_logic_vector(23 downto 0) := (others => '0');
        variable e_chmb_bx_id               : std_logic_vector(11 downto 0) := (others => '0');
        variable e_chmb_payload_size        : unsigned(19 downto 0) := (others => '0');
        variable e_chmb_evtfifo_afull       : std_logic := '0';
        variable e_chmb_evtfifo_full        : std_logic := '0';
        variable e_chmb_infifo_full         : std_logic := '0';
        variable e_chmb_evtfifo_near_full   : std_logic := '0';
        variable e_chmb_infifo_near_full    : std_logic := '0';
        variable e_chmb_infifo_underflow    : std_logic := '0';
        variable e_chmb_invalid_vfat_block  : std_logic := '0';
        variable e_chmb_evt_too_big         : std_logic := '0';
        variable e_chmb_evt_bigger_24       : std_logic := '0';
        variable e_chmb_mixed_oh_bc         : std_logic := '0';
        variable e_chmb_mixed_vfat_bc       : std_logic := '0';
        variable e_chmb_mixed_vfat_ec       : std_logic := '0';
              
    begin
    
        if (rising_edge(daq_clk_i)) then
        
            if (reset_daq = '1') then
                daq_state <= x"0";
                daq_event_data <= (others => '0');
                daq_event_header <= '0';
                daq_event_trailer <= '0';
                daq_event_write_en <= '0';
                chmb_evtfifos_rd_en <= (others => '0');
                l1afifo_rd_en <= '0';
                daq_curr_vfat_block <= (others => '0');
                chmb_infifos_rd_en <= (others => '0');
                daq_curr_block_word <= 0;
                cnt_sent_events <= (others => '0');
                e_word_count <= (others => '0');
                dav_timer <= (others => '0');
                max_dav_timer <= (others => '0');
                last_dav_timer <= (others => '0');
                dav_timeout_flags <= (others => '0');
                chmb_infifo_underflow <= '0';
            else
            
                -- state machine for sending data
                -- state 0: idle
                -- state 1: send the first AMC header
                -- state 2: send the second AMC header
                -- state 3: send the GEM Event header
                -- state 4: send the GEM Chamber header
                -- state 5: send the payload
                -- state 6: send the GEM Chamber trailer
                -- state 7: send the GEM Event trailer
                -- state 8: send the AMC trailer
                if (daq_state = x"0") then
                
                    -- zero out everything, especially the write enable :)
                    daq_event_data <= (others => '0');
                    daq_event_header <= '0';
                    daq_event_trailer <= '0';
                    daq_event_write_en <= '0';
                    e_word_count <= (others => '0');
                    e_input_idx <= 0;
                    
                    
                    -- have an L1A and data from all enabled inputs is ready (or these inputs have timed out)
                    if (l1afifo_empty = '0' and ((input_mask(g_NUM_OF_OHs - 1 downto 0) and ((not chmb_evtfifos_empty) or dav_timeout_flags(g_NUM_OF_OHs - 1 downto 0))) = input_mask(g_NUM_OF_OHs - 1 downto 0))) then
                        if (daq_ready = '1' and daqfifo_near_full = '0' and daq_enable = '1') then -- everybody ready?.... GO! :)
                            -- start the DAQ state machine
                            daq_state <= x"1";
                            
                            -- fetch the data from the L1A FIFO
                            l1afifo_rd_en <= '1';
                            
                            -- set the DAV mask
                            e_dav_mask(g_NUM_OF_OHs - 1 downto 0) <= input_mask(g_NUM_OF_OHs - 1 downto 0) and ((not chmb_evtfifos_empty) and (not dav_timeout_flags(g_NUM_OF_OHs - 1 downto 0)));
                            
                            -- save timer stats
                            dav_timer <= (others => '0');
                            last_dav_timer <= dav_timer;
                            if ((dav_timer > max_dav_timer) and (or_reduce(dav_timeout_flags) = '0')) then
                                max_dav_timer <= dav_timer;
                            end if;
                        end if;
                    -- have an L1A, but waiting for data -- start counting the time
                    elsif (l1afifo_empty = '0') then
                        dav_timer <= dav_timer + 1;
                    end if;
                    
                    -- set the timeout flags if the timer has reached the dav_timeout value
                    if (dav_timer >= unsigned(dav_timeout)) then
                        dav_timeout_flags(g_NUM_OF_OHs - 1 downto 0) <= chmb_evtfifos_empty and input_mask(g_NUM_OF_OHs - 1 downto 0);
                    end if;
                                        
                else -- lets send some data!
                
                    l1afifo_rd_en <= '0';
                    
                    ----==== send the first AMC header ====----
                    if (daq_state = x"1") then
                        
                        -- wait for the valid flag from the L1A FIFO and then populate the variables and AMC header
                        if (l1afifo_valid = '1') then
                        
                            -- fetch the L1A data
                            e_l1a_id        := l1afifo_dout(51 downto 28);
                            e_orbit_id      := l1afifo_dout(27 downto 12);
                            e_bx_id         := l1afifo_dout(11 downto 0);

                            -- send the data
                            daq_event_data <= x"00" & 
                                              e_l1a_id &   -- L1A ID
                                              e_bx_id &   -- BX ID
                                              x"fffff";
                            daq_event_header <= '1';
                            daq_event_trailer <= '0';
                            daq_event_write_en <= '1';
                            
                            -- move to the next state
                            e_word_count <= e_word_count + 1;
                            daq_state <= x"2";
                            
                        end if;
                        
                    ----==== send the second AMC header ====----
                    elsif (daq_state = x"2") then
                    
                        -- calculate the DAV count (I know it's ugly...)
                        e_dav_count <= to_integer(unsigned(e_dav_mask(0 downto 0))) + to_integer(unsigned(e_dav_mask(1 downto 1))) + to_integer(unsigned(e_dav_mask(2 downto 2))) + to_integer(unsigned(e_dav_mask(3 downto 3))) + to_integer(unsigned(e_dav_mask(4 downto 4))) + to_integer(unsigned(e_dav_mask(5 downto 5))) + to_integer(unsigned(e_dav_mask(6 downto 6))) + to_integer(unsigned(e_dav_mask(7 downto 7))) + to_integer(unsigned(e_dav_mask(8 downto 8))) + to_integer(unsigned(e_dav_mask(9 downto 9))) + to_integer(unsigned(e_dav_mask(10 downto 10))) + to_integer(unsigned(e_dav_mask(11 downto 11))) + to_integer(unsigned(e_dav_mask(12 downto 12))) + to_integer(unsigned(e_dav_mask(13 downto 13))) + to_integer(unsigned(e_dav_mask(14 downto 14))) + to_integer(unsigned(e_dav_mask(15 downto 15))) + to_integer(unsigned(e_dav_mask(16 downto 16))) + to_integer(unsigned(e_dav_mask(17 downto 17))) + to_integer(unsigned(e_dav_mask(18 downto 18))) + to_integer(unsigned(e_dav_mask(19 downto 19))) + to_integer(unsigned(e_dav_mask(20 downto 20))) + to_integer(unsigned(e_dav_mask(21 downto 21))) + to_integer(unsigned(e_dav_mask(22 downto 22))) + to_integer(unsigned(e_dav_mask(23 downto 23)));
                        
                        -- send the data
                        daq_event_data <= C_DAQ_FORMAT_VERSION &
                                          run_type &
                                          run_params &
                                          e_orbit_id & 
                                          board_sn_i;
                        daq_event_header <= '0';
                        daq_event_trailer <= '0';
                        daq_event_write_en <= '1';
                        
                        -- move to the next state
                        e_word_count <= e_word_count + 1;
                        daq_state <= x"3";
                    
                    ----==== send the GEM Event header ====----
                    elsif (daq_state = x"3") then
                        
                        -- if this input doesn't have data and we're not at the last input yet, then go to the next input
                        if ((e_input_idx < g_NUM_OF_OHs - 1) and (e_dav_mask(e_input_idx) = '0')) then 
                        
                            daq_event_write_en <= '0';
                            e_input_idx <= e_input_idx + 1;
                            
                        else

                            -- send the data
                            daq_event_data <= e_dav_mask & -- DAV mask
                                              -- buffer status (set if we've ever had a buffer overflow)
                                              x"000000" & -- TODO: implement buffer status flag
                                              --(err_event_too_big or e_chmb_evtfifo_full or e_chmb_infifo_underflow or e_chmb_infifo_full) &
                                              std_logic_vector(to_unsigned(e_dav_count, 5)) &   -- DAV count
                                              -- GLIB status
                                              "0000000" & -- Not used yet
                                              tts_state;
                            daq_event_header <= '0';
                            daq_event_trailer <= '0';
                            daq_event_write_en <= '1';
                            e_word_count <= e_word_count + 1;
                            
                            -- if we have data then read the event fifo and send the chamber data
                            if (e_dav_mask(e_input_idx) = '1') then
                            
                                -- read the first chamber event fifo
                                chmb_evtfifos_rd_en(e_input_idx) <= '1';

                                -- move to the next state
                                daq_state <= x"4";
                            
                            -- no data on this input - skip to event trailer                            
                            else
                            
                                daq_state <= x"7";
                                
                            end if;
                        
                        end if;
                    
                    ----==== send the GEM Chamber header ====----
                    elsif (daq_state = x"4") then
                    
                        -- reset the read enable
                        chmb_evtfifos_rd_en(e_input_idx) <= '0';
                        
                        -- wait for the valid flag and then fetch the chamber event data
                        if (chamber_evtfifos(e_input_idx).valid = '1') then
                        
                            e_chmb_l1a_id                       := chamber_evtfifos(e_input_idx).dout(59 downto 36);
                            e_chmb_bx_id                        := chamber_evtfifos(e_input_idx).dout(35 downto 24);
                            e_chmb_payload_size(11 downto 0)    := unsigned(chamber_evtfifos(e_input_idx).dout(23 downto 12));
                            e_chmb_evtfifo_afull                := chamber_evtfifos(e_input_idx).dout(11);
                            e_chmb_evtfifo_full                 := chamber_evtfifos(e_input_idx).dout(10);
                            e_chmb_infifo_full                  := chamber_evtfifos(e_input_idx).dout(9);
                            e_chmb_evtfifo_near_full            := chamber_evtfifos(e_input_idx).dout(8);
                            e_chmb_infifo_near_full             := chamber_evtfifos(e_input_idx).dout(7);
                            e_chmb_infifo_underflow             := chamber_evtfifos(e_input_idx).dout(6);
                            e_chmb_evt_too_big                  := chamber_evtfifos(e_input_idx).dout(5);
                            e_chmb_invalid_vfat_block           := chamber_evtfifos(e_input_idx).dout(4);
                            e_chmb_evt_bigger_24                := chamber_evtfifos(e_input_idx).dout(3);
                            e_chmb_mixed_oh_bc                  := chamber_evtfifos(e_input_idx).dout(2);
                            e_chmb_mixed_vfat_bc                := chamber_evtfifos(e_input_idx).dout(1);
                            e_chmb_mixed_vfat_ec                := chamber_evtfifos(e_input_idx).dout(0);
                            
                            -- send the data
                            daq_event_data <= x"000000" & -- Zero suppression flags
                                              std_logic_vector(to_unsigned(e_input_idx, 5)) &    -- Input ID
                                              -- OH word count
                                              std_logic_vector(e_chmb_payload_size(11 downto 0)) &
                                              -- input status
                                              e_chmb_evtfifo_full &
                                              e_chmb_infifo_full &
                                              err_l1afifo_full &
                                              e_chmb_evt_too_big &
                                              e_chmb_evtfifo_near_full &
                                              e_chmb_infifo_near_full &
                                              l1afifo_near_full &
                                              e_chmb_evt_bigger_24 &
                                              e_chmb_invalid_vfat_block &
                                              "0" & -- OOS GLIB-VFAT
                                              "0" & -- OOS GLIB-OH
                                              "0" & -- GLIB-VFAT BX mismatch
                                              "0" & -- GLIB-OH BX mismatch
                                              x"00" & "00"; -- Not used

                            daq_event_header <= '0';
                            daq_event_trailer <= '0';
                            daq_event_write_en <= '1';
                            
                            chmb_infifo_underflow <= '0';
                            e_word_count <= e_word_count + 1;
                            
                            -- if we do have any VFAT data in this event then go on to send that, otherwise just jump to the chamber trailer
                            if (unsigned(chamber_evtfifos(e_input_idx).dout(23 downto 12)) /= x"000") then
                                daq_curr_vfat_block <= unsigned(chamber_evtfifos(e_input_idx).dout(23 downto 12)) - 3;

                                -- read a block from the input fifo
                                chmb_infifos_rd_en(e_input_idx) <= '1';
                                daq_curr_block_word <= 2;
                                
                                daq_state <= x"5";                                
                            else
                                daq_state <= x"6";
                            end if;
                            
                        
                        else
                        
                            daq_event_write_en <= '0';
                            
                        end if; 

                    ----==== send the payload ====----
                    elsif (daq_state = x"5") then
                    
                        -- read the next vfat block from the infifo if we're already working with the last word, but it's not yet the last block
                        if ((daq_curr_block_word = 0) and (daq_curr_vfat_block /= x"000")) then
                            chmb_infifos_rd_en(e_input_idx) <= '1';
                            daq_curr_block_word <= 2;
                            daq_curr_vfat_block <= daq_curr_vfat_block - 3; -- this looks strange, but it's because this is not actually vfat_block but number of 64bit words of vfat data
                        -- we are done sending everything -- move on to the next state
                        elsif ((daq_curr_block_word = 0) and (daq_curr_vfat_block = x"0")) then
                            chmb_infifos_rd_en(e_input_idx) <= '0';
                            daq_state <= x"6";
                        -- we've just asserted chmb_infifos_rd_en(e_input_idx), if the valid is still 0, then just wait (make sure chmb_infifos_rd_en(e_input_idx) is 0)
                        elsif ((daq_curr_block_word = 2) and (chamber_infifos(e_input_idx).valid = '0') and (chamber_infifos(e_input_idx).underflow = '0')) then
                            chmb_infifos_rd_en(e_input_idx) <= '0';
                        -- lets move to the next vfat word
                        else
                            chmb_infifos_rd_en(e_input_idx) <= '0';
                            daq_curr_block_word <= daq_curr_block_word - 1;
                        end if;
                        
                        -- send the data!
                        if ((daq_curr_block_word < 2) or (chamber_infifos(e_input_idx).valid = '1')) then
                            daq_event_data <= chamber_infifos(e_input_idx).dout((((daq_curr_block_word + 1) * 64) - 1) downto (daq_curr_block_word * 64));
                            daq_event_header <= '0';
                            daq_event_trailer <= '0';
                            daq_event_write_en <= '1';
                            e_word_count <= e_word_count + 1;
                        elsif (chamber_infifos(e_input_idx).underflow = '1') then
                            daq_event_data <= x"ffffffffffff0000"; -- a placeholder for an underflow condition (this should be easily detectable by unpacker since BC is above max, and chip id is ffff)
                            daq_event_header <= '0';
                            daq_event_trailer <= '0';
                            daq_event_write_en <= '1';
                            e_word_count <= e_word_count + 1;
                            chmb_infifo_underflow <= '1';
                        else
                            daq_event_write_en <= '0';
                        end if;

                    ----==== send the GEM Chamber trailer ====----
                    elsif (daq_state = x"6") then
                        
                        -- increment the input index if it hasn't maxed out yet
                        if (e_input_idx < g_NUM_OF_OHs - 1) then
                            e_input_idx <= e_input_idx + 1;
                        end if;
                        
                        -- if we have data for the next input or if we've reached the last input
                        if ((e_input_idx >= g_NUM_OF_OHs - 1) or (e_dav_mask(e_input_idx + 1) = '1')) then
                        
                            -- send the data
                            daq_event_data <= x"0000" & -- OH CRC
                                              std_logic_vector(e_chmb_payload_size(11 downto 0)) & -- OH word count
                                              -- GEM chamber status
                                              err_evtfifo_underflow &
                                              "0" &  -- stuck data
                                              chmb_infifo_underflow & -- this input had an infifo underflow
                                              "0" & x"00000000";
                            daq_event_header <= '0';
                            daq_event_trailer <= '0';
                            daq_event_write_en <= '1';
                            e_word_count <= e_word_count + 1;
                                
                            -- if we have data for the next input then read the infifo and go to chamber data sending
                            if (e_dav_mask(e_input_idx + 1) = '1') then
                                chmb_evtfifos_rd_en(e_input_idx + 1) <= '1';
                                daq_state <= x"4";                            
                            else -- if next input doesn't have data we can only get here if we're at the last input, so move to the event trailer
                                daq_state <= x"7";
                            end if;
                         
                        else
                        
                            daq_event_write_en <= '0';
                            
                        end if;
                        
                    ----==== send the GEM Event trailer ====----
                    elsif (daq_state = x"7") then

                        daq_event_data <= dav_timeout_flags & -- Chamber timeout
                                          -- Event status (hmm)
                                          x"0" & "000" &
                                          "0" & -- GLIB OOS (different L1A IDs for different inputs)
                                          x"000000" &   -- Chamber error flag (hmm)
                                          -- GLIB status
                                          daq_almost_full &
                                          ttc_status_i.clk_status.mmcm_locked & 
                                          daq_clk_locked_i & 
                                          daq_ready &
                                          ttc_status_i.bc0_status.locked &
                                          "000";         -- Reserved
                        daq_event_header <= '0';
                        daq_event_trailer <= '0';
                        daq_event_write_en <= '1';
                        e_word_count <= e_word_count + 1;
                        daq_state <= x"8";
                        
                    ----==== send the AMC trailer ====----
                    elsif (daq_state = x"8") then
                    
                        -- send the AMC trailer data
                        daq_event_data <= x"00000000" & e_l1a_id(7 downto 0) & x"0" & std_logic_vector(e_word_count + 1);
                        daq_event_header <= '0';
                        daq_event_trailer <= '1';
                        daq_event_write_en <= '1';
                        
                        -- go back to DAQ idle state
                        daq_state <= x"0";
                        
                        -- reset things
                        e_word_count <= (others => '0');
                        e_input_idx <= 0;
                        cnt_sent_events <= cnt_sent_events + 1;
                        dav_timeout_flags <= x"000000";
                        
                    -- hmm
                    else
                    
                        daq_state <= x"0";
                        
                    end if;
                    
                end if;

            end if;
        end if;        
    end process;

    ------------------------- DEBUG -----------------------
    gen_debug:
    if g_DEBUG generate
        
        i_daq_ila : ila_daq
            port map(
                clk    => ttc_clks_i.clk_40,
                probe0 => std_logic_vector(daq_state),
                probe1 => tts_state,
                probe2 => ttc_cmds_i.resync,
                probe3 => resync_mode,
                probe4 => resync_done_delayed,
                probe5 => reset_daq_async,
                probe6 => reset_daq,
                probe7 => l1afifo_empty,
                probe8 => daq_almost_full,
                probe9 => daq_ready
            );
        
    end generate;
    -------------------------------------------------------

    --===============================================================================================
    -- this section is generated by <gem_amc_repo_root>/scripts/generate_registers.py (do not edit) 
    --==== Registers begin ==========================================================================

    -- IPbus slave instanciation
    ipbus_slave_inst : entity work.ipbus_slave
        generic map(
           g_NUM_REGS             => REG_DAQ_NUM_REGS,
           g_ADDR_HIGH_BIT        => REG_DAQ_ADDRESS_MSB,
           g_ADDR_LOW_BIT         => REG_DAQ_ADDRESS_LSB,
           g_USE_INDIVIDUAL_ADDRS => true
       )
       port map(
           ipb_reset_i            => ipb_reset_i,
           ipb_clk_i              => ipb_clk_i,
           ipb_mosi_i             => ipb_mosi_i,
           ipb_miso_o             => ipb_miso_o,
           usr_clk_i              => ipb_clk_i,
           regs_read_arr_i        => regs_read_arr,
           regs_write_arr_o       => regs_write_arr,
           read_pulse_arr_o       => regs_read_pulse_arr,
           write_pulse_arr_o      => regs_write_pulse_arr,
           regs_read_ready_arr_i  => regs_read_ready_arr,
           regs_write_done_arr_i  => regs_write_done_arr,
           individual_addrs_arr_i => regs_addresses,
           regs_defaults_arr_i    => regs_defaults,
           writable_regs_i        => regs_writable_arr
      );

    -- Addresses
    regs_addresses(0)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"00";
    regs_addresses(1)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"01";
    regs_addresses(2)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"02";
    regs_addresses(3)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"03";
    regs_addresses(4)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"04";
    regs_addresses(5)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"05";
    regs_addresses(6)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"06";
    regs_addresses(7)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"07";
    regs_addresses(8)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"08";
    regs_addresses(9)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"09";
    regs_addresses(10)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"0a";
    regs_addresses(11)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"0b";
    regs_addresses(12)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"0c";
    regs_addresses(13)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"0f";
    regs_addresses(14)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"10";
    regs_addresses(15)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"11";
    regs_addresses(16)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"12";
    regs_addresses(17)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"13";
    regs_addresses(18)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"14";
    regs_addresses(19)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"15";
    regs_addresses(20)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"16";
    regs_addresses(21)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"17";
    regs_addresses(22)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"18";
    regs_addresses(23)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"19";
    regs_addresses(24)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1a";
    regs_addresses(25)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1b";
    regs_addresses(26)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1c";
    regs_addresses(27)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1d";
    regs_addresses(28)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1e";
    regs_addresses(29)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"1f";
    regs_addresses(30)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"20";
    regs_addresses(31)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"21";
    regs_addresses(32)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"22";
    regs_addresses(33)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"23";
    regs_addresses(34)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"24";
    regs_addresses(35)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"25";
    regs_addresses(36)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"26";
    regs_addresses(37)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"27";
    regs_addresses(38)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"28";
    regs_addresses(39)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"29";
    regs_addresses(40)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2a";
    regs_addresses(41)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2b";
    regs_addresses(42)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2c";
    regs_addresses(43)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2d";
    regs_addresses(44)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2e";
    regs_addresses(45)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"2f";
    regs_addresses(46)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"30";
    regs_addresses(47)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"31";
    regs_addresses(48)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"32";
    regs_addresses(49)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"33";
    regs_addresses(50)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"34";
    regs_addresses(51)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"35";
    regs_addresses(52)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"36";
    regs_addresses(53)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"37";
    regs_addresses(54)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"38";
    regs_addresses(55)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"39";
    regs_addresses(56)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3a";
    regs_addresses(57)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3b";
    regs_addresses(58)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3c";
    regs_addresses(59)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3d";
    regs_addresses(60)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3e";
    regs_addresses(61)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"3f";
    regs_addresses(62)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"40";
    regs_addresses(63)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"41";
    regs_addresses(64)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"42";
    regs_addresses(65)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"43";
    regs_addresses(66)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"44";
    regs_addresses(67)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"45";
    regs_addresses(68)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"46";
    regs_addresses(69)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"47";
    regs_addresses(70)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"48";
    regs_addresses(71)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"49";
    regs_addresses(72)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4a";
    regs_addresses(73)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4b";
    regs_addresses(74)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4c";
    regs_addresses(75)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4d";
    regs_addresses(76)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4e";
    regs_addresses(77)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"4f";
    regs_addresses(78)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"50";
    regs_addresses(79)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"51";
    regs_addresses(80)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"52";
    regs_addresses(81)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"53";
    regs_addresses(82)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"54";
    regs_addresses(83)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"55";
    regs_addresses(84)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"56";
    regs_addresses(85)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"57";
    regs_addresses(86)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"58";
    regs_addresses(87)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"59";
    regs_addresses(88)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"5a";
    regs_addresses(89)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"5b";
    regs_addresses(90)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"5c";
    regs_addresses(91)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"5d";
    regs_addresses(92)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"5e";
    regs_addresses(93)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"5f";
    regs_addresses(94)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"60";
    regs_addresses(95)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"61";
    regs_addresses(96)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"62";
    regs_addresses(97)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"63";
    regs_addresses(98)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"64";
    regs_addresses(99)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"65";
    regs_addresses(100)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"66";
    regs_addresses(101)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"67";
    regs_addresses(102)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"68";
    regs_addresses(103)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"69";
    regs_addresses(104)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"6a";
    regs_addresses(105)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"6b";
    regs_addresses(106)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"6c";
    regs_addresses(107)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"6d";
    regs_addresses(108)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"6e";
    regs_addresses(109)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"6f";
    regs_addresses(110)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"70";
    regs_addresses(111)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"71";
    regs_addresses(112)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"72";
    regs_addresses(113)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"73";
    regs_addresses(114)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"74";
    regs_addresses(115)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"75";
    regs_addresses(116)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"76";
    regs_addresses(117)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"77";
    regs_addresses(118)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"78";
    regs_addresses(119)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"79";
    regs_addresses(120)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"7a";
    regs_addresses(121)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"7b";
    regs_addresses(122)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"7c";
    regs_addresses(123)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"7d";
    regs_addresses(124)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"7e";
    regs_addresses(125)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"7f";
    regs_addresses(126)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"80";
    regs_addresses(127)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"81";
    regs_addresses(128)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"82";
    regs_addresses(129)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"83";
    regs_addresses(130)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"84";
    regs_addresses(131)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"85";
    regs_addresses(132)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"86";
    regs_addresses(133)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"87";
    regs_addresses(134)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"88";
    regs_addresses(135)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"89";
    regs_addresses(136)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"8a";
    regs_addresses(137)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"8b";
    regs_addresses(138)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"8c";
    regs_addresses(139)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"8d";
    regs_addresses(140)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"8e";
    regs_addresses(141)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"8f";
    regs_addresses(142)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"90";
    regs_addresses(143)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"91";
    regs_addresses(144)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"92";
    regs_addresses(145)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"93";
    regs_addresses(146)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"94";
    regs_addresses(147)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"95";
    regs_addresses(148)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"96";
    regs_addresses(149)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"97";
    regs_addresses(150)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"98";
    regs_addresses(151)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"99";
    regs_addresses(152)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"9a";
    regs_addresses(153)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"9b";
    regs_addresses(154)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"9c";
    regs_addresses(155)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"9d";
    regs_addresses(156)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"9e";
    regs_addresses(157)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"9f";
    regs_addresses(158)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"a0";
    regs_addresses(159)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"a1";
    regs_addresses(160)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"a2";
    regs_addresses(161)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"a3";
    regs_addresses(162)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"a4";
    regs_addresses(163)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"a5";
    regs_addresses(164)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"a6";
    regs_addresses(165)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"a7";
    regs_addresses(166)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"a8";
    regs_addresses(167)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"a9";
    regs_addresses(168)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"aa";
    regs_addresses(169)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"ab";
    regs_addresses(170)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"ac";
    regs_addresses(171)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"ad";
    regs_addresses(172)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"ae";
    regs_addresses(173)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"af";
    regs_addresses(174)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"b0";
    regs_addresses(175)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"b1";
    regs_addresses(176)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"b2";
    regs_addresses(177)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"b3";
    regs_addresses(178)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"b4";
    regs_addresses(179)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"b5";
    regs_addresses(180)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"b6";
    regs_addresses(181)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"b7";
    regs_addresses(182)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"b8";
    regs_addresses(183)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"b9";
    regs_addresses(184)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"ba";
    regs_addresses(185)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"bb";
    regs_addresses(186)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"bc";
    regs_addresses(187)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"bd";
    regs_addresses(188)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"be";
    regs_addresses(189)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"bf";
    regs_addresses(190)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"c0";
    regs_addresses(191)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"c1";
    regs_addresses(192)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"c2";
    regs_addresses(193)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"c3";
    regs_addresses(194)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"c4";
    regs_addresses(195)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"c5";
    regs_addresses(196)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"c6";
    regs_addresses(197)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"c7";
    regs_addresses(198)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"c8";
    regs_addresses(199)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"c9";
    regs_addresses(200)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"ca";
    regs_addresses(201)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"cb";
    regs_addresses(202)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"cc";
    regs_addresses(203)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"cd";
    regs_addresses(204)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"ce";
    regs_addresses(205)(REG_DAQ_ADDRESS_MSB downto REG_DAQ_ADDRESS_LSB) <= '0' & x"cf";

    -- Connect read signals
    regs_read_arr(0)(REG_DAQ_CONTROL_DAQ_ENABLE_BIT) <= daq_enable;
    regs_read_arr(0)(REG_DAQ_CONTROL_ZERO_SUPPRESSION_EN_BIT) <= zero_suppression_en;
    regs_read_arr(0)(REG_DAQ_CONTROL_DAQ_LINK_RESET_BIT) <= reset_daqlink_ipb;
    regs_read_arr(0)(REG_DAQ_CONTROL_RESET_BIT) <= reset_local;
    regs_read_arr(0)(REG_DAQ_CONTROL_TTS_OVERRIDE_MSB downto REG_DAQ_CONTROL_TTS_OVERRIDE_LSB) <= tts_override;
    regs_read_arr(0)(REG_DAQ_CONTROL_INPUT_ENABLE_MASK_MSB downto REG_DAQ_CONTROL_INPUT_ENABLE_MASK_LSB) <= input_mask;
    regs_read_arr(1)(REG_DAQ_STATUS_DAQ_LINK_RDY_BIT) <= daq_ready;
    regs_read_arr(1)(REG_DAQ_STATUS_DAQ_CLK_LOCKED_BIT) <= daq_clk_locked_i;
    regs_read_arr(1)(REG_DAQ_STATUS_TTC_RDY_BIT) <= ttc_status_i.clk_status.mmcm_locked;
    regs_read_arr(1)(REG_DAQ_STATUS_DAQ_LINK_AFULL_BIT) <= daq_almost_full;
    regs_read_arr(1)(REG_DAQ_STATUS_DAQ_OUTPUT_FIFO_HAD_OVERFLOW_BIT) <= err_daqfifo_full;
    regs_read_arr(1)(REG_DAQ_STATUS_TTC_BC0_LOCKED_BIT) <= ttc_status_i.bc0_status.locked;
    regs_read_arr(1)(REG_DAQ_STATUS_L1A_FIFO_HAD_OVERFLOW_BIT) <= err_l1afifo_full;
    regs_read_arr(1)(REG_DAQ_STATUS_L1A_FIFO_IS_UNDERFLOW_BIT) <= l1afifo_underflow;
    regs_read_arr(1)(REG_DAQ_STATUS_L1A_FIFO_IS_FULL_BIT) <= l1afifo_full;
    regs_read_arr(1)(REG_DAQ_STATUS_L1A_FIFO_IS_NEAR_FULL_BIT) <= l1afifo_near_full;
    regs_read_arr(1)(REG_DAQ_STATUS_L1A_FIFO_IS_EMPTY_BIT) <= l1afifo_empty;
    regs_read_arr(1)(REG_DAQ_STATUS_TTS_STATE_MSB downto REG_DAQ_STATUS_TTS_STATE_LSB) <= tts_state;
    regs_read_arr(2)(REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_MSB downto REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_LSB) <= daq_notintable_err_cnt;
    regs_read_arr(3)(REG_DAQ_EXT_STATUS_DISPER_ERR_MSB downto REG_DAQ_EXT_STATUS_DISPER_ERR_LSB) <= daq_disper_err_cnt;
    regs_read_arr(4)(REG_DAQ_EXT_STATUS_L1AID_MSB downto REG_DAQ_EXT_STATUS_L1AID_LSB) <= ttc_daq_cntrs_i.l1id;
    regs_read_arr(5)(REG_DAQ_EXT_STATUS_EVT_SENT_MSB downto REG_DAQ_EXT_STATUS_EVT_SENT_LSB) <= std_logic_vector(cnt_sent_events);
    regs_read_arr(6)(REG_DAQ_CONTROL_DAV_TIMEOUT_MSB downto REG_DAQ_CONTROL_DAV_TIMEOUT_LSB) <= dav_timeout;
    regs_read_arr(7)(REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_MSB downto REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_LSB) <= std_logic_vector(max_dav_timer);
    regs_read_arr(8)(REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_MSB downto REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_LSB) <= std_logic_vector(last_dav_timer);
    regs_read_arr(9)(REG_DAQ_EXT_STATUS_L1A_FIFO_DATA_CNT_MSB downto REG_DAQ_EXT_STATUS_L1A_FIFO_DATA_CNT_LSB) <= l1afifo_data_cnt;
    regs_read_arr(9)(REG_DAQ_EXT_STATUS_DAQ_FIFO_DATA_CNT_MSB downto REG_DAQ_EXT_STATUS_DAQ_FIFO_DATA_CNT_LSB) <= daqfifo_data_cnt;
    regs_read_arr(10)(REG_DAQ_EXT_STATUS_L1A_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_EXT_STATUS_L1A_FIFO_NEAR_FULL_CNT_LSB) <= l1afifo_near_full_cnt;
    regs_read_arr(10)(REG_DAQ_EXT_STATUS_DAQ_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_EXT_STATUS_DAQ_FIFO_NEAR_FULL_CNT_LSB) <= daqfifo_near_full_cnt;
    regs_read_arr(11)(REG_DAQ_EXT_STATUS_DAQ_ALMOST_FULL_CNT_MSB downto REG_DAQ_EXT_STATUS_DAQ_ALMOST_FULL_CNT_LSB) <= daqlink_afull_cnt;
    regs_read_arr(11)(REG_DAQ_EXT_STATUS_TTS_WARN_CNT_MSB downto REG_DAQ_EXT_STATUS_TTS_WARN_CNT_LSB) <= tts_warning_cnt;
    regs_read_arr(12)(REG_DAQ_EXT_STATUS_DAQ_WORD_RATE_MSB downto REG_DAQ_EXT_STATUS_DAQ_WORD_RATE_LSB) <= daq_word_rate;
    regs_read_arr(13)(REG_DAQ_EXT_CONTROL_RUN_PARAMS_MSB downto REG_DAQ_EXT_CONTROL_RUN_PARAMS_LSB) <= run_params;
    regs_read_arr(13)(REG_DAQ_EXT_CONTROL_RUN_TYPE_MSB downto REG_DAQ_EXT_CONTROL_RUN_TYPE_LSB) <= run_type;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(0).err_mixed_vfat_ec;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(0).err_mixed_vfat_bc;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(0).err_mixed_oh_bc;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(0).err_event_bigger_than_24;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(0).err_vfat_block_too_small;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(0).err_vfat_block_too_big;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(0).err_corrupted_vfat_data;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(0).err_infifo_full;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(0).err_infifo_underflow;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(0).err_evtfifo_full;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(0).err_event_too_big;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_TTS_STATE_MSB downto REG_DAQ_OH0_STATUS_TTS_STATE_LSB) <= input_status_arr(0).tts_state;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(0).infifo_underflow;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(0).infifo_full;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(0).infifo_near_full;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(0).infifo_empty;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(0).evtfifo_underflow;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(0).evtfifo_full;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(0).evtfifo_near_full;
    regs_read_arr(14)(REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(0).evtfifo_empty;
    regs_read_arr(15)(REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(0).cnt_corrupted_vfat;
    regs_read_arr(16)(REG_DAQ_OH0_COUNTERS_EVN_MSB downto REG_DAQ_OH0_COUNTERS_EVN_LSB) <= input_status_arr(0).eb_event_num;
    regs_read_arr(17)(REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(0).eb_timeout_delay;
    regs_read_arr(18)(REG_DAQ_OH0_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH0_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(0).data_cnt;
    regs_read_arr(18)(REG_DAQ_OH0_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH0_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(0).data_cnt;
    regs_read_arr(19)(REG_DAQ_OH0_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH0_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(0).infifo_near_full_cnt;
    regs_read_arr(19)(REG_DAQ_OH0_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH0_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(0).evtfifo_near_full_cnt;
    regs_read_arr(20)(REG_DAQ_OH0_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH0_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(0).infifo_wr_rate;
    regs_read_arr(20)(REG_DAQ_OH0_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH0_COUNTERS_EVT_RATE_LSB) <= input_status_arr(0).evtfifo_wr_rate;
    regs_read_arr(21)(REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(0).eb_max_timer;
    regs_read_arr(22)(REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(0).eb_last_timer;
    regs_read_arr(23)(REG_DAQ_OH0_LASTBLOCK0_MSB downto REG_DAQ_OH0_LASTBLOCK0_LSB) <= input_status_arr(0).ep_vfat_block_data(0);
    regs_read_arr(24)(REG_DAQ_OH0_LASTBLOCK1_MSB downto REG_DAQ_OH0_LASTBLOCK1_LSB) <= input_status_arr(0).ep_vfat_block_data(1);
    regs_read_arr(25)(REG_DAQ_OH0_LASTBLOCK2_MSB downto REG_DAQ_OH0_LASTBLOCK2_LSB) <= input_status_arr(0).ep_vfat_block_data(2);
    regs_read_arr(26)(REG_DAQ_OH0_LASTBLOCK3_MSB downto REG_DAQ_OH0_LASTBLOCK3_LSB) <= input_status_arr(0).ep_vfat_block_data(3);
    regs_read_arr(27)(REG_DAQ_OH0_LASTBLOCK4_MSB downto REG_DAQ_OH0_LASTBLOCK4_LSB) <= input_status_arr(0).ep_vfat_block_data(4);
    regs_read_arr(28)(REG_DAQ_OH0_LASTBLOCK5_MSB downto REG_DAQ_OH0_LASTBLOCK5_LSB) <= input_status_arr(0).ep_vfat_block_data(5);
    regs_read_arr(29)(REG_DAQ_OH0_LASTBLOCK6_MSB downto REG_DAQ_OH0_LASTBLOCK6_LSB) <= input_status_arr(0).ep_vfat_block_data(6);
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(1).err_mixed_vfat_ec;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(1).err_mixed_vfat_bc;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(1).err_mixed_oh_bc;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(1).err_event_bigger_than_24;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(1).err_vfat_block_too_small;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(1).err_vfat_block_too_big;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(1).err_corrupted_vfat_data;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(1).err_infifo_full;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(1).err_infifo_underflow;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(1).err_evtfifo_full;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(1).err_event_too_big;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_TTS_STATE_MSB downto REG_DAQ_OH1_STATUS_TTS_STATE_LSB) <= input_status_arr(1).tts_state;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(1).infifo_underflow;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(1).infifo_full;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(1).infifo_near_full;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(1).infifo_empty;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(1).evtfifo_underflow;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(1).evtfifo_full;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(1).evtfifo_near_full;
    regs_read_arr(30)(REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(1).evtfifo_empty;
    regs_read_arr(31)(REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(1).cnt_corrupted_vfat;
    regs_read_arr(32)(REG_DAQ_OH1_COUNTERS_EVN_MSB downto REG_DAQ_OH1_COUNTERS_EVN_LSB) <= input_status_arr(1).eb_event_num;
    regs_read_arr(33)(REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(1).eb_timeout_delay;
    regs_read_arr(34)(REG_DAQ_OH1_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH1_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(1).data_cnt;
    regs_read_arr(34)(REG_DAQ_OH1_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH1_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(1).data_cnt;
    regs_read_arr(35)(REG_DAQ_OH1_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH1_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(1).infifo_near_full_cnt;
    regs_read_arr(35)(REG_DAQ_OH1_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH1_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(1).evtfifo_near_full_cnt;
    regs_read_arr(36)(REG_DAQ_OH1_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH1_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(1).infifo_wr_rate;
    regs_read_arr(36)(REG_DAQ_OH1_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH1_COUNTERS_EVT_RATE_LSB) <= input_status_arr(1).evtfifo_wr_rate;
    regs_read_arr(37)(REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(1).eb_max_timer;
    regs_read_arr(38)(REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(1).eb_last_timer;
    regs_read_arr(39)(REG_DAQ_OH1_LASTBLOCK0_MSB downto REG_DAQ_OH1_LASTBLOCK0_LSB) <= input_status_arr(1).ep_vfat_block_data(0);
    regs_read_arr(40)(REG_DAQ_OH1_LASTBLOCK1_MSB downto REG_DAQ_OH1_LASTBLOCK1_LSB) <= input_status_arr(1).ep_vfat_block_data(1);
    regs_read_arr(41)(REG_DAQ_OH1_LASTBLOCK2_MSB downto REG_DAQ_OH1_LASTBLOCK2_LSB) <= input_status_arr(1).ep_vfat_block_data(2);
    regs_read_arr(42)(REG_DAQ_OH1_LASTBLOCK3_MSB downto REG_DAQ_OH1_LASTBLOCK3_LSB) <= input_status_arr(1).ep_vfat_block_data(3);
    regs_read_arr(43)(REG_DAQ_OH1_LASTBLOCK4_MSB downto REG_DAQ_OH1_LASTBLOCK4_LSB) <= input_status_arr(1).ep_vfat_block_data(4);
    regs_read_arr(44)(REG_DAQ_OH1_LASTBLOCK5_MSB downto REG_DAQ_OH1_LASTBLOCK5_LSB) <= input_status_arr(1).ep_vfat_block_data(5);
    regs_read_arr(45)(REG_DAQ_OH1_LASTBLOCK6_MSB downto REG_DAQ_OH1_LASTBLOCK6_LSB) <= input_status_arr(1).ep_vfat_block_data(6);
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(2).err_mixed_vfat_ec;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(2).err_mixed_vfat_bc;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(2).err_mixed_oh_bc;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(2).err_event_bigger_than_24;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(2).err_vfat_block_too_small;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(2).err_vfat_block_too_big;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(2).err_corrupted_vfat_data;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(2).err_infifo_full;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(2).err_infifo_underflow;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(2).err_evtfifo_full;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(2).err_event_too_big;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_TTS_STATE_MSB downto REG_DAQ_OH2_STATUS_TTS_STATE_LSB) <= input_status_arr(2).tts_state;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(2).infifo_underflow;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(2).infifo_full;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(2).infifo_near_full;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(2).infifo_empty;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(2).evtfifo_underflow;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(2).evtfifo_full;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(2).evtfifo_near_full;
    regs_read_arr(46)(REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(2).evtfifo_empty;
    regs_read_arr(47)(REG_DAQ_OH2_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH2_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(2).cnt_corrupted_vfat;
    regs_read_arr(48)(REG_DAQ_OH2_COUNTERS_EVN_MSB downto REG_DAQ_OH2_COUNTERS_EVN_LSB) <= input_status_arr(2).eb_event_num;
    regs_read_arr(49)(REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(2).eb_timeout_delay;
    regs_read_arr(50)(REG_DAQ_OH2_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH2_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(2).data_cnt;
    regs_read_arr(50)(REG_DAQ_OH2_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH2_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(2).data_cnt;
    regs_read_arr(51)(REG_DAQ_OH2_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH2_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(2).infifo_near_full_cnt;
    regs_read_arr(51)(REG_DAQ_OH2_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH2_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(2).evtfifo_near_full_cnt;
    regs_read_arr(52)(REG_DAQ_OH2_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH2_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(2).infifo_wr_rate;
    regs_read_arr(52)(REG_DAQ_OH2_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH2_COUNTERS_EVT_RATE_LSB) <= input_status_arr(2).evtfifo_wr_rate;
    regs_read_arr(53)(REG_DAQ_OH2_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH2_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(2).eb_max_timer;
    regs_read_arr(54)(REG_DAQ_OH2_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH2_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(2).eb_last_timer;
    regs_read_arr(55)(REG_DAQ_OH2_LASTBLOCK0_MSB downto REG_DAQ_OH2_LASTBLOCK0_LSB) <= input_status_arr(2).ep_vfat_block_data(0);
    regs_read_arr(56)(REG_DAQ_OH2_LASTBLOCK1_MSB downto REG_DAQ_OH2_LASTBLOCK1_LSB) <= input_status_arr(2).ep_vfat_block_data(1);
    regs_read_arr(57)(REG_DAQ_OH2_LASTBLOCK2_MSB downto REG_DAQ_OH2_LASTBLOCK2_LSB) <= input_status_arr(2).ep_vfat_block_data(2);
    regs_read_arr(58)(REG_DAQ_OH2_LASTBLOCK3_MSB downto REG_DAQ_OH2_LASTBLOCK3_LSB) <= input_status_arr(2).ep_vfat_block_data(3);
    regs_read_arr(59)(REG_DAQ_OH2_LASTBLOCK4_MSB downto REG_DAQ_OH2_LASTBLOCK4_LSB) <= input_status_arr(2).ep_vfat_block_data(4);
    regs_read_arr(60)(REG_DAQ_OH2_LASTBLOCK5_MSB downto REG_DAQ_OH2_LASTBLOCK5_LSB) <= input_status_arr(2).ep_vfat_block_data(5);
    regs_read_arr(61)(REG_DAQ_OH2_LASTBLOCK6_MSB downto REG_DAQ_OH2_LASTBLOCK6_LSB) <= input_status_arr(2).ep_vfat_block_data(6);
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(3).err_mixed_vfat_ec;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(3).err_mixed_vfat_bc;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(3).err_mixed_oh_bc;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(3).err_event_bigger_than_24;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(3).err_vfat_block_too_small;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(3).err_vfat_block_too_big;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(3).err_corrupted_vfat_data;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(3).err_infifo_full;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(3).err_infifo_underflow;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(3).err_evtfifo_full;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(3).err_event_too_big;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_TTS_STATE_MSB downto REG_DAQ_OH3_STATUS_TTS_STATE_LSB) <= input_status_arr(3).tts_state;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(3).infifo_underflow;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(3).infifo_full;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(3).infifo_near_full;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(3).infifo_empty;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(3).evtfifo_underflow;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(3).evtfifo_full;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(3).evtfifo_near_full;
    regs_read_arr(62)(REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(3).evtfifo_empty;
    regs_read_arr(63)(REG_DAQ_OH3_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH3_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(3).cnt_corrupted_vfat;
    regs_read_arr(64)(REG_DAQ_OH3_COUNTERS_EVN_MSB downto REG_DAQ_OH3_COUNTERS_EVN_LSB) <= input_status_arr(3).eb_event_num;
    regs_read_arr(65)(REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(3).eb_timeout_delay;
    regs_read_arr(66)(REG_DAQ_OH3_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH3_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(3).data_cnt;
    regs_read_arr(66)(REG_DAQ_OH3_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH3_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(3).data_cnt;
    regs_read_arr(67)(REG_DAQ_OH3_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH3_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(3).infifo_near_full_cnt;
    regs_read_arr(67)(REG_DAQ_OH3_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH3_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(3).evtfifo_near_full_cnt;
    regs_read_arr(68)(REG_DAQ_OH3_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH3_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(3).infifo_wr_rate;
    regs_read_arr(68)(REG_DAQ_OH3_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH3_COUNTERS_EVT_RATE_LSB) <= input_status_arr(3).evtfifo_wr_rate;
    regs_read_arr(69)(REG_DAQ_OH3_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH3_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(3).eb_max_timer;
    regs_read_arr(70)(REG_DAQ_OH3_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH3_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(3).eb_last_timer;
    regs_read_arr(71)(REG_DAQ_OH3_LASTBLOCK0_MSB downto REG_DAQ_OH3_LASTBLOCK0_LSB) <= input_status_arr(3).ep_vfat_block_data(0);
    regs_read_arr(72)(REG_DAQ_OH3_LASTBLOCK1_MSB downto REG_DAQ_OH3_LASTBLOCK1_LSB) <= input_status_arr(3).ep_vfat_block_data(1);
    regs_read_arr(73)(REG_DAQ_OH3_LASTBLOCK2_MSB downto REG_DAQ_OH3_LASTBLOCK2_LSB) <= input_status_arr(3).ep_vfat_block_data(2);
    regs_read_arr(74)(REG_DAQ_OH3_LASTBLOCK3_MSB downto REG_DAQ_OH3_LASTBLOCK3_LSB) <= input_status_arr(3).ep_vfat_block_data(3);
    regs_read_arr(75)(REG_DAQ_OH3_LASTBLOCK4_MSB downto REG_DAQ_OH3_LASTBLOCK4_LSB) <= input_status_arr(3).ep_vfat_block_data(4);
    regs_read_arr(76)(REG_DAQ_OH3_LASTBLOCK5_MSB downto REG_DAQ_OH3_LASTBLOCK5_LSB) <= input_status_arr(3).ep_vfat_block_data(5);
    regs_read_arr(77)(REG_DAQ_OH3_LASTBLOCK6_MSB downto REG_DAQ_OH3_LASTBLOCK6_LSB) <= input_status_arr(3).ep_vfat_block_data(6);
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(4).err_mixed_vfat_ec;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(4).err_mixed_vfat_bc;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(4).err_mixed_oh_bc;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(4).err_event_bigger_than_24;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(4).err_vfat_block_too_small;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(4).err_vfat_block_too_big;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(4).err_corrupted_vfat_data;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(4).err_infifo_full;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(4).err_infifo_underflow;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(4).err_evtfifo_full;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(4).err_event_too_big;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_TTS_STATE_MSB downto REG_DAQ_OH4_STATUS_TTS_STATE_LSB) <= input_status_arr(4).tts_state;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(4).infifo_underflow;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(4).infifo_full;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(4).infifo_near_full;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(4).infifo_empty;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(4).evtfifo_underflow;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(4).evtfifo_full;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(4).evtfifo_near_full;
    regs_read_arr(78)(REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(4).evtfifo_empty;
    regs_read_arr(79)(REG_DAQ_OH4_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH4_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(4).cnt_corrupted_vfat;
    regs_read_arr(80)(REG_DAQ_OH4_COUNTERS_EVN_MSB downto REG_DAQ_OH4_COUNTERS_EVN_LSB) <= input_status_arr(4).eb_event_num;
    regs_read_arr(81)(REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(4).eb_timeout_delay;
    regs_read_arr(82)(REG_DAQ_OH4_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH4_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(4).data_cnt;
    regs_read_arr(82)(REG_DAQ_OH4_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH4_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(4).data_cnt;
    regs_read_arr(83)(REG_DAQ_OH4_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH4_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(4).infifo_near_full_cnt;
    regs_read_arr(83)(REG_DAQ_OH4_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH4_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(4).evtfifo_near_full_cnt;
    regs_read_arr(84)(REG_DAQ_OH4_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH4_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(4).infifo_wr_rate;
    regs_read_arr(84)(REG_DAQ_OH4_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH4_COUNTERS_EVT_RATE_LSB) <= input_status_arr(4).evtfifo_wr_rate;
    regs_read_arr(85)(REG_DAQ_OH4_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH4_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(4).eb_max_timer;
    regs_read_arr(86)(REG_DAQ_OH4_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH4_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(4).eb_last_timer;
    regs_read_arr(87)(REG_DAQ_OH4_LASTBLOCK0_MSB downto REG_DAQ_OH4_LASTBLOCK0_LSB) <= input_status_arr(4).ep_vfat_block_data(0);
    regs_read_arr(88)(REG_DAQ_OH4_LASTBLOCK1_MSB downto REG_DAQ_OH4_LASTBLOCK1_LSB) <= input_status_arr(4).ep_vfat_block_data(1);
    regs_read_arr(89)(REG_DAQ_OH4_LASTBLOCK2_MSB downto REG_DAQ_OH4_LASTBLOCK2_LSB) <= input_status_arr(4).ep_vfat_block_data(2);
    regs_read_arr(90)(REG_DAQ_OH4_LASTBLOCK3_MSB downto REG_DAQ_OH4_LASTBLOCK3_LSB) <= input_status_arr(4).ep_vfat_block_data(3);
    regs_read_arr(91)(REG_DAQ_OH4_LASTBLOCK4_MSB downto REG_DAQ_OH4_LASTBLOCK4_LSB) <= input_status_arr(4).ep_vfat_block_data(4);
    regs_read_arr(92)(REG_DAQ_OH4_LASTBLOCK5_MSB downto REG_DAQ_OH4_LASTBLOCK5_LSB) <= input_status_arr(4).ep_vfat_block_data(5);
    regs_read_arr(93)(REG_DAQ_OH4_LASTBLOCK6_MSB downto REG_DAQ_OH4_LASTBLOCK6_LSB) <= input_status_arr(4).ep_vfat_block_data(6);
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(5).err_mixed_vfat_ec;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(5).err_mixed_vfat_bc;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(5).err_mixed_oh_bc;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(5).err_event_bigger_than_24;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(5).err_vfat_block_too_small;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(5).err_vfat_block_too_big;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(5).err_corrupted_vfat_data;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(5).err_infifo_full;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(5).err_infifo_underflow;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(5).err_evtfifo_full;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(5).err_event_too_big;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_TTS_STATE_MSB downto REG_DAQ_OH5_STATUS_TTS_STATE_LSB) <= input_status_arr(5).tts_state;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(5).infifo_underflow;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(5).infifo_full;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(5).infifo_near_full;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(5).infifo_empty;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(5).evtfifo_underflow;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(5).evtfifo_full;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(5).evtfifo_near_full;
    regs_read_arr(94)(REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(5).evtfifo_empty;
    regs_read_arr(95)(REG_DAQ_OH5_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH5_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(5).cnt_corrupted_vfat;
    regs_read_arr(96)(REG_DAQ_OH5_COUNTERS_EVN_MSB downto REG_DAQ_OH5_COUNTERS_EVN_LSB) <= input_status_arr(5).eb_event_num;
    regs_read_arr(97)(REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(5).eb_timeout_delay;
    regs_read_arr(98)(REG_DAQ_OH5_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH5_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(5).data_cnt;
    regs_read_arr(98)(REG_DAQ_OH5_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH5_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(5).data_cnt;
    regs_read_arr(99)(REG_DAQ_OH5_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH5_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(5).infifo_near_full_cnt;
    regs_read_arr(99)(REG_DAQ_OH5_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH5_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(5).evtfifo_near_full_cnt;
    regs_read_arr(100)(REG_DAQ_OH5_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH5_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(5).infifo_wr_rate;
    regs_read_arr(100)(REG_DAQ_OH5_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH5_COUNTERS_EVT_RATE_LSB) <= input_status_arr(5).evtfifo_wr_rate;
    regs_read_arr(101)(REG_DAQ_OH5_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH5_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(5).eb_max_timer;
    regs_read_arr(102)(REG_DAQ_OH5_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH5_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(5).eb_last_timer;
    regs_read_arr(103)(REG_DAQ_OH5_LASTBLOCK0_MSB downto REG_DAQ_OH5_LASTBLOCK0_LSB) <= input_status_arr(5).ep_vfat_block_data(0);
    regs_read_arr(104)(REG_DAQ_OH5_LASTBLOCK1_MSB downto REG_DAQ_OH5_LASTBLOCK1_LSB) <= input_status_arr(5).ep_vfat_block_data(1);
    regs_read_arr(105)(REG_DAQ_OH5_LASTBLOCK2_MSB downto REG_DAQ_OH5_LASTBLOCK2_LSB) <= input_status_arr(5).ep_vfat_block_data(2);
    regs_read_arr(106)(REG_DAQ_OH5_LASTBLOCK3_MSB downto REG_DAQ_OH5_LASTBLOCK3_LSB) <= input_status_arr(5).ep_vfat_block_data(3);
    regs_read_arr(107)(REG_DAQ_OH5_LASTBLOCK4_MSB downto REG_DAQ_OH5_LASTBLOCK4_LSB) <= input_status_arr(5).ep_vfat_block_data(4);
    regs_read_arr(108)(REG_DAQ_OH5_LASTBLOCK5_MSB downto REG_DAQ_OH5_LASTBLOCK5_LSB) <= input_status_arr(5).ep_vfat_block_data(5);
    regs_read_arr(109)(REG_DAQ_OH5_LASTBLOCK6_MSB downto REG_DAQ_OH5_LASTBLOCK6_LSB) <= input_status_arr(5).ep_vfat_block_data(6);
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(6).err_mixed_vfat_ec;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(6).err_mixed_vfat_bc;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(6).err_mixed_oh_bc;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(6).err_event_bigger_than_24;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(6).err_vfat_block_too_small;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(6).err_vfat_block_too_big;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(6).err_corrupted_vfat_data;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(6).err_infifo_full;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(6).err_infifo_underflow;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(6).err_evtfifo_full;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(6).err_event_too_big;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_TTS_STATE_MSB downto REG_DAQ_OH6_STATUS_TTS_STATE_LSB) <= input_status_arr(6).tts_state;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(6).infifo_underflow;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(6).infifo_full;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(6).infifo_near_full;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(6).infifo_empty;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(6).evtfifo_underflow;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(6).evtfifo_full;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(6).evtfifo_near_full;
    regs_read_arr(110)(REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(6).evtfifo_empty;
    regs_read_arr(111)(REG_DAQ_OH6_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH6_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(6).cnt_corrupted_vfat;
    regs_read_arr(112)(REG_DAQ_OH6_COUNTERS_EVN_MSB downto REG_DAQ_OH6_COUNTERS_EVN_LSB) <= input_status_arr(6).eb_event_num;
    regs_read_arr(113)(REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(6).eb_timeout_delay;
    regs_read_arr(114)(REG_DAQ_OH6_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH6_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(6).data_cnt;
    regs_read_arr(114)(REG_DAQ_OH6_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH6_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(6).data_cnt;
    regs_read_arr(115)(REG_DAQ_OH6_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH6_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(6).infifo_near_full_cnt;
    regs_read_arr(115)(REG_DAQ_OH6_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH6_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(6).evtfifo_near_full_cnt;
    regs_read_arr(116)(REG_DAQ_OH6_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH6_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(6).infifo_wr_rate;
    regs_read_arr(116)(REG_DAQ_OH6_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH6_COUNTERS_EVT_RATE_LSB) <= input_status_arr(6).evtfifo_wr_rate;
    regs_read_arr(117)(REG_DAQ_OH6_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH6_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(6).eb_max_timer;
    regs_read_arr(118)(REG_DAQ_OH6_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH6_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(6).eb_last_timer;
    regs_read_arr(119)(REG_DAQ_OH6_LASTBLOCK0_MSB downto REG_DAQ_OH6_LASTBLOCK0_LSB) <= input_status_arr(6).ep_vfat_block_data(0);
    regs_read_arr(120)(REG_DAQ_OH6_LASTBLOCK1_MSB downto REG_DAQ_OH6_LASTBLOCK1_LSB) <= input_status_arr(6).ep_vfat_block_data(1);
    regs_read_arr(121)(REG_DAQ_OH6_LASTBLOCK2_MSB downto REG_DAQ_OH6_LASTBLOCK2_LSB) <= input_status_arr(6).ep_vfat_block_data(2);
    regs_read_arr(122)(REG_DAQ_OH6_LASTBLOCK3_MSB downto REG_DAQ_OH6_LASTBLOCK3_LSB) <= input_status_arr(6).ep_vfat_block_data(3);
    regs_read_arr(123)(REG_DAQ_OH6_LASTBLOCK4_MSB downto REG_DAQ_OH6_LASTBLOCK4_LSB) <= input_status_arr(6).ep_vfat_block_data(4);
    regs_read_arr(124)(REG_DAQ_OH6_LASTBLOCK5_MSB downto REG_DAQ_OH6_LASTBLOCK5_LSB) <= input_status_arr(6).ep_vfat_block_data(5);
    regs_read_arr(125)(REG_DAQ_OH6_LASTBLOCK6_MSB downto REG_DAQ_OH6_LASTBLOCK6_LSB) <= input_status_arr(6).ep_vfat_block_data(6);
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(7).err_mixed_vfat_ec;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(7).err_mixed_vfat_bc;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(7).err_mixed_oh_bc;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(7).err_event_bigger_than_24;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(7).err_vfat_block_too_small;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(7).err_vfat_block_too_big;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(7).err_corrupted_vfat_data;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(7).err_infifo_full;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(7).err_infifo_underflow;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(7).err_evtfifo_full;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(7).err_event_too_big;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_TTS_STATE_MSB downto REG_DAQ_OH7_STATUS_TTS_STATE_LSB) <= input_status_arr(7).tts_state;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(7).infifo_underflow;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(7).infifo_full;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(7).infifo_near_full;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(7).infifo_empty;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(7).evtfifo_underflow;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(7).evtfifo_full;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(7).evtfifo_near_full;
    regs_read_arr(126)(REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(7).evtfifo_empty;
    regs_read_arr(127)(REG_DAQ_OH7_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH7_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(7).cnt_corrupted_vfat;
    regs_read_arr(128)(REG_DAQ_OH7_COUNTERS_EVN_MSB downto REG_DAQ_OH7_COUNTERS_EVN_LSB) <= input_status_arr(7).eb_event_num;
    regs_read_arr(129)(REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(7).eb_timeout_delay;
    regs_read_arr(130)(REG_DAQ_OH7_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH7_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(7).data_cnt;
    regs_read_arr(130)(REG_DAQ_OH7_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH7_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(7).data_cnt;
    regs_read_arr(131)(REG_DAQ_OH7_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH7_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(7).infifo_near_full_cnt;
    regs_read_arr(131)(REG_DAQ_OH7_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH7_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(7).evtfifo_near_full_cnt;
    regs_read_arr(132)(REG_DAQ_OH7_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH7_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(7).infifo_wr_rate;
    regs_read_arr(132)(REG_DAQ_OH7_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH7_COUNTERS_EVT_RATE_LSB) <= input_status_arr(7).evtfifo_wr_rate;
    regs_read_arr(133)(REG_DAQ_OH7_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH7_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(7).eb_max_timer;
    regs_read_arr(134)(REG_DAQ_OH7_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH7_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(7).eb_last_timer;
    regs_read_arr(135)(REG_DAQ_OH7_LASTBLOCK0_MSB downto REG_DAQ_OH7_LASTBLOCK0_LSB) <= input_status_arr(7).ep_vfat_block_data(0);
    regs_read_arr(136)(REG_DAQ_OH7_LASTBLOCK1_MSB downto REG_DAQ_OH7_LASTBLOCK1_LSB) <= input_status_arr(7).ep_vfat_block_data(1);
    regs_read_arr(137)(REG_DAQ_OH7_LASTBLOCK2_MSB downto REG_DAQ_OH7_LASTBLOCK2_LSB) <= input_status_arr(7).ep_vfat_block_data(2);
    regs_read_arr(138)(REG_DAQ_OH7_LASTBLOCK3_MSB downto REG_DAQ_OH7_LASTBLOCK3_LSB) <= input_status_arr(7).ep_vfat_block_data(3);
    regs_read_arr(139)(REG_DAQ_OH7_LASTBLOCK4_MSB downto REG_DAQ_OH7_LASTBLOCK4_LSB) <= input_status_arr(7).ep_vfat_block_data(4);
    regs_read_arr(140)(REG_DAQ_OH7_LASTBLOCK5_MSB downto REG_DAQ_OH7_LASTBLOCK5_LSB) <= input_status_arr(7).ep_vfat_block_data(5);
    regs_read_arr(141)(REG_DAQ_OH7_LASTBLOCK6_MSB downto REG_DAQ_OH7_LASTBLOCK6_LSB) <= input_status_arr(7).ep_vfat_block_data(6);
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(8).err_mixed_vfat_ec;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(8).err_mixed_vfat_bc;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(8).err_mixed_oh_bc;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(8).err_event_bigger_than_24;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(8).err_vfat_block_too_small;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(8).err_vfat_block_too_big;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(8).err_corrupted_vfat_data;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(8).err_infifo_full;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(8).err_infifo_underflow;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(8).err_evtfifo_full;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(8).err_event_too_big;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_TTS_STATE_MSB downto REG_DAQ_OH8_STATUS_TTS_STATE_LSB) <= input_status_arr(8).tts_state;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(8).infifo_underflow;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(8).infifo_full;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(8).infifo_near_full;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(8).infifo_empty;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(8).evtfifo_underflow;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(8).evtfifo_full;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(8).evtfifo_near_full;
    regs_read_arr(142)(REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(8).evtfifo_empty;
    regs_read_arr(143)(REG_DAQ_OH8_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH8_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(8).cnt_corrupted_vfat;
    regs_read_arr(144)(REG_DAQ_OH8_COUNTERS_EVN_MSB downto REG_DAQ_OH8_COUNTERS_EVN_LSB) <= input_status_arr(8).eb_event_num;
    regs_read_arr(145)(REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(8).eb_timeout_delay;
    regs_read_arr(146)(REG_DAQ_OH8_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH8_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(8).data_cnt;
    regs_read_arr(146)(REG_DAQ_OH8_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH8_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(8).data_cnt;
    regs_read_arr(147)(REG_DAQ_OH8_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH8_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(8).infifo_near_full_cnt;
    regs_read_arr(147)(REG_DAQ_OH8_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH8_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(8).evtfifo_near_full_cnt;
    regs_read_arr(148)(REG_DAQ_OH8_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH8_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(8).infifo_wr_rate;
    regs_read_arr(148)(REG_DAQ_OH8_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH8_COUNTERS_EVT_RATE_LSB) <= input_status_arr(8).evtfifo_wr_rate;
    regs_read_arr(149)(REG_DAQ_OH8_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH8_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(8).eb_max_timer;
    regs_read_arr(150)(REG_DAQ_OH8_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH8_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(8).eb_last_timer;
    regs_read_arr(151)(REG_DAQ_OH8_LASTBLOCK0_MSB downto REG_DAQ_OH8_LASTBLOCK0_LSB) <= input_status_arr(8).ep_vfat_block_data(0);
    regs_read_arr(152)(REG_DAQ_OH8_LASTBLOCK1_MSB downto REG_DAQ_OH8_LASTBLOCK1_LSB) <= input_status_arr(8).ep_vfat_block_data(1);
    regs_read_arr(153)(REG_DAQ_OH8_LASTBLOCK2_MSB downto REG_DAQ_OH8_LASTBLOCK2_LSB) <= input_status_arr(8).ep_vfat_block_data(2);
    regs_read_arr(154)(REG_DAQ_OH8_LASTBLOCK3_MSB downto REG_DAQ_OH8_LASTBLOCK3_LSB) <= input_status_arr(8).ep_vfat_block_data(3);
    regs_read_arr(155)(REG_DAQ_OH8_LASTBLOCK4_MSB downto REG_DAQ_OH8_LASTBLOCK4_LSB) <= input_status_arr(8).ep_vfat_block_data(4);
    regs_read_arr(156)(REG_DAQ_OH8_LASTBLOCK5_MSB downto REG_DAQ_OH8_LASTBLOCK5_LSB) <= input_status_arr(8).ep_vfat_block_data(5);
    regs_read_arr(157)(REG_DAQ_OH8_LASTBLOCK6_MSB downto REG_DAQ_OH8_LASTBLOCK6_LSB) <= input_status_arr(8).ep_vfat_block_data(6);
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(9).err_mixed_vfat_ec;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(9).err_mixed_vfat_bc;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(9).err_mixed_oh_bc;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(9).err_event_bigger_than_24;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(9).err_vfat_block_too_small;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(9).err_vfat_block_too_big;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(9).err_corrupted_vfat_data;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(9).err_infifo_full;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(9).err_infifo_underflow;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(9).err_evtfifo_full;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(9).err_event_too_big;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_TTS_STATE_MSB downto REG_DAQ_OH9_STATUS_TTS_STATE_LSB) <= input_status_arr(9).tts_state;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(9).infifo_underflow;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(9).infifo_full;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(9).infifo_near_full;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(9).infifo_empty;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(9).evtfifo_underflow;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(9).evtfifo_full;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(9).evtfifo_near_full;
    regs_read_arr(158)(REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(9).evtfifo_empty;
    regs_read_arr(159)(REG_DAQ_OH9_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH9_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(9).cnt_corrupted_vfat;
    regs_read_arr(160)(REG_DAQ_OH9_COUNTERS_EVN_MSB downto REG_DAQ_OH9_COUNTERS_EVN_LSB) <= input_status_arr(9).eb_event_num;
    regs_read_arr(161)(REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(9).eb_timeout_delay;
    regs_read_arr(162)(REG_DAQ_OH9_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH9_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(9).data_cnt;
    regs_read_arr(162)(REG_DAQ_OH9_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH9_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(9).data_cnt;
    regs_read_arr(163)(REG_DAQ_OH9_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH9_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(9).infifo_near_full_cnt;
    regs_read_arr(163)(REG_DAQ_OH9_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH9_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(9).evtfifo_near_full_cnt;
    regs_read_arr(164)(REG_DAQ_OH9_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH9_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(9).infifo_wr_rate;
    regs_read_arr(164)(REG_DAQ_OH9_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH9_COUNTERS_EVT_RATE_LSB) <= input_status_arr(9).evtfifo_wr_rate;
    regs_read_arr(165)(REG_DAQ_OH9_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH9_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(9).eb_max_timer;
    regs_read_arr(166)(REG_DAQ_OH9_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH9_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(9).eb_last_timer;
    regs_read_arr(167)(REG_DAQ_OH9_LASTBLOCK0_MSB downto REG_DAQ_OH9_LASTBLOCK0_LSB) <= input_status_arr(9).ep_vfat_block_data(0);
    regs_read_arr(168)(REG_DAQ_OH9_LASTBLOCK1_MSB downto REG_DAQ_OH9_LASTBLOCK1_LSB) <= input_status_arr(9).ep_vfat_block_data(1);
    regs_read_arr(169)(REG_DAQ_OH9_LASTBLOCK2_MSB downto REG_DAQ_OH9_LASTBLOCK2_LSB) <= input_status_arr(9).ep_vfat_block_data(2);
    regs_read_arr(170)(REG_DAQ_OH9_LASTBLOCK3_MSB downto REG_DAQ_OH9_LASTBLOCK3_LSB) <= input_status_arr(9).ep_vfat_block_data(3);
    regs_read_arr(171)(REG_DAQ_OH9_LASTBLOCK4_MSB downto REG_DAQ_OH9_LASTBLOCK4_LSB) <= input_status_arr(9).ep_vfat_block_data(4);
    regs_read_arr(172)(REG_DAQ_OH9_LASTBLOCK5_MSB downto REG_DAQ_OH9_LASTBLOCK5_LSB) <= input_status_arr(9).ep_vfat_block_data(5);
    regs_read_arr(173)(REG_DAQ_OH9_LASTBLOCK6_MSB downto REG_DAQ_OH9_LASTBLOCK6_LSB) <= input_status_arr(9).ep_vfat_block_data(6);
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(10).err_mixed_vfat_ec;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(10).err_mixed_vfat_bc;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(10).err_mixed_oh_bc;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(10).err_event_bigger_than_24;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(10).err_vfat_block_too_small;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(10).err_vfat_block_too_big;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(10).err_corrupted_vfat_data;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(10).err_infifo_full;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(10).err_infifo_underflow;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(10).err_evtfifo_full;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(10).err_event_too_big;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_TTS_STATE_MSB downto REG_DAQ_OH10_STATUS_TTS_STATE_LSB) <= input_status_arr(10).tts_state;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(10).infifo_underflow;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(10).infifo_full;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(10).infifo_near_full;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(10).infifo_empty;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(10).evtfifo_underflow;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(10).evtfifo_full;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(10).evtfifo_near_full;
    regs_read_arr(174)(REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(10).evtfifo_empty;
    regs_read_arr(175)(REG_DAQ_OH10_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH10_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(10).cnt_corrupted_vfat;
    regs_read_arr(176)(REG_DAQ_OH10_COUNTERS_EVN_MSB downto REG_DAQ_OH10_COUNTERS_EVN_LSB) <= input_status_arr(10).eb_event_num;
    regs_read_arr(177)(REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(10).eb_timeout_delay;
    regs_read_arr(178)(REG_DAQ_OH10_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH10_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(10).data_cnt;
    regs_read_arr(178)(REG_DAQ_OH10_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH10_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(10).data_cnt;
    regs_read_arr(179)(REG_DAQ_OH10_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH10_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(10).infifo_near_full_cnt;
    regs_read_arr(179)(REG_DAQ_OH10_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH10_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(10).evtfifo_near_full_cnt;
    regs_read_arr(180)(REG_DAQ_OH10_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH10_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(10).infifo_wr_rate;
    regs_read_arr(180)(REG_DAQ_OH10_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH10_COUNTERS_EVT_RATE_LSB) <= input_status_arr(10).evtfifo_wr_rate;
    regs_read_arr(181)(REG_DAQ_OH10_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH10_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(10).eb_max_timer;
    regs_read_arr(182)(REG_DAQ_OH10_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH10_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(10).eb_last_timer;
    regs_read_arr(183)(REG_DAQ_OH10_LASTBLOCK0_MSB downto REG_DAQ_OH10_LASTBLOCK0_LSB) <= input_status_arr(10).ep_vfat_block_data(0);
    regs_read_arr(184)(REG_DAQ_OH10_LASTBLOCK1_MSB downto REG_DAQ_OH10_LASTBLOCK1_LSB) <= input_status_arr(10).ep_vfat_block_data(1);
    regs_read_arr(185)(REG_DAQ_OH10_LASTBLOCK2_MSB downto REG_DAQ_OH10_LASTBLOCK2_LSB) <= input_status_arr(10).ep_vfat_block_data(2);
    regs_read_arr(186)(REG_DAQ_OH10_LASTBLOCK3_MSB downto REG_DAQ_OH10_LASTBLOCK3_LSB) <= input_status_arr(10).ep_vfat_block_data(3);
    regs_read_arr(187)(REG_DAQ_OH10_LASTBLOCK4_MSB downto REG_DAQ_OH10_LASTBLOCK4_LSB) <= input_status_arr(10).ep_vfat_block_data(4);
    regs_read_arr(188)(REG_DAQ_OH10_LASTBLOCK5_MSB downto REG_DAQ_OH10_LASTBLOCK5_LSB) <= input_status_arr(10).ep_vfat_block_data(5);
    regs_read_arr(189)(REG_DAQ_OH10_LASTBLOCK6_MSB downto REG_DAQ_OH10_LASTBLOCK6_LSB) <= input_status_arr(10).ep_vfat_block_data(6);
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_VFAT_MIXED_EC_BIT) <= input_status_arr(11).err_mixed_vfat_ec;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_VFAT_MIXED_BC_BIT) <= input_status_arr(11).err_mixed_vfat_bc;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_OH_MIXED_BC_BIT) <= input_status_arr(11).err_mixed_oh_bc;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_VFAT_TOO_MANY_BIT) <= input_status_arr(11).err_event_bigger_than_24;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_VFAT_SMALL_BLOCK_BIT) <= input_status_arr(11).err_vfat_block_too_small;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_VFAT_LARGE_BLOCK_BIT) <= input_status_arr(11).err_vfat_block_too_big;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_VFAT_NO_MARKER_BIT) <= input_status_arr(11).err_corrupted_vfat_data;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_INPUT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(11).err_infifo_full;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_INPUT_FIFO_HAD_UFLOW_BIT) <= input_status_arr(11).err_infifo_underflow;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_EVENT_FIFO_HAD_OFLOW_BIT) <= input_status_arr(11).err_evtfifo_full;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_EVT_SIZE_ERR_BIT) <= input_status_arr(11).err_event_too_big;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_TTS_STATE_MSB downto REG_DAQ_OH11_STATUS_TTS_STATE_LSB) <= input_status_arr(11).tts_state;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_UFLOW_BIT) <= input_status_arr(11).infifo_underflow;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_FULL_BIT) <= input_status_arr(11).infifo_full;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_AFULL_BIT) <= input_status_arr(11).infifo_near_full;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_EMPTY_BIT) <= input_status_arr(11).infifo_empty;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_UFLOW_BIT) <= input_status_arr(11).evtfifo_underflow;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_FULL_BIT) <= input_status_arr(11).evtfifo_full;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_AFULL_BIT) <= input_status_arr(11).evtfifo_near_full;
    regs_read_arr(190)(REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_EMPTY_BIT) <= input_status_arr(11).evtfifo_empty;
    regs_read_arr(191)(REG_DAQ_OH11_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB downto REG_DAQ_OH11_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB) <= input_status_arr(11).cnt_corrupted_vfat;
    regs_read_arr(192)(REG_DAQ_OH11_COUNTERS_EVN_MSB downto REG_DAQ_OH11_COUNTERS_EVN_LSB) <= input_status_arr(11).eb_event_num;
    regs_read_arr(193)(REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_LSB) <= input_control_arr(11).eb_timeout_delay;
    regs_read_arr(194)(REG_DAQ_OH11_COUNTERS_INPUT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH11_COUNTERS_INPUT_FIFO_DATA_CNT_LSB) <= chamber_infifos(11).data_cnt;
    regs_read_arr(194)(REG_DAQ_OH11_COUNTERS_EVT_FIFO_DATA_CNT_MSB downto REG_DAQ_OH11_COUNTERS_EVT_FIFO_DATA_CNT_LSB) <= chamber_evtfifos(11).data_cnt;
    regs_read_arr(195)(REG_DAQ_OH11_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH11_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(11).infifo_near_full_cnt;
    regs_read_arr(195)(REG_DAQ_OH11_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB downto REG_DAQ_OH11_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB) <= input_status_arr(11).evtfifo_near_full_cnt;
    regs_read_arr(196)(REG_DAQ_OH11_COUNTERS_VFAT_BLOCK_RATE_MSB downto REG_DAQ_OH11_COUNTERS_VFAT_BLOCK_RATE_LSB) <= input_status_arr(11).infifo_wr_rate;
    regs_read_arr(196)(REG_DAQ_OH11_COUNTERS_EVT_RATE_MSB downto REG_DAQ_OH11_COUNTERS_EVT_RATE_LSB) <= input_status_arr(11).evtfifo_wr_rate;
    regs_read_arr(197)(REG_DAQ_OH11_COUNTERS_MAX_EOE_TIMER_MSB downto REG_DAQ_OH11_COUNTERS_MAX_EOE_TIMER_LSB) <= input_status_arr(11).eb_max_timer;
    regs_read_arr(198)(REG_DAQ_OH11_COUNTERS_LAST_EOE_TIMER_MSB downto REG_DAQ_OH11_COUNTERS_LAST_EOE_TIMER_LSB) <= input_status_arr(11).eb_last_timer;
    regs_read_arr(199)(REG_DAQ_OH11_LASTBLOCK0_MSB downto REG_DAQ_OH11_LASTBLOCK0_LSB) <= input_status_arr(11).ep_vfat_block_data(0);
    regs_read_arr(200)(REG_DAQ_OH11_LASTBLOCK1_MSB downto REG_DAQ_OH11_LASTBLOCK1_LSB) <= input_status_arr(11).ep_vfat_block_data(1);
    regs_read_arr(201)(REG_DAQ_OH11_LASTBLOCK2_MSB downto REG_DAQ_OH11_LASTBLOCK2_LSB) <= input_status_arr(11).ep_vfat_block_data(2);
    regs_read_arr(202)(REG_DAQ_OH11_LASTBLOCK3_MSB downto REG_DAQ_OH11_LASTBLOCK3_LSB) <= input_status_arr(11).ep_vfat_block_data(3);
    regs_read_arr(203)(REG_DAQ_OH11_LASTBLOCK4_MSB downto REG_DAQ_OH11_LASTBLOCK4_LSB) <= input_status_arr(11).ep_vfat_block_data(4);
    regs_read_arr(204)(REG_DAQ_OH11_LASTBLOCK5_MSB downto REG_DAQ_OH11_LASTBLOCK5_LSB) <= input_status_arr(11).ep_vfat_block_data(5);
    regs_read_arr(205)(REG_DAQ_OH11_LASTBLOCK6_MSB downto REG_DAQ_OH11_LASTBLOCK6_LSB) <= input_status_arr(11).ep_vfat_block_data(6);

    -- Connect write signals
    daq_enable <= regs_write_arr(0)(REG_DAQ_CONTROL_DAQ_ENABLE_BIT);
    zero_suppression_en <= regs_write_arr(0)(REG_DAQ_CONTROL_ZERO_SUPPRESSION_EN_BIT);
    reset_daqlink_ipb <= regs_write_arr(0)(REG_DAQ_CONTROL_DAQ_LINK_RESET_BIT);
    reset_local <= regs_write_arr(0)(REG_DAQ_CONTROL_RESET_BIT);
    tts_override <= regs_write_arr(0)(REG_DAQ_CONTROL_TTS_OVERRIDE_MSB downto REG_DAQ_CONTROL_TTS_OVERRIDE_LSB);
    input_mask <= regs_write_arr(0)(REG_DAQ_CONTROL_INPUT_ENABLE_MASK_MSB downto REG_DAQ_CONTROL_INPUT_ENABLE_MASK_LSB);
    dav_timeout <= regs_write_arr(6)(REG_DAQ_CONTROL_DAV_TIMEOUT_MSB downto REG_DAQ_CONTROL_DAV_TIMEOUT_LSB);
    run_params <= regs_write_arr(13)(REG_DAQ_EXT_CONTROL_RUN_PARAMS_MSB downto REG_DAQ_EXT_CONTROL_RUN_PARAMS_LSB);
    run_type <= regs_write_arr(13)(REG_DAQ_EXT_CONTROL_RUN_TYPE_MSB downto REG_DAQ_EXT_CONTROL_RUN_TYPE_LSB);
    input_control_arr(0).eb_timeout_delay <= regs_write_arr(17)(REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(1).eb_timeout_delay <= regs_write_arr(33)(REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(2).eb_timeout_delay <= regs_write_arr(49)(REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(3).eb_timeout_delay <= regs_write_arr(65)(REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(4).eb_timeout_delay <= regs_write_arr(81)(REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(5).eb_timeout_delay <= regs_write_arr(97)(REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(6).eb_timeout_delay <= regs_write_arr(113)(REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(7).eb_timeout_delay <= regs_write_arr(129)(REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(8).eb_timeout_delay <= regs_write_arr(145)(REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(9).eb_timeout_delay <= regs_write_arr(161)(REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(10).eb_timeout_delay <= regs_write_arr(177)(REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_LSB);
    input_control_arr(11).eb_timeout_delay <= regs_write_arr(193)(REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_LSB);

    -- Connect write pulse signals

    -- Connect write done signals

    -- Connect read pulse signals

    -- Connect read ready signals

    -- Defaults
    regs_defaults(0)(REG_DAQ_CONTROL_DAQ_ENABLE_BIT) <= REG_DAQ_CONTROL_DAQ_ENABLE_DEFAULT;
    regs_defaults(0)(REG_DAQ_CONTROL_ZERO_SUPPRESSION_EN_BIT) <= REG_DAQ_CONTROL_ZERO_SUPPRESSION_EN_DEFAULT;
    regs_defaults(0)(REG_DAQ_CONTROL_DAQ_LINK_RESET_BIT) <= REG_DAQ_CONTROL_DAQ_LINK_RESET_DEFAULT;
    regs_defaults(0)(REG_DAQ_CONTROL_RESET_BIT) <= REG_DAQ_CONTROL_RESET_DEFAULT;
    regs_defaults(0)(REG_DAQ_CONTROL_TTS_OVERRIDE_MSB downto REG_DAQ_CONTROL_TTS_OVERRIDE_LSB) <= REG_DAQ_CONTROL_TTS_OVERRIDE_DEFAULT;
    regs_defaults(0)(REG_DAQ_CONTROL_INPUT_ENABLE_MASK_MSB downto REG_DAQ_CONTROL_INPUT_ENABLE_MASK_LSB) <= REG_DAQ_CONTROL_INPUT_ENABLE_MASK_DEFAULT;
    regs_defaults(6)(REG_DAQ_CONTROL_DAV_TIMEOUT_MSB downto REG_DAQ_CONTROL_DAV_TIMEOUT_LSB) <= REG_DAQ_CONTROL_DAV_TIMEOUT_DEFAULT;
    regs_defaults(13)(REG_DAQ_EXT_CONTROL_RUN_PARAMS_MSB downto REG_DAQ_EXT_CONTROL_RUN_PARAMS_LSB) <= REG_DAQ_EXT_CONTROL_RUN_PARAMS_DEFAULT;
    regs_defaults(13)(REG_DAQ_EXT_CONTROL_RUN_TYPE_MSB downto REG_DAQ_EXT_CONTROL_RUN_TYPE_LSB) <= REG_DAQ_EXT_CONTROL_RUN_TYPE_DEFAULT;
    regs_defaults(17)(REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(33)(REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(49)(REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(65)(REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(81)(REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(97)(REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(113)(REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(129)(REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(145)(REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(161)(REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(177)(REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_DEFAULT;
    regs_defaults(193)(REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_MSB downto REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_LSB) <= REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_DEFAULT;

    -- Define writable regs
    regs_writable_arr(0) <= '1';
    regs_writable_arr(6) <= '1';
    regs_writable_arr(13) <= '1';
    regs_writable_arr(17) <= '1';
    regs_writable_arr(33) <= '1';
    regs_writable_arr(49) <= '1';
    regs_writable_arr(65) <= '1';
    regs_writable_arr(81) <= '1';
    regs_writable_arr(97) <= '1';
    regs_writable_arr(113) <= '1';
    regs_writable_arr(129) <= '1';
    regs_writable_arr(145) <= '1';
    regs_writable_arr(161) <= '1';
    regs_writable_arr(177) <= '1';
    regs_writable_arr(193) <= '1';

    --==== Registers end ============================================================================

    
end Behavioral;

