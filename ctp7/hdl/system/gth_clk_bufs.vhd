-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: gth_clk_bufs                                           
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
use IEEE.NUMERIC_STD.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

library work;
use work.gth_pkg.all;
use work.system_package.all;
use work.ttc_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity gth_clk_bufs is
  generic
    (
      g_NUM_OF_GTH_GTs : integer := 36
      );
  port (

    GTH_4p8g_TX_MMCM_reset_i  : in  std_logic;
    GTH_4p8g_TX_MMCM_locked_o : out std_logic;

    ttc_clks_i                : in t_ttc_clks;
    ttc_clks_locked_i         : in std_logic;

    refclk_F_0_p_i : in std_logic_vector (3 downto 0);
    refclk_F_0_n_i : in std_logic_vector (3 downto 0);
    refclk_F_1_p_i : in std_logic_vector (3 downto 0);
    refclk_F_1_n_i : in std_logic_vector (3 downto 0);
    refclk_B_0_p_i : in std_logic_vector (3 downto 1);
    refclk_B_0_n_i : in std_logic_vector (3 downto 1);
    refclk_B_1_p_i : in std_logic_vector (3 downto 1);
    refclk_B_1_n_i : in std_logic_vector (3 downto 1);

    refclk_F_0_o : out std_logic_vector (3 downto 0);
    refclk_F_1_o : out std_logic_vector (3 downto 0);
    refclk_B_0_o : out std_logic_vector (3 downto 1);
    refclk_B_1_o : out std_logic_vector (3 downto 1);

    gth_gt_clk_out_arr_i : in t_gth_gt_clk_out_arr(g_NUM_OF_GTH_GTs-1 downto 0);

    clk_gth_tx_usrclk_arr_o : out std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);
    clk_gth_rx_usrclk_arr_o : out std_logic_vector(g_NUM_OF_GTH_GTs-1 downto 0);

    clk_gth_4p8g_common_rxusrclk_o : out std_logic;
    clk_gth_4p8g_common_txoutclk_o : out std_logic;
    clk_gth_4p8g_common_txoutclkpcs_o : out std_logic

    );
end gth_clk_bufs;

--============================================================================
architecture gth_clk_bufs_arch of gth_clk_bufs is

--============================================================================
--                                                         Signal declarations
--============================================================================

  signal s_gth_4p8g_txusrclk_90deg   : std_logic;
  signal s_gth_4p8g_txoutclk         : std_logic;
  signal s_gth_4p8g_txoutclk_bufg    : std_logic;
  signal s_gth_4p8g_txoutclkpcs      : std_logic;
  signal s_gth_4p8g_txoutclkpcs_bufg : std_logic;
  signal s_gth_4p8g_mmcm_locked      : std_logic;

  signal s_gth_3p2g_txusrclk         : std_logic;
  signal s_gth_3p2g_txoutclk         : std_logic;
  
--============================================================================
--                                                          Architecture begin
--============================================================================

begin

--============================================================================

  clk_gth_4p8g_common_txoutclk_o <= s_gth_4p8g_txoutclk_bufg;
  clk_gth_4p8g_common_txoutclkpcs_o <= s_gth_4p8g_txoutclkpcs_bufg;
  clk_gth_4p8g_common_rxusrclk_o <= ttc_clks_i.clk_120;
  --GTH_4p8g_TX_MMCM_locked_o <= s_gth_4p8g_mmcm_locked;
  GTH_4p8g_TX_MMCM_locked_o <= ttc_clks_locked_i;

  gen_ibufds_F_clk_gte2 : for i in 0 to 3 generate

    i_ibufds_F_0 : IBUFDS_GTE2
      port map
      (
        O     => refclk_F_0_o(i),
        ODIV2 => open,
        CEB   => '0',
        I     => refclk_F_0_p_i(i),
        IB    => refclk_F_0_n_i(i)
        );

    i_ibufds_F_1 : IBUFDS_GTE2
      port map
      (
        O     => refclk_F_1_o(i),
        ODIV2 => open,
        CEB   => '0',
        I     => refclk_F_1_p_i(i),
        IB    => refclk_F_1_n_i(i)
        );
  end generate;

  gen_ibufds_B_clk_gte2 : for i in 1 to 3 generate

    i_ibufds_B_0 : IBUFDS_GTE2
      port map
      (
        O     => refclk_B_0_o(i),
        ODIV2 => open,
        CEB   => '0',
        I     => refclk_B_0_p_i(i),
        IB    => refclk_B_0_n_i(i)
        );

    i_ibufds_B_1 : IBUFDS_GTE2
      port map
      (
        O     => refclk_B_1_o(i),
        ODIV2 => open,
        CEB   => '0',
        I     => refclk_B_1_p_i(i),
        IB    => refclk_B_1_n_i(i)
        );

  end generate;

