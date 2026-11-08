library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity lsq_ga_G2_LE16_SE16_LP0_SP0 is
	port(
		rst : in std_logic;
		clk : in std_logic;
		group_init_valid_0_i : in std_logic;
		group_init_valid_1_i : in std_logic;
		group_init_ready_0_o : out std_logic;
		group_init_ready_1_o : out std_logic;
		ldq_tail_i : in std_logic_vector(3 downto 0);
		ldq_head_i : in std_logic_vector(3 downto 0);
		ldq_empty_i : in std_logic;
		stq_tail_i : in std_logic_vector(3 downto 0);
		stq_head_i : in std_logic_vector(3 downto 0);
		stq_empty_i : in std_logic;
		ldq_wen_0_o : out std_logic;
		ldq_wen_1_o : out std_logic;
		ldq_wen_2_o : out std_logic;
		ldq_wen_3_o : out std_logic;
		ldq_wen_4_o : out std_logic;
		ldq_wen_5_o : out std_logic;
		ldq_wen_6_o : out std_logic;
		ldq_wen_7_o : out std_logic;
		ldq_wen_8_o : out std_logic;
		ldq_wen_9_o : out std_logic;
		ldq_wen_10_o : out std_logic;
		ldq_wen_11_o : out std_logic;
		ldq_wen_12_o : out std_logic;
		ldq_wen_13_o : out std_logic;
		ldq_wen_14_o : out std_logic;
		ldq_wen_15_o : out std_logic;
		num_loads_o : out std_logic_vector(3 downto 0);
		stq_wen_0_o : out std_logic;
		stq_wen_1_o : out std_logic;
		stq_wen_2_o : out std_logic;
		stq_wen_3_o : out std_logic;
		stq_wen_4_o : out std_logic;
		stq_wen_5_o : out std_logic;
		stq_wen_6_o : out std_logic;
		stq_wen_7_o : out std_logic;
		stq_wen_8_o : out std_logic;
		stq_wen_9_o : out std_logic;
		stq_wen_10_o : out std_logic;
		stq_wen_11_o : out std_logic;
		stq_wen_12_o : out std_logic;
		stq_wen_13_o : out std_logic;
		stq_wen_14_o : out std_logic;
		stq_wen_15_o : out std_logic;
		num_stores_o : out std_logic_vector(3 downto 0);
		ga_ls_order_0_o : out std_logic_vector(15 downto 0);
		ga_ls_order_1_o : out std_logic_vector(15 downto 0);
		ga_ls_order_2_o : out std_logic_vector(15 downto 0);
		ga_ls_order_3_o : out std_logic_vector(15 downto 0);
		ga_ls_order_4_o : out std_logic_vector(15 downto 0);
		ga_ls_order_5_o : out std_logic_vector(15 downto 0);
		ga_ls_order_6_o : out std_logic_vector(15 downto 0);
		ga_ls_order_7_o : out std_logic_vector(15 downto 0);
		ga_ls_order_8_o : out std_logic_vector(15 downto 0);
		ga_ls_order_9_o : out std_logic_vector(15 downto 0);
		ga_ls_order_10_o : out std_logic_vector(15 downto 0);
		ga_ls_order_11_o : out std_logic_vector(15 downto 0);
		ga_ls_order_12_o : out std_logic_vector(15 downto 0);
		ga_ls_order_13_o : out std_logic_vector(15 downto 0);
		ga_ls_order_14_o : out std_logic_vector(15 downto 0);
		ga_ls_order_15_o : out std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of lsq_ga_G2_LE16_SE16_LP0_SP0 is
	attribute DONT_TOUCH : string;
	signal num_loads : std_logic_vector(3 downto 0);
	signal num_stores : std_logic_vector(3 downto 0);
	signal loads_sub : std_logic_vector(3 downto 0);
	signal stores_sub : std_logic_vector(3 downto 0);
	signal empty_loads : std_logic_vector(4 downto 0);
	signal empty_stores : std_logic_vector(4 downto 0);
	signal group_init_ready_0 : std_logic;
	signal group_init_ready_1 : std_logic;
	signal group_init_hs_0 : std_logic;
	signal group_init_hs_1 : std_logic;
	signal thr_ld_ok_0 : std_logic;
	signal thr_ld_ok_1 : std_logic;
	signal thr_st_ok_0 : std_logic;
	signal thr_st_ok_1 : std_logic;
	attribute DONT_TOUCH of thr_ld_0 : label is "TRUE";
	attribute DONT_TOUCH of thr_st_0 : label is "TRUE";
	attribute DONT_TOUCH of thr_ld_1 : label is "TRUE";
	attribute DONT_TOUCH of thr_st_1 : label is "TRUE";
	signal ga_idx : std_logic_vector(4 downto 0);
	signal ga_any : std_logic;
	signal ga_ls_order_rom_0 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_1 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_2 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_3 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_4 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_5 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_6 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_7 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_8 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_9 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_10 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_11 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_12 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_13 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_14 : std_logic_vector(15 downto 0);
	signal ga_ls_order_rom_15 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_0 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_1 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_2 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_3 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_4 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_5 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_6 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_7 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_8 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_9 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_10 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_11 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_12 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_13 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_14 : std_logic_vector(15 downto 0);
	signal ga_ls_order_temp_15 : std_logic_vector(15 downto 0);
	attribute DONT_TOUCH of tbl_lsorder_0_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_0_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_1_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_2_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_3_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_4_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_5_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_6_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_7_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_8_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_9_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_10_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_11_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_12_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_13_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_14_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b4 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b5 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b6 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b7 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b8 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b9 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b10 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b11 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b12 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b13 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b14 : label is "TRUE";
	attribute DONT_TOUCH of tbl_lsorder_15_b15 : label is "TRUE";
	attribute DONT_TOUCH of tbl_nld_0_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_nld_0_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_nld_0_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_nld_0_b3 : label is "TRUE";
	attribute DONT_TOUCH of tbl_nst_0_b0 : label is "TRUE";
	attribute DONT_TOUCH of tbl_nst_0_b1 : label is "TRUE";
	attribute DONT_TOUCH of tbl_nst_0_b2 : label is "TRUE";
	attribute DONT_TOUCH of tbl_nst_0_b3 : label is "TRUE";
	signal ldq_wen_unshifted_0 : std_logic;
	signal ldq_wen_unshifted_1 : std_logic;
	signal ldq_wen_unshifted_2 : std_logic;
	signal ldq_wen_unshifted_3 : std_logic;
	signal ldq_wen_unshifted_4 : std_logic;
	signal ldq_wen_unshifted_5 : std_logic;
	signal ldq_wen_unshifted_6 : std_logic;
	signal ldq_wen_unshifted_7 : std_logic;
	signal ldq_wen_unshifted_8 : std_logic;
	signal ldq_wen_unshifted_9 : std_logic;
	signal ldq_wen_unshifted_10 : std_logic;
	signal ldq_wen_unshifted_11 : std_logic;
	signal ldq_wen_unshifted_12 : std_logic;
	signal ldq_wen_unshifted_13 : std_logic;
	signal ldq_wen_unshifted_14 : std_logic;
	signal ldq_wen_unshifted_15 : std_logic;
	signal stq_wen_unshifted_0 : std_logic;
	signal stq_wen_unshifted_1 : std_logic;
	signal stq_wen_unshifted_2 : std_logic;
	signal stq_wen_unshifted_3 : std_logic;
	signal stq_wen_unshifted_4 : std_logic;
	signal stq_wen_unshifted_5 : std_logic;
	signal stq_wen_unshifted_6 : std_logic;
	signal stq_wen_unshifted_7 : std_logic;
	signal stq_wen_unshifted_8 : std_logic;
	signal stq_wen_unshifted_9 : std_logic;
	signal stq_wen_unshifted_10 : std_logic;
	signal stq_wen_unshifted_11 : std_logic;
	signal stq_wen_unshifted_12 : std_logic;
	signal stq_wen_unshifted_13 : std_logic;
	signal stq_wen_unshifted_14 : std_logic;
	signal stq_wen_unshifted_15 : std_logic;
	signal TEMP_1_res_0 : std_logic;
	signal TEMP_1_res_1 : std_logic;
	signal TEMP_1_res_2 : std_logic;
	signal TEMP_1_res_3 : std_logic;
	signal TEMP_1_res_4 : std_logic;
	signal TEMP_1_res_5 : std_logic;
	signal TEMP_1_res_6 : std_logic;
	signal TEMP_1_res_7 : std_logic;
	signal TEMP_1_res_8 : std_logic;
	signal TEMP_1_res_9 : std_logic;
	signal TEMP_1_res_10 : std_logic;
	signal TEMP_1_res_11 : std_logic;
	signal TEMP_1_res_12 : std_logic;
	signal TEMP_1_res_13 : std_logic;
	signal TEMP_1_res_14 : std_logic;
	signal TEMP_1_res_15 : std_logic;
	signal TEMP_2_res_0 : std_logic;
	signal TEMP_2_res_1 : std_logic;
	signal TEMP_2_res_2 : std_logic;
	signal TEMP_2_res_3 : std_logic;
	signal TEMP_2_res_4 : std_logic;
	signal TEMP_2_res_5 : std_logic;
	signal TEMP_2_res_6 : std_logic;
	signal TEMP_2_res_7 : std_logic;
	signal TEMP_2_res_8 : std_logic;
	signal TEMP_2_res_9 : std_logic;
	signal TEMP_2_res_10 : std_logic;
	signal TEMP_2_res_11 : std_logic;
	signal TEMP_2_res_12 : std_logic;
	signal TEMP_2_res_13 : std_logic;
	signal TEMP_2_res_14 : std_logic;
	signal TEMP_2_res_15 : std_logic;
	signal TEMP_3_res_0 : std_logic;
	signal TEMP_3_res_1 : std_logic;
	signal TEMP_3_res_2 : std_logic;
	signal TEMP_3_res_3 : std_logic;
	signal TEMP_3_res_4 : std_logic;
	signal TEMP_3_res_5 : std_logic;
	signal TEMP_3_res_6 : std_logic;
	signal TEMP_3_res_7 : std_logic;
	signal TEMP_3_res_8 : std_logic;
	signal TEMP_3_res_9 : std_logic;
	signal TEMP_3_res_10 : std_logic;
	signal TEMP_3_res_11 : std_logic;
	signal TEMP_3_res_12 : std_logic;
	signal TEMP_3_res_13 : std_logic;
	signal TEMP_3_res_14 : std_logic;
	signal TEMP_3_res_15 : std_logic;
	signal TEMP_4_res_0 : std_logic;
	signal TEMP_4_res_1 : std_logic;
	signal TEMP_4_res_2 : std_logic;
	signal TEMP_4_res_3 : std_logic;
	signal TEMP_4_res_4 : std_logic;
	signal TEMP_4_res_5 : std_logic;
	signal TEMP_4_res_6 : std_logic;
	signal TEMP_4_res_7 : std_logic;
	signal TEMP_4_res_8 : std_logic;
	signal TEMP_4_res_9 : std_logic;
	signal TEMP_4_res_10 : std_logic;
	signal TEMP_4_res_11 : std_logic;
	signal TEMP_4_res_12 : std_logic;
	signal TEMP_4_res_13 : std_logic;
	signal TEMP_4_res_14 : std_logic;
	signal TEMP_4_res_15 : std_logic;
	signal TEMP_5_res_0 : std_logic;
	signal TEMP_5_res_1 : std_logic;
	signal TEMP_5_res_2 : std_logic;
	signal TEMP_5_res_3 : std_logic;
	signal TEMP_5_res_4 : std_logic;
	signal TEMP_5_res_5 : std_logic;
	signal TEMP_5_res_6 : std_logic;
	signal TEMP_5_res_7 : std_logic;
	signal TEMP_5_res_8 : std_logic;
	signal TEMP_5_res_9 : std_logic;
	signal TEMP_5_res_10 : std_logic;
	signal TEMP_5_res_11 : std_logic;
	signal TEMP_5_res_12 : std_logic;
	signal TEMP_5_res_13 : std_logic;
	signal TEMP_5_res_14 : std_logic;
	signal TEMP_5_res_15 : std_logic;
	signal TEMP_6_res_0 : std_logic;
	signal TEMP_6_res_1 : std_logic;
	signal TEMP_6_res_2 : std_logic;
	signal TEMP_6_res_3 : std_logic;
	signal TEMP_6_res_4 : std_logic;
	signal TEMP_6_res_5 : std_logic;
	signal TEMP_6_res_6 : std_logic;
	signal TEMP_6_res_7 : std_logic;
	signal TEMP_6_res_8 : std_logic;
	signal TEMP_6_res_9 : std_logic;
	signal TEMP_6_res_10 : std_logic;
	signal TEMP_6_res_11 : std_logic;
	signal TEMP_6_res_12 : std_logic;
	signal TEMP_6_res_13 : std_logic;
	signal TEMP_6_res_14 : std_logic;
	signal TEMP_6_res_15 : std_logic;
	signal TEMP_7_res : std_logic_vector(15 downto 0);
	signal TEMP_8_res : std_logic_vector(15 downto 0);
	signal TEMP_9_res : std_logic_vector(15 downto 0);
	signal TEMP_10_res : std_logic_vector(15 downto 0);
	signal TEMP_11_res : std_logic_vector(15 downto 0);
	signal TEMP_12_res : std_logic_vector(15 downto 0);
	signal TEMP_13_res : std_logic_vector(15 downto 0);
	signal TEMP_14_res : std_logic_vector(15 downto 0);
	signal TEMP_15_res : std_logic_vector(15 downto 0);
	signal TEMP_16_res : std_logic_vector(15 downto 0);
	signal TEMP_17_res : std_logic_vector(15 downto 0);
	signal TEMP_18_res : std_logic_vector(15 downto 0);
	signal TEMP_19_res : std_logic_vector(15 downto 0);
	signal TEMP_20_res : std_logic_vector(15 downto 0);
	signal TEMP_21_res : std_logic_vector(15 downto 0);
	signal TEMP_22_res : std_logic_vector(15 downto 0);
	signal TEMP_23_res : std_logic_vector(15 downto 0);
	signal TEMP_24_res : std_logic_vector(15 downto 0);
	signal TEMP_25_res : std_logic_vector(15 downto 0);
	signal TEMP_26_res : std_logic_vector(15 downto 0);
	signal TEMP_27_res : std_logic_vector(15 downto 0);
	signal TEMP_28_res : std_logic_vector(15 downto 0);
	signal TEMP_29_res : std_logic_vector(15 downto 0);
	signal TEMP_30_res : std_logic_vector(15 downto 0);
	signal TEMP_31_res : std_logic_vector(15 downto 0);
	signal TEMP_32_res : std_logic_vector(15 downto 0);
	signal TEMP_33_res : std_logic_vector(15 downto 0);
	signal TEMP_34_res : std_logic_vector(15 downto 0);
	signal TEMP_35_res : std_logic_vector(15 downto 0);
	signal TEMP_36_res : std_logic_vector(15 downto 0);
	signal TEMP_37_res : std_logic_vector(15 downto 0);
	signal TEMP_38_res : std_logic_vector(15 downto 0);
	signal TEMP_39_res : std_logic_vector(15 downto 0);
	signal TEMP_40_res : std_logic_vector(15 downto 0);
	signal TEMP_41_res : std_logic_vector(15 downto 0);
	signal TEMP_42_res : std_logic_vector(15 downto 0);
	signal TEMP_43_res : std_logic_vector(15 downto 0);
	signal TEMP_44_res : std_logic_vector(15 downto 0);
	signal TEMP_45_res : std_logic_vector(15 downto 0);
	signal TEMP_46_res : std_logic_vector(15 downto 0);
	signal TEMP_47_res : std_logic_vector(15 downto 0);
	signal TEMP_48_res : std_logic_vector(15 downto 0);
	signal TEMP_49_res : std_logic_vector(15 downto 0);
	signal TEMP_50_res : std_logic_vector(15 downto 0);
	signal TEMP_51_res : std_logic_vector(15 downto 0);
	signal TEMP_52_res : std_logic_vector(15 downto 0);
	signal TEMP_53_res : std_logic_vector(15 downto 0);
	signal TEMP_54_res : std_logic_vector(15 downto 0);
	signal TEMP_55_res_0 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_1 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_2 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_3 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_4 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_5 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_6 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_7 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_8 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_9 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_10 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_11 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_12 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_13 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_14 : std_logic_vector(15 downto 0);
	signal TEMP_55_res_15 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_0 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_1 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_2 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_3 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_4 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_5 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_6 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_7 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_8 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_9 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_10 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_11 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_12 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_13 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_14 : std_logic_vector(15 downto 0);
	signal TEMP_56_res_15 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_0 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_1 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_2 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_3 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_4 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_5 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_6 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_7 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_8 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_9 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_10 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_11 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_12 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_13 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_14 : std_logic_vector(15 downto 0);
	signal TEMP_57_res_15 : std_logic_vector(15 downto 0);
begin
	-- WrapSub Begin
	-- WrapSub(loads_sub, ldq_head, ldq_tail, 16)
	loads_sub <= std_logic_vector(unsigned(ldq_head_i) - unsigned(ldq_tail_i));
	-- WrapAdd End

	-- WrapSub Begin
	-- WrapSub(stores_sub, stq_head, stq_tail, 16)
	stores_sub <= std_logic_vector(unsigned(stq_head_i) - unsigned(stq_tail_i));
	-- WrapAdd End

	empty_loads <= "10000" when ldq_empty_i else ( '0' & loads_sub );
	empty_stores <= "10000" when stq_empty_i else ( '0' & stores_sub );
	group_init_ready_0 <= thr_ld_ok_0 and thr_st_ok_0;
	group_init_ready_0_o <= group_init_ready_0;
	group_init_hs_0 <= group_init_ready_0 and group_init_valid_0_i;
	group_init_ready_1 <= thr_ld_ok_1 and thr_st_ok_1;
	group_init_ready_1_o <= group_init_ready_1;
	group_init_hs_1 <= group_init_ready_1 and group_init_valid_1_i;
	ga_idx(0) <= group_init_hs_1;
	ga_idx(1) <= '0';
	ga_idx(2) <= '0';
	ga_idx(3) <= '0';
	ga_idx(4) <= '0';
	ga_any <= group_init_hs_0 or group_init_hs_1;
	num_loads_o <= num_loads;
	num_stores_o <= num_stores;
	ldq_wen_unshifted_0 <= '1' when num_loads > "0000" else '0';
	ldq_wen_unshifted_1 <= '1' when num_loads > "0001" else '0';
	ldq_wen_unshifted_2 <= '1' when num_loads > "0010" else '0';
	ldq_wen_unshifted_3 <= '1' when num_loads > "0011" else '0';
	ldq_wen_unshifted_4 <= '1' when num_loads > "0100" else '0';
	ldq_wen_unshifted_5 <= '1' when num_loads > "0101" else '0';
	ldq_wen_unshifted_6 <= '1' when num_loads > "0110" else '0';
	ldq_wen_unshifted_7 <= '1' when num_loads > "0111" else '0';
	ldq_wen_unshifted_8 <= '1' when num_loads > "1000" else '0';
	ldq_wen_unshifted_9 <= '1' when num_loads > "1001" else '0';
	ldq_wen_unshifted_10 <= '1' when num_loads > "1010" else '0';
	ldq_wen_unshifted_11 <= '1' when num_loads > "1011" else '0';
	ldq_wen_unshifted_12 <= '1' when num_loads > "1100" else '0';
	ldq_wen_unshifted_13 <= '1' when num_loads > "1101" else '0';
	ldq_wen_unshifted_14 <= '1' when num_loads > "1110" else '0';
	ldq_wen_unshifted_15 <= '1' when num_loads > "1111" else '0';
	stq_wen_unshifted_0 <= '1' when num_stores > "0000" else '0';
	stq_wen_unshifted_1 <= '1' when num_stores > "0001" else '0';
	stq_wen_unshifted_2 <= '1' when num_stores > "0010" else '0';
	stq_wen_unshifted_3 <= '1' when num_stores > "0011" else '0';
	stq_wen_unshifted_4 <= '1' when num_stores > "0100" else '0';
	stq_wen_unshifted_5 <= '1' when num_stores > "0101" else '0';
	stq_wen_unshifted_6 <= '1' when num_stores > "0110" else '0';
	stq_wen_unshifted_7 <= '1' when num_stores > "0111" else '0';
	stq_wen_unshifted_8 <= '1' when num_stores > "1000" else '0';
	stq_wen_unshifted_9 <= '1' when num_stores > "1001" else '0';
	stq_wen_unshifted_10 <= '1' when num_stores > "1010" else '0';
	stq_wen_unshifted_11 <= '1' when num_stores > "1011" else '0';
	stq_wen_unshifted_12 <= '1' when num_stores > "1100" else '0';
	stq_wen_unshifted_13 <= '1' when num_stores > "1101" else '0';
	stq_wen_unshifted_14 <= '1' when num_stores > "1110" else '0';
	stq_wen_unshifted_15 <= '1' when num_stores > "1111" else '0';
	-- Shifter Begin
	-- CyclicLeftShift(ldq_wen, ldq_wen_unshifted, ldq_tail)
	TEMP_1_res_0 <= ldq_wen_unshifted_8 when ldq_tail_i(3) else ldq_wen_unshifted_0;
	TEMP_1_res_1 <= ldq_wen_unshifted_9 when ldq_tail_i(3) else ldq_wen_unshifted_1;
	TEMP_1_res_2 <= ldq_wen_unshifted_10 when ldq_tail_i(3) else ldq_wen_unshifted_2;
	TEMP_1_res_3 <= ldq_wen_unshifted_11 when ldq_tail_i(3) else ldq_wen_unshifted_3;
	TEMP_1_res_4 <= ldq_wen_unshifted_12 when ldq_tail_i(3) else ldq_wen_unshifted_4;
	TEMP_1_res_5 <= ldq_wen_unshifted_13 when ldq_tail_i(3) else ldq_wen_unshifted_5;
	TEMP_1_res_6 <= ldq_wen_unshifted_14 when ldq_tail_i(3) else ldq_wen_unshifted_6;
	TEMP_1_res_7 <= ldq_wen_unshifted_15 when ldq_tail_i(3) else ldq_wen_unshifted_7;
	TEMP_1_res_8 <= ldq_wen_unshifted_0 when ldq_tail_i(3) else ldq_wen_unshifted_8;
	TEMP_1_res_9 <= ldq_wen_unshifted_1 when ldq_tail_i(3) else ldq_wen_unshifted_9;
	TEMP_1_res_10 <= ldq_wen_unshifted_2 when ldq_tail_i(3) else ldq_wen_unshifted_10;
	TEMP_1_res_11 <= ldq_wen_unshifted_3 when ldq_tail_i(3) else ldq_wen_unshifted_11;
	TEMP_1_res_12 <= ldq_wen_unshifted_4 when ldq_tail_i(3) else ldq_wen_unshifted_12;
	TEMP_1_res_13 <= ldq_wen_unshifted_5 when ldq_tail_i(3) else ldq_wen_unshifted_13;
	TEMP_1_res_14 <= ldq_wen_unshifted_6 when ldq_tail_i(3) else ldq_wen_unshifted_14;
	TEMP_1_res_15 <= ldq_wen_unshifted_7 when ldq_tail_i(3) else ldq_wen_unshifted_15;
	-- Layer End
	TEMP_2_res_0 <= TEMP_1_res_12 when ldq_tail_i(2) else TEMP_1_res_0;
	TEMP_2_res_1 <= TEMP_1_res_13 when ldq_tail_i(2) else TEMP_1_res_1;
	TEMP_2_res_2 <= TEMP_1_res_14 when ldq_tail_i(2) else TEMP_1_res_2;
	TEMP_2_res_3 <= TEMP_1_res_15 when ldq_tail_i(2) else TEMP_1_res_3;
	TEMP_2_res_4 <= TEMP_1_res_0 when ldq_tail_i(2) else TEMP_1_res_4;
	TEMP_2_res_5 <= TEMP_1_res_1 when ldq_tail_i(2) else TEMP_1_res_5;
	TEMP_2_res_6 <= TEMP_1_res_2 when ldq_tail_i(2) else TEMP_1_res_6;
	TEMP_2_res_7 <= TEMP_1_res_3 when ldq_tail_i(2) else TEMP_1_res_7;
	TEMP_2_res_8 <= TEMP_1_res_4 when ldq_tail_i(2) else TEMP_1_res_8;
	TEMP_2_res_9 <= TEMP_1_res_5 when ldq_tail_i(2) else TEMP_1_res_9;
	TEMP_2_res_10 <= TEMP_1_res_6 when ldq_tail_i(2) else TEMP_1_res_10;
	TEMP_2_res_11 <= TEMP_1_res_7 when ldq_tail_i(2) else TEMP_1_res_11;
	TEMP_2_res_12 <= TEMP_1_res_8 when ldq_tail_i(2) else TEMP_1_res_12;
	TEMP_2_res_13 <= TEMP_1_res_9 when ldq_tail_i(2) else TEMP_1_res_13;
	TEMP_2_res_14 <= TEMP_1_res_10 when ldq_tail_i(2) else TEMP_1_res_14;
	TEMP_2_res_15 <= TEMP_1_res_11 when ldq_tail_i(2) else TEMP_1_res_15;
	-- Layer End
	TEMP_3_res_0 <= TEMP_2_res_14 when ldq_tail_i(1) else TEMP_2_res_0;
	TEMP_3_res_1 <= TEMP_2_res_15 when ldq_tail_i(1) else TEMP_2_res_1;
	TEMP_3_res_2 <= TEMP_2_res_0 when ldq_tail_i(1) else TEMP_2_res_2;
	TEMP_3_res_3 <= TEMP_2_res_1 when ldq_tail_i(1) else TEMP_2_res_3;
	TEMP_3_res_4 <= TEMP_2_res_2 when ldq_tail_i(1) else TEMP_2_res_4;
	TEMP_3_res_5 <= TEMP_2_res_3 when ldq_tail_i(1) else TEMP_2_res_5;
	TEMP_3_res_6 <= TEMP_2_res_4 when ldq_tail_i(1) else TEMP_2_res_6;
	TEMP_3_res_7 <= TEMP_2_res_5 when ldq_tail_i(1) else TEMP_2_res_7;
	TEMP_3_res_8 <= TEMP_2_res_6 when ldq_tail_i(1) else TEMP_2_res_8;
	TEMP_3_res_9 <= TEMP_2_res_7 when ldq_tail_i(1) else TEMP_2_res_9;
	TEMP_3_res_10 <= TEMP_2_res_8 when ldq_tail_i(1) else TEMP_2_res_10;
	TEMP_3_res_11 <= TEMP_2_res_9 when ldq_tail_i(1) else TEMP_2_res_11;
	TEMP_3_res_12 <= TEMP_2_res_10 when ldq_tail_i(1) else TEMP_2_res_12;
	TEMP_3_res_13 <= TEMP_2_res_11 when ldq_tail_i(1) else TEMP_2_res_13;
	TEMP_3_res_14 <= TEMP_2_res_12 when ldq_tail_i(1) else TEMP_2_res_14;
	TEMP_3_res_15 <= TEMP_2_res_13 when ldq_tail_i(1) else TEMP_2_res_15;
	-- Layer End
	ldq_wen_0_o <= TEMP_3_res_15 when ldq_tail_i(0) else TEMP_3_res_0;
	ldq_wen_1_o <= TEMP_3_res_0 when ldq_tail_i(0) else TEMP_3_res_1;
	ldq_wen_2_o <= TEMP_3_res_1 when ldq_tail_i(0) else TEMP_3_res_2;
	ldq_wen_3_o <= TEMP_3_res_2 when ldq_tail_i(0) else TEMP_3_res_3;
	ldq_wen_4_o <= TEMP_3_res_3 when ldq_tail_i(0) else TEMP_3_res_4;
	ldq_wen_5_o <= TEMP_3_res_4 when ldq_tail_i(0) else TEMP_3_res_5;
	ldq_wen_6_o <= TEMP_3_res_5 when ldq_tail_i(0) else TEMP_3_res_6;
	ldq_wen_7_o <= TEMP_3_res_6 when ldq_tail_i(0) else TEMP_3_res_7;
	ldq_wen_8_o <= TEMP_3_res_7 when ldq_tail_i(0) else TEMP_3_res_8;
	ldq_wen_9_o <= TEMP_3_res_8 when ldq_tail_i(0) else TEMP_3_res_9;
	ldq_wen_10_o <= TEMP_3_res_9 when ldq_tail_i(0) else TEMP_3_res_10;
	ldq_wen_11_o <= TEMP_3_res_10 when ldq_tail_i(0) else TEMP_3_res_11;
	ldq_wen_12_o <= TEMP_3_res_11 when ldq_tail_i(0) else TEMP_3_res_12;
	ldq_wen_13_o <= TEMP_3_res_12 when ldq_tail_i(0) else TEMP_3_res_13;
	ldq_wen_14_o <= TEMP_3_res_13 when ldq_tail_i(0) else TEMP_3_res_14;
	ldq_wen_15_o <= TEMP_3_res_14 when ldq_tail_i(0) else TEMP_3_res_15;
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(stq_wen, stq_wen_unshifted, stq_tail)
	TEMP_4_res_0 <= stq_wen_unshifted_8 when stq_tail_i(3) else stq_wen_unshifted_0;
	TEMP_4_res_1 <= stq_wen_unshifted_9 when stq_tail_i(3) else stq_wen_unshifted_1;
	TEMP_4_res_2 <= stq_wen_unshifted_10 when stq_tail_i(3) else stq_wen_unshifted_2;
	TEMP_4_res_3 <= stq_wen_unshifted_11 when stq_tail_i(3) else stq_wen_unshifted_3;
	TEMP_4_res_4 <= stq_wen_unshifted_12 when stq_tail_i(3) else stq_wen_unshifted_4;
	TEMP_4_res_5 <= stq_wen_unshifted_13 when stq_tail_i(3) else stq_wen_unshifted_5;
	TEMP_4_res_6 <= stq_wen_unshifted_14 when stq_tail_i(3) else stq_wen_unshifted_6;
	TEMP_4_res_7 <= stq_wen_unshifted_15 when stq_tail_i(3) else stq_wen_unshifted_7;
	TEMP_4_res_8 <= stq_wen_unshifted_0 when stq_tail_i(3) else stq_wen_unshifted_8;
	TEMP_4_res_9 <= stq_wen_unshifted_1 when stq_tail_i(3) else stq_wen_unshifted_9;
	TEMP_4_res_10 <= stq_wen_unshifted_2 when stq_tail_i(3) else stq_wen_unshifted_10;
	TEMP_4_res_11 <= stq_wen_unshifted_3 when stq_tail_i(3) else stq_wen_unshifted_11;
	TEMP_4_res_12 <= stq_wen_unshifted_4 when stq_tail_i(3) else stq_wen_unshifted_12;
	TEMP_4_res_13 <= stq_wen_unshifted_5 when stq_tail_i(3) else stq_wen_unshifted_13;
	TEMP_4_res_14 <= stq_wen_unshifted_6 when stq_tail_i(3) else stq_wen_unshifted_14;
	TEMP_4_res_15 <= stq_wen_unshifted_7 when stq_tail_i(3) else stq_wen_unshifted_15;
	-- Layer End
	TEMP_5_res_0 <= TEMP_4_res_12 when stq_tail_i(2) else TEMP_4_res_0;
	TEMP_5_res_1 <= TEMP_4_res_13 when stq_tail_i(2) else TEMP_4_res_1;
	TEMP_5_res_2 <= TEMP_4_res_14 when stq_tail_i(2) else TEMP_4_res_2;
	TEMP_5_res_3 <= TEMP_4_res_15 when stq_tail_i(2) else TEMP_4_res_3;
	TEMP_5_res_4 <= TEMP_4_res_0 when stq_tail_i(2) else TEMP_4_res_4;
	TEMP_5_res_5 <= TEMP_4_res_1 when stq_tail_i(2) else TEMP_4_res_5;
	TEMP_5_res_6 <= TEMP_4_res_2 when stq_tail_i(2) else TEMP_4_res_6;
	TEMP_5_res_7 <= TEMP_4_res_3 when stq_tail_i(2) else TEMP_4_res_7;
	TEMP_5_res_8 <= TEMP_4_res_4 when stq_tail_i(2) else TEMP_4_res_8;
	TEMP_5_res_9 <= TEMP_4_res_5 when stq_tail_i(2) else TEMP_4_res_9;
	TEMP_5_res_10 <= TEMP_4_res_6 when stq_tail_i(2) else TEMP_4_res_10;
	TEMP_5_res_11 <= TEMP_4_res_7 when stq_tail_i(2) else TEMP_4_res_11;
	TEMP_5_res_12 <= TEMP_4_res_8 when stq_tail_i(2) else TEMP_4_res_12;
	TEMP_5_res_13 <= TEMP_4_res_9 when stq_tail_i(2) else TEMP_4_res_13;
	TEMP_5_res_14 <= TEMP_4_res_10 when stq_tail_i(2) else TEMP_4_res_14;
	TEMP_5_res_15 <= TEMP_4_res_11 when stq_tail_i(2) else TEMP_4_res_15;
	-- Layer End
	TEMP_6_res_0 <= TEMP_5_res_14 when stq_tail_i(1) else TEMP_5_res_0;
	TEMP_6_res_1 <= TEMP_5_res_15 when stq_tail_i(1) else TEMP_5_res_1;
	TEMP_6_res_2 <= TEMP_5_res_0 when stq_tail_i(1) else TEMP_5_res_2;
	TEMP_6_res_3 <= TEMP_5_res_1 when stq_tail_i(1) else TEMP_5_res_3;
	TEMP_6_res_4 <= TEMP_5_res_2 when stq_tail_i(1) else TEMP_5_res_4;
	TEMP_6_res_5 <= TEMP_5_res_3 when stq_tail_i(1) else TEMP_5_res_5;
	TEMP_6_res_6 <= TEMP_5_res_4 when stq_tail_i(1) else TEMP_5_res_6;
	TEMP_6_res_7 <= TEMP_5_res_5 when stq_tail_i(1) else TEMP_5_res_7;
	TEMP_6_res_8 <= TEMP_5_res_6 when stq_tail_i(1) else TEMP_5_res_8;
	TEMP_6_res_9 <= TEMP_5_res_7 when stq_tail_i(1) else TEMP_5_res_9;
	TEMP_6_res_10 <= TEMP_5_res_8 when stq_tail_i(1) else TEMP_5_res_10;
	TEMP_6_res_11 <= TEMP_5_res_9 when stq_tail_i(1) else TEMP_5_res_11;
	TEMP_6_res_12 <= TEMP_5_res_10 when stq_tail_i(1) else TEMP_5_res_12;
	TEMP_6_res_13 <= TEMP_5_res_11 when stq_tail_i(1) else TEMP_5_res_13;
	TEMP_6_res_14 <= TEMP_5_res_12 when stq_tail_i(1) else TEMP_5_res_14;
	TEMP_6_res_15 <= TEMP_5_res_13 when stq_tail_i(1) else TEMP_5_res_15;
	-- Layer End
	stq_wen_0_o <= TEMP_6_res_15 when stq_tail_i(0) else TEMP_6_res_0;
	stq_wen_1_o <= TEMP_6_res_0 when stq_tail_i(0) else TEMP_6_res_1;
	stq_wen_2_o <= TEMP_6_res_1 when stq_tail_i(0) else TEMP_6_res_2;
	stq_wen_3_o <= TEMP_6_res_2 when stq_tail_i(0) else TEMP_6_res_3;
	stq_wen_4_o <= TEMP_6_res_3 when stq_tail_i(0) else TEMP_6_res_4;
	stq_wen_5_o <= TEMP_6_res_4 when stq_tail_i(0) else TEMP_6_res_5;
	stq_wen_6_o <= TEMP_6_res_5 when stq_tail_i(0) else TEMP_6_res_6;
	stq_wen_7_o <= TEMP_6_res_6 when stq_tail_i(0) else TEMP_6_res_7;
	stq_wen_8_o <= TEMP_6_res_7 when stq_tail_i(0) else TEMP_6_res_8;
	stq_wen_9_o <= TEMP_6_res_8 when stq_tail_i(0) else TEMP_6_res_9;
	stq_wen_10_o <= TEMP_6_res_9 when stq_tail_i(0) else TEMP_6_res_10;
	stq_wen_11_o <= TEMP_6_res_10 when stq_tail_i(0) else TEMP_6_res_11;
	stq_wen_12_o <= TEMP_6_res_11 when stq_tail_i(0) else TEMP_6_res_12;
	stq_wen_13_o <= TEMP_6_res_12 when stq_tail_i(0) else TEMP_6_res_13;
	stq_wen_14_o <= TEMP_6_res_13 when stq_tail_i(0) else TEMP_6_res_14;
	stq_wen_15_o <= TEMP_6_res_14 when stq_tail_i(0) else TEMP_6_res_15;
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_0, ga_ls_order_rom_0, stq_tail)
	TEMP_7_res(0) <= ga_ls_order_rom_0(8) when stq_tail_i(3) else ga_ls_order_rom_0(0);
	TEMP_7_res(1) <= ga_ls_order_rom_0(9) when stq_tail_i(3) else ga_ls_order_rom_0(1);
	TEMP_7_res(2) <= ga_ls_order_rom_0(10) when stq_tail_i(3) else ga_ls_order_rom_0(2);
	TEMP_7_res(3) <= ga_ls_order_rom_0(11) when stq_tail_i(3) else ga_ls_order_rom_0(3);
	TEMP_7_res(4) <= ga_ls_order_rom_0(12) when stq_tail_i(3) else ga_ls_order_rom_0(4);
	TEMP_7_res(5) <= ga_ls_order_rom_0(13) when stq_tail_i(3) else ga_ls_order_rom_0(5);
	TEMP_7_res(6) <= ga_ls_order_rom_0(14) when stq_tail_i(3) else ga_ls_order_rom_0(6);
	TEMP_7_res(7) <= ga_ls_order_rom_0(15) when stq_tail_i(3) else ga_ls_order_rom_0(7);
	TEMP_7_res(8) <= ga_ls_order_rom_0(0) when stq_tail_i(3) else ga_ls_order_rom_0(8);
	TEMP_7_res(9) <= ga_ls_order_rom_0(1) when stq_tail_i(3) else ga_ls_order_rom_0(9);
	TEMP_7_res(10) <= ga_ls_order_rom_0(2) when stq_tail_i(3) else ga_ls_order_rom_0(10);
	TEMP_7_res(11) <= ga_ls_order_rom_0(3) when stq_tail_i(3) else ga_ls_order_rom_0(11);
	TEMP_7_res(12) <= ga_ls_order_rom_0(4) when stq_tail_i(3) else ga_ls_order_rom_0(12);
	TEMP_7_res(13) <= ga_ls_order_rom_0(5) when stq_tail_i(3) else ga_ls_order_rom_0(13);
	TEMP_7_res(14) <= ga_ls_order_rom_0(6) when stq_tail_i(3) else ga_ls_order_rom_0(14);
	TEMP_7_res(15) <= ga_ls_order_rom_0(7) when stq_tail_i(3) else ga_ls_order_rom_0(15);
	-- Layer End
	TEMP_8_res(0) <= TEMP_7_res(12) when stq_tail_i(2) else TEMP_7_res(0);
	TEMP_8_res(1) <= TEMP_7_res(13) when stq_tail_i(2) else TEMP_7_res(1);
	TEMP_8_res(2) <= TEMP_7_res(14) when stq_tail_i(2) else TEMP_7_res(2);
	TEMP_8_res(3) <= TEMP_7_res(15) when stq_tail_i(2) else TEMP_7_res(3);
	TEMP_8_res(4) <= TEMP_7_res(0) when stq_tail_i(2) else TEMP_7_res(4);
	TEMP_8_res(5) <= TEMP_7_res(1) when stq_tail_i(2) else TEMP_7_res(5);
	TEMP_8_res(6) <= TEMP_7_res(2) when stq_tail_i(2) else TEMP_7_res(6);
	TEMP_8_res(7) <= TEMP_7_res(3) when stq_tail_i(2) else TEMP_7_res(7);
	TEMP_8_res(8) <= TEMP_7_res(4) when stq_tail_i(2) else TEMP_7_res(8);
	TEMP_8_res(9) <= TEMP_7_res(5) when stq_tail_i(2) else TEMP_7_res(9);
	TEMP_8_res(10) <= TEMP_7_res(6) when stq_tail_i(2) else TEMP_7_res(10);
	TEMP_8_res(11) <= TEMP_7_res(7) when stq_tail_i(2) else TEMP_7_res(11);
	TEMP_8_res(12) <= TEMP_7_res(8) when stq_tail_i(2) else TEMP_7_res(12);
	TEMP_8_res(13) <= TEMP_7_res(9) when stq_tail_i(2) else TEMP_7_res(13);
	TEMP_8_res(14) <= TEMP_7_res(10) when stq_tail_i(2) else TEMP_7_res(14);
	TEMP_8_res(15) <= TEMP_7_res(11) when stq_tail_i(2) else TEMP_7_res(15);
	-- Layer End
	TEMP_9_res(0) <= TEMP_8_res(14) when stq_tail_i(1) else TEMP_8_res(0);
	TEMP_9_res(1) <= TEMP_8_res(15) when stq_tail_i(1) else TEMP_8_res(1);
	TEMP_9_res(2) <= TEMP_8_res(0) when stq_tail_i(1) else TEMP_8_res(2);
	TEMP_9_res(3) <= TEMP_8_res(1) when stq_tail_i(1) else TEMP_8_res(3);
	TEMP_9_res(4) <= TEMP_8_res(2) when stq_tail_i(1) else TEMP_8_res(4);
	TEMP_9_res(5) <= TEMP_8_res(3) when stq_tail_i(1) else TEMP_8_res(5);
	TEMP_9_res(6) <= TEMP_8_res(4) when stq_tail_i(1) else TEMP_8_res(6);
	TEMP_9_res(7) <= TEMP_8_res(5) when stq_tail_i(1) else TEMP_8_res(7);
	TEMP_9_res(8) <= TEMP_8_res(6) when stq_tail_i(1) else TEMP_8_res(8);
	TEMP_9_res(9) <= TEMP_8_res(7) when stq_tail_i(1) else TEMP_8_res(9);
	TEMP_9_res(10) <= TEMP_8_res(8) when stq_tail_i(1) else TEMP_8_res(10);
	TEMP_9_res(11) <= TEMP_8_res(9) when stq_tail_i(1) else TEMP_8_res(11);
	TEMP_9_res(12) <= TEMP_8_res(10) when stq_tail_i(1) else TEMP_8_res(12);
	TEMP_9_res(13) <= TEMP_8_res(11) when stq_tail_i(1) else TEMP_8_res(13);
	TEMP_9_res(14) <= TEMP_8_res(12) when stq_tail_i(1) else TEMP_8_res(14);
	TEMP_9_res(15) <= TEMP_8_res(13) when stq_tail_i(1) else TEMP_8_res(15);
	-- Layer End
	ga_ls_order_temp_0(0) <= TEMP_9_res(15) when stq_tail_i(0) else TEMP_9_res(0);
	ga_ls_order_temp_0(1) <= TEMP_9_res(0) when stq_tail_i(0) else TEMP_9_res(1);
	ga_ls_order_temp_0(2) <= TEMP_9_res(1) when stq_tail_i(0) else TEMP_9_res(2);
	ga_ls_order_temp_0(3) <= TEMP_9_res(2) when stq_tail_i(0) else TEMP_9_res(3);
	ga_ls_order_temp_0(4) <= TEMP_9_res(3) when stq_tail_i(0) else TEMP_9_res(4);
	ga_ls_order_temp_0(5) <= TEMP_9_res(4) when stq_tail_i(0) else TEMP_9_res(5);
	ga_ls_order_temp_0(6) <= TEMP_9_res(5) when stq_tail_i(0) else TEMP_9_res(6);
	ga_ls_order_temp_0(7) <= TEMP_9_res(6) when stq_tail_i(0) else TEMP_9_res(7);
	ga_ls_order_temp_0(8) <= TEMP_9_res(7) when stq_tail_i(0) else TEMP_9_res(8);
	ga_ls_order_temp_0(9) <= TEMP_9_res(8) when stq_tail_i(0) else TEMP_9_res(9);
	ga_ls_order_temp_0(10) <= TEMP_9_res(9) when stq_tail_i(0) else TEMP_9_res(10);
	ga_ls_order_temp_0(11) <= TEMP_9_res(10) when stq_tail_i(0) else TEMP_9_res(11);
	ga_ls_order_temp_0(12) <= TEMP_9_res(11) when stq_tail_i(0) else TEMP_9_res(12);
	ga_ls_order_temp_0(13) <= TEMP_9_res(12) when stq_tail_i(0) else TEMP_9_res(13);
	ga_ls_order_temp_0(14) <= TEMP_9_res(13) when stq_tail_i(0) else TEMP_9_res(14);
	ga_ls_order_temp_0(15) <= TEMP_9_res(14) when stq_tail_i(0) else TEMP_9_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_1, ga_ls_order_rom_1, stq_tail)
	TEMP_10_res(0) <= ga_ls_order_rom_1(8) when stq_tail_i(3) else ga_ls_order_rom_1(0);
	TEMP_10_res(1) <= ga_ls_order_rom_1(9) when stq_tail_i(3) else ga_ls_order_rom_1(1);
	TEMP_10_res(2) <= ga_ls_order_rom_1(10) when stq_tail_i(3) else ga_ls_order_rom_1(2);
	TEMP_10_res(3) <= ga_ls_order_rom_1(11) when stq_tail_i(3) else ga_ls_order_rom_1(3);
	TEMP_10_res(4) <= ga_ls_order_rom_1(12) when stq_tail_i(3) else ga_ls_order_rom_1(4);
	TEMP_10_res(5) <= ga_ls_order_rom_1(13) when stq_tail_i(3) else ga_ls_order_rom_1(5);
	TEMP_10_res(6) <= ga_ls_order_rom_1(14) when stq_tail_i(3) else ga_ls_order_rom_1(6);
	TEMP_10_res(7) <= ga_ls_order_rom_1(15) when stq_tail_i(3) else ga_ls_order_rom_1(7);
	TEMP_10_res(8) <= ga_ls_order_rom_1(0) when stq_tail_i(3) else ga_ls_order_rom_1(8);
	TEMP_10_res(9) <= ga_ls_order_rom_1(1) when stq_tail_i(3) else ga_ls_order_rom_1(9);
	TEMP_10_res(10) <= ga_ls_order_rom_1(2) when stq_tail_i(3) else ga_ls_order_rom_1(10);
	TEMP_10_res(11) <= ga_ls_order_rom_1(3) when stq_tail_i(3) else ga_ls_order_rom_1(11);
	TEMP_10_res(12) <= ga_ls_order_rom_1(4) when stq_tail_i(3) else ga_ls_order_rom_1(12);
	TEMP_10_res(13) <= ga_ls_order_rom_1(5) when stq_tail_i(3) else ga_ls_order_rom_1(13);
	TEMP_10_res(14) <= ga_ls_order_rom_1(6) when stq_tail_i(3) else ga_ls_order_rom_1(14);
	TEMP_10_res(15) <= ga_ls_order_rom_1(7) when stq_tail_i(3) else ga_ls_order_rom_1(15);
	-- Layer End
	TEMP_11_res(0) <= TEMP_10_res(12) when stq_tail_i(2) else TEMP_10_res(0);
	TEMP_11_res(1) <= TEMP_10_res(13) when stq_tail_i(2) else TEMP_10_res(1);
	TEMP_11_res(2) <= TEMP_10_res(14) when stq_tail_i(2) else TEMP_10_res(2);
	TEMP_11_res(3) <= TEMP_10_res(15) when stq_tail_i(2) else TEMP_10_res(3);
	TEMP_11_res(4) <= TEMP_10_res(0) when stq_tail_i(2) else TEMP_10_res(4);
	TEMP_11_res(5) <= TEMP_10_res(1) when stq_tail_i(2) else TEMP_10_res(5);
	TEMP_11_res(6) <= TEMP_10_res(2) when stq_tail_i(2) else TEMP_10_res(6);
	TEMP_11_res(7) <= TEMP_10_res(3) when stq_tail_i(2) else TEMP_10_res(7);
	TEMP_11_res(8) <= TEMP_10_res(4) when stq_tail_i(2) else TEMP_10_res(8);
	TEMP_11_res(9) <= TEMP_10_res(5) when stq_tail_i(2) else TEMP_10_res(9);
	TEMP_11_res(10) <= TEMP_10_res(6) when stq_tail_i(2) else TEMP_10_res(10);
	TEMP_11_res(11) <= TEMP_10_res(7) when stq_tail_i(2) else TEMP_10_res(11);
	TEMP_11_res(12) <= TEMP_10_res(8) when stq_tail_i(2) else TEMP_10_res(12);
	TEMP_11_res(13) <= TEMP_10_res(9) when stq_tail_i(2) else TEMP_10_res(13);
	TEMP_11_res(14) <= TEMP_10_res(10) when stq_tail_i(2) else TEMP_10_res(14);
	TEMP_11_res(15) <= TEMP_10_res(11) when stq_tail_i(2) else TEMP_10_res(15);
	-- Layer End
	TEMP_12_res(0) <= TEMP_11_res(14) when stq_tail_i(1) else TEMP_11_res(0);
	TEMP_12_res(1) <= TEMP_11_res(15) when stq_tail_i(1) else TEMP_11_res(1);
	TEMP_12_res(2) <= TEMP_11_res(0) when stq_tail_i(1) else TEMP_11_res(2);
	TEMP_12_res(3) <= TEMP_11_res(1) when stq_tail_i(1) else TEMP_11_res(3);
	TEMP_12_res(4) <= TEMP_11_res(2) when stq_tail_i(1) else TEMP_11_res(4);
	TEMP_12_res(5) <= TEMP_11_res(3) when stq_tail_i(1) else TEMP_11_res(5);
	TEMP_12_res(6) <= TEMP_11_res(4) when stq_tail_i(1) else TEMP_11_res(6);
	TEMP_12_res(7) <= TEMP_11_res(5) when stq_tail_i(1) else TEMP_11_res(7);
	TEMP_12_res(8) <= TEMP_11_res(6) when stq_tail_i(1) else TEMP_11_res(8);
	TEMP_12_res(9) <= TEMP_11_res(7) when stq_tail_i(1) else TEMP_11_res(9);
	TEMP_12_res(10) <= TEMP_11_res(8) when stq_tail_i(1) else TEMP_11_res(10);
	TEMP_12_res(11) <= TEMP_11_res(9) when stq_tail_i(1) else TEMP_11_res(11);
	TEMP_12_res(12) <= TEMP_11_res(10) when stq_tail_i(1) else TEMP_11_res(12);
	TEMP_12_res(13) <= TEMP_11_res(11) when stq_tail_i(1) else TEMP_11_res(13);
	TEMP_12_res(14) <= TEMP_11_res(12) when stq_tail_i(1) else TEMP_11_res(14);
	TEMP_12_res(15) <= TEMP_11_res(13) when stq_tail_i(1) else TEMP_11_res(15);
	-- Layer End
	ga_ls_order_temp_1(0) <= TEMP_12_res(15) when stq_tail_i(0) else TEMP_12_res(0);
	ga_ls_order_temp_1(1) <= TEMP_12_res(0) when stq_tail_i(0) else TEMP_12_res(1);
	ga_ls_order_temp_1(2) <= TEMP_12_res(1) when stq_tail_i(0) else TEMP_12_res(2);
	ga_ls_order_temp_1(3) <= TEMP_12_res(2) when stq_tail_i(0) else TEMP_12_res(3);
	ga_ls_order_temp_1(4) <= TEMP_12_res(3) when stq_tail_i(0) else TEMP_12_res(4);
	ga_ls_order_temp_1(5) <= TEMP_12_res(4) when stq_tail_i(0) else TEMP_12_res(5);
	ga_ls_order_temp_1(6) <= TEMP_12_res(5) when stq_tail_i(0) else TEMP_12_res(6);
	ga_ls_order_temp_1(7) <= TEMP_12_res(6) when stq_tail_i(0) else TEMP_12_res(7);
	ga_ls_order_temp_1(8) <= TEMP_12_res(7) when stq_tail_i(0) else TEMP_12_res(8);
	ga_ls_order_temp_1(9) <= TEMP_12_res(8) when stq_tail_i(0) else TEMP_12_res(9);
	ga_ls_order_temp_1(10) <= TEMP_12_res(9) when stq_tail_i(0) else TEMP_12_res(10);
	ga_ls_order_temp_1(11) <= TEMP_12_res(10) when stq_tail_i(0) else TEMP_12_res(11);
	ga_ls_order_temp_1(12) <= TEMP_12_res(11) when stq_tail_i(0) else TEMP_12_res(12);
	ga_ls_order_temp_1(13) <= TEMP_12_res(12) when stq_tail_i(0) else TEMP_12_res(13);
	ga_ls_order_temp_1(14) <= TEMP_12_res(13) when stq_tail_i(0) else TEMP_12_res(14);
	ga_ls_order_temp_1(15) <= TEMP_12_res(14) when stq_tail_i(0) else TEMP_12_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_2, ga_ls_order_rom_2, stq_tail)
	TEMP_13_res(0) <= ga_ls_order_rom_2(8) when stq_tail_i(3) else ga_ls_order_rom_2(0);
	TEMP_13_res(1) <= ga_ls_order_rom_2(9) when stq_tail_i(3) else ga_ls_order_rom_2(1);
	TEMP_13_res(2) <= ga_ls_order_rom_2(10) when stq_tail_i(3) else ga_ls_order_rom_2(2);
	TEMP_13_res(3) <= ga_ls_order_rom_2(11) when stq_tail_i(3) else ga_ls_order_rom_2(3);
	TEMP_13_res(4) <= ga_ls_order_rom_2(12) when stq_tail_i(3) else ga_ls_order_rom_2(4);
	TEMP_13_res(5) <= ga_ls_order_rom_2(13) when stq_tail_i(3) else ga_ls_order_rom_2(5);
	TEMP_13_res(6) <= ga_ls_order_rom_2(14) when stq_tail_i(3) else ga_ls_order_rom_2(6);
	TEMP_13_res(7) <= ga_ls_order_rom_2(15) when stq_tail_i(3) else ga_ls_order_rom_2(7);
	TEMP_13_res(8) <= ga_ls_order_rom_2(0) when stq_tail_i(3) else ga_ls_order_rom_2(8);
	TEMP_13_res(9) <= ga_ls_order_rom_2(1) when stq_tail_i(3) else ga_ls_order_rom_2(9);
	TEMP_13_res(10) <= ga_ls_order_rom_2(2) when stq_tail_i(3) else ga_ls_order_rom_2(10);
	TEMP_13_res(11) <= ga_ls_order_rom_2(3) when stq_tail_i(3) else ga_ls_order_rom_2(11);
	TEMP_13_res(12) <= ga_ls_order_rom_2(4) when stq_tail_i(3) else ga_ls_order_rom_2(12);
	TEMP_13_res(13) <= ga_ls_order_rom_2(5) when stq_tail_i(3) else ga_ls_order_rom_2(13);
	TEMP_13_res(14) <= ga_ls_order_rom_2(6) when stq_tail_i(3) else ga_ls_order_rom_2(14);
	TEMP_13_res(15) <= ga_ls_order_rom_2(7) when stq_tail_i(3) else ga_ls_order_rom_2(15);
	-- Layer End
	TEMP_14_res(0) <= TEMP_13_res(12) when stq_tail_i(2) else TEMP_13_res(0);
	TEMP_14_res(1) <= TEMP_13_res(13) when stq_tail_i(2) else TEMP_13_res(1);
	TEMP_14_res(2) <= TEMP_13_res(14) when stq_tail_i(2) else TEMP_13_res(2);
	TEMP_14_res(3) <= TEMP_13_res(15) when stq_tail_i(2) else TEMP_13_res(3);
	TEMP_14_res(4) <= TEMP_13_res(0) when stq_tail_i(2) else TEMP_13_res(4);
	TEMP_14_res(5) <= TEMP_13_res(1) when stq_tail_i(2) else TEMP_13_res(5);
	TEMP_14_res(6) <= TEMP_13_res(2) when stq_tail_i(2) else TEMP_13_res(6);
	TEMP_14_res(7) <= TEMP_13_res(3) when stq_tail_i(2) else TEMP_13_res(7);
	TEMP_14_res(8) <= TEMP_13_res(4) when stq_tail_i(2) else TEMP_13_res(8);
	TEMP_14_res(9) <= TEMP_13_res(5) when stq_tail_i(2) else TEMP_13_res(9);
	TEMP_14_res(10) <= TEMP_13_res(6) when stq_tail_i(2) else TEMP_13_res(10);
	TEMP_14_res(11) <= TEMP_13_res(7) when stq_tail_i(2) else TEMP_13_res(11);
	TEMP_14_res(12) <= TEMP_13_res(8) when stq_tail_i(2) else TEMP_13_res(12);
	TEMP_14_res(13) <= TEMP_13_res(9) when stq_tail_i(2) else TEMP_13_res(13);
	TEMP_14_res(14) <= TEMP_13_res(10) when stq_tail_i(2) else TEMP_13_res(14);
	TEMP_14_res(15) <= TEMP_13_res(11) when stq_tail_i(2) else TEMP_13_res(15);
	-- Layer End
	TEMP_15_res(0) <= TEMP_14_res(14) when stq_tail_i(1) else TEMP_14_res(0);
	TEMP_15_res(1) <= TEMP_14_res(15) when stq_tail_i(1) else TEMP_14_res(1);
	TEMP_15_res(2) <= TEMP_14_res(0) when stq_tail_i(1) else TEMP_14_res(2);
	TEMP_15_res(3) <= TEMP_14_res(1) when stq_tail_i(1) else TEMP_14_res(3);
	TEMP_15_res(4) <= TEMP_14_res(2) when stq_tail_i(1) else TEMP_14_res(4);
	TEMP_15_res(5) <= TEMP_14_res(3) when stq_tail_i(1) else TEMP_14_res(5);
	TEMP_15_res(6) <= TEMP_14_res(4) when stq_tail_i(1) else TEMP_14_res(6);
	TEMP_15_res(7) <= TEMP_14_res(5) when stq_tail_i(1) else TEMP_14_res(7);
	TEMP_15_res(8) <= TEMP_14_res(6) when stq_tail_i(1) else TEMP_14_res(8);
	TEMP_15_res(9) <= TEMP_14_res(7) when stq_tail_i(1) else TEMP_14_res(9);
	TEMP_15_res(10) <= TEMP_14_res(8) when stq_tail_i(1) else TEMP_14_res(10);
	TEMP_15_res(11) <= TEMP_14_res(9) when stq_tail_i(1) else TEMP_14_res(11);
	TEMP_15_res(12) <= TEMP_14_res(10) when stq_tail_i(1) else TEMP_14_res(12);
	TEMP_15_res(13) <= TEMP_14_res(11) when stq_tail_i(1) else TEMP_14_res(13);
	TEMP_15_res(14) <= TEMP_14_res(12) when stq_tail_i(1) else TEMP_14_res(14);
	TEMP_15_res(15) <= TEMP_14_res(13) when stq_tail_i(1) else TEMP_14_res(15);
	-- Layer End
	ga_ls_order_temp_2(0) <= TEMP_15_res(15) when stq_tail_i(0) else TEMP_15_res(0);
	ga_ls_order_temp_2(1) <= TEMP_15_res(0) when stq_tail_i(0) else TEMP_15_res(1);
	ga_ls_order_temp_2(2) <= TEMP_15_res(1) when stq_tail_i(0) else TEMP_15_res(2);
	ga_ls_order_temp_2(3) <= TEMP_15_res(2) when stq_tail_i(0) else TEMP_15_res(3);
	ga_ls_order_temp_2(4) <= TEMP_15_res(3) when stq_tail_i(0) else TEMP_15_res(4);
	ga_ls_order_temp_2(5) <= TEMP_15_res(4) when stq_tail_i(0) else TEMP_15_res(5);
	ga_ls_order_temp_2(6) <= TEMP_15_res(5) when stq_tail_i(0) else TEMP_15_res(6);
	ga_ls_order_temp_2(7) <= TEMP_15_res(6) when stq_tail_i(0) else TEMP_15_res(7);
	ga_ls_order_temp_2(8) <= TEMP_15_res(7) when stq_tail_i(0) else TEMP_15_res(8);
	ga_ls_order_temp_2(9) <= TEMP_15_res(8) when stq_tail_i(0) else TEMP_15_res(9);
	ga_ls_order_temp_2(10) <= TEMP_15_res(9) when stq_tail_i(0) else TEMP_15_res(10);
	ga_ls_order_temp_2(11) <= TEMP_15_res(10) when stq_tail_i(0) else TEMP_15_res(11);
	ga_ls_order_temp_2(12) <= TEMP_15_res(11) when stq_tail_i(0) else TEMP_15_res(12);
	ga_ls_order_temp_2(13) <= TEMP_15_res(12) when stq_tail_i(0) else TEMP_15_res(13);
	ga_ls_order_temp_2(14) <= TEMP_15_res(13) when stq_tail_i(0) else TEMP_15_res(14);
	ga_ls_order_temp_2(15) <= TEMP_15_res(14) when stq_tail_i(0) else TEMP_15_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_3, ga_ls_order_rom_3, stq_tail)
	TEMP_16_res(0) <= ga_ls_order_rom_3(8) when stq_tail_i(3) else ga_ls_order_rom_3(0);
	TEMP_16_res(1) <= ga_ls_order_rom_3(9) when stq_tail_i(3) else ga_ls_order_rom_3(1);
	TEMP_16_res(2) <= ga_ls_order_rom_3(10) when stq_tail_i(3) else ga_ls_order_rom_3(2);
	TEMP_16_res(3) <= ga_ls_order_rom_3(11) when stq_tail_i(3) else ga_ls_order_rom_3(3);
	TEMP_16_res(4) <= ga_ls_order_rom_3(12) when stq_tail_i(3) else ga_ls_order_rom_3(4);
	TEMP_16_res(5) <= ga_ls_order_rom_3(13) when stq_tail_i(3) else ga_ls_order_rom_3(5);
	TEMP_16_res(6) <= ga_ls_order_rom_3(14) when stq_tail_i(3) else ga_ls_order_rom_3(6);
	TEMP_16_res(7) <= ga_ls_order_rom_3(15) when stq_tail_i(3) else ga_ls_order_rom_3(7);
	TEMP_16_res(8) <= ga_ls_order_rom_3(0) when stq_tail_i(3) else ga_ls_order_rom_3(8);
	TEMP_16_res(9) <= ga_ls_order_rom_3(1) when stq_tail_i(3) else ga_ls_order_rom_3(9);
	TEMP_16_res(10) <= ga_ls_order_rom_3(2) when stq_tail_i(3) else ga_ls_order_rom_3(10);
	TEMP_16_res(11) <= ga_ls_order_rom_3(3) when stq_tail_i(3) else ga_ls_order_rom_3(11);
	TEMP_16_res(12) <= ga_ls_order_rom_3(4) when stq_tail_i(3) else ga_ls_order_rom_3(12);
	TEMP_16_res(13) <= ga_ls_order_rom_3(5) when stq_tail_i(3) else ga_ls_order_rom_3(13);
	TEMP_16_res(14) <= ga_ls_order_rom_3(6) when stq_tail_i(3) else ga_ls_order_rom_3(14);
	TEMP_16_res(15) <= ga_ls_order_rom_3(7) when stq_tail_i(3) else ga_ls_order_rom_3(15);
	-- Layer End
	TEMP_17_res(0) <= TEMP_16_res(12) when stq_tail_i(2) else TEMP_16_res(0);
	TEMP_17_res(1) <= TEMP_16_res(13) when stq_tail_i(2) else TEMP_16_res(1);
	TEMP_17_res(2) <= TEMP_16_res(14) when stq_tail_i(2) else TEMP_16_res(2);
	TEMP_17_res(3) <= TEMP_16_res(15) when stq_tail_i(2) else TEMP_16_res(3);
	TEMP_17_res(4) <= TEMP_16_res(0) when stq_tail_i(2) else TEMP_16_res(4);
	TEMP_17_res(5) <= TEMP_16_res(1) when stq_tail_i(2) else TEMP_16_res(5);
	TEMP_17_res(6) <= TEMP_16_res(2) when stq_tail_i(2) else TEMP_16_res(6);
	TEMP_17_res(7) <= TEMP_16_res(3) when stq_tail_i(2) else TEMP_16_res(7);
	TEMP_17_res(8) <= TEMP_16_res(4) when stq_tail_i(2) else TEMP_16_res(8);
	TEMP_17_res(9) <= TEMP_16_res(5) when stq_tail_i(2) else TEMP_16_res(9);
	TEMP_17_res(10) <= TEMP_16_res(6) when stq_tail_i(2) else TEMP_16_res(10);
	TEMP_17_res(11) <= TEMP_16_res(7) when stq_tail_i(2) else TEMP_16_res(11);
	TEMP_17_res(12) <= TEMP_16_res(8) when stq_tail_i(2) else TEMP_16_res(12);
	TEMP_17_res(13) <= TEMP_16_res(9) when stq_tail_i(2) else TEMP_16_res(13);
	TEMP_17_res(14) <= TEMP_16_res(10) when stq_tail_i(2) else TEMP_16_res(14);
	TEMP_17_res(15) <= TEMP_16_res(11) when stq_tail_i(2) else TEMP_16_res(15);
	-- Layer End
	TEMP_18_res(0) <= TEMP_17_res(14) when stq_tail_i(1) else TEMP_17_res(0);
	TEMP_18_res(1) <= TEMP_17_res(15) when stq_tail_i(1) else TEMP_17_res(1);
	TEMP_18_res(2) <= TEMP_17_res(0) when stq_tail_i(1) else TEMP_17_res(2);
	TEMP_18_res(3) <= TEMP_17_res(1) when stq_tail_i(1) else TEMP_17_res(3);
	TEMP_18_res(4) <= TEMP_17_res(2) when stq_tail_i(1) else TEMP_17_res(4);
	TEMP_18_res(5) <= TEMP_17_res(3) when stq_tail_i(1) else TEMP_17_res(5);
	TEMP_18_res(6) <= TEMP_17_res(4) when stq_tail_i(1) else TEMP_17_res(6);
	TEMP_18_res(7) <= TEMP_17_res(5) when stq_tail_i(1) else TEMP_17_res(7);
	TEMP_18_res(8) <= TEMP_17_res(6) when stq_tail_i(1) else TEMP_17_res(8);
	TEMP_18_res(9) <= TEMP_17_res(7) when stq_tail_i(1) else TEMP_17_res(9);
	TEMP_18_res(10) <= TEMP_17_res(8) when stq_tail_i(1) else TEMP_17_res(10);
	TEMP_18_res(11) <= TEMP_17_res(9) when stq_tail_i(1) else TEMP_17_res(11);
	TEMP_18_res(12) <= TEMP_17_res(10) when stq_tail_i(1) else TEMP_17_res(12);
	TEMP_18_res(13) <= TEMP_17_res(11) when stq_tail_i(1) else TEMP_17_res(13);
	TEMP_18_res(14) <= TEMP_17_res(12) when stq_tail_i(1) else TEMP_17_res(14);
	TEMP_18_res(15) <= TEMP_17_res(13) when stq_tail_i(1) else TEMP_17_res(15);
	-- Layer End
	ga_ls_order_temp_3(0) <= TEMP_18_res(15) when stq_tail_i(0) else TEMP_18_res(0);
	ga_ls_order_temp_3(1) <= TEMP_18_res(0) when stq_tail_i(0) else TEMP_18_res(1);
	ga_ls_order_temp_3(2) <= TEMP_18_res(1) when stq_tail_i(0) else TEMP_18_res(2);
	ga_ls_order_temp_3(3) <= TEMP_18_res(2) when stq_tail_i(0) else TEMP_18_res(3);
	ga_ls_order_temp_3(4) <= TEMP_18_res(3) when stq_tail_i(0) else TEMP_18_res(4);
	ga_ls_order_temp_3(5) <= TEMP_18_res(4) when stq_tail_i(0) else TEMP_18_res(5);
	ga_ls_order_temp_3(6) <= TEMP_18_res(5) when stq_tail_i(0) else TEMP_18_res(6);
	ga_ls_order_temp_3(7) <= TEMP_18_res(6) when stq_tail_i(0) else TEMP_18_res(7);
	ga_ls_order_temp_3(8) <= TEMP_18_res(7) when stq_tail_i(0) else TEMP_18_res(8);
	ga_ls_order_temp_3(9) <= TEMP_18_res(8) when stq_tail_i(0) else TEMP_18_res(9);
	ga_ls_order_temp_3(10) <= TEMP_18_res(9) when stq_tail_i(0) else TEMP_18_res(10);
	ga_ls_order_temp_3(11) <= TEMP_18_res(10) when stq_tail_i(0) else TEMP_18_res(11);
	ga_ls_order_temp_3(12) <= TEMP_18_res(11) when stq_tail_i(0) else TEMP_18_res(12);
	ga_ls_order_temp_3(13) <= TEMP_18_res(12) when stq_tail_i(0) else TEMP_18_res(13);
	ga_ls_order_temp_3(14) <= TEMP_18_res(13) when stq_tail_i(0) else TEMP_18_res(14);
	ga_ls_order_temp_3(15) <= TEMP_18_res(14) when stq_tail_i(0) else TEMP_18_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_4, ga_ls_order_rom_4, stq_tail)
	TEMP_19_res(0) <= ga_ls_order_rom_4(8) when stq_tail_i(3) else ga_ls_order_rom_4(0);
	TEMP_19_res(1) <= ga_ls_order_rom_4(9) when stq_tail_i(3) else ga_ls_order_rom_4(1);
	TEMP_19_res(2) <= ga_ls_order_rom_4(10) when stq_tail_i(3) else ga_ls_order_rom_4(2);
	TEMP_19_res(3) <= ga_ls_order_rom_4(11) when stq_tail_i(3) else ga_ls_order_rom_4(3);
	TEMP_19_res(4) <= ga_ls_order_rom_4(12) when stq_tail_i(3) else ga_ls_order_rom_4(4);
	TEMP_19_res(5) <= ga_ls_order_rom_4(13) when stq_tail_i(3) else ga_ls_order_rom_4(5);
	TEMP_19_res(6) <= ga_ls_order_rom_4(14) when stq_tail_i(3) else ga_ls_order_rom_4(6);
	TEMP_19_res(7) <= ga_ls_order_rom_4(15) when stq_tail_i(3) else ga_ls_order_rom_4(7);
	TEMP_19_res(8) <= ga_ls_order_rom_4(0) when stq_tail_i(3) else ga_ls_order_rom_4(8);
	TEMP_19_res(9) <= ga_ls_order_rom_4(1) when stq_tail_i(3) else ga_ls_order_rom_4(9);
	TEMP_19_res(10) <= ga_ls_order_rom_4(2) when stq_tail_i(3) else ga_ls_order_rom_4(10);
	TEMP_19_res(11) <= ga_ls_order_rom_4(3) when stq_tail_i(3) else ga_ls_order_rom_4(11);
	TEMP_19_res(12) <= ga_ls_order_rom_4(4) when stq_tail_i(3) else ga_ls_order_rom_4(12);
	TEMP_19_res(13) <= ga_ls_order_rom_4(5) when stq_tail_i(3) else ga_ls_order_rom_4(13);
	TEMP_19_res(14) <= ga_ls_order_rom_4(6) when stq_tail_i(3) else ga_ls_order_rom_4(14);
	TEMP_19_res(15) <= ga_ls_order_rom_4(7) when stq_tail_i(3) else ga_ls_order_rom_4(15);
	-- Layer End
	TEMP_20_res(0) <= TEMP_19_res(12) when stq_tail_i(2) else TEMP_19_res(0);
	TEMP_20_res(1) <= TEMP_19_res(13) when stq_tail_i(2) else TEMP_19_res(1);
	TEMP_20_res(2) <= TEMP_19_res(14) when stq_tail_i(2) else TEMP_19_res(2);
	TEMP_20_res(3) <= TEMP_19_res(15) when stq_tail_i(2) else TEMP_19_res(3);
	TEMP_20_res(4) <= TEMP_19_res(0) when stq_tail_i(2) else TEMP_19_res(4);
	TEMP_20_res(5) <= TEMP_19_res(1) when stq_tail_i(2) else TEMP_19_res(5);
	TEMP_20_res(6) <= TEMP_19_res(2) when stq_tail_i(2) else TEMP_19_res(6);
	TEMP_20_res(7) <= TEMP_19_res(3) when stq_tail_i(2) else TEMP_19_res(7);
	TEMP_20_res(8) <= TEMP_19_res(4) when stq_tail_i(2) else TEMP_19_res(8);
	TEMP_20_res(9) <= TEMP_19_res(5) when stq_tail_i(2) else TEMP_19_res(9);
	TEMP_20_res(10) <= TEMP_19_res(6) when stq_tail_i(2) else TEMP_19_res(10);
	TEMP_20_res(11) <= TEMP_19_res(7) when stq_tail_i(2) else TEMP_19_res(11);
	TEMP_20_res(12) <= TEMP_19_res(8) when stq_tail_i(2) else TEMP_19_res(12);
	TEMP_20_res(13) <= TEMP_19_res(9) when stq_tail_i(2) else TEMP_19_res(13);
	TEMP_20_res(14) <= TEMP_19_res(10) when stq_tail_i(2) else TEMP_19_res(14);
	TEMP_20_res(15) <= TEMP_19_res(11) when stq_tail_i(2) else TEMP_19_res(15);
	-- Layer End
	TEMP_21_res(0) <= TEMP_20_res(14) when stq_tail_i(1) else TEMP_20_res(0);
	TEMP_21_res(1) <= TEMP_20_res(15) when stq_tail_i(1) else TEMP_20_res(1);
	TEMP_21_res(2) <= TEMP_20_res(0) when stq_tail_i(1) else TEMP_20_res(2);
	TEMP_21_res(3) <= TEMP_20_res(1) when stq_tail_i(1) else TEMP_20_res(3);
	TEMP_21_res(4) <= TEMP_20_res(2) when stq_tail_i(1) else TEMP_20_res(4);
	TEMP_21_res(5) <= TEMP_20_res(3) when stq_tail_i(1) else TEMP_20_res(5);
	TEMP_21_res(6) <= TEMP_20_res(4) when stq_tail_i(1) else TEMP_20_res(6);
	TEMP_21_res(7) <= TEMP_20_res(5) when stq_tail_i(1) else TEMP_20_res(7);
	TEMP_21_res(8) <= TEMP_20_res(6) when stq_tail_i(1) else TEMP_20_res(8);
	TEMP_21_res(9) <= TEMP_20_res(7) when stq_tail_i(1) else TEMP_20_res(9);
	TEMP_21_res(10) <= TEMP_20_res(8) when stq_tail_i(1) else TEMP_20_res(10);
	TEMP_21_res(11) <= TEMP_20_res(9) when stq_tail_i(1) else TEMP_20_res(11);
	TEMP_21_res(12) <= TEMP_20_res(10) when stq_tail_i(1) else TEMP_20_res(12);
	TEMP_21_res(13) <= TEMP_20_res(11) when stq_tail_i(1) else TEMP_20_res(13);
	TEMP_21_res(14) <= TEMP_20_res(12) when stq_tail_i(1) else TEMP_20_res(14);
	TEMP_21_res(15) <= TEMP_20_res(13) when stq_tail_i(1) else TEMP_20_res(15);
	-- Layer End
	ga_ls_order_temp_4(0) <= TEMP_21_res(15) when stq_tail_i(0) else TEMP_21_res(0);
	ga_ls_order_temp_4(1) <= TEMP_21_res(0) when stq_tail_i(0) else TEMP_21_res(1);
	ga_ls_order_temp_4(2) <= TEMP_21_res(1) when stq_tail_i(0) else TEMP_21_res(2);
	ga_ls_order_temp_4(3) <= TEMP_21_res(2) when stq_tail_i(0) else TEMP_21_res(3);
	ga_ls_order_temp_4(4) <= TEMP_21_res(3) when stq_tail_i(0) else TEMP_21_res(4);
	ga_ls_order_temp_4(5) <= TEMP_21_res(4) when stq_tail_i(0) else TEMP_21_res(5);
	ga_ls_order_temp_4(6) <= TEMP_21_res(5) when stq_tail_i(0) else TEMP_21_res(6);
	ga_ls_order_temp_4(7) <= TEMP_21_res(6) when stq_tail_i(0) else TEMP_21_res(7);
	ga_ls_order_temp_4(8) <= TEMP_21_res(7) when stq_tail_i(0) else TEMP_21_res(8);
	ga_ls_order_temp_4(9) <= TEMP_21_res(8) when stq_tail_i(0) else TEMP_21_res(9);
	ga_ls_order_temp_4(10) <= TEMP_21_res(9) when stq_tail_i(0) else TEMP_21_res(10);
	ga_ls_order_temp_4(11) <= TEMP_21_res(10) when stq_tail_i(0) else TEMP_21_res(11);
	ga_ls_order_temp_4(12) <= TEMP_21_res(11) when stq_tail_i(0) else TEMP_21_res(12);
	ga_ls_order_temp_4(13) <= TEMP_21_res(12) when stq_tail_i(0) else TEMP_21_res(13);
	ga_ls_order_temp_4(14) <= TEMP_21_res(13) when stq_tail_i(0) else TEMP_21_res(14);
	ga_ls_order_temp_4(15) <= TEMP_21_res(14) when stq_tail_i(0) else TEMP_21_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_5, ga_ls_order_rom_5, stq_tail)
	TEMP_22_res(0) <= ga_ls_order_rom_5(8) when stq_tail_i(3) else ga_ls_order_rom_5(0);
	TEMP_22_res(1) <= ga_ls_order_rom_5(9) when stq_tail_i(3) else ga_ls_order_rom_5(1);
	TEMP_22_res(2) <= ga_ls_order_rom_5(10) when stq_tail_i(3) else ga_ls_order_rom_5(2);
	TEMP_22_res(3) <= ga_ls_order_rom_5(11) when stq_tail_i(3) else ga_ls_order_rom_5(3);
	TEMP_22_res(4) <= ga_ls_order_rom_5(12) when stq_tail_i(3) else ga_ls_order_rom_5(4);
	TEMP_22_res(5) <= ga_ls_order_rom_5(13) when stq_tail_i(3) else ga_ls_order_rom_5(5);
	TEMP_22_res(6) <= ga_ls_order_rom_5(14) when stq_tail_i(3) else ga_ls_order_rom_5(6);
	TEMP_22_res(7) <= ga_ls_order_rom_5(15) when stq_tail_i(3) else ga_ls_order_rom_5(7);
	TEMP_22_res(8) <= ga_ls_order_rom_5(0) when stq_tail_i(3) else ga_ls_order_rom_5(8);
	TEMP_22_res(9) <= ga_ls_order_rom_5(1) when stq_tail_i(3) else ga_ls_order_rom_5(9);
	TEMP_22_res(10) <= ga_ls_order_rom_5(2) when stq_tail_i(3) else ga_ls_order_rom_5(10);
	TEMP_22_res(11) <= ga_ls_order_rom_5(3) when stq_tail_i(3) else ga_ls_order_rom_5(11);
	TEMP_22_res(12) <= ga_ls_order_rom_5(4) when stq_tail_i(3) else ga_ls_order_rom_5(12);
	TEMP_22_res(13) <= ga_ls_order_rom_5(5) when stq_tail_i(3) else ga_ls_order_rom_5(13);
	TEMP_22_res(14) <= ga_ls_order_rom_5(6) when stq_tail_i(3) else ga_ls_order_rom_5(14);
	TEMP_22_res(15) <= ga_ls_order_rom_5(7) when stq_tail_i(3) else ga_ls_order_rom_5(15);
	-- Layer End
	TEMP_23_res(0) <= TEMP_22_res(12) when stq_tail_i(2) else TEMP_22_res(0);
	TEMP_23_res(1) <= TEMP_22_res(13) when stq_tail_i(2) else TEMP_22_res(1);
	TEMP_23_res(2) <= TEMP_22_res(14) when stq_tail_i(2) else TEMP_22_res(2);
	TEMP_23_res(3) <= TEMP_22_res(15) when stq_tail_i(2) else TEMP_22_res(3);
	TEMP_23_res(4) <= TEMP_22_res(0) when stq_tail_i(2) else TEMP_22_res(4);
	TEMP_23_res(5) <= TEMP_22_res(1) when stq_tail_i(2) else TEMP_22_res(5);
	TEMP_23_res(6) <= TEMP_22_res(2) when stq_tail_i(2) else TEMP_22_res(6);
	TEMP_23_res(7) <= TEMP_22_res(3) when stq_tail_i(2) else TEMP_22_res(7);
	TEMP_23_res(8) <= TEMP_22_res(4) when stq_tail_i(2) else TEMP_22_res(8);
	TEMP_23_res(9) <= TEMP_22_res(5) when stq_tail_i(2) else TEMP_22_res(9);
	TEMP_23_res(10) <= TEMP_22_res(6) when stq_tail_i(2) else TEMP_22_res(10);
	TEMP_23_res(11) <= TEMP_22_res(7) when stq_tail_i(2) else TEMP_22_res(11);
	TEMP_23_res(12) <= TEMP_22_res(8) when stq_tail_i(2) else TEMP_22_res(12);
	TEMP_23_res(13) <= TEMP_22_res(9) when stq_tail_i(2) else TEMP_22_res(13);
	TEMP_23_res(14) <= TEMP_22_res(10) when stq_tail_i(2) else TEMP_22_res(14);
	TEMP_23_res(15) <= TEMP_22_res(11) when stq_tail_i(2) else TEMP_22_res(15);
	-- Layer End
	TEMP_24_res(0) <= TEMP_23_res(14) when stq_tail_i(1) else TEMP_23_res(0);
	TEMP_24_res(1) <= TEMP_23_res(15) when stq_tail_i(1) else TEMP_23_res(1);
	TEMP_24_res(2) <= TEMP_23_res(0) when stq_tail_i(1) else TEMP_23_res(2);
	TEMP_24_res(3) <= TEMP_23_res(1) when stq_tail_i(1) else TEMP_23_res(3);
	TEMP_24_res(4) <= TEMP_23_res(2) when stq_tail_i(1) else TEMP_23_res(4);
	TEMP_24_res(5) <= TEMP_23_res(3) when stq_tail_i(1) else TEMP_23_res(5);
	TEMP_24_res(6) <= TEMP_23_res(4) when stq_tail_i(1) else TEMP_23_res(6);
	TEMP_24_res(7) <= TEMP_23_res(5) when stq_tail_i(1) else TEMP_23_res(7);
	TEMP_24_res(8) <= TEMP_23_res(6) when stq_tail_i(1) else TEMP_23_res(8);
	TEMP_24_res(9) <= TEMP_23_res(7) when stq_tail_i(1) else TEMP_23_res(9);
	TEMP_24_res(10) <= TEMP_23_res(8) when stq_tail_i(1) else TEMP_23_res(10);
	TEMP_24_res(11) <= TEMP_23_res(9) when stq_tail_i(1) else TEMP_23_res(11);
	TEMP_24_res(12) <= TEMP_23_res(10) when stq_tail_i(1) else TEMP_23_res(12);
	TEMP_24_res(13) <= TEMP_23_res(11) when stq_tail_i(1) else TEMP_23_res(13);
	TEMP_24_res(14) <= TEMP_23_res(12) when stq_tail_i(1) else TEMP_23_res(14);
	TEMP_24_res(15) <= TEMP_23_res(13) when stq_tail_i(1) else TEMP_23_res(15);
	-- Layer End
	ga_ls_order_temp_5(0) <= TEMP_24_res(15) when stq_tail_i(0) else TEMP_24_res(0);
	ga_ls_order_temp_5(1) <= TEMP_24_res(0) when stq_tail_i(0) else TEMP_24_res(1);
	ga_ls_order_temp_5(2) <= TEMP_24_res(1) when stq_tail_i(0) else TEMP_24_res(2);
	ga_ls_order_temp_5(3) <= TEMP_24_res(2) when stq_tail_i(0) else TEMP_24_res(3);
	ga_ls_order_temp_5(4) <= TEMP_24_res(3) when stq_tail_i(0) else TEMP_24_res(4);
	ga_ls_order_temp_5(5) <= TEMP_24_res(4) when stq_tail_i(0) else TEMP_24_res(5);
	ga_ls_order_temp_5(6) <= TEMP_24_res(5) when stq_tail_i(0) else TEMP_24_res(6);
	ga_ls_order_temp_5(7) <= TEMP_24_res(6) when stq_tail_i(0) else TEMP_24_res(7);
	ga_ls_order_temp_5(8) <= TEMP_24_res(7) when stq_tail_i(0) else TEMP_24_res(8);
	ga_ls_order_temp_5(9) <= TEMP_24_res(8) when stq_tail_i(0) else TEMP_24_res(9);
	ga_ls_order_temp_5(10) <= TEMP_24_res(9) when stq_tail_i(0) else TEMP_24_res(10);
	ga_ls_order_temp_5(11) <= TEMP_24_res(10) when stq_tail_i(0) else TEMP_24_res(11);
	ga_ls_order_temp_5(12) <= TEMP_24_res(11) when stq_tail_i(0) else TEMP_24_res(12);
	ga_ls_order_temp_5(13) <= TEMP_24_res(12) when stq_tail_i(0) else TEMP_24_res(13);
	ga_ls_order_temp_5(14) <= TEMP_24_res(13) when stq_tail_i(0) else TEMP_24_res(14);
	ga_ls_order_temp_5(15) <= TEMP_24_res(14) when stq_tail_i(0) else TEMP_24_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_6, ga_ls_order_rom_6, stq_tail)
	TEMP_25_res(0) <= ga_ls_order_rom_6(8) when stq_tail_i(3) else ga_ls_order_rom_6(0);
	TEMP_25_res(1) <= ga_ls_order_rom_6(9) when stq_tail_i(3) else ga_ls_order_rom_6(1);
	TEMP_25_res(2) <= ga_ls_order_rom_6(10) when stq_tail_i(3) else ga_ls_order_rom_6(2);
	TEMP_25_res(3) <= ga_ls_order_rom_6(11) when stq_tail_i(3) else ga_ls_order_rom_6(3);
	TEMP_25_res(4) <= ga_ls_order_rom_6(12) when stq_tail_i(3) else ga_ls_order_rom_6(4);
	TEMP_25_res(5) <= ga_ls_order_rom_6(13) when stq_tail_i(3) else ga_ls_order_rom_6(5);
	TEMP_25_res(6) <= ga_ls_order_rom_6(14) when stq_tail_i(3) else ga_ls_order_rom_6(6);
	TEMP_25_res(7) <= ga_ls_order_rom_6(15) when stq_tail_i(3) else ga_ls_order_rom_6(7);
	TEMP_25_res(8) <= ga_ls_order_rom_6(0) when stq_tail_i(3) else ga_ls_order_rom_6(8);
	TEMP_25_res(9) <= ga_ls_order_rom_6(1) when stq_tail_i(3) else ga_ls_order_rom_6(9);
	TEMP_25_res(10) <= ga_ls_order_rom_6(2) when stq_tail_i(3) else ga_ls_order_rom_6(10);
	TEMP_25_res(11) <= ga_ls_order_rom_6(3) when stq_tail_i(3) else ga_ls_order_rom_6(11);
	TEMP_25_res(12) <= ga_ls_order_rom_6(4) when stq_tail_i(3) else ga_ls_order_rom_6(12);
	TEMP_25_res(13) <= ga_ls_order_rom_6(5) when stq_tail_i(3) else ga_ls_order_rom_6(13);
	TEMP_25_res(14) <= ga_ls_order_rom_6(6) when stq_tail_i(3) else ga_ls_order_rom_6(14);
	TEMP_25_res(15) <= ga_ls_order_rom_6(7) when stq_tail_i(3) else ga_ls_order_rom_6(15);
	-- Layer End
	TEMP_26_res(0) <= TEMP_25_res(12) when stq_tail_i(2) else TEMP_25_res(0);
	TEMP_26_res(1) <= TEMP_25_res(13) when stq_tail_i(2) else TEMP_25_res(1);
	TEMP_26_res(2) <= TEMP_25_res(14) when stq_tail_i(2) else TEMP_25_res(2);
	TEMP_26_res(3) <= TEMP_25_res(15) when stq_tail_i(2) else TEMP_25_res(3);
	TEMP_26_res(4) <= TEMP_25_res(0) when stq_tail_i(2) else TEMP_25_res(4);
	TEMP_26_res(5) <= TEMP_25_res(1) when stq_tail_i(2) else TEMP_25_res(5);
	TEMP_26_res(6) <= TEMP_25_res(2) when stq_tail_i(2) else TEMP_25_res(6);
	TEMP_26_res(7) <= TEMP_25_res(3) when stq_tail_i(2) else TEMP_25_res(7);
	TEMP_26_res(8) <= TEMP_25_res(4) when stq_tail_i(2) else TEMP_25_res(8);
	TEMP_26_res(9) <= TEMP_25_res(5) when stq_tail_i(2) else TEMP_25_res(9);
	TEMP_26_res(10) <= TEMP_25_res(6) when stq_tail_i(2) else TEMP_25_res(10);
	TEMP_26_res(11) <= TEMP_25_res(7) when stq_tail_i(2) else TEMP_25_res(11);
	TEMP_26_res(12) <= TEMP_25_res(8) when stq_tail_i(2) else TEMP_25_res(12);
	TEMP_26_res(13) <= TEMP_25_res(9) when stq_tail_i(2) else TEMP_25_res(13);
	TEMP_26_res(14) <= TEMP_25_res(10) when stq_tail_i(2) else TEMP_25_res(14);
	TEMP_26_res(15) <= TEMP_25_res(11) when stq_tail_i(2) else TEMP_25_res(15);
	-- Layer End
	TEMP_27_res(0) <= TEMP_26_res(14) when stq_tail_i(1) else TEMP_26_res(0);
	TEMP_27_res(1) <= TEMP_26_res(15) when stq_tail_i(1) else TEMP_26_res(1);
	TEMP_27_res(2) <= TEMP_26_res(0) when stq_tail_i(1) else TEMP_26_res(2);
	TEMP_27_res(3) <= TEMP_26_res(1) when stq_tail_i(1) else TEMP_26_res(3);
	TEMP_27_res(4) <= TEMP_26_res(2) when stq_tail_i(1) else TEMP_26_res(4);
	TEMP_27_res(5) <= TEMP_26_res(3) when stq_tail_i(1) else TEMP_26_res(5);
	TEMP_27_res(6) <= TEMP_26_res(4) when stq_tail_i(1) else TEMP_26_res(6);
	TEMP_27_res(7) <= TEMP_26_res(5) when stq_tail_i(1) else TEMP_26_res(7);
	TEMP_27_res(8) <= TEMP_26_res(6) when stq_tail_i(1) else TEMP_26_res(8);
	TEMP_27_res(9) <= TEMP_26_res(7) when stq_tail_i(1) else TEMP_26_res(9);
	TEMP_27_res(10) <= TEMP_26_res(8) when stq_tail_i(1) else TEMP_26_res(10);
	TEMP_27_res(11) <= TEMP_26_res(9) when stq_tail_i(1) else TEMP_26_res(11);
	TEMP_27_res(12) <= TEMP_26_res(10) when stq_tail_i(1) else TEMP_26_res(12);
	TEMP_27_res(13) <= TEMP_26_res(11) when stq_tail_i(1) else TEMP_26_res(13);
	TEMP_27_res(14) <= TEMP_26_res(12) when stq_tail_i(1) else TEMP_26_res(14);
	TEMP_27_res(15) <= TEMP_26_res(13) when stq_tail_i(1) else TEMP_26_res(15);
	-- Layer End
	ga_ls_order_temp_6(0) <= TEMP_27_res(15) when stq_tail_i(0) else TEMP_27_res(0);
	ga_ls_order_temp_6(1) <= TEMP_27_res(0) when stq_tail_i(0) else TEMP_27_res(1);
	ga_ls_order_temp_6(2) <= TEMP_27_res(1) when stq_tail_i(0) else TEMP_27_res(2);
	ga_ls_order_temp_6(3) <= TEMP_27_res(2) when stq_tail_i(0) else TEMP_27_res(3);
	ga_ls_order_temp_6(4) <= TEMP_27_res(3) when stq_tail_i(0) else TEMP_27_res(4);
	ga_ls_order_temp_6(5) <= TEMP_27_res(4) when stq_tail_i(0) else TEMP_27_res(5);
	ga_ls_order_temp_6(6) <= TEMP_27_res(5) when stq_tail_i(0) else TEMP_27_res(6);
	ga_ls_order_temp_6(7) <= TEMP_27_res(6) when stq_tail_i(0) else TEMP_27_res(7);
	ga_ls_order_temp_6(8) <= TEMP_27_res(7) when stq_tail_i(0) else TEMP_27_res(8);
	ga_ls_order_temp_6(9) <= TEMP_27_res(8) when stq_tail_i(0) else TEMP_27_res(9);
	ga_ls_order_temp_6(10) <= TEMP_27_res(9) when stq_tail_i(0) else TEMP_27_res(10);
	ga_ls_order_temp_6(11) <= TEMP_27_res(10) when stq_tail_i(0) else TEMP_27_res(11);
	ga_ls_order_temp_6(12) <= TEMP_27_res(11) when stq_tail_i(0) else TEMP_27_res(12);
	ga_ls_order_temp_6(13) <= TEMP_27_res(12) when stq_tail_i(0) else TEMP_27_res(13);
	ga_ls_order_temp_6(14) <= TEMP_27_res(13) when stq_tail_i(0) else TEMP_27_res(14);
	ga_ls_order_temp_6(15) <= TEMP_27_res(14) when stq_tail_i(0) else TEMP_27_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_7, ga_ls_order_rom_7, stq_tail)
	TEMP_28_res(0) <= ga_ls_order_rom_7(8) when stq_tail_i(3) else ga_ls_order_rom_7(0);
	TEMP_28_res(1) <= ga_ls_order_rom_7(9) when stq_tail_i(3) else ga_ls_order_rom_7(1);
	TEMP_28_res(2) <= ga_ls_order_rom_7(10) when stq_tail_i(3) else ga_ls_order_rom_7(2);
	TEMP_28_res(3) <= ga_ls_order_rom_7(11) when stq_tail_i(3) else ga_ls_order_rom_7(3);
	TEMP_28_res(4) <= ga_ls_order_rom_7(12) when stq_tail_i(3) else ga_ls_order_rom_7(4);
	TEMP_28_res(5) <= ga_ls_order_rom_7(13) when stq_tail_i(3) else ga_ls_order_rom_7(5);
	TEMP_28_res(6) <= ga_ls_order_rom_7(14) when stq_tail_i(3) else ga_ls_order_rom_7(6);
	TEMP_28_res(7) <= ga_ls_order_rom_7(15) when stq_tail_i(3) else ga_ls_order_rom_7(7);
	TEMP_28_res(8) <= ga_ls_order_rom_7(0) when stq_tail_i(3) else ga_ls_order_rom_7(8);
	TEMP_28_res(9) <= ga_ls_order_rom_7(1) when stq_tail_i(3) else ga_ls_order_rom_7(9);
	TEMP_28_res(10) <= ga_ls_order_rom_7(2) when stq_tail_i(3) else ga_ls_order_rom_7(10);
	TEMP_28_res(11) <= ga_ls_order_rom_7(3) when stq_tail_i(3) else ga_ls_order_rom_7(11);
	TEMP_28_res(12) <= ga_ls_order_rom_7(4) when stq_tail_i(3) else ga_ls_order_rom_7(12);
	TEMP_28_res(13) <= ga_ls_order_rom_7(5) when stq_tail_i(3) else ga_ls_order_rom_7(13);
	TEMP_28_res(14) <= ga_ls_order_rom_7(6) when stq_tail_i(3) else ga_ls_order_rom_7(14);
	TEMP_28_res(15) <= ga_ls_order_rom_7(7) when stq_tail_i(3) else ga_ls_order_rom_7(15);
	-- Layer End
	TEMP_29_res(0) <= TEMP_28_res(12) when stq_tail_i(2) else TEMP_28_res(0);
	TEMP_29_res(1) <= TEMP_28_res(13) when stq_tail_i(2) else TEMP_28_res(1);
	TEMP_29_res(2) <= TEMP_28_res(14) when stq_tail_i(2) else TEMP_28_res(2);
	TEMP_29_res(3) <= TEMP_28_res(15) when stq_tail_i(2) else TEMP_28_res(3);
	TEMP_29_res(4) <= TEMP_28_res(0) when stq_tail_i(2) else TEMP_28_res(4);
	TEMP_29_res(5) <= TEMP_28_res(1) when stq_tail_i(2) else TEMP_28_res(5);
	TEMP_29_res(6) <= TEMP_28_res(2) when stq_tail_i(2) else TEMP_28_res(6);
	TEMP_29_res(7) <= TEMP_28_res(3) when stq_tail_i(2) else TEMP_28_res(7);
	TEMP_29_res(8) <= TEMP_28_res(4) when stq_tail_i(2) else TEMP_28_res(8);
	TEMP_29_res(9) <= TEMP_28_res(5) when stq_tail_i(2) else TEMP_28_res(9);
	TEMP_29_res(10) <= TEMP_28_res(6) when stq_tail_i(2) else TEMP_28_res(10);
	TEMP_29_res(11) <= TEMP_28_res(7) when stq_tail_i(2) else TEMP_28_res(11);
	TEMP_29_res(12) <= TEMP_28_res(8) when stq_tail_i(2) else TEMP_28_res(12);
	TEMP_29_res(13) <= TEMP_28_res(9) when stq_tail_i(2) else TEMP_28_res(13);
	TEMP_29_res(14) <= TEMP_28_res(10) when stq_tail_i(2) else TEMP_28_res(14);
	TEMP_29_res(15) <= TEMP_28_res(11) when stq_tail_i(2) else TEMP_28_res(15);
	-- Layer End
	TEMP_30_res(0) <= TEMP_29_res(14) when stq_tail_i(1) else TEMP_29_res(0);
	TEMP_30_res(1) <= TEMP_29_res(15) when stq_tail_i(1) else TEMP_29_res(1);
	TEMP_30_res(2) <= TEMP_29_res(0) when stq_tail_i(1) else TEMP_29_res(2);
	TEMP_30_res(3) <= TEMP_29_res(1) when stq_tail_i(1) else TEMP_29_res(3);
	TEMP_30_res(4) <= TEMP_29_res(2) when stq_tail_i(1) else TEMP_29_res(4);
	TEMP_30_res(5) <= TEMP_29_res(3) when stq_tail_i(1) else TEMP_29_res(5);
	TEMP_30_res(6) <= TEMP_29_res(4) when stq_tail_i(1) else TEMP_29_res(6);
	TEMP_30_res(7) <= TEMP_29_res(5) when stq_tail_i(1) else TEMP_29_res(7);
	TEMP_30_res(8) <= TEMP_29_res(6) when stq_tail_i(1) else TEMP_29_res(8);
	TEMP_30_res(9) <= TEMP_29_res(7) when stq_tail_i(1) else TEMP_29_res(9);
	TEMP_30_res(10) <= TEMP_29_res(8) when stq_tail_i(1) else TEMP_29_res(10);
	TEMP_30_res(11) <= TEMP_29_res(9) when stq_tail_i(1) else TEMP_29_res(11);
	TEMP_30_res(12) <= TEMP_29_res(10) when stq_tail_i(1) else TEMP_29_res(12);
	TEMP_30_res(13) <= TEMP_29_res(11) when stq_tail_i(1) else TEMP_29_res(13);
	TEMP_30_res(14) <= TEMP_29_res(12) when stq_tail_i(1) else TEMP_29_res(14);
	TEMP_30_res(15) <= TEMP_29_res(13) when stq_tail_i(1) else TEMP_29_res(15);
	-- Layer End
	ga_ls_order_temp_7(0) <= TEMP_30_res(15) when stq_tail_i(0) else TEMP_30_res(0);
	ga_ls_order_temp_7(1) <= TEMP_30_res(0) when stq_tail_i(0) else TEMP_30_res(1);
	ga_ls_order_temp_7(2) <= TEMP_30_res(1) when stq_tail_i(0) else TEMP_30_res(2);
	ga_ls_order_temp_7(3) <= TEMP_30_res(2) when stq_tail_i(0) else TEMP_30_res(3);
	ga_ls_order_temp_7(4) <= TEMP_30_res(3) when stq_tail_i(0) else TEMP_30_res(4);
	ga_ls_order_temp_7(5) <= TEMP_30_res(4) when stq_tail_i(0) else TEMP_30_res(5);
	ga_ls_order_temp_7(6) <= TEMP_30_res(5) when stq_tail_i(0) else TEMP_30_res(6);
	ga_ls_order_temp_7(7) <= TEMP_30_res(6) when stq_tail_i(0) else TEMP_30_res(7);
	ga_ls_order_temp_7(8) <= TEMP_30_res(7) when stq_tail_i(0) else TEMP_30_res(8);
	ga_ls_order_temp_7(9) <= TEMP_30_res(8) when stq_tail_i(0) else TEMP_30_res(9);
	ga_ls_order_temp_7(10) <= TEMP_30_res(9) when stq_tail_i(0) else TEMP_30_res(10);
	ga_ls_order_temp_7(11) <= TEMP_30_res(10) when stq_tail_i(0) else TEMP_30_res(11);
	ga_ls_order_temp_7(12) <= TEMP_30_res(11) when stq_tail_i(0) else TEMP_30_res(12);
	ga_ls_order_temp_7(13) <= TEMP_30_res(12) when stq_tail_i(0) else TEMP_30_res(13);
	ga_ls_order_temp_7(14) <= TEMP_30_res(13) when stq_tail_i(0) else TEMP_30_res(14);
	ga_ls_order_temp_7(15) <= TEMP_30_res(14) when stq_tail_i(0) else TEMP_30_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_8, ga_ls_order_rom_8, stq_tail)
	TEMP_31_res(0) <= ga_ls_order_rom_8(8) when stq_tail_i(3) else ga_ls_order_rom_8(0);
	TEMP_31_res(1) <= ga_ls_order_rom_8(9) when stq_tail_i(3) else ga_ls_order_rom_8(1);
	TEMP_31_res(2) <= ga_ls_order_rom_8(10) when stq_tail_i(3) else ga_ls_order_rom_8(2);
	TEMP_31_res(3) <= ga_ls_order_rom_8(11) when stq_tail_i(3) else ga_ls_order_rom_8(3);
	TEMP_31_res(4) <= ga_ls_order_rom_8(12) when stq_tail_i(3) else ga_ls_order_rom_8(4);
	TEMP_31_res(5) <= ga_ls_order_rom_8(13) when stq_tail_i(3) else ga_ls_order_rom_8(5);
	TEMP_31_res(6) <= ga_ls_order_rom_8(14) when stq_tail_i(3) else ga_ls_order_rom_8(6);
	TEMP_31_res(7) <= ga_ls_order_rom_8(15) when stq_tail_i(3) else ga_ls_order_rom_8(7);
	TEMP_31_res(8) <= ga_ls_order_rom_8(0) when stq_tail_i(3) else ga_ls_order_rom_8(8);
	TEMP_31_res(9) <= ga_ls_order_rom_8(1) when stq_tail_i(3) else ga_ls_order_rom_8(9);
	TEMP_31_res(10) <= ga_ls_order_rom_8(2) when stq_tail_i(3) else ga_ls_order_rom_8(10);
	TEMP_31_res(11) <= ga_ls_order_rom_8(3) when stq_tail_i(3) else ga_ls_order_rom_8(11);
	TEMP_31_res(12) <= ga_ls_order_rom_8(4) when stq_tail_i(3) else ga_ls_order_rom_8(12);
	TEMP_31_res(13) <= ga_ls_order_rom_8(5) when stq_tail_i(3) else ga_ls_order_rom_8(13);
	TEMP_31_res(14) <= ga_ls_order_rom_8(6) when stq_tail_i(3) else ga_ls_order_rom_8(14);
	TEMP_31_res(15) <= ga_ls_order_rom_8(7) when stq_tail_i(3) else ga_ls_order_rom_8(15);
	-- Layer End
	TEMP_32_res(0) <= TEMP_31_res(12) when stq_tail_i(2) else TEMP_31_res(0);
	TEMP_32_res(1) <= TEMP_31_res(13) when stq_tail_i(2) else TEMP_31_res(1);
	TEMP_32_res(2) <= TEMP_31_res(14) when stq_tail_i(2) else TEMP_31_res(2);
	TEMP_32_res(3) <= TEMP_31_res(15) when stq_tail_i(2) else TEMP_31_res(3);
	TEMP_32_res(4) <= TEMP_31_res(0) when stq_tail_i(2) else TEMP_31_res(4);
	TEMP_32_res(5) <= TEMP_31_res(1) when stq_tail_i(2) else TEMP_31_res(5);
	TEMP_32_res(6) <= TEMP_31_res(2) when stq_tail_i(2) else TEMP_31_res(6);
	TEMP_32_res(7) <= TEMP_31_res(3) when stq_tail_i(2) else TEMP_31_res(7);
	TEMP_32_res(8) <= TEMP_31_res(4) when stq_tail_i(2) else TEMP_31_res(8);
	TEMP_32_res(9) <= TEMP_31_res(5) when stq_tail_i(2) else TEMP_31_res(9);
	TEMP_32_res(10) <= TEMP_31_res(6) when stq_tail_i(2) else TEMP_31_res(10);
	TEMP_32_res(11) <= TEMP_31_res(7) when stq_tail_i(2) else TEMP_31_res(11);
	TEMP_32_res(12) <= TEMP_31_res(8) when stq_tail_i(2) else TEMP_31_res(12);
	TEMP_32_res(13) <= TEMP_31_res(9) when stq_tail_i(2) else TEMP_31_res(13);
	TEMP_32_res(14) <= TEMP_31_res(10) when stq_tail_i(2) else TEMP_31_res(14);
	TEMP_32_res(15) <= TEMP_31_res(11) when stq_tail_i(2) else TEMP_31_res(15);
	-- Layer End
	TEMP_33_res(0) <= TEMP_32_res(14) when stq_tail_i(1) else TEMP_32_res(0);
	TEMP_33_res(1) <= TEMP_32_res(15) when stq_tail_i(1) else TEMP_32_res(1);
	TEMP_33_res(2) <= TEMP_32_res(0) when stq_tail_i(1) else TEMP_32_res(2);
	TEMP_33_res(3) <= TEMP_32_res(1) when stq_tail_i(1) else TEMP_32_res(3);
	TEMP_33_res(4) <= TEMP_32_res(2) when stq_tail_i(1) else TEMP_32_res(4);
	TEMP_33_res(5) <= TEMP_32_res(3) when stq_tail_i(1) else TEMP_32_res(5);
	TEMP_33_res(6) <= TEMP_32_res(4) when stq_tail_i(1) else TEMP_32_res(6);
	TEMP_33_res(7) <= TEMP_32_res(5) when stq_tail_i(1) else TEMP_32_res(7);
	TEMP_33_res(8) <= TEMP_32_res(6) when stq_tail_i(1) else TEMP_32_res(8);
	TEMP_33_res(9) <= TEMP_32_res(7) when stq_tail_i(1) else TEMP_32_res(9);
	TEMP_33_res(10) <= TEMP_32_res(8) when stq_tail_i(1) else TEMP_32_res(10);
	TEMP_33_res(11) <= TEMP_32_res(9) when stq_tail_i(1) else TEMP_32_res(11);
	TEMP_33_res(12) <= TEMP_32_res(10) when stq_tail_i(1) else TEMP_32_res(12);
	TEMP_33_res(13) <= TEMP_32_res(11) when stq_tail_i(1) else TEMP_32_res(13);
	TEMP_33_res(14) <= TEMP_32_res(12) when stq_tail_i(1) else TEMP_32_res(14);
	TEMP_33_res(15) <= TEMP_32_res(13) when stq_tail_i(1) else TEMP_32_res(15);
	-- Layer End
	ga_ls_order_temp_8(0) <= TEMP_33_res(15) when stq_tail_i(0) else TEMP_33_res(0);
	ga_ls_order_temp_8(1) <= TEMP_33_res(0) when stq_tail_i(0) else TEMP_33_res(1);
	ga_ls_order_temp_8(2) <= TEMP_33_res(1) when stq_tail_i(0) else TEMP_33_res(2);
	ga_ls_order_temp_8(3) <= TEMP_33_res(2) when stq_tail_i(0) else TEMP_33_res(3);
	ga_ls_order_temp_8(4) <= TEMP_33_res(3) when stq_tail_i(0) else TEMP_33_res(4);
	ga_ls_order_temp_8(5) <= TEMP_33_res(4) when stq_tail_i(0) else TEMP_33_res(5);
	ga_ls_order_temp_8(6) <= TEMP_33_res(5) when stq_tail_i(0) else TEMP_33_res(6);
	ga_ls_order_temp_8(7) <= TEMP_33_res(6) when stq_tail_i(0) else TEMP_33_res(7);
	ga_ls_order_temp_8(8) <= TEMP_33_res(7) when stq_tail_i(0) else TEMP_33_res(8);
	ga_ls_order_temp_8(9) <= TEMP_33_res(8) when stq_tail_i(0) else TEMP_33_res(9);
	ga_ls_order_temp_8(10) <= TEMP_33_res(9) when stq_tail_i(0) else TEMP_33_res(10);
	ga_ls_order_temp_8(11) <= TEMP_33_res(10) when stq_tail_i(0) else TEMP_33_res(11);
	ga_ls_order_temp_8(12) <= TEMP_33_res(11) when stq_tail_i(0) else TEMP_33_res(12);
	ga_ls_order_temp_8(13) <= TEMP_33_res(12) when stq_tail_i(0) else TEMP_33_res(13);
	ga_ls_order_temp_8(14) <= TEMP_33_res(13) when stq_tail_i(0) else TEMP_33_res(14);
	ga_ls_order_temp_8(15) <= TEMP_33_res(14) when stq_tail_i(0) else TEMP_33_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_9, ga_ls_order_rom_9, stq_tail)
	TEMP_34_res(0) <= ga_ls_order_rom_9(8) when stq_tail_i(3) else ga_ls_order_rom_9(0);
	TEMP_34_res(1) <= ga_ls_order_rom_9(9) when stq_tail_i(3) else ga_ls_order_rom_9(1);
	TEMP_34_res(2) <= ga_ls_order_rom_9(10) when stq_tail_i(3) else ga_ls_order_rom_9(2);
	TEMP_34_res(3) <= ga_ls_order_rom_9(11) when stq_tail_i(3) else ga_ls_order_rom_9(3);
	TEMP_34_res(4) <= ga_ls_order_rom_9(12) when stq_tail_i(3) else ga_ls_order_rom_9(4);
	TEMP_34_res(5) <= ga_ls_order_rom_9(13) when stq_tail_i(3) else ga_ls_order_rom_9(5);
	TEMP_34_res(6) <= ga_ls_order_rom_9(14) when stq_tail_i(3) else ga_ls_order_rom_9(6);
	TEMP_34_res(7) <= ga_ls_order_rom_9(15) when stq_tail_i(3) else ga_ls_order_rom_9(7);
	TEMP_34_res(8) <= ga_ls_order_rom_9(0) when stq_tail_i(3) else ga_ls_order_rom_9(8);
	TEMP_34_res(9) <= ga_ls_order_rom_9(1) when stq_tail_i(3) else ga_ls_order_rom_9(9);
	TEMP_34_res(10) <= ga_ls_order_rom_9(2) when stq_tail_i(3) else ga_ls_order_rom_9(10);
	TEMP_34_res(11) <= ga_ls_order_rom_9(3) when stq_tail_i(3) else ga_ls_order_rom_9(11);
	TEMP_34_res(12) <= ga_ls_order_rom_9(4) when stq_tail_i(3) else ga_ls_order_rom_9(12);
	TEMP_34_res(13) <= ga_ls_order_rom_9(5) when stq_tail_i(3) else ga_ls_order_rom_9(13);
	TEMP_34_res(14) <= ga_ls_order_rom_9(6) when stq_tail_i(3) else ga_ls_order_rom_9(14);
	TEMP_34_res(15) <= ga_ls_order_rom_9(7) when stq_tail_i(3) else ga_ls_order_rom_9(15);
	-- Layer End
	TEMP_35_res(0) <= TEMP_34_res(12) when stq_tail_i(2) else TEMP_34_res(0);
	TEMP_35_res(1) <= TEMP_34_res(13) when stq_tail_i(2) else TEMP_34_res(1);
	TEMP_35_res(2) <= TEMP_34_res(14) when stq_tail_i(2) else TEMP_34_res(2);
	TEMP_35_res(3) <= TEMP_34_res(15) when stq_tail_i(2) else TEMP_34_res(3);
	TEMP_35_res(4) <= TEMP_34_res(0) when stq_tail_i(2) else TEMP_34_res(4);
	TEMP_35_res(5) <= TEMP_34_res(1) when stq_tail_i(2) else TEMP_34_res(5);
	TEMP_35_res(6) <= TEMP_34_res(2) when stq_tail_i(2) else TEMP_34_res(6);
	TEMP_35_res(7) <= TEMP_34_res(3) when stq_tail_i(2) else TEMP_34_res(7);
	TEMP_35_res(8) <= TEMP_34_res(4) when stq_tail_i(2) else TEMP_34_res(8);
	TEMP_35_res(9) <= TEMP_34_res(5) when stq_tail_i(2) else TEMP_34_res(9);
	TEMP_35_res(10) <= TEMP_34_res(6) when stq_tail_i(2) else TEMP_34_res(10);
	TEMP_35_res(11) <= TEMP_34_res(7) when stq_tail_i(2) else TEMP_34_res(11);
	TEMP_35_res(12) <= TEMP_34_res(8) when stq_tail_i(2) else TEMP_34_res(12);
	TEMP_35_res(13) <= TEMP_34_res(9) when stq_tail_i(2) else TEMP_34_res(13);
	TEMP_35_res(14) <= TEMP_34_res(10) when stq_tail_i(2) else TEMP_34_res(14);
	TEMP_35_res(15) <= TEMP_34_res(11) when stq_tail_i(2) else TEMP_34_res(15);
	-- Layer End
	TEMP_36_res(0) <= TEMP_35_res(14) when stq_tail_i(1) else TEMP_35_res(0);
	TEMP_36_res(1) <= TEMP_35_res(15) when stq_tail_i(1) else TEMP_35_res(1);
	TEMP_36_res(2) <= TEMP_35_res(0) when stq_tail_i(1) else TEMP_35_res(2);
	TEMP_36_res(3) <= TEMP_35_res(1) when stq_tail_i(1) else TEMP_35_res(3);
	TEMP_36_res(4) <= TEMP_35_res(2) when stq_tail_i(1) else TEMP_35_res(4);
	TEMP_36_res(5) <= TEMP_35_res(3) when stq_tail_i(1) else TEMP_35_res(5);
	TEMP_36_res(6) <= TEMP_35_res(4) when stq_tail_i(1) else TEMP_35_res(6);
	TEMP_36_res(7) <= TEMP_35_res(5) when stq_tail_i(1) else TEMP_35_res(7);
	TEMP_36_res(8) <= TEMP_35_res(6) when stq_tail_i(1) else TEMP_35_res(8);
	TEMP_36_res(9) <= TEMP_35_res(7) when stq_tail_i(1) else TEMP_35_res(9);
	TEMP_36_res(10) <= TEMP_35_res(8) when stq_tail_i(1) else TEMP_35_res(10);
	TEMP_36_res(11) <= TEMP_35_res(9) when stq_tail_i(1) else TEMP_35_res(11);
	TEMP_36_res(12) <= TEMP_35_res(10) when stq_tail_i(1) else TEMP_35_res(12);
	TEMP_36_res(13) <= TEMP_35_res(11) when stq_tail_i(1) else TEMP_35_res(13);
	TEMP_36_res(14) <= TEMP_35_res(12) when stq_tail_i(1) else TEMP_35_res(14);
	TEMP_36_res(15) <= TEMP_35_res(13) when stq_tail_i(1) else TEMP_35_res(15);
	-- Layer End
	ga_ls_order_temp_9(0) <= TEMP_36_res(15) when stq_tail_i(0) else TEMP_36_res(0);
	ga_ls_order_temp_9(1) <= TEMP_36_res(0) when stq_tail_i(0) else TEMP_36_res(1);
	ga_ls_order_temp_9(2) <= TEMP_36_res(1) when stq_tail_i(0) else TEMP_36_res(2);
	ga_ls_order_temp_9(3) <= TEMP_36_res(2) when stq_tail_i(0) else TEMP_36_res(3);
	ga_ls_order_temp_9(4) <= TEMP_36_res(3) when stq_tail_i(0) else TEMP_36_res(4);
	ga_ls_order_temp_9(5) <= TEMP_36_res(4) when stq_tail_i(0) else TEMP_36_res(5);
	ga_ls_order_temp_9(6) <= TEMP_36_res(5) when stq_tail_i(0) else TEMP_36_res(6);
	ga_ls_order_temp_9(7) <= TEMP_36_res(6) when stq_tail_i(0) else TEMP_36_res(7);
	ga_ls_order_temp_9(8) <= TEMP_36_res(7) when stq_tail_i(0) else TEMP_36_res(8);
	ga_ls_order_temp_9(9) <= TEMP_36_res(8) when stq_tail_i(0) else TEMP_36_res(9);
	ga_ls_order_temp_9(10) <= TEMP_36_res(9) when stq_tail_i(0) else TEMP_36_res(10);
	ga_ls_order_temp_9(11) <= TEMP_36_res(10) when stq_tail_i(0) else TEMP_36_res(11);
	ga_ls_order_temp_9(12) <= TEMP_36_res(11) when stq_tail_i(0) else TEMP_36_res(12);
	ga_ls_order_temp_9(13) <= TEMP_36_res(12) when stq_tail_i(0) else TEMP_36_res(13);
	ga_ls_order_temp_9(14) <= TEMP_36_res(13) when stq_tail_i(0) else TEMP_36_res(14);
	ga_ls_order_temp_9(15) <= TEMP_36_res(14) when stq_tail_i(0) else TEMP_36_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_10, ga_ls_order_rom_10, stq_tail)
	TEMP_37_res(0) <= ga_ls_order_rom_10(8) when stq_tail_i(3) else ga_ls_order_rom_10(0);
	TEMP_37_res(1) <= ga_ls_order_rom_10(9) when stq_tail_i(3) else ga_ls_order_rom_10(1);
	TEMP_37_res(2) <= ga_ls_order_rom_10(10) when stq_tail_i(3) else ga_ls_order_rom_10(2);
	TEMP_37_res(3) <= ga_ls_order_rom_10(11) when stq_tail_i(3) else ga_ls_order_rom_10(3);
	TEMP_37_res(4) <= ga_ls_order_rom_10(12) when stq_tail_i(3) else ga_ls_order_rom_10(4);
	TEMP_37_res(5) <= ga_ls_order_rom_10(13) when stq_tail_i(3) else ga_ls_order_rom_10(5);
	TEMP_37_res(6) <= ga_ls_order_rom_10(14) when stq_tail_i(3) else ga_ls_order_rom_10(6);
	TEMP_37_res(7) <= ga_ls_order_rom_10(15) when stq_tail_i(3) else ga_ls_order_rom_10(7);
	TEMP_37_res(8) <= ga_ls_order_rom_10(0) when stq_tail_i(3) else ga_ls_order_rom_10(8);
	TEMP_37_res(9) <= ga_ls_order_rom_10(1) when stq_tail_i(3) else ga_ls_order_rom_10(9);
	TEMP_37_res(10) <= ga_ls_order_rom_10(2) when stq_tail_i(3) else ga_ls_order_rom_10(10);
	TEMP_37_res(11) <= ga_ls_order_rom_10(3) when stq_tail_i(3) else ga_ls_order_rom_10(11);
	TEMP_37_res(12) <= ga_ls_order_rom_10(4) when stq_tail_i(3) else ga_ls_order_rom_10(12);
	TEMP_37_res(13) <= ga_ls_order_rom_10(5) when stq_tail_i(3) else ga_ls_order_rom_10(13);
	TEMP_37_res(14) <= ga_ls_order_rom_10(6) when stq_tail_i(3) else ga_ls_order_rom_10(14);
	TEMP_37_res(15) <= ga_ls_order_rom_10(7) when stq_tail_i(3) else ga_ls_order_rom_10(15);
	-- Layer End
	TEMP_38_res(0) <= TEMP_37_res(12) when stq_tail_i(2) else TEMP_37_res(0);
	TEMP_38_res(1) <= TEMP_37_res(13) when stq_tail_i(2) else TEMP_37_res(1);
	TEMP_38_res(2) <= TEMP_37_res(14) when stq_tail_i(2) else TEMP_37_res(2);
	TEMP_38_res(3) <= TEMP_37_res(15) when stq_tail_i(2) else TEMP_37_res(3);
	TEMP_38_res(4) <= TEMP_37_res(0) when stq_tail_i(2) else TEMP_37_res(4);
	TEMP_38_res(5) <= TEMP_37_res(1) when stq_tail_i(2) else TEMP_37_res(5);
	TEMP_38_res(6) <= TEMP_37_res(2) when stq_tail_i(2) else TEMP_37_res(6);
	TEMP_38_res(7) <= TEMP_37_res(3) when stq_tail_i(2) else TEMP_37_res(7);
	TEMP_38_res(8) <= TEMP_37_res(4) when stq_tail_i(2) else TEMP_37_res(8);
	TEMP_38_res(9) <= TEMP_37_res(5) when stq_tail_i(2) else TEMP_37_res(9);
	TEMP_38_res(10) <= TEMP_37_res(6) when stq_tail_i(2) else TEMP_37_res(10);
	TEMP_38_res(11) <= TEMP_37_res(7) when stq_tail_i(2) else TEMP_37_res(11);
	TEMP_38_res(12) <= TEMP_37_res(8) when stq_tail_i(2) else TEMP_37_res(12);
	TEMP_38_res(13) <= TEMP_37_res(9) when stq_tail_i(2) else TEMP_37_res(13);
	TEMP_38_res(14) <= TEMP_37_res(10) when stq_tail_i(2) else TEMP_37_res(14);
	TEMP_38_res(15) <= TEMP_37_res(11) when stq_tail_i(2) else TEMP_37_res(15);
	-- Layer End
	TEMP_39_res(0) <= TEMP_38_res(14) when stq_tail_i(1) else TEMP_38_res(0);
	TEMP_39_res(1) <= TEMP_38_res(15) when stq_tail_i(1) else TEMP_38_res(1);
	TEMP_39_res(2) <= TEMP_38_res(0) when stq_tail_i(1) else TEMP_38_res(2);
	TEMP_39_res(3) <= TEMP_38_res(1) when stq_tail_i(1) else TEMP_38_res(3);
	TEMP_39_res(4) <= TEMP_38_res(2) when stq_tail_i(1) else TEMP_38_res(4);
	TEMP_39_res(5) <= TEMP_38_res(3) when stq_tail_i(1) else TEMP_38_res(5);
	TEMP_39_res(6) <= TEMP_38_res(4) when stq_tail_i(1) else TEMP_38_res(6);
	TEMP_39_res(7) <= TEMP_38_res(5) when stq_tail_i(1) else TEMP_38_res(7);
	TEMP_39_res(8) <= TEMP_38_res(6) when stq_tail_i(1) else TEMP_38_res(8);
	TEMP_39_res(9) <= TEMP_38_res(7) when stq_tail_i(1) else TEMP_38_res(9);
	TEMP_39_res(10) <= TEMP_38_res(8) when stq_tail_i(1) else TEMP_38_res(10);
	TEMP_39_res(11) <= TEMP_38_res(9) when stq_tail_i(1) else TEMP_38_res(11);
	TEMP_39_res(12) <= TEMP_38_res(10) when stq_tail_i(1) else TEMP_38_res(12);
	TEMP_39_res(13) <= TEMP_38_res(11) when stq_tail_i(1) else TEMP_38_res(13);
	TEMP_39_res(14) <= TEMP_38_res(12) when stq_tail_i(1) else TEMP_38_res(14);
	TEMP_39_res(15) <= TEMP_38_res(13) when stq_tail_i(1) else TEMP_38_res(15);
	-- Layer End
	ga_ls_order_temp_10(0) <= TEMP_39_res(15) when stq_tail_i(0) else TEMP_39_res(0);
	ga_ls_order_temp_10(1) <= TEMP_39_res(0) when stq_tail_i(0) else TEMP_39_res(1);
	ga_ls_order_temp_10(2) <= TEMP_39_res(1) when stq_tail_i(0) else TEMP_39_res(2);
	ga_ls_order_temp_10(3) <= TEMP_39_res(2) when stq_tail_i(0) else TEMP_39_res(3);
	ga_ls_order_temp_10(4) <= TEMP_39_res(3) when stq_tail_i(0) else TEMP_39_res(4);
	ga_ls_order_temp_10(5) <= TEMP_39_res(4) when stq_tail_i(0) else TEMP_39_res(5);
	ga_ls_order_temp_10(6) <= TEMP_39_res(5) when stq_tail_i(0) else TEMP_39_res(6);
	ga_ls_order_temp_10(7) <= TEMP_39_res(6) when stq_tail_i(0) else TEMP_39_res(7);
	ga_ls_order_temp_10(8) <= TEMP_39_res(7) when stq_tail_i(0) else TEMP_39_res(8);
	ga_ls_order_temp_10(9) <= TEMP_39_res(8) when stq_tail_i(0) else TEMP_39_res(9);
	ga_ls_order_temp_10(10) <= TEMP_39_res(9) when stq_tail_i(0) else TEMP_39_res(10);
	ga_ls_order_temp_10(11) <= TEMP_39_res(10) when stq_tail_i(0) else TEMP_39_res(11);
	ga_ls_order_temp_10(12) <= TEMP_39_res(11) when stq_tail_i(0) else TEMP_39_res(12);
	ga_ls_order_temp_10(13) <= TEMP_39_res(12) when stq_tail_i(0) else TEMP_39_res(13);
	ga_ls_order_temp_10(14) <= TEMP_39_res(13) when stq_tail_i(0) else TEMP_39_res(14);
	ga_ls_order_temp_10(15) <= TEMP_39_res(14) when stq_tail_i(0) else TEMP_39_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_11, ga_ls_order_rom_11, stq_tail)
	TEMP_40_res(0) <= ga_ls_order_rom_11(8) when stq_tail_i(3) else ga_ls_order_rom_11(0);
	TEMP_40_res(1) <= ga_ls_order_rom_11(9) when stq_tail_i(3) else ga_ls_order_rom_11(1);
	TEMP_40_res(2) <= ga_ls_order_rom_11(10) when stq_tail_i(3) else ga_ls_order_rom_11(2);
	TEMP_40_res(3) <= ga_ls_order_rom_11(11) when stq_tail_i(3) else ga_ls_order_rom_11(3);
	TEMP_40_res(4) <= ga_ls_order_rom_11(12) when stq_tail_i(3) else ga_ls_order_rom_11(4);
	TEMP_40_res(5) <= ga_ls_order_rom_11(13) when stq_tail_i(3) else ga_ls_order_rom_11(5);
	TEMP_40_res(6) <= ga_ls_order_rom_11(14) when stq_tail_i(3) else ga_ls_order_rom_11(6);
	TEMP_40_res(7) <= ga_ls_order_rom_11(15) when stq_tail_i(3) else ga_ls_order_rom_11(7);
	TEMP_40_res(8) <= ga_ls_order_rom_11(0) when stq_tail_i(3) else ga_ls_order_rom_11(8);
	TEMP_40_res(9) <= ga_ls_order_rom_11(1) when stq_tail_i(3) else ga_ls_order_rom_11(9);
	TEMP_40_res(10) <= ga_ls_order_rom_11(2) when stq_tail_i(3) else ga_ls_order_rom_11(10);
	TEMP_40_res(11) <= ga_ls_order_rom_11(3) when stq_tail_i(3) else ga_ls_order_rom_11(11);
	TEMP_40_res(12) <= ga_ls_order_rom_11(4) when stq_tail_i(3) else ga_ls_order_rom_11(12);
	TEMP_40_res(13) <= ga_ls_order_rom_11(5) when stq_tail_i(3) else ga_ls_order_rom_11(13);
	TEMP_40_res(14) <= ga_ls_order_rom_11(6) when stq_tail_i(3) else ga_ls_order_rom_11(14);
	TEMP_40_res(15) <= ga_ls_order_rom_11(7) when stq_tail_i(3) else ga_ls_order_rom_11(15);
	-- Layer End
	TEMP_41_res(0) <= TEMP_40_res(12) when stq_tail_i(2) else TEMP_40_res(0);
	TEMP_41_res(1) <= TEMP_40_res(13) when stq_tail_i(2) else TEMP_40_res(1);
	TEMP_41_res(2) <= TEMP_40_res(14) when stq_tail_i(2) else TEMP_40_res(2);
	TEMP_41_res(3) <= TEMP_40_res(15) when stq_tail_i(2) else TEMP_40_res(3);
	TEMP_41_res(4) <= TEMP_40_res(0) when stq_tail_i(2) else TEMP_40_res(4);
	TEMP_41_res(5) <= TEMP_40_res(1) when stq_tail_i(2) else TEMP_40_res(5);
	TEMP_41_res(6) <= TEMP_40_res(2) when stq_tail_i(2) else TEMP_40_res(6);
	TEMP_41_res(7) <= TEMP_40_res(3) when stq_tail_i(2) else TEMP_40_res(7);
	TEMP_41_res(8) <= TEMP_40_res(4) when stq_tail_i(2) else TEMP_40_res(8);
	TEMP_41_res(9) <= TEMP_40_res(5) when stq_tail_i(2) else TEMP_40_res(9);
	TEMP_41_res(10) <= TEMP_40_res(6) when stq_tail_i(2) else TEMP_40_res(10);
	TEMP_41_res(11) <= TEMP_40_res(7) when stq_tail_i(2) else TEMP_40_res(11);
	TEMP_41_res(12) <= TEMP_40_res(8) when stq_tail_i(2) else TEMP_40_res(12);
	TEMP_41_res(13) <= TEMP_40_res(9) when stq_tail_i(2) else TEMP_40_res(13);
	TEMP_41_res(14) <= TEMP_40_res(10) when stq_tail_i(2) else TEMP_40_res(14);
	TEMP_41_res(15) <= TEMP_40_res(11) when stq_tail_i(2) else TEMP_40_res(15);
	-- Layer End
	TEMP_42_res(0) <= TEMP_41_res(14) when stq_tail_i(1) else TEMP_41_res(0);
	TEMP_42_res(1) <= TEMP_41_res(15) when stq_tail_i(1) else TEMP_41_res(1);
	TEMP_42_res(2) <= TEMP_41_res(0) when stq_tail_i(1) else TEMP_41_res(2);
	TEMP_42_res(3) <= TEMP_41_res(1) when stq_tail_i(1) else TEMP_41_res(3);
	TEMP_42_res(4) <= TEMP_41_res(2) when stq_tail_i(1) else TEMP_41_res(4);
	TEMP_42_res(5) <= TEMP_41_res(3) when stq_tail_i(1) else TEMP_41_res(5);
	TEMP_42_res(6) <= TEMP_41_res(4) when stq_tail_i(1) else TEMP_41_res(6);
	TEMP_42_res(7) <= TEMP_41_res(5) when stq_tail_i(1) else TEMP_41_res(7);
	TEMP_42_res(8) <= TEMP_41_res(6) when stq_tail_i(1) else TEMP_41_res(8);
	TEMP_42_res(9) <= TEMP_41_res(7) when stq_tail_i(1) else TEMP_41_res(9);
	TEMP_42_res(10) <= TEMP_41_res(8) when stq_tail_i(1) else TEMP_41_res(10);
	TEMP_42_res(11) <= TEMP_41_res(9) when stq_tail_i(1) else TEMP_41_res(11);
	TEMP_42_res(12) <= TEMP_41_res(10) when stq_tail_i(1) else TEMP_41_res(12);
	TEMP_42_res(13) <= TEMP_41_res(11) when stq_tail_i(1) else TEMP_41_res(13);
	TEMP_42_res(14) <= TEMP_41_res(12) when stq_tail_i(1) else TEMP_41_res(14);
	TEMP_42_res(15) <= TEMP_41_res(13) when stq_tail_i(1) else TEMP_41_res(15);
	-- Layer End
	ga_ls_order_temp_11(0) <= TEMP_42_res(15) when stq_tail_i(0) else TEMP_42_res(0);
	ga_ls_order_temp_11(1) <= TEMP_42_res(0) when stq_tail_i(0) else TEMP_42_res(1);
	ga_ls_order_temp_11(2) <= TEMP_42_res(1) when stq_tail_i(0) else TEMP_42_res(2);
	ga_ls_order_temp_11(3) <= TEMP_42_res(2) when stq_tail_i(0) else TEMP_42_res(3);
	ga_ls_order_temp_11(4) <= TEMP_42_res(3) when stq_tail_i(0) else TEMP_42_res(4);
	ga_ls_order_temp_11(5) <= TEMP_42_res(4) when stq_tail_i(0) else TEMP_42_res(5);
	ga_ls_order_temp_11(6) <= TEMP_42_res(5) when stq_tail_i(0) else TEMP_42_res(6);
	ga_ls_order_temp_11(7) <= TEMP_42_res(6) when stq_tail_i(0) else TEMP_42_res(7);
	ga_ls_order_temp_11(8) <= TEMP_42_res(7) when stq_tail_i(0) else TEMP_42_res(8);
	ga_ls_order_temp_11(9) <= TEMP_42_res(8) when stq_tail_i(0) else TEMP_42_res(9);
	ga_ls_order_temp_11(10) <= TEMP_42_res(9) when stq_tail_i(0) else TEMP_42_res(10);
	ga_ls_order_temp_11(11) <= TEMP_42_res(10) when stq_tail_i(0) else TEMP_42_res(11);
	ga_ls_order_temp_11(12) <= TEMP_42_res(11) when stq_tail_i(0) else TEMP_42_res(12);
	ga_ls_order_temp_11(13) <= TEMP_42_res(12) when stq_tail_i(0) else TEMP_42_res(13);
	ga_ls_order_temp_11(14) <= TEMP_42_res(13) when stq_tail_i(0) else TEMP_42_res(14);
	ga_ls_order_temp_11(15) <= TEMP_42_res(14) when stq_tail_i(0) else TEMP_42_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_12, ga_ls_order_rom_12, stq_tail)
	TEMP_43_res(0) <= ga_ls_order_rom_12(8) when stq_tail_i(3) else ga_ls_order_rom_12(0);
	TEMP_43_res(1) <= ga_ls_order_rom_12(9) when stq_tail_i(3) else ga_ls_order_rom_12(1);
	TEMP_43_res(2) <= ga_ls_order_rom_12(10) when stq_tail_i(3) else ga_ls_order_rom_12(2);
	TEMP_43_res(3) <= ga_ls_order_rom_12(11) when stq_tail_i(3) else ga_ls_order_rom_12(3);
	TEMP_43_res(4) <= ga_ls_order_rom_12(12) when stq_tail_i(3) else ga_ls_order_rom_12(4);
	TEMP_43_res(5) <= ga_ls_order_rom_12(13) when stq_tail_i(3) else ga_ls_order_rom_12(5);
	TEMP_43_res(6) <= ga_ls_order_rom_12(14) when stq_tail_i(3) else ga_ls_order_rom_12(6);
	TEMP_43_res(7) <= ga_ls_order_rom_12(15) when stq_tail_i(3) else ga_ls_order_rom_12(7);
	TEMP_43_res(8) <= ga_ls_order_rom_12(0) when stq_tail_i(3) else ga_ls_order_rom_12(8);
	TEMP_43_res(9) <= ga_ls_order_rom_12(1) when stq_tail_i(3) else ga_ls_order_rom_12(9);
	TEMP_43_res(10) <= ga_ls_order_rom_12(2) when stq_tail_i(3) else ga_ls_order_rom_12(10);
	TEMP_43_res(11) <= ga_ls_order_rom_12(3) when stq_tail_i(3) else ga_ls_order_rom_12(11);
	TEMP_43_res(12) <= ga_ls_order_rom_12(4) when stq_tail_i(3) else ga_ls_order_rom_12(12);
	TEMP_43_res(13) <= ga_ls_order_rom_12(5) when stq_tail_i(3) else ga_ls_order_rom_12(13);
	TEMP_43_res(14) <= ga_ls_order_rom_12(6) when stq_tail_i(3) else ga_ls_order_rom_12(14);
	TEMP_43_res(15) <= ga_ls_order_rom_12(7) when stq_tail_i(3) else ga_ls_order_rom_12(15);
	-- Layer End
	TEMP_44_res(0) <= TEMP_43_res(12) when stq_tail_i(2) else TEMP_43_res(0);
	TEMP_44_res(1) <= TEMP_43_res(13) when stq_tail_i(2) else TEMP_43_res(1);
	TEMP_44_res(2) <= TEMP_43_res(14) when stq_tail_i(2) else TEMP_43_res(2);
	TEMP_44_res(3) <= TEMP_43_res(15) when stq_tail_i(2) else TEMP_43_res(3);
	TEMP_44_res(4) <= TEMP_43_res(0) when stq_tail_i(2) else TEMP_43_res(4);
	TEMP_44_res(5) <= TEMP_43_res(1) when stq_tail_i(2) else TEMP_43_res(5);
	TEMP_44_res(6) <= TEMP_43_res(2) when stq_tail_i(2) else TEMP_43_res(6);
	TEMP_44_res(7) <= TEMP_43_res(3) when stq_tail_i(2) else TEMP_43_res(7);
	TEMP_44_res(8) <= TEMP_43_res(4) when stq_tail_i(2) else TEMP_43_res(8);
	TEMP_44_res(9) <= TEMP_43_res(5) when stq_tail_i(2) else TEMP_43_res(9);
	TEMP_44_res(10) <= TEMP_43_res(6) when stq_tail_i(2) else TEMP_43_res(10);
	TEMP_44_res(11) <= TEMP_43_res(7) when stq_tail_i(2) else TEMP_43_res(11);
	TEMP_44_res(12) <= TEMP_43_res(8) when stq_tail_i(2) else TEMP_43_res(12);
	TEMP_44_res(13) <= TEMP_43_res(9) when stq_tail_i(2) else TEMP_43_res(13);
	TEMP_44_res(14) <= TEMP_43_res(10) when stq_tail_i(2) else TEMP_43_res(14);
	TEMP_44_res(15) <= TEMP_43_res(11) when stq_tail_i(2) else TEMP_43_res(15);
	-- Layer End
	TEMP_45_res(0) <= TEMP_44_res(14) when stq_tail_i(1) else TEMP_44_res(0);
	TEMP_45_res(1) <= TEMP_44_res(15) when stq_tail_i(1) else TEMP_44_res(1);
	TEMP_45_res(2) <= TEMP_44_res(0) when stq_tail_i(1) else TEMP_44_res(2);
	TEMP_45_res(3) <= TEMP_44_res(1) when stq_tail_i(1) else TEMP_44_res(3);
	TEMP_45_res(4) <= TEMP_44_res(2) when stq_tail_i(1) else TEMP_44_res(4);
	TEMP_45_res(5) <= TEMP_44_res(3) when stq_tail_i(1) else TEMP_44_res(5);
	TEMP_45_res(6) <= TEMP_44_res(4) when stq_tail_i(1) else TEMP_44_res(6);
	TEMP_45_res(7) <= TEMP_44_res(5) when stq_tail_i(1) else TEMP_44_res(7);
	TEMP_45_res(8) <= TEMP_44_res(6) when stq_tail_i(1) else TEMP_44_res(8);
	TEMP_45_res(9) <= TEMP_44_res(7) when stq_tail_i(1) else TEMP_44_res(9);
	TEMP_45_res(10) <= TEMP_44_res(8) when stq_tail_i(1) else TEMP_44_res(10);
	TEMP_45_res(11) <= TEMP_44_res(9) when stq_tail_i(1) else TEMP_44_res(11);
	TEMP_45_res(12) <= TEMP_44_res(10) when stq_tail_i(1) else TEMP_44_res(12);
	TEMP_45_res(13) <= TEMP_44_res(11) when stq_tail_i(1) else TEMP_44_res(13);
	TEMP_45_res(14) <= TEMP_44_res(12) when stq_tail_i(1) else TEMP_44_res(14);
	TEMP_45_res(15) <= TEMP_44_res(13) when stq_tail_i(1) else TEMP_44_res(15);
	-- Layer End
	ga_ls_order_temp_12(0) <= TEMP_45_res(15) when stq_tail_i(0) else TEMP_45_res(0);
	ga_ls_order_temp_12(1) <= TEMP_45_res(0) when stq_tail_i(0) else TEMP_45_res(1);
	ga_ls_order_temp_12(2) <= TEMP_45_res(1) when stq_tail_i(0) else TEMP_45_res(2);
	ga_ls_order_temp_12(3) <= TEMP_45_res(2) when stq_tail_i(0) else TEMP_45_res(3);
	ga_ls_order_temp_12(4) <= TEMP_45_res(3) when stq_tail_i(0) else TEMP_45_res(4);
	ga_ls_order_temp_12(5) <= TEMP_45_res(4) when stq_tail_i(0) else TEMP_45_res(5);
	ga_ls_order_temp_12(6) <= TEMP_45_res(5) when stq_tail_i(0) else TEMP_45_res(6);
	ga_ls_order_temp_12(7) <= TEMP_45_res(6) when stq_tail_i(0) else TEMP_45_res(7);
	ga_ls_order_temp_12(8) <= TEMP_45_res(7) when stq_tail_i(0) else TEMP_45_res(8);
	ga_ls_order_temp_12(9) <= TEMP_45_res(8) when stq_tail_i(0) else TEMP_45_res(9);
	ga_ls_order_temp_12(10) <= TEMP_45_res(9) when stq_tail_i(0) else TEMP_45_res(10);
	ga_ls_order_temp_12(11) <= TEMP_45_res(10) when stq_tail_i(0) else TEMP_45_res(11);
	ga_ls_order_temp_12(12) <= TEMP_45_res(11) when stq_tail_i(0) else TEMP_45_res(12);
	ga_ls_order_temp_12(13) <= TEMP_45_res(12) when stq_tail_i(0) else TEMP_45_res(13);
	ga_ls_order_temp_12(14) <= TEMP_45_res(13) when stq_tail_i(0) else TEMP_45_res(14);
	ga_ls_order_temp_12(15) <= TEMP_45_res(14) when stq_tail_i(0) else TEMP_45_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_13, ga_ls_order_rom_13, stq_tail)
	TEMP_46_res(0) <= ga_ls_order_rom_13(8) when stq_tail_i(3) else ga_ls_order_rom_13(0);
	TEMP_46_res(1) <= ga_ls_order_rom_13(9) when stq_tail_i(3) else ga_ls_order_rom_13(1);
	TEMP_46_res(2) <= ga_ls_order_rom_13(10) when stq_tail_i(3) else ga_ls_order_rom_13(2);
	TEMP_46_res(3) <= ga_ls_order_rom_13(11) when stq_tail_i(3) else ga_ls_order_rom_13(3);
	TEMP_46_res(4) <= ga_ls_order_rom_13(12) when stq_tail_i(3) else ga_ls_order_rom_13(4);
	TEMP_46_res(5) <= ga_ls_order_rom_13(13) when stq_tail_i(3) else ga_ls_order_rom_13(5);
	TEMP_46_res(6) <= ga_ls_order_rom_13(14) when stq_tail_i(3) else ga_ls_order_rom_13(6);
	TEMP_46_res(7) <= ga_ls_order_rom_13(15) when stq_tail_i(3) else ga_ls_order_rom_13(7);
	TEMP_46_res(8) <= ga_ls_order_rom_13(0) when stq_tail_i(3) else ga_ls_order_rom_13(8);
	TEMP_46_res(9) <= ga_ls_order_rom_13(1) when stq_tail_i(3) else ga_ls_order_rom_13(9);
	TEMP_46_res(10) <= ga_ls_order_rom_13(2) when stq_tail_i(3) else ga_ls_order_rom_13(10);
	TEMP_46_res(11) <= ga_ls_order_rom_13(3) when stq_tail_i(3) else ga_ls_order_rom_13(11);
	TEMP_46_res(12) <= ga_ls_order_rom_13(4) when stq_tail_i(3) else ga_ls_order_rom_13(12);
	TEMP_46_res(13) <= ga_ls_order_rom_13(5) when stq_tail_i(3) else ga_ls_order_rom_13(13);
	TEMP_46_res(14) <= ga_ls_order_rom_13(6) when stq_tail_i(3) else ga_ls_order_rom_13(14);
	TEMP_46_res(15) <= ga_ls_order_rom_13(7) when stq_tail_i(3) else ga_ls_order_rom_13(15);
	-- Layer End
	TEMP_47_res(0) <= TEMP_46_res(12) when stq_tail_i(2) else TEMP_46_res(0);
	TEMP_47_res(1) <= TEMP_46_res(13) when stq_tail_i(2) else TEMP_46_res(1);
	TEMP_47_res(2) <= TEMP_46_res(14) when stq_tail_i(2) else TEMP_46_res(2);
	TEMP_47_res(3) <= TEMP_46_res(15) when stq_tail_i(2) else TEMP_46_res(3);
	TEMP_47_res(4) <= TEMP_46_res(0) when stq_tail_i(2) else TEMP_46_res(4);
	TEMP_47_res(5) <= TEMP_46_res(1) when stq_tail_i(2) else TEMP_46_res(5);
	TEMP_47_res(6) <= TEMP_46_res(2) when stq_tail_i(2) else TEMP_46_res(6);
	TEMP_47_res(7) <= TEMP_46_res(3) when stq_tail_i(2) else TEMP_46_res(7);
	TEMP_47_res(8) <= TEMP_46_res(4) when stq_tail_i(2) else TEMP_46_res(8);
	TEMP_47_res(9) <= TEMP_46_res(5) when stq_tail_i(2) else TEMP_46_res(9);
	TEMP_47_res(10) <= TEMP_46_res(6) when stq_tail_i(2) else TEMP_46_res(10);
	TEMP_47_res(11) <= TEMP_46_res(7) when stq_tail_i(2) else TEMP_46_res(11);
	TEMP_47_res(12) <= TEMP_46_res(8) when stq_tail_i(2) else TEMP_46_res(12);
	TEMP_47_res(13) <= TEMP_46_res(9) when stq_tail_i(2) else TEMP_46_res(13);
	TEMP_47_res(14) <= TEMP_46_res(10) when stq_tail_i(2) else TEMP_46_res(14);
	TEMP_47_res(15) <= TEMP_46_res(11) when stq_tail_i(2) else TEMP_46_res(15);
	-- Layer End
	TEMP_48_res(0) <= TEMP_47_res(14) when stq_tail_i(1) else TEMP_47_res(0);
	TEMP_48_res(1) <= TEMP_47_res(15) when stq_tail_i(1) else TEMP_47_res(1);
	TEMP_48_res(2) <= TEMP_47_res(0) when stq_tail_i(1) else TEMP_47_res(2);
	TEMP_48_res(3) <= TEMP_47_res(1) when stq_tail_i(1) else TEMP_47_res(3);
	TEMP_48_res(4) <= TEMP_47_res(2) when stq_tail_i(1) else TEMP_47_res(4);
	TEMP_48_res(5) <= TEMP_47_res(3) when stq_tail_i(1) else TEMP_47_res(5);
	TEMP_48_res(6) <= TEMP_47_res(4) when stq_tail_i(1) else TEMP_47_res(6);
	TEMP_48_res(7) <= TEMP_47_res(5) when stq_tail_i(1) else TEMP_47_res(7);
	TEMP_48_res(8) <= TEMP_47_res(6) when stq_tail_i(1) else TEMP_47_res(8);
	TEMP_48_res(9) <= TEMP_47_res(7) when stq_tail_i(1) else TEMP_47_res(9);
	TEMP_48_res(10) <= TEMP_47_res(8) when stq_tail_i(1) else TEMP_47_res(10);
	TEMP_48_res(11) <= TEMP_47_res(9) when stq_tail_i(1) else TEMP_47_res(11);
	TEMP_48_res(12) <= TEMP_47_res(10) when stq_tail_i(1) else TEMP_47_res(12);
	TEMP_48_res(13) <= TEMP_47_res(11) when stq_tail_i(1) else TEMP_47_res(13);
	TEMP_48_res(14) <= TEMP_47_res(12) when stq_tail_i(1) else TEMP_47_res(14);
	TEMP_48_res(15) <= TEMP_47_res(13) when stq_tail_i(1) else TEMP_47_res(15);
	-- Layer End
	ga_ls_order_temp_13(0) <= TEMP_48_res(15) when stq_tail_i(0) else TEMP_48_res(0);
	ga_ls_order_temp_13(1) <= TEMP_48_res(0) when stq_tail_i(0) else TEMP_48_res(1);
	ga_ls_order_temp_13(2) <= TEMP_48_res(1) when stq_tail_i(0) else TEMP_48_res(2);
	ga_ls_order_temp_13(3) <= TEMP_48_res(2) when stq_tail_i(0) else TEMP_48_res(3);
	ga_ls_order_temp_13(4) <= TEMP_48_res(3) when stq_tail_i(0) else TEMP_48_res(4);
	ga_ls_order_temp_13(5) <= TEMP_48_res(4) when stq_tail_i(0) else TEMP_48_res(5);
	ga_ls_order_temp_13(6) <= TEMP_48_res(5) when stq_tail_i(0) else TEMP_48_res(6);
	ga_ls_order_temp_13(7) <= TEMP_48_res(6) when stq_tail_i(0) else TEMP_48_res(7);
	ga_ls_order_temp_13(8) <= TEMP_48_res(7) when stq_tail_i(0) else TEMP_48_res(8);
	ga_ls_order_temp_13(9) <= TEMP_48_res(8) when stq_tail_i(0) else TEMP_48_res(9);
	ga_ls_order_temp_13(10) <= TEMP_48_res(9) when stq_tail_i(0) else TEMP_48_res(10);
	ga_ls_order_temp_13(11) <= TEMP_48_res(10) when stq_tail_i(0) else TEMP_48_res(11);
	ga_ls_order_temp_13(12) <= TEMP_48_res(11) when stq_tail_i(0) else TEMP_48_res(12);
	ga_ls_order_temp_13(13) <= TEMP_48_res(12) when stq_tail_i(0) else TEMP_48_res(13);
	ga_ls_order_temp_13(14) <= TEMP_48_res(13) when stq_tail_i(0) else TEMP_48_res(14);
	ga_ls_order_temp_13(15) <= TEMP_48_res(14) when stq_tail_i(0) else TEMP_48_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_14, ga_ls_order_rom_14, stq_tail)
	TEMP_49_res(0) <= ga_ls_order_rom_14(8) when stq_tail_i(3) else ga_ls_order_rom_14(0);
	TEMP_49_res(1) <= ga_ls_order_rom_14(9) when stq_tail_i(3) else ga_ls_order_rom_14(1);
	TEMP_49_res(2) <= ga_ls_order_rom_14(10) when stq_tail_i(3) else ga_ls_order_rom_14(2);
	TEMP_49_res(3) <= ga_ls_order_rom_14(11) when stq_tail_i(3) else ga_ls_order_rom_14(3);
	TEMP_49_res(4) <= ga_ls_order_rom_14(12) when stq_tail_i(3) else ga_ls_order_rom_14(4);
	TEMP_49_res(5) <= ga_ls_order_rom_14(13) when stq_tail_i(3) else ga_ls_order_rom_14(5);
	TEMP_49_res(6) <= ga_ls_order_rom_14(14) when stq_tail_i(3) else ga_ls_order_rom_14(6);
	TEMP_49_res(7) <= ga_ls_order_rom_14(15) when stq_tail_i(3) else ga_ls_order_rom_14(7);
	TEMP_49_res(8) <= ga_ls_order_rom_14(0) when stq_tail_i(3) else ga_ls_order_rom_14(8);
	TEMP_49_res(9) <= ga_ls_order_rom_14(1) when stq_tail_i(3) else ga_ls_order_rom_14(9);
	TEMP_49_res(10) <= ga_ls_order_rom_14(2) when stq_tail_i(3) else ga_ls_order_rom_14(10);
	TEMP_49_res(11) <= ga_ls_order_rom_14(3) when stq_tail_i(3) else ga_ls_order_rom_14(11);
	TEMP_49_res(12) <= ga_ls_order_rom_14(4) when stq_tail_i(3) else ga_ls_order_rom_14(12);
	TEMP_49_res(13) <= ga_ls_order_rom_14(5) when stq_tail_i(3) else ga_ls_order_rom_14(13);
	TEMP_49_res(14) <= ga_ls_order_rom_14(6) when stq_tail_i(3) else ga_ls_order_rom_14(14);
	TEMP_49_res(15) <= ga_ls_order_rom_14(7) when stq_tail_i(3) else ga_ls_order_rom_14(15);
	-- Layer End
	TEMP_50_res(0) <= TEMP_49_res(12) when stq_tail_i(2) else TEMP_49_res(0);
	TEMP_50_res(1) <= TEMP_49_res(13) when stq_tail_i(2) else TEMP_49_res(1);
	TEMP_50_res(2) <= TEMP_49_res(14) when stq_tail_i(2) else TEMP_49_res(2);
	TEMP_50_res(3) <= TEMP_49_res(15) when stq_tail_i(2) else TEMP_49_res(3);
	TEMP_50_res(4) <= TEMP_49_res(0) when stq_tail_i(2) else TEMP_49_res(4);
	TEMP_50_res(5) <= TEMP_49_res(1) when stq_tail_i(2) else TEMP_49_res(5);
	TEMP_50_res(6) <= TEMP_49_res(2) when stq_tail_i(2) else TEMP_49_res(6);
	TEMP_50_res(7) <= TEMP_49_res(3) when stq_tail_i(2) else TEMP_49_res(7);
	TEMP_50_res(8) <= TEMP_49_res(4) when stq_tail_i(2) else TEMP_49_res(8);
	TEMP_50_res(9) <= TEMP_49_res(5) when stq_tail_i(2) else TEMP_49_res(9);
	TEMP_50_res(10) <= TEMP_49_res(6) when stq_tail_i(2) else TEMP_49_res(10);
	TEMP_50_res(11) <= TEMP_49_res(7) when stq_tail_i(2) else TEMP_49_res(11);
	TEMP_50_res(12) <= TEMP_49_res(8) when stq_tail_i(2) else TEMP_49_res(12);
	TEMP_50_res(13) <= TEMP_49_res(9) when stq_tail_i(2) else TEMP_49_res(13);
	TEMP_50_res(14) <= TEMP_49_res(10) when stq_tail_i(2) else TEMP_49_res(14);
	TEMP_50_res(15) <= TEMP_49_res(11) when stq_tail_i(2) else TEMP_49_res(15);
	-- Layer End
	TEMP_51_res(0) <= TEMP_50_res(14) when stq_tail_i(1) else TEMP_50_res(0);
	TEMP_51_res(1) <= TEMP_50_res(15) when stq_tail_i(1) else TEMP_50_res(1);
	TEMP_51_res(2) <= TEMP_50_res(0) when stq_tail_i(1) else TEMP_50_res(2);
	TEMP_51_res(3) <= TEMP_50_res(1) when stq_tail_i(1) else TEMP_50_res(3);
	TEMP_51_res(4) <= TEMP_50_res(2) when stq_tail_i(1) else TEMP_50_res(4);
	TEMP_51_res(5) <= TEMP_50_res(3) when stq_tail_i(1) else TEMP_50_res(5);
	TEMP_51_res(6) <= TEMP_50_res(4) when stq_tail_i(1) else TEMP_50_res(6);
	TEMP_51_res(7) <= TEMP_50_res(5) when stq_tail_i(1) else TEMP_50_res(7);
	TEMP_51_res(8) <= TEMP_50_res(6) when stq_tail_i(1) else TEMP_50_res(8);
	TEMP_51_res(9) <= TEMP_50_res(7) when stq_tail_i(1) else TEMP_50_res(9);
	TEMP_51_res(10) <= TEMP_50_res(8) when stq_tail_i(1) else TEMP_50_res(10);
	TEMP_51_res(11) <= TEMP_50_res(9) when stq_tail_i(1) else TEMP_50_res(11);
	TEMP_51_res(12) <= TEMP_50_res(10) when stq_tail_i(1) else TEMP_50_res(12);
	TEMP_51_res(13) <= TEMP_50_res(11) when stq_tail_i(1) else TEMP_50_res(13);
	TEMP_51_res(14) <= TEMP_50_res(12) when stq_tail_i(1) else TEMP_50_res(14);
	TEMP_51_res(15) <= TEMP_50_res(13) when stq_tail_i(1) else TEMP_50_res(15);
	-- Layer End
	ga_ls_order_temp_14(0) <= TEMP_51_res(15) when stq_tail_i(0) else TEMP_51_res(0);
	ga_ls_order_temp_14(1) <= TEMP_51_res(0) when stq_tail_i(0) else TEMP_51_res(1);
	ga_ls_order_temp_14(2) <= TEMP_51_res(1) when stq_tail_i(0) else TEMP_51_res(2);
	ga_ls_order_temp_14(3) <= TEMP_51_res(2) when stq_tail_i(0) else TEMP_51_res(3);
	ga_ls_order_temp_14(4) <= TEMP_51_res(3) when stq_tail_i(0) else TEMP_51_res(4);
	ga_ls_order_temp_14(5) <= TEMP_51_res(4) when stq_tail_i(0) else TEMP_51_res(5);
	ga_ls_order_temp_14(6) <= TEMP_51_res(5) when stq_tail_i(0) else TEMP_51_res(6);
	ga_ls_order_temp_14(7) <= TEMP_51_res(6) when stq_tail_i(0) else TEMP_51_res(7);
	ga_ls_order_temp_14(8) <= TEMP_51_res(7) when stq_tail_i(0) else TEMP_51_res(8);
	ga_ls_order_temp_14(9) <= TEMP_51_res(8) when stq_tail_i(0) else TEMP_51_res(9);
	ga_ls_order_temp_14(10) <= TEMP_51_res(9) when stq_tail_i(0) else TEMP_51_res(10);
	ga_ls_order_temp_14(11) <= TEMP_51_res(10) when stq_tail_i(0) else TEMP_51_res(11);
	ga_ls_order_temp_14(12) <= TEMP_51_res(11) when stq_tail_i(0) else TEMP_51_res(12);
	ga_ls_order_temp_14(13) <= TEMP_51_res(12) when stq_tail_i(0) else TEMP_51_res(13);
	ga_ls_order_temp_14(14) <= TEMP_51_res(13) when stq_tail_i(0) else TEMP_51_res(14);
	ga_ls_order_temp_14(15) <= TEMP_51_res(14) when stq_tail_i(0) else TEMP_51_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order_temp_15, ga_ls_order_rom_15, stq_tail)
	TEMP_52_res(0) <= ga_ls_order_rom_15(8) when stq_tail_i(3) else ga_ls_order_rom_15(0);
	TEMP_52_res(1) <= ga_ls_order_rom_15(9) when stq_tail_i(3) else ga_ls_order_rom_15(1);
	TEMP_52_res(2) <= ga_ls_order_rom_15(10) when stq_tail_i(3) else ga_ls_order_rom_15(2);
	TEMP_52_res(3) <= ga_ls_order_rom_15(11) when stq_tail_i(3) else ga_ls_order_rom_15(3);
	TEMP_52_res(4) <= ga_ls_order_rom_15(12) when stq_tail_i(3) else ga_ls_order_rom_15(4);
	TEMP_52_res(5) <= ga_ls_order_rom_15(13) when stq_tail_i(3) else ga_ls_order_rom_15(5);
	TEMP_52_res(6) <= ga_ls_order_rom_15(14) when stq_tail_i(3) else ga_ls_order_rom_15(6);
	TEMP_52_res(7) <= ga_ls_order_rom_15(15) when stq_tail_i(3) else ga_ls_order_rom_15(7);
	TEMP_52_res(8) <= ga_ls_order_rom_15(0) when stq_tail_i(3) else ga_ls_order_rom_15(8);
	TEMP_52_res(9) <= ga_ls_order_rom_15(1) when stq_tail_i(3) else ga_ls_order_rom_15(9);
	TEMP_52_res(10) <= ga_ls_order_rom_15(2) when stq_tail_i(3) else ga_ls_order_rom_15(10);
	TEMP_52_res(11) <= ga_ls_order_rom_15(3) when stq_tail_i(3) else ga_ls_order_rom_15(11);
	TEMP_52_res(12) <= ga_ls_order_rom_15(4) when stq_tail_i(3) else ga_ls_order_rom_15(12);
	TEMP_52_res(13) <= ga_ls_order_rom_15(5) when stq_tail_i(3) else ga_ls_order_rom_15(13);
	TEMP_52_res(14) <= ga_ls_order_rom_15(6) when stq_tail_i(3) else ga_ls_order_rom_15(14);
	TEMP_52_res(15) <= ga_ls_order_rom_15(7) when stq_tail_i(3) else ga_ls_order_rom_15(15);
	-- Layer End
	TEMP_53_res(0) <= TEMP_52_res(12) when stq_tail_i(2) else TEMP_52_res(0);
	TEMP_53_res(1) <= TEMP_52_res(13) when stq_tail_i(2) else TEMP_52_res(1);
	TEMP_53_res(2) <= TEMP_52_res(14) when stq_tail_i(2) else TEMP_52_res(2);
	TEMP_53_res(3) <= TEMP_52_res(15) when stq_tail_i(2) else TEMP_52_res(3);
	TEMP_53_res(4) <= TEMP_52_res(0) when stq_tail_i(2) else TEMP_52_res(4);
	TEMP_53_res(5) <= TEMP_52_res(1) when stq_tail_i(2) else TEMP_52_res(5);
	TEMP_53_res(6) <= TEMP_52_res(2) when stq_tail_i(2) else TEMP_52_res(6);
	TEMP_53_res(7) <= TEMP_52_res(3) when stq_tail_i(2) else TEMP_52_res(7);
	TEMP_53_res(8) <= TEMP_52_res(4) when stq_tail_i(2) else TEMP_52_res(8);
	TEMP_53_res(9) <= TEMP_52_res(5) when stq_tail_i(2) else TEMP_52_res(9);
	TEMP_53_res(10) <= TEMP_52_res(6) when stq_tail_i(2) else TEMP_52_res(10);
	TEMP_53_res(11) <= TEMP_52_res(7) when stq_tail_i(2) else TEMP_52_res(11);
	TEMP_53_res(12) <= TEMP_52_res(8) when stq_tail_i(2) else TEMP_52_res(12);
	TEMP_53_res(13) <= TEMP_52_res(9) when stq_tail_i(2) else TEMP_52_res(13);
	TEMP_53_res(14) <= TEMP_52_res(10) when stq_tail_i(2) else TEMP_52_res(14);
	TEMP_53_res(15) <= TEMP_52_res(11) when stq_tail_i(2) else TEMP_52_res(15);
	-- Layer End
	TEMP_54_res(0) <= TEMP_53_res(14) when stq_tail_i(1) else TEMP_53_res(0);
	TEMP_54_res(1) <= TEMP_53_res(15) when stq_tail_i(1) else TEMP_53_res(1);
	TEMP_54_res(2) <= TEMP_53_res(0) when stq_tail_i(1) else TEMP_53_res(2);
	TEMP_54_res(3) <= TEMP_53_res(1) when stq_tail_i(1) else TEMP_53_res(3);
	TEMP_54_res(4) <= TEMP_53_res(2) when stq_tail_i(1) else TEMP_53_res(4);
	TEMP_54_res(5) <= TEMP_53_res(3) when stq_tail_i(1) else TEMP_53_res(5);
	TEMP_54_res(6) <= TEMP_53_res(4) when stq_tail_i(1) else TEMP_53_res(6);
	TEMP_54_res(7) <= TEMP_53_res(5) when stq_tail_i(1) else TEMP_53_res(7);
	TEMP_54_res(8) <= TEMP_53_res(6) when stq_tail_i(1) else TEMP_53_res(8);
	TEMP_54_res(9) <= TEMP_53_res(7) when stq_tail_i(1) else TEMP_53_res(9);
	TEMP_54_res(10) <= TEMP_53_res(8) when stq_tail_i(1) else TEMP_53_res(10);
	TEMP_54_res(11) <= TEMP_53_res(9) when stq_tail_i(1) else TEMP_53_res(11);
	TEMP_54_res(12) <= TEMP_53_res(10) when stq_tail_i(1) else TEMP_53_res(12);
	TEMP_54_res(13) <= TEMP_53_res(11) when stq_tail_i(1) else TEMP_53_res(13);
	TEMP_54_res(14) <= TEMP_53_res(12) when stq_tail_i(1) else TEMP_53_res(14);
	TEMP_54_res(15) <= TEMP_53_res(13) when stq_tail_i(1) else TEMP_53_res(15);
	-- Layer End
	ga_ls_order_temp_15(0) <= TEMP_54_res(15) when stq_tail_i(0) else TEMP_54_res(0);
	ga_ls_order_temp_15(1) <= TEMP_54_res(0) when stq_tail_i(0) else TEMP_54_res(1);
	ga_ls_order_temp_15(2) <= TEMP_54_res(1) when stq_tail_i(0) else TEMP_54_res(2);
	ga_ls_order_temp_15(3) <= TEMP_54_res(2) when stq_tail_i(0) else TEMP_54_res(3);
	ga_ls_order_temp_15(4) <= TEMP_54_res(3) when stq_tail_i(0) else TEMP_54_res(4);
	ga_ls_order_temp_15(5) <= TEMP_54_res(4) when stq_tail_i(0) else TEMP_54_res(5);
	ga_ls_order_temp_15(6) <= TEMP_54_res(5) when stq_tail_i(0) else TEMP_54_res(6);
	ga_ls_order_temp_15(7) <= TEMP_54_res(6) when stq_tail_i(0) else TEMP_54_res(7);
	ga_ls_order_temp_15(8) <= TEMP_54_res(7) when stq_tail_i(0) else TEMP_54_res(8);
	ga_ls_order_temp_15(9) <= TEMP_54_res(8) when stq_tail_i(0) else TEMP_54_res(9);
	ga_ls_order_temp_15(10) <= TEMP_54_res(9) when stq_tail_i(0) else TEMP_54_res(10);
	ga_ls_order_temp_15(11) <= TEMP_54_res(10) when stq_tail_i(0) else TEMP_54_res(11);
	ga_ls_order_temp_15(12) <= TEMP_54_res(11) when stq_tail_i(0) else TEMP_54_res(12);
	ga_ls_order_temp_15(13) <= TEMP_54_res(12) when stq_tail_i(0) else TEMP_54_res(13);
	ga_ls_order_temp_15(14) <= TEMP_54_res(13) when stq_tail_i(0) else TEMP_54_res(14);
	ga_ls_order_temp_15(15) <= TEMP_54_res(14) when stq_tail_i(0) else TEMP_54_res(15);
	-- Shifter End

	-- Shifter Begin
	-- CyclicLeftShift(ga_ls_order, ga_ls_order_temp, ldq_tail)
	TEMP_55_res_0 <= ga_ls_order_temp_8 when ldq_tail_i(3) else ga_ls_order_temp_0;
	TEMP_55_res_1 <= ga_ls_order_temp_9 when ldq_tail_i(3) else ga_ls_order_temp_1;
	TEMP_55_res_2 <= ga_ls_order_temp_10 when ldq_tail_i(3) else ga_ls_order_temp_2;
	TEMP_55_res_3 <= ga_ls_order_temp_11 when ldq_tail_i(3) else ga_ls_order_temp_3;
	TEMP_55_res_4 <= ga_ls_order_temp_12 when ldq_tail_i(3) else ga_ls_order_temp_4;
	TEMP_55_res_5 <= ga_ls_order_temp_13 when ldq_tail_i(3) else ga_ls_order_temp_5;
	TEMP_55_res_6 <= ga_ls_order_temp_14 when ldq_tail_i(3) else ga_ls_order_temp_6;
	TEMP_55_res_7 <= ga_ls_order_temp_15 when ldq_tail_i(3) else ga_ls_order_temp_7;
	TEMP_55_res_8 <= ga_ls_order_temp_0 when ldq_tail_i(3) else ga_ls_order_temp_8;
	TEMP_55_res_9 <= ga_ls_order_temp_1 when ldq_tail_i(3) else ga_ls_order_temp_9;
	TEMP_55_res_10 <= ga_ls_order_temp_2 when ldq_tail_i(3) else ga_ls_order_temp_10;
	TEMP_55_res_11 <= ga_ls_order_temp_3 when ldq_tail_i(3) else ga_ls_order_temp_11;
	TEMP_55_res_12 <= ga_ls_order_temp_4 when ldq_tail_i(3) else ga_ls_order_temp_12;
	TEMP_55_res_13 <= ga_ls_order_temp_5 when ldq_tail_i(3) else ga_ls_order_temp_13;
	TEMP_55_res_14 <= ga_ls_order_temp_6 when ldq_tail_i(3) else ga_ls_order_temp_14;
	TEMP_55_res_15 <= ga_ls_order_temp_7 when ldq_tail_i(3) else ga_ls_order_temp_15;
	-- Layer End
	TEMP_56_res_0 <= TEMP_55_res_12 when ldq_tail_i(2) else TEMP_55_res_0;
	TEMP_56_res_1 <= TEMP_55_res_13 when ldq_tail_i(2) else TEMP_55_res_1;
	TEMP_56_res_2 <= TEMP_55_res_14 when ldq_tail_i(2) else TEMP_55_res_2;
	TEMP_56_res_3 <= TEMP_55_res_15 when ldq_tail_i(2) else TEMP_55_res_3;
	TEMP_56_res_4 <= TEMP_55_res_0 when ldq_tail_i(2) else TEMP_55_res_4;
	TEMP_56_res_5 <= TEMP_55_res_1 when ldq_tail_i(2) else TEMP_55_res_5;
	TEMP_56_res_6 <= TEMP_55_res_2 when ldq_tail_i(2) else TEMP_55_res_6;
	TEMP_56_res_7 <= TEMP_55_res_3 when ldq_tail_i(2) else TEMP_55_res_7;
	TEMP_56_res_8 <= TEMP_55_res_4 when ldq_tail_i(2) else TEMP_55_res_8;
	TEMP_56_res_9 <= TEMP_55_res_5 when ldq_tail_i(2) else TEMP_55_res_9;
	TEMP_56_res_10 <= TEMP_55_res_6 when ldq_tail_i(2) else TEMP_55_res_10;
	TEMP_56_res_11 <= TEMP_55_res_7 when ldq_tail_i(2) else TEMP_55_res_11;
	TEMP_56_res_12 <= TEMP_55_res_8 when ldq_tail_i(2) else TEMP_55_res_12;
	TEMP_56_res_13 <= TEMP_55_res_9 when ldq_tail_i(2) else TEMP_55_res_13;
	TEMP_56_res_14 <= TEMP_55_res_10 when ldq_tail_i(2) else TEMP_55_res_14;
	TEMP_56_res_15 <= TEMP_55_res_11 when ldq_tail_i(2) else TEMP_55_res_15;
	-- Layer End
	TEMP_57_res_0 <= TEMP_56_res_14 when ldq_tail_i(1) else TEMP_56_res_0;
	TEMP_57_res_1 <= TEMP_56_res_15 when ldq_tail_i(1) else TEMP_56_res_1;
	TEMP_57_res_2 <= TEMP_56_res_0 when ldq_tail_i(1) else TEMP_56_res_2;
	TEMP_57_res_3 <= TEMP_56_res_1 when ldq_tail_i(1) else TEMP_56_res_3;
	TEMP_57_res_4 <= TEMP_56_res_2 when ldq_tail_i(1) else TEMP_56_res_4;
	TEMP_57_res_5 <= TEMP_56_res_3 when ldq_tail_i(1) else TEMP_56_res_5;
	TEMP_57_res_6 <= TEMP_56_res_4 when ldq_tail_i(1) else TEMP_56_res_6;
	TEMP_57_res_7 <= TEMP_56_res_5 when ldq_tail_i(1) else TEMP_56_res_7;
	TEMP_57_res_8 <= TEMP_56_res_6 when ldq_tail_i(1) else TEMP_56_res_8;
	TEMP_57_res_9 <= TEMP_56_res_7 when ldq_tail_i(1) else TEMP_56_res_9;
	TEMP_57_res_10 <= TEMP_56_res_8 when ldq_tail_i(1) else TEMP_56_res_10;
	TEMP_57_res_11 <= TEMP_56_res_9 when ldq_tail_i(1) else TEMP_56_res_11;
	TEMP_57_res_12 <= TEMP_56_res_10 when ldq_tail_i(1) else TEMP_56_res_12;
	TEMP_57_res_13 <= TEMP_56_res_11 when ldq_tail_i(1) else TEMP_56_res_13;
	TEMP_57_res_14 <= TEMP_56_res_12 when ldq_tail_i(1) else TEMP_56_res_14;
	TEMP_57_res_15 <= TEMP_56_res_13 when ldq_tail_i(1) else TEMP_56_res_15;
	-- Layer End
	ga_ls_order_0_o <= TEMP_57_res_15 when ldq_tail_i(0) else TEMP_57_res_0;
	ga_ls_order_1_o <= TEMP_57_res_0 when ldq_tail_i(0) else TEMP_57_res_1;
	ga_ls_order_2_o <= TEMP_57_res_1 when ldq_tail_i(0) else TEMP_57_res_2;
	ga_ls_order_3_o <= TEMP_57_res_2 when ldq_tail_i(0) else TEMP_57_res_3;
	ga_ls_order_4_o <= TEMP_57_res_3 when ldq_tail_i(0) else TEMP_57_res_4;
	ga_ls_order_5_o <= TEMP_57_res_4 when ldq_tail_i(0) else TEMP_57_res_5;
	ga_ls_order_6_o <= TEMP_57_res_5 when ldq_tail_i(0) else TEMP_57_res_6;
	ga_ls_order_7_o <= TEMP_57_res_6 when ldq_tail_i(0) else TEMP_57_res_7;
	ga_ls_order_8_o <= TEMP_57_res_7 when ldq_tail_i(0) else TEMP_57_res_8;
	ga_ls_order_9_o <= TEMP_57_res_8 when ldq_tail_i(0) else TEMP_57_res_9;
	ga_ls_order_10_o <= TEMP_57_res_9 when ldq_tail_i(0) else TEMP_57_res_10;
	ga_ls_order_11_o <= TEMP_57_res_10 when ldq_tail_i(0) else TEMP_57_res_11;
	ga_ls_order_12_o <= TEMP_57_res_11 when ldq_tail_i(0) else TEMP_57_res_12;
	ga_ls_order_13_o <= TEMP_57_res_12 when ldq_tail_i(0) else TEMP_57_res_13;
	ga_ls_order_14_o <= TEMP_57_res_13 when ldq_tail_i(0) else TEMP_57_res_14;
	ga_ls_order_15_o <= TEMP_57_res_14 when ldq_tail_i(0) else TEMP_57_res_15;
	-- Shifter End

	thr_ld_0 : LUT6 generic map (INIT => X"BE0BF63ABFA5BCD8")
		port map (O => thr_ld_ok_0, I0 => empty_loads(0), I1 => empty_loads(1), I2 => empty_loads(2), I3 => empty_loads(3), I4 => empty_loads(4), I5 => '0');
	thr_st_0 : LUT6 generic map (INIT => X"A9FE2EF75BB6B215")
		port map (O => thr_st_ok_0, I0 => empty_stores(0), I1 => empty_stores(1), I2 => empty_stores(2), I3 => empty_stores(3), I4 => empty_stores(4), I5 => '0');
	thr_ld_1 : LUT6 generic map (INIT => X"86702867B0FB596E")
		port map (O => thr_ld_ok_1, I0 => empty_loads(0), I1 => empty_loads(1), I2 => empty_loads(2), I3 => empty_loads(3), I4 => empty_loads(4), I5 => '0');
	thr_st_1 : LUT6 generic map (INIT => X"C38B62F438E6874B")
		port map (O => thr_st_ok_1, I0 => empty_stores(0), I1 => empty_stores(1), I2 => empty_stores(2), I3 => empty_stores(3), I4 => empty_stores(4), I5 => '0');
	tbl_lsorder_0_b0 : LUT6 generic map (INIT => X"3E90C8FFD08FFD0F")
		port map (O => ga_ls_order_rom_0(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b1 : LUT6 generic map (INIT => X"98752456BE89AAD1")
		port map (O => ga_ls_order_rom_0(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b2 : LUT6 generic map (INIT => X"644EC77ADB8E44C3")
		port map (O => ga_ls_order_rom_0(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b3 : LUT6 generic map (INIT => X"956DF56377E3550D")
		port map (O => ga_ls_order_rom_0(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b4 : LUT6 generic map (INIT => X"90F75CB10E718712")
		port map (O => ga_ls_order_rom_0(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b5 : LUT6 generic map (INIT => X"3BB858295BF1F314")
		port map (O => ga_ls_order_rom_0(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b6 : LUT6 generic map (INIT => X"67D7EE1C840ECC76")
		port map (O => ga_ls_order_rom_0(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b7 : LUT6 generic map (INIT => X"08A9DC59B4B05B00")
		port map (O => ga_ls_order_rom_0(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b8 : LUT6 generic map (INIT => X"9151C17D41FD5AE5")
		port map (O => ga_ls_order_rom_0(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b9 : LUT6 generic map (INIT => X"E858BAED35E386BB")
		port map (O => ga_ls_order_rom_0(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b10 : LUT6 generic map (INIT => X"0B9F16E3B521C813")
		port map (O => ga_ls_order_rom_0(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b11 : LUT6 generic map (INIT => X"94653AD0D32927BD")
		port map (O => ga_ls_order_rom_0(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b12 : LUT6 generic map (INIT => X"0C2C296A60F7B01F")
		port map (O => ga_ls_order_rom_0(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b13 : LUT6 generic map (INIT => X"86C3789EBA9DEC01")
		port map (O => ga_ls_order_rom_0(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b14 : LUT6 generic map (INIT => X"76B6699ECFD25EE6")
		port map (O => ga_ls_order_rom_0(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_0_b15 : LUT6 generic map (INIT => X"C2B0082D9DF92F50")
		port map (O => ga_ls_order_rom_0(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b0 : LUT6 generic map (INIT => X"ED5C5BB120233646")
		port map (O => ga_ls_order_rom_1(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b1 : LUT6 generic map (INIT => X"D5AA93CC283C06B0")
		port map (O => ga_ls_order_rom_1(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b2 : LUT6 generic map (INIT => X"A2B9F679999061E2")
		port map (O => ga_ls_order_rom_1(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b3 : LUT6 generic map (INIT => X"E0C723E4DBC65E84")
		port map (O => ga_ls_order_rom_1(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b4 : LUT6 generic map (INIT => X"449DED1260DFA073")
		port map (O => ga_ls_order_rom_1(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b5 : LUT6 generic map (INIT => X"1C2DC55704ED3F1D")
		port map (O => ga_ls_order_rom_1(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b6 : LUT6 generic map (INIT => X"84B061DC4A06D8BF")
		port map (O => ga_ls_order_rom_1(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b7 : LUT6 generic map (INIT => X"BE88AEDC63F914A1")
		port map (O => ga_ls_order_rom_1(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b8 : LUT6 generic map (INIT => X"AD1D4DCDDB238A7C")
		port map (O => ga_ls_order_rom_1(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b9 : LUT6 generic map (INIT => X"BC9B69CDE92709DA")
		port map (O => ga_ls_order_rom_1(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b10 : LUT6 generic map (INIT => X"214343567297AF83")
		port map (O => ga_ls_order_rom_1(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b11 : LUT6 generic map (INIT => X"27AE61F5894163CD")
		port map (O => ga_ls_order_rom_1(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b12 : LUT6 generic map (INIT => X"A32AD67410DB64CF")
		port map (O => ga_ls_order_rom_1(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b13 : LUT6 generic map (INIT => X"9E440365B150B891")
		port map (O => ga_ls_order_rom_1(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b14 : LUT6 generic map (INIT => X"9647C7DF7531B736")
		port map (O => ga_ls_order_rom_1(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_1_b15 : LUT6 generic map (INIT => X"2DEE120FE361E9C0")
		port map (O => ga_ls_order_rom_1(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b0 : LUT6 generic map (INIT => X"30A9D1AF7E650748")
		port map (O => ga_ls_order_rom_2(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b1 : LUT6 generic map (INIT => X"138D25DC5FE30BBE")
		port map (O => ga_ls_order_rom_2(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b2 : LUT6 generic map (INIT => X"7FCF4CCECD9A4FAC")
		port map (O => ga_ls_order_rom_2(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b3 : LUT6 generic map (INIT => X"824AC0F1034B73AA")
		port map (O => ga_ls_order_rom_2(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b4 : LUT6 generic map (INIT => X"7CC60D55EAEB9605")
		port map (O => ga_ls_order_rom_2(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b5 : LUT6 generic map (INIT => X"C69529DD21B219DB")
		port map (O => ga_ls_order_rom_2(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b6 : LUT6 generic map (INIT => X"1ABEF7B63CB211D9")
		port map (O => ga_ls_order_rom_2(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b7 : LUT6 generic map (INIT => X"70F68C8F2E5D8037")
		port map (O => ga_ls_order_rom_2(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b8 : LUT6 generic map (INIT => X"EBDB618201B224F2")
		port map (O => ga_ls_order_rom_2(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b9 : LUT6 generic map (INIT => X"19501A6A990C87F4")
		port map (O => ga_ls_order_rom_2(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b10 : LUT6 generic map (INIT => X"9335F8EA5CAAD733")
		port map (O => ga_ls_order_rom_2(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b11 : LUT6 generic map (INIT => X"0B45CD0C1650C2DD")
		port map (O => ga_ls_order_rom_2(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b12 : LUT6 generic map (INIT => X"4439416E2C1E4C7F")
		port map (O => ga_ls_order_rom_2(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b13 : LUT6 generic map (INIT => X"A14A56C6CB295861")
		port map (O => ga_ls_order_rom_2(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b14 : LUT6 generic map (INIT => X"0ABD1F5496C1DD06")
		port map (O => ga_ls_order_rom_2(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_2_b15 : LUT6 generic map (INIT => X"679D2BEA686D4A70")
		port map (O => ga_ls_order_rom_2(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b0 : LUT6 generic map (INIT => X"C8783F099B4BFBA9")
		port map (O => ga_ls_order_rom_3(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b1 : LUT6 generic map (INIT => X"84923540D2C0EFA7")
		port map (O => ga_ls_order_rom_3(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b2 : LUT6 generic map (INIT => X"5BD6F1447D5AF015")
		port map (O => ga_ls_order_rom_3(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b3 : LUT6 generic map (INIT => X"4E4BA428D904C54B")
		port map (O => ga_ls_order_rom_3(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b4 : LUT6 generic map (INIT => X"F3E0BEB912002B5C")
		port map (O => ga_ls_order_rom_3(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b5 : LUT6 generic map (INIT => X"863FB9E2617FDDBA")
		port map (O => ga_ls_order_rom_3(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b6 : LUT6 generic map (INIT => X"0D9B8D45F0AD62F8")
		port map (O => ga_ls_order_rom_3(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b7 : LUT6 generic map (INIT => X"90585DB58BA9F58E")
		port map (O => ga_ls_order_rom_3(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b8 : LUT6 generic map (INIT => X"EFD7879E46C01F93")
		port map (O => ga_ls_order_rom_3(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b9 : LUT6 generic map (INIT => X"EE989950F8419E3D")
		port map (O => ga_ls_order_rom_3(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b10 : LUT6 generic map (INIT => X"2FA6B9FDEB31FBE3")
		port map (O => ga_ls_order_rom_3(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b11 : LUT6 generic map (INIT => X"A0DF33ED1B605F2D")
		port map (O => ga_ls_order_rom_3(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b12 : LUT6 generic map (INIT => X"CD443A6ABBCAE3EF")
		port map (O => ga_ls_order_rom_3(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b13 : LUT6 generic map (INIT => X"B70D42DB1DC4A7B1")
		port map (O => ga_ls_order_rom_3(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b14 : LUT6 generic map (INIT => X"EF512665DE584296")
		port map (O => ga_ls_order_rom_3(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_3_b15 : LUT6 generic map (INIT => X"3AF041EB100D2520")
		port map (O => ga_ls_order_rom_3(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b0 : LUT6 generic map (INIT => X"D4927CE22D6C627C")
		port map (O => ga_ls_order_rom_4(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b1 : LUT6 generic map (INIT => X"EB5AE099DD3D41DA")
		port map (O => ga_ls_order_rom_4(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b2 : LUT6 generic map (INIT => X"7EAB1A57080CE6D8")
		port map (O => ga_ls_order_rom_4(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b3 : LUT6 generic map (INIT => X"99CC862A08C7236E")
		port map (O => ga_ls_order_rom_4(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b4 : LUT6 generic map (INIT => X"73E9B06E0CC61AC9")
		port map (O => ga_ls_order_rom_4(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b5 : LUT6 generic map (INIT => X"B6C624F550B67BC7")
		port map (O => ga_ls_order_rom_4(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b6 : LUT6 generic map (INIT => X"5541CE4D4E235CF5")
		port map (O => ga_ls_order_rom_4(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b7 : LUT6 generic map (INIT => X"B9BBFA99EBA51A2B")
		port map (O => ga_ls_order_rom_4(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b8 : LUT6 generic map (INIT => X"F1E211ECF2057E46")
		port map (O => ga_ls_order_rom_4(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b9 : LUT6 generic map (INIT => X"0FA858D50C07AEB0")
		port map (O => ga_ls_order_rom_4(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b10 : LUT6 generic map (INIT => X"64FA795063584653")
		port map (O => ga_ls_order_rom_4(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b11 : LUT6 generic map (INIT => X"E9A0D7F90CDAB8FD")
		port map (O => ga_ls_order_rom_4(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b12 : LUT6 generic map (INIT => X"D8B0B76749E4EE5F")
		port map (O => ga_ls_order_rom_4(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b13 : LUT6 generic map (INIT => X"AF9089AEFF308141")
		port map (O => ga_ls_order_rom_4(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b14 : LUT6 generic map (INIT => X"6AD7FDB32FF73426")
		port map (O => ga_ls_order_rom_4(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_4_b15 : LUT6 generic map (INIT => X"E7D868498790EB90")
		port map (O => ga_ls_order_rom_4(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b0 : LUT6 generic map (INIT => X"5A05ADD2C49672E5")
		port map (O => ga_ls_order_rom_5(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b1 : LUT6 generic map (INIT => X"D0B002715B9EBEBB")
		port map (O => ga_ls_order_rom_5(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b2 : LUT6 generic map (INIT => X"554D2C4E50F3B0F9")
		port map (O => ga_ls_order_rom_5(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b3 : LUT6 generic map (INIT => X"AFF5CDA86C289C57")
		port map (O => ga_ls_order_rom_5(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b4 : LUT6 generic map (INIT => X"1D2E8AEE9FDA3B28")
		port map (O => ga_ls_order_rom_5(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b5 : LUT6 generic map (INIT => X"7482323587B1F89E")
		port map (O => ga_ls_order_rom_5(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b6 : LUT6 generic map (INIT => X"4DF715A8D40906CC")
		port map (O => ga_ls_order_rom_5(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b7 : LUT6 generic map (INIT => X"35E7D4574D8567CA")
		port map (O => ga_ls_order_rom_5(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b8 : LUT6 generic map (INIT => X"121816B9F4D8450F")
		port map (O => ga_ls_order_rom_5(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b9 : LUT6 generic map (INIT => X"9AF78CEAF43012D1")
		port map (O => ga_ls_order_rom_5(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b10 : LUT6 generic map (INIT => X"DC9C79A1AE0700C3")
		port map (O => ga_ls_order_rom_5(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b11 : LUT6 generic map (INIT => X"4A0BA87C7778110D")
		port map (O => ga_ls_order_rom_5(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b12 : LUT6 generic map (INIT => X"82E46BCA554E390F")
		port map (O => ga_ls_order_rom_5(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b13 : LUT6 generic map (INIT => X"86B6AB701645F6D1")
		port map (O => ga_ls_order_rom_5(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b14 : LUT6 generic map (INIT => X"0CBA9958DCAF7076")
		port map (O => ga_ls_order_rom_5(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_5_b15 : LUT6 generic map (INIT => X"FDC043714386CF00")
		port map (O => ga_ls_order_rom_5(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b0 : LUT6 generic map (INIT => X"4C76AA321ABDA793")
		port map (O => ga_ls_order_rom_6(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b1 : LUT6 generic map (INIT => X"5E6530AD1E3E863D")
		port map (O => ga_ls_order_rom_6(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b2 : LUT6 generic map (INIT => X"48DC2163C571199F")
		port map (O => ga_ls_order_rom_6(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b3 : LUT6 generic map (INIT => X"52078DC431F55881")
		port map (O => ga_ls_order_rom_6(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b4 : LUT6 generic map (INIT => X"BC8D3A718FD21266")
		port map (O => ga_ls_order_rom_6(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b5 : LUT6 generic map (INIT => X"62C029C08F1E69D0")
		port map (O => ga_ls_order_rom_6(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b6 : LUT6 generic map (INIT => X"12DFC446E51A96C2")
		port map (O => ga_ls_order_rom_6(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b7 : LUT6 generic map (INIT => X"7D0C7948A2184B64")
		port map (O => ga_ls_order_rom_6(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b8 : LUT6 generic map (INIT => X"4F2752842F8E53A9")
		port map (O => ga_ls_order_rom_6(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b9 : LUT6 generic map (INIT => X"F6825A9E48D0A7A7")
		port map (O => ga_ls_order_rom_6(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b10 : LUT6 generic map (INIT => X"760F36C1D3330AF3")
		port map (O => ga_ls_order_rom_6(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b11 : LUT6 generic map (INIT => X"E2DE8FB7D833EC9D")
		port map (O => ga_ls_order_rom_6(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b12 : LUT6 generic map (INIT => X"4055848A5B7D433F")
		port map (O => ga_ls_order_rom_6(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b13 : LUT6 generic map (INIT => X"9C861FFA120F8221")
		port map (O => ga_ls_order_rom_6(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b14 : LUT6 generic map (INIT => X"6F02AAEBBF5078C6")
		port map (O => ga_ls_order_rom_6(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_6_b15 : LUT6 generic map (INIT => X"22B870ABD876DC30")
		port map (O => ga_ls_order_rom_6(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b0 : LUT6 generic map (INIT => X"614E10D863C92CF2")
		port map (O => ga_ls_order_rom_7(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b1 : LUT6 generic map (INIT => X"096157684AA16FF4")
		port map (O => ga_ls_order_rom_7(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b2 : LUT6 generic map (INIT => X"04511F0260C02B96")
		port map (O => ga_ls_order_rom_7(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b3 : LUT6 generic map (INIT => X"01069B4069ED0A20")
		port map (O => ga_ls_order_rom_7(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b4 : LUT6 generic map (INIT => X"A49E0305509CBAEF")
		port map (O => ga_ls_order_rom_7(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b5 : LUT6 generic map (INIT => X"CC777389B5F67EB1")
		port map (O => ga_ls_order_rom_7(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b6 : LUT6 generic map (INIT => X"24B874557451F8E3")
		port map (O => ga_ls_order_rom_7(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b7 : LUT6 generic map (INIT => X"F85BC0B991285C2D")
		port map (O => ga_ls_order_rom_7(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b8 : LUT6 generic map (INIT => X"91471F6B0304DF48")
		port map (O => ga_ls_order_rom_7(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b9 : LUT6 generic map (INIT => X"D0A21D97C38483BE")
		port map (O => ga_ls_order_rom_7(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b10 : LUT6 generic map (INIT => X"CC8901CEAAECE5A3")
		port map (O => ga_ls_order_rom_7(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b11 : LUT6 generic map (INIT => X"D08F0F960FCA92ED")
		port map (O => ga_ls_order_rom_7(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b12 : LUT6 generic map (INIT => X"F2EF484BC2AF4DAF")
		port map (O => ga_ls_order_rom_7(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b13 : LUT6 generic map (INIT => X"4C6A45098B2BDB71")
		port map (O => ga_ls_order_rom_7(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b14 : LUT6 generic map (INIT => X"68D9CA38CE21D556")
		port map (O => ga_ls_order_rom_7(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_7_b15 : LUT6 generic map (INIT => X"CEA778A0B69DC0E0")
		port map (O => ga_ls_order_rom_7(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b0 : LUT6 generic map (INIT => X"4A16E958D28FC8B4")
		port map (O => ga_ls_order_rom_8(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b1 : LUT6 generic map (INIT => X"D9B78CF6CBFEFCB2")
		port map (O => ga_ls_order_rom_8(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b2 : LUT6 generic map (INIT => X"DD6A0EEA0D86B7E0")
		port map (O => ga_ls_order_rom_8(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b3 : LUT6 generic map (INIT => X"4D440A548F2AB856")
		port map (O => ga_ls_order_rom_8(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b4 : LUT6 generic map (INIT => X"4D09F57FF9A4D871")
		port map (O => ga_ls_order_rom_8(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b5 : LUT6 generic map (INIT => X"06F2321089284AAF")
		port map (O => ga_ls_order_rom_8(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b6 : LUT6 generic map (INIT => X"BBA6FBFAD779F9ED")
		port map (O => ga_ls_order_rom_8(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b7 : LUT6 generic map (INIT => X"917C71B5488248A3")
		port map (O => ga_ls_order_rom_8(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b8 : LUT6 generic map (INIT => X"B27B3BE23012ED7E")
		port map (O => ga_ls_order_rom_8(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b9 : LUT6 generic map (INIT => X"E1168A3A79B86F08")
		port map (O => ga_ls_order_rom_8(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b10 : LUT6 generic map (INIT => X"C554001D3141DB3E")
		port map (O => ga_ls_order_rom_8(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b11 : LUT6 generic map (INIT => X"533E822C39C55DC8")
		port map (O => ga_ls_order_rom_8(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b12 : LUT6 generic map (INIT => X"0E62A6FD70145D2A")
		port map (O => ga_ls_order_rom_8(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b13 : LUT6 generic map (INIT => X"D7B713CAF43EBC2C")
		port map (O => ga_ls_order_rom_8(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b14 : LUT6 generic map (INIT => X"BDE959E70353A95B")
		port map (O => ga_ls_order_rom_8(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_8_b15 : LUT6 generic map (INIT => X"F2FF50503BF6AC85")
		port map (O => ga_ls_order_rom_8(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b0 : LUT6 generic map (INIT => X"87E958D8AD54367D")
		port map (O => ga_ls_order_rom_9(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b1 : LUT6 generic map (INIT => X"EAA8C6A548843AD3")
		port map (O => ga_ls_order_rom_9(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b2 : LUT6 generic map (INIT => X"01B638E7BB4188C1")
		port map (O => ga_ls_order_rom_9(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b3 : LUT6 generic map (INIT => X"56FD069FD4E4BCDF")
		port map (O => ga_ls_order_rom_9(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b4 : LUT6 generic map (INIT => X"D59A188CE12C1910")
		port map (O => ga_ls_order_rom_9(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b5 : LUT6 generic map (INIT => X"D6291F31D60268A6")
		port map (O => ga_ls_order_rom_9(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b6 : LUT6 generic map (INIT => X"C4D2037E9BCCBAA4")
		port map (O => ga_ls_order_rom_9(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b7 : LUT6 generic map (INIT => X"1CEE235327A42D02")
		port map (O => ga_ls_order_rom_9(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b8 : LUT6 generic map (INIT => X"AC1141B41C4E57E7")
		port map (O => ga_ls_order_rom_9(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b9 : LUT6 generic map (INIT => X"B34BC4E24A16B6E9")
		port map (O => ga_ls_order_rom_9(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b10 : LUT6 generic map (INIT => X"6C91E33C03048FAE")
		port map (O => ga_ls_order_rom_9(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b11 : LUT6 generic map (INIT => X"62E757BB2D7A5C18")
		port map (O => ga_ls_order_rom_9(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b12 : LUT6 generic map (INIT => X"2F2C13A6C87EAA1A")
		port map (O => ga_ls_order_rom_9(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b13 : LUT6 generic map (INIT => X"C918AEB37C7FDBBC")
		port map (O => ga_ls_order_rom_9(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b14 : LUT6 generic map (INIT => X"60723001C5861F6B")
		port map (O => ga_ls_order_rom_9(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_9_b15 : LUT6 generic map (INIT => X"0359A0DE897A2A35")
		port map (O => ga_ls_order_rom_9(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b0 : LUT6 generic map (INIT => X"700D83CBAA744D6E")
		port map (O => ga_ls_order_rom_10(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b1 : LUT6 generic map (INIT => X"6D4E12FB02A4A0D8")
		port map (O => ga_ls_order_rom_10(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b2 : LUT6 generic map (INIT => X"401925AC79A1EBDA")
		port map (O => ga_ls_order_rom_10(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b3 : LUT6 generic map (INIT => X"877E0C3D33A3AC7C")
		port map (O => ga_ls_order_rom_10(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b4 : LUT6 generic map (INIT => X"694C43B4F2F7842B")
		port map (O => ga_ls_order_rom_10(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b5 : LUT6 generic map (INIT => X"F49031F43CA466F5")
		port map (O => ga_ls_order_rom_10(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b6 : LUT6 generic map (INIT => X"74AA5D5BBE2965C7")
		port map (O => ga_ls_order_rom_10(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b7 : LUT6 generic map (INIT => X"DC7092C41079A4C9")
		port map (O => ga_ls_order_rom_10(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b8 : LUT6 generic map (INIT => X"9DF4F6229C51A084")
		port map (O => ga_ls_order_rom_10(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b9 : LUT6 generic map (INIT => X"F5E5D3A62284B3E2")
		port map (O => ga_ls_order_rom_10(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b10 : LUT6 generic map (INIT => X"E95B53C239BD9D4E")
		port map (O => ga_ls_order_rom_10(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b11 : LUT6 generic map (INIT => X"EE8198A25591CDB8")
		port map (O => ga_ls_order_rom_10(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b12 : LUT6 generic map (INIT => X"E263E59A5B18057A")
		port map (O => ga_ls_order_rom_10(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b13 : LUT6 generic map (INIT => X"2AB89870A69FD21C")
		port map (O => ga_ls_order_rom_10(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b14 : LUT6 generic map (INIT => X"E6AD1C15ECC8D40B")
		port map (O => ga_ls_order_rom_10(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_10_b15 : LUT6 generic map (INIT => X"D21DA1945E2183D5")
		port map (O => ga_ls_order_rom_10(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b0 : LUT6 generic map (INIT => X"0903D7064930D257")
		port map (O => ga_ls_order_rom_11(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b1 : LUT6 generic map (INIT => X"DF983CD484DE96F9")
		port map (O => ga_ls_order_rom_11(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b2 : LUT6 generic map (INIT => X"DC6ADFC9A8CF74BB")
		port map (O => ga_ls_order_rom_11(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b3 : LUT6 generic map (INIT => X"F36217A7BF93C8E5")
		port map (O => ga_ls_order_rom_11(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b4 : LUT6 generic map (INIT => X"4D0568B2C99C5DCA")
		port map (O => ga_ls_order_rom_11(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b5 : LUT6 generic map (INIT => X"050C9C8BB7789CCC")
		port map (O => ga_ls_order_rom_11(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b6 : LUT6 generic map (INIT => X"E9B20DCB2C9E3E9E")
		port map (O => ga_ls_order_rom_11(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b7 : LUT6 generic map (INIT => X"B3ACAB775AA71128")
		port map (O => ga_ls_order_rom_11(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b8 : LUT6 generic map (INIT => X"BAC9B592DF63330D")
		port map (O => ga_ls_order_rom_11(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b9 : LUT6 generic map (INIT => X"D8C38B194B0D62C3")
		port map (O => ga_ls_order_rom_11(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b10 : LUT6 generic map (INIT => X"A4DEB846E39A459E")
		port map (O => ga_ls_order_rom_11(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b11 : LUT6 generic map (INIT => X"B11FECD4719C6428")
		port map (O => ga_ls_order_rom_11(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b12 : LUT6 generic map (INIT => X"E23B800423917ACA")
		port map (O => ga_ls_order_rom_11(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b13 : LUT6 generic map (INIT => X"CFB93197D5387DCC")
		port map (O => ga_ls_order_rom_11(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b14 : LUT6 generic map (INIT => X"8D8F8AF8FA343BBB")
		port map (O => ga_ls_order_rom_11(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_11_b15 : LUT6 generic map (INIT => X"77DD4B3A8C5DDFE5")
		port map (O => ga_ls_order_rom_11(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b0 : LUT6 generic map (INIT => X"934CED7FDC87C281")
		port map (O => ga_ls_order_rom_12(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b1 : LUT6 generic map (INIT => X"2B31FB6A3B7A239F")
		port map (O => ga_ls_order_rom_12(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b2 : LUT6 generic map (INIT => X"3816102F8151A03D")
		port map (O => ga_ls_order_rom_12(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b3 : LUT6 generic map (INIT => X"4CB99B79D7D76193")
		port map (O => ga_ls_order_rom_12(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b4 : LUT6 generic map (INIT => X"96B3B156E00D7564")
		port map (O => ga_ls_order_rom_12(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b5 : LUT6 generic map (INIT => X"2553B69D563250C2")
		port map (O => ga_ls_order_rom_12(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b6 : LUT6 generic map (INIT => X"1ED562D1F60113D0")
		port map (O => ga_ls_order_rom_12(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b7 : LUT6 generic map (INIT => X"9F5BB04F5C615C66")
		port map (O => ga_ls_order_rom_12(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b8 : LUT6 generic map (INIT => X"67A6B5CA0060E74B")
		port map (O => ga_ls_order_rom_12(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b9 : LUT6 generic map (INIT => X"F353B347EF5FD215")
		port map (O => ga_ls_order_rom_12(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b10 : LUT6 generic map (INIT => X"E9ACC213F516C1EE")
		port map (O => ga_ls_order_rom_12(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b11 : LUT6 generic map (INIT => X"D2D345A835449E58")
		port map (O => ga_ls_order_rom_12(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b12 : LUT6 generic map (INIT => X"7158265A7E17065A")
		port map (O => ga_ls_order_rom_12(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b13 : LUT6 generic map (INIT => X"14D08D42481037FC")
		port map (O => ga_ls_order_rom_12(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b14 : LUT6 generic map (INIT => X"066A6A0631AEB8AB")
		port map (O => ga_ls_order_rom_12(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_12_b15 : LUT6 generic map (INIT => X"8BAE6D5F1F82D475")
		port map (O => ga_ls_order_rom_12(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b0 : LUT6 generic map (INIT => X"F5B0BB8C4965C020")
		port map (O => ga_ls_order_rom_13(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b1 : LUT6 generic map (INIT => X"FA31707BCBB78196")
		port map (O => ga_ls_order_rom_13(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b2 : LUT6 generic map (INIT => X"602E5A68270FA5F4")
		port map (O => ga_ls_order_rom_13(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b3 : LUT6 generic map (INIT => X"D235FF63D65602F2")
		port map (O => ga_ls_order_rom_13(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b4 : LUT6 generic map (INIT => X"C326A637C6B0922D")
		port map (O => ga_ls_order_rom_13(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b5 : LUT6 generic map (INIT => X"61C9161E20BCDEE3")
		port map (O => ga_ls_order_rom_13(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b6 : LUT6 generic map (INIT => X"9503C61251A734B1")
		port map (O => ga_ls_order_rom_13(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b7 : LUT6 generic map (INIT => X"AC77BE53D21810EF")
		port map (O => ga_ls_order_rom_13(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b8 : LUT6 generic map (INIT => X"3C2E4E10F275E1AA")
		port map (O => ga_ls_order_rom_13(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b9 : LUT6 generic map (INIT => X"275B4D59048A3DAC")
		port map (O => ga_ls_order_rom_13(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b10 : LUT6 generic map (INIT => X"B03E9F194BE4C77E")
		port map (O => ga_ls_order_rom_13(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b11 : LUT6 generic map (INIT => X"756751753C687908")
		port map (O => ga_ls_order_rom_13(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b12 : LUT6 generic map (INIT => X"8F0C51AC44772F6A")
		port map (O => ga_ls_order_rom_13(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b13 : LUT6 generic map (INIT => X"220F6EA6B2998E6C")
		port map (O => ga_ls_order_rom_13(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b14 : LUT6 generic map (INIT => X"0665CCEDC1333C9B")
		port map (O => ga_ls_order_rom_13(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_13_b15 : LUT6 generic map (INIT => X"7B04D0164FD630C5")
		port map (O => ga_ls_order_rom_13(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b0 : LUT6 generic map (INIT => X"1C1FD4992B52AB0D")
		port map (O => ga_ls_order_rom_14(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b1 : LUT6 generic map (INIT => X"CDCA6DE605853AC3")
		port map (O => ga_ls_order_rom_14(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b2 : LUT6 generic map (INIT => X"6FBDD6D6FF9680D1")
		port map (O => ga_ls_order_rom_14(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b3 : LUT6 generic map (INIT => X"49AD1620B794330F")
		port map (O => ga_ls_order_rom_14(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b4 : LUT6 generic map (INIT => X"CB6584E816833100")
		port map (O => ga_ls_order_rom_14(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b5 : LUT6 generic map (INIT => X"81B0DC55F3150276")
		port map (O => ga_ls_order_rom_14(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b6 : LUT6 generic map (INIT => X"74478D3D90CD4914")
		port map (O => ga_ls_order_rom_14(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b7 : LUT6 generic map (INIT => X"C5CEE78021A27D12")
		port map (O => ga_ls_order_rom_14(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b8 : LUT6 generic map (INIT => X"53907131529FBA57")
		port map (O => ga_ls_order_rom_14(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b9 : LUT6 generic map (INIT => X"CB969BE4F1239EF9")
		port map (O => ga_ls_order_rom_14(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b10 : LUT6 generic map (INIT => X"D0139ACF570AF80E")
		port map (O => ga_ls_order_rom_14(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b11 : LUT6 generic map (INIT => X"4AAF95984C7C9C78")
		port map (O => ga_ls_order_rom_14(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b12 : LUT6 generic map (INIT => X"2D6855AA7F68A03A")
		port map (O => ga_ls_order_rom_14(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b13 : LUT6 generic map (INIT => X"143C5B54186724DC")
		port map (O => ga_ls_order_rom_14(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b14 : LUT6 generic map (INIT => X"51750293AC2FCBCB")
		port map (O => ga_ls_order_rom_14(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_14_b15 : LUT6 generic map (INIT => X"2CADCB7A5707ED95")
		port map (O => ga_ls_order_rom_14(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b0 : LUT6 generic map (INIT => X"5BBDC3D55A4F9884")
		port map (O => ga_ls_order_rom_15(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b1 : LUT6 generic map (INIT => X"DD2067F64EA10BE2")
		port map (O => ga_ls_order_rom_15(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b2 : LUT6 generic map (INIT => X"91CF4E4FAFD7C0B0")
		port map (O => ga_ls_order_rom_15(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b3 : LUT6 generic map (INIT => X"55BC0EF5CDD65046")
		port map (O => ga_ls_order_rom_15(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b4 : LUT6 generic map (INIT => X"ECEC89514A92DEA1")
		port map (O => ga_ls_order_rom_15(4), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b5 : LUT6 generic map (INIT => X"347EB31BFFBBC2BF")
		port map (O => ga_ls_order_rom_15(5), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b6 : LUT6 generic map (INIT => X"674384FC8B3C791D")
		port map (O => ga_ls_order_rom_15(6), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b7 : LUT6 generic map (INIT => X"0803632641424A73")
		port map (O => ga_ls_order_rom_15(7), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b8 : LUT6 generic map (INIT => X"227085D1480B756E")
		port map (O => ga_ls_order_rom_15(8), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b9 : LUT6 generic map (INIT => X"626C5482FEAE68D8")
		port map (O => ga_ls_order_rom_15(9), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b10 : LUT6 generic map (INIT => X"C4B9F5C95A65145E")
		port map (O => ga_ls_order_rom_15(10), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b11 : LUT6 generic map (INIT => X"CBFAFFB38CE9C3E8")
		port map (O => ga_ls_order_rom_15(11), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b12 : LUT6 generic map (INIT => X"1C191BBD157ACC8A")
		port map (O => ga_ls_order_rom_15(12), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b13 : LUT6 generic map (INIT => X"C17D879A798F188C")
		port map (O => ga_ls_order_rom_15(13), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b14 : LUT6 generic map (INIT => X"B393521D731A627B")
		port map (O => ga_ls_order_rom_15(14), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_lsorder_15_b15 : LUT6 generic map (INIT => X"10BF97C54DBCD2A5")
		port map (O => ga_ls_order_rom_15(15), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_nld_0_b0 : LUT6 generic map (INIT => X"6381839066D5C436")
		port map (O => num_loads(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_nld_0_b1 : LUT6 generic map (INIT => X"76F87DA185E2A6C0")
		port map (O => num_loads(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_nld_0_b2 : LUT6 generic map (INIT => X"C549E09A68A925D2")
		port map (O => num_loads(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_nld_0_b3 : LUT6 generic map (INIT => X"5E16AC69E98164D4")
		port map (O => num_loads(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_nst_0_b0 : LUT6 generic map (INIT => X"83A6D969DB9DEDE2")
		port map (O => num_stores(0), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_nst_0_b1 : LUT6 generic map (INIT => X"6480CD79EE2DBA84")
		port map (O => num_stores(1), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_nst_0_b2 : LUT6 generic map (INIT => X"6A1F95C64AE47246")
		port map (O => num_stores(2), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
	tbl_nst_0_b3 : LUT6 generic map (INIT => X"44489C7CD1E2A2B0")
		port map (O => num_stores(3), I0 => ga_idx(0), I1 => ga_idx(1), I2 => ga_idx(2), I3 => ga_idx(3), I4 => ga_idx(4), I5 => ga_any);
end architecture;
