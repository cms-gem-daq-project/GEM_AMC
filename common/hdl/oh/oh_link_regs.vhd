------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    12:22 2016-05-10
-- Module Name:    trigger
-- Description:    This module handles everything related to sbit cluster data (link synchronization, monitoring, local triggering, matching to L1A and reporting data to DAQ)  
------------------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

use work.gem_pkg.all;
use work.ttc_pkg.all;
use work.ipbus.all;
use work.registers.all;

entity oh_link_regs is
    generic(
        g_NUM_OF_OHs : integer := 1
    );
    port(
        -- reset
        reset_i                : in  std_logic;
        clk_i                  : in  std_logic;

        -- Link statuses
        oh_link_status_arr_i   : in  t_oh_link_status_arr(g_NUM_OF_OHs - 1 downto 0);
        gbt_rx_sync_done_arr_i : in  std_logic_vector(g_NUM_OF_OHs - 1 downto 0);

        -- IPbus
        ipb_reset_i            : in  std_logic;
        ipb_clk_i              : in  std_logic;
        ipb_miso_o             : out ipb_rbus;
        ipb_mosi_i             : in  ipb_wbus
    );
end oh_link_regs;

architecture oh_link_regs_arch of oh_link_regs is
    
    --=== resets ===--
    
    signal reset_global         : std_logic;
    signal reset_local          : std_logic;
    signal reset                : std_logic;
    
    --=== counters ===--
    
    signal tk_error_cnt_arr     : t_std32_array(g_NUM_OF_OHs - 1 downto 0);
    signal evt_rcvd_cnt_arr     : t_std32_array(g_NUM_OF_OHs - 1 downto 0);

    signal sync_tk_tx_ovf_arr   : t_std32_array(g_NUM_OF_OHs - 1 downto 0);
    signal sync_tk_tx_unf_arr   : t_std32_array(g_NUM_OF_OHs - 1 downto 0);

    signal sync_tk_rx_ovf_arr   : t_std32_array(g_NUM_OF_OHs - 1 downto 0);
    signal sync_tk_rx_unf_arr   : t_std32_array(g_NUM_OF_OHs - 1 downto 0);
       
    signal sync_tr0_rx_ovf_arr  : t_std32_array(g_NUM_OF_OHs - 1 downto 0);
    signal sync_tr0_rx_unf_arr  : t_std32_array(g_NUM_OF_OHs - 1 downto 0);

    signal sync_tr1_rx_ovf_arr  : t_std32_array(g_NUM_OF_OHs - 1 downto 0);
    signal sync_tr1_rx_unf_arr  : t_std32_array(g_NUM_OF_OHs - 1 downto 0);

    signal tk_not_in_table_arr  : t_std32_array(g_NUM_OF_OHs - 1 downto 0);
    signal tk_disperr_arr       : t_std32_array(g_NUM_OF_OHs - 1 downto 0);

    signal tr0_not_in_table_arr : t_std32_array(g_NUM_OF_OHs - 1 downto 0);
    signal tr0_disperr_arr      : t_std32_array(g_NUM_OF_OHs - 1 downto 0);

    signal tr1_not_in_table_arr : t_std32_array(g_NUM_OF_OHs - 1 downto 0);
    signal tr1_disperr_arr      : t_std32_array(g_NUM_OF_OHs - 1 downto 0);


    ------ Register signals begin (this section is generated by <gem_amc_repo_root>/scripts/generate_registers.py -- do not edit)
    signal regs_read_arr        : t_std32_array(REG_OH_LINKS_NUM_REGS - 1 downto 0);
    signal regs_write_arr       : t_std32_array(REG_OH_LINKS_NUM_REGS - 1 downto 0);
    signal regs_addresses       : t_std32_array(REG_OH_LINKS_NUM_REGS - 1 downto 0);
    signal regs_defaults        : t_std32_array(REG_OH_LINKS_NUM_REGS - 1 downto 0) := (others => (others => '0'));
    signal regs_read_pulse_arr  : std_logic_vector(REG_OH_LINKS_NUM_REGS - 1 downto 0);
    signal regs_write_pulse_arr : std_logic_vector(REG_OH_LINKS_NUM_REGS - 1 downto 0);
    signal regs_read_ready_arr  : std_logic_vector(REG_OH_LINKS_NUM_REGS - 1 downto 0) := (others => '1');
    signal regs_write_done_arr  : std_logic_vector(REG_OH_LINKS_NUM_REGS - 1 downto 0) := (others => '1');
    signal regs_writable_arr    : std_logic_vector(REG_OH_LINKS_NUM_REGS - 1 downto 0) := (others => '0');
    ------ Register signals end ----------------------------------------------
    
