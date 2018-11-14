-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: ttc_pkg                                            
--                                                                            
--     Description: 
--
--                                                                            
-------------------------------------------------------------------------------
--                                                                            
--           Notes:                                                           
--                                                                            
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

--============================================================================
--                                                         Package declaration
--============================================================================
package ttc_pkg is

    constant C_TTC_CLK_FREQUENCY        : integer := 40_079_000;
    constant C_TTC_CLK_FREQUENCY_SLV    : std_logic_vector(31 downto 0) := x"02638e98";
    constant C_TTC_NUM_BXs              : std_logic_vector(11 downto 0) := x"dec";

    type t_ttc_clks is record
        clk_40              : std_logic;
        clk_80              : std_logic;
        clk_120             : std_logic;
        clk_160             : std_logic;
        clk_40_backplane    : std_logic;
    end record;

    type t_phase_monitor_status is record
        phase               : std_logic_vector(11 downto 0); -- phase difference between the rising edges of the jitter cleaned 40MHz and backplane TTC 40MHz clocks (each count is about 18.6012ps)
        phase_mean          : std_logic_vector(11 downto 0); -- the mean of the phase in the last 2048 measurements
        phase_min           : std_logic_vector(11 downto 0); -- the minimum measured phase value since last reset
        phase_max           : std_logic_vector(11 downto 0); -- the maximum measured phase value since last reset
        phase_jump          : std_logic;                     -- this signal goes high if a significant phase difference is observed compared to the previous measurement
        phase_jump_cnt      : std_logic_vector(15 downto 0); -- number of times a phase jump has been detected
        phase_jump_size     : std_logic_vector(11 downto 0); -- the magnitude of the phase jump (difference between the subsequent measurements that triggered the last phase jump detection)
        phase_jump_time     : std_logic_vector(15 downto 0); -- number of seconds since last phase jump
    end record;

    type t_ttc_clk_status is record
        sync_done           : std_logic; -- Jitter cleaned clock is locked and phase alignment procedure is finished (use this to start the GTH startup FSM)
        mmcm_locked         : std_logic; -- MMCM is locked (input is jitter cleaned 160MHz clock)
        phase_locked        : std_logic; -- Jitter cleaned 40MHz clock is in phase with the backplane 40MHz TTC clock
        sync_restart_cnt    : std_logic_vector(15 downto 0); -- number of times the sync procedure was restarted due to loosing MMCM lock after sync was done
        mmcm_unlock_cnt     : std_logic_vector(15 downto 0); -- number of times the MMCM lock signal has gone low
        phase_unlock_cnt    : std_logic_vector(15 downto 0); -- number of times the phase monitoring PLL lock signal has gone low
        sync_done_time      : std_logic_vector(15 downto 0); -- number of seconds since last sync was done
        phase_unlock_time   : std_logic_vector(15 downto 0); -- number of seconds since last phase unlock
        pll_lock_time       : std_logic_vector(23 downto 0); -- number of clock cycles it took the phase monitoring PLL to lock
        pll_lock_window     : std_logic_vector(15 downto 0); -- the width of the phase lock window
        phase_shift_cnt     : std_logic_vector(15 downto 0); -- number of phase shifts done by the phase alignment FSM
        pa_fsm_state        : std_logic_vector(2 downto 0);  -- phase alignment FSM state
        pa_manual_shift_cnt : std_logic_vector(15 downto 0); -- number of manual shifts
        -- phase monitor
        pm_ttc              : t_phase_monitor_status;
        pm_gth              : t_phase_monitor_status;
        -- gth pi ppm
        gth_pi_shift_error  : std_logic_vector(3 downto 0); -- error while shifting the phase of the GTH PI
        gth_pi_shift_cnt    : std_logic_vector(15 downto 0);
        gth_pi_man_shift_cnt: std_logic_vector(15 downto 0); -- number of manual shifts
        gth_reset_cnt       : std_logic_vector(15 downto 0);
    end record;

    type t_ttc_clk_ctrl is record
        reset_cnt               : std_logic; -- reset the counters
        reset_sync_fsm          : std_logic; -- reset the sync FSM, this will restart the phase alignment procedure
        reset_mmcm              : std_logic; -- reset the MMCM, this will reset the MMCM and also restart the phase alignment procedure
        reset_pll               : std_logic; -- reset the phase check PLL
        force_sync_done         : std_logic; -- force the sync_done signal high -- this may be useful in setups where backplane clock does not exist (no AMC13), and only the jitter cleaned clock is available
        no_init_shift_out       : std_logic; -- if this is set to 0 (default), then when the phase alignment FSM is reset, it will first shift the phase out of lock if it is currently locked, and then start searching for lock as usual
        gth_phalign_disable     : std_logic; -- if this is set to 0 (default), then the GTH PI PPM controller will be used to track the phase of the TXUSRCLK every time the TXUSRCLK is shifted, this may help to keep the fiber links alive while resetting the phase alignment FSM
        gth_shift_rev_dir       : std_logic; -- shift the GTH in reverse direction (not sure which one is the correct one, so introducing this debug control)
        gth_shift_use_sel       : std_logic; -- if 1 then PIPPMSEL will be set to 1 when shifting the PI phase, otherwise it will always stay at 0 (debugging)
        gth_sel_ovrd            : std_logic; -- if this is set to 1 then GTH PIPPMSEL will be forced to always be 1
        pa_shift_wait_time      : std_logic_vector(15 downto 0); -- number of clock cycles to wait between each phase shift
        gth_txdlybypass         : std_logic; -- connected to GBT GTH TXDLYBYPASS
        pa_manual_shift_en      : std_logic; -- positive edge of this signal will do one shift in the selected direction
        pa_manual_shift_dir     : std_logic; -- direction of the manual shifting
        pa_manual_shift_ovrd    : std_logic; -- if this is set to 1, then shift direction is overriden
        pa_manual_gth_shift_ovrd: std_logic; -- if this is set to 1, then GTH PI shifts will only be controlled manually instead of being automatically shifted after MMCM shifts
        pa_manual_gth_shift_dir : std_logic; -- controls the GTH PIPPM shift direction in when manual override is set
        pa_manual_gth_shift_step: std_logic_vector(3 downto 0); -- controls the GTH PIPPM shift step size
        pa_manual_gth_shift_en  : std_logic; -- when pulsed, it will shift the GTH PIPPM by one step
        pa_manual_combined      : std_logic; -- when this is 1 then shifting the gth will also shift the MMCM when necessary to keep the GTH phase constant (7 mmcm manual shifts in every 40 gth shifts)
    end record;

    type t_ttc_cmds is record
        l1a        : std_logic;
        bc0        : std_logic;
        ec0        : std_logic;
        resync     : std_logic;
        hard_reset : std_logic;
        start      : std_logic;
        stop       : std_logic;
        calpulse   : std_logic;
        test_sync  : std_logic;
    end record;

    type t_ttc_conf is record
        cmd_bc0        : std_logic_vector(7 downto 0);
        cmd_ec0        : std_logic_vector(7 downto 0);
        cmd_oc0        : std_logic_vector(7 downto 0);
        cmd_resync     : std_logic_vector(7 downto 0);
        cmd_start      : std_logic_vector(7 downto 0);
        cmd_stop       : std_logic_vector(7 downto 0);
        cmd_hard_reset : std_logic_vector(7 downto 0);
        cmd_test_sync  : std_logic_vector(7 downto 0);
        cmd_calpulse   : std_logic_vector(7 downto 0);
    end record;

    type t_ttc_ctrl is record
        clk_ctrl         : t_ttc_clk_ctrl;
        reset_local      : std_logic;
        cnt_reset        : std_logic;        
        l1a_enable       : std_logic;
    end record;

    type t_bc0_status is record
        unlocked_cnt : std_logic_vector(15 downto 0);
        udf_cnt      : std_logic_vector(15 downto 0);
        ovf_cnt      : std_logic_vector(15 downto 0);
        locked       : std_logic;
        err          : std_logic;
    end record;

    type t_ttc_buffer_status is record
        depth           : std_logic_vector(3 downto 0); -- current buffer depth
        min_depth       : std_logic_vector(3 downto 0); -- min buffer depth
        max_depth       : std_logic_vector(3 downto 0); -- max buffer depth
        out_of_sync     : std_logic; -- buffer is out of sync (the depth limits have been hit)
        busy            : std_logic; -- asserted high after reset until the buffer has been initialized
        oos_cnt         : std_logic_vector(15 downto 0); -- number of times the buffer has gone into OOS state 
        unf_cnt         : std_logic_vector(15 downto 0); -- number of times the buffer had an underflow and went to OOS due to that
        ovf_cnt         : std_logic_vector(15 downto 0); -- number of times the buffer had an overflow and went to OOS due to that
        oos_time_last   : std_logic_vector(15 downto 0); -- number of seconds since last time the buffer went into OOS
        oos_dur_last    : std_logic_vector(31 downto 0); -- number of clock cycles that the last OOS state lasted before being reset
        oos_dur_max     : std_logic_vector(31 downto 0); -- maximum number of clock cycles that the OOS state lasted before being reset        
    end record;

    type t_ttc_status is record
        clk_status      : t_ttc_clk_status;
        bc0_status      : t_bc0_status;
        buffer_status   : t_ttc_buffer_status;
        single_err      : std_logic_vector(15 downto 0);
        double_err      : std_logic_vector(15 downto 0);
    end record;

    type t_ttc_cmd_cntrs is record
        l1a        : std_logic_vector(31 downto 0);
        bc0        : std_logic_vector(31 downto 0);
        ec0        : std_logic_vector(31 downto 0);
        oc0        : std_logic_vector(31 downto 0);
        resync     : std_logic_vector(31 downto 0);
        hard_reset : std_logic_vector(31 downto 0);
        start      : std_logic_vector(31 downto 0);
        stop       : std_logic_vector(31 downto 0);
        calpulse   : std_logic_vector(31 downto 0);
        test_sync  : std_logic_vector(31 downto 0);
    end record;

    type t_ttc_daq_cntrs is record
        l1id  : std_logic_vector(23 downto 0);
        orbit : std_logic_vector(15 downto 0);
        bx    : std_logic_vector(11 downto 0);
    end record;

    -- Default TTC Command Assignment 
    constant C_TTC_BGO_BC0        : std_logic_vector(7 downto 0) := X"01";
    constant C_TTC_BGO_EC0        : std_logic_vector(7 downto 0) := X"02";
    constant C_TTC_BGO_RESYNC     : std_logic_vector(7 downto 0) := X"04";
    constant C_TTC_BGO_OC0        : std_logic_vector(7 downto 0) := X"08";
    constant C_TTC_BGO_HARD_RESET : std_logic_vector(7 downto 0) := X"10";
    constant C_TTC_BGO_CALPULSE   : std_logic_vector(7 downto 0) := X"14";
    constant C_TTC_BGO_START      : std_logic_vector(7 downto 0) := X"18";
    constant C_TTC_BGO_STOP       : std_logic_vector(7 downto 0) := X"1C";
    constant C_TTC_BGO_TEST_SYNC  : std_logic_vector(7 downto 0) := X"20";

end ttc_pkg;
--============================================================================
--                                                                 Package end 
--============================================================================
