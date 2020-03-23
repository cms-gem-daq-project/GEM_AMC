----------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date: 12/13/2016 14:27:30
-- Module Name: TTC_CLOCKS
-- Project Name: GEM_AMC
-- Description: Given a jitter cleaned TTC clock (160MHz, coming from MGT ref) and a reference 40MHz TTC clock from the backplane, this module   
--              generates 40MHz, 80MHz, 120MHz, 160MHz TTC clocks that are phase aligned with the reference TTC clock from the backplane.
--              All clocks are generated from the jitter cleaned clock and then phase shifted to match the reference, using PLL to check for phase alignment.
--              Note that phase alignment might take quite some time. It's phase shifting the 40MHz clock in steps of ~19ps and each step can take up to ~30us. 
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library UNISIM;
use UNISIM.VComponents.all;

use work.ttc_pkg.all;
use work.gem_board_config_package.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity ttc_clocks is
    generic (
        PLL_LOCK_WAIT_TIMEOUT     : unsigned(23 downto 0) := x"002710" -- way too long, will measure how low we can go here
    );
    port (
        clk_40_ttc_p_i          : in  std_logic; -- TTC backplane clock signals
        clk_40_ttc_n_i          : in  std_logic;
        clk_gbt_mgt_txout_i     : in  std_logic; -- TTC jitter cleaned 160MHz or 320MHz TTC clock, should come from MGT ref (160MHz in GBTX case, and 320MHz in LpGBT case)
        clocks_o                : out t_ttc_clks;
        ctrl_i                  : in  t_ttc_clk_ctrl; -- control signals
        status_o                : out t_ttc_clk_status -- status outputs
    );

end ttc_clocks;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture ttc_clocks_arch of ttc_clocks is

COMPONENT vio_ttc_clocks
  PORT (
    clk : IN STD_LOGIC;
    probe_in0  : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in1  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    probe_in2  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_in3  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);   
    probe_in4  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    probe_in5  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    probe_in6  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out0 : OUT STD_LOGIC;
    probe_out1 : OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT ila_ttc_clocks
    PORT (
        clk : IN STD_LOGIC;
        probe0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); 
        probe1 : IN STD_LOGIC; 
        probe2 : IN STD_LOGIC; 
        probe3 : IN STD_LOGIC; 
        probe4 : IN STD_LOGIC; 
        probe5 : IN STD_LOGIC;
        probe6 : IN STD_LOGIC
    );
