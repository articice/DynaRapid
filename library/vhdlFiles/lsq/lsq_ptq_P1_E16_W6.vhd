

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lsq_ptq_P1_E16_W6 is
	port(
		rst : in std_logic;
		clk : in std_logic;
		port_payload_0_i : in std_logic_vector(5 downto 0);
		port_valid_0_i : in std_logic;
		port_ready_0_o : out std_logic;
		entry_alloc_0_i : in std_logic;
		entry_alloc_1_i : in std_logic;
		entry_alloc_2_i : in std_logic;
		entry_alloc_3_i : in std_logic;
		entry_alloc_4_i : in std_logic;
		entry_alloc_5_i : in std_logic;
		entry_alloc_6_i : in std_logic;
		entry_alloc_7_i : in std_logic;
		entry_alloc_8_i : in std_logic;
		entry_alloc_9_i : in std_logic;
		entry_alloc_10_i : in std_logic;
		entry_alloc_11_i : in std_logic;
		entry_alloc_12_i : in std_logic;
		entry_alloc_13_i : in std_logic;
		entry_alloc_14_i : in std_logic;
		entry_alloc_15_i : in std_logic;
		entry_payload_valid_0_i : in std_logic;
		entry_payload_valid_1_i : in std_logic;
		entry_payload_valid_2_i : in std_logic;
		entry_payload_valid_3_i : in std_logic;
		entry_payload_valid_4_i : in std_logic;
		entry_payload_valid_5_i : in std_logic;
		entry_payload_valid_6_i : in std_logic;
		entry_payload_valid_7_i : in std_logic;
		entry_payload_valid_8_i : in std_logic;
		entry_payload_valid_9_i : in std_logic;
		entry_payload_valid_10_i : in std_logic;
		entry_payload_valid_11_i : in std_logic;
		entry_payload_valid_12_i : in std_logic;
		entry_payload_valid_13_i : in std_logic;
		entry_payload_valid_14_i : in std_logic;
		entry_payload_valid_15_i : in std_logic;
		entry_payload_0_o : out std_logic_vector(5 downto 0);
		entry_payload_1_o : out std_logic_vector(5 downto 0);
		entry_payload_2_o : out std_logic_vector(5 downto 0);
		entry_payload_3_o : out std_logic_vector(5 downto 0);
		entry_payload_4_o : out std_logic_vector(5 downto 0);
		entry_payload_5_o : out std_logic_vector(5 downto 0);
		entry_payload_6_o : out std_logic_vector(5 downto 0);
		entry_payload_7_o : out std_logic_vector(5 downto 0);
		entry_payload_8_o : out std_logic_vector(5 downto 0);
		entry_payload_9_o : out std_logic_vector(5 downto 0);
		entry_payload_10_o : out std_logic_vector(5 downto 0);
		entry_payload_11_o : out std_logic_vector(5 downto 0);
		entry_payload_12_o : out std_logic_vector(5 downto 0);
		entry_payload_13_o : out std_logic_vector(5 downto 0);
		entry_payload_14_o : out std_logic_vector(5 downto 0);
		entry_payload_15_o : out std_logic_vector(5 downto 0);
		entry_wen_0_o : out std_logic;
		entry_wen_1_o : out std_logic;
		entry_wen_2_o : out std_logic;
		entry_wen_3_o : out std_logic;
		entry_wen_4_o : out std_logic;
		entry_wen_5_o : out std_logic;
		entry_wen_6_o : out std_logic;
		entry_wen_7_o : out std_logic;
		entry_wen_8_o : out std_logic;
		entry_wen_9_o : out std_logic;
		entry_wen_10_o : out std_logic;
		entry_wen_11_o : out std_logic;
		entry_wen_12_o : out std_logic;
		entry_wen_13_o : out std_logic;
		entry_wen_14_o : out std_logic;
		entry_wen_15_o : out std_logic;
		queue_head_oh_i : in std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of lsq_ptq_P1_E16_W6 is
	signal entry_port_idx_oh_0 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_1 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_2 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_3 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_4 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_5 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_6 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_7 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_8 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_9 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_10 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_11 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_12 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_13 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_14 : std_logic_vector(0 downto 0);
	signal entry_port_idx_oh_15 : std_logic_vector(0 downto 0);
	signal TEMP_1_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_2_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_3_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_4_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_5_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_6_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_7_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_8_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_9_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_10_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_11_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_12_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_13_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_14_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_15_mux_0 : std_logic_vector(5 downto 0);
	signal TEMP_16_mux_0 : std_logic_vector(5 downto 0);
	signal entry_ptq_ready_0 : std_logic;
	signal entry_ptq_ready_1 : std_logic;
	signal entry_ptq_ready_2 : std_logic;
	signal entry_ptq_ready_3 : std_logic;
	signal entry_ptq_ready_4 : std_logic;
	signal entry_ptq_ready_5 : std_logic;
	signal entry_ptq_ready_6 : std_logic;
	signal entry_ptq_ready_7 : std_logic;
	signal entry_ptq_ready_8 : std_logic;
	signal entry_ptq_ready_9 : std_logic;
	signal entry_ptq_ready_10 : std_logic;
	signal entry_ptq_ready_11 : std_logic;
	signal entry_ptq_ready_12 : std_logic;
	signal entry_ptq_ready_13 : std_logic;
	signal entry_ptq_ready_14 : std_logic;
	signal entry_ptq_ready_15 : std_logic;
	signal entry_waiting_for_port_0 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_1 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_2 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_3 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_4 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_5 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_6 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_7 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_8 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_9 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_10 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_11 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_12 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_13 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_14 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_15 : std_logic_vector(0 downto 0);
	signal port_ready_vec : std_logic_vector(0 downto 0);
	signal TEMP_17_res_0 : std_logic_vector(0 downto 0);
	signal TEMP_17_res_1 : std_logic_vector(0 downto 0);
	signal TEMP_17_res_2 : std_logic_vector(0 downto 0);
	signal TEMP_17_res_3 : std_logic_vector(0 downto 0);
	signal TEMP_17_res_4 : std_logic_vector(0 downto 0);
	signal TEMP_17_res_5 : std_logic_vector(0 downto 0);
	signal TEMP_17_res_6 : std_logic_vector(0 downto 0);
	signal TEMP_17_res_7 : std_logic_vector(0 downto 0);
	signal TEMP_18_res_0 : std_logic_vector(0 downto 0);
	signal TEMP_18_res_1 : std_logic_vector(0 downto 0);
	signal TEMP_18_res_2 : std_logic_vector(0 downto 0);
	signal TEMP_18_res_3 : std_logic_vector(0 downto 0);
	signal TEMP_19_res_0 : std_logic_vector(0 downto 0);
	signal TEMP_19_res_1 : std_logic_vector(0 downto 0);
	signal entry_port_options_0 : std_logic_vector(0 downto 0);
	signal entry_port_options_1 : std_logic_vector(0 downto 0);
	signal entry_port_options_2 : std_logic_vector(0 downto 0);
	signal entry_port_options_3 : std_logic_vector(0 downto 0);
	signal entry_port_options_4 : std_logic_vector(0 downto 0);
	signal entry_port_options_5 : std_logic_vector(0 downto 0);
	signal entry_port_options_6 : std_logic_vector(0 downto 0);
	signal entry_port_options_7 : std_logic_vector(0 downto 0);
	signal entry_port_options_8 : std_logic_vector(0 downto 0);
	signal entry_port_options_9 : std_logic_vector(0 downto 0);
	signal entry_port_options_10 : std_logic_vector(0 downto 0);
	signal entry_port_options_11 : std_logic_vector(0 downto 0);
	signal entry_port_options_12 : std_logic_vector(0 downto 0);
	signal entry_port_options_13 : std_logic_vector(0 downto 0);
	signal entry_port_options_14 : std_logic_vector(0 downto 0);
	signal entry_port_options_15 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_0 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_1 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_2 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_3 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_4 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_5 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_6 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_7 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_8 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_9 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_10 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_11 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_12 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_13 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_14 : std_logic_vector(0 downto 0);
	signal entry_port_transfer_15 : std_logic_vector(0 downto 0);
	signal TEMP_20_double_in_0 : std_logic_vector(31 downto 0);
	signal TEMP_20_double_out_0 : std_logic_vector(31 downto 0);
begin
	entry_port_idx_oh_0 <= "1";
	entry_port_idx_oh_1 <= "1";
	entry_port_idx_oh_2 <= "1";
	entry_port_idx_oh_3 <= "1";
	entry_port_idx_oh_4 <= "1";
	entry_port_idx_oh_5 <= "1";
	entry_port_idx_oh_6 <= "1";
	entry_port_idx_oh_7 <= "1";
	entry_port_idx_oh_8 <= "1";
	entry_port_idx_oh_9 <= "1";
	entry_port_idx_oh_10 <= "1";
	entry_port_idx_oh_11 <= "1";
	entry_port_idx_oh_12 <= "1";
	entry_port_idx_oh_13 <= "1";
	entry_port_idx_oh_14 <= "1";
	entry_port_idx_oh_15 <= "1";
	-- Mux1H Begin
	-- Mux1H(entry_payload_0, port_payload, entry_port_idx_oh_0)
	TEMP_1_mux_0 <= port_payload_0_i when entry_port_idx_oh_0(0) = '1' else "000000";
	entry_payload_0_o <= TEMP_1_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_1, port_payload, entry_port_idx_oh_1)
	TEMP_2_mux_0 <= port_payload_0_i when entry_port_idx_oh_1(0) = '1' else "000000";
	entry_payload_1_o <= TEMP_2_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_2, port_payload, entry_port_idx_oh_2)
	TEMP_3_mux_0 <= port_payload_0_i when entry_port_idx_oh_2(0) = '1' else "000000";
	entry_payload_2_o <= TEMP_3_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_3, port_payload, entry_port_idx_oh_3)
	TEMP_4_mux_0 <= port_payload_0_i when entry_port_idx_oh_3(0) = '1' else "000000";
	entry_payload_3_o <= TEMP_4_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_4, port_payload, entry_port_idx_oh_4)
	TEMP_5_mux_0 <= port_payload_0_i when entry_port_idx_oh_4(0) = '1' else "000000";
	entry_payload_4_o <= TEMP_5_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_5, port_payload, entry_port_idx_oh_5)
	TEMP_6_mux_0 <= port_payload_0_i when entry_port_idx_oh_5(0) = '1' else "000000";
	entry_payload_5_o <= TEMP_6_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_6, port_payload, entry_port_idx_oh_6)
	TEMP_7_mux_0 <= port_payload_0_i when entry_port_idx_oh_6(0) = '1' else "000000";
	entry_payload_6_o <= TEMP_7_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_7, port_payload, entry_port_idx_oh_7)
	TEMP_8_mux_0 <= port_payload_0_i when entry_port_idx_oh_7(0) = '1' else "000000";
	entry_payload_7_o <= TEMP_8_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_8, port_payload, entry_port_idx_oh_8)
	TEMP_9_mux_0 <= port_payload_0_i when entry_port_idx_oh_8(0) = '1' else "000000";
	entry_payload_8_o <= TEMP_9_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_9, port_payload, entry_port_idx_oh_9)
	TEMP_10_mux_0 <= port_payload_0_i when entry_port_idx_oh_9(0) = '1' else "000000";
	entry_payload_9_o <= TEMP_10_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_10, port_payload, entry_port_idx_oh_10)
	TEMP_11_mux_0 <= port_payload_0_i when entry_port_idx_oh_10(0) = '1' else "000000";
	entry_payload_10_o <= TEMP_11_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_11, port_payload, entry_port_idx_oh_11)
	TEMP_12_mux_0 <= port_payload_0_i when entry_port_idx_oh_11(0) = '1' else "000000";
	entry_payload_11_o <= TEMP_12_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_12, port_payload, entry_port_idx_oh_12)
	TEMP_13_mux_0 <= port_payload_0_i when entry_port_idx_oh_12(0) = '1' else "000000";
	entry_payload_12_o <= TEMP_13_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_13, port_payload, entry_port_idx_oh_13)
	TEMP_14_mux_0 <= port_payload_0_i when entry_port_idx_oh_13(0) = '1' else "000000";
	entry_payload_13_o <= TEMP_14_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_14, port_payload, entry_port_idx_oh_14)
	TEMP_15_mux_0 <= port_payload_0_i when entry_port_idx_oh_14(0) = '1' else "000000";
	entry_payload_14_o <= TEMP_15_mux_0;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_15, port_payload, entry_port_idx_oh_15)
	TEMP_16_mux_0 <= port_payload_0_i when entry_port_idx_oh_15(0) = '1' else "000000";
	entry_payload_15_o <= TEMP_16_mux_0;
	-- Mux1H End

	entry_ptq_ready_0 <= entry_alloc_0_i and not entry_payload_valid_0_i;
	entry_ptq_ready_1 <= entry_alloc_1_i and not entry_payload_valid_1_i;
	entry_ptq_ready_2 <= entry_alloc_2_i and not entry_payload_valid_2_i;
	entry_ptq_ready_3 <= entry_alloc_3_i and not entry_payload_valid_3_i;
	entry_ptq_ready_4 <= entry_alloc_4_i and not entry_payload_valid_4_i;
	entry_ptq_ready_5 <= entry_alloc_5_i and not entry_payload_valid_5_i;
	entry_ptq_ready_6 <= entry_alloc_6_i and not entry_payload_valid_6_i;
	entry_ptq_ready_7 <= entry_alloc_7_i and not entry_payload_valid_7_i;
	entry_ptq_ready_8 <= entry_alloc_8_i and not entry_payload_valid_8_i;
	entry_ptq_ready_9 <= entry_alloc_9_i and not entry_payload_valid_9_i;
	entry_ptq_ready_10 <= entry_alloc_10_i and not entry_payload_valid_10_i;
	entry_ptq_ready_11 <= entry_alloc_11_i and not entry_payload_valid_11_i;
	entry_ptq_ready_12 <= entry_alloc_12_i and not entry_payload_valid_12_i;
	entry_ptq_ready_13 <= entry_alloc_13_i and not entry_payload_valid_13_i;
	entry_ptq_ready_14 <= entry_alloc_14_i and not entry_payload_valid_14_i;
	entry_ptq_ready_15 <= entry_alloc_15_i and not entry_payload_valid_15_i;
	entry_waiting_for_port_0 <= entry_port_idx_oh_0 when entry_ptq_ready_0 else "0";
	entry_waiting_for_port_1 <= entry_port_idx_oh_1 when entry_ptq_ready_1 else "0";
	entry_waiting_for_port_2 <= entry_port_idx_oh_2 when entry_ptq_ready_2 else "0";
	entry_waiting_for_port_3 <= entry_port_idx_oh_3 when entry_ptq_ready_3 else "0";
	entry_waiting_for_port_4 <= entry_port_idx_oh_4 when entry_ptq_ready_4 else "0";
	entry_waiting_for_port_5 <= entry_port_idx_oh_5 when entry_ptq_ready_5 else "0";
	entry_waiting_for_port_6 <= entry_port_idx_oh_6 when entry_ptq_ready_6 else "0";
	entry_waiting_for_port_7 <= entry_port_idx_oh_7 when entry_ptq_ready_7 else "0";
	entry_waiting_for_port_8 <= entry_port_idx_oh_8 when entry_ptq_ready_8 else "0";
	entry_waiting_for_port_9 <= entry_port_idx_oh_9 when entry_ptq_ready_9 else "0";
	entry_waiting_for_port_10 <= entry_port_idx_oh_10 when entry_ptq_ready_10 else "0";
	entry_waiting_for_port_11 <= entry_port_idx_oh_11 when entry_ptq_ready_11 else "0";
	entry_waiting_for_port_12 <= entry_port_idx_oh_12 when entry_ptq_ready_12 else "0";
	entry_waiting_for_port_13 <= entry_port_idx_oh_13 when entry_ptq_ready_13 else "0";
	entry_waiting_for_port_14 <= entry_port_idx_oh_14 when entry_ptq_ready_14 else "0";
	entry_waiting_for_port_15 <= entry_port_idx_oh_15 when entry_ptq_ready_15 else "0";
	-- Reduction Begin
	-- Reduce(port_ready_vec, entry_waiting_for_port, or)
	TEMP_17_res_0 <= entry_waiting_for_port_0 or entry_waiting_for_port_8;
	TEMP_17_res_1 <= entry_waiting_for_port_1 or entry_waiting_for_port_9;
	TEMP_17_res_2 <= entry_waiting_for_port_2 or entry_waiting_for_port_10;
	TEMP_17_res_3 <= entry_waiting_for_port_3 or entry_waiting_for_port_11;
	TEMP_17_res_4 <= entry_waiting_for_port_4 or entry_waiting_for_port_12;
	TEMP_17_res_5 <= entry_waiting_for_port_5 or entry_waiting_for_port_13;
	TEMP_17_res_6 <= entry_waiting_for_port_6 or entry_waiting_for_port_14;
	TEMP_17_res_7 <= entry_waiting_for_port_7 or entry_waiting_for_port_15;
	-- Layer End
	TEMP_18_res_0 <= TEMP_17_res_0 or TEMP_17_res_4;
	TEMP_18_res_1 <= TEMP_17_res_1 or TEMP_17_res_5;
	TEMP_18_res_2 <= TEMP_17_res_2 or TEMP_17_res_6;
	TEMP_18_res_3 <= TEMP_17_res_3 or TEMP_17_res_7;
	-- Layer End
	TEMP_19_res_0 <= TEMP_18_res_0 or TEMP_18_res_2;
	TEMP_19_res_1 <= TEMP_18_res_1 or TEMP_18_res_3;
	-- Layer End
	port_ready_vec <= TEMP_19_res_0 or TEMP_19_res_1;
	-- Reduction End

	port_ready_0_o <= port_ready_vec(0);
	entry_port_options_0(0) <= entry_waiting_for_port_0(0) and port_valid_0_i;
	entry_port_options_1(0) <= entry_waiting_for_port_1(0) and port_valid_0_i;
	entry_port_options_2(0) <= entry_waiting_for_port_2(0) and port_valid_0_i;
	entry_port_options_3(0) <= entry_waiting_for_port_3(0) and port_valid_0_i;
	entry_port_options_4(0) <= entry_waiting_for_port_4(0) and port_valid_0_i;
	entry_port_options_5(0) <= entry_waiting_for_port_5(0) and port_valid_0_i;
	entry_port_options_6(0) <= entry_waiting_for_port_6(0) and port_valid_0_i;
	entry_port_options_7(0) <= entry_waiting_for_port_7(0) and port_valid_0_i;
	entry_port_options_8(0) <= entry_waiting_for_port_8(0) and port_valid_0_i;
	entry_port_options_9(0) <= entry_waiting_for_port_9(0) and port_valid_0_i;
	entry_port_options_10(0) <= entry_waiting_for_port_10(0) and port_valid_0_i;
	entry_port_options_11(0) <= entry_waiting_for_port_11(0) and port_valid_0_i;
	entry_port_options_12(0) <= entry_waiting_for_port_12(0) and port_valid_0_i;
	entry_port_options_13(0) <= entry_waiting_for_port_13(0) and port_valid_0_i;
	entry_port_options_14(0) <= entry_waiting_for_port_14(0) and port_valid_0_i;
	entry_port_options_15(0) <= entry_waiting_for_port_15(0) and port_valid_0_i;
	-- Priority Masking Begin
	-- CyclicPriorityMask(entry_port_transfer, entry_port_options, queue_head_oh)
	TEMP_20_double_in_0(0) <= entry_port_options_0(0);
	TEMP_20_double_in_0(16) <= entry_port_options_0(0);
	TEMP_20_double_in_0(1) <= entry_port_options_1(0);
	TEMP_20_double_in_0(17) <= entry_port_options_1(0);
	TEMP_20_double_in_0(2) <= entry_port_options_2(0);
	TEMP_20_double_in_0(18) <= entry_port_options_2(0);
	TEMP_20_double_in_0(3) <= entry_port_options_3(0);
	TEMP_20_double_in_0(19) <= entry_port_options_3(0);
	TEMP_20_double_in_0(4) <= entry_port_options_4(0);
	TEMP_20_double_in_0(20) <= entry_port_options_4(0);
	TEMP_20_double_in_0(5) <= entry_port_options_5(0);
	TEMP_20_double_in_0(21) <= entry_port_options_5(0);
	TEMP_20_double_in_0(6) <= entry_port_options_6(0);
	TEMP_20_double_in_0(22) <= entry_port_options_6(0);
	TEMP_20_double_in_0(7) <= entry_port_options_7(0);
	TEMP_20_double_in_0(23) <= entry_port_options_7(0);
	TEMP_20_double_in_0(8) <= entry_port_options_8(0);
	TEMP_20_double_in_0(24) <= entry_port_options_8(0);
	TEMP_20_double_in_0(9) <= entry_port_options_9(0);
	TEMP_20_double_in_0(25) <= entry_port_options_9(0);
	TEMP_20_double_in_0(10) <= entry_port_options_10(0);
	TEMP_20_double_in_0(26) <= entry_port_options_10(0);
	TEMP_20_double_in_0(11) <= entry_port_options_11(0);
	TEMP_20_double_in_0(27) <= entry_port_options_11(0);
	TEMP_20_double_in_0(12) <= entry_port_options_12(0);
	TEMP_20_double_in_0(28) <= entry_port_options_12(0);
	TEMP_20_double_in_0(13) <= entry_port_options_13(0);
	TEMP_20_double_in_0(29) <= entry_port_options_13(0);
	TEMP_20_double_in_0(14) <= entry_port_options_14(0);
	TEMP_20_double_in_0(30) <= entry_port_options_14(0);
	TEMP_20_double_in_0(15) <= entry_port_options_15(0);
	TEMP_20_double_in_0(31) <= entry_port_options_15(0);
	TEMP_20_double_out_0 <= TEMP_20_double_in_0 and not std_logic_vector( unsigned( TEMP_20_double_in_0 ) - unsigned( "0000000000000000" & queue_head_oh_i ) );
	entry_port_transfer_0(0) <= TEMP_20_double_out_0(0) or TEMP_20_double_out_0(16);
	entry_port_transfer_1(0) <= TEMP_20_double_out_0(1) or TEMP_20_double_out_0(17);
	entry_port_transfer_2(0) <= TEMP_20_double_out_0(2) or TEMP_20_double_out_0(18);
	entry_port_transfer_3(0) <= TEMP_20_double_out_0(3) or TEMP_20_double_out_0(19);
	entry_port_transfer_4(0) <= TEMP_20_double_out_0(4) or TEMP_20_double_out_0(20);
	entry_port_transfer_5(0) <= TEMP_20_double_out_0(5) or TEMP_20_double_out_0(21);
	entry_port_transfer_6(0) <= TEMP_20_double_out_0(6) or TEMP_20_double_out_0(22);
	entry_port_transfer_7(0) <= TEMP_20_double_out_0(7) or TEMP_20_double_out_0(23);
	entry_port_transfer_8(0) <= TEMP_20_double_out_0(8) or TEMP_20_double_out_0(24);
	entry_port_transfer_9(0) <= TEMP_20_double_out_0(9) or TEMP_20_double_out_0(25);
	entry_port_transfer_10(0) <= TEMP_20_double_out_0(10) or TEMP_20_double_out_0(26);
	entry_port_transfer_11(0) <= TEMP_20_double_out_0(11) or TEMP_20_double_out_0(27);
	entry_port_transfer_12(0) <= TEMP_20_double_out_0(12) or TEMP_20_double_out_0(28);
	entry_port_transfer_13(0) <= TEMP_20_double_out_0(13) or TEMP_20_double_out_0(29);
	entry_port_transfer_14(0) <= TEMP_20_double_out_0(14) or TEMP_20_double_out_0(30);
	entry_port_transfer_15(0) <= TEMP_20_double_out_0(15) or TEMP_20_double_out_0(31);
	-- Priority Masking End

	-- Reduction Begin
	-- Reduce(entry_wen_0, entry_port_transfer_0, or)
	entry_wen_0_o <= entry_port_transfer_0(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_1, entry_port_transfer_1, or)
	entry_wen_1_o <= entry_port_transfer_1(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_2, entry_port_transfer_2, or)
	entry_wen_2_o <= entry_port_transfer_2(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_3, entry_port_transfer_3, or)
	entry_wen_3_o <= entry_port_transfer_3(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_4, entry_port_transfer_4, or)
	entry_wen_4_o <= entry_port_transfer_4(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_5, entry_port_transfer_5, or)
	entry_wen_5_o <= entry_port_transfer_5(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_6, entry_port_transfer_6, or)
	entry_wen_6_o <= entry_port_transfer_6(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_7, entry_port_transfer_7, or)
	entry_wen_7_o <= entry_port_transfer_7(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_8, entry_port_transfer_8, or)
	entry_wen_8_o <= entry_port_transfer_8(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_9, entry_port_transfer_9, or)
	entry_wen_9_o <= entry_port_transfer_9(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_10, entry_port_transfer_10, or)
	entry_wen_10_o <= entry_port_transfer_10(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_11, entry_port_transfer_11, or)
	entry_wen_11_o <= entry_port_transfer_11(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_12, entry_port_transfer_12, or)
	entry_wen_12_o <= entry_port_transfer_12(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_13, entry_port_transfer_13, or)
	entry_wen_13_o <= entry_port_transfer_13(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_14, entry_port_transfer_14, or)
	entry_wen_14_o <= entry_port_transfer_14(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_15, entry_port_transfer_15, or)
	entry_wen_15_o <= entry_port_transfer_15(0);
	-- Reduction End


end architecture;
