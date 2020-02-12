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
        disable_phase_align_i   : in  std_logic; -- completely disables the phase alignment mechanism and just forwards MMCM lock signal to mmcm_locked, instead of the SYNC_DONE. This is useful for setups without AMC13 and running on the local oscilator clock
        mmcm_rst_i              : in  std_logic;
        mmcm_locked_o           : out std_logic;
        clocks_o                : out t_ttc_clks;
        pll_lock_time_o         : out std_logic_vector(23 downto 0);
        pll_lock_window_o       : out std_logic_vector(15 downto 0);
        unlock_cnt_o            : out std_logic_vector(15 downto 0)
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

    signal clkfb                : std_logic;

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

    function get_txoutclk_period(gem_station : integer; is_lpgbt_loopback : boolean) return real is
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
    end function get_txoutclk_period;    


    constant CFG_CLKFBOUT_MULT : real := get_clkfbout_mult(CFG_GEM_STATION, CFG_LPGBT_2P56G_LOOPBACK_TEST);
    constant CFG_GBT_MGT_CLK_DIVIDE : integer := get_gbt_mgt_clk_divide(CFG_GEM_STATION, CFG_LPGBT_2P56G_LOOPBACK_TEST);
    constant CFG_CLKIN1_PERIOD : real := get_txoutclk_period(CFG_GEM_STATION, CFG_LPGBT_2P56G_LOOPBACK_TEST);
    
    ----------------- phase alignment ------------------
    constant MMCM_PS_DONE_TIMEOUT : unsigned(7 downto 0) := x"9f"; -- datasheet says MMCM should complete a phase shift in 12 clocks, but we check it with some margin, just in case
    type pa_state_t is (IDLE, CHECK_FOR_LOCK, SHIFT_PHASE, WAIT_SHIFT_DONE, CHECK_FOR_UNLOCK, SHIFT_BACK, SYNC_DONE, DEAD);

    signal mmcm_ps_clk      : std_logic;
    signal mmcm_ps_en       : std_logic;
    signal mmcm_ps_incdec   : std_logic;
    signal mmcm_ps_done     : std_logic;
    signal mmcm_locked_raw  : std_logic;
    signal mmcm_locked      : std_logic;
    signal mmcm_reset       : std_logic := '0';

    signal pll_locked_raw   : std_logic;
    signal pll_locked       : std_logic;
    signal pll_reset        : std_logic;

    signal fsm_reset            : std_logic := '0';
    signal fsm_reset_debug      : std_logic;
    signal pa_state             : pa_state_t            := IDLE;
    signal searching_for_unlock : std_logic;
    signal shifting_back        : std_logic;
    signal shift_cnt            : unsigned(15 downto 0) := (others => '0');
    signal shift_back_cnt       : unsigned(15 downto 0) := (others => '0');
    signal pll_lock_wait_timer  : unsigned(23 downto 0) := (others => '0');
    signal pll_lock_window      : unsigned(15 downto 0) := (others => '0');
    signal mmcm_ps_done_timer   : unsigned(7 downto 0)  := (others => '0');
    signal unlock_cnt           : unsigned(15 downto 0) := (others => '0');
    signal mmcm_unlock_cnt      : unsigned(15 downto 0) := (others => '0');
    
    signal mmcm_lock_stable_cnt : integer range 0 to 127 := 0;
    signal pll_lock_stable_cnt  : integer range 0 to 127 := 0;
    constant LOCK_STABLE_TIMEOUT: integer := 12;
    
    -- debug counters
    signal shift_back_fail_cnt  : unsigned(7 downto 0) := (others => '0');
      
