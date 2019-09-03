------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    14:19 2016-10-05
-- Module Name:    slow_control
-- Description:    This module is mainly responsible for communication with Optohybrid SCA and reading/writing GBTx registers
------------------------------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

use work.gem_pkg.all;
use work.sca_pkg.all;
use work.ttc_pkg.all;
use work.ipbus.all;
use work.registers.all;

entity slow_control is
    generic(
        g_NUM_OF_OHs        : integer;
        g_NUM_GBTS_PER_OH   : integer;
        g_DEBUG             : boolean := false -- if this is set to true, some chipscope cores will be inserted
    );
    port(
        -- reset
        reset_i                 : in  std_logic;

        -- TTC
        ttc_clk_i               : in  t_ttc_clks;
        ttc_cmds_i              : in  t_ttc_cmds;
        
        -- SCA elinks
        gbt_rx_ready_i          : in  std_logic_vector(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0); 
        gbt_rx_sca_elinks_i     : in  t_std2_array(g_NUM_OF_OHs - 1 downto 0);
        gbt_tx_sca_elinks_o     : out t_std2_array(g_NUM_OF_OHs - 1 downto 0);
        
        -- GBTx IC elinks
        gbt_rx_ic_elinks_i      : in  t_std2_array(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        gbt_tx_ic_elinks_o      : out t_std2_array(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        
        -- VFAT3 slow control status
        vfat3_sc_status_i       : in t_vfat_slow_control_status; 
        
        -- IPbus
        ipb_reset_i             : in  std_logic;
        ipb_clk_i               : in  std_logic;
        ipb_miso_o              : out ipb_rbus;
        ipb_mosi_i              : in  ipb_wbus
        
    );
end slow_control;

architecture slow_control_arch of slow_control is

    --------------------------------- signals ---------------------------------    

    --============ SCA ============--
    
    -- general
    signal sca_reset                : std_logic;
    signal sca_reset_mask           : std_logic_vector(31 downto 0);
    signal sca_ready_arr            : std_logic_vector(31 downto 0);
    signal sca_critical_error_arr   : std_logic_vector(31 downto 0);
    signal sca_ttc_hr_enable        : std_logic_vector(31 downto 0);
    
    -- manual commands
    signal manual_hard_reset            : std_logic;
    signal sca_user_command             : t_sca_command;
    signal sca_user_command_en          : std_logic;
    signal sca_user_command_en_mask     : std_logic_vector(31 downto 0); -- command_en signal will only be sent to the channels that are enabled in this bitmask
    signal sca_user_command_done_arr    : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal sca_user_command_done_latch  : std_logic_vector(g_NUM_OF_OHs - 1 downto 0) := (others => '0');
    signal sca_user_command_done_all    : std_logic;
    signal sca_user_reply_arr           : t_sca_reply_array(g_NUM_OF_OHs - 1 downto 0);
    
    -- core monitoring
    signal sca_not_ready_cnt_arr: t_std16_array(g_NUM_OF_OHs - 1 downto 0);
    signal sca_rx_err_cnt       : std_logic_vector(15 downto 0);
    signal sca_seq_num_err_cnt  : std_logic_vector(15 downto 0);
    signal sca_crc_err_cnt      : std_logic_vector(15 downto 0);
    signal sca_tr_timeout_cnt   : std_logic_vector(15 downto 0);
    signal sca_tr_fail_cnt      : std_logic_vector(15 downto 0);
    signal sca_tr_done_cnt      : std_logic_vector(31 downto 0);
    signal sca_last_sca_error   : std_logic_vector(6 downto 0);
    
    -- jtag
    signal jtag_enabled_mask        : std_logic_vector(31 downto 0);
    signal jtag_cmd_length          : std_logic_vector(6 downto 0);
    signal jtag_tdo                 : std_logic_vector(31 downto 0);
    signal jtag_tms                 : std_logic_vector(31 downto 0);
    signal jtag_tdi_arr             : t_std32_array(g_NUM_OF_OHs - 1 downto 0);
    signal jtag_shift_tdo_en        : std_logic; 
    signal jtag_shift_tms_en        : std_logic;
    signal jtag_shift_tdi_en_arr    : std_logic_vector(g_NUM_OF_OHs - 1 downto 0);
    signal jtag_shift_done_arr      : std_logic_vector(g_NUM_OF_OHs - 1 downto 0); 
    signal jtag_shift_done_latch    : std_logic_vector(g_NUM_OF_OHs - 1 downto 0) := (others => '0'); 
    signal jtag_shift_done_all      : std_logic; 
    signal jtag_shift_msb_first     : std_logic; -- tell SCA to shift out MSB first instead of the default LSB first
    signal jtag_exec_on_every_tdo   : std_logic; -- EXPERT ONLY: used to optimize firmware downloading, when set high the controller will execute JTAG_GO after every TDO shift (even if length is higher than 32)
    signal jtag_no_length_update    : std_logic; -- EXPERT ONLY: used to optimize firmware downloading, when set high the controller will assume that SCA already has the correct length and will not update it before each JTAG_GO
    signal jtag_shift_tdo_async     : std_logic; -- kindof expert: if this is set high then JTAG controller will assert jtag_shift_done_o immediately after TDO shift command, but if the second command is received while it's still busy it won't assert jtag_shift_done_o until the previous command is done
    
            
    -- debug
    signal sca_tx_raw_last_cmd  : std_logic_vector(95 downto 0);
    signal sca_rx_raw_last_reply: std_logic_vector(95 downto 0);
    signal sca_rx_last_calc_crc : std_logic_vector(15 downto 0);

    ------------- GBTx IC -------------

    signal ic_link_select       : std_logic_vector(5 downto 0);
    signal ic_rx_elink          : std_logic_vector(1 downto 0);
    signal ic_tx_elink          : std_logic_vector(1 downto 0);
    signal ic_address           : std_logic_vector(15 downto 0);
    signal ic_write_data        : std_logic_vector(31 downto 0);
    signal ic_rw_length         : std_logic_vector(2 downto 0);
    signal ic_write_req         : std_logic;
    signal ic_write_done        : std_logic;
    signal ic_read_req          : std_logic; 
    signal ic_gbtx_i2c_addr     : std_logic_vector(3 downto 0);

    ------ Register signals begin (this section is generated by <gem_amc_repo_root>/scripts/generate_registers.py -- do not edit)
    signal regs_read_arr        : t_std32_array(REG_SLOW_CONTROL_NUM_REGS - 1 downto 0);
    signal regs_write_arr       : t_std32_array(REG_SLOW_CONTROL_NUM_REGS - 1 downto 0);
    signal regs_addresses       : t_std32_array(REG_SLOW_CONTROL_NUM_REGS - 1 downto 0);
    signal regs_defaults        : t_std32_array(REG_SLOW_CONTROL_NUM_REGS - 1 downto 0) := (others => (others => '0'));
    signal regs_read_pulse_arr  : std_logic_vector(REG_SLOW_CONTROL_NUM_REGS - 1 downto 0);
    signal regs_write_pulse_arr : std_logic_vector(REG_SLOW_CONTROL_NUM_REGS - 1 downto 0);
    signal regs_read_ready_arr  : std_logic_vector(REG_SLOW_CONTROL_NUM_REGS - 1 downto 0) := (others => '1');
    signal regs_write_done_arr  : std_logic_vector(REG_SLOW_CONTROL_NUM_REGS - 1 downto 0) := (others => '1');
    signal regs_writable_arr    : std_logic_vector(REG_SLOW_CONTROL_NUM_REGS - 1 downto 0) := (others => '0');
    ------ Register signals end ----------------------------------------------

begin

    --======== SCA controller ========--
    
    g_sca_controllers : for i in 0 to g_NUM_OF_OHs - 1 generate
        i_sca_controller : entity work.sca_controller
            port map(
                reset_i                     => reset_i or (sca_reset and sca_reset_mask(i)),
                gbt_clk_40_i                => ttc_clk_i.clk_40,
                clk_80_i                    => ttc_clk_i.clk_80,
            
                gbt_rx_ready_i              => gbt_rx_ready_i(i * g_NUM_GBTS_PER_OH),
                gbt_rx_sca_elink_i          => gbt_rx_sca_elinks_i(i),
                gbt_tx_sca_elink_o          => gbt_tx_sca_elinks_o(i),
            
                hard_reset_i                => manual_hard_reset or (ttc_cmds_i.hard_reset and sca_ttc_hr_enable(i)),
            
                user_command_i              => sca_user_command,
                user_command_en_i           => sca_user_command_en and sca_user_command_en_mask(i),
                user_reply_o                => sca_user_reply_arr(i),
                user_reply_valid_o          => sca_user_command_done_arr(i),
            
                jtag_enabled_i              => jtag_enabled_mask(i),
                jtag_cmd_length_i           => unsigned(jtag_cmd_length),
                jtag_tdo_i                  => jtag_tdo,
                jtag_tms_i                  => jtag_tms,
                jtag_tdi_o                  => jtag_tdi_arr(i),
                jtag_shift_tdo_en_i         => jtag_shift_tdo_en,
                jtag_shift_tms_en_i         => jtag_shift_tms_en,
                jtag_shift_tdi_en_i         => jtag_shift_tdi_en_arr(i),
                jtag_shift_done_o           => jtag_shift_done_arr(i),            
                jtag_shift_msb_first_i      => jtag_shift_msb_first,
                
                jtag_exec_on_every_tdo_i    => jtag_exec_on_every_tdo,
                jtag_no_length_update_i     => jtag_no_length_update,
                jtag_shift_tdo_async_i      => jtag_shift_tdo_async,
                                    
                ready_o                     => sca_ready_arr(i),
                critical_error_o            => sca_critical_error_arr(i),
                not_ready_cnt_o             => sca_not_ready_cnt_arr(i),
                rx_err_cnt_o                => open, --sca_rx_err_cnt,
                rx_seq_num_err_cnt_o        => open, --sca_seq_num_err_cnt,
                rx_crc_err_cnt_o            => open, --sca_crc_err_cnt,
                trans_timeout_cnt_o         => open, --sca_tr_timeout_cnt,
                trans_fail_cnt_o            => open, --sca_tr_fail_cnt,
                trans_done_cnt_o            => open, --sca_tr_done_cnt,
                last_sca_error_o            => open, --sca_last_sca_error,
                tx_raw_last_cmd_o           => open, --sca_tx_raw_last_cmd,
                rx_raw_last_reply_o         => open, --sca_rx_raw_last_reply,
                rx_last_calc_crc_o          => open  --sca_rx_last_calc_crc
            );
    end generate;

    ------------------- SCA done signal aggregation based on enabled channels -------------------
    
    -- manual command
    process(ttc_clk_i.clk_40)
    begin
        if (rising_edge(ttc_clk_i.clk_40)) then
            if (sca_user_command_en = '1') then
                sca_user_command_done_latch <= (others => '0');
            else
                sca_user_command_done_latch <= sca_user_command_done_latch or sca_user_command_done_arr;
            end if;
            
            if (sca_user_command_done_latch = sca_user_command_en_mask(g_NUM_OF_OHs - 1 downto 0)) then
                sca_user_command_done_all <= '1';
                sca_user_command_done_latch <= (others => '0');
            else
                sca_user_command_done_all <= '0';
            end if;
        end if;
    end process; 

    -- JTAG command
    process(ttc_clk_i.clk_40)
    begin
        if (rising_edge(ttc_clk_i.clk_40)) then
            if ((jtag_shift_tdo_en = '1') or (jtag_shift_tms_en = '1')) then
                jtag_shift_done_latch <= (others => '0');
            else
                jtag_shift_done_latch <= jtag_shift_done_latch or jtag_shift_done_arr;
            end if;
            
            if (jtag_shift_done_latch = jtag_enabled_mask(g_NUM_OF_OHs - 1 downto 0)) then
                jtag_shift_done_all <= '1';
                jtag_shift_done_latch <= (others => '0');
            else
                jtag_shift_done_all <= '0';
            end if;
        end if;
    end process; 

    
    --======== GBTx IC ========--
    
    i_ic_controller : entity work.gbtx_ic_controller
--        generic map(
--            g_GBTX_I2C_ADDRESS => x"1"
--        )
        port map(
            reset_i           => reset_i,
            gbt_clk_i         => ttc_clk_i.clk_40,
            gbtx_i2c_address  => ic_gbtx_i2c_addr,
            gbt_rx_ic_elink_i => ic_rx_elink,
            gbt_tx_ic_elink_o => ic_tx_elink,
            ic_rw_address_i   => ic_address,
            ic_w_data_i       => ic_write_data,
            ic_rw_length_i    => ic_rw_length,
            ic_write_req_i    => ic_write_req,
            ic_write_done_o   => ic_write_done,
            ic_read_req_i     => ic_read_req
        );
    
    ic_rx_elink <= gbt_rx_ic_elinks_i(to_integer(unsigned(ic_link_select)));
    g_ic_tx_generate: for i in 0 to g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 generate
        gbt_tx_ic_elinks_o(i) <= ic_tx_elink when to_integer(unsigned(ic_link_select)) = i else (others => '1'); 
    end generate;
    
    --===============================================================================================
    -- this section is generated by <gem_amc_repo_root>/scripts/generate_registers.py (do not edit) 
    --==== Registers begin ==========================================================================

    -- IPbus slave instanciation
    ipbus_slave_inst : entity work.ipbus_slave
        generic map(
           g_NUM_REGS             => REG_SLOW_CONTROL_NUM_REGS,
           g_ADDR_HIGH_BIT        => REG_SLOW_CONTROL_ADDRESS_MSB,
           g_ADDR_LOW_BIT         => REG_SLOW_CONTROL_ADDRESS_LSB,
           g_USE_INDIVIDUAL_ADDRS => true
       )
       port map(
           ipb_reset_i            => ipb_reset_i,
           ipb_clk_i              => ipb_clk_i,
           ipb_mosi_i             => ipb_mosi_i,
           ipb_miso_o             => ipb_miso_o,
           usr_clk_i              => ttc_clk_i.clk_40,
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
    regs_addresses(0)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0000";
    regs_addresses(1)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0001";
    regs_addresses(2)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0002";
    regs_addresses(3)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0003";
    regs_addresses(4)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0100";
    regs_addresses(5)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0101";
    regs_addresses(6)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0102";
    regs_addresses(7)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0103";
    regs_addresses(8)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0104";
    regs_addresses(9)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0105";
    regs_addresses(10)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0106";
    regs_addresses(11)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0107";
    regs_addresses(12)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0108";
    regs_addresses(13)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"0109";
    regs_addresses(14)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"010a";
    regs_addresses(15)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"010b";
    regs_addresses(16)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"010c";
    regs_addresses(17)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"010d";
    regs_addresses(18)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1000";
    regs_addresses(19)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1001";
    regs_addresses(20)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1002";
    regs_addresses(21)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1003";
    regs_addresses(22)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1004";
    regs_addresses(23)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1005";
    regs_addresses(24)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1006";
    regs_addresses(25)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1007";
    regs_addresses(26)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1008";
    regs_addresses(27)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1009";
    regs_addresses(28)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"100a";
    regs_addresses(29)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"100b";
    regs_addresses(30)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"100c";
    regs_addresses(31)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"100d";
    regs_addresses(32)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"100e";
    regs_addresses(33)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"100f";
    regs_addresses(34)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1010";
    regs_addresses(35)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1011";
    regs_addresses(36)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1012";
    regs_addresses(37)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1013";
    regs_addresses(38)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1014";
    regs_addresses(39)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1015";
    regs_addresses(40)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1016";
    regs_addresses(41)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1017";
    regs_addresses(42)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1018";
    regs_addresses(43)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"1019";
    regs_addresses(44)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"101a";
    regs_addresses(45)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"101b";
    regs_addresses(46)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"2500";
    regs_addresses(47)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"2501";
    regs_addresses(48)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"2502";
    regs_addresses(49)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"2503";
    regs_addresses(50)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"2504";
    regs_addresses(51)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"2505";
    regs_addresses(52)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"2506";
    regs_addresses(53)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"2507";
    regs_addresses(54)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"2508";
    regs_addresses(55)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"2509";
    regs_addresses(56)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"250a";
    regs_addresses(57)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"250b";
    regs_addresses(58)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"250c";
    regs_addresses(59)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"250d";
    regs_addresses(60)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"250e";
    regs_addresses(61)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"250f";
    regs_addresses(62)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"2510";
    regs_addresses(63)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"3000";
    regs_addresses(64)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"3001";
    regs_addresses(65)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"3002";
    regs_addresses(66)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"3003";
    regs_addresses(67)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"3004";
    regs_addresses(68)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"3005";
    regs_addresses(69)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"3006";
    regs_addresses(70)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"4000";
    regs_addresses(71)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"4001";
    regs_addresses(72)(REG_SLOW_CONTROL_ADDRESS_MSB downto REG_SLOW_CONTROL_ADDRESS_LSB) <= '0' & x"4002";

    -- Connect read signals
    regs_read_arr(2)(REG_SLOW_CONTROL_SCA_CTRL_TTC_HARD_RESET_EN_MSB downto REG_SLOW_CONTROL_SCA_CTRL_TTC_HARD_RESET_EN_LSB) <= sca_ttc_hr_enable;
    regs_read_arr(3)(REG_SLOW_CONTROL_SCA_CTRL_SCA_RESET_ENABLE_MASK_MSB downto REG_SLOW_CONTROL_SCA_CTRL_SCA_RESET_ENABLE_MASK_LSB) <= sca_reset_mask;
    regs_read_arr(4)(REG_SLOW_CONTROL_SCA_STATUS_READY_MSB downto REG_SLOW_CONTROL_SCA_STATUS_READY_LSB) <= sca_ready_arr;
    regs_read_arr(5)(REG_SLOW_CONTROL_SCA_STATUS_CRITICAL_ERROR_MSB downto REG_SLOW_CONTROL_SCA_STATUS_CRITICAL_ERROR_LSB) <= sca_critical_error_arr;
    regs_read_arr(6)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH0_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH0_LSB) <= sca_not_ready_cnt_arr(0);
    regs_read_arr(7)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH1_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH1_LSB) <= sca_not_ready_cnt_arr(1);
    regs_read_arr(8)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH2_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH2_LSB) <= sca_not_ready_cnt_arr(2);
    regs_read_arr(9)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH3_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH3_LSB) <= sca_not_ready_cnt_arr(3);
    regs_read_arr(10)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH4_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH4_LSB) <= sca_not_ready_cnt_arr(4);
    regs_read_arr(11)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH5_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH5_LSB) <= sca_not_ready_cnt_arr(5);
    regs_read_arr(12)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH6_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH6_LSB) <= sca_not_ready_cnt_arr(6);
    regs_read_arr(13)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH7_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH7_LSB) <= sca_not_ready_cnt_arr(7);
    regs_read_arr(14)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH8_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH8_LSB) <= sca_not_ready_cnt_arr(8);
    regs_read_arr(15)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH9_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH9_LSB) <= sca_not_ready_cnt_arr(9);
    regs_read_arr(16)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH10_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH10_LSB) <= sca_not_ready_cnt_arr(10);
    regs_read_arr(17)(REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH11_MSB downto REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH11_LSB) <= sca_not_ready_cnt_arr(11);
    regs_read_arr(18)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_LINK_ENABLE_MASK_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_LINK_ENABLE_MASK_LSB) <= sca_user_command_en_mask;
    regs_read_arr(19)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_CHANNEL_LSB) <= sca_user_command.channel;
    regs_read_arr(19)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_COMMAND_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_COMMAND_LSB) <= sca_user_command.command;
    regs_read_arr(19)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_LENGTH_LSB) <= sca_user_command.length;
    regs_read_arr(20)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_DATA_LSB) <= sca_user_command.data;
    regs_read_arr(22)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(0).channel;
    regs_read_arr(22)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(0).error;
    regs_read_arr(22)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(0).length;
    regs_read_arr(23)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(0).data;
    regs_read_arr(24)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(1).channel;
    regs_read_arr(24)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(1).error;
    regs_read_arr(24)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(1).length;
    regs_read_arr(25)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(1).data;
    regs_read_arr(26)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(2).channel;
    regs_read_arr(26)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(2).error;
    regs_read_arr(26)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(2).length;
    regs_read_arr(27)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(2).data;
    regs_read_arr(28)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(3).channel;
    regs_read_arr(28)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(3).error;
    regs_read_arr(28)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(3).length;
    regs_read_arr(29)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(3).data;
    regs_read_arr(30)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(4).channel;
    regs_read_arr(30)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(4).error;
    regs_read_arr(30)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(4).length;
    regs_read_arr(31)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(4).data;
    regs_read_arr(32)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(5).channel;
    regs_read_arr(32)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(5).error;
    regs_read_arr(32)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(5).length;
    regs_read_arr(33)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(5).data;
    regs_read_arr(34)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(6).channel;
    regs_read_arr(34)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(6).error;
    regs_read_arr(34)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(6).length;
    regs_read_arr(35)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(6).data;
    regs_read_arr(36)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(7).channel;
    regs_read_arr(36)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(7).error;
    regs_read_arr(36)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(7).length;
    regs_read_arr(37)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(7).data;
    regs_read_arr(38)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(8).channel;
    regs_read_arr(38)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(8).error;
    regs_read_arr(38)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(8).length;
    regs_read_arr(39)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(8).data;
    regs_read_arr(40)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(9).channel;
    regs_read_arr(40)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(9).error;
    regs_read_arr(40)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(9).length;
    regs_read_arr(41)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(9).data;
    regs_read_arr(42)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(10).channel;
    regs_read_arr(42)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(10).error;
    regs_read_arr(42)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(10).length;
    regs_read_arr(43)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(10).data;
    regs_read_arr(44)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_CHANNEL_LSB) <= sca_user_reply_arr(11).channel;
    regs_read_arr(44)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_ERROR_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_ERROR_LSB) <= sca_user_reply_arr(11).error;
    regs_read_arr(44)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_LENGTH_LSB) <= sca_user_reply_arr(11).length;
    regs_read_arr(45)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_DATA_LSB) <= sca_user_reply_arr(11).data;
    regs_read_arr(46)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_ENABLE_MASK_MSB downto REG_SLOW_CONTROL_SCA_JTAG_CTRL_ENABLE_MASK_LSB) <= jtag_enabled_mask;
    regs_read_arr(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_SHIFT_MSB_BIT) <= jtag_shift_msb_first;
    regs_read_arr(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_EXEC_ON_EVERY_TDO_BIT) <= jtag_exec_on_every_tdo;
    regs_read_arr(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_NO_SCA_LENGTH_UPDATE_BIT) <= jtag_no_length_update;
    regs_read_arr(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_SHIFT_TDO_ASYNC_BIT) <= jtag_shift_tdo_async;
    regs_read_arr(48)(REG_SLOW_CONTROL_SCA_JTAG_NUM_BITS_MSB downto REG_SLOW_CONTROL_SCA_JTAG_NUM_BITS_LSB) <= jtag_cmd_length;
    regs_read_arr(51)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH0_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH0_LSB) <= jtag_tdi_arr(0);
    regs_read_arr(52)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH1_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH1_LSB) <= jtag_tdi_arr(1);
    regs_read_arr(53)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH2_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH2_LSB) <= jtag_tdi_arr(2);
    regs_read_arr(54)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH3_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH3_LSB) <= jtag_tdi_arr(3);
    regs_read_arr(55)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH4_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH4_LSB) <= jtag_tdi_arr(4);
    regs_read_arr(56)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH5_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH5_LSB) <= jtag_tdi_arr(5);
    regs_read_arr(57)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH6_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH6_LSB) <= jtag_tdi_arr(6);
    regs_read_arr(58)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH7_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH7_LSB) <= jtag_tdi_arr(7);
    regs_read_arr(59)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH8_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH8_LSB) <= jtag_tdi_arr(8);
    regs_read_arr(60)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH9_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH9_LSB) <= jtag_tdi_arr(9);
    regs_read_arr(61)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH10_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH10_LSB) <= jtag_tdi_arr(10);
    regs_read_arr(62)(REG_SLOW_CONTROL_SCA_JTAG_TDI_OH11_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDI_OH11_LSB) <= jtag_tdi_arr(11);
    regs_read_arr(63)(REG_SLOW_CONTROL_IC_ADDRESS_MSB downto REG_SLOW_CONTROL_IC_ADDRESS_LSB) <= ic_address;
    regs_read_arr(64)(REG_SLOW_CONTROL_IC_READ_WRITE_LENGTH_MSB downto REG_SLOW_CONTROL_IC_READ_WRITE_LENGTH_LSB) <= ic_rw_length;
    regs_read_arr(65)(REG_SLOW_CONTROL_IC_WRITE_DATA_MSB downto REG_SLOW_CONTROL_IC_WRITE_DATA_LSB) <= ic_write_data;
    regs_read_arr(68)(REG_SLOW_CONTROL_IC_GBTX_I2C_ADDR_MSB downto REG_SLOW_CONTROL_IC_GBTX_I2C_ADDR_LSB) <= ic_gbtx_i2c_addr;
    regs_read_arr(69)(REG_SLOW_CONTROL_IC_GBTX_LINK_SELECT_MSB downto REG_SLOW_CONTROL_IC_GBTX_LINK_SELECT_LSB) <= ic_link_select;
    regs_read_arr(70)(REG_SLOW_CONTROL_VFAT3_CRC_ERROR_CNT_MSB downto REG_SLOW_CONTROL_VFAT3_CRC_ERROR_CNT_LSB) <= vfat3_sc_status_i.crc_error_cnt;
    regs_read_arr(70)(REG_SLOW_CONTROL_VFAT3_PACKET_ERROR_CNT_MSB downto REG_SLOW_CONTROL_VFAT3_PACKET_ERROR_CNT_LSB) <= vfat3_sc_status_i.packet_error_cnt;
    regs_read_arr(71)(REG_SLOW_CONTROL_VFAT3_BITSTUFFING_ERROR_CNT_MSB downto REG_SLOW_CONTROL_VFAT3_BITSTUFFING_ERROR_CNT_LSB) <= vfat3_sc_status_i.bitstuff_error_cnt;
    regs_read_arr(71)(REG_SLOW_CONTROL_VFAT3_TIMEOUT_ERROR_CNT_MSB downto REG_SLOW_CONTROL_VFAT3_TIMEOUT_ERROR_CNT_LSB) <= vfat3_sc_status_i.timeout_error_cnt;
    regs_read_arr(72)(REG_SLOW_CONTROL_VFAT3_AXI_STROBE_ERROR_CNT_MSB downto REG_SLOW_CONTROL_VFAT3_AXI_STROBE_ERROR_CNT_LSB) <= vfat3_sc_status_i.axi_strobe_error_cnt;
    regs_read_arr(72)(REG_SLOW_CONTROL_VFAT3_TRANSACTION_CNT_MSB downto REG_SLOW_CONTROL_VFAT3_TRANSACTION_CNT_LSB) <= vfat3_sc_status_i.transaction_cnt;

    -- Connect write signals
    sca_ttc_hr_enable <= regs_write_arr(2)(REG_SLOW_CONTROL_SCA_CTRL_TTC_HARD_RESET_EN_MSB downto REG_SLOW_CONTROL_SCA_CTRL_TTC_HARD_RESET_EN_LSB);
    sca_reset_mask <= regs_write_arr(3)(REG_SLOW_CONTROL_SCA_CTRL_SCA_RESET_ENABLE_MASK_MSB downto REG_SLOW_CONTROL_SCA_CTRL_SCA_RESET_ENABLE_MASK_LSB);
    sca_user_command_en_mask <= regs_write_arr(18)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_LINK_ENABLE_MASK_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_LINK_ENABLE_MASK_LSB);
    sca_user_command.channel <= regs_write_arr(19)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_CHANNEL_LSB);
    sca_user_command.command <= regs_write_arr(19)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_COMMAND_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_COMMAND_LSB);
    sca_user_command.length <= regs_write_arr(19)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_LENGTH_LSB);
    sca_user_command.data <= regs_write_arr(20)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_DATA_LSB);
    jtag_enabled_mask <= regs_write_arr(46)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_ENABLE_MASK_MSB downto REG_SLOW_CONTROL_SCA_JTAG_CTRL_ENABLE_MASK_LSB);
    jtag_shift_msb_first <= regs_write_arr(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_SHIFT_MSB_BIT);
    jtag_exec_on_every_tdo <= regs_write_arr(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_EXEC_ON_EVERY_TDO_BIT);
    jtag_no_length_update <= regs_write_arr(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_NO_SCA_LENGTH_UPDATE_BIT);
    jtag_shift_tdo_async <= regs_write_arr(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_SHIFT_TDO_ASYNC_BIT);
    jtag_cmd_length <= regs_write_arr(48)(REG_SLOW_CONTROL_SCA_JTAG_NUM_BITS_MSB downto REG_SLOW_CONTROL_SCA_JTAG_NUM_BITS_LSB);
    jtag_tms <= regs_write_arr(49)(REG_SLOW_CONTROL_SCA_JTAG_TMS_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TMS_LSB);
    jtag_tdo <= regs_write_arr(50)(REG_SLOW_CONTROL_SCA_JTAG_TDO_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDO_LSB);
    ic_address <= regs_write_arr(63)(REG_SLOW_CONTROL_IC_ADDRESS_MSB downto REG_SLOW_CONTROL_IC_ADDRESS_LSB);
    ic_rw_length <= regs_write_arr(64)(REG_SLOW_CONTROL_IC_READ_WRITE_LENGTH_MSB downto REG_SLOW_CONTROL_IC_READ_WRITE_LENGTH_LSB);
    ic_write_data <= regs_write_arr(65)(REG_SLOW_CONTROL_IC_WRITE_DATA_MSB downto REG_SLOW_CONTROL_IC_WRITE_DATA_LSB);
    ic_gbtx_i2c_addr <= regs_write_arr(68)(REG_SLOW_CONTROL_IC_GBTX_I2C_ADDR_MSB downto REG_SLOW_CONTROL_IC_GBTX_I2C_ADDR_LSB);
    ic_link_select <= regs_write_arr(69)(REG_SLOW_CONTROL_IC_GBTX_LINK_SELECT_MSB downto REG_SLOW_CONTROL_IC_GBTX_LINK_SELECT_LSB);

    -- Connect write pulse signals
    sca_reset <= regs_write_pulse_arr(0);
    manual_hard_reset <= regs_write_pulse_arr(1);
    sca_user_command_en <= regs_write_pulse_arr(21);
    jtag_shift_tms_en <= regs_write_pulse_arr(49);
    jtag_shift_tdo_en <= regs_write_pulse_arr(50);
    ic_write_req <= regs_write_pulse_arr(66);
    ic_read_req <= regs_write_pulse_arr(67);

    -- Connect write done signals
    regs_write_done_arr(21) <= sca_user_command_done_all;
    regs_write_done_arr(49) <= jtag_shift_done_all;
    regs_write_done_arr(50) <= jtag_shift_done_all;
    regs_write_done_arr(66) <= ic_write_done;

    -- Connect read pulse signals
    jtag_shift_tdi_en_arr(0) <= regs_read_pulse_arr(51);
    jtag_shift_tdi_en_arr(1) <= regs_read_pulse_arr(52);
    jtag_shift_tdi_en_arr(2) <= regs_read_pulse_arr(53);
    jtag_shift_tdi_en_arr(3) <= regs_read_pulse_arr(54);
    jtag_shift_tdi_en_arr(4) <= regs_read_pulse_arr(55);
    jtag_shift_tdi_en_arr(5) <= regs_read_pulse_arr(56);
    jtag_shift_tdi_en_arr(6) <= regs_read_pulse_arr(57);
    jtag_shift_tdi_en_arr(7) <= regs_read_pulse_arr(58);
    jtag_shift_tdi_en_arr(8) <= regs_read_pulse_arr(59);
    jtag_shift_tdi_en_arr(9) <= regs_read_pulse_arr(60);
    jtag_shift_tdi_en_arr(10) <= regs_read_pulse_arr(61);
    jtag_shift_tdi_en_arr(11) <= regs_read_pulse_arr(62);

    -- Connect read ready signals
    regs_read_ready_arr(51) <= jtag_shift_done_arr(0);
    regs_read_ready_arr(52) <= jtag_shift_done_arr(1);
    regs_read_ready_arr(53) <= jtag_shift_done_arr(2);
    regs_read_ready_arr(54) <= jtag_shift_done_arr(3);
    regs_read_ready_arr(55) <= jtag_shift_done_arr(4);
    regs_read_ready_arr(56) <= jtag_shift_done_arr(5);
    regs_read_ready_arr(57) <= jtag_shift_done_arr(6);
    regs_read_ready_arr(58) <= jtag_shift_done_arr(7);
    regs_read_ready_arr(59) <= jtag_shift_done_arr(8);
    regs_read_ready_arr(60) <= jtag_shift_done_arr(9);
    regs_read_ready_arr(61) <= jtag_shift_done_arr(10);
    regs_read_ready_arr(62) <= jtag_shift_done_arr(11);

    -- Defaults
    regs_defaults(2)(REG_SLOW_CONTROL_SCA_CTRL_TTC_HARD_RESET_EN_MSB downto REG_SLOW_CONTROL_SCA_CTRL_TTC_HARD_RESET_EN_LSB) <= REG_SLOW_CONTROL_SCA_CTRL_TTC_HARD_RESET_EN_DEFAULT;
    regs_defaults(3)(REG_SLOW_CONTROL_SCA_CTRL_SCA_RESET_ENABLE_MASK_MSB downto REG_SLOW_CONTROL_SCA_CTRL_SCA_RESET_ENABLE_MASK_LSB) <= REG_SLOW_CONTROL_SCA_CTRL_SCA_RESET_ENABLE_MASK_DEFAULT;
    regs_defaults(18)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_LINK_ENABLE_MASK_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_LINK_ENABLE_MASK_LSB) <= REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_LINK_ENABLE_MASK_DEFAULT;
    regs_defaults(19)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_CHANNEL_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_CHANNEL_LSB) <= REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_CHANNEL_DEFAULT;
    regs_defaults(19)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_COMMAND_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_COMMAND_LSB) <= REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_COMMAND_DEFAULT;
    regs_defaults(19)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_LENGTH_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_LENGTH_LSB) <= REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_LENGTH_DEFAULT;
    regs_defaults(20)(REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_DATA_MSB downto REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_DATA_LSB) <= REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_DATA_DEFAULT;
    regs_defaults(46)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_ENABLE_MASK_MSB downto REG_SLOW_CONTROL_SCA_JTAG_CTRL_ENABLE_MASK_LSB) <= REG_SLOW_CONTROL_SCA_JTAG_CTRL_ENABLE_MASK_DEFAULT;
    regs_defaults(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_SHIFT_MSB_BIT) <= REG_SLOW_CONTROL_SCA_JTAG_CTRL_SHIFT_MSB_DEFAULT;
    regs_defaults(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_EXEC_ON_EVERY_TDO_BIT) <= REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_EXEC_ON_EVERY_TDO_DEFAULT;
    regs_defaults(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_NO_SCA_LENGTH_UPDATE_BIT) <= REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_NO_SCA_LENGTH_UPDATE_DEFAULT;
    regs_defaults(47)(REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_SHIFT_TDO_ASYNC_BIT) <= REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_SHIFT_TDO_ASYNC_DEFAULT;
    regs_defaults(48)(REG_SLOW_CONTROL_SCA_JTAG_NUM_BITS_MSB downto REG_SLOW_CONTROL_SCA_JTAG_NUM_BITS_LSB) <= REG_SLOW_CONTROL_SCA_JTAG_NUM_BITS_DEFAULT;
    regs_defaults(49)(REG_SLOW_CONTROL_SCA_JTAG_TMS_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TMS_LSB) <= REG_SLOW_CONTROL_SCA_JTAG_TMS_DEFAULT;
    regs_defaults(50)(REG_SLOW_CONTROL_SCA_JTAG_TDO_MSB downto REG_SLOW_CONTROL_SCA_JTAG_TDO_LSB) <= REG_SLOW_CONTROL_SCA_JTAG_TDO_DEFAULT;
    regs_defaults(63)(REG_SLOW_CONTROL_IC_ADDRESS_MSB downto REG_SLOW_CONTROL_IC_ADDRESS_LSB) <= REG_SLOW_CONTROL_IC_ADDRESS_DEFAULT;
    regs_defaults(64)(REG_SLOW_CONTROL_IC_READ_WRITE_LENGTH_MSB downto REG_SLOW_CONTROL_IC_READ_WRITE_LENGTH_LSB) <= REG_SLOW_CONTROL_IC_READ_WRITE_LENGTH_DEFAULT;
    regs_defaults(65)(REG_SLOW_CONTROL_IC_WRITE_DATA_MSB downto REG_SLOW_CONTROL_IC_WRITE_DATA_LSB) <= REG_SLOW_CONTROL_IC_WRITE_DATA_DEFAULT;
    regs_defaults(68)(REG_SLOW_CONTROL_IC_GBTX_I2C_ADDR_MSB downto REG_SLOW_CONTROL_IC_GBTX_I2C_ADDR_LSB) <= REG_SLOW_CONTROL_IC_GBTX_I2C_ADDR_DEFAULT;
    regs_defaults(69)(REG_SLOW_CONTROL_IC_GBTX_LINK_SELECT_MSB downto REG_SLOW_CONTROL_IC_GBTX_LINK_SELECT_LSB) <= REG_SLOW_CONTROL_IC_GBTX_LINK_SELECT_DEFAULT;

    -- Define writable regs
    regs_writable_arr(2) <= '1';
    regs_writable_arr(3) <= '1';
    regs_writable_arr(18) <= '1';
    regs_writable_arr(19) <= '1';
    regs_writable_arr(20) <= '1';
    regs_writable_arr(46) <= '1';
    regs_writable_arr(47) <= '1';
    regs_writable_arr(48) <= '1';
    regs_writable_arr(49) <= '1';
    regs_writable_arr(50) <= '1';
    regs_writable_arr(63) <= '1';
    regs_writable_arr(64) <= '1';
    regs_writable_arr(65) <= '1';
    regs_writable_arr(68) <= '1';
    regs_writable_arr(69) <= '1';

    --==== Registers end ============================================================================
        
end slow_control_arch;
