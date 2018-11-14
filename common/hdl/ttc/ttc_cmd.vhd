-------------------------------------------------------------------------------
--                                                                            
--       Unit Name: ttc_cmd                                            
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
use ieee.numeric_std.all;
library unisim;
use unisim.VComponents.all;

use work.ttc_pkg.all;

--============================================================================
--                                                          Entity declaration
--============================================================================
entity ttc_cmd is
    generic(
        g_DEBUG         : boolean := false -- if this is set to true, some chipscope cores will be inserted
    );    
    port(
        reset_i                 : in  std_logic; -- resets the TTC command fifo, note that TTC commands are dead for 8 clock cycles after this reset (note that this reset does not reset the OOS counters!)
        reset_oos_cnt_i         : in  std_logic; -- this reset only resets the OOS counters
        
        clk_40_backplane_i      : in  std_logic; -- TTC 40MHz clock from the backplane
        clk_40_fabric_i         : in  std_logic; -- TTC 40MHz fabric clock
        ttc_clks_i              : in  t_ttc_clks; -- other TTC clocks (only used for ILA)

        ttc_data_p_i            : in  std_logic; -- TTC datastream from AMC13
        ttc_data_n_i            : in  std_logic;
        ttc_cmd_o               : out std_logic_vector(7 downto 0); -- B-command output (zero if no command)
        ttc_l1a_o               : out std_logic; -- L1A output

        tcc_err_cnt_rst_i       : in  std_logic; -- Err ctr reset
        ttc_err_single_cnt_o    : out std_logic_vector(15 downto 0);
        ttc_err_double_cnt_o    : out std_logic_vector(15 downto 0);
        
        buf_depth_after_reset_i : in  std_logic_vector(3 downto 0); -- desired depth of the buffer after reset 
        buf_oos_min_depth_i     : in  std_logic_vector(3 downto 0); -- lower range of the buffer depth when oos should be asserted
        buf_oos_max_depth_i     : in  std_logic_vector(3 downto 0); -- upper range of the buffer depth when oos should be asserted
        
        buf_status_o            : out t_ttc_buffer_status
        
    );
end ttc_cmd;