--============================================================================
--                                                          Architecture begin
--============================================================================
begin

    -- mmcm_reset <= mmcm_rst_i; -- it's driven by the vio right now

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
            CLKFBOUT     => clkfb,
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
            CLKFBIN      => clkfb,
            CLKIN1       => clk_gbt_mgt_txout_i,
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
            PSEN         => mmcm_ps_en,
            PSINCDEC     => mmcm_ps_incdec,
            PSDONE       => mmcm_ps_done,
            -- Other control and status signals
            LOCKED       => mmcm_locked_raw,
            CLKINSTOPPED => open,
            CLKFBSTOPPED => open,
            PWRDWN       => '0',
            RST          => mmcm_reset
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

    ----------------------------------------------------------
    --------- Phase Alignment to TTC backplane clock ---------
    ----------------------------------------------------------
  
    fsm_reset <= disable_phase_align_i;
    mmcm_locked_o <= mmcm_locked_raw when disable_phase_align_i = '1' else '1' when pa_state = SYNC_DONE else '0';
    
    mmcm_ps_clk <= clk_gbt_mgt_txout_i;
    pll_lock_time_o <= std_logic_vector(pll_lock_wait_timer);
    pll_lock_window_o <= std_logic_vector(pll_lock_window);
    unlock_cnt_o <= std_logic_vector(unlock_cnt);
  
    -- using this PLL to check phase alignment between the MMCM 120 output and TTC 120
    i_phase_monitor_pll : PLLE2_BASE
        generic map(
            BANDWIDTH          => "OPTIMIZED",
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
            RST      => pll_reset
        );  

    -- detect stable MMCM and PLL lock signals 
    process(mmcm_ps_clk)
    begin
        if (rising_edge(mmcm_ps_clk)) then
            
            if ((mmcm_lock_stable_cnt = LOCK_STABLE_TIMEOUT) and (mmcm_locked_raw = '1') and (mmcm_reset = '0')) then
                mmcm_locked <= '1';
            else
                mmcm_locked <= '0';
            end if;
            
            if ((pll_lock_stable_cnt = LOCK_STABLE_TIMEOUT) and (pll_locked_raw = '1') and (pll_reset = '0')) then
                pll_locked <= '1';
            else
                pll_locked <= '0';
            end if;
            
            if ((mmcm_locked = '1') and (mmcm_locked_raw = '0')) then
                mmcm_unlock_cnt <= mmcm_unlock_cnt + 1;
            end if; 
            
            if ((mmcm_locked_raw = '0') or (mmcm_reset = '1')) then
                mmcm_lock_stable_cnt <= 0;
            elsif (mmcm_lock_stable_cnt < LOCK_STABLE_TIMEOUT) then
                mmcm_lock_stable_cnt <= mmcm_lock_stable_cnt + 1;
            end if;

            if ((pll_locked_raw = '0') or (pll_reset = '1')) then
                pll_lock_stable_cnt <= 0;
            elsif (pll_lock_stable_cnt < LOCK_STABLE_TIMEOUT) then
                pll_lock_stable_cnt <= pll_lock_stable_cnt + 1;
            end if;
            
        end if;
    end process;
    
    -- power-on FSM reset
--    process(mmcm_ps_clk)
--        variable countdown : integer := 160_000_000;
--    begin
--        if (rising_edge(mmcm_ps_clk)) then
--            if (countdown > 0) then
--              fsm_reset <= '1';
--              countdown := countdown - 1;
--            else
--              fsm_reset <= '0';
--            end if;
--        end if;
--    end process; 

    -- phase alignment FSM
    -- step 1) shifs the MMCM clock phase until the PLL locks
    -- step 2) keeps shifting the MMCM clock phase until the PLL unlocks and counts the number of shifts done
    -- step 3) shifts the MMCM clock phase back half the number of times that it took to unlock when shifting forwards after it locked
    process(mmcm_ps_clk)
    begin
        if (rising_edge(mmcm_ps_clk)) then
            if ((mmcm_reset = '1') or (fsm_reset = '1') or (fsm_reset_debug = '1')) then
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
                unlock_cnt <= (others => '0');
                pll_lock_window <= (others => '0');
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
                        else
                            if (pll_lock_wait_timer = 0) then
                                pll_reset <= '1';
                                pll_lock_wait_timer <= pll_lock_wait_timer + 1;
                            elsif (pll_lock_wait_timer = PLL_LOCK_WAIT_TIMEOUT) then
                                pa_state <= SHIFT_BACK;
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
                            if ((pll_locked = '1') and (shift_cnt = x"0000")) then
                                -- if we find that in fact the pll did lock, but there were 0 shifts done to get there, then go back to IDLE,
                                -- because we found experimentaly that this results in wrong phase.. going through the FSM multiple times will 
                                -- eventually shift it out of lock and then find a good locking point as per usual operation. 
                                --pa_state <= IDLE;
                                pa_state <= DEAD; -- just keep it in a dead state for now if this happens, this will prevent the GTH startup from completing and will be clearly visible during the FPGA programming  
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
                        end if;
                        
                        mmcm_ps_incdec <= '0';
                                            
                    when SYNC_DONE =>
                        mmcm_ps_en <= '0';

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
        
    i_vio_ttc_clocks : component vio_ttc_clocks
        port map(
            clk        => mmcm_ps_clk,
            probe_in0  => std_logic_vector(pll_lock_wait_timer),
            probe_in1  => std_logic_vector(pll_lock_window),
            probe_in2  => std_logic_vector(shift_back_fail_cnt),
            probe_in3  => std_logic_vector(shift_cnt),
            probe_in4  => std_logic_vector(unlock_cnt),
            probe_in5  => std_logic_vector(mmcm_unlock_cnt),
            probe_in6  => std_logic_vector(to_unsigned(pa_state_t'pos(pa_state), 3)),
            probe_out0 => mmcm_reset,
            probe_out1 => fsm_reset_debug
        );
    
--    i_ila_ttc_clocks : component ila_ttc_clocks
--        port map(
--            clk    => mmcm_ps_clk,
--            probe0 => std_logic_vector(to_unsigned(pa_state_t'pos(pa_state), 3)),
--            probe1 => pll_reset,
--            probe2 => pll_locked,
--            probe3 => mmcm_locked,
--            probe4 => mmcm_ps_en,
--            probe5 => mmcm_ps_done,
--            probe6 => mmcm_ps_incdec
--        );
    
end ttc_clocks_arch;
--============================================================================
--                                                            Architecture end
--============================================================================
