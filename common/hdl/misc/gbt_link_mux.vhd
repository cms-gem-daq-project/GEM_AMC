------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company: TAMU
-- Engineer: Evaldas Juska (evaldas.juska@cern.ch, evka85@gmail.com)
-- 
-- Create Date:    20:38:00 2016-08-30
-- Module Name:    GBT_LINK_MUX
-- Description:    This module is used to direct the GBT links either to the OH modules (standard operation) or to the GEM_TESTS module 
------------------------------------------------------------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gem_pkg.all;

entity gbt_link_mux is
    generic(
        g_NUM_OF_OHs                : integer;
        g_NUM_GBTS_PER_OH           : integer
    );
    port(
        -- clock
        gbt_frame_clk_i             : in  std_logic;
        
        -- links
        gbt_rx_data_arr_i           : in  t_gbt_frame_array(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        gbt_tx_data_arr_o           : out t_gbt_frame_array(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        gbt_link_status_arr_i       : in  t_gbt_link_status_arr(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        
        -- configure
        link_test_mode_i            : in  std_logic;
        use_v3b_mapping_i           : in  std_logic; -- if set high, then will use the v3b elink assignments for the OH FPGA communication, otherwise v3a

        -- real elinks
        sca_tx_data_arr_i           : in  t_std2_array(g_NUM_OF_OHs - 1 downto 0);
        sca_rx_data_arr_o           : out t_std2_array(g_NUM_OF_OHs - 1 downto 0);

        gbt_ic_tx_data_arr_i        : in  t_std2_array(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        gbt_ic_rx_data_arr_o        : out t_std2_array(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);

        promless_tx_data_i          : in  std_logic_vector(15 downto 0);

        oh_fpga_tx_data_arr_i       : in  t_std8_array(g_NUM_OF_OHs - 1 downto 0);
        oh_fpga_rx_data_arr_o       : out t_std8_array(g_NUM_OF_OHs - 1 downto 0);

        vfat3_tx_data_arr_i         : in  t_vfat3_elinks_arr(g_NUM_OF_OHs - 1 downto 0);
        vfat3_rx_data_arr_o         : out t_vfat3_elinks_arr(g_NUM_OF_OHs - 1 downto 0);

        gbt_ready_arr_o             : out std_logic_vector(g_NUM_OF_OHs * g_NUM_GBTS_PER_OH - 1 downto 0);
        vfat3_gbt_ready_arr_o       : out t_std24_array(g_NUM_OF_OHs - 1 downto 0);

        -- to tests module
        tst_gbt_rx_data_arr_o       : out t_gbt_frame_array((g_NUM_OF_OHs * g_NUM_GBTS_PER_OH) - 1 downto 0);
        tst_gbt_tx_data_arr_i       : in  t_gbt_frame_array((g_NUM_OF_OHs * g_NUM_GBTS_PER_OH) - 1 downto 0);
        tst_gbt_ready_arr_o         : out std_logic_vector((g_NUM_OF_OHs * g_NUM_GBTS_PER_OH) - 1 downto 0)
    );
end gbt_link_mux;

architecture gbt_link_mux_ge11 of gbt_link_mux is

    type t_gbt_idx_array is array(integer range 0 to 23) of integer range 0 to g_NUM_GBTS_PER_OH - 1;
    constant VFAT_TO_GBT_MAP            : t_gbt_idx_array := (1, 1, 1, 1, 1, 1, 1, 0, 1, 2, 2, 2, 0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 0); 

    signal real_gbt_tx_data             : t_gbt_frame_array(g_NUM_OF_OHs * 3 - 1 downto 0);
    signal real_gbt_rx_data             : t_gbt_frame_array(g_NUM_OF_OHs * 3 - 1 downto 0);
    signal gbt_rx_ready_arr             : std_logic_vector((g_NUM_OF_OHs * 3) - 1 downto 0);

    signal fpga_tx_data_arr             : t_std8_array(g_NUM_OF_OHs - 1 downto 0);

    signal promless_tx_data_shuffle     : std_logic_vector(15 downto 0);

begin

    gbt_tx_data_arr_o <= real_gbt_tx_data when link_test_mode_i = '0' else tst_gbt_tx_data_arr_i;
    real_gbt_rx_data <= gbt_rx_data_arr_i when link_test_mode_i = '0' else (others => (others => '0'));
    gbt_ready_arr_o <= gbt_rx_ready_arr when link_test_mode_i = '0' else (others => '0');

    tst_gbt_rx_data_arr_o <= gbt_rx_data_arr_i when link_test_mode_i = '1' else (others => (others => '0'));
    tst_gbt_ready_arr_o <= gbt_rx_ready_arr when link_test_mode_i = '1' else (others => '0');

    g_ohs : for i in 0 to g_NUM_OF_OHs - 1 generate

        --------- RX ---------
        sca_rx_data_arr_o(i) <= real_gbt_rx_data(i * 3 + 0)(81 downto 80);

        gbt_ic_rx_data_arr_o(i * 3 + 0) <= real_gbt_rx_data(i * 3 + 0)(83 downto 82);
        gbt_ic_rx_data_arr_o(i * 3 + 1) <= real_gbt_rx_data(i * 3 + 1)(83 downto 82);
        gbt_ic_rx_data_arr_o(i * 3 + 2) <= real_gbt_rx_data(i * 3 + 2)(83 downto 82);

        gbt_rx_ready_arr(i * 3 + 0) <= gbt_link_status_arr_i(i * 3 + 0).gbt_rx_ready;
        gbt_rx_ready_arr(i * 3 + 1) <= gbt_link_status_arr_i(i * 3 + 1).gbt_rx_ready;
        gbt_rx_ready_arr(i * 3 + 2) <= gbt_link_status_arr_i(i * 3 + 2).gbt_rx_ready;

        g_vfat_gbt_ready: for vfat in 0 to 23 generate
            vfat3_gbt_ready_arr_o(i)(vfat) <= gbt_rx_ready_arr(i * 3 + VFAT_TO_GBT_MAP(vfat));
        end generate;

        oh_fpga_rx_data_arr_o (i) <= real_gbt_rx_data(i * 3 + 0)(79 downto 72);

        vfat3_rx_data_arr_o(i)(23)  <= real_gbt_rx_data(i * 3 + 0)(71 downto 64);
        vfat3_rx_data_arr_o(i)(22)  <= real_gbt_rx_data(i * 3 + 2)(79 downto 72);
        vfat3_rx_data_arr_o(i)(21)  <= real_gbt_rx_data(i * 3 + 2)(31 downto 24);
        vfat3_rx_data_arr_o(i)(20)  <= real_gbt_rx_data(i * 3 + 2)(23 downto 16);
        vfat3_rx_data_arr_o(i)(19)  <= real_gbt_rx_data(i * 3 + 2)(63 downto 56);
        vfat3_rx_data_arr_o(i)(18)  <= real_gbt_rx_data(i * 3 + 2)(55 downto 48);
        vfat3_rx_data_arr_o(i)(17)  <= real_gbt_rx_data(i * 3 + 2)(71 downto 64);
        vfat3_rx_data_arr_o(i)(16)  <= real_gbt_rx_data(i * 3 + 1)(63 downto 56);
        vfat3_rx_data_arr_o(i)(15)  <= real_gbt_rx_data(i * 3 + 0)(7 downto 0);
        vfat3_rx_data_arr_o(i)(14)  <= real_gbt_rx_data(i * 3 + 0)(15 downto 8);
        vfat3_rx_data_arr_o(i)(13) <= real_gbt_rx_data(i * 3 + 0)(23 downto 16);
        vfat3_rx_data_arr_o(i)(12) <= real_gbt_rx_data(i * 3 + 0)(31 downto 24);
        vfat3_rx_data_arr_o(i)(11) <= real_gbt_rx_data(i * 3 + 2)(39 downto 32);
        vfat3_rx_data_arr_o(i)(10) <= real_gbt_rx_data(i * 3 + 2)(47 downto 40);
        vfat3_rx_data_arr_o(i)(9) <= real_gbt_rx_data(i * 3 + 2)(15 downto 8);
        vfat3_rx_data_arr_o(i)(8) <= real_gbt_rx_data(i * 3 + 1)(39 downto 32);
        vfat3_rx_data_arr_o(i)(7) <= real_gbt_rx_data(i * 3 + 0)(47 downto 40) when use_v3b_mapping_i = '0' else real_gbt_rx_data(i * 3 + 0)(55 downto 48);
        vfat3_rx_data_arr_o(i)(6) <= real_gbt_rx_data(i * 3 + 1)(55 downto 48);
        vfat3_rx_data_arr_o(i)(5) <= real_gbt_rx_data(i * 3 + 1)(71 downto 64);
        vfat3_rx_data_arr_o(i)(4) <= real_gbt_rx_data(i * 3 + 1)(15 downto 8);
        vfat3_rx_data_arr_o(i)(3) <= real_gbt_rx_data(i * 3 + 1)(31 downto 24);
        vfat3_rx_data_arr_o(i)(2) <= real_gbt_rx_data(i * 3 + 1)(23 downto 16);
        vfat3_rx_data_arr_o(i)(1) <= real_gbt_rx_data(i * 3 + 1)(79 downto 72);
        vfat3_rx_data_arr_o(i)(0) <= real_gbt_rx_data(i * 3 + 1)(47 downto 40);

        --------- TX ---------
        real_gbt_tx_data(i * 3 + 0)(81 downto 80) <= sca_tx_data_arr_i(i);
        real_gbt_tx_data(i * 3 + 1)(81 downto 80) <= (others => '0');
        real_gbt_tx_data(i * 3 + 2)(81 downto 80) <= (others => '0');
        
        real_gbt_tx_data(i * 3 + 0)(83 downto 82) <= gbt_ic_tx_data_arr_i(i * 3 + 0);
        real_gbt_tx_data(i * 3 + 1)(83 downto 82) <= gbt_ic_tx_data_arr_i(i * 3 + 1);
        real_gbt_tx_data(i * 3 + 2)(83 downto 82) <= gbt_ic_tx_data_arr_i(i * 3 + 2);
  
        promless_tx_data_shuffle(15) <= promless_tx_data_i(0);
        promless_tx_data_shuffle(14) <= promless_tx_data_i(8);
        promless_tx_data_shuffle(13) <= promless_tx_data_i(1);
        promless_tx_data_shuffle(12) <= promless_tx_data_i(9);
        promless_tx_data_shuffle(11) <= promless_tx_data_i(2);
        promless_tx_data_shuffle(10) <= promless_tx_data_i(10);
        promless_tx_data_shuffle(9) <= promless_tx_data_i(3);
        promless_tx_data_shuffle(8) <= promless_tx_data_i(11);
            
        promless_tx_data_shuffle(7) <= promless_tx_data_i(4);
        promless_tx_data_shuffle(6) <= promless_tx_data_i(12);
        promless_tx_data_shuffle(5) <= promless_tx_data_i(5);
        promless_tx_data_shuffle(4) <= promless_tx_data_i(13);
        promless_tx_data_shuffle(3) <= promless_tx_data_i(6);
        promless_tx_data_shuffle(2) <= promless_tx_data_i(14);
        promless_tx_data_shuffle(1) <= promless_tx_data_i(7);
        promless_tx_data_shuffle(0) <= promless_tx_data_i(15);

        fpga_tx_data_arr(i) <= oh_fpga_tx_data_arr_i(i)(7 downto 0);

        real_gbt_tx_data(i * 3 + 0)(79 downto 72) <=  fpga_tx_data_arr(i);

        real_gbt_tx_data(i * 3 + 0)(55 downto 48) <= promless_tx_data_shuffle(15 downto 8) when use_v3b_mapping_i = '0' else vfat3_tx_data_arr_i(i)(7);
        real_gbt_tx_data(i * 3 + 0)(39 downto 32) <= promless_tx_data_shuffle(7 downto 0);

        real_gbt_tx_data(i * 3 + 1)(7 downto 0)   <= (others => '0'); -- test VFAT3 slot 1 on the OH
        real_gbt_tx_data(i * 3 + 2)(7 downto 0)   <= (others => '0'); -- test VFAT3 slot 2 on the OH
        real_gbt_tx_data(i * 3 + 0)(71 downto 64) <= vfat3_tx_data_arr_i(i)(23);
        real_gbt_tx_data(i * 3 + 2)(79 downto 72) <= vfat3_tx_data_arr_i(i)(22);
        real_gbt_tx_data(i * 3 + 2)(31 downto 24) <= vfat3_tx_data_arr_i(i)(21);
        real_gbt_tx_data(i * 3 + 2)(23 downto 16) <= vfat3_tx_data_arr_i(i)(20);
        real_gbt_tx_data(i * 3 + 2)(63 downto 56) <= vfat3_tx_data_arr_i(i)(19);
        real_gbt_tx_data(i * 3 + 2)(55 downto 48) <= vfat3_tx_data_arr_i(i)(18);
        real_gbt_tx_data(i * 3 + 2)(71 downto 64) <= vfat3_tx_data_arr_i(i)(17);
        real_gbt_tx_data(i * 3 + 1)(63 downto 56) <= vfat3_tx_data_arr_i(i)(16);
        real_gbt_tx_data(i * 3 + 0)(7 downto 0)   <= vfat3_tx_data_arr_i(i)(15);
        real_gbt_tx_data(i * 3 + 0)(15 downto 8)  <= vfat3_tx_data_arr_i(i)(14);
        real_gbt_tx_data(i * 3 + 0)(23 downto 16) <= vfat3_tx_data_arr_i(i)(13);
        real_gbt_tx_data(i * 3 + 0)(31 downto 24) <= vfat3_tx_data_arr_i(i)(12);
        real_gbt_tx_data(i * 3 + 2)(39 downto 32) <= vfat3_tx_data_arr_i(i)(11);
        real_gbt_tx_data(i * 3 + 2)(47 downto 40) <= vfat3_tx_data_arr_i(i)(10);
        real_gbt_tx_data(i * 3 + 2)(15 downto 8)  <= vfat3_tx_data_arr_i(i)(9);
        real_gbt_tx_data(i * 3 + 1)(39 downto 32) <= vfat3_tx_data_arr_i(i)(8);
        real_gbt_tx_data(i * 3 + 0)(47 downto 40) <= vfat3_tx_data_arr_i(i)(7) when use_v3b_mapping_i = '0' else promless_tx_data_shuffle(15 downto 8); -- problematic on v3a because it sits on the same group as the promless elinks, so can run only at 80MHz
        real_gbt_tx_data(i * 3 + 1)(55 downto 48) <= vfat3_tx_data_arr_i(i)(6);
        real_gbt_tx_data(i * 3 + 1)(71 downto 64) <= vfat3_tx_data_arr_i(i)(5);
        real_gbt_tx_data(i * 3 + 1)(15 downto 8)  <= vfat3_tx_data_arr_i(i)(4);
        real_gbt_tx_data(i * 3 + 1)(31 downto 24) <= vfat3_tx_data_arr_i(i)(3);
        real_gbt_tx_data(i * 3 + 1)(23 downto 16) <= vfat3_tx_data_arr_i(i)(2);
        real_gbt_tx_data(i * 3 + 1)(79 downto 72) <= vfat3_tx_data_arr_i(i)(1);
        real_gbt_tx_data(i * 3 + 1)(47 downto 40) <= vfat3_tx_data_arr_i(i)(0);

    end generate;

end gbt_link_mux_ge11;

architecture gbt_link_mux_ge21 of gbt_link_mux is

    type t_gbt_idx_array is array(integer range 0 to 23) of integer range 0 to g_NUM_GBTS_PER_OH - 1;
    constant VFAT_TO_GBT_MAP            : t_gbt_idx_array := (0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); 

    signal real_gbt_tx_data             : t_gbt_frame_array(g_NUM_OF_OHs * 2 - 1 downto 0);
    signal real_gbt_rx_data             : t_gbt_frame_array(g_NUM_OF_OHs * 2 - 1 downto 0);
    signal gbt_rx_ready_arr             : std_logic_vector((g_NUM_OF_OHs * 2) - 1 downto 0);

    signal fpga_tx_data_arr             : t_std8_array(g_NUM_OF_OHs - 1 downto 0);

    signal promless_tx_data_shuffle     : std_logic_vector(15 downto 0);

begin

    gbt_tx_data_arr_o <= real_gbt_tx_data when link_test_mode_i = '0' else tst_gbt_tx_data_arr_i;
    real_gbt_rx_data <= gbt_rx_data_arr_i when link_test_mode_i = '0' else (others => (others => '0'));
    gbt_ready_arr_o <= gbt_rx_ready_arr when link_test_mode_i = '0' else (others => '0');

    tst_gbt_rx_data_arr_o <= gbt_rx_data_arr_i when link_test_mode_i = '1' else (others => (others => '0'));
    tst_gbt_ready_arr_o <= gbt_rx_ready_arr when link_test_mode_i = '1' else (others => '0');

    g_ohs : for i in 0 to g_NUM_OF_OHs - 1 generate

        --------- RX ---------
        sca_rx_data_arr_o(i) <= real_gbt_rx_data(i * 2 + 0)(81 downto 80);

        gbt_ic_rx_data_arr_o(i * 2 + 0) <= real_gbt_rx_data(i * 2 + 0)(83 downto 82);
        gbt_ic_rx_data_arr_o(i * 2 + 1) <= real_gbt_rx_data(i * 2 + 1)(83 downto 82);

        gbt_rx_ready_arr(i * 2 + 0) <= gbt_link_status_arr_i(i * 2 + 0).gbt_rx_ready;
        gbt_rx_ready_arr(i * 2 + 1) <= gbt_link_status_arr_i(i * 2 + 1).gbt_rx_ready;

        g_vfat_gbt_ready: for vfat in 0 to 23 generate
            vfat3_gbt_ready_arr_o(i)(vfat) <= gbt_rx_ready_arr(i * 2 + VFAT_TO_GBT_MAP(vfat));
        end generate;

        oh_fpga_rx_data_arr_o (i) <= real_gbt_rx_data(i * 2 + 0)(79 downto 72);

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
        vfat3_rx_data_arr_o(i)(11) <= real_gbt_rx_data(i * 2 + 1)(47 downto 40);
        vfat3_rx_data_arr_o(i)(10) <= real_gbt_rx_data(i * 2 + 1)(39 downto 32);
        vfat3_rx_data_arr_o(i)(9) <= real_gbt_rx_data(i * 2 + 1)(31 downto 24);
        vfat3_rx_data_arr_o(i)(8) <= real_gbt_rx_data(i * 2 + 1)(23 downto 16);
        vfat3_rx_data_arr_o(i)(7) <= real_gbt_rx_data(i * 2 + 1)(15 downto 8);
        vfat3_rx_data_arr_o(i)(6) <= real_gbt_rx_data(i * 2 + 1)(7 downto 0);
        vfat3_rx_data_arr_o(i)(5) <= real_gbt_rx_data(i * 2 + 0)(47 downto 40);
        vfat3_rx_data_arr_o(i)(4) <= real_gbt_rx_data(i * 2 + 0)(39 downto 32);
        vfat3_rx_data_arr_o(i)(3) <= real_gbt_rx_data(i * 2 + 0)(31 downto 24);
        vfat3_rx_data_arr_o(i)(2) <= real_gbt_rx_data(i * 2 + 0)(23 downto 16);
        vfat3_rx_data_arr_o(i)(1) <= real_gbt_rx_data(i * 2 + 0)(15 downto 8);
        vfat3_rx_data_arr_o(i)(0) <= real_gbt_rx_data(i * 2 + 0)(7 downto 0);

        --------- TX ---------
        real_gbt_tx_data(i * 2 + 0)(81 downto 80) <= sca_tx_data_arr_i(i);
        real_gbt_tx_data(i * 2 + 1)(81 downto 80) <= (others => '0');
        
        real_gbt_tx_data(i * 2 + 0)(83 downto 82) <= gbt_ic_tx_data_arr_i(i * 2 + 0);
        real_gbt_tx_data(i * 2 + 1)(83 downto 82) <= gbt_ic_tx_data_arr_i(i * 2 + 1);
  
        promless_tx_data_shuffle(15) <= promless_tx_data_i(0);
        promless_tx_data_shuffle(14) <= promless_tx_data_i(8);
        promless_tx_data_shuffle(13) <= promless_tx_data_i(1);
        promless_tx_data_shuffle(12) <= promless_tx_data_i(9);
        promless_tx_data_shuffle(11) <= promless_tx_data_i(2);
        promless_tx_data_shuffle(10) <= promless_tx_data_i(10);
        promless_tx_data_shuffle(9) <= promless_tx_data_i(3);
        promless_tx_data_shuffle(8) <= promless_tx_data_i(11);
            
        promless_tx_data_shuffle(7) <= promless_tx_data_i(4);
        promless_tx_data_shuffle(6) <= promless_tx_data_i(12);
        promless_tx_data_shuffle(5) <= promless_tx_data_i(5);
        promless_tx_data_shuffle(4) <= promless_tx_data_i(13);
        promless_tx_data_shuffle(3) <= promless_tx_data_i(6);
        promless_tx_data_shuffle(2) <= promless_tx_data_i(14);
        promless_tx_data_shuffle(1) <= promless_tx_data_i(7);
        promless_tx_data_shuffle(0) <= promless_tx_data_i(15);

        fpga_tx_data_arr(i) <= oh_fpga_tx_data_arr_i(i)(7 downto 0);

        real_gbt_tx_data(i * 2 + 0)(79 downto 72) <=  fpga_tx_data_arr(i);

        real_gbt_tx_data(i * 2 + 0)(63 downto 48) <= promless_tx_data_shuffle;

        real_gbt_tx_data(i * 2 + 1)(79 downto 48) <= (others => '0');
        real_gbt_tx_data(i * 2 + 0)(71 downto 64) <= (others => '0');
        
        real_gbt_tx_data(i * 2 + 1)(47 downto 40) <= vfat3_tx_data_arr_i(i)(11);
        real_gbt_tx_data(i * 2 + 1)(39 downto 32) <= vfat3_tx_data_arr_i(i)(10);
        real_gbt_tx_data(i * 2 + 1)(31 downto 24) <= vfat3_tx_data_arr_i(i)(9);
        real_gbt_tx_data(i * 2 + 1)(23 downto 16) <= vfat3_tx_data_arr_i(i)(8);
        real_gbt_tx_data(i * 2 + 1)(15 downto 8) <= vfat3_tx_data_arr_i(i)(7);
        real_gbt_tx_data(i * 2 + 1)(7 downto 0) <= vfat3_tx_data_arr_i(i)(6);
        real_gbt_tx_data(i * 2 + 0)(47 downto 40) <= vfat3_tx_data_arr_i(i)(5);
        real_gbt_tx_data(i * 2 + 0)(39 downto 32) <= vfat3_tx_data_arr_i(i)(4);
        real_gbt_tx_data(i * 2 + 0)(31 downto 24) <= vfat3_tx_data_arr_i(i)(3);
        real_gbt_tx_data(i * 2 + 0)(23 downto 16) <= vfat3_tx_data_arr_i(i)(2);
        real_gbt_tx_data(i * 2 + 0)(15 downto 8) <= vfat3_tx_data_arr_i(i)(1);
        real_gbt_tx_data(i * 2 + 0)(7 downto 0) <= vfat3_tx_data_arr_i(i)(0);

    end generate;

end gbt_link_mux_ge21;