END COMPONENT  ;

    --============================================================================
    --                                                         Signal declarations
    --============================================================================
    signal clk_40_ttc_ibufgds   : std_logic;
    signal clk_40_ttc_bufg      : std_logic;

    signal clkin                : std_logic;

    signal clkfbout             : std_logic;
    signal clkfbin              : std_logic;

    signal clk_40               : std_logic;
    signal clk_80               : std_logic;
    signal clk_160              : std_logic;
    signal clk_320              : std_logic;
    signal clk_gbt_mgt_usrclk   : std_logic;

    signal ttc_clocks_bufg      : t_ttc_clks;
    
    -- this function determines the feedback clock multiplication factor based on whether the station is using LpGBT or GBTX
    function get_clkfbout_mult(gem_station : integer; is_lpgbt_loopback : boolean) return real is
    begin
        if is_lpgbt_loopback then
            return 3.0;
        elsif gem_station = 0 then
            return 3.0;
        elsif gem_station = 1 then
            return 6.0;
        elsif gem_station = 2 then
            return 6.0;
        else -- hmm whatever, lets say 6.0
            return 6.0;  
        end if;
    end function get_clkfbout_mult;    

    -- this function determines the division factor to get the MGT user clk based on whether the station is using LpGBT or GBTX
    function get_gbt_mgt_clk_divide(gem_station : integer; is_lpgbt_loopback : boolean) return integer is
    begin
        if is_lpgbt_loopback then
            return 12;
        elsif gem_station = 0 then
            return 3;
        elsif gem_station = 1 then
            return 8;
        elsif gem_station = 2 then
            return 8;
        else -- hmm whatever, lets say 8
            return 8;  
        end if;
    end function get_gbt_mgt_clk_divide;    

    function get_clkin_period(gem_station : integer; is_lpgbt_loopback : boolean) return real is
    begin
        if is_lpgbt_loopback then
            return 3.125;
        elsif gem_station = 0 then
            return 3.125;
        elsif gem_station = 1 then
            return 6.25;
        elsif gem_station = 2 then
            return 6.25;
        else -- hmm whatever, lets say 6.25
            return 6.25;  
        end if;
    end function get_clkin_period;    

    function get_clkin_frequency_slv32(gem_station : integer; is_lpgbt_loopback : boolean) return std_logic_vector is
    begin
        if is_lpgbt_loopback then
            return x"131c74c0"; -- 320.632
        elsif gem_station = 0 then
            return x"131c74c0"; -- 320.632
        elsif gem_station = 1 then
            return x"098e3a60"; -- 160.316MHz
        elsif gem_station = 2 then
            return x"098e3a60"; -- 160.316MHz
        else -- hmm whatever, lets say 160
            return x"098e3a60";  -- 160.316MHz
        end if;
    end function get_clkin_frequency_slv32;    


    constant CFG_CLKFBOUT_MULT : real := get_clkfbout_mult(CFG_GEM_STATION, CFG_LPGBT_2P56G_LOOPBACK_TEST);
    constant CFG_GBT_MGT_CLK_DIVIDE : integer := get_gbt_mgt_clk_divide(CFG_GEM_STATION, CFG_LPGBT_2P56G_LOOPBACK_TEST);
    constant CFG_CLKIN1_PERIOD : real := get_clkin_period(CFG_GEM_STATION, CFG_LPGBT_2P56G_LOOPBACK_TEST);
    constant CFG_CLKIN1_FREQ_SLV32 : std_logic_vector := get_clkin_frequency_slv32(CFG_GEM_STATION, CFG_LPGBT_2P56G_LOOPBACK_TEST);
    
    ----------------- phase alignment ------------------
    constant MMCM_PS_DONE_TIMEOUT : unsigned(7 downto 0) := x"9f"; -- datasheet says MMCM should complete a phase shift in 12 clocks, but we check it with some margin, just in case
    type pa_state_t is (IDLE, CHECK_FOR_LOCK, SHIFT_PHASE, WAIT_SHIFT_DONE, CHECK_FOR_UNLOCK, SHIFT_BACK, SYNC_DONE, DEAD);

    signal mmcm_ps_clk              : std_logic;
    signal mmcm_ps_en               : std_logic;
    signal mmcm_ps_incdec           : std_logic;
    signal mmcm_ps_done             : std_logic;
    signal mmcm_locked_raw          : std_logic;
    signal mmcm_locked              : std_logic;

    signal pll_locked_raw           : std_logic;
    signal pll_locked               : std_logic;
    signal pll_reset                : std_logic;

    signal fsm_reset                : std_logic := '0';
    signal fsm_reset_debug          : std_logic;
    signal sync_good                : std_logic;
    signal pa_state                 : pa_state_t := IDLE;
    signal searching_for_unlock     : std_logic;
    signal initial_unlock_search    : std_logic := '1';
    signal shifting_back            : std_logic;
    signal shift_cnt                : unsigned(15 downto 0) := (others => '0');
    signal shift_cnt_to_lock        : unsigned(15 downto 0) := (others => '0');
    signal shift_back_cnt           : unsigned(15 downto 0) := (others => '0');
    signal pll_lock_wait_timer      : unsigned(23 downto 0) := (others => '0');
    signal pll_lock_window          : unsigned(15 downto 0) := (others => '0');
    signal mmcm_ps_done_timer       : unsigned(7 downto 0)  := (others => '0');
    signal unlock_cnt               : unsigned(15 downto 0) := (others => '0');
    signal mmcm_unlock_cnt          : unsigned(15 downto 0) := (others => '0');
    signal pll_unlock_cnt           : unsigned(15 downto 0) := (others => '0');
    
    signal mmcm_lock_stable_cnt     : integer range 0 to 127 := 0;
    signal pll_lock_stable_cnt      : integer range 0 to 127 := 0;
    signal pll_unlock_stable_cnt    : integer range 0 to 127 := 0;

    constant LOCK_STABLE_TIMEOUT    : integer := 12;
    constant UNLOCK_STABLE_TIMEOUT  : integer := 12;
    
    -- time counters
    signal sync_done_time           : std_logic_vector(15 downto 0);
    signal phase_unlock_time        : std_logic_vector(15 downto 0);
    
    -- debug counters
    signal shift_back_fail_cnt      : unsigned(7 downto 0) := (others => '0');
    
    -- ttc phase monitoring
    signal ttc_phase                : std_logic_vector(11 downto 0); -- phase difference between the rising edges of the two clocks (each count is about 18.6012ps)
    signal ttc_phase_mean           : std_logic_vector(11 downto 0);
    signal ttc_phase_min            : std_logic_vector(11 downto 0);
    signal ttc_phase_max            : std_logic_vector(11 downto 0);
    signal ttc_phase_jump           : std_logic := '0';
    signal ttc_phase_jump_cnt       : std_logic_vector(15 downto 0);
    signal ttc_phase_jump_size      : std_logic_vector(11 downto 0);
    signal ttc_phase_jump_time      : std_logic_vector(15 downto 0); -- number of seconds since last phase jump
   
    -- control signals moved to mmcm_ps_clk domain
    signal ctrl                     : t_ttc_clk_ctrl;
    
