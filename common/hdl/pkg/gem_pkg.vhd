library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gem_board_config_package.CFG_NUM_OF_OHs;

package gem_pkg is

    --========================--
    --==  Firmware version  ==--
    --========================-- 

    constant C_FIRMWARE_DATE    : std_logic_vector(31 downto 0) := x"20180604";
    constant C_FIRMWARE_MAJOR   : integer range 0 to 255        := 1;
    constant C_FIRMWARE_MINOR   : integer range 0 to 255        := 12;
    constant C_FIRMWARE_BUILD   : integer range 0 to 255        := 0;
    
    ------ Change log ------
    -- 1.8.6  no gbt sync procedure with oh
    -- 1.8.7  advanced ILA trigger for gbt link
    -- 1.8.8  tied unused 8b10b or gbt links to 0
    -- 1.8.9  disable automatic phase shifting, just use unknown phase from 160MHz ref clock, also use bufg for the MMCM feedback clock
    -- 1.8.9  special version with 8b10b main link moved to OH2 and longer IPBusBridge timeout (comms with OH are perfect, but can't read VFATs at all)
    -- 1.9.0  fixed TX phase alignment, removed MMCM reset (was driven by the GTH startup FSM and messing things up).
    --        if 0 shifts are applied it's known to result in bad phase, so for now just made that if this happens, 
    --        then lock is never asserted, which will prevent GTH startup from completing and will be clearly visible during FPGA programming.
    -- 1.9.1  using TTC 120MHz as the GBT common RX clock instead of recovered clock from the main link (so all links should work even if link 1 is not connected)
    -- 1.9.2  separate SCA controlers for each channel implemented. There's also inbuilt ability to broadcast JTAG and custom SCA commands to any set of selected channels
    -- 1.9.3  Added SCA not ready counters (since last SCA reset). This will show if the SCA communication is stable (once established). 
    --        If yes, we could add an automatic SCA reset + configure after each time the SCA ready goes high after being low.
    -- 1.9.4  Swapped calpulse and bc0 bits in the GBT link because the OH was reading them backwards. Also re-enabled forwarding of resync and calpulse to OH.
    -- 1.10.0 Resync functionality added to the DAQ module. Note that OHs are only sent the resync signal AFTER the DAQ module has drained the buffers and reset.
    -- 1.11.0 Added zero suppression option in the DAQ module - it throws away the complete VFAT blocks where channel data is all zero.
    --        The VFAT payload word count is correctly indicated in the chamber header and trailer, but the zero suppression flags in the chamber header are 
    --        still not implemented because the VFAT order coming from OH is not guaranteed anyway (so can't tell which VFAT position was skipped anyway)..
    -- 1.11.1 Changed the default value of TTC_HARD_RESET_EN from 1 to 0 (TTC hard resets are not forwarded to OH by default)
    -- 1.11.2 Fixed a mismatched width bug when checking VFAT data for zero suppression. Extended reset_daq pulse for resync. Debug probes added for resync debugging.
    -- 1.11.3 Fixed a bug in resync procedure - has to also wait for DAQ output FIFO to drain before doing the reset
    -- 1.11.4 Updated DAQ timeout defaults to sensible values that work well with 100kHz of L1A rate
    -- 1.11.5 Updates in SCA ADC monitoring - setting fixed gain of 90% and enabling current source when measuring the PT100 ADC channels
    -- 1.11.6 Changed the SCA ADC MONITORING_OFF register default to 0xffffffff so that monitoring is off at startup
    -- 1.11.7 Debug version of DAQLink
    -- 1.11.8 Delay DAQ reset after resync by 4 clocks
    -- 1.11.9 Fix a possible deadlock in case of infifo underflow, in this case just put in some fake data and set a flag in the chamber trailer.
    -- 1.12.0 Added a lot of TTC clock monitoring features, including unlock counters and phase monitoring. It's also possible to reset or disable the phase alignment procedure through registers

    --======================--
    --==      General     ==--
    --======================-- 
        
    constant C_LED_PULSE_LENGTH_TTC_CLK : std_logic_vector(20 downto 0) := std_logic_vector(to_unsigned(1_600_000, 21));

    function count_ones(s : std_logic_vector) return integer;
    function bool_to_std_logic(L : BOOLEAN) return std_logic;

    --======================--
    --== Config Constants ==--
    --======================-- 
    
    -- DAQ
    constant C_DAQ_FORMAT_VERSION     : std_logic_vector(3 downto 0)  := x"0";

    --============--
    --== Common ==--
    --============--   
    
    type t_std_array is array(integer range <>) of std_logic;
  
    type t_std32_array is array(integer range <>) of std_logic_vector(31 downto 0);
        
    type t_std16_array is array(integer range <>) of std_logic_vector(15 downto 0);

    type t_std24_array is array(integer range <>) of std_logic_vector(23 downto 0);

    type t_std4_array is array(integer range <>) of std_logic_vector(3 downto 0);

    type t_std2_array is array(integer range <>) of std_logic_vector(1 downto 0);

    --============--
    --==   GBT  ==--
    --============--   

    type t_gbt_frame_array is array(integer range <>) of std_logic_vector(83 downto 0);

    --========================--
    --== GTH/GTX link types ==--
    --========================--

    type t_gt_8b10b_tx_data is record
        txdata         : std_logic_vector(31 downto 0);
        txcharisk      : std_logic_vector(3 downto 0);
        txchardispmode : std_logic_vector(3 downto 0);
        txchardispval  : std_logic_vector(3 downto 0);
    end record;

    type t_gt_8b10b_rx_data is record
        rxdata          : std_logic_vector(31 downto 0);
        rxbyteisaligned : std_logic;
        rxbyterealign   : std_logic;
        rxcommadet      : std_logic;
        rxdisperr       : std_logic_vector(3 downto 0);
        rxnotintable    : std_logic_vector(3 downto 0);
        rxchariscomma   : std_logic_vector(3 downto 0);
        rxcharisk       : std_logic_vector(3 downto 0);
    end record;

    type t_gt_8b10b_tx_data_arr is array(integer range <>) of t_gt_8b10b_tx_data;
    type t_gt_8b10b_rx_data_arr is array(integer range <>) of t_gt_8b10b_rx_data;

    type t_gbt_mgt_tx_links is record
        tx0data          : std_logic_vector(39 downto 0); -- main GBT link for OH v2b 
        tx1data          : std_logic_vector(39 downto 0); -- this will only be used in OH v3 (for now this will just have a dummy load if CFG_USE_3x_GBTs is set to true)
        tx2data          : std_logic_vector(39 downto 0); -- this will only be used in OH v3 (for now this will just have a dummy load if CFG_USE_3x_GBTs is set to true)
    end record;

    type t_gbt_mgt_rx_links is record
        rx0clk           : std_logic;
        rx1clk           : std_logic;
        rx2clk           : std_logic;
        rx0data          : std_logic_vector(39 downto 0); -- main GBT link for OH v2b 
        rx1data          : std_logic_vector(39 downto 0); -- this will only be used in OH v3 (for now this will just have a dummy load if CFG_USE_3x_GBTs is set to true)
        rx2data          : std_logic_vector(39 downto 0); -- this will only be used in OH v3 (for now this will just have a dummy load if CFG_USE_3x_GBTs is set to true)
    end record;

    type t_gbt_mgt_rx_links_arr  is array(integer range <>) of t_gbt_mgt_rx_links;
    type t_gbt_mgt_tx_links_arr  is array(integer range <>) of t_gbt_mgt_tx_links;

    type t_gt_gbt_tx_data_arr is array(integer range <>) of std_logic_vector(39 downto 0);
    type t_gt_gbt_rx_data_arr is array(integer range <>) of std_logic_vector(39 downto 0);

    --========================--
    --== SBit cluster data  ==--
    --========================--

    type t_sbit_cluster is record
        size        : std_logic_vector(2 downto 0);
        address     : std_logic_vector(10 downto 0);
    end record;

    type t_oh_sbits is array(7 downto 0) of t_sbit_cluster;
    type t_oh_sbits_arr is array(integer range <>) of t_oh_sbits;

    type t_sbit_link_status is record
        valid           : std_logic;
        sync_word       : std_logic;
        missed_comma    : std_logic;
        underflow       : std_logic;
        overflow        : std_logic;
    end record;

    type t_oh_sbit_links is array(1 downto 0) of t_sbit_link_status;    
    type t_oh_sbit_links_arr is array(integer range <>) of t_oh_sbit_links;

    --====================--
    --==     DAQLink    ==--
    --====================--

    type t_daq_to_daqlink is record
        reset           : std_logic;
        ttc_clk         : std_logic;
        ttc_bc0         : std_logic;
        trig            : std_logic_vector(7 downto 0);
        tts_clk         : std_logic;
        tts_state       : std_logic_vector(3 downto 0);
        resync          : std_logic;
        event_clk       : std_logic;
        event_valid     : std_logic;
        event_header    : std_logic;
        event_trailer   : std_logic;
        event_data      : std_logic_vector(63 downto 0);
    end record;

    type t_daqlink_to_daq is record
        ready           : std_logic;
        almost_full     : std_logic;
        disperr_cnt     : std_logic_vector(15 downto 0);
        notintable_cnt  : std_logic_vector(15 downto 0);
    end record;

    --====================--
    --== DAQ data input ==--
    --====================--
    
    type t_data_link is record
        clk             : std_logic;
        data_en    : std_logic;
        data       : std_logic_vector(15 downto 0);
    end record;
    
    type t_data_link_array is array(integer range <>) of t_data_link;    

    --=====================================--
    --==   DAQ input status and control  ==--
    --=====================================--
    
    type t_daq_input_status is record
        evtfifo_empty           : std_logic;
        evtfifo_near_full       : std_logic;
        evtfifo_full            : std_logic;
        evtfifo_underflow       : std_logic;
        evtfifo_near_full_cnt   : std_logic_vector(15 downto 0);
        evtfifo_wr_rate         : std_logic_vector(16 downto 0);
        infifo_empty            : std_logic;
        infifo_near_full        : std_logic;
        infifo_full             : std_logic;
        infifo_underflow        : std_logic;
        infifo_near_full_cnt    : std_logic_vector(15 downto 0);
        infifo_wr_rate          : std_logic_vector(14 downto 0);
        tts_state               : std_logic_vector(3 downto 0);
        err_event_too_big       : std_logic;
        err_evtfifo_full        : std_logic;
        err_infifo_underflow    : std_logic;
        err_infifo_full         : std_logic;
        err_corrupted_vfat_data : std_logic;
        err_vfat_block_too_big  : std_logic;
        err_vfat_block_too_small: std_logic;
        err_event_bigger_than_24: std_logic;
        err_mixed_oh_bc         : std_logic;
        err_mixed_vfat_bc       : std_logic;
        err_mixed_vfat_ec       : std_logic;
        cnt_corrupted_vfat      : std_logic_vector(31 downto 0);
        eb_event_num            : std_logic_vector(23 downto 0);
        eb_max_timer            : std_logic_vector(23 downto 0);
        eb_last_timer           : std_logic_vector(23 downto 0);
        ep_vfat_block_data      : t_std32_array(6 downto 0);
    end record;

    type t_daq_input_status_arr is array(integer range <>) of t_daq_input_status;

    type t_daq_input_control is record
        eb_timeout_delay        : std_logic_vector(23 downto 0);
        eb_zero_supression_en   : std_logic;
    end record;
    
    type t_daq_input_control_arr is array(integer range <>) of t_daq_input_control;

    --====================--
    --==   DAQ other    ==--
    --====================--

    type t_chamber_infifo_rd is record
        dout          : std_logic_vector(191 downto 0);
        rd_en         : std_logic;
        empty         : std_logic;
        valid         : std_logic;
        underflow     : std_logic;
        data_cnt      : std_logic_vector(11 downto 0);
    end record;

    type t_chamber_infifo_rd_array is array(integer range <>) of t_chamber_infifo_rd;

    type t_chamber_evtfifo_rd is record
        dout          : std_logic_vector(59 downto 0);
        rd_en         : std_logic;
        empty         : std_logic;
        valid         : std_logic;
        underflow     : std_logic;
        data_cnt      : std_logic_vector(11 downto 0);
    end record;

    type t_chamber_evtfifo_rd_array is array(integer range <>) of t_chamber_evtfifo_rd;

    --====================--
    --==     OH Link    ==--
    --====================--

    type t_sync_fifo_status is record
        ovf         : std_logic;
        unf         : std_logic;
    end record;
    
    type t_gt_status is record
        not_in_table    : std_logic;
        disperr         : std_logic;
    end record;

    type t_oh_link_status is record
        tk_error            : std_logic;
        evt_rcvd            : std_logic;
        tk_tx_sync_status   : t_sync_fifo_status;      
        tk_rx_sync_status   : t_sync_fifo_status;      
        tr0_rx_sync_status  : t_sync_fifo_status;      
        tr1_rx_sync_status  : t_sync_fifo_status;
        tk_rx_gt_status     : t_gt_status;     
        tr0_rx_gt_status    : t_gt_status;     
        tr1_rx_gt_status    : t_gt_status;     
    end record;
    
    type t_oh_link_status_arr is array(integer range <>) of t_oh_link_status;    
        
    --================--
    --== T1 command ==--
    --================--
    
    type t_t1 is record
        lv1a        : std_logic;
        calpulse    : std_logic;
        resync      : std_logic;
        bc0         : std_logic;
    end record;
    
    type t_t1_array is array(integer range <>) of t_t1;
	
end gem_pkg;
   
package body gem_pkg is

    function count_ones(s : std_logic_vector) return integer is
        variable temp : natural := 0;
    begin
        for i in s'range loop
            if s(i) = '1' then
                temp := temp + 1;
            end if;
        end loop;

        return temp;
    end function count_ones;

    function bool_to_std_logic(L : BOOLEAN) return std_logic is
    begin
        if L then
            return ('1');
        else
            return ('0');
        end if;
    end function bool_to_std_logic;
    
end gem_pkg;
