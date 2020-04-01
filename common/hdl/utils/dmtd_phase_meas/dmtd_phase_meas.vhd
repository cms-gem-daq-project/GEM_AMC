-------------------------------------------------------------------------------
-- Title      : Digital DMTD Phase Measurement Unit
-- Project    : White Rabbit
-------------------------------------------------------------------------------
-- File       : dmtd_phase_meas.vhd
-- Author     : Tomasz Wlostowski
-- Company    : CERN BE-Co-HT
-- Created    : 2010-02-25
-- Last update: 2011-05-11
-- Platform   : FPGA-generic
-- Standard   : VHDL '93
-------------------------------------------------------------------------------
-- Description: Module measures phase shift between the two input clocks
-- using a DDMTD phase detector. The raw measurement can be further averaged to
-- increase the accuracy.
-------------------------------------------------------------------------------
--
-- Copyright (c) 2009 - 2010 CERN
--
-- This source file is free software; you can redistribute it   
-- and/or modify it under the terms of the GNU Lesser General   
-- Public License as published by the Free Software Foundation; 
-- either version 2.1 of the License, or (at your option) any   
-- later version.                                               
--
-- This source is distributed in the hope that it will be       
-- useful, but WITHOUT ANY WARRANTY; without even the implied   
-- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      
-- PURPOSE.  See the GNU Lesser General Public License for more 
-- details.                                                     
--
-- You should have received a copy of the GNU Lesser General    
-- Public License along with this source; if not, download it   
-- from http://www.gnu.org/licenses/lgpl-2.1.html
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2010-02-25  1.0      twlostow        Created
-- 2011-04-18  1.1      twlostow        Added comments and header
-- 2020-03-27  1.2      Evaldas Juska   Adapted to GEM needs (phase_meas_o actually outputs the average and not sum, also provides min/max, and jump monitoring)
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity dmtd_phase_meas is
    generic(
        g_deglitcher_threshold : integer := 2000;
        g_counter_bits         : integer := 14;
        g_max_valid_phase      : integer
    );
    port(
        reset_i             : in  std_logic;
        clk_sys_i           : in  std_logic;
        clk_a_i             : in  std_logic;
        clk_b_i             : in  std_logic;
        clk_dmtd_i          : in  std_logic;
        navg_log2_i         : in  std_logic_vector(3 downto 0);
        phase_jump_thresh_i : in  std_logic_vector(g_counter_bits - 1 downto 0);
        phase_o             : out std_logic_vector(g_counter_bits - 1 downto 0);
        phase_min_o         : out std_logic_vector(g_counter_bits - 1 downto 0);
        phase_max_o         : out std_logic_vector(g_counter_bits - 1 downto 0);
        phase_p_o           : out std_logic;
        dv_o                : out std_logic;
        phase_jump_cnt_o    : out std_logic_vector(15 downto 0) -- number of times a phase jump has been detected
    );

end dmtd_phase_meas;

architecture syn of dmtd_phase_meas is
    
    constant RANGE_OUTSIDE_VALID_PHASE  : integer := (2 ** g_counter_bits) - g_max_valid_phase;
    constant MAX_POSITIVE_PHASE         : unsigned(g_counter_bits - 1 downto 0) := to_unsigned(g_max_valid_phase + (RANGE_OUTSIDE_VALID_PHASE / 2), g_counter_bits);
    
    type t_pd_state is (PD_WAIT_TAG, PD_WAIT_A, PD_WAIT_B);

    signal rst_n_dmtdclk    : std_logic;
    signal rst_n_sysclk     : std_logic;

    signal tag_a            : std_logic_vector(g_counter_bits - 1 downto 0);
    signal tag_b            : std_logic_vector(g_counter_bits - 1 downto 0);

    signal tag_a_p          : std_logic;
    signal tag_b_p          : std_logic;

    signal acc              : unsigned(31 downto 0);
    signal avg_cnt          : unsigned(15 downto 0);
    signal navg             : unsigned(15 downto 0);

    signal phase_raw_p      : std_logic;
    signal phase_raw        : unsigned(g_counter_bits - 1 downto 0);
    signal phase_corr_p     : std_logic;
    signal phase_corr       : unsigned(g_counter_bits - 1 downto 0);
    signal pd_state         : t_pd_state;

    signal phase_avg        : std_logic_vector(g_counter_bits - 1 downto 0);
    signal phase_avg_p      : std_logic;
    signal phase_lo         : std_logic;
    signal phase_hi         : std_logic;
    signal stored_sign      : std_logic;
    signal preserve_sign    : std_logic;
    signal dv               : std_logic := '0';
    
    signal phase_min        : std_logic_vector(g_counter_bits - 1 downto 0) := (others => '1');
    signal phase_max        : std_logic_vector(g_counter_bits - 1 downto 0) := (others => '0');

    signal phase_jump_thresh: unsigned(g_counter_bits -1 downto 0);
    signal phase_jump_cnt   : unsigned(15 downto 0);
    signal phase_avg_prev   : std_logic_vector(g_counter_bits - 1 downto 0);
    signal dv_prev          : std_logic := '0';