--============================================================================
--                                                        Architecture section
--============================================================================
architecture ttc_cmd_arch of ttc_cmd is

    component ttc_command_fifo
        port (
            rst           : in  std_logic;
            wr_clk        : in  std_logic;
            rd_clk        : in  std_logic;
            din           : in  std_logic_vector(1 downto 0);
            wr_en         : in  std_logic;
            rd_en         : in  std_logic;
            dout          : out std_logic_vector(1 downto 0);
            full          : out std_logic;
            overflow      : out std_logic;
            empty         : out std_logic;
            valid         : out std_logic;
            underflow     : out std_logic;
            rd_data_count : out std_logic_vector(3 downto 0)
        );
    end component;

    COMPONENT ila_ttc_cmd_buffer
        PORT(
            clk     : IN STD_LOGIC;
            probe0  : IN STD_LOGIC;
            probe1  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            probe2  : IN STD_LOGIC;
            probe3  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            probe4  : IN STD_LOGIC;
            probe5  : IN STD_LOGIC;
            probe6  : IN STD_LOGIC;
            probe7  : IN STD_LOGIC;
            probe8  : IN STD_LOGIC;
            probe9  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            probe10 : IN STD_LOGIC;
            probe11 : IN STD_LOGIC;
            probe12 : IN STD_LOGIC;
            probe13 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            probe14 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            probe15 : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ila_ttc_cmd_buf_2
        PORT(
            clk    : IN STD_LOGIC;
            probe0 : IN STD_LOGIC;
            probe1 : IN STD_LOGIC;
            probe2 : IN STD_LOGIC;
            probe3 : IN STD_LOGIC;
            probe4 : IN STD_LOGIC;
            probe5 : IN STD_LOGIC;
            probe6 : IN STD_LOGIC;
            probe7 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            probe8 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            probe9 : IN STD_LOGIC
        );
    END COMPONENT;

    --============================================================================
    --                                                         Signal declarations
    --============================================================================
    signal s_ttc_data_ibufds        : std_logic;
    signal s_ttc_data_backplane     : std_logic_vector(1 downto 0);
    signal s_ttc_data_fabric        : std_logic_vector(1 downto 0);

    signal s_ttc_stb : std_logic;
    signal s_ttc_cmd : std_logic_vector(7 downto 0);

    signal s_ttc_l1a : std_logic;

    signal s_ttc_err_single, s_ttc_err_double         : std_logic;
    signal s_ttc_err_single_cnt, s_ttc_err_double_cnt : unsigned(15 downto 0);

    signal s_reset_sync_fabric  : std_logic;
    signal s_buf_reset          : std_logic;
    signal s_buf_wr_en          : std_logic;
    signal s_buf_rd_en          : std_logic;
    signal s_buf_ovf            : std_logic;
    signal s_buf_ovf_prev       : std_logic;
    signal s_buf_unf            : std_logic;
    signal s_buf_unf_prev       : std_logic;
    signal s_buf_full           : std_logic;
    signal s_buf_empty          : std_logic;
    signal s_buf_valid          : std_logic;
    signal s_buf_dout           : std_logic_vector(1 downto 0);
    signal s_buf_data_cnt       : std_logic_vector(3 downto 0);
    signal s_buf_data_cnt_min   : std_logic_vector(3 downto 0) := x"f";
    signal s_buf_data_cnt_max   : std_logic_vector(3 downto 0) := x"0";
    signal s_buf_oos            : std_logic := '0';
    signal s_buf_oos_prev       : std_logic := '0';
    signal s_buf_busy           : std_logic := '1';
    signal s_buf_reset_done     : std_logic := '0';
    
    signal s_buf_oos_start      : std_logic; -- this goes up for 1 clock when OOS transitions from 0 to 1
    signal s_buf_oos_cnt        : unsigned(15 downto 0) := (others => '0');
    signal s_buf_unf_cnt        : unsigned(15 downto 0) := (others => '0');
    signal s_buf_ovf_cnt        : unsigned(15 downto 0) := (others => '0');
    signal s_buf_oos_time_last  : std_logic_vector(15 downto 0) := (others => '0');
    signal s_buf_oos_dur_last   : std_logic_vector(31 downto 0) := (others => '0');
    signal s_buf_oos_dur_max    : unsigned(31 downto 0) := (others => '0');

--============================================================================
--                                                          Architecture begin
--============================================================================
begin
    i_bufds_fab_b : IBUFDS
        port map(
            i  => ttc_data_p_i,
            ib => ttc_data_n_i,
            o  => s_ttc_data_ibufds
        );

    i_ddr_ttc_data : IDDR
        generic map(
            DDR_CLK_EDGE => "SAME_EDGE"
        )
        port map(
            q1 => s_ttc_data_backplane(0),
            q2 => s_ttc_data_backplane(1),
            c  => clk_40_backplane_i,
            ce => '1',
            d  => s_ttc_data_ibufds,
            r  => '0',
            s  => '0'
        );

    i_ttc_command_buffer : component ttc_command_fifo
        port map(
            rst           => s_buf_reset,
            wr_clk        => clk_40_backplane_i,
            rd_clk        => clk_40_fabric_i,
            din           => s_ttc_data_backplane,
            wr_en         => s_buf_wr_en,
            rd_en         => s_buf_rd_en,
            dout          => s_buf_dout,
            full          => s_buf_full,
            overflow      => s_buf_ovf,
            empty         => s_buf_empty,
            valid         => s_buf_valid,
            underflow     => s_buf_unf,
            rd_data_count => s_buf_data_cnt
        );

    i_buf_reset_sync : entity work.synchronizer
        generic map(
            N_STAGES => 2
        )
        port map(
            async_i => reset_i,
            clk_i   => clk_40_fabric_i,
            sync_o  => s_reset_sync_fabric
        );

    p_buffer_manage : process(clk_40_fabric_i)
    begin
        if (rising_edge(clk_40_fabric_i)) then
            if (s_reset_sync_fabric = '1') then
                s_buf_data_cnt_min <= (others => '1');
                s_buf_data_cnt_max <= (others => '0');
                s_buf_oos          <= '0';
                s_buf_busy         <= '1';
                s_buf_reset_done   <= '0';
                s_buf_rd_en        <= '0';
                s_ttc_data_fabric  <= "00";
                s_buf_reset        <= '1';
                s_buf_wr_en <= '0';
            elsif (s_buf_reset_done = '0') then
                
                s_buf_reset        <= '0';
                s_buf_data_cnt_min <= (others => '1');
                s_buf_data_cnt_max <= (others => '0');
                s_buf_oos          <= '0';
                s_ttc_data_fabric  <= "00";
    
                if (s_buf_full = '1' and s_buf_empty = '1') then
                    s_buf_wr_en <= '0';
                else
                    s_buf_wr_en <= '1';
                end if;
    
                if (unsigned(s_buf_data_cnt) = (unsigned(buf_depth_after_reset_i) - 1)) then
                    s_buf_busy         <= '1';
                    s_buf_reset_done   <= '0';
                    s_buf_rd_en        <= '1';
                elsif (unsigned(s_buf_data_cnt) > (unsigned(buf_depth_after_reset_i) - 1)) then
                    s_buf_busy         <= '0';
                    s_buf_reset_done   <= '1';
                    s_buf_rd_en        <= '1';
                else
                    s_buf_busy         <= '1';
                    s_buf_reset_done   <= '0';
                    s_buf_rd_en        <= '0';
                end if;
            else

                s_buf_reset <= '0';
                s_buf_rd_en <= '1';
                s_buf_reset_done <= '1';
                s_buf_busy <= '0';
                s_buf_wr_en <= '1';
                
                if (s_buf_valid = '1') then
                    s_ttc_data_fabric  <= s_buf_dout;
                else
                    s_ttc_data_fabric <= "00";
                end if;
                
                if (unsigned(s_buf_data_cnt) < unsigned(s_buf_data_cnt_min)) then
                    s_buf_data_cnt_min <= s_buf_data_cnt;
                end if;
                
                if (unsigned(s_buf_data_cnt) > unsigned(s_buf_data_cnt_max)) then
                    s_buf_data_cnt_max <= s_buf_data_cnt;
                end if;
                
                if ((unsigned(s_buf_data_cnt) < unsigned(buf_oos_min_depth_i)) or
                    (unsigned(s_buf_data_cnt) > unsigned(buf_oos_max_depth_i)) or
                    (s_buf_ovf = '1') or (s_buf_unf = '1'))
                then
                    s_buf_oos <= '1';
                else
                    s_buf_oos <= s_buf_oos;
                end if;
            end if;
        end if;
    end process;

    buf_status_o.depth          <= s_buf_data_cnt;
    buf_status_o.min_depth      <= s_buf_data_cnt_min;
    buf_status_o.max_depth      <= s_buf_data_cnt_max;
    buf_status_o.out_of_sync    <= s_buf_oos;
    buf_status_o.busy           <= s_buf_busy;
    
    buf_status_o.oos_cnt        <= std_logic_vector(s_buf_oos_cnt);
    buf_status_o.unf_cnt        <= std_logic_vector(s_buf_unf_cnt);
    buf_status_o.ovf_cnt        <= std_logic_vector(s_buf_ovf_cnt);
    buf_status_o.oos_time_last  <= s_buf_oos_time_last;
    buf_status_o.oos_dur_last   <= s_buf_oos_dur_last;
    buf_status_o.oos_dur_max    <= std_logic_vector(s_buf_oos_dur_max);

    p_oos_cnt : process(clk_40_fabric_i)
    begin
        if (rising_edge(clk_40_fabric_i)) then
            
            s_buf_oos_prev <= s_buf_oos;
            s_buf_ovf_prev <= s_buf_ovf;
            s_buf_unf_prev <= s_buf_unf;
            
            if (reset_oos_cnt_i = '1') then
                s_buf_oos_cnt <= (others => '0');
                s_buf_unf_cnt <= (others => '0');
                s_buf_ovf_cnt <= (others => '0');
                s_buf_oos_dur_max <= (others => '0');
                s_buf_oos_start <= '0';
            else
                if ((s_buf_oos_prev = '0') and (s_buf_oos = '1')) then
                    s_buf_oos_cnt <= s_buf_oos_cnt + 1;
                    s_buf_oos_start <= '1';
                    if (s_buf_ovf_prev = '1') then
                        s_buf_ovf_cnt <= s_buf_ovf_cnt + 1;
                    end if;
                    if (s_buf_unf_prev = '1') then
                        s_buf_unf_cnt <= s_buf_unf_cnt + 1;
                    end if;
                else
                    s_buf_oos_start <= '0';
                end if;
                
                if (s_buf_oos_dur_max < unsigned(s_buf_oos_dur_last)) then
                    s_buf_oos_dur_max <= unsigned(s_buf_oos_dur_last);
                else
                    s_buf_oos_dur_max <= s_buf_oos_dur_max;
                end if;
                
            end if;
        end if;
    end process;

    cnt_oos_dur_last : entity work.counter
        generic map(
            g_COUNTER_WIDTH  => 32,
            g_ALLOW_ROLLOVER => false
        )
        port map(
            ref_clk_i => clk_40_fabric_i,
            reset_i   => s_buf_oos_start or reset_oos_cnt_i,
            en_i      => s_buf_oos,
            count_o   => s_buf_oos_dur_last
        );

    cnt_oos_time_last : entity work.seconds_counter
        generic map(
            g_CLK_FREQUENCY  => C_TTC_CLK_FREQUENCY_SLV,
            g_ALLOW_ROLLOVER => false,
            g_COUNTER_WIDTH  => 16
        )
        port map(
            clk_i     => clk_40_fabric_i,
            reset_i   => s_buf_oos_start or reset_oos_cnt_i,
            seconds_o => s_buf_oos_time_last
        );

    gen_debug: if g_DEBUG generate
        i_buf_ila_2 : component ila_ttc_cmd_buf_2
            port map(
                clk    => ttc_clks_i.clk_160,
                probe0 => clk_40_fabric_i,
                probe1 => clk_40_backplane_i,
                probe2 => s_buf_wr_en,
                probe3 => s_buf_rd_en,
                probe4 => s_buf_ovf,
                probe5 => s_buf_unf,
                probe6 => s_buf_reset,
                probe7 => s_buf_data_cnt,
                probe8 => s_ttc_data_backplane,
                probe9 => s_buf_oos
            );

--        i_buf_ila : component ila_ttc_cmd_buffer
--            port map(
--                clk     => clk_40_fabric_i,
--                probe0  => s_buf_reset,
--                probe1  => s_ttc_data_backplane,
--                probe2  => s_buf_rd_en,
--                probe3  => s_buf_dout,
--                probe4  => s_buf_full,
--                probe5  => s_buf_ovf,
--                probe6  => s_buf_empty,
--                probe7  => s_buf_valid,
--                probe8  => s_buf_unf,
--                probe9  => s_buf_data_cnt,
--                probe10 => s_buf_oos,
--                probe11 => s_buf_busy,
--                probe12 => s_buf_reset_done,
--                probe13 => s_ttc_data_fabric,
--                probe14 => s_buf_data_cnt_min,
--                probe15 => s_buf_data_cnt_max
--            );
    end generate;

    i_ttc_decoder : entity work.ttc_decoder
        port map(
            ttc_clk   => clk_40_fabric_i,
            ttc_data  => s_ttc_data_fabric,
            l1accept  => s_ttc_l1a,
            sinerrstr => s_ttc_err_single,
            dberrstr  => s_ttc_err_double,
            brcststr  => s_ttc_stb,
            brcst     => s_ttc_cmd
        );

    process(clk_40_fabric_i)
    begin
        if rising_edge(clk_40_fabric_i) then
            if tcc_err_cnt_rst_i = '1' then
                s_ttc_err_single_cnt <= (others => '0');
                s_ttc_err_double_cnt <= (others => '0');
            else
                if s_ttc_err_single = '1' and s_ttc_err_single_cnt /= X"ffff" then
                    s_ttc_err_single_cnt <= s_ttc_err_single_cnt + 1;
                end if;
                if s_ttc_err_double = '1' and s_ttc_err_double_cnt /= X"ffff" then
                    s_ttc_err_double_cnt <= s_ttc_err_double_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    ----

    ttc_l1a_o <= s_ttc_l1a;
    ttc_cmd_o <= s_ttc_cmd when s_ttc_stb = '1' and s_buf_busy = '0' else X"00";

    ttc_err_single_cnt_o <= std_logic_vector(s_ttc_err_single_cnt);
    ttc_err_double_cnt_o <= std_logic_vector(s_ttc_err_double_cnt);

end ttc_cmd_arch;
--============================================================================
--                                                            Architecture end
--============================================================================
