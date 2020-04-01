library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity dmdt_clock_gen is
port 
(
    rst_mmcm1_i      : in std_logic;
    rst_mmcm2_i      : in std_logic;
    refclk_i         : in std_logic;
    dmdt_clk_o       : out std_logic;
    mmcm1_locked_o   : out std_logic;
    mmcm2_locked_o   : out std_logic
);
end dmdt_clock_gen;


architecture arch of dmdt_clock_gen is

signal clk_40_080     : std_logic;
--signal clk_39_997     : std_logic;

begin

--=============================--
mmcm1: entity work.phase_mon_mmcm_1
--=============================--
port map
( 
    clk_i_40       => refclk_i, 
    clk_o_40_08    => clk_40_080,
    reset          => rst_mmcm1_i, 
    locked         => mmcm1_locked_o
);
--=============================--



--=============================--
mmcm2: entity work.phase_mon_mmcm_2
--=============================--
port map
( 
    clk_i_40_08    => clk_40_080, 
    clk_o_39_997   => dmdt_clk_o, --clk_39_997
    reset          => rst_mmcm2_i, 
    locked         => mmcm2_locked_o
);
--=============================--



end architecture;