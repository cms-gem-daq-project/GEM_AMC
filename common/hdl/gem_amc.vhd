------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    23:45:21 2016-04-20
-- Module Name:    GEM_AMC 
-- Description:    This is the top module of all the common GEM AMC logic. It is board-agnostic and can be used in different FPGA / board designs 
------------------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.gem_pkg.all;
use work.gem_board_config_package.all;
use work.ipb_addr_decode.all;
use work.ipbus.all;
use work.ttc_pkg.all;
use work.vendor_specific_gbt_bank_package.all;

entity gem_amc is
    generic(
        g_NUM_OF_OHs         : integer;
        g_USE_GBT            : boolean := true;  -- if this is true, GBT links will be used for communicationa with OH, if false 3.2Gbs 8b10b links will be used instead (remember to instanciate the correct links!)
        g_USE_3x_GBTs        : boolean := false; -- if this is true, each OH will use 3 GBT links - this will be default in the future with OH v3, but for now it's a good test
        g_USE_TRIG_LINKS     : boolean := true;  -- this should be TRUE by default, but could be set to false for tests or quicker compilation if not needed
        
        g_NUM_IPB_SLAVES     : integer;
        g_DAQ_CLK_FREQ       : integer
    );
    port(
        reset_i                 : in   std_logic;
        reset_pwrup_o           : out  std_logic;

        -- TTC
        ttc_data_p_i            : in  std_logic;      -- TTC protocol backplane signals
        ttc_data_n_i            : in  std_logic;
        ttc_clocks_i            : in  t_ttc_clks;
        ttc_clocks_status_i     : in  t_ttc_clk_status;
        ttc_clocks_ctrl_o       : out t_ttc_clk_ctrl;
        
        -- 8b10b DAQ + Control GTX / GTH links (3.2Gbs, 16bit @ 160MHz w/ 8b10b encoding)
        gt_8b10b_rx_clk_arr_i   : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_8b10b_tx_clk_arr_i   : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_8b10b_rx_data_arr_i  : in  t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
        gt_8b10b_tx_data_arr_o  : out t_gt_8b10b_tx_data_arr(g_NUM_OF_OHs - 1 downto 0);

        -- Trigger RX GTX / GTH links (3.2Gbs, 16bit @ 160MHz w/ 8b10b encoding)
        gt_trig0_rx_clk_arr_i   : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_trig0_rx_data_arr_i  : in  t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
        gt_trig1_rx_clk_arr_i   : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_trig1_rx_data_arr_i  : in  t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);

        -- GBT DAQ + Control GTX / GTH links (4.8Gbs, 40bit @ 120MHz without 8b10b encoding)
        gt_gbt_rx_common_clk_i  : in  std_logic;
        gt_gbt_rx_links_arr_i   : in  t_gbt_mgt_rx_links_arr(g_NUM_OF_OHs - 1 downto 0);
        gt_gbt_tx_links_arr_o   : out t_gbt_mgt_tx_links_arr(g_NUM_OF_OHs - 1 downto 0);
        gt_gbt_tx0_clk_arr_i    : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_gbt_tx1_clk_arr_i    : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
        gt_gbt_tx2_clk_arr_i    : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);

        -- IPbus
        ipb_reset_i             : in  std_logic;
        ipb_clk_i               : in  std_logic;
        ipb_miso_arr_o          : out ipb_rbus_array(g_NUM_IPB_SLAVES - 1 downto 0);
        ipb_mosi_arr_i          : in  ipb_wbus_array(g_NUM_IPB_SLAVES - 1 downto 0);
        
        -- LEDs
        led_l1a_o               : out std_logic;
        led_trigger_o           : out std_logic;
        
        -- DAQLink
        daq_data_clk_i          : in  std_logic;
        daq_data_clk_locked_i   : in  std_logic;
        daq_to_daqlink_o        : out t_daq_to_daqlink;
        daqlink_to_daq_i        : in  t_daqlink_to_daq;
        
        -- Board serial number
        board_id_i              : in std_logic_vector(15 downto 0)
        
    );
end gem_amc;

