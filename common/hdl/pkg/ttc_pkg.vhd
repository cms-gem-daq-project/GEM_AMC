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
        clk_160             : std_logic;
        clk_320             : std_logic;
        clk_gbt_mgt_usrclk  : std_logic;
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
        reset_local      : std_logic;
        mmcm_reset       : std_logic;
        mmcm_phase_shift : std_logic;
        cnt_reset        : std_logic;        
        l1a_enable       : std_logic;
        calib_mode       : std_logic;
        calib_l1a_delay  : std_logic_vector(11 downto 0);
    end record;

    type t_bc0_status is record
        unlocked_cnt : std_logic_vector(15 downto 0);
        udf_cnt      : std_logic_vector(15 downto 0);
        ovf_cnt      : std_logic_vector(15 downto 0);
        locked       : std_logic;
        err          : std_logic;
    end record;

    type t_ttc_status is record
        mmcm_locked : std_logic;
        bc0_status  : t_bc0_status;
        single_err  : std_logic_vector(15 downto 0);
        double_err  : std_logic_vector(15 downto 0);
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