begin                                   -- syn

    rst_n_sysclk <= not reset_i;
    dv_o         <= dv;

    -- reset sync for DMTD sampling clock
    sync_reset_dmtdclk : entity work.synchronizer
        generic map(
            N_STAGES => 3
        )
        port map(
            async_i => rst_n_sysclk,
            clk_i   => clk_dmtd_i,
            sync_o  => rst_n_dmtdclk
        );

    DMTD_A : entity work.dmtd_with_deglitcher
        generic map(
            g_counter_bits => g_counter_bits
        --            g_log2_replication => 2
        )
        port map(
            rst_n_dmtdclk_i      => rst_n_dmtdclk,
            rst_n_sysclk_i       => rst_n_sysclk,
            clk_dmtd_i           => clk_dmtd_i,
            clk_sys_i            => clk_sys_i,
            clk_in_i             => clk_a_i,
            tag_o                => tag_a,
            tag_stb_p1_o         => tag_a_p,
            shift_en_i           => '0',
            shift_dir_i          => '0',
            deglitch_threshold_i => std_logic_vector(to_unsigned(g_deglitcher_threshold, 16))
        );

    DMTD_B : entity work.dmtd_with_deglitcher
        generic map(
            g_counter_bits => g_counter_bits
        --            g_log2_replication => 2
        )
        port map(
            rst_n_dmtdclk_i      => rst_n_dmtdclk,
            rst_n_sysclk_i       => rst_n_sysclk,
            clk_dmtd_i           => clk_dmtd_i,
            clk_sys_i            => clk_sys_i,
            clk_in_i             => clk_b_i,
            tag_o                => tag_b,
            tag_stb_p1_o         => tag_b_p,
            shift_en_i           => '0',
            shift_dir_i          => '0',
            deglitch_threshold_i => std_logic_vector(to_unsigned(g_deglitcher_threshold, 16))
        );

    collect_tags : process(clk_sys_i)
    begin                               -- process   
        if rising_edge(clk_sys_i) then
            if (reset_i = '1') then
                phase_raw   <= (others => '0');
                phase_raw_p <= '0';
                pd_state    <= PD_WAIT_TAG;
            else
                case pd_state is
                    when PD_WAIT_TAG =>
                        if (tag_a_p = '1' and tag_b_p = '1') then
                            phase_raw   <= unsigned(tag_a) - unsigned(tag_b);
                            phase_raw_p <= '1';
                        elsif (tag_a_p = '1') then
                            phase_raw   <= unsigned(tag_a);
                            phase_raw_p <= '0';
                            pd_state    <= PD_WAIT_B;
                        elsif (tag_b_p = '1') then
                            phase_raw   <= (not unsigned(tag_b)) + 1;
                            phase_raw_p <= '0';
                            pd_state    <= PD_WAIT_A;
                        else
                            phase_raw_p <= '0';
                        end if;

                    when PD_WAIT_A =>
                        if (tag_a_p = '1') then
                            phase_raw   <= phase_raw + unsigned(tag_a);
                            phase_raw_p <= '1';
                            pd_state    <= PD_WAIT_TAG;
                        end if;

                    when PD_WAIT_B =>
                        if (tag_b_p = '1') then
                            phase_raw   <= phase_raw - unsigned(tag_b);
                            phase_raw_p <= '1';
                            pd_state    <= PD_WAIT_TAG;
                        end if;

                    when others => null;
                end case;

            end if;
        end if;
    end process;

    correct_phase : process(clk_sys_i)
    begin
        if (rising_edge(clk_sys_i)) then
            phase_corr_p <= phase_raw_p;
            if (phase_raw > to_unsigned(g_max_valid_phase, g_counter_bits)) then
                phase_corr <= phase_raw - to_unsigned(RANGE_OUTSIDE_VALID_PHASE, g_counter_bits);
            else
                phase_corr <= phase_raw;
            end if;
        end if;
    end process;

    phase_hi <= '1' when phase_corr(phase_corr'high downto phase_corr'high - 1) = "11" else '0';
    phase_lo <= '1' when phase_corr(phase_corr'high downto phase_corr'high - 1) = "00" else '0';

    phase_o <= phase_avg;
    phase_p_o <= phase_avg_p;
    navg <= to_unsigned(2 ** to_integer(unsigned(navg_log2_i)), 16);

    -- calculates the average
    -- note: most of the strange, seemingly unnecessary code is meant to deal with the transition between 0 and max phase
    calc_avg : process(clk_sys_i)
        variable avg_tmp    : unsigned(g_counter_bits - 1 downto 0);
    begin
        if rising_edge(clk_sys_i) then
            if (reset_i = '1') then
                acc            <= (others => '0');
                avg_cnt        <= to_unsigned(1, avg_cnt'length);
                phase_avg      <= (others => '0');
                phase_avg_p    <= '0';
                dv             <= '0';
            else
                if (phase_corr_p = '1') then
                    if (navg = to_unsigned(1, navg'length)) then -- this is just avoid the extra 1 sample delay of doing it in the averaging clause below
                        phase_avg <= std_logic_vector(phase_corr);
                        phase_avg_p    <= '1';
                        dv             <= '1';
                    elsif (avg_cnt = unsigned(navg)) then
                        acc <= resize(phase_corr, acc'length);

                        if (phase_lo = '1') then
                            preserve_sign <= '1';
                            stored_sign   <= '0';
                        elsif (phase_hi = '1') then
                            preserve_sign <= '1';
                            stored_sign   <= '1';
                        else
                            preserve_sign <= '0';
                        end if;

                        avg_cnt        <= to_unsigned(1, avg_cnt'length);

                        avg_tmp := acc(g_counter_bits - 1 + to_integer(unsigned(navg_log2_i)) downto to_integer(unsigned(navg_log2_i)));
                        if (avg_tmp > MAX_POSITIVE_PHASE) then -- this is a wraparoud from min to high
                            phase_avg <= std_logic_vector(to_unsigned(g_max_valid_phase, g_counter_bits) - (to_unsigned(2 ** g_counter_bits, g_counter_bits) - avg_tmp));
                        elsif (avg_tmp > to_unsigned(g_max_valid_phase, g_counter_bits)) then -- this is a wraparoud from max to low
                            phase_avg <= std_logic_vector(avg_tmp - to_unsigned(g_max_valid_phase + 1, g_counter_bits));
                        else
                            phase_avg <= std_logic_vector(avg_tmp);
                        end if;
                        phase_avg_p    <= '1';
                        dv             <= '1';
                    else
                        avg_cnt        <= avg_cnt + 1;
                        phase_avg_p    <= '0';

                        if (preserve_sign = '1') then
                            if (phase_lo = '1' and stored_sign = '1') then
                                --       report "preserve_sign1";
                                acc <= acc + resize(phase_corr, acc'length) + to_unsigned(g_max_valid_phase, acc'length);
                            elsif (phase_hi = '1' and stored_sign = '0') then

                                --report "preserve_sign0";
                                acc <= acc + resize(phase_corr, acc'length) - to_unsigned(g_max_valid_phase, acc'length);
                            else
                                acc <= acc + resize(phase_corr, acc'length);
                            end if;
                        else
                            acc <= acc + resize(phase_corr, acc'length);
                        end if;
                    end if;
                else
                    phase_avg_p <= '0';
                end if;
            end if;
        end if;
    end process;
    
    phase_min_o <= phase_min;
    phase_max_o <= phase_max;
    
    -- update minimum and maximum phase values
    calc_min_max : process(clk_sys_i)
    begin
        if rising_edge(clk_sys_i) then
            if (reset_i = '1') then
                phase_min <= (others => '1');
                phase_max <= (others => '0');
            else
                if (phase_avg_p = '1') then
                    
                    if (phase_avg > phase_max) then
                        phase_max <= phase_avg;
                    end if;
                    
                    if (phase_avg < phase_min) then
                        phase_min <= phase_avg;
                    end if;
                    
                end if;
            end if;
        end if;
    end process;

    phase_jump_cnt_o <= std_logic_vector(phase_jump_cnt);
    
    -- monitor for phase jumps
    jump_monitor : process(clk_sys_i)
        variable phase_higher    : unsigned(g_counter_bits - 1 downto 0);
        variable phase_lower     : unsigned(g_counter_bits - 1 downto 0);
        variable phase_diff      : unsigned(g_counter_bits - 1 downto 0);
        variable phase_diff_wrap : unsigned(g_counter_bits - 1 downto 0);
    begin
        if (rising_edge(clk_sys_i)) then
            if (reset_i = '1') then
                dv_prev <= '0';
                phase_jump_cnt <= (others => '0');
            else
                phase_jump_thresh <= unsigned(phase_jump_thresh_i);
                
                if (phase_avg_p = '1') then
                    dv_prev <= '1';
                    phase_avg_prev <= phase_avg;
                    
                    if (phase_avg > phase_avg_prev) then
                        phase_higher := unsigned(phase_avg);
                        phase_lower := unsigned(phase_avg_prev);
                    else
                        phase_higher := unsigned(phase_avg_prev);
                        phase_lower := unsigned(phase_avg);
                    end if;

                    phase_diff := phase_higher - phase_lower;
                    phase_diff_wrap := to_unsigned(g_max_valid_phase, g_counter_bits) - phase_higher + phase_lower;

                    if (dv_prev = '1' and phase_diff > phase_jump_thresh and phase_diff_wrap > phase_jump_thresh) then
                        phase_jump_cnt <= phase_jump_cnt + 1;
                    end if;

                end if;
            end if;
        end if;
    end process;
    
end syn;