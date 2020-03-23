----------------------------------------------------------------------------------
-- Company: TAMU, a lot of this is taken from WU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date: 04/24/2016 04:52:35 AM
-- Module Name: TTC
-- Project Name: GEM_AMC
-- Description: Locks to TTC clock and decodes TTC commands from the backplane link. Also provides various controls and counters to be used for configuration, diagnostics and daq   
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library UNISIM;
use UNISIM.VComponents.all;

--use work.ctp7_utils_pkg.all;
use work.ttc_pkg.all;
use work.ipbus.all;
use work.gem_pkg.all;
use work.ipb_addr_decode.all;
use work.registers.all;

--============================================================================
--                                                          Entity declaration
--============================================================================

entity ttc is
    port(
        -- reset
        reset_i             : in  std_logic;

        -- TTC clocks
        ttc_clks_i          : in  t_ttc_clks;
        ttc_clks_status_i   : in  t_ttc_clk_status;
        ttc_clks_ctrl_o     : out t_ttc_clk_ctrl;

        -- TTC backplane data signals
        ttc_data_p_i        : in  std_logic;
        ttc_data_n_i        : in  std_logic;

        -- TTC commands
        ttc_cmds_o          : out t_ttc_cmds;
    
        -- DAQ counters (L1A ID, Orbit ID, BX ID)
        ttc_daq_cntrs_o     : out t_ttc_daq_cntrs;

        -- TTC status
        ttc_status_o        : out t_ttc_status;
        
        -- L1A LED
        l1a_led_o           : out std_logic;

        -- IPbus
        ipb_reset_i         : in  std_logic;
        ipb_clk_i           : in  std_logic;
        ipb_mosi_i          : in  ipb_wbus;
        ipb_miso_o          : out ipb_rbus
    );

end ttc;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture ttc_arch of ttc is

    --============================================================================
    --                                                         Signal declarations
    --============================================================================

    signal reset_global             : std_logic;
    signal reset                    : std_logic;

    -- commands
    signal ttc_cmd                  : std_logic_vector(7 downto 0);
    signal ttc_l1a                  : std_logic;

    signal l1a_cmd                  : std_logic;
    signal bc0_cmd                  : std_logic;
    signal ec0_cmd                  : std_logic;
    signal resync_cmd               : std_logic;
    signal oc0_cmd                  : std_logic;
    signal start_cmd                : std_logic;
    signal stop_cmd                 : std_logic;
    signal hard_reset_cmd           : std_logic;
    signal calpulse_cmd             : std_logic;
    signal test_sync_cmd            : std_logic;

    signal l1a_cmd_real             : std_logic;
    signal bc0_cmd_real             : std_logic;
    signal ec0_cmd_real             : std_logic;
    signal resync_cmd_real          : std_logic;
    signal oc0_cmd_real             : std_logic;
    signal start_cmd_real           : std_logic;
    signal stop_cmd_real            : std_logic;
    signal hard_reset_cmd_real      : std_logic;
    signal calpulse_cmd_real        : std_logic;
    signal test_sync_cmd_real       : std_logic;

    -- ttc generator
    signal gen_enable               : std_logic;
    signal gen_enable_cal_only      : std_logic; -- for synthetic tests, this will use only the calpulse signal from the generator while all the other commands will come from AMC13
    signal gen_reset                : std_logic;
    signal gen_ttc_cmds             : t_ttc_cmds;
    signal gen_single_hard_reset    : std_logic;
    signal gen_single_resync        : std_logic;
    signal gen_single_ec0           : std_logic;
    signal gen_cyclic_l1a_gap       : std_logic_vector(15 downto 0);
    signal gen_cyclic_l1a_cnt       : std_logic_vector(23 downto 0);
    signal gen_cyclic_cal_l1a_gap   : std_logic_vector(11 downto 0);
    signal gen_cyclic_cal_prescale  : std_logic_vector(11 downto 0);
    signal gen_cyclic_l1a_start     : std_logic;
    signal gen_cyclic_l1a_running   : std_logic;

    -- daq counters
    signal l1id_cnt                 : std_logic_vector(23 downto 0);
    signal orbit_cnt                : std_logic_vector(15 downto 0);
    signal bx_cnt                   : std_logic_vector(11 downto 0);

    -- control and status
    signal ttc_ctrl                 : t_ttc_ctrl;
    signal ttc_status               : t_ttc_status;
    signal ttc_conf                 : t_ttc_conf; 
    
    -- calibration signals
    signal calib_l1a_countdown      : unsigned(11 downto 0) := (others => '0');

    -- stats
    constant C_NUM_OF_DECODED_TTC_CMDS : integer := 10;
    signal ttc_cmds_arr             : std_logic_vector(C_NUM_OF_DECODED_TTC_CMDS - 1 downto 0);
    signal ttc_cmds_cnt_arr         : t_std32_array(C_NUM_OF_DECODED_TTC_CMDS - 1 downto 0);
    
    signal l1a_rate                 : std_logic_vector(31 downto 0); 

    -- ttc mini spy
    signal ttc_spy_buffer           : std_logic_vector(31 downto 0) := (others => '1');
    signal ttc_spy_pointer          : integer range 0 to 31         := 0;
    signal ttc_spy_reset            : std_logic                     := '0';

    ------ Register signals begin (this section is generated by <gem_amc_repo_root>/scripts/generate_registers.py -- do not edit)
    signal regs_read_arr        : t_std32_array(REG_TTC_NUM_REGS - 1 downto 0);
    signal regs_write_arr       : t_std32_array(REG_TTC_NUM_REGS - 1 downto 0);
    signal regs_addresses       : t_std32_array(REG_TTC_NUM_REGS - 1 downto 0);
    signal regs_defaults        : t_std32_array(REG_TTC_NUM_REGS - 1 downto 0) := (others => (others => '0'));
    signal regs_read_pulse_arr  : std_logic_vector(REG_TTC_NUM_REGS - 1 downto 0);
    signal regs_write_pulse_arr : std_logic_vector(REG_TTC_NUM_REGS - 1 downto 0);
    signal regs_read_ready_arr  : std_logic_vector(REG_TTC_NUM_REGS - 1 downto 0) := (others => '1');
    signal regs_write_done_arr  : std_logic_vector(REG_TTC_NUM_REGS - 1 downto 0) := (others => '1');
    signal regs_writable_arr    : std_logic_vector(REG_TTC_NUM_REGS - 1 downto 0) := (others => '0');
    ------ Register signals end ----------------------------------------------
    
