library IEEE;
use IEEE.STD_LOGIC_1164.all;

-----> !! This package is auto-generated from an address table file using <repo_root>/scripts/generate_registers.py !! <-----
package registers is

    --============================================================================
    --       >>> TTC Module <<<    base address: 0x00300000
    --
    -- TTC control and monitoring. It takes care of locking to the TTC clock
    -- coming from the                        backplane as well as decoding TTC
    -- commands and forwarding that to all other modules in
    -- the design. It also provides several control and monitoring registers
    -- (resets, command                        decoding configuration, clock and
    -- data status, bc0 status, command counters and a small spy buffer)
    --============================================================================

    constant REG_TTC_NUM_REGS : integer := 50;
    constant REG_TTC_ADDRESS_MSB : integer := 7;
    constant REG_TTC_ADDRESS_LSB : integer := 0;
    constant REG_TTC_CTRL_MODULE_RESET_ADDR    : std_logic_vector(7 downto 0) := x"00";
    constant REG_TTC_CTRL_MODULE_RESET_MSB    : integer := 31;
    constant REG_TTC_CTRL_MODULE_RESET_LSB     : integer := 0;

    constant REG_TTC_CTRL_MMCM_RESET_ADDR    : std_logic_vector(7 downto 0) := x"01";
    constant REG_TTC_CTRL_MMCM_RESET_MSB    : integer := 31;
    constant REG_TTC_CTRL_MMCM_RESET_LSB     : integer := 0;

    constant REG_TTC_CTRL_CNT_RESET_ADDR    : std_logic_vector(7 downto 0) := x"02";
    constant REG_TTC_CTRL_CNT_RESET_MSB    : integer := 31;
    constant REG_TTC_CTRL_CNT_RESET_LSB     : integer := 0;

    constant REG_TTC_CTRL_PHASE_ALIGNMENT_RESET_ADDR    : std_logic_vector(7 downto 0) := x"03";
    constant REG_TTC_CTRL_PHASE_ALIGNMENT_RESET_MSB    : integer := 31;
    constant REG_TTC_CTRL_PHASE_ALIGNMENT_RESET_LSB     : integer := 0;

    constant REG_TTC_CTRL_L1A_ENABLE_ADDR    : std_logic_vector(7 downto 0) := x"04";
    constant REG_TTC_CTRL_L1A_ENABLE_BIT    : integer := 0;
    constant REG_TTC_CTRL_L1A_ENABLE_DEFAULT : std_logic := '1';

    constant REG_TTC_CTRL_PA_SHIFT_WAIT_TIME_ADDR    : std_logic_vector(7 downto 0) := x"04";
    constant REG_TTC_CTRL_PA_SHIFT_WAIT_TIME_MSB    : integer := 23;
    constant REG_TTC_CTRL_PA_SHIFT_WAIT_TIME_LSB     : integer := 8;
    constant REG_TTC_CTRL_PA_SHIFT_WAIT_TIME_DEFAULT : std_logic_vector(23 downto 8) := x"a2c2";

    constant REG_TTC_CTRL_GTH_TXDLYBYPASS_ADDR    : std_logic_vector(7 downto 0) := x"04";
    constant REG_TTC_CTRL_GTH_TXDLYBYPASS_BIT    : integer := 26;
    constant REG_TTC_CTRL_GTH_TXDLYBYPASS_DEFAULT : std_logic := '1';

    constant REG_TTC_CTRL_PA_GTH_SHIFT_USE_SEL_ADDR    : std_logic_vector(7 downto 0) := x"04";
    constant REG_TTC_CTRL_PA_GTH_SHIFT_USE_SEL_BIT    : integer := 27;
    constant REG_TTC_CTRL_PA_GTH_SHIFT_USE_SEL_DEFAULT : std_logic := '0';

    constant REG_TTC_CTRL_PA_GTH_SHIFT_REV_DIR_ADDR    : std_logic_vector(7 downto 0) := x"04";
    constant REG_TTC_CTRL_PA_GTH_SHIFT_REV_DIR_BIT    : integer := 28;
    constant REG_TTC_CTRL_PA_GTH_SHIFT_REV_DIR_DEFAULT : std_logic := '0';

    constant REG_TTC_CTRL_PA_DISABLE_GTH_PHASE_TRACKING_ADDR    : std_logic_vector(7 downto 0) := x"04";
    constant REG_TTC_CTRL_PA_DISABLE_GTH_PHASE_TRACKING_BIT    : integer := 29;
    constant REG_TTC_CTRL_PA_DISABLE_GTH_PHASE_TRACKING_DEFAULT : std_logic := '1';

    constant REG_TTC_CTRL_PA_DISABLE_INIT_SHIFT_OUT_ADDR    : std_logic_vector(7 downto 0) := x"04";
    constant REG_TTC_CTRL_PA_DISABLE_INIT_SHIFT_OUT_BIT    : integer := 30;
    constant REG_TTC_CTRL_PA_DISABLE_INIT_SHIFT_OUT_DEFAULT : std_logic := '0';

    constant REG_TTC_CTRL_DISABLE_PHASE_ALIGNMENT_ADDR    : std_logic_vector(7 downto 0) := x"04";
    constant REG_TTC_CTRL_DISABLE_PHASE_ALIGNMENT_BIT    : integer := 31;
    constant REG_TTC_CTRL_DISABLE_PHASE_ALIGNMENT_DEFAULT : std_logic := '1';

    constant REG_TTC_CTRL_PA_MANUAL_OVERRIDE_ADDR    : std_logic_vector(7 downto 0) := x"05";
    constant REG_TTC_CTRL_PA_MANUAL_OVERRIDE_BIT    : integer := 0;
    constant REG_TTC_CTRL_PA_MANUAL_OVERRIDE_DEFAULT : std_logic := '0';

    constant REG_TTC_CTRL_PA_MANUAL_SHIFT_DIR_ADDR    : std_logic_vector(7 downto 0) := x"05";
    constant REG_TTC_CTRL_PA_MANUAL_SHIFT_DIR_BIT    : integer := 1;
    constant REG_TTC_CTRL_PA_MANUAL_SHIFT_DIR_DEFAULT : std_logic := '0';

    constant REG_TTC_CTRL_PA_MANUAL_SHIFT_EN_ADDR    : std_logic_vector(7 downto 0) := x"06";
    constant REG_TTC_CTRL_PA_MANUAL_SHIFT_EN_MSB    : integer := 31;
    constant REG_TTC_CTRL_PA_MANUAL_SHIFT_EN_LSB     : integer := 0;

    constant REG_TTC_CTRL_PA_GTH_MANUAL_SEL_OVERRIDE_ADDR    : std_logic_vector(7 downto 0) := x"07";
    constant REG_TTC_CTRL_PA_GTH_MANUAL_SEL_OVERRIDE_BIT    : integer := 0;
    constant REG_TTC_CTRL_PA_GTH_MANUAL_SEL_OVERRIDE_DEFAULT : std_logic := '0';

    constant REG_TTC_CTRL_PA_GTH_MANUAL_OVERRIDE_ADDR    : std_logic_vector(7 downto 0) := x"07";
    constant REG_TTC_CTRL_PA_GTH_MANUAL_OVERRIDE_BIT    : integer := 1;
    constant REG_TTC_CTRL_PA_GTH_MANUAL_OVERRIDE_DEFAULT : std_logic := '0';

    constant REG_TTC_CTRL_PA_GTH_MANUAL_SHIFT_DIR_ADDR    : std_logic_vector(7 downto 0) := x"07";
    constant REG_TTC_CTRL_PA_GTH_MANUAL_SHIFT_DIR_BIT    : integer := 2;
    constant REG_TTC_CTRL_PA_GTH_MANUAL_SHIFT_DIR_DEFAULT : std_logic := '0';

    constant REG_TTC_CTRL_PA_GTH_MANUAL_SHIFT_STEP_ADDR    : std_logic_vector(7 downto 0) := x"07";
    constant REG_TTC_CTRL_PA_GTH_MANUAL_SHIFT_STEP_MSB    : integer := 7;
    constant REG_TTC_CTRL_PA_GTH_MANUAL_SHIFT_STEP_LSB     : integer := 4;
    constant REG_TTC_CTRL_PA_GTH_MANUAL_SHIFT_STEP_DEFAULT : std_logic_vector(7 downto 4) := x"1";

    constant REG_TTC_CTRL_PA_GTH_MANUAL_COMBINED_ADDR    : std_logic_vector(7 downto 0) := x"07";
    constant REG_TTC_CTRL_PA_GTH_MANUAL_COMBINED_BIT    : integer := 8;
    constant REG_TTC_CTRL_PA_GTH_MANUAL_COMBINED_DEFAULT : std_logic := '1';

    constant REG_TTC_CTRL_PA_GTH_MANUAL_SHIFT_EN_ADDR    : std_logic_vector(7 downto 0) := x"08";
    constant REG_TTC_CTRL_PA_GTH_MANUAL_SHIFT_EN_MSB    : integer := 31;
    constant REG_TTC_CTRL_PA_GTH_MANUAL_SHIFT_EN_LSB     : integer := 0;

    constant REG_TTC_CTRL_PA_MANUAL_PLL_RESET_ADDR    : std_logic_vector(7 downto 0) := x"09";
    constant REG_TTC_CTRL_PA_MANUAL_PLL_RESET_MSB    : integer := 31;
    constant REG_TTC_CTRL_PA_MANUAL_PLL_RESET_LSB     : integer := 0;

    constant REG_TTC_CTRL_BUF_DEPTH_AFTER_RESET_ADDR    : std_logic_vector(7 downto 0) := x"0d";
    constant REG_TTC_CTRL_BUF_DEPTH_AFTER_RESET_MSB    : integer := 3;
    constant REG_TTC_CTRL_BUF_DEPTH_AFTER_RESET_LSB     : integer := 0;
    constant REG_TTC_CTRL_BUF_DEPTH_AFTER_RESET_DEFAULT : std_logic_vector(3 downto 0) := x"2";

    constant REG_TTC_CTRL_BUF_OOS_MIN_DEPTH_ADDR    : std_logic_vector(7 downto 0) := x"0d";
    constant REG_TTC_CTRL_BUF_OOS_MIN_DEPTH_MSB    : integer := 7;
    constant REG_TTC_CTRL_BUF_OOS_MIN_DEPTH_LSB     : integer := 4;
    constant REG_TTC_CTRL_BUF_OOS_MIN_DEPTH_DEFAULT : std_logic_vector(7 downto 4) := x"2";

    constant REG_TTC_CTRL_BUF_OOS_MAX_DEPTH_ADDR    : std_logic_vector(7 downto 0) := x"0d";
    constant REG_TTC_CTRL_BUF_OOS_MAX_DEPTH_MSB    : integer := 11;
    constant REG_TTC_CTRL_BUF_OOS_MAX_DEPTH_LSB     : integer := 8;
    constant REG_TTC_CTRL_BUF_OOS_MAX_DEPTH_DEFAULT : std_logic_vector(11 downto 8) := x"4";

    constant REG_TTC_CONFIG_CMD_BC0_ADDR    : std_logic_vector(7 downto 0) := x"10";
    constant REG_TTC_CONFIG_CMD_BC0_MSB    : integer := 7;
    constant REG_TTC_CONFIG_CMD_BC0_LSB     : integer := 0;
    constant REG_TTC_CONFIG_CMD_BC0_DEFAULT : std_logic_vector(7 downto 0) := x"01";

    constant REG_TTC_CONFIG_CMD_EC0_ADDR    : std_logic_vector(7 downto 0) := x"10";
    constant REG_TTC_CONFIG_CMD_EC0_MSB    : integer := 15;
    constant REG_TTC_CONFIG_CMD_EC0_LSB     : integer := 8;
    constant REG_TTC_CONFIG_CMD_EC0_DEFAULT : std_logic_vector(15 downto 8) := x"02";

    constant REG_TTC_CONFIG_CMD_RESYNC_ADDR    : std_logic_vector(7 downto 0) := x"10";
    constant REG_TTC_CONFIG_CMD_RESYNC_MSB    : integer := 23;
    constant REG_TTC_CONFIG_CMD_RESYNC_LSB     : integer := 16;
    constant REG_TTC_CONFIG_CMD_RESYNC_DEFAULT : std_logic_vector(23 downto 16) := x"04";

    constant REG_TTC_CONFIG_CMD_OC0_ADDR    : std_logic_vector(7 downto 0) := x"10";
    constant REG_TTC_CONFIG_CMD_OC0_MSB    : integer := 31;
    constant REG_TTC_CONFIG_CMD_OC0_LSB     : integer := 24;
    constant REG_TTC_CONFIG_CMD_OC0_DEFAULT : std_logic_vector(31 downto 24) := x"08";

    constant REG_TTC_CONFIG_CMD_HARD_RESET_ADDR    : std_logic_vector(7 downto 0) := x"11";
    constant REG_TTC_CONFIG_CMD_HARD_RESET_MSB    : integer := 7;
    constant REG_TTC_CONFIG_CMD_HARD_RESET_LSB     : integer := 0;
    constant REG_TTC_CONFIG_CMD_HARD_RESET_DEFAULT : std_logic_vector(7 downto 0) := x"10";

    constant REG_TTC_CONFIG_CMD_CALPULSE_ADDR    : std_logic_vector(7 downto 0) := x"11";
    constant REG_TTC_CONFIG_CMD_CALPULSE_MSB    : integer := 15;
    constant REG_TTC_CONFIG_CMD_CALPULSE_LSB     : integer := 8;
    constant REG_TTC_CONFIG_CMD_CALPULSE_DEFAULT : std_logic_vector(15 downto 8) := x"14";

    constant REG_TTC_CONFIG_CMD_START_ADDR    : std_logic_vector(7 downto 0) := x"11";
    constant REG_TTC_CONFIG_CMD_START_MSB    : integer := 23;
    constant REG_TTC_CONFIG_CMD_START_LSB     : integer := 16;
    constant REG_TTC_CONFIG_CMD_START_DEFAULT : std_logic_vector(23 downto 16) := x"18";

    constant REG_TTC_CONFIG_CMD_STOP_ADDR    : std_logic_vector(7 downto 0) := x"11";
    constant REG_TTC_CONFIG_CMD_STOP_MSB    : integer := 31;
    constant REG_TTC_CONFIG_CMD_STOP_LSB     : integer := 24;
    constant REG_TTC_CONFIG_CMD_STOP_DEFAULT : std_logic_vector(31 downto 24) := x"1c";

    constant REG_TTC_CONFIG_CMD_TEST_SYNC_ADDR    : std_logic_vector(7 downto 0) := x"12";
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_MSB    : integer := 7;
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_LSB     : integer := 0;
    constant REG_TTC_CONFIG_CMD_TEST_SYNC_DEFAULT : std_logic_vector(7 downto 0) := x"20";

    constant REG_TTC_STATUS_CLK_MMCM_LOCKED_ADDR    : std_logic_vector(7 downto 0) := x"20";
    constant REG_TTC_STATUS_CLK_MMCM_LOCKED_BIT    : integer := 0;

    constant REG_TTC_STATUS_CLK_SYNC_DONE_ADDR    : std_logic_vector(7 downto 0) := x"20";
    constant REG_TTC_STATUS_CLK_SYNC_DONE_BIT    : integer := 1;

    constant REG_TTC_STATUS_CLK_PHASE_LOCKED_ADDR    : std_logic_vector(7 downto 0) := x"20";
    constant REG_TTC_STATUS_CLK_PHASE_LOCKED_BIT    : integer := 2;

    constant REG_TTC_STATUS_CLK_MMCM_UNLOCK_CNT_ADDR    : std_logic_vector(7 downto 0) := x"20";
    constant REG_TTC_STATUS_CLK_MMCM_UNLOCK_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_CLK_MMCM_UNLOCK_CNT_LSB     : integer := 16;

    constant REG_TTC_STATUS_CLK_SYNC_RESTART_CNT_ADDR    : std_logic_vector(7 downto 0) := x"21";
    constant REG_TTC_STATUS_CLK_SYNC_RESTART_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_CLK_SYNC_RESTART_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_PHASE_UNLOCK_CNT_ADDR    : std_logic_vector(7 downto 0) := x"21";
    constant REG_TTC_STATUS_CLK_PHASE_UNLOCK_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_CLK_PHASE_UNLOCK_CNT_LSB     : integer := 16;

    constant REG_TTC_STATUS_CLK_SYNC_DONE_TIME_ADDR    : std_logic_vector(7 downto 0) := x"22";
    constant REG_TTC_STATUS_CLK_SYNC_DONE_TIME_MSB    : integer := 15;
    constant REG_TTC_STATUS_CLK_SYNC_DONE_TIME_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_PHASE_UNLOCK_TIME_ADDR    : std_logic_vector(7 downto 0) := x"22";
    constant REG_TTC_STATUS_CLK_PHASE_UNLOCK_TIME_MSB    : integer := 31;
    constant REG_TTC_STATUS_CLK_PHASE_UNLOCK_TIME_LSB     : integer := 16;

    constant REG_TTC_STATUS_CLK_PA_PLL_LOCK_WINDOW_ADDR    : std_logic_vector(7 downto 0) := x"23";
    constant REG_TTC_STATUS_CLK_PA_PLL_LOCK_WINDOW_MSB    : integer := 15;
    constant REG_TTC_STATUS_CLK_PA_PLL_LOCK_WINDOW_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_PA_PHASE_SHIFT_CNT_ADDR    : std_logic_vector(7 downto 0) := x"23";
    constant REG_TTC_STATUS_CLK_PA_PHASE_SHIFT_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_CLK_PA_PHASE_SHIFT_CNT_LSB     : integer := 16;

    constant REG_TTC_STATUS_CLK_PA_PLL_LOCK_CLOCKS_ADDR    : std_logic_vector(7 downto 0) := x"24";
    constant REG_TTC_STATUS_CLK_PA_PLL_LOCK_CLOCKS_MSB    : integer := 23;
    constant REG_TTC_STATUS_CLK_PA_PLL_LOCK_CLOCKS_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_PA_FSM_STATE_ADDR    : std_logic_vector(7 downto 0) := x"24";
    constant REG_TTC_STATUS_CLK_PA_FSM_STATE_MSB    : integer := 30;
    constant REG_TTC_STATUS_CLK_PA_FSM_STATE_LSB     : integer := 28;

    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_ADDR    : std_logic_vector(7 downto 0) := x"25";
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_MSB    : integer := 11;
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_MEAN_ADDR    : std_logic_vector(7 downto 0) := x"25";
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_MEAN_MSB    : integer := 23;
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_MEAN_LSB     : integer := 12;

    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_MIN_ADDR    : std_logic_vector(7 downto 0) := x"26";
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_MIN_MSB    : integer := 11;
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_MIN_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_MAX_ADDR    : std_logic_vector(7 downto 0) := x"26";
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_MAX_MSB    : integer := 23;
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_MAX_LSB     : integer := 12;

    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_JUMP_CNT_ADDR    : std_logic_vector(7 downto 0) := x"27";
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_JUMP_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_JUMP_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_JUMP_SIZE_ADDR    : std_logic_vector(7 downto 0) := x"27";
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_JUMP_SIZE_MSB    : integer := 27;
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_JUMP_SIZE_LSB     : integer := 16;

    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_JUMP_TIME_ADDR    : std_logic_vector(7 downto 0) := x"28";
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_JUMP_TIME_MSB    : integer := 15;
    constant REG_TTC_STATUS_CLK_TTC_PM_PHASE_JUMP_TIME_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_ADDR    : std_logic_vector(7 downto 0) := x"29";
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_MSB    : integer := 11;
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_MEAN_ADDR    : std_logic_vector(7 downto 0) := x"29";
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_MEAN_MSB    : integer := 23;
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_MEAN_LSB     : integer := 12;

    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_MIN_ADDR    : std_logic_vector(7 downto 0) := x"2a";
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_MIN_MSB    : integer := 11;
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_MIN_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_MAX_ADDR    : std_logic_vector(7 downto 0) := x"2a";
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_MAX_MSB    : integer := 23;
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_MAX_LSB     : integer := 12;

    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_JUMP_CNT_ADDR    : std_logic_vector(7 downto 0) := x"2b";
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_JUMP_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_JUMP_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_JUMP_SIZE_ADDR    : std_logic_vector(7 downto 0) := x"2b";
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_JUMP_SIZE_MSB    : integer := 27;
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_JUMP_SIZE_LSB     : integer := 16;

    constant REG_TTC_STATUS_CLK_GTH_SHIFT_ERROR_ADDR    : std_logic_vector(7 downto 0) := x"2b";
    constant REG_TTC_STATUS_CLK_GTH_SHIFT_ERROR_MSB    : integer := 31;
    constant REG_TTC_STATUS_CLK_GTH_SHIFT_ERROR_LSB     : integer := 28;

    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_JUMP_TIME_ADDR    : std_logic_vector(7 downto 0) := x"2c";
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_JUMP_TIME_MSB    : integer := 15;
    constant REG_TTC_STATUS_CLK_GTH_PM_PHASE_JUMP_TIME_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_GTH_SHIFT_CNT_ADDR    : std_logic_vector(7 downto 0) := x"2c";
    constant REG_TTC_STATUS_CLK_GTH_SHIFT_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_CLK_GTH_SHIFT_CNT_LSB     : integer := 16;

    constant REG_TTC_STATUS_CLK_GTH_RESET_CNT_ADDR    : std_logic_vector(7 downto 0) := x"2d";
    constant REG_TTC_STATUS_CLK_GTH_RESET_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_CLK_GTH_RESET_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_PA_MANUAL_SHIFT_CNT_ADDR    : std_logic_vector(7 downto 0) := x"2e";
    constant REG_TTC_STATUS_CLK_PA_MANUAL_SHIFT_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_CLK_PA_MANUAL_SHIFT_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_CLK_PA_MANUAL_GTH_SHIFT_CNT_ADDR    : std_logic_vector(7 downto 0) := x"2e";
    constant REG_TTC_STATUS_CLK_PA_MANUAL_GTH_SHIFT_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_CLK_PA_MANUAL_GTH_SHIFT_CNT_LSB     : integer := 16;

    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_ADDR    : std_logic_vector(7 downto 0) := x"30";
    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_TTC_SINGLE_ERROR_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_ADDR    : std_logic_vector(7 downto 0) := x"30";
    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_TTC_DOUBLE_ERROR_CNT_LSB     : integer := 16;

    constant REG_TTC_STATUS_BC0_LOCKED_ADDR    : std_logic_vector(7 downto 0) := x"31";
    constant REG_TTC_STATUS_BC0_LOCKED_BIT    : integer := 0;

    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_ADDR    : std_logic_vector(7 downto 0) := x"32";
    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_BC0_UNLOCK_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_ADDR    : std_logic_vector(7 downto 0) := x"33";
    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_BC0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_ADDR    : std_logic_vector(7 downto 0) := x"33";
    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_BC0_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TTC_STATUS_BUFFER_DEPTH_ADDR    : std_logic_vector(7 downto 0) := x"35";
    constant REG_TTC_STATUS_BUFFER_DEPTH_MSB    : integer := 3;
    constant REG_TTC_STATUS_BUFFER_DEPTH_LSB     : integer := 0;

    constant REG_TTC_STATUS_BUFFER_MIN_DEPTH_ADDR    : std_logic_vector(7 downto 0) := x"35";
    constant REG_TTC_STATUS_BUFFER_MIN_DEPTH_MSB    : integer := 7;
    constant REG_TTC_STATUS_BUFFER_MIN_DEPTH_LSB     : integer := 4;

    constant REG_TTC_STATUS_BUFFER_MAX_DEPTH_ADDR    : std_logic_vector(7 downto 0) := x"35";
    constant REG_TTC_STATUS_BUFFER_MAX_DEPTH_MSB    : integer := 11;
    constant REG_TTC_STATUS_BUFFER_MAX_DEPTH_LSB     : integer := 8;

    constant REG_TTC_STATUS_BUFFER_OOS_ADDR    : std_logic_vector(7 downto 0) := x"35";
    constant REG_TTC_STATUS_BUFFER_OOS_BIT    : integer := 12;

    constant REG_TTC_STATUS_BUFFER_BUSY_ADDR    : std_logic_vector(7 downto 0) := x"35";
    constant REG_TTC_STATUS_BUFFER_BUSY_BIT    : integer := 13;

    constant REG_TTC_STATUS_BUFFER_OOS_CNT_ADDR    : std_logic_vector(7 downto 0) := x"35";
    constant REG_TTC_STATUS_BUFFER_OOS_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_BUFFER_OOS_CNT_LSB     : integer := 16;

    constant REG_TTC_STATUS_BUFFER_UNF_CNT_ADDR    : std_logic_vector(7 downto 0) := x"36";
    constant REG_TTC_STATUS_BUFFER_UNF_CNT_MSB    : integer := 15;
    constant REG_TTC_STATUS_BUFFER_UNF_CNT_LSB     : integer := 0;

    constant REG_TTC_STATUS_BUFFER_OVF_CNT_ADDR    : std_logic_vector(7 downto 0) := x"36";
    constant REG_TTC_STATUS_BUFFER_OVF_CNT_MSB    : integer := 31;
    constant REG_TTC_STATUS_BUFFER_OVF_CNT_LSB     : integer := 16;

    constant REG_TTC_STATUS_BUFFER_LAST_OOS_TIME_SECONDS_ADDR    : std_logic_vector(7 downto 0) := x"37";
    constant REG_TTC_STATUS_BUFFER_LAST_OOS_TIME_SECONDS_MSB    : integer := 15;
    constant REG_TTC_STATUS_BUFFER_LAST_OOS_TIME_SECONDS_LSB     : integer := 0;

    constant REG_TTC_STATUS_BUFFER_OOS_DURATION_LAST_ADDR    : std_logic_vector(7 downto 0) := x"38";
    constant REG_TTC_STATUS_BUFFER_OOS_DURATION_LAST_MSB    : integer := 31;
    constant REG_TTC_STATUS_BUFFER_OOS_DURATION_LAST_LSB     : integer := 0;

    constant REG_TTC_STATUS_BUFFER_OOS_DURATION_MAX_ADDR    : std_logic_vector(7 downto 0) := x"39";
    constant REG_TTC_STATUS_BUFFER_OOS_DURATION_MAX_MSB    : integer := 31;
    constant REG_TTC_STATUS_BUFFER_OOS_DURATION_MAX_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_L1A_ADDR    : std_logic_vector(7 downto 0) := x"40";
    constant REG_TTC_CMD_COUNTERS_L1A_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_L1A_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_BC0_ADDR    : std_logic_vector(7 downto 0) := x"41";
    constant REG_TTC_CMD_COUNTERS_BC0_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_BC0_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_EC0_ADDR    : std_logic_vector(7 downto 0) := x"42";
    constant REG_TTC_CMD_COUNTERS_EC0_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_EC0_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_RESYNC_ADDR    : std_logic_vector(7 downto 0) := x"43";
    constant REG_TTC_CMD_COUNTERS_RESYNC_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_RESYNC_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_OC0_ADDR    : std_logic_vector(7 downto 0) := x"44";
    constant REG_TTC_CMD_COUNTERS_OC0_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_OC0_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_HARD_RESET_ADDR    : std_logic_vector(7 downto 0) := x"45";
    constant REG_TTC_CMD_COUNTERS_HARD_RESET_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_HARD_RESET_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_CALPULSE_ADDR    : std_logic_vector(7 downto 0) := x"46";
    constant REG_TTC_CMD_COUNTERS_CALPULSE_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_CALPULSE_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_START_ADDR    : std_logic_vector(7 downto 0) := x"47";
    constant REG_TTC_CMD_COUNTERS_START_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_START_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_STOP_ADDR    : std_logic_vector(7 downto 0) := x"48";
    constant REG_TTC_CMD_COUNTERS_STOP_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_STOP_LSB     : integer := 0;

    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_ADDR    : std_logic_vector(7 downto 0) := x"49";
    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_MSB    : integer := 31;
    constant REG_TTC_CMD_COUNTERS_TEST_SYNC_LSB     : integer := 0;

    constant REG_TTC_L1A_ID_ADDR    : std_logic_vector(7 downto 0) := x"50";
    constant REG_TTC_L1A_ID_MSB    : integer := 23;
    constant REG_TTC_L1A_ID_LSB     : integer := 0;

    constant REG_TTC_L1A_RATE_ADDR    : std_logic_vector(7 downto 0) := x"51";
    constant REG_TTC_L1A_RATE_MSB    : integer := 31;
    constant REG_TTC_L1A_RATE_LSB     : integer := 0;


    --============================================================================
    --       >>> TRIGGER Module <<<    base address: 0x00800000
    --
    -- Trigger module handles everything related to sbit cluster data
    -- (link synchronization, monitoring, local triggering, matching to L1A and
    -- reporting data to DAQ)
    --============================================================================

    constant REG_TRIGGER_NUM_REGS : integer := 413;
    constant REG_TRIGGER_ADDRESS_MSB : integer := 12;
    constant REG_TRIGGER_ADDRESS_LSB : integer := 0;
    constant REG_TRIGGER_CTRL_MODULE_RESET_ADDR    : std_logic_vector(12 downto 0) := '0' & x"000";
    constant REG_TRIGGER_CTRL_MODULE_RESET_MSB    : integer := 31;
    constant REG_TRIGGER_CTRL_MODULE_RESET_LSB     : integer := 0;

    constant REG_TRIGGER_CTRL_CNT_RESET_ADDR    : std_logic_vector(12 downto 0) := '0' & x"001";
    constant REG_TRIGGER_CTRL_CNT_RESET_MSB    : integer := 31;
    constant REG_TRIGGER_CTRL_CNT_RESET_LSB     : integer := 0;

    constant REG_TRIGGER_CTRL_OH_KILL_MASK_ADDR    : std_logic_vector(12 downto 0) := '0' & x"002";
    constant REG_TRIGGER_CTRL_OH_KILL_MASK_MSB    : integer := 23;
    constant REG_TRIGGER_CTRL_OH_KILL_MASK_LSB     : integer := 0;
    constant REG_TRIGGER_CTRL_OH_KILL_MASK_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_TRIGGER_STATUS_OR_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"010";
    constant REG_TRIGGER_STATUS_OR_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_STATUS_OR_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_STATUS_OR_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"011";
    constant REG_TRIGGER_STATUS_OR_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_STATUS_OR_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"100";
    constant REG_TRIGGER_OH0_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"101";
    constant REG_TRIGGER_OH0_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"110";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"111";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"112";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"113";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"114";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"115";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"116";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"117";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"118";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"120";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"121";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"122";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"123";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"124";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"125";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"126";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"127";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"128";
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a0";
    constant REG_TRIGGER_OH0_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a0";
    constant REG_TRIGGER_OH0_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a1";
    constant REG_TRIGGER_OH0_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a1";
    constant REG_TRIGGER_OH0_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a2";
    constant REG_TRIGGER_OH0_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a2";
    constant REG_TRIGGER_OH0_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a3";
    constant REG_TRIGGER_OH0_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a3";
    constant REG_TRIGGER_OH0_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a4";
    constant REG_TRIGGER_OH0_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a4";
    constant REG_TRIGGER_OH0_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a5";
    constant REG_TRIGGER_OH0_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1a5";
    constant REG_TRIGGER_OH0_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH0_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f0";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f1";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f2";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f3";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f4";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f5";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f6";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"1f7";
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH0_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"200";
    constant REG_TRIGGER_OH1_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"201";
    constant REG_TRIGGER_OH1_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"210";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"211";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"212";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"213";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"214";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"215";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"216";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"217";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"218";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"220";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"221";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"222";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"223";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"224";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"225";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"226";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"227";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"228";
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a0";
    constant REG_TRIGGER_OH1_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a0";
    constant REG_TRIGGER_OH1_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a1";
    constant REG_TRIGGER_OH1_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a1";
    constant REG_TRIGGER_OH1_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a2";
    constant REG_TRIGGER_OH1_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a2";
    constant REG_TRIGGER_OH1_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a3";
    constant REG_TRIGGER_OH1_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a3";
    constant REG_TRIGGER_OH1_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a4";
    constant REG_TRIGGER_OH1_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a4";
    constant REG_TRIGGER_OH1_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a5";
    constant REG_TRIGGER_OH1_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2a5";
    constant REG_TRIGGER_OH1_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH1_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f0";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f1";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f2";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f3";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f4";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f5";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f6";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"2f7";
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH1_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"300";
    constant REG_TRIGGER_OH2_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"301";
    constant REG_TRIGGER_OH2_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"310";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"311";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"312";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"313";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"314";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"315";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"316";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"317";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"318";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"320";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"321";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"322";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"323";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"324";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"325";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"326";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"327";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"328";
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a0";
    constant REG_TRIGGER_OH2_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a0";
    constant REG_TRIGGER_OH2_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH2_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a1";
    constant REG_TRIGGER_OH2_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a1";
    constant REG_TRIGGER_OH2_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH2_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a2";
    constant REG_TRIGGER_OH2_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a2";
    constant REG_TRIGGER_OH2_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH2_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a3";
    constant REG_TRIGGER_OH2_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a3";
    constant REG_TRIGGER_OH2_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH2_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a4";
    constant REG_TRIGGER_OH2_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a4";
    constant REG_TRIGGER_OH2_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH2_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a5";
    constant REG_TRIGGER_OH2_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3a5";
    constant REG_TRIGGER_OH2_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH2_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f0";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f1";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f2";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f3";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f4";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f5";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f6";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"3f7";
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH2_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"400";
    constant REG_TRIGGER_OH3_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"401";
    constant REG_TRIGGER_OH3_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"410";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"411";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"412";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"413";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"414";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"415";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"416";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"417";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"418";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"420";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"421";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"422";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"423";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"424";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"425";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"426";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"427";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"428";
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a0";
    constant REG_TRIGGER_OH3_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a0";
    constant REG_TRIGGER_OH3_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH3_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a1";
    constant REG_TRIGGER_OH3_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a1";
    constant REG_TRIGGER_OH3_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH3_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a2";
    constant REG_TRIGGER_OH3_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a2";
    constant REG_TRIGGER_OH3_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH3_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a3";
    constant REG_TRIGGER_OH3_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a3";
    constant REG_TRIGGER_OH3_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH3_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a4";
    constant REG_TRIGGER_OH3_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a4";
    constant REG_TRIGGER_OH3_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH3_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a5";
    constant REG_TRIGGER_OH3_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4a5";
    constant REG_TRIGGER_OH3_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH3_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f0";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f1";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f2";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f3";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f4";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f5";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f6";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"4f7";
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH3_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"500";
    constant REG_TRIGGER_OH4_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"501";
    constant REG_TRIGGER_OH4_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"510";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"511";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"512";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"513";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"514";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"515";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"516";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"517";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"518";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"520";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"521";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"522";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"523";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"524";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"525";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"526";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"527";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"528";
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a0";
    constant REG_TRIGGER_OH4_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a0";
    constant REG_TRIGGER_OH4_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH4_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a1";
    constant REG_TRIGGER_OH4_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a1";
    constant REG_TRIGGER_OH4_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH4_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a2";
    constant REG_TRIGGER_OH4_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a2";
    constant REG_TRIGGER_OH4_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH4_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a3";
    constant REG_TRIGGER_OH4_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a3";
    constant REG_TRIGGER_OH4_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH4_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a4";
    constant REG_TRIGGER_OH4_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a4";
    constant REG_TRIGGER_OH4_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH4_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a5";
    constant REG_TRIGGER_OH4_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5a5";
    constant REG_TRIGGER_OH4_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH4_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f0";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f1";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f2";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f3";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f4";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f5";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f6";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"5f7";
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH4_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"600";
    constant REG_TRIGGER_OH5_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"601";
    constant REG_TRIGGER_OH5_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"610";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"611";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"612";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"613";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"614";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"615";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"616";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"617";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"618";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"620";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"621";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"622";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"623";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"624";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"625";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"626";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"627";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"628";
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a0";
    constant REG_TRIGGER_OH5_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a0";
    constant REG_TRIGGER_OH5_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH5_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a1";
    constant REG_TRIGGER_OH5_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a1";
    constant REG_TRIGGER_OH5_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH5_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a2";
    constant REG_TRIGGER_OH5_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a2";
    constant REG_TRIGGER_OH5_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH5_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a3";
    constant REG_TRIGGER_OH5_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a3";
    constant REG_TRIGGER_OH5_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH5_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a4";
    constant REG_TRIGGER_OH5_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a4";
    constant REG_TRIGGER_OH5_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH5_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a5";
    constant REG_TRIGGER_OH5_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6a5";
    constant REG_TRIGGER_OH5_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH5_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f0";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f1";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f2";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f3";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f4";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f5";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f6";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"6f7";
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH5_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"700";
    constant REG_TRIGGER_OH6_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"701";
    constant REG_TRIGGER_OH6_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"710";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"711";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"712";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"713";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"714";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"715";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"716";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"717";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"718";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"720";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"721";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"722";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"723";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"724";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"725";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"726";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"727";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"728";
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a0";
    constant REG_TRIGGER_OH6_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a0";
    constant REG_TRIGGER_OH6_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH6_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a1";
    constant REG_TRIGGER_OH6_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a1";
    constant REG_TRIGGER_OH6_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH6_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a2";
    constant REG_TRIGGER_OH6_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a2";
    constant REG_TRIGGER_OH6_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH6_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a3";
    constant REG_TRIGGER_OH6_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a3";
    constant REG_TRIGGER_OH6_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH6_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a4";
    constant REG_TRIGGER_OH6_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a4";
    constant REG_TRIGGER_OH6_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH6_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a5";
    constant REG_TRIGGER_OH6_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7a5";
    constant REG_TRIGGER_OH6_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH6_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f0";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f1";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f2";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f3";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f4";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f5";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f6";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"7f7";
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH6_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"800";
    constant REG_TRIGGER_OH7_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"801";
    constant REG_TRIGGER_OH7_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"810";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"811";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"812";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"813";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"814";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"815";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"816";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"817";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"818";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"820";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"821";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"822";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"823";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"824";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"825";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"826";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"827";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"828";
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a0";
    constant REG_TRIGGER_OH7_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a0";
    constant REG_TRIGGER_OH7_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH7_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a1";
    constant REG_TRIGGER_OH7_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a1";
    constant REG_TRIGGER_OH7_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH7_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a2";
    constant REG_TRIGGER_OH7_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a2";
    constant REG_TRIGGER_OH7_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH7_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a3";
    constant REG_TRIGGER_OH7_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a3";
    constant REG_TRIGGER_OH7_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH7_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a4";
    constant REG_TRIGGER_OH7_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a4";
    constant REG_TRIGGER_OH7_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH7_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a5";
    constant REG_TRIGGER_OH7_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8a5";
    constant REG_TRIGGER_OH7_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH7_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f0";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f1";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f2";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f3";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f4";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f5";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f6";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"8f7";
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH7_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"900";
    constant REG_TRIGGER_OH8_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"901";
    constant REG_TRIGGER_OH8_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"910";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"911";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"912";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"913";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"914";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"915";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"916";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"917";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"918";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"920";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"921";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"922";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"923";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"924";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"925";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"926";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"927";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"928";
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a0";
    constant REG_TRIGGER_OH8_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a0";
    constant REG_TRIGGER_OH8_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH8_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a1";
    constant REG_TRIGGER_OH8_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a1";
    constant REG_TRIGGER_OH8_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH8_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a2";
    constant REG_TRIGGER_OH8_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a2";
    constant REG_TRIGGER_OH8_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH8_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a3";
    constant REG_TRIGGER_OH8_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a3";
    constant REG_TRIGGER_OH8_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH8_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a4";
    constant REG_TRIGGER_OH8_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a4";
    constant REG_TRIGGER_OH8_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH8_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a5";
    constant REG_TRIGGER_OH8_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9a5";
    constant REG_TRIGGER_OH8_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH8_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f0";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f1";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f2";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f3";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f4";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f5";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f6";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"9f7";
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH8_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a00";
    constant REG_TRIGGER_OH9_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a01";
    constant REG_TRIGGER_OH9_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a10";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a11";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a12";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a13";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a14";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a15";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a16";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a17";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a18";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a20";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a21";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a22";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a23";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a24";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a25";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a26";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a27";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a28";
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa0";
    constant REG_TRIGGER_OH9_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa0";
    constant REG_TRIGGER_OH9_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH9_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa1";
    constant REG_TRIGGER_OH9_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa1";
    constant REG_TRIGGER_OH9_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH9_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa2";
    constant REG_TRIGGER_OH9_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa2";
    constant REG_TRIGGER_OH9_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH9_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa3";
    constant REG_TRIGGER_OH9_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa3";
    constant REG_TRIGGER_OH9_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH9_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa4";
    constant REG_TRIGGER_OH9_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa4";
    constant REG_TRIGGER_OH9_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH9_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa5";
    constant REG_TRIGGER_OH9_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"aa5";
    constant REG_TRIGGER_OH9_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH9_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af0";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af1";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af2";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af3";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af4";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af5";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af6";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"af7";
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH9_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b00";
    constant REG_TRIGGER_OH10_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b01";
    constant REG_TRIGGER_OH10_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b10";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b11";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b12";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b13";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b14";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b15";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b16";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b17";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b18";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b20";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b21";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b22";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b23";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b24";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b25";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b26";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b27";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b28";
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba0";
    constant REG_TRIGGER_OH10_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba0";
    constant REG_TRIGGER_OH10_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH10_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba1";
    constant REG_TRIGGER_OH10_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba1";
    constant REG_TRIGGER_OH10_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH10_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba2";
    constant REG_TRIGGER_OH10_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba2";
    constant REG_TRIGGER_OH10_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH10_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba3";
    constant REG_TRIGGER_OH10_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba3";
    constant REG_TRIGGER_OH10_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH10_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba4";
    constant REG_TRIGGER_OH10_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba4";
    constant REG_TRIGGER_OH10_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH10_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba5";
    constant REG_TRIGGER_OH10_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ba5";
    constant REG_TRIGGER_OH10_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH10_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf0";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf1";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf2";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf3";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf4";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf5";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf6";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"bf7";
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH10_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_TRIGGER_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c00";
    constant REG_TRIGGER_OH11_TRIGGER_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_TRIGGER_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_TRIGGER_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c01";
    constant REG_TRIGGER_OH11_TRIGGER_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_TRIGGER_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c10";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c11";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c12";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c13";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c14";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c15";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c16";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c17";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_RATE_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c18";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_RATE_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_RATE_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c20";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_0_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c21";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_1_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c22";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_2_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c23";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_3_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c24";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_4_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c25";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_5_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c26";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_6_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c27";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_7_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c28";
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_CLUSTER_SIZE_8_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK0_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca0";
    constant REG_TRIGGER_OH11_LINK0_NOT_VALID_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_LINK0_NOT_VALID_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK1_NOT_VALID_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca0";
    constant REG_TRIGGER_OH11_LINK1_NOT_VALID_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_LINK1_NOT_VALID_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH11_LINK0_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca1";
    constant REG_TRIGGER_OH11_LINK0_MISSED_COMMA_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_LINK0_MISSED_COMMA_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK1_MISSED_COMMA_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca1";
    constant REG_TRIGGER_OH11_LINK1_MISSED_COMMA_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_LINK1_MISSED_COMMA_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH11_LINK0_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca2";
    constant REG_TRIGGER_OH11_LINK0_INVALID_SIZE_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_LINK0_INVALID_SIZE_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK1_INVALID_SIZE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca2";
    constant REG_TRIGGER_OH11_LINK1_INVALID_SIZE_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_LINK1_INVALID_SIZE_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH11_LINK0_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca3";
    constant REG_TRIGGER_OH11_LINK0_OVERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_LINK0_OVERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK1_OVERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca3";
    constant REG_TRIGGER_OH11_LINK1_OVERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_LINK1_OVERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH11_LINK0_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca4";
    constant REG_TRIGGER_OH11_LINK0_UNDERFLOW_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_LINK0_UNDERFLOW_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK1_UNDERFLOW_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca4";
    constant REG_TRIGGER_OH11_LINK1_UNDERFLOW_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_LINK1_UNDERFLOW_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH11_LINK0_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca5";
    constant REG_TRIGGER_OH11_LINK0_SYNC_WORD_CNT_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_LINK0_SYNC_WORD_CNT_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_LINK1_SYNC_WORD_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"ca5";
    constant REG_TRIGGER_OH11_LINK1_SYNC_WORD_CNT_MSB    : integer := 31;
    constant REG_TRIGGER_OH11_LINK1_SYNC_WORD_CNT_LSB     : integer := 16;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_0_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf0";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_0_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_0_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_1_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf1";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_1_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_1_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_2_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf2";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_2_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_2_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_3_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf3";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_3_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_3_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_4_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf4";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_4_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_4_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_5_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf5";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_5_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_5_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_6_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf6";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_6_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_6_LSB     : integer := 0;

    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_7_ADDR    : std_logic_vector(12 downto 0) := '0' & x"cf7";
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_7_MSB    : integer := 15;
    constant REG_TRIGGER_OH11_DEBUG_LAST_CLUSTER_7_LSB     : integer := 0;


    --============================================================================
    --       >>> GEM_SYSTEM Module <<<    base address: 0x00900000
    --
    -- This module is controlling GEM AMC System wide settings
    --============================================================================

    constant REG_GEM_SYSTEM_NUM_REGS : integer := 11;
    constant REG_GEM_SYSTEM_ADDRESS_MSB : integer := 16;
    constant REG_GEM_SYSTEM_ADDRESS_LSB : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0000";
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_MSB    : integer := 23;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_RX_POLARITY_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0001";
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_MSB    : integer := 23;
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_TK_LINK_TX_POLARITY_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_GEM_SYSTEM_BOARD_ID_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0002";
    constant REG_GEM_SYSTEM_BOARD_ID_MSB    : integer := 15;
    constant REG_GEM_SYSTEM_BOARD_ID_LSB     : integer := 0;
    constant REG_GEM_SYSTEM_BOARD_ID_DEFAULT : std_logic_vector(15 downto 0) := x"beef";

    constant REG_GEM_SYSTEM_BOARD_TYPE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0002";
    constant REG_GEM_SYSTEM_BOARD_TYPE_MSB    : integer := 19;
    constant REG_GEM_SYSTEM_BOARD_TYPE_LSB     : integer := 16;

    constant REG_GEM_SYSTEM_RELEASE_BUILD_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0003";
    constant REG_GEM_SYSTEM_RELEASE_BUILD_MSB    : integer := 7;
    constant REG_GEM_SYSTEM_RELEASE_BUILD_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_RELEASE_MINOR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0003";
    constant REG_GEM_SYSTEM_RELEASE_MINOR_MSB    : integer := 15;
    constant REG_GEM_SYSTEM_RELEASE_MINOR_LSB     : integer := 8;

    constant REG_GEM_SYSTEM_RELEASE_MAJOR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0003";
    constant REG_GEM_SYSTEM_RELEASE_MAJOR_MSB    : integer := 23;
    constant REG_GEM_SYSTEM_RELEASE_MAJOR_LSB     : integer := 16;

    constant REG_GEM_SYSTEM_RELEASE_DATE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0004";
    constant REG_GEM_SYSTEM_RELEASE_DATE_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_RELEASE_DATE_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_CONFIG_NUM_OF_OH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0005";
    constant REG_GEM_SYSTEM_CONFIG_NUM_OF_OH_MSB    : integer := 4;
    constant REG_GEM_SYSTEM_CONFIG_NUM_OF_OH_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_CONFIG_USE_GBT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0005";
    constant REG_GEM_SYSTEM_CONFIG_USE_GBT_BIT    : integer := 8;

    constant REG_GEM_SYSTEM_CONFIG_USE_TRIG_LINKS_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0005";
    constant REG_GEM_SYSTEM_CONFIG_USE_TRIG_LINKS_BIT    : integer := 9;

    constant REG_GEM_SYSTEM_CTRL_CNT_RESET_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0100";
    constant REG_GEM_SYSTEM_CTRL_CNT_RESET_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_CTRL_CNT_RESET_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_TESTS_GBT_LOOPBACK_EN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0200";
    constant REG_GEM_SYSTEM_TESTS_GBT_LOOPBACK_EN_BIT    : integer := 0;
    constant REG_GEM_SYSTEM_TESTS_GBT_LOOPBACK_EN_DEFAULT : std_logic := '0';

    constant REG_GEM_SYSTEM_TESTS_8B10B_LOOPBACK_EN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0200";
    constant REG_GEM_SYSTEM_TESTS_8B10B_LOOPBACK_EN_BIT    : integer := 1;
    constant REG_GEM_SYSTEM_TESTS_8B10B_LOOPBACK_EN_DEFAULT : std_logic := '0';

    constant REG_GEM_SYSTEM_TESTS_8B10B_LOOPBACK_USE_TRIG_LINKS_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0200";
    constant REG_GEM_SYSTEM_TESTS_8B10B_LOOPBACK_USE_TRIG_LINKS_BIT    : integer := 2;
    constant REG_GEM_SYSTEM_TESTS_8B10B_LOOPBACK_USE_TRIG_LINKS_DEFAULT : std_logic := '0';

    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_BOARD_ID_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0000";
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_BOARD_ID_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_BOARD_ID_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_SYSTEM_ID_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0001";
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_SYSTEM_ID_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_SYSTEM_ID_LSB     : integer := 0;

    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_FIRMWARE_VERSION_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0002";
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_FIRMWARE_VERSION_MSB    : integer := 31;
    constant REG_GEM_SYSTEM_LEGACY_SYSTEM_FIRMWARE_VERSION_LSB     : integer := 0;


    --============================================================================
    --       >>> GEM_TESTS Module <<<    base address: 0x00a00000
    --
    -- This module is controlling various hardware tests e.g. fiber loopback
    --============================================================================

    constant REG_GEM_TESTS_NUM_REGS : integer := 170;
    constant REG_GEM_TESTS_ADDRESS_MSB : integer := 16;
    constant REG_GEM_TESTS_ADDRESS_LSB : integer := 0;
    constant REG_GEM_TESTS_CTRL_RESET_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0000";
    constant REG_GEM_TESTS_CTRL_RESET_MSB    : integer := 31;
    constant REG_GEM_TESTS_CTRL_RESET_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_CTRL_LOOP_THROUGH_OH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1000";
    constant REG_GEM_TESTS_GBT_LOOPBACK_CTRL_LOOP_THROUGH_OH_BIT    : integer := 0;
    constant REG_GEM_TESTS_GBT_LOOPBACK_CTRL_LOOP_THROUGH_OH_DEFAULT : std_logic := '0';

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1010";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1011";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1012";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1020";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1021";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1022";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1030";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1031";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1032";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_2_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1040";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1041";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1042";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_3_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1050";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1051";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1052";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_4_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1060";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1061";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1062";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_5_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1070";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1071";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1072";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_6_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1080";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1081";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1082";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_7_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1090";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1091";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1092";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_8_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10a0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10a1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10a2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_9_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10b0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10b1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10b2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_10_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10c0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10c1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10c2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_11_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10d0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10d1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10d2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_12_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10e0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10e1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10e2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_13_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10f0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10f1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"10f2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_14_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1100";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1101";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1102";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_15_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1110";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1111";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1112";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_16_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1120";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1121";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1122";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_17_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1130";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1131";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1132";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_18_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1140";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1141";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1142";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_19_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1150";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1151";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1152";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_20_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1160";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1161";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1162";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_21_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1170";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1171";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1172";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_22_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1180";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1181";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1182";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_23_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1190";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1191";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1192";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_24_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11a0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11a1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11a2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_25_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11b0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11b1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11b2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_26_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11c0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11c1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11c2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_27_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11d0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11d1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11d2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_28_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11e0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11e1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11e2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_29_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11f0";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11f1";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"11f2";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_30_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1200";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1201";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1202";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_31_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1210";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1211";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1212";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_32_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1220";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1221";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1222";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_33_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1230";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1231";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1232";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_34_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1240";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1241";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1242";
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_GBT_LOOPBACK_LINK_35_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2010";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2010";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2010";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2011";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2012";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2013";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2014";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_0_TRIG1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2020";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2020";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2020";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2021";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2022";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2023";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2024";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_1_TRIG1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2030";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2030";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2030";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2031";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2032";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2033";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2034";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_2_TRIG1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2040";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2040";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2040";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2041";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2042";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2043";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2044";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_3_TRIG1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2050";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2050";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2050";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2051";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2052";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2053";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2054";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_4_TRIG1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2060";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2060";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2060";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2061";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2062";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2063";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2064";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_5_TRIG1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2070";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2070";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2070";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2071";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2072";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2073";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2074";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_6_TRIG1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2080";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2080";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2080";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2081";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2082";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2083";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2084";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_7_TRIG1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2090";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2090";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2090";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2091";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2092";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2093";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2094";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_8_TRIG1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a0";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a0";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a0";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a1";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a2";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a3";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a4";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_9_TRIG1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20b0";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20b0";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20b0";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20b1";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20b2";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20b3";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20b4";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_10_TRIG1_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_DAQ_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20c0";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_DAQ_SYNC_DONE_BIT    : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_TRIG0_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20c0";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_TRIG0_SYNC_DONE_BIT    : integer := 1;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_TRIG1_SYNC_DONE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20c0";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_TRIG1_SYNC_DONE_BIT    : integer := 2;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_MEGA_WORD_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20c1";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_MEGA_WORD_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_MEGA_WORD_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_DAQ_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20c2";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_DAQ_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_DAQ_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_TRIG0_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20c3";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_TRIG0_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_TRIG0_ERROR_CNT_LSB     : integer := 0;

    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_TRIG1_ERROR_CNT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20c4";
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_TRIG1_ERROR_CNT_MSB    : integer := 31;
    constant REG_GEM_TESTS_8b10b_LOOPBACK_LINK_11_TRIG1_ERROR_CNT_LSB     : integer := 0;


    --============================================================================
    --       >>> DAQ Module <<<    base address: 0x00700000
    --
    -- DAQ module buffers track data, builds events, analyses the data for
    -- consistency                        and ships off the events with all the
    -- needed headers and trailers to AMC13 over DAQLink
    --============================================================================

    constant REG_DAQ_NUM_REGS : integer := 244;
    constant REG_DAQ_ADDRESS_MSB : integer := 8;
    constant REG_DAQ_ADDRESS_LSB : integer := 0;
    constant REG_DAQ_CONTROL_DAQ_ENABLE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_DAQ_ENABLE_BIT    : integer := 0;
    constant REG_DAQ_CONTROL_DAQ_ENABLE_DEFAULT : std_logic := '0';

    constant REG_DAQ_CONTROL_ZERO_SUPPRESSION_EN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_ZERO_SUPPRESSION_EN_BIT    : integer := 1;
    constant REG_DAQ_CONTROL_ZERO_SUPPRESSION_EN_DEFAULT : std_logic := '0';

    constant REG_DAQ_CONTROL_DAQ_LINK_RESET_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_DAQ_LINK_RESET_BIT    : integer := 2;
    constant REG_DAQ_CONTROL_DAQ_LINK_RESET_DEFAULT : std_logic := '0';

    constant REG_DAQ_CONTROL_RESET_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_RESET_BIT    : integer := 3;
    constant REG_DAQ_CONTROL_RESET_DEFAULT : std_logic := '0';

    constant REG_DAQ_CONTROL_TTS_OVERRIDE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_TTS_OVERRIDE_MSB    : integer := 7;
    constant REG_DAQ_CONTROL_TTS_OVERRIDE_LSB     : integer := 4;
    constant REG_DAQ_CONTROL_TTS_OVERRIDE_DEFAULT : std_logic_vector(7 downto 4) := x"0";

    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"00";
    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_MSB    : integer := 31;
    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_LSB     : integer := 8;
    constant REG_DAQ_CONTROL_INPUT_ENABLE_MASK_DEFAULT : std_logic_vector(31 downto 8) := x"000001";

    constant REG_DAQ_CONTROL_DAV_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_CONTROL_DAV_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_CONTROL_DAV_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_CONTROL_DAV_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000500";

    constant REG_DAQ_CONTROL_EOE_USE_OH_EC_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_CONTROL_EOE_USE_OH_EC_BC_BIT    : integer := 24;
    constant REG_DAQ_CONTROL_EOE_USE_OH_EC_BC_DEFAULT : std_logic := '1';

    constant REG_DAQ_CONTROL_ENABLE_INPUT_AUTOKILL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"01";
    constant REG_DAQ_CONTROL_ENABLE_INPUT_AUTOKILL_BIT    : integer := 25;
    constant REG_DAQ_CONTROL_ENABLE_INPUT_AUTOKILL_DEFAULT : std_logic := '1';

    constant REG_DAQ_CONTROL_INPUT_AUTOKILL_THRESH_ADDR    : std_logic_vector(8 downto 0) := '0' & x"02";
    constant REG_DAQ_CONTROL_INPUT_AUTOKILL_THRESH_MSB    : integer := 15;
    constant REG_DAQ_CONTROL_INPUT_AUTOKILL_THRESH_LSB     : integer := 0;
    constant REG_DAQ_CONTROL_INPUT_AUTOKILL_THRESH_DEFAULT : std_logic_vector(15 downto 0) := x"0064";

    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_MSB    : integer := 23;
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_LSB     : integer := 0;
    constant REG_DAQ_EXT_CONTROL_RUN_PARAMS_DEFAULT : std_logic_vector(23 downto 0) := x"000000";

    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"10";
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_MSB    : integer := 27;
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_LSB     : integer := 24;
    constant REG_DAQ_EXT_CONTROL_RUN_TYPE_DEFAULT : std_logic_vector(27 downto 24) := x"0";

    constant REG_DAQ_STATUS_DAQ_LINK_RDY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_DAQ_LINK_RDY_BIT    : integer := 0;

    constant REG_DAQ_STATUS_DAQ_CLK_LOCKED_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_DAQ_CLK_LOCKED_BIT    : integer := 1;

    constant REG_DAQ_STATUS_TTC_RDY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_TTC_RDY_BIT    : integer := 2;

    constant REG_DAQ_STATUS_DAQ_LINK_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_DAQ_LINK_AFULL_BIT    : integer := 3;

    constant REG_DAQ_STATUS_DAQ_OUTPUT_FIFO_HAD_OVERFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_DAQ_OUTPUT_FIFO_HAD_OVERFLOW_BIT    : integer := 4;

    constant REG_DAQ_STATUS_TTC_BC0_LOCKED_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_TTC_BC0_LOCKED_BIT    : integer := 5;

    constant REG_DAQ_STATUS_L1A_FIFO_HAD_OVERFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_L1A_FIFO_HAD_OVERFLOW_BIT    : integer := 23;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_UNDERFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_UNDERFLOW_BIT    : integer := 24;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_NEAR_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_NEAR_FULL_BIT    : integer := 26;

    constant REG_DAQ_STATUS_L1A_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_L1A_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"20";
    constant REG_DAQ_STATUS_TTS_STATE_MSB    : integer := 31;
    constant REG_DAQ_STATUS_TTS_STATE_LSB     : integer := 28;

    constant REG_DAQ_STATUS_INPUT_AUTOKILL_MASK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"21";
    constant REG_DAQ_STATUS_INPUT_AUTOKILL_MASK_MSB    : integer := 23;
    constant REG_DAQ_STATUS_INPUT_AUTOKILL_MASK_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"30";
    constant REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_NOTINTABLE_ERR_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_DISPER_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"31";
    constant REG_DAQ_EXT_STATUS_DISPER_ERR_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_DISPER_ERR_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_L1AID_ADDR    : std_logic_vector(8 downto 0) := '0' & x"32";
    constant REG_DAQ_EXT_STATUS_L1AID_MSB    : integer := 23;
    constant REG_DAQ_EXT_STATUS_L1AID_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_EVT_SENT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"33";
    constant REG_DAQ_EXT_STATUS_EVT_SENT_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_EVT_SENT_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"35";
    constant REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_MSB    : integer := 23;
    constant REG_DAQ_EXT_STATUS_MAX_DAV_TIMER_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"36";
    constant REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_MSB    : integer := 23;
    constant REG_DAQ_EXT_STATUS_LAST_DAV_TIMER_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_L1A_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"37";
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_DATA_CNT_MSB    : integer := 12;
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"37";
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_DATA_CNT_MSB    : integer := 28;
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_EXT_STATUS_L1A_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"38";
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_L1A_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"38";
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_DAQ_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_EXT_STATUS_DAQ_ALMOST_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"39";
    constant REG_DAQ_EXT_STATUS_DAQ_ALMOST_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_EXT_STATUS_DAQ_ALMOST_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_EXT_STATUS_TTS_WARN_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"39";
    constant REG_DAQ_EXT_STATUS_TTS_WARN_CNT_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_TTS_WARN_CNT_LSB     : integer := 16;

    constant REG_DAQ_EXT_STATUS_DAQ_WORD_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"3a";
    constant REG_DAQ_EXT_STATUS_DAQ_WORD_RATE_MSB    : integer := 31;
    constant REG_DAQ_EXT_STATUS_DAQ_WORD_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH0_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH0_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH0_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH0_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH0_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH0_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH0_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH0_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"50";
    constant REG_DAQ_OH0_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"51";
    constant REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH0_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"52";
    constant REG_DAQ_OH0_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH0_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"53";
    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH0_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"54";
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"54";
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"55";
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH0_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"55";
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH0_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH0_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"56";
    constant REG_DAQ_OH0_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH0_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"56";
    constant REG_DAQ_OH0_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH0_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"57";
    constant REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH0_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"58";
    constant REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH0_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '0' & x"59";
    constant REG_DAQ_OH0_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH0_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"59";
    constant REG_DAQ_OH0_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH0_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH0_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '0' & x"5a";
    constant REG_DAQ_OH0_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH0_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"5b";
    constant REG_DAQ_OH0_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH0_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH0_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"5b";
    constant REG_DAQ_OH0_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH0_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH0_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"60";
    constant REG_DAQ_OH0_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"61";
    constant REG_DAQ_OH0_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"62";
    constant REG_DAQ_OH0_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"63";
    constant REG_DAQ_OH0_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"64";
    constant REG_DAQ_OH0_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"65";
    constant REG_DAQ_OH0_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH0_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"66";
    constant REG_DAQ_OH0_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH0_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH1_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH1_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH1_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH1_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH1_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH1_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH1_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH1_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"70";
    constant REG_DAQ_OH1_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"71";
    constant REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH1_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"72";
    constant REG_DAQ_OH1_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH1_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"73";
    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH1_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"74";
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"74";
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"75";
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH1_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"75";
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH1_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH1_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"76";
    constant REG_DAQ_OH1_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH1_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"76";
    constant REG_DAQ_OH1_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH1_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"77";
    constant REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH1_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"78";
    constant REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH1_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '0' & x"79";
    constant REG_DAQ_OH1_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH1_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"79";
    constant REG_DAQ_OH1_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH1_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH1_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '0' & x"7a";
    constant REG_DAQ_OH1_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH1_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"7b";
    constant REG_DAQ_OH1_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH1_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH1_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"7b";
    constant REG_DAQ_OH1_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH1_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH1_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"80";
    constant REG_DAQ_OH1_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"81";
    constant REG_DAQ_OH1_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"82";
    constant REG_DAQ_OH1_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"83";
    constant REG_DAQ_OH1_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"84";
    constant REG_DAQ_OH1_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"85";
    constant REG_DAQ_OH1_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH1_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"86";
    constant REG_DAQ_OH1_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH1_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH2_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH2_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH2_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH2_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH2_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH2_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH2_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH2_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH2_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH2_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"90";
    constant REG_DAQ_OH2_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH2_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"91";
    constant REG_DAQ_OH2_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH2_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"92";
    constant REG_DAQ_OH2_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH2_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"93";
    constant REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH2_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"94";
    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"94";
    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"95";
    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH2_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"95";
    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH2_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH2_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"96";
    constant REG_DAQ_OH2_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH2_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"96";
    constant REG_DAQ_OH2_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH2_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH2_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"97";
    constant REG_DAQ_OH2_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH2_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"98";
    constant REG_DAQ_OH2_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH2_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '0' & x"99";
    constant REG_DAQ_OH2_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH2_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"99";
    constant REG_DAQ_OH2_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH2_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH2_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '0' & x"9a";
    constant REG_DAQ_OH2_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH2_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"9b";
    constant REG_DAQ_OH2_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH2_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH2_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"9b";
    constant REG_DAQ_OH2_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH2_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH2_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a0";
    constant REG_DAQ_OH2_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a1";
    constant REG_DAQ_OH2_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a2";
    constant REG_DAQ_OH2_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a3";
    constant REG_DAQ_OH2_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a4";
    constant REG_DAQ_OH2_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a5";
    constant REG_DAQ_OH2_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH2_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"a6";
    constant REG_DAQ_OH2_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH2_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH3_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH3_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH3_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH3_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH3_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH3_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH3_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH3_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH3_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH3_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b0";
    constant REG_DAQ_OH3_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH3_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b1";
    constant REG_DAQ_OH3_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH3_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b2";
    constant REG_DAQ_OH3_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH3_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b3";
    constant REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH3_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b4";
    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b4";
    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b5";
    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH3_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b5";
    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH3_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH3_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b6";
    constant REG_DAQ_OH3_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH3_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b6";
    constant REG_DAQ_OH3_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH3_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH3_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b7";
    constant REG_DAQ_OH3_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH3_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b8";
    constant REG_DAQ_OH3_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH3_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b9";
    constant REG_DAQ_OH3_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH3_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"b9";
    constant REG_DAQ_OH3_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH3_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH3_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '0' & x"ba";
    constant REG_DAQ_OH3_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH3_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"bb";
    constant REG_DAQ_OH3_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH3_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH3_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"bb";
    constant REG_DAQ_OH3_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH3_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH3_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c0";
    constant REG_DAQ_OH3_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c1";
    constant REG_DAQ_OH3_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c2";
    constant REG_DAQ_OH3_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c3";
    constant REG_DAQ_OH3_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c4";
    constant REG_DAQ_OH3_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c5";
    constant REG_DAQ_OH3_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH3_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"c6";
    constant REG_DAQ_OH3_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH3_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH4_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH4_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH4_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH4_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH4_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH4_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH4_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH4_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH4_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH4_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d0";
    constant REG_DAQ_OH4_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH4_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d1";
    constant REG_DAQ_OH4_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH4_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d2";
    constant REG_DAQ_OH4_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH4_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d3";
    constant REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH4_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d4";
    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d4";
    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d5";
    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH4_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d5";
    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH4_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH4_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d6";
    constant REG_DAQ_OH4_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH4_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d6";
    constant REG_DAQ_OH4_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH4_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH4_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d7";
    constant REG_DAQ_OH4_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH4_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d8";
    constant REG_DAQ_OH4_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH4_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d9";
    constant REG_DAQ_OH4_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH4_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"d9";
    constant REG_DAQ_OH4_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH4_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH4_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '0' & x"da";
    constant REG_DAQ_OH4_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH4_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"db";
    constant REG_DAQ_OH4_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH4_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH4_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"db";
    constant REG_DAQ_OH4_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH4_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH4_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '0' & x"e0";
    constant REG_DAQ_OH4_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '0' & x"e1";
    constant REG_DAQ_OH4_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '0' & x"e2";
    constant REG_DAQ_OH4_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '0' & x"e3";
    constant REG_DAQ_OH4_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '0' & x"e4";
    constant REG_DAQ_OH4_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '0' & x"e5";
    constant REG_DAQ_OH4_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH4_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '0' & x"e6";
    constant REG_DAQ_OH4_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH4_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH5_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH5_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH5_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH5_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH5_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH5_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH5_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH5_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH5_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH5_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f0";
    constant REG_DAQ_OH5_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH5_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f1";
    constant REG_DAQ_OH5_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH5_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f2";
    constant REG_DAQ_OH5_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH5_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f3";
    constant REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH5_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f4";
    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f4";
    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f5";
    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH5_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f5";
    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH5_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH5_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f6";
    constant REG_DAQ_OH5_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH5_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f6";
    constant REG_DAQ_OH5_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH5_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH5_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f7";
    constant REG_DAQ_OH5_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH5_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f8";
    constant REG_DAQ_OH5_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH5_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f9";
    constant REG_DAQ_OH5_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH5_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '0' & x"f9";
    constant REG_DAQ_OH5_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH5_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH5_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '0' & x"fa";
    constant REG_DAQ_OH5_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH5_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"fb";
    constant REG_DAQ_OH5_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH5_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH5_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '0' & x"fb";
    constant REG_DAQ_OH5_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH5_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH5_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '1' & x"00";
    constant REG_DAQ_OH5_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '1' & x"01";
    constant REG_DAQ_OH5_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '1' & x"02";
    constant REG_DAQ_OH5_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '1' & x"03";
    constant REG_DAQ_OH5_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '1' & x"04";
    constant REG_DAQ_OH5_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '1' & x"05";
    constant REG_DAQ_OH5_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH5_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '1' & x"06";
    constant REG_DAQ_OH5_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH5_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH6_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH6_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH6_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH6_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH6_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH6_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH6_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH6_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH6_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH6_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"10";
    constant REG_DAQ_OH6_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH6_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"11";
    constant REG_DAQ_OH6_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH6_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"12";
    constant REG_DAQ_OH6_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH6_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"13";
    constant REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH6_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"14";
    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"14";
    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"15";
    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH6_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"15";
    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH6_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH6_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"16";
    constant REG_DAQ_OH6_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH6_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"16";
    constant REG_DAQ_OH6_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH6_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH6_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"17";
    constant REG_DAQ_OH6_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH6_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"18";
    constant REG_DAQ_OH6_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH6_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '1' & x"19";
    constant REG_DAQ_OH6_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH6_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"19";
    constant REG_DAQ_OH6_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH6_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH6_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '1' & x"1a";
    constant REG_DAQ_OH6_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH6_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"1b";
    constant REG_DAQ_OH6_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH6_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH6_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"1b";
    constant REG_DAQ_OH6_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH6_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH6_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '1' & x"20";
    constant REG_DAQ_OH6_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '1' & x"21";
    constant REG_DAQ_OH6_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '1' & x"22";
    constant REG_DAQ_OH6_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '1' & x"23";
    constant REG_DAQ_OH6_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '1' & x"24";
    constant REG_DAQ_OH6_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '1' & x"25";
    constant REG_DAQ_OH6_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH6_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '1' & x"26";
    constant REG_DAQ_OH6_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH6_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH7_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH7_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH7_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH7_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH7_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH7_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH7_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH7_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH7_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH7_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"30";
    constant REG_DAQ_OH7_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH7_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"31";
    constant REG_DAQ_OH7_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH7_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"32";
    constant REG_DAQ_OH7_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH7_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"33";
    constant REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH7_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"34";
    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"34";
    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"35";
    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH7_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"35";
    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH7_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH7_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"36";
    constant REG_DAQ_OH7_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH7_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"36";
    constant REG_DAQ_OH7_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH7_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH7_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"37";
    constant REG_DAQ_OH7_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH7_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"38";
    constant REG_DAQ_OH7_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH7_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '1' & x"39";
    constant REG_DAQ_OH7_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH7_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"39";
    constant REG_DAQ_OH7_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH7_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH7_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '1' & x"3a";
    constant REG_DAQ_OH7_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH7_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"3b";
    constant REG_DAQ_OH7_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH7_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH7_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"3b";
    constant REG_DAQ_OH7_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH7_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH7_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '1' & x"40";
    constant REG_DAQ_OH7_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '1' & x"41";
    constant REG_DAQ_OH7_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '1' & x"42";
    constant REG_DAQ_OH7_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '1' & x"43";
    constant REG_DAQ_OH7_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '1' & x"44";
    constant REG_DAQ_OH7_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '1' & x"45";
    constant REG_DAQ_OH7_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH7_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '1' & x"46";
    constant REG_DAQ_OH7_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH7_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH8_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH8_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH8_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH8_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH8_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH8_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH8_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH8_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH8_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH8_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"50";
    constant REG_DAQ_OH8_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH8_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"51";
    constant REG_DAQ_OH8_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH8_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"52";
    constant REG_DAQ_OH8_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH8_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"53";
    constant REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH8_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"54";
    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"54";
    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"55";
    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH8_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"55";
    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH8_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH8_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"56";
    constant REG_DAQ_OH8_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH8_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"56";
    constant REG_DAQ_OH8_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH8_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH8_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"57";
    constant REG_DAQ_OH8_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH8_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"58";
    constant REG_DAQ_OH8_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH8_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '1' & x"59";
    constant REG_DAQ_OH8_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH8_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"59";
    constant REG_DAQ_OH8_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH8_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH8_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '1' & x"5a";
    constant REG_DAQ_OH8_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH8_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"5b";
    constant REG_DAQ_OH8_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH8_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH8_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"5b";
    constant REG_DAQ_OH8_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH8_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH8_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '1' & x"60";
    constant REG_DAQ_OH8_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '1' & x"61";
    constant REG_DAQ_OH8_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '1' & x"62";
    constant REG_DAQ_OH8_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '1' & x"63";
    constant REG_DAQ_OH8_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '1' & x"64";
    constant REG_DAQ_OH8_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '1' & x"65";
    constant REG_DAQ_OH8_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH8_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '1' & x"66";
    constant REG_DAQ_OH8_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH8_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH9_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH9_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH9_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH9_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH9_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH9_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH9_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH9_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH9_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH9_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"70";
    constant REG_DAQ_OH9_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH9_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"71";
    constant REG_DAQ_OH9_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH9_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"72";
    constant REG_DAQ_OH9_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH9_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"73";
    constant REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH9_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"74";
    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"74";
    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"75";
    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH9_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"75";
    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH9_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH9_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"76";
    constant REG_DAQ_OH9_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH9_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"76";
    constant REG_DAQ_OH9_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH9_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH9_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"77";
    constant REG_DAQ_OH9_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH9_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"78";
    constant REG_DAQ_OH9_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH9_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '1' & x"79";
    constant REG_DAQ_OH9_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH9_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"79";
    constant REG_DAQ_OH9_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH9_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH9_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '1' & x"7a";
    constant REG_DAQ_OH9_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH9_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"7b";
    constant REG_DAQ_OH9_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH9_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH9_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"7b";
    constant REG_DAQ_OH9_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH9_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH9_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '1' & x"80";
    constant REG_DAQ_OH9_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '1' & x"81";
    constant REG_DAQ_OH9_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '1' & x"82";
    constant REG_DAQ_OH9_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '1' & x"83";
    constant REG_DAQ_OH9_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '1' & x"84";
    constant REG_DAQ_OH9_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '1' & x"85";
    constant REG_DAQ_OH9_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH9_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '1' & x"86";
    constant REG_DAQ_OH9_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH9_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH10_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH10_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH10_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH10_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH10_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH10_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH10_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH10_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH10_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH10_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"90";
    constant REG_DAQ_OH10_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH10_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"91";
    constant REG_DAQ_OH10_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH10_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"92";
    constant REG_DAQ_OH10_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH10_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"93";
    constant REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH10_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"94";
    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"94";
    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"95";
    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH10_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"95";
    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH10_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH10_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"96";
    constant REG_DAQ_OH10_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH10_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"96";
    constant REG_DAQ_OH10_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH10_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH10_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"97";
    constant REG_DAQ_OH10_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH10_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"98";
    constant REG_DAQ_OH10_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH10_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '1' & x"99";
    constant REG_DAQ_OH10_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH10_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"99";
    constant REG_DAQ_OH10_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH10_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH10_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '1' & x"9a";
    constant REG_DAQ_OH10_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH10_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"9b";
    constant REG_DAQ_OH10_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH10_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH10_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"9b";
    constant REG_DAQ_OH10_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH10_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH10_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '1' & x"a0";
    constant REG_DAQ_OH10_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '1' & x"a1";
    constant REG_DAQ_OH10_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '1' & x"a2";
    constant REG_DAQ_OH10_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '1' & x"a3";
    constant REG_DAQ_OH10_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '1' & x"a4";
    constant REG_DAQ_OH10_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '1' & x"a5";
    constant REG_DAQ_OH10_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH10_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '1' & x"a6";
    constant REG_DAQ_OH10_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH10_LASTBLOCK6_LSB     : integer := 0;

    constant REG_DAQ_OH11_STATUS_VFAT_MIXED_EC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_VFAT_MIXED_EC_BIT    : integer := 1;

    constant REG_DAQ_OH11_STATUS_VFAT_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_VFAT_MIXED_BC_BIT    : integer := 2;

    constant REG_DAQ_OH11_STATUS_OH_MIXED_BC_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_OH_MIXED_BC_BIT    : integer := 3;

    constant REG_DAQ_OH11_STATUS_VFAT_TOO_MANY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_VFAT_TOO_MANY_BIT    : integer := 4;

    constant REG_DAQ_OH11_STATUS_VFAT_SMALL_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_VFAT_SMALL_BLOCK_BIT    : integer := 5;

    constant REG_DAQ_OH11_STATUS_VFAT_LARGE_BLOCK_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_VFAT_LARGE_BLOCK_BIT    : integer := 6;

    constant REG_DAQ_OH11_STATUS_VFAT_NO_MARKER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_VFAT_NO_MARKER_BIT    : integer := 7;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_HAD_OFLOW_BIT    : integer := 8;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_HAD_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_HAD_UFLOW_BIT    : integer := 9;

    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_HAD_OFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_HAD_OFLOW_BIT    : integer := 10;

    constant REG_DAQ_OH11_STATUS_EVT_SIZE_ERR_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_EVT_SIZE_ERR_BIT    : integer := 11;

    constant REG_DAQ_OH11_STATUS_TTS_STATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_TTS_STATE_MSB    : integer := 15;
    constant REG_DAQ_OH11_STATUS_TTS_STATE_LSB     : integer := 12;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_UFLOW_BIT    : integer := 24;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_FULL_BIT    : integer := 25;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_AFULL_BIT    : integer := 26;

    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_INPUT_FIFO_IS_EMPTY_BIT    : integer := 27;

    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_UFLOW_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_UFLOW_BIT    : integer := 28;

    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_FULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_FULL_BIT    : integer := 29;

    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_AFULL_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_AFULL_BIT    : integer := 30;

    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_EMPTY_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b0";
    constant REG_DAQ_OH11_STATUS_EVENT_FIFO_IS_EMPTY_BIT    : integer := 31;

    constant REG_DAQ_OH11_COUNTERS_CORRUPT_VFAT_BLK_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b1";
    constant REG_DAQ_OH11_COUNTERS_CORRUPT_VFAT_BLK_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH11_COUNTERS_CORRUPT_VFAT_BLK_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_EVN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b2";
    constant REG_DAQ_OH11_COUNTERS_EVN_MSB    : integer := 23;
    constant REG_DAQ_OH11_COUNTERS_EVN_LSB     : integer := 0;

    constant REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b3";
    constant REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_MSB    : integer := 23;
    constant REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_LSB     : integer := 0;
    constant REG_DAQ_OH11_CONTROL_EOE_TIMEOUT_DEFAULT : std_logic_vector(23 downto 0) := x"000100";

    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b4";
    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_DATA_CNT_MSB    : integer := 11;
    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_DATA_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_DATA_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b4";
    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_DATA_CNT_MSB    : integer := 27;
    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_DATA_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b5";
    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH11_COUNTERS_INPUT_FIFO_NEAR_FULL_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b5";
    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH11_COUNTERS_EVT_FIFO_NEAR_FULL_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH11_COUNTERS_VFAT_BLOCK_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b6";
    constant REG_DAQ_OH11_COUNTERS_VFAT_BLOCK_RATE_MSB    : integer := 14;
    constant REG_DAQ_OH11_COUNTERS_VFAT_BLOCK_RATE_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_EVT_RATE_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b6";
    constant REG_DAQ_OH11_COUNTERS_EVT_RATE_MSB    : integer := 31;
    constant REG_DAQ_OH11_COUNTERS_EVT_RATE_LSB     : integer := 15;

    constant REG_DAQ_OH11_COUNTERS_MAX_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b7";
    constant REG_DAQ_OH11_COUNTERS_MAX_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH11_COUNTERS_MAX_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_LAST_EOE_TIMER_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b8";
    constant REG_DAQ_OH11_COUNTERS_LAST_EOE_TIMER_MSB    : integer := 23;
    constant REG_DAQ_OH11_COUNTERS_LAST_EOE_TIMER_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_LIVE_VFAT_WORDS_64_LAST_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b9";
    constant REG_DAQ_OH11_COUNTERS_LIVE_VFAT_WORDS_64_LAST_MSB    : integer := 11;
    constant REG_DAQ_OH11_COUNTERS_LIVE_VFAT_WORDS_64_LAST_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_LIVE_VFAT_WORDS_64_MIN_ADDR    : std_logic_vector(8 downto 0) := '1' & x"b9";
    constant REG_DAQ_OH11_COUNTERS_LIVE_VFAT_WORDS_64_MIN_MSB    : integer := 23;
    constant REG_DAQ_OH11_COUNTERS_LIVE_VFAT_WORDS_64_MIN_LSB     : integer := 12;

    constant REG_DAQ_OH11_COUNTERS_LIVE_VFAT_WORDS_64_MAX_ADDR    : std_logic_vector(8 downto 0) := '1' & x"ba";
    constant REG_DAQ_OH11_COUNTERS_LIVE_VFAT_WORDS_64_MAX_MSB    : integer := 11;
    constant REG_DAQ_OH11_COUNTERS_LIVE_VFAT_WORDS_64_MAX_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"bb";
    constant REG_DAQ_OH11_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_MSB    : integer := 15;
    constant REG_DAQ_OH11_COUNTERS_DAV_TIMEOUT_CONSEC_CNT_LSB     : integer := 0;

    constant REG_DAQ_OH11_COUNTERS_DAV_TIMEOUT_CNT_ADDR    : std_logic_vector(8 downto 0) := '1' & x"bb";
    constant REG_DAQ_OH11_COUNTERS_DAV_TIMEOUT_CNT_MSB    : integer := 31;
    constant REG_DAQ_OH11_COUNTERS_DAV_TIMEOUT_CNT_LSB     : integer := 16;

    constant REG_DAQ_OH11_LASTBLOCK0_ADDR    : std_logic_vector(8 downto 0) := '1' & x"c0";
    constant REG_DAQ_OH11_LASTBLOCK0_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK0_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK1_ADDR    : std_logic_vector(8 downto 0) := '1' & x"c1";
    constant REG_DAQ_OH11_LASTBLOCK1_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK1_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK2_ADDR    : std_logic_vector(8 downto 0) := '1' & x"c2";
    constant REG_DAQ_OH11_LASTBLOCK2_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK2_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK3_ADDR    : std_logic_vector(8 downto 0) := '1' & x"c3";
    constant REG_DAQ_OH11_LASTBLOCK3_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK3_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK4_ADDR    : std_logic_vector(8 downto 0) := '1' & x"c4";
    constant REG_DAQ_OH11_LASTBLOCK4_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK4_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK5_ADDR    : std_logic_vector(8 downto 0) := '1' & x"c5";
    constant REG_DAQ_OH11_LASTBLOCK5_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK5_LSB     : integer := 0;

    constant REG_DAQ_OH11_LASTBLOCK6_ADDR    : std_logic_vector(8 downto 0) := '1' & x"c6";
    constant REG_DAQ_OH11_LASTBLOCK6_MSB    : integer := 31;
    constant REG_DAQ_OH11_LASTBLOCK6_LSB     : integer := 0;


    --============================================================================
    --       >>> OH_LINKS Module <<<    base address: 0x00600000
    --
    -- OH Link monitoring registers
    --============================================================================

    constant REG_OH_LINKS_NUM_REGS : integer := 193;
    constant REG_OH_LINKS_ADDRESS_MSB : integer := 12;
    constant REG_OH_LINKS_ADDRESS_LSB : integer := 0;
    constant REG_OH_LINKS_CTRL_CNT_RESET_ADDR    : std_logic_vector(12 downto 0) := '0' & x"000";
    constant REG_OH_LINKS_CTRL_CNT_RESET_MSB    : integer := 31;
    constant REG_OH_LINKS_CTRL_CNT_RESET_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"100";
    constant REG_OH_LINKS_OH0_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"101";
    constant REG_OH_LINKS_OH0_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"102";
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"103";
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"104";
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"105";
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"106";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"107";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"108";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"109";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10a";
    constant REG_OH_LINKS_OH0_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10b";
    constant REG_OH_LINKS_OH0_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10c";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10d";
    constant REG_OH_LINKS_OH0_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10e";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH0_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"10f";
    constant REG_OH_LINKS_OH0_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH0_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"200";
    constant REG_OH_LINKS_OH1_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"201";
    constant REG_OH_LINKS_OH1_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"202";
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"203";
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"204";
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"205";
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"206";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"207";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"208";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"209";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20a";
    constant REG_OH_LINKS_OH1_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20b";
    constant REG_OH_LINKS_OH1_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20c";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20d";
    constant REG_OH_LINKS_OH1_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20e";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH1_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"20f";
    constant REG_OH_LINKS_OH1_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH1_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"300";
    constant REG_OH_LINKS_OH2_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"301";
    constant REG_OH_LINKS_OH2_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"302";
    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"303";
    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"304";
    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"305";
    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"306";
    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"307";
    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"308";
    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"309";
    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30a";
    constant REG_OH_LINKS_OH2_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30b";
    constant REG_OH_LINKS_OH2_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30c";
    constant REG_OH_LINKS_OH2_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30d";
    constant REG_OH_LINKS_OH2_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30e";
    constant REG_OH_LINKS_OH2_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH2_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"30f";
    constant REG_OH_LINKS_OH2_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH2_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"400";
    constant REG_OH_LINKS_OH3_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"401";
    constant REG_OH_LINKS_OH3_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"402";
    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"403";
    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"404";
    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"405";
    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"406";
    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"407";
    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"408";
    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"409";
    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40a";
    constant REG_OH_LINKS_OH3_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40b";
    constant REG_OH_LINKS_OH3_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40c";
    constant REG_OH_LINKS_OH3_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40d";
    constant REG_OH_LINKS_OH3_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40e";
    constant REG_OH_LINKS_OH3_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH3_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"40f";
    constant REG_OH_LINKS_OH3_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH3_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"500";
    constant REG_OH_LINKS_OH4_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"501";
    constant REG_OH_LINKS_OH4_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"502";
    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"503";
    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"504";
    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"505";
    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"506";
    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"507";
    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"508";
    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"509";
    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50a";
    constant REG_OH_LINKS_OH4_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50b";
    constant REG_OH_LINKS_OH4_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50c";
    constant REG_OH_LINKS_OH4_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50d";
    constant REG_OH_LINKS_OH4_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50e";
    constant REG_OH_LINKS_OH4_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH4_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"50f";
    constant REG_OH_LINKS_OH4_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH4_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"600";
    constant REG_OH_LINKS_OH5_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"601";
    constant REG_OH_LINKS_OH5_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"602";
    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"603";
    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"604";
    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"605";
    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"606";
    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"607";
    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"608";
    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"609";
    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60a";
    constant REG_OH_LINKS_OH5_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60b";
    constant REG_OH_LINKS_OH5_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60c";
    constant REG_OH_LINKS_OH5_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60d";
    constant REG_OH_LINKS_OH5_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60e";
    constant REG_OH_LINKS_OH5_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH5_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"60f";
    constant REG_OH_LINKS_OH5_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH5_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"700";
    constant REG_OH_LINKS_OH6_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"701";
    constant REG_OH_LINKS_OH6_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"702";
    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"703";
    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"704";
    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"705";
    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"706";
    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"707";
    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"708";
    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"709";
    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70a";
    constant REG_OH_LINKS_OH6_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70b";
    constant REG_OH_LINKS_OH6_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70c";
    constant REG_OH_LINKS_OH6_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70d";
    constant REG_OH_LINKS_OH6_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70e";
    constant REG_OH_LINKS_OH6_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH6_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"70f";
    constant REG_OH_LINKS_OH6_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH6_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"800";
    constant REG_OH_LINKS_OH7_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"801";
    constant REG_OH_LINKS_OH7_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"802";
    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"803";
    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"804";
    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"805";
    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"806";
    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"807";
    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"808";
    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"809";
    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80a";
    constant REG_OH_LINKS_OH7_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80b";
    constant REG_OH_LINKS_OH7_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80c";
    constant REG_OH_LINKS_OH7_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80d";
    constant REG_OH_LINKS_OH7_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80e";
    constant REG_OH_LINKS_OH7_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH7_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"80f";
    constant REG_OH_LINKS_OH7_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH7_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"900";
    constant REG_OH_LINKS_OH8_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"901";
    constant REG_OH_LINKS_OH8_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"902";
    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"903";
    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"904";
    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"905";
    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"906";
    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"907";
    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"908";
    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"909";
    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90a";
    constant REG_OH_LINKS_OH8_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90b";
    constant REG_OH_LINKS_OH8_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90c";
    constant REG_OH_LINKS_OH8_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90d";
    constant REG_OH_LINKS_OH8_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90e";
    constant REG_OH_LINKS_OH8_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH8_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"90f";
    constant REG_OH_LINKS_OH8_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH8_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a00";
    constant REG_OH_LINKS_OH9_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a01";
    constant REG_OH_LINKS_OH9_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a02";
    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a03";
    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a04";
    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a05";
    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a06";
    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a07";
    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a08";
    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a09";
    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0a";
    constant REG_OH_LINKS_OH9_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0b";
    constant REG_OH_LINKS_OH9_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0c";
    constant REG_OH_LINKS_OH9_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0d";
    constant REG_OH_LINKS_OH9_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0e";
    constant REG_OH_LINKS_OH9_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH9_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"a0f";
    constant REG_OH_LINKS_OH9_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH9_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b00";
    constant REG_OH_LINKS_OH10_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b01";
    constant REG_OH_LINKS_OH10_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b02";
    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b03";
    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b04";
    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b05";
    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b06";
    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b07";
    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b08";
    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b09";
    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0a";
    constant REG_OH_LINKS_OH10_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0b";
    constant REG_OH_LINKS_OH10_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0c";
    constant REG_OH_LINKS_OH10_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0d";
    constant REG_OH_LINKS_OH10_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0e";
    constant REG_OH_LINKS_OH10_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH10_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"b0f";
    constant REG_OH_LINKS_OH10_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH10_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_ERROR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c00";
    constant REG_OH_LINKS_OH11_TRACK_LINK_ERROR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_ERROR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_VFAT_BLOCK_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c01";
    constant REG_OH_LINKS_OH11_VFAT_BLOCK_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_VFAT_BLOCK_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c02";
    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c03";
    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_TX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c04";
    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c05";
    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c06";
    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c07";
    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG0_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_OVF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c08";
    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_OVF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_OVF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_UNF_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c09";
    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_UNF_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG1_LINK_RX_SYNC_UNF_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0a";
    constant REG_OH_LINKS_OH11_TRACK_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRACK_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0b";
    constant REG_OH_LINKS_OH11_TRACK_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRACK_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG0_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0c";
    constant REG_OH_LINKS_OH11_TRIG0_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG0_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG0_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0d";
    constant REG_OH_LINKS_OH11_TRIG0_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG0_LINK_DISPERR_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG1_LINK_NOT_IN_TABLE_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0e";
    constant REG_OH_LINKS_OH11_TRIG1_LINK_NOT_IN_TABLE_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG1_LINK_NOT_IN_TABLE_CNT_LSB     : integer := 0;

    constant REG_OH_LINKS_OH11_TRIG1_LINK_DISPERR_CNT_ADDR    : std_logic_vector(12 downto 0) := '0' & x"c0f";
    constant REG_OH_LINKS_OH11_TRIG1_LINK_DISPERR_CNT_MSB    : integer := 31;
    constant REG_OH_LINKS_OH11_TRIG1_LINK_DISPERR_CNT_LSB     : integer := 0;


    --============================================================================
    --       >>> SLOW_CONTROL Module <<<    base address: 0x00b00000
    --
    -- This module is handling slow control (mainly OH SCA and OH GBTx IC related
    -- communication)
    --============================================================================

    constant REG_SLOW_CONTROL_NUM_REGS : integer := 189;
    constant REG_SLOW_CONTROL_ADDRESS_MSB : integer := 16;
    constant REG_SLOW_CONTROL_ADDRESS_LSB : integer := 0;
    constant REG_SLOW_CONTROL_SCA_CTRL_MODULE_RESET_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0000";
    constant REG_SLOW_CONTROL_SCA_CTRL_MODULE_RESET_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_CTRL_MODULE_RESET_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_CTRL_OH_FPGA_HARD_RESET_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0001";
    constant REG_SLOW_CONTROL_SCA_CTRL_OH_FPGA_HARD_RESET_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_CTRL_OH_FPGA_HARD_RESET_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_CTRL_TTC_HARD_RESET_EN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0002";
    constant REG_SLOW_CONTROL_SCA_CTRL_TTC_HARD_RESET_EN_BIT    : integer := 0;
    constant REG_SLOW_CONTROL_SCA_CTRL_TTC_HARD_RESET_EN_DEFAULT : std_logic := '0';

    constant REG_SLOW_CONTROL_SCA_STATUS_READY_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0100";
    constant REG_SLOW_CONTROL_SCA_STATUS_READY_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_STATUS_READY_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_CRITICAL_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0101";
    constant REG_SLOW_CONTROL_SCA_STATUS_CRITICAL_ERROR_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_STATUS_CRITICAL_ERROR_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0102";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH0_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0103";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH1_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH1_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0104";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH2_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0105";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH3_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH3_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0106";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH4_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0107";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH5_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0108";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH6_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"0109";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH7_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH7_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"010a";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH8_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"010b";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH9_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH9_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH10_ADDR    : std_logic_vector(16 downto 0) := '0' & x"010c";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH10_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH10_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH11_ADDR    : std_logic_vector(16 downto 0) := '0' & x"010d";
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH11_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_STATUS_NOT_READY_CNT_OH11_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_LINK_ENABLE_MASK_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1000";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_LINK_ENABLE_MASK_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_LINK_ENABLE_MASK_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_LINK_ENABLE_MASK_DEFAULT : std_logic_vector(31 downto 0) := x"00000000";

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1001";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_CHANNEL_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_CHANNEL_DEFAULT : std_logic_vector(7 downto 0) := x"00";

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_COMMAND_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1001";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_COMMAND_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_COMMAND_LSB     : integer := 8;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_COMMAND_DEFAULT : std_logic_vector(15 downto 8) := x"00";

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1001";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_LENGTH_LSB     : integer := 16;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_LENGTH_DEFAULT : std_logic_vector(23 downto 16) := x"00";

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1002";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_DATA_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_DATA_DEFAULT : std_logic_vector(31 downto 0) := x"00000000";

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_EXECUTE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1003";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_EXECUTE_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_CMD_SCA_CMD_EXECUTE_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1004";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1004";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1004";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1005";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH0_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1006";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1006";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1006";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1007";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH1_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1008";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1008";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1008";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1009";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH2_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100a";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100a";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100a";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100b";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH3_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100c";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100c";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100c";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100d";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH4_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100e";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100e";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100e";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"100f";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH5_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1010";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1010";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1010";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1011";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH6_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1012";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1012";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1012";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1013";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH7_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1014";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1014";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1014";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1015";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH8_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1016";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1016";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1016";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1017";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH9_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1018";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1018";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1018";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"1019";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH10_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_CHANNEL_ADDR    : std_logic_vector(16 downto 0) := '0' & x"101a";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_CHANNEL_MSB    : integer := 7;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_CHANNEL_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_ERROR_ADDR    : std_logic_vector(16 downto 0) := '0' & x"101a";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_ERROR_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_ERROR_LSB     : integer := 8;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '0' & x"101a";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_LENGTH_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_LENGTH_LSB     : integer := 16;

    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_DATA_ADDR    : std_logic_vector(16 downto 0) := '0' & x"101b";
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_MANUAL_CONTROL_SCA_REPLY_OH11_SCA_RPY_DATA_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_MONITORING_OFF_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2000";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_MONITORING_OFF_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_MONITORING_OFF_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_MONITORING_OFF_DEFAULT : std_logic_vector(31 downto 0) := x"ffffffff";

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2001";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2001";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2002";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2002";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2003";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2003";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2004";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2004";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2005";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2005";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2006";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2006";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2007";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2007";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2008";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2008";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2009";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2009";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"200a";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"200a";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH0_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2010";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2010";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2011";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2011";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2012";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2012";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2013";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2013";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2014";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2014";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2015";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2015";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2016";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2016";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2017";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2017";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2018";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2018";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2019";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2019";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH1_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"201f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"201f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2020";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2020";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2021";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2021";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2022";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2022";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2023";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2023";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2024";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2024";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2025";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2025";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2026";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2026";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2027";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2027";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2028";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2028";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH2_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"202e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"202e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"202f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"202f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2030";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2030";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2031";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2031";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2032";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2032";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2033";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2033";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2034";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2034";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2035";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2035";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2036";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2036";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2037";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2037";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH3_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"203d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"203d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"203e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"203e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"203f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"203f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2040";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2040";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2041";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2041";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2042";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2042";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2043";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2043";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2044";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2044";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2045";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2045";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2046";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2046";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH4_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"204c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"204c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"204d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"204d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"204e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"204e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"204f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"204f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2050";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2050";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2051";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2051";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2052";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2052";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2053";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2053";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2054";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2054";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2055";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2055";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH5_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"205b";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"205b";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"205c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"205c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"205d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"205d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"205e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"205e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"205f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"205f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2060";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2060";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2061";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2061";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2062";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2062";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2063";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2063";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2064";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2064";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH6_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206a";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206a";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206b";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206b";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"206f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2070";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2070";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2071";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2071";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2072";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2072";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2073";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2073";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH7_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2079";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2079";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207a";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207a";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207b";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207b";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"207f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2080";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2080";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2081";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2081";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2082";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2082";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH8_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2088";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2088";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2089";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2089";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208a";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208a";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208b";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208b";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"208f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2090";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2090";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2091";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2091";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH9_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2097";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2097";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2098";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2098";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2099";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2099";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209a";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209a";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209b";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209b";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209c";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209d";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209e";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"209f";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a0";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a0";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH10_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_AVCCN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a6";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_AVCCN_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_AVCCN_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_AVTTN_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a6";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_AVTTN_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_AVTTN_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V0_INT_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a7";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V0_INT_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V0_INT_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V8F_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a7";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V8F_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V8F_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a8";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V5_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_2V5_IO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a8";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_2V5_IO_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_2V5_IO_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_3V0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a9";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_3V0_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_3V0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20a9";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V8_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_1V8_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_VTRX_RSSI2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20aa";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_VTRX_RSSI2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_VTRX_RSSI2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_VTRX_RSSI1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20aa";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_VTRX_RSSI1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_VTRX_RSSI1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_SCA_TEMP_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20ab";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_SCA_TEMP_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_SCA_TEMP_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20ab";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP1_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP1_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20ac";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP2_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20ac";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP3_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP3_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20ad";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP4_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20ad";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP5_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP5_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20ae";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP6_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20ae";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP7_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP7_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20af";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP8_MSB    : integer := 11;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"20af";
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP9_MSB    : integer := 23;
    constant REG_SLOW_CONTROL_SCA_ADC_MONITORING_OH11_BOARD_TEMP9_LSB     : integer := 12;

    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_ENABLE_MASK_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2500";
    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_ENABLE_MASK_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_ENABLE_MASK_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_ENABLE_MASK_DEFAULT : std_logic_vector(31 downto 0) := x"00000000";

    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_SHIFT_MSB_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2501";
    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_SHIFT_MSB_BIT    : integer := 1;
    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_SHIFT_MSB_DEFAULT : std_logic := '0';

    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_EXEC_ON_EVERY_TDO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2501";
    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_EXEC_ON_EVERY_TDO_BIT    : integer := 2;
    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_EXEC_ON_EVERY_TDO_DEFAULT : std_logic := '0';

    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_NO_SCA_LENGTH_UPDATE_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2501";
    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_NO_SCA_LENGTH_UPDATE_BIT    : integer := 3;
    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_NO_SCA_LENGTH_UPDATE_DEFAULT : std_logic := '0';

    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_SHIFT_TDO_ASYNC_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2501";
    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_SHIFT_TDO_ASYNC_BIT    : integer := 4;
    constant REG_SLOW_CONTROL_SCA_JTAG_CTRL_EXPERT_SHIFT_TDO_ASYNC_DEFAULT : std_logic := '0';

    constant REG_SLOW_CONTROL_SCA_JTAG_NUM_BITS_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2502";
    constant REG_SLOW_CONTROL_SCA_JTAG_NUM_BITS_MSB    : integer := 6;
    constant REG_SLOW_CONTROL_SCA_JTAG_NUM_BITS_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_SCA_JTAG_NUM_BITS_DEFAULT : std_logic_vector(6 downto 0) := "000" & x"0";

    constant REG_SLOW_CONTROL_SCA_JTAG_TMS_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2503";
    constant REG_SLOW_CONTROL_SCA_JTAG_TMS_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TMS_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_SCA_JTAG_TMS_DEFAULT : std_logic_vector(31 downto 0) := x"00000000";

    constant REG_SLOW_CONTROL_SCA_JTAG_TDO_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2504";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDO_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDO_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDO_DEFAULT : std_logic_vector(31 downto 0) := x"00000000";

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH0_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2505";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH0_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH0_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH1_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2506";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH1_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH1_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH2_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2507";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH2_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH2_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH3_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2508";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH3_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH3_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH4_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2509";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH4_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH4_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH5_ADDR    : std_logic_vector(16 downto 0) := '0' & x"250a";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH5_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH5_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH6_ADDR    : std_logic_vector(16 downto 0) := '0' & x"250b";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH6_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH6_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH7_ADDR    : std_logic_vector(16 downto 0) := '0' & x"250c";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH7_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH7_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH8_ADDR    : std_logic_vector(16 downto 0) := '0' & x"250d";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH8_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH8_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH9_ADDR    : std_logic_vector(16 downto 0) := '0' & x"250e";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH9_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH9_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH10_ADDR    : std_logic_vector(16 downto 0) := '0' & x"250f";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH10_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH10_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH11_ADDR    : std_logic_vector(16 downto 0) := '0' & x"2510";
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH11_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_SCA_JTAG_TDI_OH11_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_IC_ADDRESS_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0000";
    constant REG_SLOW_CONTROL_IC_ADDRESS_MSB    : integer := 15;
    constant REG_SLOW_CONTROL_IC_ADDRESS_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_IC_ADDRESS_DEFAULT : std_logic_vector(15 downto 0) := x"0000";

    constant REG_SLOW_CONTROL_IC_READ_WRITE_LENGTH_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0001";
    constant REG_SLOW_CONTROL_IC_READ_WRITE_LENGTH_MSB    : integer := 2;
    constant REG_SLOW_CONTROL_IC_READ_WRITE_LENGTH_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_IC_READ_WRITE_LENGTH_DEFAULT : std_logic_vector(2 downto 0) := "001";

    constant REG_SLOW_CONTROL_IC_WRITE_DATA_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0002";
    constant REG_SLOW_CONTROL_IC_WRITE_DATA_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_IC_WRITE_DATA_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_IC_WRITE_DATA_DEFAULT : std_logic_vector(31 downto 0) := x"00000000";

    constant REG_SLOW_CONTROL_IC_EXECUTE_WRITE_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0003";
    constant REG_SLOW_CONTROL_IC_EXECUTE_WRITE_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_IC_EXECUTE_WRITE_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_IC_EXECUTE_READ_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0004";
    constant REG_SLOW_CONTROL_IC_EXECUTE_READ_MSB    : integer := 31;
    constant REG_SLOW_CONTROL_IC_EXECUTE_READ_LSB     : integer := 0;

    constant REG_SLOW_CONTROL_IC_GBTX_I2C_ADDR_ADDR    : std_logic_vector(16 downto 0) := '1' & x"0005";
    constant REG_SLOW_CONTROL_IC_GBTX_I2C_ADDR_MSB    : integer := 3;
    constant REG_SLOW_CONTROL_IC_GBTX_I2C_ADDR_LSB     : integer := 0;
    constant REG_SLOW_CONTROL_IC_GBTX_I2C_ADDR_DEFAULT : std_logic_vector(3 downto 0) := x"1";


end registers;
