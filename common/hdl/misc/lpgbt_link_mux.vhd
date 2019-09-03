------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    2019-08-29
-- Module Name:    LPGBT_LINK_MUX
-- Description:    This module is used to direct the LpGBT links either to the VFATs (standard operation) or to the GEM_TESTS module 
------------------------------------------------------------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gem_pkg.all;

entity lpgbt_link_mux is
    generic(
        g_NUM_OF_OHs                : integer;
        g_NUM_GBTS_PER_OH           : integer
    );
    port(
        -- clock
        gbt_frame_clk_i             : in  std_logic;
        
        -- links
        gbt_rx_data_arr_i           : in  t_lpgbt_rx_frame_array(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        gbt_tx_data_arr_o           : out t_lpgbt_tx_frame_array(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        gbt_link_status_arr_i       : in  t_gbt_link_status_arr(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        
        -- elinks
        gbt_ic_tx_data_arr_i        : in  t_std2_array(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        gbt_ic_rx_data_arr_o        : out t_std2_array(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);

        vfat3_tx_data_arr_i         : in  t_vfat3_elinks_arr(g_NUM_OF_OHs - 1 downto 0);
        vfat3_rx_data_arr_o         : out t_vfat3_elinks_arr(g_NUM_OF_OHs - 1 downto 0);

        gbt_ready_arr_o             : out std_logic_vector(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        vfat3_gbt_ready_arr_o       : out t_std24_array(g_NUM_OF_OHs - 1 downto 0)
    );
end lpgbt_link_mux;

architecture lpgbt_link_mux_arch of lpgbt_link_mux is

    type t_gbt_idx_array is array(integer range 0 to 23) of integer range 0 to g_NUM_GBTS_PER_OH - 1;
    constant VFAT_TO_GBT_MAP_PIZZA_POS1            : t_gbt_idx_array := (1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); 
    constant VFAT_TO_GBT_MAP_PIZZA_POS2            : t_gbt_idx_array := (0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); 

    signal gbt_rx_ready_arr             : std_logic_vector((g_NUM_OF_OHs * g_NUM_GBTS_PER_OH) - 1 downto 0);

begin

    gbt_ready_arr_o <= gbt_rx_ready_arr;
     
    g_ohs : for i in 0 to g_NUM_OF_OHs - 1 generate

        gbt_rx_ready_arr(i * 2 + 0) <= gbt_link_status_arr_i(i * 2 + 0).gbt_rx_ready;
        gbt_rx_ready_arr(i * 2 + 1) <= gbt_link_status_arr_i(i * 2 + 1).gbt_rx_ready;

        --------- RX ---------
        gbt_ic_rx_data_arr_o(i * 2 + 0) <= gbt_rx_data_arr_i(i * 2 + 0).rx_ic_data;
        gbt_ic_rx_data_arr_o(i * 2 + 1) <= gbt_rx_data_arr_i(i * 2 + 1).rx_ic_data;

        gbt_rx_ready_arr(i * 2 + 0) <= gbt_link_status_arr_i(i * 2 + 0).gbt_rx_ready;
        gbt_rx_ready_arr(i * 2 + 1) <= gbt_link_status_arr_i(i * 2 + 1).gbt_rx_ready;

        g_vfat_gbt_ready: for vfat in 0 to 23 generate
            g_ready_pizza_pos1 : if i mod 2 = 0 generate
                vfat3_gbt_ready_arr_o(i)(vfat) <= gbt_rx_ready_arr(i * 2 + VFAT_TO_GBT_MAP_PIZZA_POS1(vfat));
            end generate;
            g_ready_pizza_pos2 : if i mod 2 /= 0 generate
                vfat3_gbt_ready_arr_o(i)(vfat) <= gbt_rx_ready_arr(i * 2 + VFAT_TO_GBT_MAP_PIZZA_POS2(vfat));
            end generate;
        end generate;

        vfat3_rx_data_arr_o(i)(23)  <= (others => '0');
        vfat3_rx_data_arr_o(i)(22)  <= (others => '0');
        vfat3_rx_data_arr_o(i)(21)  <= (others => '0');
        vfat3_rx_data_arr_o(i)(20)  <= (others => '0');
        vfat3_rx_data_arr_o(i)(19)  <= (others => '0');
        vfat3_rx_data_arr_o(i)(18)  <= (others => '0');
        vfat3_rx_data_arr_o(i)(17)  <= (others => '0');
        vfat3_rx_data_arr_o(i)(16)  <= (others => '0');
        vfat3_rx_data_arr_o(i)(15)  <= (others => '0');
        vfat3_rx_data_arr_o(i)(14)  <= (others => '0');
        vfat3_rx_data_arr_o(i)(13) <= (others => '0');
        vfat3_rx_data_arr_o(i)(12) <= (others => '0');
        vfat3_rx_data_arr_o(i)(11) <= (others => '0');
        vfat3_rx_data_arr_o(i)(10) <= (others => '0');
        vfat3_rx_data_arr_o(i)(9) <= (others => '0');
        vfat3_rx_data_arr_o(i)(8) <= (others => '0');
        vfat3_rx_data_arr_o(i)(7) <= (others => '0');
        vfat3_rx_data_arr_o(i)(6) <= (others => '0');
        
        g_rx_pizza_pos1 : if i mod 2 = 0 generate 
            vfat3_rx_data_arr_o(i)(5) <= gbt_rx_data_arr_i(i * 2 + 0).rx_data(207 downto 200);
            vfat3_rx_data_arr_o(i)(4) <= gbt_rx_data_arr_i(i * 2 + 1).rx_data(223 downto 216);
            vfat3_rx_data_arr_o(i)(3) <= gbt_rx_data_arr_i(i * 2 + 0).rx_data(31 downto 24);
            vfat3_rx_data_arr_o(i)(2) <= gbt_rx_data_arr_i(i * 2 + 1).rx_data(95 downto 88);
            vfat3_rx_data_arr_o(i)(1) <= gbt_rx_data_arr_i(i * 2 + 1).rx_data(199 downto 192);
            vfat3_rx_data_arr_o(i)(0) <= gbt_rx_data_arr_i(i * 2 + 1).rx_data(55 downto 48);
        end generate;

        g_rx_pizza_pos2 : if i mod 2 /= 0 generate 
            vfat3_rx_data_arr_o(i)(5) <= gbt_rx_data_arr_i(i * 2 + 1).rx_data(143 downto 136);
            vfat3_rx_data_arr_o(i)(4) <= gbt_rx_data_arr_i(i * 2 + 1).rx_data(31 downto 24);
            vfat3_rx_data_arr_o(i)(3) <= gbt_rx_data_arr_i(i * 2 + 1).rx_data(127 downto 120);
            vfat3_rx_data_arr_o(i)(2) <= gbt_rx_data_arr_i(i * 2 + 1).rx_data(151 downto 144);
            vfat3_rx_data_arr_o(i)(1) <= gbt_rx_data_arr_i(i * 2 + 0).rx_data(135 downto 128);
            vfat3_rx_data_arr_o(i)(0) <= gbt_rx_data_arr_i(i * 2 + 0).rx_data(55 downto 48);
        end generate;

        --------- TX ---------
        gbt_tx_data_arr_o(i * 2 + 0).tx_ec_data <= (others => '0');
        gbt_tx_data_arr_o(i * 2 + 1).tx_ec_data <= (others => '0');
        
        gbt_tx_data_arr_o(i * 2 + 0).tx_ic_data <= gbt_ic_tx_data_arr_i(i * 2 + 0);
        gbt_tx_data_arr_o(i * 2 + 1).tx_ic_data <= gbt_ic_tx_data_arr_i(i * 2 + 1);
        
--        g_tx_pizza_pos1 : if i mod 2 = 0 generate 
--            gbt_tx_data_arr_o(i * 2 + 0).tx_data(31 downto 24) <= (others => '0');
--            gbt_tx_data_arr_o(i * 2 + 0).tx_data(23 downto 16) <= vfat3_tx_data_arr_i(i)(4); -- this also covers position 5
--            gbt_tx_data_arr_o(i * 2 + 0).tx_data(15 downto 8) <= vfat3_tx_data_arr_i(i)(3); -- this also covers position 1
--            gbt_tx_data_arr_o(i * 2 + 0).tx_data(7 downto 0) <= vfat3_tx_data_arr_i(i)(2); -- this also covers position 0
--        end generate;

--        g_tx_pizza_pos2 : if i mod 2 /= 0 generate 
            gbt_tx_data_arr_o(i * 2 + 0).tx_data(31 downto 24) <= (others => '0');
            gbt_tx_data_arr_o(i * 2 + 0).tx_data(23 downto 16) <= vfat3_tx_data_arr_i(i)(3); -- this also covers position 1
            gbt_tx_data_arr_o(i * 2 + 0).tx_data(15 downto 8) <= vfat3_tx_data_arr_i(i)(0); -- this also covers position 2
            gbt_tx_data_arr_o(i * 2 + 0).tx_data(7 downto 0) <= vfat3_tx_data_arr_i(i)(5); -- this also covers position 4

            gbt_tx_data_arr_o(i * 2 + 1).tx_data(31 downto 24) <= (others => '0');
            gbt_tx_data_arr_o(i * 2 + 1).tx_data(23 downto 16) <= vfat3_tx_data_arr_i(i)(3); -- this also covers position 1
            gbt_tx_data_arr_o(i * 2 + 1).tx_data(15 downto 8) <= vfat3_tx_data_arr_i(i)(0); -- this also covers position 2
            gbt_tx_data_arr_o(i * 2 + 1).tx_data(7 downto 0) <= vfat3_tx_data_arr_i(i)(5); -- this also covers position 4
--        end generate;


    end generate;

end lpgbt_link_mux_arch;