--============================================================================
--                                                          Architecture begin
--============================================================================

begin

    ------------- Wiring and resets -------------

    ttc_ctrl.clk_ctrl.reset_cnt <= ttc_ctrl.cnt_reset or ttc_ctrl.reset_local;
    ttc_clks_ctrl_o <= ttc_ctrl.clk_ctrl;
    
    ttc_status.clk_status <= ttc_clks_status_i;
    ttc_status_o <= ttc_status;

    i_reset_sync: 
    entity work.synchronizer
        generic map(
            N_STAGES => 3
        )
        port map(
            async_i => reset_i,
            clk_i   => ttc_clks_i.clk_40,
            sync_o  => reset_global
        );

    reset <= reset_global or ttc_ctrl.reset_local;

    ------------- LEDs -------------

    i_l1a_led_pulse : entity work.pulse_extend
        generic map(
            DELAY_CNT_LENGTH => C_LED_PULSE_LENGTH_TTC_CLK'length
        )
        port map(
            clk_i          => ttc_clks_i.clk_40,
            rst_i          => reset,
            pulse_length_i => C_LED_PULSE_LENGTH_TTC_CLK,
            pulse_i        => l1a_cmd,
            pulse_o        => l1a_led_o
        );

    ------------- TTC commands -------------
    
    i_ttc_cmd:
    entity work.ttc_cmd
        port map(
            clk_40_i             => ttc_clks_i.clk_40,
            ttc_data_p_i         => ttc_data_p_i,
            ttc_data_n_i         => ttc_data_n_i,
            ttc_cmd_o            => ttc_cmd,
            ttc_l1a_o            => ttc_l1a,
            tcc_err_cnt_rst_i    => ttc_ctrl.cnt_reset or reset,
            ttc_err_single_cnt_o => ttc_status.single_err,
            ttc_err_double_cnt_o => ttc_status.double_err
        );

    p_cmd:
    process(ttc_clks_i.clk_40) is
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (reset = '1') then
                bc0_cmd_real        <= '0';
                ec0_cmd_real        <= '0';
                resync_cmd_real     <= '0';
                oc0_cmd_real        <= '0';
                start_cmd_real      <= '0';
                stop_cmd_real       <= '0';
                test_sync_cmd_real  <= '0';
                hard_reset_cmd_real <= '0';
                calpulse_cmd_real   <= '0';
                l1a_cmd_real        <= '0';
                calib_l1a_countdown <= (others => '0');
            else
                if (ttc_cmd = ttc_conf.cmd_bc0) then
                    bc0_cmd_real <= '1';
                else
                    bc0_cmd_real <= '0';
                end if;
                if (ttc_cmd = ttc_conf.cmd_ec0) then
                    ec0_cmd_real <= '1';
                else
                    ec0_cmd_real <= '0';
                end if;
                if (ttc_cmd = ttc_conf.cmd_resync) then
                    resync_cmd_real <= '1';
                else
                    resync_cmd_real <= '0';
                end if;
                if (ttc_cmd = ttc_conf.cmd_oc0) then
                    oc0_cmd_real <= '1';
                else
                    oc0_cmd_real <= '0';
                end if;
                if (ttc_cmd = ttc_conf.cmd_hard_reset) then
                    hard_reset_cmd_real <= '1';
                else
                    hard_reset_cmd_real <= '0';
                end if;
                if (ttc_cmd = ttc_conf.cmd_start) then
                    start_cmd_real <= '1';
                else
                    start_cmd_real <= '0';
                end if;
                if (ttc_cmd = ttc_conf.cmd_stop) then
                    stop_cmd_real <= '1';
                else
                    stop_cmd_real <= '0';
                end if;
                if (ttc_cmd = ttc_conf.cmd_test_sync) then
                    test_sync_cmd_real <= '1';
                else
                    test_sync_cmd_real <= '0';
                end if;

                if (ttc_ctrl.calib_mode = '0') then
                    l1a_cmd_real <= ttc_l1a and ttc_ctrl.l1a_enable;
                    if (ttc_cmd = ttc_conf.cmd_calpulse) then
                        calpulse_cmd_real <= '1';
                    else
                        calpulse_cmd_real <= '0';
                    end if;
                    calib_l1a_countdown <= x"000";
                else
                    if (calib_l1a_countdown = x"001") then
                        l1a_cmd_real <= '1';
                    else
                        l1a_cmd_real <= '0';
                    end if;
                    
                    if (ttc_l1a = '1' and ttc_ctrl.l1a_enable = '1') then  
                        calpulse_cmd_real <= '1';
                        calib_l1a_countdown <= unsigned(ttc_ctrl.calib_l1a_delay);
                    else
                        calpulse_cmd_real <= '0';
                        
                        if (calib_l1a_countdown /= x"000") then
                            calib_l1a_countdown <= calib_l1a_countdown - 1;
                        else
                            calib_l1a_countdown <= x"000";
                        end if;
                        
                    end if;
                    
                end if;

            end if;

        end if;
    end process p_cmd;

    ------------- TTC generator -------------

    i_ttc_generator : entity work.ttc_generator
        port map(
            reset_i              => reset_i or gen_reset,
            ttc_clks_i           => ttc_clks_i,
            ttc_cmds_o           => gen_ttc_cmds,
            single_hard_reset_i  => gen_single_hard_reset,
            single_resync_i      => gen_single_resync,
            single_ec0_i         => gen_single_ec0,
            cyclic_l1a_gap_i     => gen_cyclic_l1a_gap,
            cyclic_l1a_cnt_i     => gen_cyclic_l1a_cnt,
            cyclic_cal_l1a_gap_i => gen_cyclic_cal_l1a_gap,
            cyclic_cal_prescale_i=> gen_cyclic_cal_prescale,
            cyclic_l1a_start_i   => gen_cyclic_l1a_start,
            cyclic_l1a_running_o => gen_cyclic_l1a_running
        );

    ------------- MUX between real and generated TTC commands -------------    
    
    bc0_cmd        <= bc0_cmd_real when gen_enable = '0' else gen_ttc_cmds.bc0;
    ec0_cmd        <= ec0_cmd_real when gen_enable = '0' else gen_ttc_cmds.ec0;
    resync_cmd     <= resync_cmd_real when gen_enable = '0' else gen_ttc_cmds.resync;
    oc0_cmd        <= oc0_cmd_real when gen_enable = '0' else '0';
    start_cmd      <= start_cmd_real when gen_enable = '0' else gen_ttc_cmds.start;
    stop_cmd       <= stop_cmd_real when gen_enable = '0' else gen_ttc_cmds.stop;
    test_sync_cmd  <= test_sync_cmd_real when gen_enable = '0' else gen_ttc_cmds.test_sync;
    hard_reset_cmd <= hard_reset_cmd_real when gen_enable = '0' else gen_ttc_cmds.hard_reset;
    calpulse_cmd   <= calpulse_cmd_real when gen_enable = '0' and gen_enable_cal_only = '0' else gen_ttc_cmds.calpulse;
    l1a_cmd        <= l1a_cmd_real when gen_enable = '0' else gen_ttc_cmds.l1a;

    ------------- TTC counters -------------
    
    p_orbit_cnt:
    process(ttc_clks_i.clk_40) is
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (reset = '1') then
                orbit_cnt <= (others => '0');
            else
                if (oc0_cmd = '1') then
                    orbit_cnt <= (others => '0');
                elsif (bc0_cmd = '1') then
                    orbit_cnt <= std_logic_vector(unsigned(orbit_cnt) + 1);
                end if;
            end if;

        end if;
    end process p_orbit_cnt;

    p_l1id_cnt:
    process(ttc_clks_i.clk_40) is
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (reset = '1') then
                l1id_cnt <= x"000001";
            else
                if (ec0_cmd = '1' or resync_cmd = '1') then
                    l1id_cnt <= x"000001";
                elsif (l1a_cmd = '1') then
                    l1id_cnt <= std_logic_vector(unsigned(l1id_cnt) + 1);
                end if;
            end if;

        end if;
    end process p_l1id_cnt;

    p_bx_cnt:
    process(ttc_clks_i.clk_40) is
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (reset = '1') then
                bx_cnt <= x"001";
            else
                if (bc0_cmd = '1') then
                    bx_cnt <= x"001";
                else
                    bx_cnt <= std_logic_vector(unsigned(bx_cnt) + 1);
                end if;
            end if;

        end if;
    end process p_bx_cnt;

    ------------- Monitoring -------------
    
    p_bc0_monitoring:
    process(ttc_clks_i.clk_40) is
    begin
        if (rising_edge(ttc_clks_i.clk_40)) then
            if (reset = '1' or ttc_ctrl.cnt_reset = '1') then
                ttc_status.bc0_status.err <= '0';
                ttc_status.bc0_status.locked <= '0';
                ttc_status.bc0_status.ovf_cnt <= (others => '0');
                ttc_status.bc0_status.udf_cnt <= (others => '0');
                ttc_status.bc0_status.unlocked_cnt <= (others => '0');
            elsif (bc0_cmd = '1') then            
                if (unsigned(bx_cnt) < unsigned(C_TTC_NUM_BXs)) then
                    ttc_status.bc0_status.err <= '1';
                    ttc_status.bc0_status.locked <= '0';
                    if (ttc_status.bc0_status.unlocked_cnt /= x"ffff") then
                        ttc_status.bc0_status.unlocked_cnt <= std_logic_vector(unsigned(ttc_status.bc0_status.unlocked_cnt) + 1);
                    end if; 
                    if (ttc_status.bc0_status.udf_cnt /= x"ffff") then
                        ttc_status.bc0_status.udf_cnt <= std_logic_vector(unsigned(ttc_status.bc0_status.udf_cnt) + 1);
                    end if; 
                elsif (unsigned(bx_cnt) > unsigned(C_TTC_NUM_BXs)) then
                    ttc_status.bc0_status.err <= '1';
                    ttc_status.bc0_status.locked <= '0';
                    if (ttc_status.bc0_status.unlocked_cnt /= x"ffff") then
                        ttc_status.bc0_status.unlocked_cnt <= std_logic_vector(unsigned(ttc_status.bc0_status.unlocked_cnt) + 1);
                    end if; 
                    if (ttc_status.bc0_status.ovf_cnt /= x"ffff") then
                        ttc_status.bc0_status.ovf_cnt <= std_logic_vector(unsigned(ttc_status.bc0_status.ovf_cnt) + 1);
                    end if; 
                else
                    ttc_status.bc0_status.err <= '0';
                    ttc_status.bc0_status.locked <= '1';
                end if;
            end if;
        end if;
    end process p_bc0_monitoring;