begin

    --== Resets ==--
    
    i_reset_sync : entity work.synchronizer
        generic map(
            N_STAGES => 3
        )
        port map(
            async_i => reset_i,
            clk_i   => clk_i,
            sync_o  => reset_global
        );

    reset <= reset_global or reset_local;
    
    i_optohybrids : for i in 0 to g_NUM_OF_OHs - 1 generate

        i_cnt_tk_error : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tk_error,
                count_o   => tk_error_cnt_arr(i)
            );
    
        i_cnt_evt_rcvd : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).evt_rcvd,
                count_o   => evt_rcvd_cnt_arr(i)
            );    
    
        i_cnt_sync_tk_tx_ovf : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tk_tx_sync_status.ovf,
                count_o   => sync_tk_tx_ovf_arr(i)
            );    
    
        i_cnt_sync_tk_tx_unf : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tk_tx_sync_status.unf,
                count_o   => sync_tk_tx_unf_arr(i)
            );    
    
        i_cnt_sync_tk_rx_ovf : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tk_rx_sync_status.ovf,
                count_o   => sync_tk_rx_ovf_arr(i)
            );    
    
        i_cnt_sync_tk_rx_unf : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tk_rx_sync_status.unf,
                count_o   => sync_tk_rx_unf_arr(i)
            );    
    
        i_cnt_sync_tr0_rx_ovf : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tr0_rx_sync_status.ovf,
                count_o   => sync_tr0_rx_ovf_arr(i)
            );    
    
        i_cnt_sync_tr0_rx_unf : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tr0_rx_sync_status.unf,
                count_o   => sync_tr0_rx_unf_arr(i)
            );    
    
        i_cnt_sync_tr1_rx_ovf : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tr1_rx_sync_status.ovf,
                count_o   => sync_tr1_rx_ovf_arr(i)
            );    
    
        i_cnt_sync_tr1_rx_unf : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tr1_rx_sync_status.unf,
                count_o   => sync_tr1_rx_unf_arr(i)
            );    
    
        i_cnt_tk_not_in_table : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tk_rx_gt_status.not_in_table,
                count_o   => tk_not_in_table_arr(i)
            );
                
        i_cnt_tk_disperr : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tk_rx_gt_status.disperr,
                count_o   => tk_disperr_arr(i)
            );
                
        i_cnt_tr0_not_in_table : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tr0_rx_gt_status.not_in_table,
                count_o   => tr0_not_in_table_arr(i)
            );
                
        i_cnt_tr0_disperr : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tr0_rx_gt_status.disperr,
                count_o   => tr0_disperr_arr(i)
            );
                
        i_cnt_tr1_not_in_table : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tr1_rx_gt_status.not_in_table,
                count_o   => tr1_not_in_table_arr(i)
            );
                
        i_cnt_tr1_disperr : entity work.counter
            generic map(
                g_COUNTER_WIDTH => 32
            )
            port map(
                ref_clk_i => clk_i,
                reset_i   => reset,
                en_i      => oh_link_status_arr_i(i).tr1_rx_gt_status.disperr,
                count_o   => tr1_disperr_arr(i)
            );
                
    end generate i_optohybrids;
    
    
    --===============================================================================================
    -- this section is generated by <gem_amc_repo_root>/scripts/generate_registers.py (do not edit) 
    --==== Registers begin ==========================================================================

    -- IPbus slave instanciation
    ipbus_slave_inst : entity work.ipbus_slave
        generic map(
           g_NUM_REGS             => REG_OH_LINKS_NUM_REGS,
           g_ADDR_HIGH_BIT        => REG_OH_LINKS_ADDRESS_MSB,
           g_ADDR_LOW_BIT         => REG_OH_LINKS_ADDRESS_LSB,
           g_USE_INDIVIDUAL_ADDRS => true
       )
       port map(
           ipb_reset_i            => ipb_reset_i,
           ipb_clk_i              => ipb_clk_i,
           ipb_mosi_i             => ipb_mosi_i,
           ipb_miso_o             => ipb_miso_o,
           usr_clk_i              => clk_i,
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
    regs_addresses(0)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"000";
    regs_addresses(1)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"100";
    regs_addresses(2)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"101";
    regs_addresses(3)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"102";
    regs_addresses(4)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"103";
    regs_addresses(5)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"104";
    regs_addresses(6)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"105";
    regs_addresses(7)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"106";
    regs_addresses(8)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"107";
    regs_addresses(9)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"108";
    regs_addresses(10)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"109";
    regs_addresses(11)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"10a";
    regs_addresses(12)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"10b";
    regs_addresses(13)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"10c";
    regs_addresses(14)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"10d";
    regs_addresses(15)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"10e";
    regs_addresses(16)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"10f";
    regs_addresses(17)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"110";
    regs_addresses(18)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"200";
    regs_addresses(19)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"201";
    regs_addresses(20)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"202";
    regs_addresses(21)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"203";
    regs_addresses(22)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"204";
    regs_addresses(23)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"205";
    regs_addresses(24)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"206";
    regs_addresses(25)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"207";
    regs_addresses(26)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"208";
    regs_addresses(27)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"209";
    regs_addresses(28)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"20a";
    regs_addresses(29)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"20b";
    regs_addresses(30)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"20c";
    regs_addresses(31)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"20d";
    regs_addresses(32)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"20e";
    regs_addresses(33)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"20f";
    regs_addresses(34)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"210";
    regs_addresses(35)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"300";
    regs_addresses(36)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"301";
    regs_addresses(37)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"302";
    regs_addresses(38)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"303";
    regs_addresses(39)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"304";
    regs_addresses(40)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"305";
    regs_addresses(41)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"306";
    regs_addresses(42)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"307";
    regs_addresses(43)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"308";
    regs_addresses(44)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"309";
    regs_addresses(45)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"30a";
    regs_addresses(46)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"30b";
    regs_addresses(47)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"30c";
    regs_addresses(48)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"30d";
    regs_addresses(49)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"30e";
    regs_addresses(50)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"30f";
    regs_addresses(51)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"310";
    regs_addresses(52)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"400";
    regs_addresses(53)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"401";
    regs_addresses(54)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"402";
    regs_addresses(55)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"403";
    regs_addresses(56)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"404";
    regs_addresses(57)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"405";
    regs_addresses(58)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"406";
    regs_addresses(59)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"407";
    regs_addresses(60)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"408";
    regs_addresses(61)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"409";
    regs_addresses(62)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"40a";
    regs_addresses(63)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"40b";
    regs_addresses(64)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"40c";
    regs_addresses(65)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"40d";
    regs_addresses(66)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"40e";
    regs_addresses(67)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"40f";
    regs_addresses(68)(REG_OH_LINKS_ADDRESS_MSB downto REG_OH_LINKS_ADDRESS_LSB) <= '0' & x"410";

    -- Connect read signals
    regs_read_arr(1)(REG_OH_LINKS_OH0_TRACK_LINK_ERROR_CNT_MSB downto REG_OH_LINKS_OH0_TRACK_LINK_ERROR_CNT_LSB) <= tk_error_cnt_arr(0);
    regs_read_arr(2)(REG_OH_LINKS_OH0_VFAT_BLOCK_CNT_MSB downto REG_OH_LINKS_OH0_VFAT_BLOCK_CNT_LSB) <= evt_rcvd_cnt_arr(0);
    regs_read_arr(3)(REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_OVF_CNT_LSB) <= sync_tk_tx_ovf_arr(0);
    regs_read_arr(4)(REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_UNF_CNT_LSB) <= sync_tk_tx_unf_arr(0);
    regs_read_arr(5)(REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tk_rx_ovf_arr(0);
    regs_read_arr(6)(REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tk_rx_unf_arr(0);
    regs_read_arr(7)(REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tr0_rx_ovf_arr(0);
    regs_read_arr(8)(REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tr0_rx_unf_arr(0);
    regs_read_arr(9)(REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tr1_rx_ovf_arr(0);
    regs_read_arr(10)(REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tr1_rx_unf_arr(0);
    regs_read_arr(11)(REG_OH_LINKS_OH0_TRACK_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH0_TRACK_LINK_NOT_IN_TABLE_CNT_LSB) <= tk_not_in_table_arr(0);
    regs_read_arr(12)(REG_OH_LINKS_OH0_TRACK_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH0_TRACK_LINK_DISPERR_CNT_LSB) <= tk_disperr_arr(0);
    regs_read_arr(13)(REG_OH_LINKS_OH0_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH0_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB) <= tr0_not_in_table_arr(0);
    regs_read_arr(14)(REG_OH_LINKS_OH0_TRIG0_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH0_TRIG0_LINK_DISPERR_CNT_LSB) <= tr0_disperr_arr(0);
    regs_read_arr(15)(REG_OH_LINKS_OH0_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH0_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB) <= tr1_not_in_table_arr(0);
    regs_read_arr(16)(REG_OH_LINKS_OH0_TRIG1_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH0_TRIG1_LINK_DISPERR_CNT_LSB) <= tr1_disperr_arr(0);
    regs_read_arr(17)(REG_OH_LINKS_OH0_GBT_LINK_SYNC_DONE_BIT) <= gbt_rx_sync_done_arr_i(0);
    regs_read_arr(18)(REG_OH_LINKS_OH1_TRACK_LINK_ERROR_CNT_MSB downto REG_OH_LINKS_OH1_TRACK_LINK_ERROR_CNT_LSB) <= tk_error_cnt_arr(1);
    regs_read_arr(19)(REG_OH_LINKS_OH1_VFAT_BLOCK_CNT_MSB downto REG_OH_LINKS_OH1_VFAT_BLOCK_CNT_LSB) <= evt_rcvd_cnt_arr(1);
    regs_read_arr(20)(REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_OVF_CNT_LSB) <= sync_tk_tx_ovf_arr(1);
    regs_read_arr(21)(REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_UNF_CNT_LSB) <= sync_tk_tx_unf_arr(1);
    regs_read_arr(22)(REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tk_rx_ovf_arr(1);
    regs_read_arr(23)(REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tk_rx_unf_arr(1);
    regs_read_arr(24)(REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tr0_rx_ovf_arr(1);
    regs_read_arr(25)(REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tr0_rx_unf_arr(1);
    regs_read_arr(26)(REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tr1_rx_ovf_arr(1);
    regs_read_arr(27)(REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tr1_rx_unf_arr(1);
    regs_read_arr(28)(REG_OH_LINKS_OH1_TRACK_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH1_TRACK_LINK_NOT_IN_TABLE_CNT_LSB) <= tk_not_in_table_arr(1);
    regs_read_arr(29)(REG_OH_LINKS_OH1_TRACK_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH1_TRACK_LINK_DISPERR_CNT_LSB) <= tk_disperr_arr(1);
    regs_read_arr(30)(REG_OH_LINKS_OH1_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH1_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB) <= tr0_not_in_table_arr(1);
    regs_read_arr(31)(REG_OH_LINKS_OH1_TRIG0_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH1_TRIG0_LINK_DISPERR_CNT_LSB) <= tr0_disperr_arr(1);
    regs_read_arr(32)(REG_OH_LINKS_OH1_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH1_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB) <= tr1_not_in_table_arr(1);
    regs_read_arr(33)(REG_OH_LINKS_OH1_TRIG1_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH1_TRIG1_LINK_DISPERR_CNT_LSB) <= tr1_disperr_arr(1);
    regs_read_arr(34)(REG_OH_LINKS_OH1_GBT_LINK_SYNC_DONE_BIT) <= gbt_rx_sync_done_arr_i(1);
    regs_read_arr(35)(REG_OH_LINKS_OH2_TRACK_LINK_ERROR_CNT_MSB downto REG_OH_LINKS_OH2_TRACK_LINK_ERROR_CNT_LSB) <= tk_error_cnt_arr(2);
    regs_read_arr(36)(REG_OH_LINKS_OH2_VFAT_BLOCK_CNT_MSB downto REG_OH_LINKS_OH2_VFAT_BLOCK_CNT_LSB) <= evt_rcvd_cnt_arr(2);
    regs_read_arr(37)(REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_OVF_CNT_LSB) <= sync_tk_tx_ovf_arr(2);
    regs_read_arr(38)(REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_UNF_CNT_LSB) <= sync_tk_tx_unf_arr(2);
    regs_read_arr(39)(REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tk_rx_ovf_arr(2);
    regs_read_arr(40)(REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tk_rx_unf_arr(2);
    regs_read_arr(41)(REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tr0_rx_ovf_arr(2);
    regs_read_arr(42)(REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tr0_rx_unf_arr(2);
    regs_read_arr(43)(REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tr1_rx_ovf_arr(2);
    regs_read_arr(44)(REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tr1_rx_unf_arr(2);
    regs_read_arr(45)(REG_OH_LINKS_OH2_TRACK_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH2_TRACK_LINK_NOT_IN_TABLE_CNT_LSB) <= tk_not_in_table_arr(2);
    regs_read_arr(46)(REG_OH_LINKS_OH2_TRACK_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH2_TRACK_LINK_DISPERR_CNT_LSB) <= tk_disperr_arr(2);
    regs_read_arr(47)(REG_OH_LINKS_OH2_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH2_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB) <= tr0_not_in_table_arr(2);
    regs_read_arr(48)(REG_OH_LINKS_OH2_TRIG0_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH2_TRIG0_LINK_DISPERR_CNT_LSB) <= tr0_disperr_arr(2);
    regs_read_arr(49)(REG_OH_LINKS_OH2_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH2_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB) <= tr1_not_in_table_arr(2);
    regs_read_arr(50)(REG_OH_LINKS_OH2_TRIG1_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH2_TRIG1_LINK_DISPERR_CNT_LSB) <= tr1_disperr_arr(2);
    regs_read_arr(51)(REG_OH_LINKS_OH2_GBT_LINK_SYNC_DONE_BIT) <= gbt_rx_sync_done_arr_i(2);
    regs_read_arr(52)(REG_OH_LINKS_OH3_TRACK_LINK_ERROR_CNT_MSB downto REG_OH_LINKS_OH3_TRACK_LINK_ERROR_CNT_LSB) <= tk_error_cnt_arr(3);
    regs_read_arr(53)(REG_OH_LINKS_OH3_VFAT_BLOCK_CNT_MSB downto REG_OH_LINKS_OH3_VFAT_BLOCK_CNT_LSB) <= evt_rcvd_cnt_arr(3);
    regs_read_arr(54)(REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_OVF_CNT_LSB) <= sync_tk_tx_ovf_arr(3);
    regs_read_arr(55)(REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_UNF_CNT_LSB) <= sync_tk_tx_unf_arr(3);
    regs_read_arr(56)(REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tk_rx_ovf_arr(3);
    regs_read_arr(57)(REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tk_rx_unf_arr(3);
    regs_read_arr(58)(REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tr0_rx_ovf_arr(3);
    regs_read_arr(59)(REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tr0_rx_unf_arr(3);
    regs_read_arr(60)(REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB downto REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB) <= sync_tr1_rx_ovf_arr(3);
    regs_read_arr(61)(REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB downto REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB) <= sync_tr1_rx_unf_arr(3);
    regs_read_arr(62)(REG_OH_LINKS_OH3_TRACK_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH3_TRACK_LINK_NOT_IN_TABLE_CNT_LSB) <= tk_not_in_table_arr(3);
    regs_read_arr(63)(REG_OH_LINKS_OH3_TRACK_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH3_TRACK_LINK_DISPERR_CNT_LSB) <= tk_disperr_arr(3);
    regs_read_arr(64)(REG_OH_LINKS_OH3_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH3_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB) <= tr0_not_in_table_arr(3);
    regs_read_arr(65)(REG_OH_LINKS_OH3_TRIG0_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH3_TRIG0_LINK_DISPERR_CNT_LSB) <= tr0_disperr_arr(3);
    regs_read_arr(66)(REG_OH_LINKS_OH3_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB downto REG_OH_LINKS_OH3_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB) <= tr1_not_in_table_arr(3);
    regs_read_arr(67)(REG_OH_LINKS_OH3_TRIG1_LINK_DISPERR_CNT_MSB downto REG_OH_LINKS_OH3_TRIG1_LINK_DISPERR_CNT_LSB) <= tr1_disperr_arr(3);
    regs_read_arr(68)(REG_OH_LINKS_OH3_GBT_LINK_SYNC_DONE_BIT) <= gbt_rx_sync_done_arr_i(3);

    -- Connect write signals

    -- Connect write pulse signals
    reset_local <= regs_write_pulse_arr(0);

    -- Connect write done signals

    -- Connect read pulse signals

    -- Connect read ready signals

    -- Defaults

    -- Define writable regs

    --==== Registers end ============================================================================
    
end oh_link_regs_arch;