--============================================================================

  gen_bufh_outclks : for n in 0 to g_NUM_OF_GTH_GTs-1 generate
    gen_gth_4p8g_txuserclk : if c_gth_config_arr(n).gth_link_type = gth_4p8g generate
      gen_gth_4p8g_txuserclk_master : if c_gth_config_arr(n).gth_txclk_out_master = true generate

        s_gth_4p8g_txoutclk <= gth_gt_clk_out_arr_i(n).txoutclk;
        s_gth_4p8g_txoutclkpcs <= gth_gt_clk_out_arr_i(n).txoutpcs;

        i_bufg_4p8g_tx_outclk : BUFG
            port map(
                I => s_gth_4p8g_txoutclk,
                O => s_gth_4p8g_txoutclk_bufg
            );
            
        i_bufg_4p8g_tx_outclkpcs : BUFG
            port map(
                I => s_gth_4p8g_txoutclkpcs,
                O => s_gth_4p8g_txoutclkpcs_bufg
            );
            
        -- Instantiate a MMCM module to divide the reference clock. Uses internal feedback
        -- for improved jitter performance, and to avoid consuming an additional BUFG
--        txoutclk_mmcm0_i : entity work.gth_4p8_raw_CLOCK_MODULE
--          generic map
--          (
--            MULT        => 9.0,
--            DIVIDE      => 2,
--            CLK_PERIOD  => 6.25,
--            OUT0_DIVIDE => 6.0,
--            OUT1_DIVIDE => 6,
--            OUT2_DIVIDE => 1,
--            OUT3_DIVIDE => 1
--            )
--          port map
--          (
--            CLK_IN_160          => s_gth_4p8g_txoutclk,
--            CLK_ALIGN_120       => ttc_clks.clk_120,
--            CLK_OUT_120         => s_gth_4p8g_txusrclk,
--            CLK_OUT_120_90deg   => s_gth_4p8g_txusrclk_90deg,
--            MMCM_LOCKED_OUT     => s_gth_4p8g_mmcm_locked,
--            MMCM_RESET_IN       => GTH_4p8g_TX_MMCM_reset_i,
--            MMCM_SHIFT_CNT      => gth_4p8g_mmcm_shift_cnt,
--            PLL_LOCK_TIME       => gth_4p8_pll_lock_time
--            );

--        i_bufg_4p8g_rx_common_usrclk : BUFG
--            port map(
--                I => gth_gt_clk_out_arr_i(n).rxoutclk,
--                O => clk_gth_4p8g_common_rxusrclk_o
--            );

      end generate;

      clk_gth_tx_usrclk_arr_o(n) <= ttc_clks_i.clk_120; --s_gth_4p8g_txusrclk;

    end generate;

    gen_gth_3p2g_txuserclk : if c_gth_config_arr(n).gth_link_type = gth_3p2g generate

      gen_gth_3p2g_txuserclk_master : if c_gth_config_arr(n).gth_txclk_out_master = true generate

        s_gth_3p2g_txoutclk <= gth_gt_clk_out_arr_i(n).txoutclk;

        i_bufg_3p2g_tx_outclk : BUFG
          port map
          (
            I => s_gth_3p2g_txoutclk,
            O => s_gth_3p2g_txusrclk
            );

      end generate;

      clk_gth_tx_usrclk_arr_o(n) <= s_gth_3p2g_txusrclk;

    end generate;


    i_bufh_rx_outclk : BUFH
      port map
      (
        I => gth_gt_clk_out_arr_i(n).rxoutclk,
        O => clk_gth_rx_usrclk_arr_o(n)
        );

  end generate;

end gth_clk_bufs_arch;
--============================================================================
--                                                            Architecture end
--============================================================================