--    p_mini_spy:
--    process(clk_40) is
--    begin
--        if rising_edge(clk_40) then
--            if ttc_spy_reset = '1' then
--                ttc_spy_buffer <= (others => '0');
--            else
--            end if;
--        end if;
--    end process p_mini_spy;

    ttc_cmds_arr(0) <= l1a_cmd;
    ttc_cmds_arr(1) <= bc0_cmd;
    ttc_cmds_arr(2) <= ec0_cmd;
    ttc_cmds_arr(3) <= resync_cmd;
    ttc_cmds_arr(4) <= oc0_cmd;
    ttc_cmds_arr(5) <= hard_reset_cmd;
    ttc_cmds_arr(6) <= calpulse_cmd;
    ttc_cmds_arr(7) <= start_cmd;
    ttc_cmds_arr(8) <= stop_cmd;
    ttc_cmds_arr(9) <= test_sync_cmd;

    gen_ttc_cmd_cnt:
    for i in 0 to C_NUM_OF_DECODED_TTC_CMDS - 1 generate
        process(ttc_clks_i.clk_40) is
        begin
            if (rising_edge(ttc_clks_i.clk_40)) then
                if (ttc_ctrl.cnt_reset = '1' or reset = '1') then
                    ttc_cmds_cnt_arr(i) <= (others => '0');
                elsif (ttc_cmds_arr(i) = '1') then
                    ttc_cmds_cnt_arr(i) <= std_logic_vector(unsigned(ttc_cmds_cnt_arr(i)) + 1);
                end if;
            end if;
        end process;
    end generate;

    -- L1A rate counter
    i_l1a_rate_counter : entity work.rate_counter
    generic map(
        g_CLK_FREQUENCY => C_TTC_CLK_FREQUENCY_SLV,
        g_COUNTER_WIDTH => 32
    )
    port map(
        clk_i   => ttc_clks_i.clk_40,
        reset_i => reset,
        en_i    => l1a_cmd,
        rate_o  => l1a_rate
    );

    -- wiring
    ttc_daq_cntrs_o.orbit <= orbit_cnt;
    ttc_daq_cntrs_o.l1id  <= l1id_cnt;
    ttc_daq_cntrs_o.bx    <= bx_cnt;

    ttc_cmds_o.l1a        <= l1a_cmd;
    ttc_cmds_o.bc0        <= bc0_cmd;
    ttc_cmds_o.ec0        <= ec0_cmd;
    ttc_cmds_o.resync     <= resync_cmd;
    ttc_cmds_o.hard_reset <= hard_reset_cmd;
    ttc_cmds_o.calpulse   <= calpulse_cmd;
    ttc_cmds_o.start      <= start_cmd;
    ttc_cmds_o.stop       <= stop_cmd;
    ttc_cmds_o.test_sync  <= test_sync_cmd;

    --===============================================================================================
    -- this section is generated by <gem_amc_repo_root>/scripts/generate_registers.py (do not edit) 
    --==== Registers begin ==========================================================================

    -- IPbus slave instanciation
    ipbus_slave_inst : entity work.ipbus_slave
        generic map(
           g_NUM_REGS             => REG_TTC_NUM_REGS,
           g_ADDR_HIGH_BIT        => REG_TTC_ADDRESS_MSB,
           g_ADDR_LOW_BIT         => REG_TTC_ADDRESS_LSB,
           g_USE_INDIVIDUAL_ADDRS => true
       )
       port map(
           ipb_reset_i            => ipb_reset_i,
           ipb_clk_i              => ipb_clk_i,
           ipb_mosi_i             => ipb_mosi_i,
           ipb_miso_o             => ipb_miso_o,
           usr_clk_i              => ttc_clks_i.clk_40,
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
    regs_addresses(0)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"00";
    regs_addresses(1)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"01";
    regs_addresses(2)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"02";
    regs_addresses(3)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"03";
    regs_addresses(4)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"04";
    regs_addresses(5)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"05";
    regs_addresses(6)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"06";
    regs_addresses(7)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"10";
    regs_addresses(8)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"11";
    regs_addresses(9)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"12";
    regs_addresses(10)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"20";
    regs_addresses(11)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"21";
    regs_addresses(12)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"22";
    regs_addresses(13)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"23";
    regs_addresses(14)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"24";
    regs_addresses(15)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"25";
    regs_addresses(16)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"26";
    regs_addresses(17)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"27";
    regs_addresses(18)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"28";
    regs_addresses(19)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"29";
    regs_addresses(20)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"40";
    regs_addresses(21)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"41";
    regs_addresses(22)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"42";
    regs_addresses(23)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"43";
    regs_addresses(24)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"50";
    regs_addresses(25)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"51";
    regs_addresses(26)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"52";
    regs_addresses(27)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"53";
    regs_addresses(28)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"54";
    regs_addresses(29)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"55";
    regs_addresses(30)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"56";
    regs_addresses(31)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"57";
    regs_addresses(32)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"58";
    regs_addresses(33)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"59";
    regs_addresses(34)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"60";
    regs_addresses(35)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"61";
    regs_addresses(36)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"62";
    regs_addresses(37)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"70";
    regs_addresses(38)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"71";
    regs_addresses(39)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"72";
    regs_addresses(40)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"73";
    regs_addresses(41)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"74";
    regs_addresses(42)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"75";
    regs_addresses(43)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"76";
    regs_addresses(44)(REG_TTC_ADDRESS_MSB downto REG_TTC_ADDRESS_LSB) <= x"77";

    -- Connect read signals
    regs_read_arr(4)(REG_TTC_CTRL_L1A_ENABLE_BIT) <= ttc_ctrl.l1a_enable;
    regs_read_arr(4)(REG_TTC_CTRL_CALIBRATION_MODE_BIT) <= ttc_ctrl.calib_mode;
    regs_read_arr(4)(REG_TTC_CTRL_DISABLE_PHASE_ALIGNMENT_BIT) <= ttc_ctrl.clk_ctrl.phase_align_disable;
    regs_read_arr(4)(REG_TTC_CTRL_PA_DISABLE_INIT_SHIFT_OUT_BIT) <= ttc_ctrl.clk_ctrl.pa_no_init_shift_out;
    regs_read_arr(4)(REG_TTC_CTRL_PA_MANUAL_OVERRIDE_BIT) <= ttc_ctrl.clk_ctrl.pa_manual_shift_ovrd;
    regs_read_arr(4)(REG_TTC_CTRL_PA_MANUAL_SHIFT_DIR_BIT) <= ttc_ctrl.clk_ctrl.pa_manual_shift_dir;
    regs_read_arr(4)(REG_TTC_CTRL_CALPULSE_L1A_DELAY_MSB downto REG_TTC_CTRL_CALPULSE_L1A_DELAY_LSB) <= ttc_ctrl.calib_l1a_delay;
    regs_read_arr(7)(REG_TTC_CONFIG_CMD_BC0_MSB downto REG_TTC_CONFIG_CMD_BC0_LSB) <= ttc_conf.cmd_bc0;
    regs_read_arr(7)(REG_TTC_CONFIG_CMD_EC0_MSB downto REG_TTC_CONFIG_CMD_EC0_LSB) <= ttc_conf.cmd_ec0;
    regs_read_arr(7)(REG_TTC_CONFIG_CMD_RESYNC_MSB downto REG_TTC_CONFIG_CMD_RESYNC_LSB) <= ttc_conf.cmd_resync;
    regs_read_arr(7)(REG_TTC_CONFIG_CMD_OC0_MSB downto REG_TTC_CONFIG_CMD_OC0_LSB) <= ttc_conf.cmd_oc0;
    regs_read_arr(8)(REG_TTC_CONFIG_CMD_HARD_RESET_MSB downto REG_TTC_CONFIG_CMD_HARD_RESET_LSB) <= ttc_conf.cmd_hard_reset;
    regs_read_arr(8)(REG_TTC_CONFIG_CMD_CALPULSE_MSB downto REG_TTC_CONFIG_CMD_CALPULSE_LSB) <= ttc_conf.cmd_calpulse;
    regs_read_arr(8)(REG_TTC_CONFIG_CMD_START_MSB downto REG_TTC_CONFIG_CMD_START_LSB) <= ttc_conf.cmd_start;
    regs_read_arr(8)(REG_TTC_CONFIG_CMD_STOP_MSB downto REG_TTC_CONFIG_CMD_STOP_LSB) <= ttc_conf.cmd_stop;
    regs_read_arr(9)(REG_TTC_CONFIG_CMD_TEST_SYNC_MSB downto REG_TTC_CONFIG_CMD_TEST_SYNC_LSB) <= ttc_conf.cmd_test_sync;
    regs_read_arr(10)(REG_TTC_STATUS_CLK_MMCM_LOCKED_BIT) <= ttc_clks_status_i.mmcm_locked;
    regs_read_arr(10)(REG_TTC_STATUS_CLK_SYNC_DONE_BIT) <= ttc_clks_status_i.sync_done;
    regs_read_arr(10)(REG_TTC_STATUS_CLK_PHASE_LOCKED_BIT) <= ttc_clks_status_i.phase_locked;
    regs_read_arr(10)(REG_TTC_STATUS_CLK_MMCM_UNLOCK_CNT_MSB downto REG_TTC_STATUS_CLK_MMCM_UNLOCK_CNT_LSB) <= ttc_clks_status_i.mmcm_unlock_cnt;
    regs_read_arr(11)(REG_TTC_STATUS_CLK_SYNC_RESTART_CNT_MSB downto REG_TTC_STATUS_CLK_SYNC_RESTART_CNT_LSB) <= ttc_clks_status_i.sync_restart_cnt;
    regs_read_arr(11)(REG_TTC_STATUS_CLK_PHASE_UNLOCK_CNT_MSB downto REG_TTC_STATUS_CLK_PHASE_UNLOCK_CNT_LSB) <= ttc_clks_status_i.phase_unlock_cnt;
    regs_read_arr(12)(REG_TTC_STATUS_CLK_SYNC_DONE_TIME_MSB downto REG_TTC_STATUS_CLK_SYNC_DONE_TIME_LSB) <= ttc_clks_status_i.sync_done_time;
    regs_read_arr(12)(REG_TTC_STATUS_CLK_PHASE_UNLOCK_TIME_MSB downto REG_TTC_STATUS_CLK_PHASE_UNLOCK_TIME_LSB) <= ttc_clks_status_i.phase_unlock_time;
    regs_read_arr(13)(REG_TTC_STATUS_CLK_PA_PLL_LOCK_WINDOW_MSB downto REG_TTC_STATUS_CLK_PA_PLL_LOCK_WINDOW_LSB) <= ttc_clks_status_i.pll_lock_window;
    regs_read_arr(13)(REG_TTC_STATUS_CLK_PA_PHASE_SHIFT_CNT_MSB downto REG_TTC_STATUS_CLK_PA_PHASE_SHIFT_CNT_LSB) <= ttc_clks_status_i.pa_phase_shift_cnt;
    regs_read_arr(14)(REG_TTC_STATUS_CLK_PA_PLL_LOCK_CLOCKS_MSB downto REG_TTC_STATUS_CLK_PA_PLL_LOCK_CLOCKS_LSB) <= ttc_clks_status_i.pll_lock_time;
    regs_read_arr(14)(REG_TTC_STATUS_CLK_PA_FSM_STATE_MSB downto REG_TTC_STATUS_CLK_PA_FSM_STATE_LSB) <= ttc_clks_status_i.pa_fsm_state;
    regs_read_arr(15)(REG_TTC_STATUS_CLK_PA_SHIFT_BACK_FAIL_CNT_MSB downto REG_TTC_STATUS_CLK_PA_SHIFT_BACK_FAIL_CNT_LSB) <= ttc_clks_status_i.pa_shift_back_fail_cnt;
    regs_read_arr(16)(REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_MSB downto REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_LSB) <= ttc_clks_status_i.phase_monitor.phase;
    regs_read_arr(16)(REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_MEAN_MSB downto REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_MEAN_LSB) <= ttc_clks_status_i.phase_monitor.phase_mean;
    regs_read_arr(17)(REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_MIN_MSB downto REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_MIN_LSB) <= ttc_clks_status_i.phase_monitor.phase_min;
    regs_read_arr(17)(REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_MAX_MSB downto REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_MAX_LSB) <= ttc_clks_status_i.phase_monitor.phase_max;
    regs_read_arr(18)(REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_JUMP_CNT_MSB downto REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_JUMP_CNT_LSB) <= ttc_clks_status_i.phase_monitor.phase_jump_cnt;
    regs_read_arr(18)(REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_JUMP_SIZE_MSB downto REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_JUMP_SIZE_LSB) <= ttc_clks_status_i.phase_monitor.phase_jump_size;
    regs_read_arr(19)(REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_JUMP_TIME_MSB downto REG_TTC_STATUS_CLK_PHASE_MONITOR_PHASE_JUMP_TIME_LSB) <= ttc_clks_status_i.phase_monitor.phase_jump_time;
    regs_read_arr(20)(REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_MSB downto REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_LSB) <= ttc_status.single_err;
    regs_read_arr(20)(REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_MSB downto REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_LSB) <= ttc_status.double_err;
    regs_read_arr(21)(REG_TTC_STATUS_BC0_LOCKED_BIT) <= ttc_status.bc0_status.locked;
    regs_read_arr(22)(REG_TTC_STATUS_BC0_UNLOCK_CNT_MSB downto REG_TTC_STATUS_BC0_UNLOCK_CNT_LSB) <= ttc_status.bc0_status.unlocked_cnt;
    regs_read_arr(23)(REG_TTC_STATUS_BC0_OVERFLOW_CNT_MSB downto REG_TTC_STATUS_BC0_OVERFLOW_CNT_LSB) <= ttc_status.bc0_status.ovf_cnt;
    regs_read_arr(23)(REG_TTC_STATUS_BC0_UNDERFLOW_CNT_MSB downto REG_TTC_STATUS_BC0_UNDERFLOW_CNT_LSB) <= ttc_status.bc0_status.udf_cnt;
    regs_read_arr(24)(REG_TTC_CMD_COUNTERS_L1A_MSB downto REG_TTC_CMD_COUNTERS_L1A_LSB) <= ttc_cmds_cnt_arr(0);
    regs_read_arr(25)(REG_TTC_CMD_COUNTERS_BC0_MSB downto REG_TTC_CMD_COUNTERS_BC0_LSB) <= ttc_cmds_cnt_arr(1);
    regs_read_arr(26)(REG_TTC_CMD_COUNTERS_EC0_MSB downto REG_TTC_CMD_COUNTERS_EC0_LSB) <= ttc_cmds_cnt_arr(2);
    regs_read_arr(27)(REG_TTC_CMD_COUNTERS_RESYNC_MSB downto REG_TTC_CMD_COUNTERS_RESYNC_LSB) <= ttc_cmds_cnt_arr(3);
    regs_read_arr(28)(REG_TTC_CMD_COUNTERS_OC0_MSB downto REG_TTC_CMD_COUNTERS_OC0_LSB) <= ttc_cmds_cnt_arr(4);
    regs_read_arr(29)(REG_TTC_CMD_COUNTERS_HARD_RESET_MSB downto REG_TTC_CMD_COUNTERS_HARD_RESET_LSB) <= ttc_cmds_cnt_arr(5);
    regs_read_arr(30)(REG_TTC_CMD_COUNTERS_CALPULSE_MSB downto REG_TTC_CMD_COUNTERS_CALPULSE_LSB) <= ttc_cmds_cnt_arr(6);
    regs_read_arr(31)(REG_TTC_CMD_COUNTERS_START_MSB downto REG_TTC_CMD_COUNTERS_START_LSB) <= ttc_cmds_cnt_arr(7);
    regs_read_arr(32)(REG_TTC_CMD_COUNTERS_STOP_MSB downto REG_TTC_CMD_COUNTERS_STOP_LSB) <= ttc_cmds_cnt_arr(8);
    regs_read_arr(33)(REG_TTC_CMD_COUNTERS_TEST_SYNC_MSB downto REG_TTC_CMD_COUNTERS_TEST_SYNC_LSB) <= ttc_cmds_cnt_arr(9);
    regs_read_arr(34)(REG_TTC_L1A_ID_MSB downto REG_TTC_L1A_ID_LSB) <= l1id_cnt;
    regs_read_arr(35)(REG_TTC_L1A_RATE_MSB downto REG_TTC_L1A_RATE_LSB) <= l1a_rate;
    regs_read_arr(36)(REG_TTC_TTC_SPY_BUFFER_MSB downto REG_TTC_TTC_SPY_BUFFER_LSB) <= ttc_spy_buffer;
    regs_read_arr(38)(REG_TTC_GENERATOR_ENABLE_BIT) <= gen_enable;
    regs_read_arr(38)(REG_TTC_GENERATOR_CYCLIC_RUNNING_BIT) <= gen_cyclic_l1a_running;
    regs_read_arr(38)(REG_TTC_GENERATOR_ENABLE_CALPULSE_ONLY_BIT) <= gen_enable_cal_only;
    regs_read_arr(38)(REG_TTC_GENERATOR_CYCLIC_L1A_GAP_MSB downto REG_TTC_GENERATOR_CYCLIC_L1A_GAP_LSB) <= gen_cyclic_l1a_gap;
    regs_read_arr(38)(REG_TTC_GENERATOR_CYCLIC_CALPULSE_TO_L1A_GAP_MSB downto REG_TTC_GENERATOR_CYCLIC_CALPULSE_TO_L1A_GAP_LSB) <= gen_cyclic_cal_l1a_gap;
    regs_read_arr(42)(REG_TTC_GENERATOR_CYCLIC_L1A_COUNT_MSB downto REG_TTC_GENERATOR_CYCLIC_L1A_COUNT_LSB) <= gen_cyclic_l1a_cnt;
    regs_read_arr(44)(REG_TTC_GENERATOR_CYCLIC_CALPULSE_PRESCALE_MSB downto REG_TTC_GENERATOR_CYCLIC_CALPULSE_PRESCALE_LSB) <= gen_cyclic_cal_prescale;

    -- Connect write signals
    ttc_ctrl.l1a_enable <= regs_write_arr(4)(REG_TTC_CTRL_L1A_ENABLE_BIT);
    ttc_ctrl.calib_mode <= regs_write_arr(4)(REG_TTC_CTRL_CALIBRATION_MODE_BIT);
    ttc_ctrl.clk_ctrl.phase_align_disable <= regs_write_arr(4)(REG_TTC_CTRL_DISABLE_PHASE_ALIGNMENT_BIT);
    ttc_ctrl.clk_ctrl.pa_no_init_shift_out <= regs_write_arr(4)(REG_TTC_CTRL_PA_DISABLE_INIT_SHIFT_OUT_BIT);
    ttc_ctrl.clk_ctrl.pa_manual_shift_ovrd <= regs_write_arr(4)(REG_TTC_CTRL_PA_MANUAL_OVERRIDE_BIT);
    ttc_ctrl.clk_ctrl.pa_manual_shift_dir <= regs_write_arr(4)(REG_TTC_CTRL_PA_MANUAL_SHIFT_DIR_BIT);
    ttc_ctrl.calib_l1a_delay <= regs_write_arr(4)(REG_TTC_CTRL_CALPULSE_L1A_DELAY_MSB downto REG_TTC_CTRL_CALPULSE_L1A_DELAY_LSB);
    ttc_conf.cmd_bc0 <= regs_write_arr(7)(REG_TTC_CONFIG_CMD_BC0_MSB downto REG_TTC_CONFIG_CMD_BC0_LSB);
    ttc_conf.cmd_ec0 <= regs_write_arr(7)(REG_TTC_CONFIG_CMD_EC0_MSB downto REG_TTC_CONFIG_CMD_EC0_LSB);
    ttc_conf.cmd_resync <= regs_write_arr(7)(REG_TTC_CONFIG_CMD_RESYNC_MSB downto REG_TTC_CONFIG_CMD_RESYNC_LSB);
    ttc_conf.cmd_oc0 <= regs_write_arr(7)(REG_TTC_CONFIG_CMD_OC0_MSB downto REG_TTC_CONFIG_CMD_OC0_LSB);
    ttc_conf.cmd_hard_reset <= regs_write_arr(8)(REG_TTC_CONFIG_CMD_HARD_RESET_MSB downto REG_TTC_CONFIG_CMD_HARD_RESET_LSB);
    ttc_conf.cmd_calpulse <= regs_write_arr(8)(REG_TTC_CONFIG_CMD_CALPULSE_MSB downto REG_TTC_CONFIG_CMD_CALPULSE_LSB);
    ttc_conf.cmd_start <= regs_write_arr(8)(REG_TTC_CONFIG_CMD_START_MSB downto REG_TTC_CONFIG_CMD_START_LSB);
    ttc_conf.cmd_stop <= regs_write_arr(8)(REG_TTC_CONFIG_CMD_STOP_MSB downto REG_TTC_CONFIG_CMD_STOP_LSB);
    ttc_conf.cmd_test_sync <= regs_write_arr(9)(REG_TTC_CONFIG_CMD_TEST_SYNC_MSB downto REG_TTC_CONFIG_CMD_TEST_SYNC_LSB);
    gen_enable <= regs_write_arr(38)(REG_TTC_GENERATOR_ENABLE_BIT);
    gen_enable_cal_only <= regs_write_arr(38)(REG_TTC_GENERATOR_ENABLE_CALPULSE_ONLY_BIT);
    gen_cyclic_l1a_gap <= regs_write_arr(38)(REG_TTC_GENERATOR_CYCLIC_L1A_GAP_MSB downto REG_TTC_GENERATOR_CYCLIC_L1A_GAP_LSB);
    gen_cyclic_cal_l1a_gap <= regs_write_arr(38)(REG_TTC_GENERATOR_CYCLIC_CALPULSE_TO_L1A_GAP_MSB downto REG_TTC_GENERATOR_CYCLIC_CALPULSE_TO_L1A_GAP_LSB);
    gen_cyclic_l1a_cnt <= regs_write_arr(42)(REG_TTC_GENERATOR_CYCLIC_L1A_COUNT_MSB downto REG_TTC_GENERATOR_CYCLIC_L1A_COUNT_LSB);
    gen_cyclic_cal_prescale <= regs_write_arr(44)(REG_TTC_GENERATOR_CYCLIC_CALPULSE_PRESCALE_MSB downto REG_TTC_GENERATOR_CYCLIC_CALPULSE_PRESCALE_LSB);

    -- Connect write pulse signals
    ttc_ctrl.reset_local <= regs_write_pulse_arr(0);
    ttc_ctrl.clk_ctrl.reset_mmcm <= regs_write_pulse_arr(1);
    ttc_ctrl.cnt_reset <= regs_write_pulse_arr(2);
    ttc_ctrl.clk_ctrl.reset_sync_fsm <= regs_write_pulse_arr(3);
    ttc_ctrl.clk_ctrl.pa_manual_shift_en <= regs_write_pulse_arr(5);
    ttc_ctrl.clk_ctrl.reset_pll <= regs_write_pulse_arr(6);
    gen_reset <= regs_write_pulse_arr(37);
    gen_single_hard_reset <= regs_write_pulse_arr(39);
    gen_single_resync <= regs_write_pulse_arr(40);
    gen_single_ec0 <= regs_write_pulse_arr(41);
    gen_cyclic_l1a_start <= regs_write_pulse_arr(43);

    -- Connect write done signals

    -- Connect read pulse signals
    ttc_spy_reset <= regs_read_pulse_arr(36);

    -- Connect read ready signals

    -- Defaults
    regs_defaults(4)(REG_TTC_CTRL_L1A_ENABLE_BIT) <= REG_TTC_CTRL_L1A_ENABLE_DEFAULT;
    regs_defaults(4)(REG_TTC_CTRL_CALIBRATION_MODE_BIT) <= REG_TTC_CTRL_CALIBRATION_MODE_DEFAULT;
    regs_defaults(4)(REG_TTC_CTRL_DISABLE_PHASE_ALIGNMENT_BIT) <= REG_TTC_CTRL_DISABLE_PHASE_ALIGNMENT_DEFAULT;
    regs_defaults(4)(REG_TTC_CTRL_PA_DISABLE_INIT_SHIFT_OUT_BIT) <= REG_TTC_CTRL_PA_DISABLE_INIT_SHIFT_OUT_DEFAULT;
    regs_defaults(4)(REG_TTC_CTRL_PA_MANUAL_OVERRIDE_BIT) <= REG_TTC_CTRL_PA_MANUAL_OVERRIDE_DEFAULT;
    regs_defaults(4)(REG_TTC_CTRL_PA_MANUAL_SHIFT_DIR_BIT) <= REG_TTC_CTRL_PA_MANUAL_SHIFT_DIR_DEFAULT;
    regs_defaults(4)(REG_TTC_CTRL_CALPULSE_L1A_DELAY_MSB downto REG_TTC_CTRL_CALPULSE_L1A_DELAY_LSB) <= REG_TTC_CTRL_CALPULSE_L1A_DELAY_DEFAULT;
    regs_defaults(7)(REG_TTC_CONFIG_CMD_BC0_MSB downto REG_TTC_CONFIG_CMD_BC0_LSB) <= REG_TTC_CONFIG_CMD_BC0_DEFAULT;
    regs_defaults(7)(REG_TTC_CONFIG_CMD_EC0_MSB downto REG_TTC_CONFIG_CMD_EC0_LSB) <= REG_TTC_CONFIG_CMD_EC0_DEFAULT;
    regs_defaults(7)(REG_TTC_CONFIG_CMD_RESYNC_MSB downto REG_TTC_CONFIG_CMD_RESYNC_LSB) <= REG_TTC_CONFIG_CMD_RESYNC_DEFAULT;
    regs_defaults(7)(REG_TTC_CONFIG_CMD_OC0_MSB downto REG_TTC_CONFIG_CMD_OC0_LSB) <= REG_TTC_CONFIG_CMD_OC0_DEFAULT;
    regs_defaults(8)(REG_TTC_CONFIG_CMD_HARD_RESET_MSB downto REG_TTC_CONFIG_CMD_HARD_RESET_LSB) <= REG_TTC_CONFIG_CMD_HARD_RESET_DEFAULT;
    regs_defaults(8)(REG_TTC_CONFIG_CMD_CALPULSE_MSB downto REG_TTC_CONFIG_CMD_CALPULSE_LSB) <= REG_TTC_CONFIG_CMD_CALPULSE_DEFAULT;
    regs_defaults(8)(REG_TTC_CONFIG_CMD_START_MSB downto REG_TTC_CONFIG_CMD_START_LSB) <= REG_TTC_CONFIG_CMD_START_DEFAULT;
    regs_defaults(8)(REG_TTC_CONFIG_CMD_STOP_MSB downto REG_TTC_CONFIG_CMD_STOP_LSB) <= REG_TTC_CONFIG_CMD_STOP_DEFAULT;
    regs_defaults(9)(REG_TTC_CONFIG_CMD_TEST_SYNC_MSB downto REG_TTC_CONFIG_CMD_TEST_SYNC_LSB) <= REG_TTC_CONFIG_CMD_TEST_SYNC_DEFAULT;
    regs_defaults(38)(REG_TTC_GENERATOR_ENABLE_BIT) <= REG_TTC_GENERATOR_ENABLE_DEFAULT;
    regs_defaults(38)(REG_TTC_GENERATOR_ENABLE_CALPULSE_ONLY_BIT) <= REG_TTC_GENERATOR_ENABLE_CALPULSE_ONLY_DEFAULT;
    regs_defaults(38)(REG_TTC_GENERATOR_CYCLIC_L1A_GAP_MSB downto REG_TTC_GENERATOR_CYCLIC_L1A_GAP_LSB) <= REG_TTC_GENERATOR_CYCLIC_L1A_GAP_DEFAULT;
    regs_defaults(38)(REG_TTC_GENERATOR_CYCLIC_CALPULSE_TO_L1A_GAP_MSB downto REG_TTC_GENERATOR_CYCLIC_CALPULSE_TO_L1A_GAP_LSB) <= REG_TTC_GENERATOR_CYCLIC_CALPULSE_TO_L1A_GAP_DEFAULT;
    regs_defaults(42)(REG_TTC_GENERATOR_CYCLIC_L1A_COUNT_MSB downto REG_TTC_GENERATOR_CYCLIC_L1A_COUNT_LSB) <= REG_TTC_GENERATOR_CYCLIC_L1A_COUNT_DEFAULT;
    regs_defaults(44)(REG_TTC_GENERATOR_CYCLIC_CALPULSE_PRESCALE_MSB downto REG_TTC_GENERATOR_CYCLIC_CALPULSE_PRESCALE_LSB) <= REG_TTC_GENERATOR_CYCLIC_CALPULSE_PRESCALE_DEFAULT;

    -- Define writable regs
    regs_writable_arr(4) <= '1';
    regs_writable_arr(7) <= '1';
    regs_writable_arr(8) <= '1';
    regs_writable_arr(9) <= '1';
    regs_writable_arr(38) <= '1';
    regs_writable_arr(42) <= '1';
    regs_writable_arr(44) <= '1';

    --==== Registers end ============================================================================

end ttc_arch;
--============================================================================
--                                                            Architecture end
--============================================================================