--============================================================================
--                                                          Architecture begin
--============================================================================
begin

    mmcm_ps_clk <= clk_gbt_mgt_txout_i;

    -- CDC of the control signals to mmcm_ps_clk domain
    g_sync_reset_cnt :      entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => ctrl_i.reset_cnt, clk_i   => mmcm_ps_clk, sync_o  => ctrl.reset_cnt);
    g_sync_reset_sync_fsm : entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => ctrl_i.reset_sync_fsm, clk_i   => mmcm_ps_clk, sync_o  => ctrl.reset_sync_fsm);
    g_sync_reset_mmcm :     entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => ctrl_i.reset_mmcm, clk_i   => mmcm_ps_clk, sync_o  => ctrl.reset_mmcm);
    g_sync_reset_pll :      entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => ctrl_i.reset_pll, clk_i   => mmcm_ps_clk, sync_o  => ctrl.reset_pll);
    g_sync_pa_disable :     entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => ctrl_i.phase_align_disable, clk_i   => mmcm_ps_clk, sync_o  => ctrl.phase_align_disable);
    g_sync_no_init_shift_o: entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => ctrl_i.pa_no_init_shift_out, clk_i   => mmcm_ps_clk, sync_o  => ctrl.pa_no_init_shift_out);
    g_sync_man_shift_dir :  entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => ctrl_i.pa_manual_shift_dir, clk_i   => mmcm_ps_clk, sync_o  => ctrl.pa_manual_shift_dir);
    g_sync_man_shift_ovrd : entity work.synchronizer generic map(N_STAGES => 2) port map(async_i => ctrl_i.pa_manual_shift_ovrd, clk_i   => mmcm_ps_clk, sync_o  => ctrl.pa_manual_shift_ovrd);

    i_mmcm_ps_en_manual_oneshot : entity work.oneshot_cross_domain
        port map(
            reset_i       => ctrl.reset_mmcm,
            input_clk_i   => ttc_clocks_bufg.clk_40,
            oneshot_clk_i => mmcm_ps_clk,
            input_i       => ctrl_i.pa_manual_shift_en,
            oneshot_o     => ctrl.pa_manual_shift_en
        );

    fsm_reset <= ctrl.reset_sync_fsm or ctrl.phase_align_disable;

    -- Input buffering
    --------------------------------------
    i_ibufgds_clk_40_ttc : IBUFGDS
        port map(
            O  => clk_40_ttc_ibufgds,
            I  => clk_40_ttc_p_i,
            IB => clk_40_ttc_n_i
        );

    i_bufg_clk_40_ttc : BUFG
        port map(
            O => clk_40_ttc_bufg,
            I => clk_40_ttc_ibufgds
        );
        
    -- Main MMCM
    mmcm_adv_inst : MMCME2_ADV
        generic map(
            BANDWIDTH            => "OPTIMIZED",
            CLKOUT4_CASCADE      => false,
            COMPENSATION         => "ZHOLD",
            STARTUP_WAIT         => false,
            DIVCLK_DIVIDE        => 1,
            CLKFBOUT_MULT_F      => CFG_CLKFBOUT_MULT,
            CLKFBOUT_PHASE       => 0.000,
            CLKFBOUT_USE_FINE_PS => true,
            CLKOUT0_DIVIDE_F     => 24.000,
            CLKOUT0_PHASE        => 0.000,
            CLKOUT0_DUTY_CYCLE   => 0.500,
            CLKOUT0_USE_FINE_PS  => false,
            CLKOUT1_DIVIDE       => 12,
            CLKOUT1_PHASE        => 0.000,
            CLKOUT1_DUTY_CYCLE   => 0.500,
            CLKOUT1_USE_FINE_PS  => false,
            CLKOUT2_DIVIDE       => CFG_GBT_MGT_CLK_DIVIDE,
            CLKOUT2_PHASE        => 0.000,
            CLKOUT2_DUTY_CYCLE   => 0.500,
            CLKOUT2_USE_FINE_PS  => false,
            CLKOUT3_DIVIDE       => 6,
            CLKOUT3_PHASE        => 0.000,
            CLKOUT3_DUTY_CYCLE   => 0.500,
            CLKOUT3_USE_FINE_PS  => false,
            CLKOUT4_DIVIDE       => 3,
            CLKOUT4_PHASE        => 0.000,
            CLKOUT4_DUTY_CYCLE   => 0.500,
            CLKOUT4_USE_FINE_PS  => false,
            CLKIN1_PERIOD        => CFG_CLKIN1_PERIOD,
            REF_JITTER1          => 0.010)
        port map(
            -- Output clocks
            CLKFBOUT     => clkfbout,
            CLKFBOUTB    => open,
            CLKOUT0      => clk_40,
            CLKOUT0B     => open,
            CLKOUT1      => clk_80,
            CLKOUT1B     => open,
            CLKOUT2      => clk_gbt_mgt_usrclk,
            CLKOUT2B     => open,
            CLKOUT3      => clk_160,
            CLKOUT3B     => open,
            CLKOUT4      => clk_320,
            CLKOUT5      => open,
            CLKOUT6      => open,
            -- Input clock control
            CLKFBIN      => clkfbin,
            CLKIN1       => clkin,
            CLKIN2       => '0',
            -- Tied to always select the primary input clock
            CLKINSEL     => '1',

            -- Ports for dynamic reconfiguration
            DADDR        => (others => '0'),
            DCLK         => '0',
            DEN          => '0',
            DI           => (others => '0'),
            DO           => open,
            DRDY         => open,
            DWE          => '0',
            -- Ports for dynamic phase shift
            PSCLK        => mmcm_ps_clk,
            PSEN         => (mmcm_ps_en and not ctrl.pa_manual_shift_ovrd) or (ctrl.pa_manual_shift_en and ctrl.pa_manual_shift_ovrd),
            PSINCDEC     => (mmcm_ps_incdec and not ctrl.pa_manual_shift_ovrd) or (ctrl.pa_manual_shift_dir and ctrl.pa_manual_shift_ovrd),
            PSDONE       => mmcm_ps_done,
            -- Other control and status signals
            LOCKED       => mmcm_locked_raw,
            CLKINSTOPPED => open,
            CLKFBSTOPPED => open,
            PWRDWN       => '0',
            RST          => ctrl.reset_mmcm
        );

    -- Output buffering
    -------------------------------------

    i_bufg_clk_40 : BUFG
        port map(
            O => ttc_clocks_bufg.clk_40,
            I => clk_40
        );

    i_bufg_clk_80 : BUFG
        port map(
            O => ttc_clocks_bufg.clk_80,
            I => clk_80
        );

    i_bufg_clk_160 : BUFG
        port map(
            O => ttc_clocks_bufg.clk_160,
            I => clk_160
        );

    i_bufg_clk_320 : BUFG
        port map(
            O => ttc_clocks_bufg.clk_320,
            I => clk_320
        );

    i_bufg_clk_gbt : BUFG
        port map(
            O => ttc_clocks_bufg.clk_gbt_mgt_usrclk,
            I => clk_gbt_mgt_usrclk
        );

    clocks_o <= ttc_clocks_bufg;

    ------------------------------------------------------------------------------
    ------------------------ Use MGT refclk as the source ------------------------
    ------------------------------------------------------------------------------

    -- In case of the MGT refclk as the source, we have to align the MMCM 40MHz output to the backplane 40MHz clk manually. This has better clock performance, but the phase management can become a nightmare

    clkin <= clk_gbt_mgt_txout_i;
    clkfbin <= clkfbout; -- use internal feedback for better performance, because we don't care about the skew

    ----------------------------------------------------------
    --------- Phase Alignment to TTC backplane clock ---------
    ----------------------------------------------------------
        
    sync_good <= '1' when pa_state = SYNC_DONE else '0';
    status_o.sync_done <= sync_good when ctrl.phase_align_disable = '0' else mmcm_locked_raw;
    status_o.mmcm_locked <= mmcm_locked;
    status_o.phase_locked <= pll_locked;
    status_o.sync_restart_cnt <= std_logic_vector(unlock_cnt);
    status_o.mmcm_unlock_cnt <= std_logic_vector(mmcm_unlock_cnt);
    status_o.phase_unlock_cnt <= std_logic_vector(pll_unlock_cnt);
    status_o.pll_lock_time <= std_logic_vector(pll_lock_wait_timer);
    status_o.pll_lock_window <= std_logic_vector(pll_lock_window);
    status_o.pa_phase_shift_cnt <= std_logic_vector(shift_cnt);
    status_o.pa_fsm_state <= std_logic_vector(to_unsigned(pa_state_t'pos(pa_state), 3));
    status_o.sync_done_time <= sync_done_time;
    status_o.phase_unlock_time <= phase_unlock_time;
    status_o.pa_shift_back_fail_cnt <= std_logic_vector(shift_back_fail_cnt);
  
    -- using this PLL to check phase alignment between the MMCM 120 output and TTC 120
    i_phase_monitor_pll : PLLE2_BASE
        generic map(
            BANDWIDTH          => "LOW",
            CLKFBOUT_MULT      => 24,
            CLKFBOUT_PHASE     => 0.000,
            CLKIN1_PERIOD      => 25.000,
            CLKOUT0_DIVIDE     => 24,
            CLKOUT0_DUTY_CYCLE => 0.500,
            CLKOUT0_PHASE      => 0.000,
            CLKOUT1_DIVIDE     => 24,
            CLKOUT1_DUTY_CYCLE => 0.500,
            CLKOUT1_PHASE      => 0.000,
            CLKOUT2_DIVIDE     => 24,
            CLKOUT2_DUTY_CYCLE => 0.500,
            CLKOUT2_PHASE      => 0.000,
            CLKOUT3_DIVIDE     => 24,
            CLKOUT3_DUTY_CYCLE => 0.500,
            CLKOUT3_PHASE      => 0.000,
            DIVCLK_DIVIDE      => 1,
            REF_JITTER1        => 0.010
        )
        port map(
            CLKFBOUT => open,
            CLKOUT0  => open,
            CLKOUT1  => open,
            CLKOUT2  => open,
            CLKOUT3  => open,
            CLKOUT4  => open,
            CLKOUT5  => open,
            LOCKED   => pll_locked_raw,
            CLKFBIN  => ttc_clocks_bufg.clk_40,
            CLKIN1   => clk_40_ttc_bufg,
            PWRDWN   => '0',
            RST      => pll_reset or ctrl.reset_pll
        );  

    -- detect stable MMCM and PLL lock signals 
    process(mmcm_ps_clk)
    begin
        if (rising_edge(mmcm_ps_clk)) then
            
            if ((mmcm_lock_stable_cnt = LOCK_STABLE_TIMEOUT) and (mmcm_locked_raw = '1') and (ctrl.reset_mmcm = '0')) then
                mmcm_locked <= '1';
            else
                mmcm_locked <= '0';
            end if;
            
            if ((pll_lock_stable_cnt = LOCK_STABLE_TIMEOUT) and (pll_locked_raw = '1') and (pll_reset = '0' and ctrl.reset_pll = '0')) then
                pll_locked <= '1';
            else
                pll_locked <= '0';
            end if;
            
            if (ctrl.reset_cnt = '1') then
                mmcm_unlock_cnt <= (others => '0');
            elsif ((mmcm_locked = '1') and (mmcm_locked_raw = '0') and (mmcm_unlock_cnt /= x"ffff")) then
                mmcm_unlock_cnt <= mmcm_unlock_cnt + 1;
            end if; 
            
            if (ctrl.reset_cnt = '1') then
                pll_unlock_cnt <= (others => '0');
            elsif ((pa_state = SYNC_DONE) and (pll_unlock_stable_cnt = UNLOCK_STABLE_TIMEOUT) and (pll_unlock_cnt /= x"ffff")) then
                pll_unlock_cnt <= pll_unlock_cnt + 1;
            end if;
            
            if ((mmcm_locked_raw = '0') or (ctrl.reset_mmcm = '1')) then
                mmcm_lock_stable_cnt <= 0;
            elsif (mmcm_lock_stable_cnt < LOCK_STABLE_TIMEOUT) then
                mmcm_lock_stable_cnt <= mmcm_lock_stable_cnt + 1;
            end if;

            if ((pll_locked_raw = '0') or (pll_reset = '1') or (ctrl.reset_pll = '1')) then
                pll_lock_stable_cnt <= 0;
            elsif (pll_lock_stable_cnt < LOCK_STABLE_TIMEOUT) then
                pll_lock_stable_cnt <= pll_lock_stable_cnt + 1;
            end if;
            
            if ((pll_locked_raw = '1') or (pll_reset = '1') or (ctrl.reset_pll = '1')) then
                pll_unlock_stable_cnt <= 0;
            elsif (pll_unlock_stable_cnt < UNLOCK_STABLE_TIMEOUT + 1) then
                pll_unlock_stable_cnt <= pll_unlock_stable_cnt + 1;
            end if;
            
        end if;
    end process;
    
    i_phase_unlock_time : entity work.seconds_counter
        generic map(
            g_CLK_FREQUENCY  => CFG_CLKIN1_FREQ_SLV32,
            g_ALLOW_ROLLOVER => false,
            g_COUNTER_WIDTH  => 16
        )
        port map(
            clk_i     => mmcm_ps_clk,
            reset_i   => not pll_locked or ctrl.reset_cnt,
            seconds_o => phase_unlock_time
        );
            
    i_sync_done_time : entity work.seconds_counter
        generic map(
            g_CLK_FREQUENCY  => x"098e3a60", -- 160.316MHz
            g_ALLOW_ROLLOVER => false,
            g_COUNTER_WIDTH  => 16
        )
        port map(
            clk_i     => mmcm_ps_clk,
            reset_i   => not sync_good or ctrl.reset_cnt,
            seconds_o => sync_done_time
        );   
                    
    -- phase alignment FSM
    -- step 0) shifts the MMCM clock phase until the PLL unlocks if it is locked
    -- step 1) shifts the MMCM clock phase until the PLL locks
    -- step 2) keeps shifting the MMCM clock phase until the PLL unlocks and counts the number of shifts done
    -- step 3) shifts the MMCM clock phase back half the number of times that it took to unlock when shifting forwards after it locked
    process(mmcm_ps_clk)
    begin
        if (rising_edge(mmcm_ps_clk)) then
            if ((ctrl.reset_mmcm = '1') or (fsm_reset = '1') or (fsm_reset_debug = '1')) then
                pa_state <= IDLE;
                pll_reset <= '1';
                mmcm_ps_en <= '0';
                pll_lock_wait_timer <= (others => '0'); 
                searching_for_unlock <= '0';
                shifting_back <= '0';
                shift_back_cnt <= (others => '0');
                mmcm_ps_incdec <= '1';
                shift_back_fail_cnt <= (others => '0');
                shift_cnt <= (others => '0');
                shift_cnt_to_lock <= (others => '0');
                unlock_cnt <= (others => '0');
                pll_lock_window <= (others => '0');
                initial_unlock_search <= not ctrl.pa_no_init_shift_out; -- initially after a reset shift the phase out of lock and the restart the FSM as usual
                if (ctrl.pa_no_init_shift_out = '1') then
                    pa_state <= IDLE;                
                else
                    pa_state <= CHECK_FOR_UNLOCK;                
                end if;
            else
                case pa_state is
                    when IDLE =>
                        if (mmcm_locked = '1') then
                            pa_state <= CHECK_FOR_LOCK;
                        end if;
                        
                        pll_reset <= '1';
                        mmcm_ps_en <= '0';
                        pll_lock_wait_timer <= (others => '0');
                        mmcm_ps_done_timer <= (others => '0');
                        searching_for_unlock <= '0';
                        shifting_back <= '0';
                        shift_back_cnt <= (others => '0');
                        mmcm_ps_incdec <= '1';
                        shift_cnt_to_lock <= (others => '0');
                        pll_lock_window <= (others => '0');
                        
                    when CHECK_FOR_LOCK =>
                        if (pll_locked = '1') then
                            pa_state <= CHECK_FOR_UNLOCK;
                        else
                            if (pll_lock_wait_timer = 0) then
                                pll_reset <= '1';
                                pll_lock_wait_timer <= pll_lock_wait_timer + 1;
                            elsif (pll_lock_wait_timer = PLL_LOCK_WAIT_TIMEOUT) then
                                pa_state <= SHIFT_PHASE;
                                pll_reset <= '1';
                                pll_lock_wait_timer <= (others => '0');
                                shift_cnt_to_lock <= shift_cnt_to_lock + 1;
                                shift_cnt <= shift_cnt + 1;
                            else
                                pll_lock_wait_timer <= pll_lock_wait_timer + 1;
                                pll_reset <= '0';
                            end if;
                        end if;
                        
                        mmcm_ps_en <= '0';
                        mmcm_ps_done_timer <= (others => '0');
                        
                    when SHIFT_PHASE =>
                        mmcm_ps_en <= '1';
                        pa_state <= WAIT_SHIFT_DONE;
                        pll_reset <= '1';
                        mmcm_ps_done_timer <= (others => '0');

                    when WAIT_SHIFT_DONE =>
                        mmcm_ps_en <= '0';
                        pll_reset <= '1';

                        if ((mmcm_ps_done = '1') and (shifting_back = '1')) then
                            pa_state <= SHIFT_BACK;
                        elsif ((mmcm_ps_done = '1') and (searching_for_unlock = '1')) then
                            pa_state <= CHECK_FOR_UNLOCK;
                        elsif ((mmcm_ps_done = '1') and (mmcm_locked = '1')) then
                            pa_state <= CHECK_FOR_LOCK;
                        else
                            -- datasheet says MMCM should lock in 12 clock cycles and assert mmcm_ps_done for one clock period, but we have a timeout just in case
                            if (mmcm_ps_done_timer = MMCM_PS_DONE_TIMEOUT) then
                                pa_state <= IDLE;
                                mmcm_ps_done_timer <= (others => '0'); 
                            else
                                mmcm_ps_done_timer <= mmcm_ps_done_timer + 1;
                            end if;
                        end if;
                        
                    when CHECK_FOR_UNLOCK =>
                        if (pll_locked = '1') then
                            pa_state <= SHIFT_PHASE;
                            shift_back_cnt <= shift_back_cnt + 1;
                            shift_cnt <= shift_cnt + 1;
                        else
                            if (pll_lock_wait_timer = 0) then
                                pll_reset <= '1';
                                pll_lock_wait_timer <= pll_lock_wait_timer + 1;
                            elsif (pll_lock_wait_timer = PLL_LOCK_WAIT_TIMEOUT) then
                                -- initially after a reset shift the phase out of lock and the restart the FSM as usual
                                if (initial_unlock_search = '1') then
                                    initial_unlock_search <= '0';
                                    pa_state <= IDLE;
                                else
                                    pa_state <= SHIFT_BACK;
                                end if;
                                pll_lock_window <= shift_back_cnt;
                                shift_back_cnt <= '0' & shift_back_cnt(15 downto 1); -- divide the shift back count by 2
                                shifting_back <= '1';
                                pll_reset <= '1';
                                pll_lock_wait_timer <= (others => '0');
                            else
                                pll_lock_wait_timer <= pll_lock_wait_timer + 1;
                                pll_reset <= '0';
                            end if;
                        end if;
                        
                        searching_for_unlock <= '1';
                        mmcm_ps_en <= '0';
                        mmcm_ps_done_timer <= (others => '0');                        

                    when SHIFT_BACK =>
                        if (shift_back_cnt = x"0000") then
                            mmcm_ps_en <= '0';
                            pll_reset <= '0';
                            
                            -- pll should lock, but if not, then just go back to IDLE and start all over again...                            
                            if ((pll_locked = '1') and (shift_cnt_to_lock = x"0000") and (ctrl.pa_no_init_shift_out = '0')) then
                                -- if we find that in fact the pll did lock, but there were 0 shifts done to get there, then go back to IDLE,
                                -- because we found experimentaly that this results in wrong phase.. going through the FSM multiple times will 
                                -- eventually shift it out of lock and then find a good locking point as per usual operation.
                                initial_unlock_search <= '1'; 
                                pa_state <= IDLE;
                                --pa_state <= DEAD; -- just keep it in a dead state for now if this happens, this will prevent the GTH startup from completing and will be clearly visible during the FPGA programming  
                            elsif (pll_locked = '1') then
                                pa_state <= SYNC_DONE;
                            elsif (pll_lock_wait_timer = PLL_LOCK_WAIT_TIMEOUT) then
                                pa_state <= IDLE;
                                shift_back_fail_cnt <= shift_back_fail_cnt + 1;
                            else
                                pll_lock_wait_timer <= pll_lock_wait_timer + 1;
                            end if;
                        else
                            shift_back_cnt <= shift_back_cnt - 1;
                            pa_state <= WAIT_SHIFT_DONE;
                            mmcm_ps_en <= '1';
                            pll_reset <= '1';
                            mmcm_ps_done_timer <= (others => '0');
                            shift_cnt <= shift_cnt - 1;
                        end if;
                        
                        mmcm_ps_incdec <= '0';
                                            
                    when SYNC_DONE =>
                        mmcm_ps_en <= '0';

                        if (ctrl.reset_cnt = '1') then
                            unlock_cnt <= (others => '0');
                        end if;

                        if (mmcm_locked = '0') then
                            pa_state <= IDLE;
                            unlock_cnt <= unlock_cnt + 1;
                        else
                            pa_state <= SYNC_DONE;
                        end if;
                        
                    when DEAD =>
                        pa_state <= DEAD;
                        mmcm_ps_en <= '0';
                        
                    when others =>
                        pa_state <= IDLE;
                        mmcm_ps_en <= '0';
                        
                end case;
            end if;
        end if;
    end process;
        
    -------------- Phase monitoring of the 40MHz derived from TXOUTCLK vs TTC backplane -------------- 
    
    status_o.phase_monitor.phase <= ttc_phase;
    status_o.phase_monitor.phase_mean <= ttc_phase_mean;
    status_o.phase_monitor.phase_min <= ttc_phase_min;
    status_o.phase_monitor.phase_max <= ttc_phase_max;
    status_o.phase_monitor.phase_jump <= ttc_phase_jump;
    status_o.phase_monitor.phase_jump_cnt <= ttc_phase_jump_cnt;
    status_o.phase_monitor.phase_jump_size <= ttc_phase_jump_size;
    status_o.phase_monitor.phase_jump_time <= ttc_phase_jump_time;
    
    i_ttc_clk_phase_check : entity work.clk_phase_check_v7
        generic map(
            ROUND_FREQ_MHZ => 40.000,
            EXACT_FREQ_HZ => C_TTC_CLK_FREQUENCY_SLV,
            PHASE_JUMP_THRESH => x"06c", -- 2ns
            ILA_ENABLE => false
        )
        port map(
            reset_i             => (not sync_good and not ctrl_i.phase_align_disable) or ctrl_i.reset_cnt,
            clk1_i              => ttc_clocks_bufg.clk_40,
            clk2_i              => clk_40_ttc_bufg,
            phase_o             => ttc_phase,
            phase_mean_o        => ttc_phase_mean,
            phase_min_o         => ttc_phase_min,
            phase_max_o         => ttc_phase_max,
            phase_jump_o        => ttc_phase_jump,
            phase_jump_cnt_o    => ttc_phase_jump_cnt,
            phase_jump_size_o   => ttc_phase_jump_size,
            phase_jump_time_o   => ttc_phase_jump_time
        );
        
    -------------- DEBUG -------------- 
    
--    i_clk_phase_check : entity work.clk_phase_check_v7
--        generic map(
--            FREQ_MHZ => 40.000
--        )
--        port map(
--            reset => mmcm_rst_i,
--            clk1  => clk_40_ttc_bufg,
--            clk2  => ttc_clocks_bufg.clk_40
--        );
--        
--    i_vio_ttc_clocks : component vio_ttc_clocks
--        port map(
--            clk        => mmcm_ps_clk,
--            probe_in0  => std_logic_vector(pll_lock_wait_timer),
--            probe_in1  => std_logic_vector(pll_lock_window),
--            probe_in2  => std_logic_vector(shift_back_fail_cnt),
--            probe_in3  => std_logic_vector(shift_cnt),
--            probe_in4  => std_logic_vector(unlock_cnt),
--            probe_in5  => std_logic_vector(mmcm_unlock_cnt),
--            probe_in6  => std_logic_vector(to_unsigned(pa_state_t'pos(pa_state), 3)),
--            probe_out0 => open,
--            probe_out1 => fsm_reset_debug
--        );

    
end ttc_clocks_arch;
--============================================================================
--                                                            Architecture end
--============================================================================