architecture gem_amc_arch of gem_amc is

    --================================--
    -- Components  
    --================================--

    component ila_gbt
        port(
            clk     : IN STD_LOGIC;
            probe0  : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
            probe1  : IN STD_LOGIC_VECTOR(83 DOWNTO 0);
            probe2  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe3  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe4  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe5  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe6  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe7  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe8  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe9  : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe10 : IN STD_LOGIC_VECTOR(5 DOWNTO 0)
        );
    end component;

    --================================--
    -- Signals
    --================================--

    --== General ==--
    signal reset            : std_logic;
    signal reset_pwrup      : std_logic;
    signal ipb_reset        : std_logic;

    --== TTC signals ==--
    signal ttc_cmd          : t_ttc_cmds;
    signal ttc_counters     : t_ttc_daq_cntrs;
    signal ttc_status       : t_ttc_status;
    signal daq_resync_done  : std_logic;

    --== DAQ signals ==--    
    signal tk_data_links    : t_data_link_array(g_NUM_OF_OHs - 1 downto 0);
    
    --== Trigger signals ==--    
    signal sbit_clusters_arr        : t_oh_sbits_arr(g_NUM_OF_OHs - 1 downto 0);
    signal sbit_links_status_arr    : t_oh_sbit_links_arr(g_NUM_OF_OHs - 1 downto 0);
    
    signal gt_trig0_rx_clk_arr      : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gt_trig0_rx_data_arr     : t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal gt_trig1_rx_clk_arr      : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gt_trig1_rx_data_arr     : t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    
    --== OH links ==--
    signal oh_8b10b_rx_data_arr         : t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal oh_8b10b_tx_data_arr         : t_gt_8b10b_tx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal oh_trig0_rx_data_arr         : t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal oh_trig1_rx_data_arr         : t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);    
    signal oh_link_status_arr           : t_oh_link_status_arr(g_NUM_OF_OHs - 1 downto 0);    
    signal oh_link_tk_error_arr         : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal oh_link_evt_rcvd_arr         : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);

    --== GBT ==--
    signal gbt_tx_we_arr                : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_tx_data_arr              : t_gbt_frame_array(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_tx_sca_data_arr          : t_std2_array(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_tx_ic_data_arr           : t_std2_array(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_tx_gearbox_aligned_arr   : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_tx_gearbox_align_done_arr: std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_mgt_tx_data_arr          : t_gt_gbt_tx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_mgt_tx_clk_arr           : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
            
    signal gbt_rx_valid_arr             : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_data_arr              : t_gbt_frame_array(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_sca_data_arr          : t_std2_array(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_ic_data_arr           : t_std2_array(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_header                : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_header_locked         : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_ready                 : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_frame_clk_ready       : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_word_clk_ready        : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_rx_bitslip_nbr           : rxBitSlipNbr_mxnbit_A(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_mgt_rx_data_arr          : t_gt_gbt_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal gbt_mgt_rx_ready_arr         : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);    
    signal gbt_mgt_rx_clk_arr           : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);

    -- OHv2 GBT links
    signal ohv2_gbt_rx_data_arr         : t_gbt_frame_array(g_NUM_OF_OHs - 1 downto 0);
    signal ohv2_gbt_tx_data_arr         : t_gbt_frame_array(g_NUM_OF_OHs - 1 downto 0);
    signal ohv2_gbt_ready_arr           : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    
    -- test module links
    signal test_gbt_rx_data_arr         : t_gbt_frame_array((g_NUM_OF_OHs * 3) - 1 downto 0);
    signal test_gbt_tx_data_arr         : t_gbt_frame_array((g_NUM_OF_OHs * 3) - 1 downto 0);
    signal test_gbt_ready_arr           : std_logic_vector((g_NUM_OF_OHs * 3) - 1 downto 0);
        
    signal test_8b10b_rx_data_arr       : t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal test_8b10b_tx_data_arr       : t_gt_8b10b_tx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal test_trig0_rx_data_arr       : t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    signal test_trig1_rx_data_arr       : t_gt_8b10b_rx_data_arr(g_NUM_OF_OHs - 1 downto 0);
    

    --== GBT fake links ==--
    signal gbt_fake_tx_data_arr         : t_gbt_frame_array((g_NUM_OF_OHs * 2) - 1 downto 0);
    signal gbt_fake_mgt_tx_data_arr     : t_gt_gbt_tx_data_arr((g_NUM_OF_OHs * 2) - 1 downto 0);
    signal gbt_fake_mgt_tx_clk_arr      : std_logic_vector((g_NUM_OF_OHs * 2) - 1 downto 0);
            
    signal gbt_fake_rx_valid_arr        : std_logic_vector((g_NUM_OF_OHs * 2) - 1 downto 0);
    signal gbt_fake_rx_ready_arr        : std_logic_vector((g_NUM_OF_OHs * 2) - 1 downto 0);
    signal gbt_fake_rx_data_arr         : t_gbt_frame_array((g_NUM_OF_OHs * 2) - 1 downto 0);
    signal gbt_fake_mgt_rx_data_arr     : t_gt_gbt_rx_data_arr((g_NUM_OF_OHs * 2) - 1 downto 0);
    signal gbt_fake_mgt_rx_clk_arr      : std_logic_vector((g_NUM_OF_OHs * 2) - 1 downto 0);

    --== TEST module ==--
    signal loopback_gbt_test_en         : std_logic; 
    signal loopback_8b10b_test_en       : std_logic;
    signal loopback_8b10b_use_trig      : std_logic;
    
    --== Other ==--
    signal ipb_miso_arr     : ipb_rbus_array(g_NUM_IPB_SLAVES - 1 downto 0) := (others => (ipb_rdata => (others => '0'), ipb_ack => '0', ipb_err => '0'));
    
    -------- DEBUG --------
    signal fake_tk_data_links    : t_data_link_array(g_NUM_OF_OHs - 1 downto 0);

begin

    --================================--
    -- Power-on reset  
    --================================--
    
    reset_pwrup_o <= reset_pwrup;
    reset <= reset_i or reset_pwrup; -- TODO: Add a global reset from IPbus
    ipb_reset <= ipb_reset_i or reset_pwrup;
    ipb_miso_arr_o <= ipb_miso_arr;

    g_real_trig_links : if (g_USE_TRIG_LINKS) generate
        gt_trig0_rx_clk_arr <= gt_trig0_rx_clk_arr_i;
        gt_trig1_rx_clk_arr <= gt_trig1_rx_clk_arr_i;
        
        gt_trig0_rx_data_arr <= gt_trig0_rx_data_arr_i;
        gt_trig1_rx_data_arr <= gt_trig1_rx_data_arr_i;
    end generate;
    
    g_fake_trig_links : if (not g_USE_TRIG_LINKS) generate
        gt_trig0_rx_clk_arr <= (others => '0');
        gt_trig1_rx_clk_arr <= (others => '0');

        gt_trig0_rx_data_arr <= (others => (rxdata => (others => ('0')), rxcharisk => (others => '0'), rxchariscomma => (others => '0'), rxnotintable => (others => '0'), rxdisperr => (others => '0'), rxcommadet => '0', rxbyterealign => '0', rxbyteisaligned => '0'));
        gt_trig1_rx_data_arr <= (others => (rxdata => (others => ('0')), rxcharisk => (others => '0'), rxchariscomma => (others => '0'), rxnotintable => (others => '0'), rxdisperr => (others => '0'), rxcommadet => '0', rxbyterealign => '0', rxbyteisaligned => '0'));
    end generate;

    --================================--
    -- Power-on reset  
    --================================--
    
    process(ttc_clocks_i.clk_40) -- NOTE: using TTC clock, no nothing will work if there's no TTC clock
        variable countdown : integer := 40_000_000; -- 1s - probably way too long, but ok for now (this is only used after powerup)
    begin
        if (rising_edge(ttc_clocks_i.clk_40)) then
            if (countdown > 0) then
              reset_pwrup <= '1';
              countdown := countdown - 1;
            else
              reset_pwrup <= '0';
            end if;
        end if;
    end process;    
    
    --================================--
    -- TTC  
    --================================--

    i_ttc : entity work.ttc
        port map(
            reset_i             => reset,
            ttc_clks_i          => ttc_clocks_i,
            ttc_clks_status_i   => ttc_clocks_status_i,
            ttc_clks_ctrl_o     => ttc_clocks_ctrl_o,
            ttc_data_p_i        => ttc_data_p_i,
            ttc_data_n_i        => ttc_data_n_i,
            ttc_cmds_o          => ttc_cmd,
            ttc_daq_cntrs_o     => ttc_counters,
            ttc_status_o        => ttc_status,
            l1a_led_o           => led_l1a_o,
            ipb_reset_i         => ipb_reset,
            ipb_clk_i           => ipb_clk_i,
            ipb_mosi_i          => ipb_mosi_arr_i(C_IPB_SLV.ttc),
            ipb_miso_o          => ipb_miso_arr(C_IPB_SLV.ttc)
        );
    
    --================================--
    -- Optohybrids  
    --================================--
    
    i_optohybrids : for i in 0 to g_NUM_OF_OHs - 1 generate

        i_optohybrid_single : entity work.optohybrid
            generic map(
                g_USE_GBT       => g_USE_GBT,
                g_DEBUG         => TRUE
            )
            port map(
                reset_i                 => reset,
                ttc_clk_i               => ttc_clocks_i,
                ttc_cmds_i              => ttc_cmd,
                resync_i                => daq_resync_done,

                gth_rx_data_i           => oh_8b10b_rx_data_arr(i),
                gth_tx_data_o           => oh_8b10b_tx_data_arr(i),

                gbt_rx_ready_i          => ohv2_gbt_ready_arr(i),
                gbt_rx_data_i           => ohv2_gbt_rx_data_arr(i),
                gbt_tx_data_o           => ohv2_gbt_tx_data_arr(i),

                sbit_clusters_o         => sbit_clusters_arr(i), 
                sbit_links_status_o     => sbit_links_status_arr(i), 
                gth_rx_trig_data_i      => (oh_trig0_rx_data_arr(i), oh_trig1_rx_data_arr(i)),

                tk_data_link_o          => tk_data_links(i),
                tk_error_o              => oh_link_tk_error_arr(i),
                tk_evt_received_o       => oh_link_evt_rcvd_arr(i),

                oh_reg_ipb_reset_i      => ipb_reset,
                oh_reg_ipb_clk_i        => ipb_clk_i,
                oh_reg_ipb_reg_miso_o   => ipb_miso_arr(C_IPB_SLV.oh_reg(i)),
                oh_reg_ipb_reg_mosi_i   => ipb_mosi_arr_i(C_IPB_SLV.oh_reg(i))
            );    
    
    end generate;

    --================================--
    -- Trigger  
    --================================--

    i_trigger : entity work.trigger
        generic map(
            g_NUM_OF_OHs => g_NUM_OF_OHs
        )
        port map(
            reset_i            => reset,
            ttc_clk_i          => ttc_clocks_i,
            ttc_cmds_i         => ttc_cmd,
            sbit_clusters_i    => sbit_clusters_arr,
            sbit_link_status_i => sbit_links_status_arr,
            trig_led_o         => led_trigger_o,
            ipb_reset_i        => ipb_reset,
            ipb_clk_i          => ipb_clk_i,
            ipb_miso_o         => ipb_miso_arr(C_IPB_SLV.trigger),
            ipb_mosi_i         => ipb_mosi_arr_i(C_IPB_SLV.trigger)
        );

    --================================--
    -- DAQ  
    --================================--

    i_daq : entity work.daq
        generic map(
            g_NUM_OF_OHs => g_NUM_OF_OHs,
            g_DAQ_CLK_FREQ => g_DAQ_CLK_FREQ,
            g_DEBUG => false
        )
        port map(
            reset_i             => reset,
            daq_clk_i           => daq_data_clk_i,
            daq_clk_locked_i    => daq_data_clk_locked_i,
            daq_to_daqlink_o    => daq_to_daqlink_o,
            daqlink_to_daq_i    => daqlink_to_daq_i,
            ttc_clks_i          => ttc_clocks_i,
            ttc_cmds_i          => ttc_cmd,
            ttc_daq_cntrs_i     => ttc_counters,
            ttc_status_i        => ttc_status,
            resync_frontend_o   => daq_resync_done,
            tk_data_links_i     => tk_data_links,
            ipb_reset_i         => ipb_reset_i,
            ipb_clk_i           => ipb_clk_i,
            ipb_mosi_i          => ipb_mosi_arr_i(C_IPB_SLV.daq),
            ipb_miso_o          => ipb_miso_arr(C_IPB_SLV.daq),
            board_sn_i          => board_id_i
        );    

    ------------ DEBUG - fanout DAQ data from OH1 to all DAQ inputs --------------
--    g_fake_daq_links : for i in 0 to g_NUM_OF_OHs - 1 generate
--        fake_tk_data_links(i) <= tk_data_links(1);
--    end generate;

    --================================--
    -- GEM System
    --================================--

    i_gem_system : entity work.gem_system_regs
        port map(
            ttc_clks_i                  => ttc_clocks_i,            
            reset_i                     => reset,
            ipb_clk_i                   => ipb_clk_i,
            ipb_reset_i                 => ipb_reset_i,
            ipb_mosi_i                  => ipb_mosi_arr_i(C_IPB_SLV.system),
            ipb_miso_o                  => ipb_miso_arr(C_IPB_SLV.system),
            tk_rx_polarity_o            => open,
            tk_tx_polarity_o            => open,
            board_id_o                  => open,
            loopback_gbt_test_en_o      => loopback_gbt_test_en,
            loopback_8b10b_test_en_o    => loopback_8b10b_test_en,
            loopback_8b10b_use_trig_o   => loopback_8b10b_use_trig
        );

    --==================--
    -- OH Link Counters --
    --==================--

    i_oh_link_registers : entity work.oh_link_regs
        generic map(
            g_NUM_OF_OHs => g_NUM_OF_OHs
        )
        port map(
            reset_i                => reset,
            clk_i                  => ttc_clocks_i.clk_160,

            oh_link_status_arr_i   => oh_link_status_arr,

            ipb_reset_i            => ipb_reset_i,
            ipb_clk_i              => ipb_clk_i,
            ipb_miso_o             => ipb_miso_arr(C_IPB_SLV.oh_links),
            ipb_mosi_i             => ipb_mosi_arr_i(C_IPB_SLV.oh_links)
        );

    --=====================--
    --    8b10b link MUX   --
    --=====================--
    
    i_8b10b_link_mux : entity work.link_hub
        generic map(
            g_NUM_OF_OHs => g_NUM_OF_OHs,
            g_USE_GBT    => g_USE_GBT
        )
        port map(
            reset_i                 => reset_i,
            ttc_clks_i              => ttc_clocks_i,
            gt_8b10b_rx_usrclk_i    => gt_8b10b_rx_clk_arr_i,
            gt_8b10b_tx_usrclk_i    => gt_8b10b_tx_clk_arr_i,
            gt_trig0_rx_usrclk_i    => gt_trig0_rx_clk_arr,
            gt_trig1_rx_usrclk_i    => gt_trig1_rx_clk_arr,
            gt_8b10b_rx_data_arr_i  => gt_8b10b_rx_data_arr_i,
            gt_8b10b_tx_data_arr_o  => gt_8b10b_tx_data_arr_o,
            gt_trig0_rx_data_arr_i  => gt_trig0_rx_data_arr,
            gt_trig1_rx_data_arr_i  => gt_trig1_rx_data_arr,
            oh_link_tk_error_arr_i  => oh_link_tk_error_arr,
            oh_link_evt_rcvd_arr_i  => oh_link_evt_rcvd_arr,            
            daq_link_test_mode_i    => loopback_8b10b_test_en,
            trig_link_test_mode_i   => loopback_8b10b_use_trig,
            oh_8b10b_rx_data_arr_o  => oh_8b10b_rx_data_arr,
            oh_8b10b_tx_data_arr_i  => oh_8b10b_tx_data_arr,
            oh_trig0_rx_data_arr_o  => oh_trig0_rx_data_arr,
            oh_trig1_rx_data_arr_o  => oh_trig1_rx_data_arr,
            tst_8b10b_rx_data_arr_o => test_8b10b_rx_data_arr,
            tst_8b10b_tx_data_arr_i => test_8b10b_tx_data_arr,
            tst_trig0_rx_data_arr_o => test_trig0_rx_data_arr,
            tst_trig1_rx_data_arr_o => test_trig1_rx_data_arr,
            link_status_arr_o       => oh_link_status_arr
        );

    --===================--
    --    Slow Control   --
    --===================--

    g_slow_control: if g_USE_GBT generate
        i_slow_control : entity work.slow_control
            generic map(
                g_NUM_OF_OHs => g_NUM_OF_OHs,
                g_USE_GBT    => g_USE_GBT,
                g_DEBUG      => false
            )
            port map(
                reset_i             => reset,
                ttc_clk_i           => ttc_clocks_i,
                ttc_cmds_i          => ttc_cmd,
                gbt_rx_ready_i      => ohv2_gbt_ready_arr,
                gbt_rx_sca_elinks_i => gbt_rx_sca_data_arr,
                gbt_tx_sca_elinks_o => gbt_tx_sca_data_arr,
                gbt_rx_ic_elinks_i  => gbt_rx_ic_data_arr,
                gbt_tx_ic_elinks_o  => gbt_tx_ic_data_arr,
                ipb_reset_i         => ipb_reset_i,
                ipb_clk_i           => ipb_clk_i,
                ipb_miso_o          => ipb_miso_arr(C_IPB_SLV.slow_control),
                ipb_mosi_i          => ipb_mosi_arr_i(C_IPB_SLV.slow_control)
            );
    end generate;

    --==========--
    --    GBT   --
    --==========--
    
    g_gbt : if g_USE_GBT generate
    
        i_gbt : entity work.gbt
            generic map(
                GBT_BANK_ID     => 0,
                NUM_LINKS       => g_NUM_OF_OHs,
                TX_OPTIMIZATION => 1,
                RX_OPTIMIZATION => 0,
                TX_ENCODING     => 0,
                RX_ENCODING     => 0
            )
            port map(
                reset_i                     => reset,
                tx_frame_clk_i              => ttc_clocks_i.clk_40,
                rx_frame_clk_i              => ttc_clocks_i.clk_40,
                rx_word_common_clk_i        => gt_gbt_rx_common_clk_i,
                tx_word_clk_arr_i           => gbt_mgt_tx_clk_arr,
                rx_word_clk_arr_i           => gbt_mgt_rx_clk_arr,
                tx_ready_arr_i              => (others => '1'),
                tx_we_arr_i                 => (others => '1'),
                tx_data_arr_i               => gbt_tx_data_arr,
                tx_sca_data_arr_i           => gbt_tx_sca_data_arr, -- !!!!!!!!!!!!! MOVE THIS TO OH !!!!!!!!!!!!
                tx_ic_data_arr_i            => gbt_tx_ic_data_arr, -- !!!!!!!!!!!!! MOVE THIS TO OH !!!!!!!!!!!!
                tx_gearbox_aligned_arr_o    => gbt_tx_gearbox_aligned_arr,
                tx_gearbox_align_done_arr_o => gbt_tx_gearbox_align_done_arr,
                rx_frame_clk_rdy_arr_i      => gbt_rx_frame_clk_ready,
                rx_word_clk_rdy_arr_i       => gbt_rx_word_clk_ready,
                rx_rdy_arr_o                => gbt_rx_ready,
                rx_bitslip_nbr_arr_o        => gbt_rx_bitslip_nbr,
                rx_header_arr_o             => gbt_rx_header,
                rx_header_locked_arr_o      => gbt_rx_header_locked,
                rx_data_valid_arr_o         => gbt_rx_valid_arr,
                rx_data_arr_o               => gbt_rx_data_arr,
                rx_sca_data_arr_o           => gbt_rx_sca_data_arr,
                rx_ic_data_arr_o            => gbt_rx_ic_data_arr,
                mgt_rx_rdy_arr_i            => gbt_mgt_rx_ready_arr,
                mgt_tx_data_arr_o           => gbt_mgt_tx_data_arr,
                mgt_rx_data_arr_i           => gbt_mgt_rx_data_arr
            );
        
        -- 3x GBT test for resource utilization testing for future OH v3        
        g_3x_gbt_fake_gbt_cores : if g_USE_3x_GBTs generate
            i_gbt : entity work.gbt
                generic map(
                    GBT_BANK_ID     => 0,
                    NUM_LINKS       => g_NUM_OF_OHs * 2,
                    TX_OPTIMIZATION => 0,
                    RX_OPTIMIZATION => 0,
                    TX_ENCODING     => 0,
                    RX_ENCODING     => 0
                )
                port map(
                    reset_i                     => reset,
                    tx_frame_clk_i              => ttc_clocks_i.clk_40,
                    rx_frame_clk_i              => ttc_clocks_i.clk_40,
                    rx_word_common_clk_i        => gt_gbt_rx_common_clk_i,
                    tx_word_clk_arr_i           => gbt_fake_mgt_tx_clk_arr,
                    rx_word_clk_arr_i           => gbt_fake_mgt_rx_clk_arr,
                    tx_ready_arr_i              => (others => '1'),
                    tx_we_arr_i                 => (others => not reset),
                    tx_data_arr_i               => gbt_fake_tx_data_arr,
                    tx_sca_data_arr_i           => (others => "00"),
                    tx_ic_data_arr_i            => (others => "00"),
                    tx_gearbox_aligned_arr_o    => open,
                    tx_gearbox_align_done_arr_o => open,
                    rx_frame_clk_rdy_arr_i      => (others => '1'),
                    rx_word_clk_rdy_arr_i       => (others => '1'),
                    rx_rdy_arr_o                => gbt_fake_rx_ready_arr,
                    rx_bitslip_nbr_arr_o        => open,
                    rx_header_arr_o             => open,
                    rx_header_locked_arr_o      => open,
                    rx_data_valid_arr_o         => gbt_fake_rx_valid_arr,
                    rx_data_arr_o               => gbt_fake_rx_data_arr,
                    mgt_rx_rdy_arr_i            => (others => '1'),
                    mgt_tx_data_arr_o           => gbt_fake_mgt_tx_data_arr,
                    mgt_rx_data_arr_i           => gbt_fake_mgt_rx_data_arr
                );        
        end generate;
        
        
        g_gbt_tx_clks: for i in 0 to g_NUM_OF_OHs - 1 generate
            gbt_mgt_tx_clk_arr(i) <= gt_gbt_tx0_clk_arr_i(i);
            gt_gbt_tx_links_arr_o(i).tx0data <= gbt_mgt_tx_data_arr(i);
            
            gbt_mgt_rx_clk_arr(i) <= gt_gbt_rx_links_arr_i(i).rx0clk;
            gbt_mgt_rx_data_arr(i) <= gt_gbt_rx_links_arr_i(i).rx0data;
    
            -- 3x GBT test for resource utilization testing for future OH v3        
            g_3x_gbt_fake_links : if g_USE_3x_GBTs generate               
                gt_gbt_tx_links_arr_o(i).tx1data        <= gbt_fake_mgt_tx_data_arr(i * 2); 
                gt_gbt_tx_links_arr_o(i).tx2data        <= gbt_fake_mgt_tx_data_arr((i * 2) + 1);
    
                gbt_fake_mgt_rx_data_arr(i * 2)         <= gt_gbt_rx_links_arr_i(i).rx1data;
                gbt_fake_mgt_rx_data_arr((i * 2) + 1)   <= gt_gbt_rx_links_arr_i(i).rx2data;
                
                gbt_fake_mgt_tx_clk_arr(i * 2)          <= gt_gbt_tx1_clk_arr_i(i);
                gbt_fake_mgt_tx_clk_arr((i * 2) + 1)    <= gt_gbt_tx2_clk_arr_i(i);
                
                gbt_fake_mgt_rx_clk_arr(i * 2)          <= gt_gbt_rx_links_arr_i(i).rx1clk;
                gbt_fake_mgt_rx_clk_arr((i * 2) + 1)    <= gt_gbt_rx_links_arr_i(i).rx2clk;
            end generate;
                    
        end generate;
        
        gbt_rx_frame_clk_ready <= (others => '1');
        gbt_rx_word_clk_ready <= (others => '1');
        gbt_mgt_rx_ready_arr <= (others => '1');
    
        i_gbt_link_mux : entity work.gbt_link_mux
            generic map(
                g_NUM_OF_OHs  => g_NUM_OF_OHs,
                g_USE_3x_GBTs => g_USE_3x_GBTs
            )
            port map(
                gbt_rx_data_arr_i           => gbt_rx_data_arr,
                gbt_tx_data_arr_o           => gbt_tx_data_arr,
                gbt_rx_ready_arr_i          => gbt_rx_ready,
                gbt_rx_valid_arr_i          => gbt_rx_valid_arr,
                extra_gbt_rx_data_arr_i     => gbt_fake_rx_data_arr,
                extra_gbt_tx_data_arr_o     => gbt_fake_tx_data_arr,
                extra_gbt_rx_ready_arr_i    => gbt_fake_rx_ready_arr,
                extra_gbt_rx_valid_arr_i    => gbt_fake_rx_valid_arr,
                link_test_mode_i            => loopback_gbt_test_en,
                ohv2_gbt_rx_data_arr_o      => ohv2_gbt_rx_data_arr,
                ohv2_gbt_tx_data_arr_i      => ohv2_gbt_tx_data_arr,
                ohv2_gbt_ready_arr_o        => ohv2_gbt_ready_arr,
                tst_gbt_rx_data_arr_o       => test_gbt_rx_data_arr,
                tst_gbt_tx_data_arr_i       => test_gbt_tx_data_arr,
                tst_gbt_ready_arr_o         => test_gbt_ready_arr
            );    
    
        i_ila_gbt : component ila_gbt
            port map(
                clk     => ttc_clocks_i.clk_40,
                probe0  => gbt_tx_ic_data_arr(1) & gbt_tx_sca_data_arr(1) & gbt_tx_data_arr(1)(79 downto 0),
                probe1  => gbt_rx_data_arr(1),
                probe2  => gbt_tx_gearbox_aligned_arr(1 downto 1),
                probe3  => gbt_tx_gearbox_align_done_arr(1 downto 1),
                probe4  => gbt_rx_frame_clk_ready(1 downto 1),
                probe5  => gbt_rx_word_clk_ready(1 downto 1),
                probe6  => gbt_rx_ready(1 downto 1),
                probe7  => gbt_rx_header(1 downto 1),
                probe8  => gbt_rx_header_locked(1 downto 1),
                probe9  => gbt_rx_valid_arr(1 downto 1),
                probe10 => gbt_rx_bitslip_nbr(1)
            );
        
    end generate g_gbt;
    
    --=============--
    --    Tests    --
    --=============--
    
    i_gem_tests : entity work.gem_tests
        generic map(
            g_NUM_OF_OHs => g_NUM_OF_OHs,
            g_NUM_GBT_LINKS => g_NUM_OF_OHs * 3
        )
        port map(
            reset_i                     => reset_i,
            ttc_clk_i                   => ttc_clocks_i,
            ttc_cmds_i                  => ttc_cmd,
            loopback_8b10b_test_en_i    => loopback_8b10b_test_en,
            loopback_gbt_test_en_i      => loopback_gbt_test_en,
            loopback_8b10b_use_trig_i   => loopback_8b10b_use_trig,
            daq_8b10b_tx_data_arr_o     => test_8b10b_tx_data_arr,
            daq_8b10b_rx_data_arr_i     => test_8b10b_rx_data_arr,
            trig0_8b10b_rx_data_arr_i   => test_trig0_rx_data_arr,
            trig1_8b10b_rx_data_arr_i   => test_trig1_rx_data_arr,
            gbt_link_ready_i            => test_gbt_ready_arr,
            gbt_tx_data_arr_o           => test_gbt_tx_data_arr,
            gbt_rx_data_arr_i           => test_gbt_rx_data_arr,
            ipb_reset_i                 => ipb_reset,
            ipb_clk_i                   => ipb_clk_i,
            ipb_mosi_i                  => ipb_mosi_arr_i(C_IPB_SLV.test),
            ipb_miso_o                  => ipb_miso_arr(C_IPB_SLV.test)
        );

    --=============--
    --    Debug    --
    --=============--    
    
--    i_8b10b_raw_tx_ila_inst : entity work.gt_tx_link_ila_wrapper
--        port map(
--            clk_i => gt_8b10b_tx_clk_arr_i(0),
--            kchar_i => gt_8b10b_tx_data_arr(0).txcharisk(1 downto 0),
--            data_i => gt_8b10b_tx_data_arr(0).txdata(15 downto 0)
--        );    
--
--    i_8b10b_oh_tx_ila_inst : entity work.gt_tx_link_ila_wrapper
--        port map(
--            clk_i => ttc_clocks_i.clk_160,
--            kchar_i => oh_8b10b_tx_data_arr(0).txcharisk(1 downto 0),
--            data_i => oh_8b10b_tx_data_arr(0).txdata(15 downto 0)
--        );    
--
--    i_8b10b_test_tx_ila_inst : entity work.gt_tx_link_ila_wrapper
--        port map(
--            clk_i => ttc_clocks_i.clk_160,
--            kchar_i => test_8b10b_tx_data_arr(0).txcharisk(1 downto 0),
--            data_i => test_8b10b_tx_data_arr(0).txdata(15 downto 0)
--        );    
--
--    i_8b10b_raw_rx_ila_inst : entity work.gt_rx_link_ila_wrapper
--        port map(
--            clk_i => gt_8b10b_rx_clk_arr_i(0),
--            kchar_i => gt_8b10b_rx_data_arr_i(0).rxcharisk(1 downto 0),
--            comma_i => gt_8b10b_rx_data_arr_i(0).rxchariscomma(1 downto 0),
--            not_in_table_i => gt_8b10b_rx_data_arr_i(0).rxnotintable(1 downto 0),
--            disperr_i => gt_8b10b_rx_data_arr_i(0).rxdisperr(1 downto 0),
--            data_i => gt_8b10b_rx_data_arr_i(0).rxdata(15 downto 0)
--        );
--           
--    i_8b10b_oh_rx_ila_inst : entity work.gt_rx_link_ila_wrapper
--        port map(
--            clk_i => ttc_clocks_i.clk_160,
--            kchar_i => oh_8b10b_rx_data_arr(0).rxcharisk(1 downto 0),
--            comma_i => oh_8b10b_rx_data_arr(0).rxchariscomma(1 downto 0),
--            not_in_table_i => oh_8b10b_rx_data_arr(0).rxnotintable(1 downto 0),
--            disperr_i => oh_8b10b_rx_data_arr(0).rxdisperr(1 downto 0),
--            data_i => oh_8b10b_rx_data_arr(0).rxdata(15 downto 0)
--        );
--           
--    i_8b10b_test_rx_ila_inst : entity work.gt_rx_link_ila_wrapper
--        port map(
--            clk_i => ttc_clocks_i.clk_160,
--            kchar_i => test_8b10b_rx_data_arr(0).rxcharisk(1 downto 0),
--            comma_i => test_8b10b_rx_data_arr(0).rxchariscomma(1 downto 0),
--            not_in_table_i => test_8b10b_rx_data_arr(0).rxnotintable(1 downto 0),
--            disperr_i => test_8b10b_rx_data_arr(0).rxdisperr(1 downto 0),
--            data_i => test_8b10b_rx_data_arr(0).rxdata(15 downto 0)
--        );   
        
end gem_amc_arch;
