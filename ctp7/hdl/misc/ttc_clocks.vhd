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
use work.gth_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity ttc_clocks is
    generic (
        PLL_LOCK_WAIT_TIMEOUT     : unsigned(23 downto 0) := x"002710" -- way too long, will measure how low we can go here
    );
    port (
        clk_40_ttc_p_i          : in  std_logic; -- TTC backplane clock
        clk_40_ttc_n_i          : in  std_logic; -- TTC backplane clock
        clk_160_ttc_clean_i     : in  std_logic; -- TTC jitter cleaned 160MHz TTC clock (should come from MGT ref)
        ctrl_i                  : in  t_ttc_clk_ctrl; -- control signals
        clocks_o                : out t_ttc_clks; -- clock outputs
        status_o                : out t_ttc_clk_status; -- status outputs
        gth_tx_pippm_ctrl_o     : out t_gth_tx_pippm_ctrl; -- control of the GTH PI phase
        gth_master_pcs_clk_i    : in std_logic; -- the master GTH PCS clock (master is the one that provides the TXOUTCLK as the clk_160_ttc_clean_i to this module)
        gth_txphalign_done_i    : in std_logic  -- rising edge of this input tells this module that the GTH startup phase alignment was done and thus resets the PIPPM control logic
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
    signal clk_40_ttc_ibufgds       : std_logic;
    signal clk_40_ttc_bufg          : std_logic;

    signal clkfb                    : std_logic;

    signal clk_40                   : std_logic;
    signal clk_80                   : std_logic;
    signal clk_160                  : std_logic;
    signal clk_120                  : std_logic;

    signal ttc_clocks_bufg          : t_ttc_clks;
    
    ----------------- phase alignment ------------------
    constant MMCM_PS_DONE_TIMEOUT : unsigned(7 downto 0) := x"9f"; -- datasheet says MMCM should complete a phase shift in 12 clocks, but we check it with some margin, just in case
    type pa_state_t is (IDLE, CHECK_FOR_LOCK, SHIFT_PHASE, WAIT_SHIFT_DONE, CHECK_FOR_UNLOCK, SHIFT_BACK, SYNC_DONE, DEAD);

    signal mmcm_ps_clk              : std_logic;
    signal mmcm_ps_en               : std_logic;
    signal mmcm_ps_incdec           : std_logic;
    signal mmcm_ps_done             : std_logic;
    signal mmcm_locked_raw          : std_logic;
    signal mmcm_locked              : std_logic;
    signal mmcm_reset               : std_logic;

    signal pll_locked_raw           : std_logic;
    signal pll_locked               : std_logic;
    signal pll_reset                : std_logic;

    signal fsm_reset                : std_logic := '1';
    signal pa_state                 : pa_state_t            := IDLE;
    signal searching_for_unlock     : std_logic := '0';
    signal initial_unlock_search    : std_logic := '1';
    signal shifting_back            : std_logic := '0';
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
    
    signal sync_good                : std_logic;
    
    -- time counters
    signal sync_done_time           : std_logic_vector(15 downto 0);
    signal phase_unlock_time        : std_logic_vector(15 downto 0);
    
    -- ttc phase monitoring
    signal ttc_phase                : std_logic_vector(11 downto 0); -- phase difference between the rising edges of the two clocks (each count is about 18.6012ps)
    signal ttc_phase_mean           : std_logic_vector(11 downto 0);
    signal ttc_phase_min            : std_logic_vector(11 downto 0);
    signal ttc_phase_max            : std_logic_vector(11 downto 0);
    signal ttc_phase_jump           : std_logic := '0';
    signal ttc_phase_jump_cnt       : std_logic_vector(15 downto 0);
    signal ttc_phase_jump_size      : std_logic_vector(11 downto 0);
    signal ttc_phase_jump_time      : std_logic_vector(15 downto 0); -- number of seconds since last phase jump

    -- GTH PCS-TXUSRCLK phase monitoring
    signal gth_phase                : std_logic_vector(11 downto 0); -- phase difference between the rising edges of the two clocks (each count is about 18.6012ps)
    signal gth_phase_mean           : std_logic_vector(11 downto 0);
    signal gth_phase_min            : std_logic_vector(11 downto 0);
    signal gth_phase_max            : std_logic_vector(11 downto 0);
    signal gth_phase_jump           : std_logic := '0';
    signal gth_phase_jump_cnt       : std_logic_vector(15 downto 0);
    signal gth_phase_jump_size      : std_logic_vector(11 downto 0);
    signal gth_phase_jump_time      : std_logic_vector(15 downto 0); -- number of seconds since last phase jump
        
    -- GTH PIPPM control
    signal gth_shift_req            : std_logic := '0';
    signal gth_shift_req_dly        : std_logic := '0';
    signal gth_shift_ack            : std_logic := '0';
    signal gth_shift_dir            : std_logic := '0';
    signal gth_shift_error          : std_logic := '0';
    signal gth_shift_cnt            : unsigned(2 downto 0) := (others => '0');
    signal gth_reset_done           : std_logic := '0';
    signal gth_txphalign_sync       : std_logic := '0';
    signal gth_txphalign_sync_prev  : std_logic := '0';
    signal gth_tx_pippm_ctrl        : t_gth_tx_pippm_ctrl := (enable => '0', direction => '0', step_size => (others => '0'));
    signal gth_shift_en_timer       : unsigned(1 downto 0) := (others => '0');
    signal gth_shift_cnt_global     : unsigned(15 downto 0) := (others => '0');
        
    -- debug counters
    signal shift_back_fail_cnt      : unsigned(7 downto 0) := (others => '0');
      
--============================================================================
--                                                          Architecture begin
--============================================================================
begin

    mmcm_reset <= ctrl_i.reset_mmcm;
    fsm_reset <= ctrl_i.reset_sync_fsm;

    gth_tx_pippm_ctrl_o <= gth_tx_pippm_ctrl;

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
            CLKFBOUT_MULT_F      => 6.000,
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
            CLKOUT2_DIVIDE       => 8,
            CLKOUT2_PHASE        => 0.000,
            CLKOUT2_DUTY_CYCLE   => 0.500,
            CLKOUT2_USE_FINE_PS  => false,
            CLKOUT3_DIVIDE       => 6,
            CLKOUT3_PHASE        => 0.000,
            CLKOUT3_DUTY_CYCLE   => 0.500,
            CLKOUT3_USE_FINE_PS  => false,
            CLKOUT4_DIVIDE       => 6,
            CLKOUT4_PHASE        => 0.000,
            CLKOUT4_DUTY_CYCLE   => 0.500,
            CLKOUT4_USE_FINE_PS  => false,
            CLKIN1_PERIOD        => 6.25,
            REF_JITTER1          => 0.010)
        port map(
            -- Output clocks
            CLKFBOUT     => clkfb,
            CLKFBOUTB    => open,
            CLKOUT0      => clk_40,
            CLKOUT0B     => open,
            CLKOUT1      => clk_80,
            CLKOUT1B     => open,
            CLKOUT2      => clk_120,
            CLKOUT2B     => open,
            CLKOUT3      => clk_160,
            CLKOUT3B     => open,
            CLKOUT4      => open,
            CLKOUT5      => open,
            CLKOUT6      => open,
            -- Input clock control
            CLKFBIN      => clkfb,
            CLKIN1       => clk_160_ttc_clean_i,
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

    i_bufg_clk_120 : BUFG
        port map(
            O => ttc_clocks_bufg.clk_120,
            I => clk_120
        );

    clocks_o <= ttc_clocks_bufg;

    ----------------------------------------------------------
    --------- Phase Alignment to TTC backplane clock ---------
    ----------------------------------------------------------
  
    mmcm_ps_clk <= clk_160_ttc_clean_i;
    
    sync_good <= '1' when pa_state = SYNC_DONE else '0';
    status_o.sync_done <= sync_good when ctrl_i.force_sync_done = '0' else mmcm_locked_raw;
    status_o.mmcm_locked <= mmcm_locked;
    status_o.phase_locked <= pll_locked;
    status_o.sync_restart_cnt <= std_logic_vector(unlock_cnt);
    status_o.mmcm_unlock_cnt <= std_logic_vector(mmcm_unlock_cnt);
    status_o.phase_unlock_cnt <= std_logic_vector(pll_unlock_cnt);
    status_o.pll_lock_time <= std_logic_vector(pll_lock_wait_timer);
    status_o.pll_lock_window <= std_logic_vector(pll_lock_window);
    status_o.phase_shift_cnt <= std_logic_vector(shift_cnt);
    status_o.pa_fsm_state <= std_logic_vector(to_unsigned(pa_state_t'pos(pa_state), 3));
    status_o.sync_done_time <= sync_done_time;
    status_o.phase_unlock_time <= phase_unlock_time;
      
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
            
            if (ctrl_i.reset_cnt = '1') then
                mmcm_unlock_cnt <= (others => '0');
            elsif ((mmcm_locked = '1') and (mmcm_locked_raw = '0') and (mmcm_unlock_cnt /= x"ffff")) then
                mmcm_unlock_cnt <= mmcm_unlock_cnt + 1;
            end if; 
            
            if (ctrl_i.reset_cnt = '1') then
                pll_unlock_cnt <= (others => '0');
            elsif ((pa_state = SYNC_DONE) and (pll_unlock_stable_cnt = UNLOCK_STABLE_TIMEOUT) and (pll_unlock_cnt /= x"ffff")) then
                pll_unlock_cnt <= pll_unlock_cnt + 1;
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

            if ((pll_locked_raw = '1') or (pll_reset = '1')) then
                pll_unlock_stable_cnt <= 0;
            elsif (pll_unlock_stable_cnt < UNLOCK_STABLE_TIMEOUT + 1) then
                pll_unlock_stable_cnt <= pll_unlock_stable_cnt + 1;
            end if;
            
        end if;
    end process;
    
    i_phase_unlock_time : entity work.seconds_counter
        generic map(
            g_CLK_FREQUENCY  => x"098e3a60", -- 160.316MHz
            g_ALLOW_ROLLOVER => false,
            g_COUNTER_WIDTH  => 16
        )
        port map(
            clk_i     => mmcm_ps_clk,
            reset_i   => not pll_locked or ctrl_i.reset_cnt,
            seconds_o => phase_unlock_time
        );
    
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
            if ((mmcm_reset = '1') or (fsm_reset = '1') or (ctrl_i.force_sync_done = '1')) then
                pll_reset <= '1';
                mmcm_ps_en <= '0';
                pll_lock_wait_timer <= (others => '0'); 
                mmcm_ps_done_timer <= (others => '0');
                searching_for_unlock <= '0';
                shifting_back <= '0';
                shift_back_cnt <= (others => '0');
                mmcm_ps_incdec <= '1';
                shift_back_fail_cnt <= (others => '0');
                shift_cnt <= (others => '0');
                shift_cnt_to_lock <= (others => '0');
                unlock_cnt <= (others => '0');
                pll_lock_window <= (others => '0');
                initial_unlock_search <= not ctrl_i.no_init_shift_out; -- initially after a reset shift the phase out of lock and the restart the FSM as usual
                if (ctrl_i.no_init_shift_out = '1') then
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
                            if ((pll_locked = '1') and (shift_cnt_to_lock = x"0000") and (ctrl_i.no_init_shift_out = '0')) then
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

                        if (ctrl_i.reset_cnt = '1') then
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
    
    i_sync_done_time : entity work.seconds_counter
        generic map(
            g_CLK_FREQUENCY  => x"098e3a60", -- 160.316MHz
            g_ALLOW_ROLLOVER => false,
            g_COUNTER_WIDTH  => 16
        )
        port map(
            clk_i     => mmcm_ps_clk,
            reset_i   => not sync_good or ctrl_i.reset_cnt,
            seconds_o => sync_done_time
        );    

    -------------- GTH PI PPM shifting --------------
    
    -- transfer the mmcm_ps_en and mmcm_ps_incdec from mmcm_ps_clk to TXUSRCLK (ttc_clocks_bufg.clk_120) domain
    process(mmcm_ps_clk)
    begin
        if (rising_edge(mmcm_ps_clk)) then
            if ((fsm_reset = '1') or (ctrl_i.force_sync_done = '1')) then
                gth_shift_req <= '0';
                gth_shift_dir <= '0';
                gth_shift_error <= '0';
                gth_shift_req_dly <= '0';
            else
                gth_shift_req_dly <= gth_shift_req;
                
                if (gth_shift_req = '0') then
                    if (mmcm_ps_en = '1') then
                        gth_shift_req <= '1';
                        gth_shift_dir <= mmcm_ps_incdec;
                    else
                        gth_shift_req <= '0';
                    end if; 
                    if (gth_shift_ack = '1') then
                        gth_shift_error <= '1';
                    end if;
                else
                    if (mmcm_ps_en = '1') then
                        gth_shift_error <= '1';
                    end if;
                    if (gth_shift_ack = '1') then
                        gth_shift_req <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    i_gth_txphalign_done_sync : entity work.synchronizer
        generic map(
            N_STAGES => 3
        )
        port map(
            async_i => gth_txphalign_done_i,
            clk_i   => ttc_clocks_bufg.clk_120,
            sync_o  => gth_txphalign_sync
        );
    
    process(ttc_clocks_bufg.clk_120)
    begin
        if (rising_edge(ttc_clocks_bufg.clk_120)) then
            gth_txphalign_sync_prev <= gth_txphalign_sync;
            if (gth_txphalign_sync_prev = '0' and gth_txphalign_sync = '1') then
                gth_reset_done <= '1';
            else 
                gth_reset_done <= '0';
            end if;
        end if;
    end process;
    
    -- control of the GTH TX PIPPM controller
    -- whenever it sees that the MMCM was shifted, it will shift the TX PI in the same direction (by asserting the PIPPM_EN for 2 clock cycles)
    -- the PIPPM shift resolution is different from the MMCM shift resolution. The 4.8Gbs GBT GTH PI shift step in it's current configuration =  6.510416667ps, while this MMCM step is 18.601190476ps
    -- given these step sizes, it's not possible to always shift them by exactly the same amount, but we can keep it within 3.255ps. Here's how:
    -- every 7 shifts of MMCM matches exactly 20 shifts in the GTH PI
    -- since 20 is not divisible by 7, we will shift the PI by 3 steps for every MMCM shift, but every 7th MMCM shift (starting from the 4th shift) we will only shift the PI by 2 steps
    -- this will give us a total of 20 PI shifts for every 7 MMCM shifts
    -- note that when the MMCM is shifting backwards, we have to shift the PI back by the same number of steps that we did when shifting forwards
    process(ttc_clocks_bufg.clk_120)
    begin
        if (rising_edge(ttc_clocks_bufg.clk_120)) then
            if (gth_reset_done = '1') then
                gth_shift_ack <= '0';
                gth_shift_cnt <= (others => '0');
                gth_tx_pippm_ctrl.enable <= '0';
                gth_tx_pippm_ctrl.direction <= '0';
                gth_tx_pippm_ctrl.step_size <= (others => '0');
                gth_shift_en_timer <= (others => '0');
                gth_shift_cnt_global <= (others => '0');
            elsif ((fsm_reset = '1') or (ctrl_i.force_sync_done = '1') or (ctrl_i.gth_phalign_disable = '1')) then
                gth_shift_ack <= '0';
                gth_tx_pippm_ctrl.enable <= '0';
                gth_tx_pippm_ctrl.direction <= '0';
                gth_tx_pippm_ctrl.step_size <= (others => '0');
                gth_shift_en_timer <= (others => '0');
                gth_shift_cnt_global <= (others => '0');
            else

                if (gth_shift_req_dly = '1' and gth_shift_ack = '0') then
                    gth_shift_ack <= '1';
                                        
                    gth_tx_pippm_ctrl.direction <= not gth_shift_dir; -- shifting the MMCM feedback clock forward, actually shifts the outputs backwards.. so in this case we have to shift the PMA clock also backwards..
                    gth_tx_pippm_ctrl.enable <= '1';
                    gth_shift_en_timer <= "01";
                    
                    -- set the GTH PI shift amount (we normally do 3 steps, except in the middle of every 7 shifts we do 2 steps)
                    if (gth_shift_dir = '1') then
                        if (gth_shift_cnt = 2) then
                            gth_shift_cnt <= gth_shift_cnt + 1;
                            gth_tx_pippm_ctrl.step_size <= x"2";
                            gth_shift_cnt_global <= gth_shift_cnt_global + x"0002";
                        elsif (gth_shift_cnt = 6) then
                            gth_shift_cnt <= (others => '0');
                            gth_tx_pippm_ctrl.step_size <= x"3";
                            gth_shift_cnt_global <= gth_shift_cnt_global + x"0003";
                        else
                            gth_shift_cnt <= gth_shift_cnt + 1;
                            gth_tx_pippm_ctrl.step_size <= x"3";
                            gth_shift_cnt_global <= gth_shift_cnt_global + x"0003";
                        end if;
                    else
                        if (gth_shift_cnt = 3) then
                            gth_shift_cnt <= gth_shift_cnt - 1;
                            gth_tx_pippm_ctrl.step_size <= x"2";
                            gth_shift_cnt_global <= gth_shift_cnt_global - x"0002";
                        elsif (gth_shift_cnt = 0) then
                            gth_shift_cnt <= "110";
                            gth_tx_pippm_ctrl.step_size <= x"3";
                            gth_shift_cnt_global <= gth_shift_cnt_global - x"0003";
                        else
                            gth_shift_cnt <= gth_shift_cnt - 1;
                            gth_tx_pippm_ctrl.step_size <= x"3";
                            gth_shift_cnt_global <= gth_shift_cnt_global - x"0003";
                        end if;
                    end if;
                    
                elsif (gth_shift_req_dly = '0') then
                    gth_shift_ack <= '0';
                else
                    gth_shift_ack <= gth_shift_ack;
                end if;
                
                -- hold the enable signal high for 2 clock cycles
                if (gth_tx_pippm_ctrl.enable = '1' and gth_shift_en_timer /= "10") then
                    gth_shift_en_timer <= gth_shift_en_timer + 1;
                elsif (gth_shift_en_timer = "10") then
                    gth_tx_pippm_ctrl.enable <= '0';
                end if;
                
            end if;
        end if;
    end process;
    
    status_o.gth_pi_shift_error <= gth_shift_error;
    status_o.gth_pi_shift_cnt <= std_logic_vector(gth_shift_cnt_global);
        
    -------------- Phase monitoring of the TX 40MHz derived from TXOUTCLK vs TTC backplane -------------- 
    
    status_o.pm_gth.phase <= gth_phase;
    status_o.pm_gth.phase_mean <= gth_phase_mean;
    status_o.pm_gth.phase_min <= gth_phase_min;
    status_o.pm_gth.phase_max <= gth_phase_max;
    status_o.pm_gth.phase_jump <= gth_phase_jump;
    status_o.pm_gth.phase_jump_cnt <= gth_phase_jump_cnt;
    status_o.pm_gth.phase_jump_size <= gth_phase_jump_size;
    status_o.pm_gth.phase_jump_time <= gth_phase_jump_time;
    
    i_gth_clk_phase_check : entity work.clk_phase_check_v7
        generic map(
            ROUND_FREQ_MHZ => 120.000,
            EXACT_FREQ_HZ => x"072aabc8",
            PHASE_JUMP_THRESH => x"035" -- 1ns
        )
        port map(
            reset_i             => (not sync_good) or ctrl_i.reset_cnt,
            clk1_i              => gth_master_pcs_clk_i,
            clk2_i              => ttc_clocks_bufg.clk_120,
            phase_o             => gth_phase,
            phase_mean_o        => gth_phase_mean,
            phase_min_o         => gth_phase_min,
            phase_max_o         => gth_phase_max,
            phase_jump_o        => gth_phase_jump,
            phase_jump_cnt_o    => gth_phase_jump_cnt,
            phase_jump_size_o   => gth_phase_jump_size,
            phase_jump_time_o   => gth_phase_jump_time
        );

        
    -------------- Phase monitoring of the 40MHz derived from TXOUTCLK vs TTC backplane -------------- 
    
    status_o.pm_ttc.phase <= ttc_phase;
    status_o.pm_ttc.phase_mean <= ttc_phase_mean;
    status_o.pm_ttc.phase_min <= ttc_phase_min;
    status_o.pm_ttc.phase_max <= ttc_phase_max;
    status_o.pm_ttc.phase_jump <= ttc_phase_jump;
    status_o.pm_ttc.phase_jump_cnt <= ttc_phase_jump_cnt;
    status_o.pm_ttc.phase_jump_size <= ttc_phase_jump_size;
    status_o.pm_ttc.phase_jump_time <= ttc_phase_jump_time;
    
    i_ttc_clk_phase_check : entity work.clk_phase_check_v7
        generic map(
            ROUND_FREQ_MHZ => 40.000,
            EXACT_FREQ_HZ => C_TTC_CLK_FREQUENCY_SLV,
            PHASE_JUMP_THRESH => x"06c" -- 2ns
        )
        port map(
            reset_i             => (not sync_good) or ctrl_i.reset_cnt,
            clk1_i              => clk_40_ttc_bufg,
            clk2_i              => ttc_clocks_bufg.clk_40,
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
--            probe_out0 => mmcm_reset,
--            probe_out1 => fsm_reset
--        );
    
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
