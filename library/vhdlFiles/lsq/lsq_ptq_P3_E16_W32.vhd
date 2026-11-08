

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lsq_ptq_P3_E16_W32 is
	port(
		rst : in std_logic;
		clk : in std_logic;
		port_payload_0_i : in std_logic_vector(31 downto 0);
		port_payload_1_i : in std_logic_vector(31 downto 0);
		port_payload_2_i : in std_logic_vector(31 downto 0);
		port_valid_0_i : in std_logic;
		port_valid_1_i : in std_logic;
		port_valid_2_i : in std_logic;
		port_ready_0_o : out std_logic;
		port_ready_1_o : out std_logic;
		port_ready_2_o : out std_logic;
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
		entry_port_idx_0_i : in std_logic_vector(1 downto 0);
		entry_port_idx_1_i : in std_logic_vector(1 downto 0);
		entry_port_idx_2_i : in std_logic_vector(1 downto 0);
		entry_port_idx_3_i : in std_logic_vector(1 downto 0);
		entry_port_idx_4_i : in std_logic_vector(1 downto 0);
		entry_port_idx_5_i : in std_logic_vector(1 downto 0);
		entry_port_idx_6_i : in std_logic_vector(1 downto 0);
		entry_port_idx_7_i : in std_logic_vector(1 downto 0);
		entry_port_idx_8_i : in std_logic_vector(1 downto 0);
		entry_port_idx_9_i : in std_logic_vector(1 downto 0);
		entry_port_idx_10_i : in std_logic_vector(1 downto 0);
		entry_port_idx_11_i : in std_logic_vector(1 downto 0);
		entry_port_idx_12_i : in std_logic_vector(1 downto 0);
		entry_port_idx_13_i : in std_logic_vector(1 downto 0);
		entry_port_idx_14_i : in std_logic_vector(1 downto 0);
		entry_port_idx_15_i : in std_logic_vector(1 downto 0);
		entry_payload_0_o : out std_logic_vector(31 downto 0);
		entry_payload_1_o : out std_logic_vector(31 downto 0);
		entry_payload_2_o : out std_logic_vector(31 downto 0);
		entry_payload_3_o : out std_logic_vector(31 downto 0);
		entry_payload_4_o : out std_logic_vector(31 downto 0);
		entry_payload_5_o : out std_logic_vector(31 downto 0);
		entry_payload_6_o : out std_logic_vector(31 downto 0);
		entry_payload_7_o : out std_logic_vector(31 downto 0);
		entry_payload_8_o : out std_logic_vector(31 downto 0);
		entry_payload_9_o : out std_logic_vector(31 downto 0);
		entry_payload_10_o : out std_logic_vector(31 downto 0);
		entry_payload_11_o : out std_logic_vector(31 downto 0);
		entry_payload_12_o : out std_logic_vector(31 downto 0);
		entry_payload_13_o : out std_logic_vector(31 downto 0);
		entry_payload_14_o : out std_logic_vector(31 downto 0);
		entry_payload_15_o : out std_logic_vector(31 downto 0);
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

architecture arch of lsq_ptq_P3_E16_W32 is
	signal entry_port_idx_oh_0 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_1 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_2 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_3 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_4 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_5 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_6 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_7 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_8 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_9 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_10 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_11 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_12 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_13 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_14 : std_logic_vector(2 downto 0);
	signal entry_port_idx_oh_15 : std_logic_vector(2 downto 0);
	signal TEMP_1_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_1_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_1_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_2_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_2_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_3_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_3_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_3_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_4_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_4_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_5_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_5_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_5_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_6_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_6_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_7_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_7_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_7_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_8_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_8_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_9_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_9_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_9_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_10_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_10_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_11_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_11_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_11_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_12_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_12_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_13_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_13_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_13_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_14_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_14_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_15_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_15_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_15_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_16_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_16_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_17_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_17_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_17_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_18_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_18_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_19_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_19_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_19_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_20_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_20_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_21_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_21_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_21_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_22_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_22_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_23_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_23_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_23_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_24_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_24_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_25_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_25_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_25_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_26_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_26_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_27_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_27_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_27_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_28_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_28_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_29_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_29_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_29_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_30_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_30_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_31_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_31_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_31_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_32_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_32_res_1 : std_logic_vector(31 downto 0);
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
	signal entry_waiting_for_port_0 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_1 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_2 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_3 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_4 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_5 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_6 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_7 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_8 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_9 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_10 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_11 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_12 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_13 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_14 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_15 : std_logic_vector(2 downto 0);
	signal port_ready_vec : std_logic_vector(2 downto 0);
	signal TEMP_33_res_0 : std_logic_vector(2 downto 0);
	signal TEMP_33_res_1 : std_logic_vector(2 downto 0);
	signal TEMP_33_res_2 : std_logic_vector(2 downto 0);
	signal TEMP_33_res_3 : std_logic_vector(2 downto 0);
	signal TEMP_33_res_4 : std_logic_vector(2 downto 0);
	signal TEMP_33_res_5 : std_logic_vector(2 downto 0);
	signal TEMP_33_res_6 : std_logic_vector(2 downto 0);
	signal TEMP_33_res_7 : std_logic_vector(2 downto 0);
	signal TEMP_34_res_0 : std_logic_vector(2 downto 0);
	signal TEMP_34_res_1 : std_logic_vector(2 downto 0);
	signal TEMP_34_res_2 : std_logic_vector(2 downto 0);
	signal TEMP_34_res_3 : std_logic_vector(2 downto 0);
	signal TEMP_35_res_0 : std_logic_vector(2 downto 0);
	signal TEMP_35_res_1 : std_logic_vector(2 downto 0);
	signal entry_port_options_0 : std_logic_vector(2 downto 0);
	signal entry_port_options_1 : std_logic_vector(2 downto 0);
	signal entry_port_options_2 : std_logic_vector(2 downto 0);
	signal entry_port_options_3 : std_logic_vector(2 downto 0);
	signal entry_port_options_4 : std_logic_vector(2 downto 0);
	signal entry_port_options_5 : std_logic_vector(2 downto 0);
	signal entry_port_options_6 : std_logic_vector(2 downto 0);
	signal entry_port_options_7 : std_logic_vector(2 downto 0);
	signal entry_port_options_8 : std_logic_vector(2 downto 0);
	signal entry_port_options_9 : std_logic_vector(2 downto 0);
	signal entry_port_options_10 : std_logic_vector(2 downto 0);
	signal entry_port_options_11 : std_logic_vector(2 downto 0);
	signal entry_port_options_12 : std_logic_vector(2 downto 0);
	signal entry_port_options_13 : std_logic_vector(2 downto 0);
	signal entry_port_options_14 : std_logic_vector(2 downto 0);
	signal entry_port_options_15 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_0 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_1 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_2 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_3 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_4 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_5 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_6 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_7 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_8 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_9 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_10 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_11 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_12 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_13 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_14 : std_logic_vector(2 downto 0);
	signal entry_port_transfer_15 : std_logic_vector(2 downto 0);
	signal TEMP_36_double_in_0 : std_logic_vector(31 downto 0);
	signal TEMP_36_double_out_0 : std_logic_vector(31 downto 0);
	signal TEMP_36_double_in_1 : std_logic_vector(31 downto 0);
	signal TEMP_36_double_out_1 : std_logic_vector(31 downto 0);
	signal TEMP_36_double_in_2 : std_logic_vector(31 downto 0);
	signal TEMP_36_double_out_2 : std_logic_vector(31 downto 0);
	signal TEMP_37_res : std_logic_vector(1 downto 0);
	signal TEMP_38_res : std_logic_vector(1 downto 0);
	signal TEMP_39_res : std_logic_vector(1 downto 0);
	signal TEMP_40_res : std_logic_vector(1 downto 0);
	signal TEMP_41_res : std_logic_vector(1 downto 0);
	signal TEMP_42_res : std_logic_vector(1 downto 0);
	signal TEMP_43_res : std_logic_vector(1 downto 0);
	signal TEMP_44_res : std_logic_vector(1 downto 0);
	signal TEMP_45_res : std_logic_vector(1 downto 0);
	signal TEMP_46_res : std_logic_vector(1 downto 0);
	signal TEMP_47_res : std_logic_vector(1 downto 0);
	signal TEMP_48_res : std_logic_vector(1 downto 0);
	signal TEMP_49_res : std_logic_vector(1 downto 0);
	signal TEMP_50_res : std_logic_vector(1 downto 0);
	signal TEMP_51_res : std_logic_vector(1 downto 0);
	signal TEMP_52_res : std_logic_vector(1 downto 0);
begin
	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_0, entry_port_idx_0)
	entry_port_idx_oh_0(0) <= '1' when entry_port_idx_0_i = "00" else '0';
	entry_port_idx_oh_0(1) <= '1' when entry_port_idx_0_i = "01" else '0';
	entry_port_idx_oh_0(2) <= '1' when entry_port_idx_0_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_1, entry_port_idx_1)
	entry_port_idx_oh_1(0) <= '1' when entry_port_idx_1_i = "00" else '0';
	entry_port_idx_oh_1(1) <= '1' when entry_port_idx_1_i = "01" else '0';
	entry_port_idx_oh_1(2) <= '1' when entry_port_idx_1_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_2, entry_port_idx_2)
	entry_port_idx_oh_2(0) <= '1' when entry_port_idx_2_i = "00" else '0';
	entry_port_idx_oh_2(1) <= '1' when entry_port_idx_2_i = "01" else '0';
	entry_port_idx_oh_2(2) <= '1' when entry_port_idx_2_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_3, entry_port_idx_3)
	entry_port_idx_oh_3(0) <= '1' when entry_port_idx_3_i = "00" else '0';
	entry_port_idx_oh_3(1) <= '1' when entry_port_idx_3_i = "01" else '0';
	entry_port_idx_oh_3(2) <= '1' when entry_port_idx_3_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_4, entry_port_idx_4)
	entry_port_idx_oh_4(0) <= '1' when entry_port_idx_4_i = "00" else '0';
	entry_port_idx_oh_4(1) <= '1' when entry_port_idx_4_i = "01" else '0';
	entry_port_idx_oh_4(2) <= '1' when entry_port_idx_4_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_5, entry_port_idx_5)
	entry_port_idx_oh_5(0) <= '1' when entry_port_idx_5_i = "00" else '0';
	entry_port_idx_oh_5(1) <= '1' when entry_port_idx_5_i = "01" else '0';
	entry_port_idx_oh_5(2) <= '1' when entry_port_idx_5_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_6, entry_port_idx_6)
	entry_port_idx_oh_6(0) <= '1' when entry_port_idx_6_i = "00" else '0';
	entry_port_idx_oh_6(1) <= '1' when entry_port_idx_6_i = "01" else '0';
	entry_port_idx_oh_6(2) <= '1' when entry_port_idx_6_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_7, entry_port_idx_7)
	entry_port_idx_oh_7(0) <= '1' when entry_port_idx_7_i = "00" else '0';
	entry_port_idx_oh_7(1) <= '1' when entry_port_idx_7_i = "01" else '0';
	entry_port_idx_oh_7(2) <= '1' when entry_port_idx_7_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_8, entry_port_idx_8)
	entry_port_idx_oh_8(0) <= '1' when entry_port_idx_8_i = "00" else '0';
	entry_port_idx_oh_8(1) <= '1' when entry_port_idx_8_i = "01" else '0';
	entry_port_idx_oh_8(2) <= '1' when entry_port_idx_8_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_9, entry_port_idx_9)
	entry_port_idx_oh_9(0) <= '1' when entry_port_idx_9_i = "00" else '0';
	entry_port_idx_oh_9(1) <= '1' when entry_port_idx_9_i = "01" else '0';
	entry_port_idx_oh_9(2) <= '1' when entry_port_idx_9_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_10, entry_port_idx_10)
	entry_port_idx_oh_10(0) <= '1' when entry_port_idx_10_i = "00" else '0';
	entry_port_idx_oh_10(1) <= '1' when entry_port_idx_10_i = "01" else '0';
	entry_port_idx_oh_10(2) <= '1' when entry_port_idx_10_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_11, entry_port_idx_11)
	entry_port_idx_oh_11(0) <= '1' when entry_port_idx_11_i = "00" else '0';
	entry_port_idx_oh_11(1) <= '1' when entry_port_idx_11_i = "01" else '0';
	entry_port_idx_oh_11(2) <= '1' when entry_port_idx_11_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_12, entry_port_idx_12)
	entry_port_idx_oh_12(0) <= '1' when entry_port_idx_12_i = "00" else '0';
	entry_port_idx_oh_12(1) <= '1' when entry_port_idx_12_i = "01" else '0';
	entry_port_idx_oh_12(2) <= '1' when entry_port_idx_12_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_13, entry_port_idx_13)
	entry_port_idx_oh_13(0) <= '1' when entry_port_idx_13_i = "00" else '0';
	entry_port_idx_oh_13(1) <= '1' when entry_port_idx_13_i = "01" else '0';
	entry_port_idx_oh_13(2) <= '1' when entry_port_idx_13_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_14, entry_port_idx_14)
	entry_port_idx_oh_14(0) <= '1' when entry_port_idx_14_i = "00" else '0';
	entry_port_idx_oh_14(1) <= '1' when entry_port_idx_14_i = "01" else '0';
	entry_port_idx_oh_14(2) <= '1' when entry_port_idx_14_i = "10" else '0';
	-- Bits To One-Hot End

	-- Bits To One-Hot Begin
	-- BitsToOH(entry_port_idx_oh_15, entry_port_idx_15)
	entry_port_idx_oh_15(0) <= '1' when entry_port_idx_15_i = "00" else '0';
	entry_port_idx_oh_15(1) <= '1' when entry_port_idx_15_i = "01" else '0';
	entry_port_idx_oh_15(2) <= '1' when entry_port_idx_15_i = "10" else '0';
	-- Bits To One-Hot End

	-- Mux1H Begin
	-- Mux1H(entry_payload_0, port_payload, entry_port_idx_oh_0)
	TEMP_1_mux_0 <= port_payload_0_i when entry_port_idx_oh_0(0) = '1' else "00000000000000000000000000000000";
	TEMP_1_mux_1 <= port_payload_1_i when entry_port_idx_oh_0(1) = '1' else "00000000000000000000000000000000";
	TEMP_1_mux_2 <= port_payload_2_i when entry_port_idx_oh_0(2) = '1' else "00000000000000000000000000000000";
	TEMP_2_res_0 <= TEMP_1_mux_0 or TEMP_1_mux_2;
	TEMP_2_res_1 <= TEMP_1_mux_1;
	-- Layer End
	entry_payload_0_o <= TEMP_2_res_0 or TEMP_2_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_1, port_payload, entry_port_idx_oh_1)
	TEMP_3_mux_0 <= port_payload_0_i when entry_port_idx_oh_1(0) = '1' else "00000000000000000000000000000000";
	TEMP_3_mux_1 <= port_payload_1_i when entry_port_idx_oh_1(1) = '1' else "00000000000000000000000000000000";
	TEMP_3_mux_2 <= port_payload_2_i when entry_port_idx_oh_1(2) = '1' else "00000000000000000000000000000000";
	TEMP_4_res_0 <= TEMP_3_mux_0 or TEMP_3_mux_2;
	TEMP_4_res_1 <= TEMP_3_mux_1;
	-- Layer End
	entry_payload_1_o <= TEMP_4_res_0 or TEMP_4_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_2, port_payload, entry_port_idx_oh_2)
	TEMP_5_mux_0 <= port_payload_0_i when entry_port_idx_oh_2(0) = '1' else "00000000000000000000000000000000";
	TEMP_5_mux_1 <= port_payload_1_i when entry_port_idx_oh_2(1) = '1' else "00000000000000000000000000000000";
	TEMP_5_mux_2 <= port_payload_2_i when entry_port_idx_oh_2(2) = '1' else "00000000000000000000000000000000";
	TEMP_6_res_0 <= TEMP_5_mux_0 or TEMP_5_mux_2;
	TEMP_6_res_1 <= TEMP_5_mux_1;
	-- Layer End
	entry_payload_2_o <= TEMP_6_res_0 or TEMP_6_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_3, port_payload, entry_port_idx_oh_3)
	TEMP_7_mux_0 <= port_payload_0_i when entry_port_idx_oh_3(0) = '1' else "00000000000000000000000000000000";
	TEMP_7_mux_1 <= port_payload_1_i when entry_port_idx_oh_3(1) = '1' else "00000000000000000000000000000000";
	TEMP_7_mux_2 <= port_payload_2_i when entry_port_idx_oh_3(2) = '1' else "00000000000000000000000000000000";
	TEMP_8_res_0 <= TEMP_7_mux_0 or TEMP_7_mux_2;
	TEMP_8_res_1 <= TEMP_7_mux_1;
	-- Layer End
	entry_payload_3_o <= TEMP_8_res_0 or TEMP_8_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_4, port_payload, entry_port_idx_oh_4)
	TEMP_9_mux_0 <= port_payload_0_i when entry_port_idx_oh_4(0) = '1' else "00000000000000000000000000000000";
	TEMP_9_mux_1 <= port_payload_1_i when entry_port_idx_oh_4(1) = '1' else "00000000000000000000000000000000";
	TEMP_9_mux_2 <= port_payload_2_i when entry_port_idx_oh_4(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_res_0 <= TEMP_9_mux_0 or TEMP_9_mux_2;
	TEMP_10_res_1 <= TEMP_9_mux_1;
	-- Layer End
	entry_payload_4_o <= TEMP_10_res_0 or TEMP_10_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_5, port_payload, entry_port_idx_oh_5)
	TEMP_11_mux_0 <= port_payload_0_i when entry_port_idx_oh_5(0) = '1' else "00000000000000000000000000000000";
	TEMP_11_mux_1 <= port_payload_1_i when entry_port_idx_oh_5(1) = '1' else "00000000000000000000000000000000";
	TEMP_11_mux_2 <= port_payload_2_i when entry_port_idx_oh_5(2) = '1' else "00000000000000000000000000000000";
	TEMP_12_res_0 <= TEMP_11_mux_0 or TEMP_11_mux_2;
	TEMP_12_res_1 <= TEMP_11_mux_1;
	-- Layer End
	entry_payload_5_o <= TEMP_12_res_0 or TEMP_12_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_6, port_payload, entry_port_idx_oh_6)
	TEMP_13_mux_0 <= port_payload_0_i when entry_port_idx_oh_6(0) = '1' else "00000000000000000000000000000000";
	TEMP_13_mux_1 <= port_payload_1_i when entry_port_idx_oh_6(1) = '1' else "00000000000000000000000000000000";
	TEMP_13_mux_2 <= port_payload_2_i when entry_port_idx_oh_6(2) = '1' else "00000000000000000000000000000000";
	TEMP_14_res_0 <= TEMP_13_mux_0 or TEMP_13_mux_2;
	TEMP_14_res_1 <= TEMP_13_mux_1;
	-- Layer End
	entry_payload_6_o <= TEMP_14_res_0 or TEMP_14_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_7, port_payload, entry_port_idx_oh_7)
	TEMP_15_mux_0 <= port_payload_0_i when entry_port_idx_oh_7(0) = '1' else "00000000000000000000000000000000";
	TEMP_15_mux_1 <= port_payload_1_i when entry_port_idx_oh_7(1) = '1' else "00000000000000000000000000000000";
	TEMP_15_mux_2 <= port_payload_2_i when entry_port_idx_oh_7(2) = '1' else "00000000000000000000000000000000";
	TEMP_16_res_0 <= TEMP_15_mux_0 or TEMP_15_mux_2;
	TEMP_16_res_1 <= TEMP_15_mux_1;
	-- Layer End
	entry_payload_7_o <= TEMP_16_res_0 or TEMP_16_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_8, port_payload, entry_port_idx_oh_8)
	TEMP_17_mux_0 <= port_payload_0_i when entry_port_idx_oh_8(0) = '1' else "00000000000000000000000000000000";
	TEMP_17_mux_1 <= port_payload_1_i when entry_port_idx_oh_8(1) = '1' else "00000000000000000000000000000000";
	TEMP_17_mux_2 <= port_payload_2_i when entry_port_idx_oh_8(2) = '1' else "00000000000000000000000000000000";
	TEMP_18_res_0 <= TEMP_17_mux_0 or TEMP_17_mux_2;
	TEMP_18_res_1 <= TEMP_17_mux_1;
	-- Layer End
	entry_payload_8_o <= TEMP_18_res_0 or TEMP_18_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_9, port_payload, entry_port_idx_oh_9)
	TEMP_19_mux_0 <= port_payload_0_i when entry_port_idx_oh_9(0) = '1' else "00000000000000000000000000000000";
	TEMP_19_mux_1 <= port_payload_1_i when entry_port_idx_oh_9(1) = '1' else "00000000000000000000000000000000";
	TEMP_19_mux_2 <= port_payload_2_i when entry_port_idx_oh_9(2) = '1' else "00000000000000000000000000000000";
	TEMP_20_res_0 <= TEMP_19_mux_0 or TEMP_19_mux_2;
	TEMP_20_res_1 <= TEMP_19_mux_1;
	-- Layer End
	entry_payload_9_o <= TEMP_20_res_0 or TEMP_20_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_10, port_payload, entry_port_idx_oh_10)
	TEMP_21_mux_0 <= port_payload_0_i when entry_port_idx_oh_10(0) = '1' else "00000000000000000000000000000000";
	TEMP_21_mux_1 <= port_payload_1_i when entry_port_idx_oh_10(1) = '1' else "00000000000000000000000000000000";
	TEMP_21_mux_2 <= port_payload_2_i when entry_port_idx_oh_10(2) = '1' else "00000000000000000000000000000000";
	TEMP_22_res_0 <= TEMP_21_mux_0 or TEMP_21_mux_2;
	TEMP_22_res_1 <= TEMP_21_mux_1;
	-- Layer End
	entry_payload_10_o <= TEMP_22_res_0 or TEMP_22_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_11, port_payload, entry_port_idx_oh_11)
	TEMP_23_mux_0 <= port_payload_0_i when entry_port_idx_oh_11(0) = '1' else "00000000000000000000000000000000";
	TEMP_23_mux_1 <= port_payload_1_i when entry_port_idx_oh_11(1) = '1' else "00000000000000000000000000000000";
	TEMP_23_mux_2 <= port_payload_2_i when entry_port_idx_oh_11(2) = '1' else "00000000000000000000000000000000";
	TEMP_24_res_0 <= TEMP_23_mux_0 or TEMP_23_mux_2;
	TEMP_24_res_1 <= TEMP_23_mux_1;
	-- Layer End
	entry_payload_11_o <= TEMP_24_res_0 or TEMP_24_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_12, port_payload, entry_port_idx_oh_12)
	TEMP_25_mux_0 <= port_payload_0_i when entry_port_idx_oh_12(0) = '1' else "00000000000000000000000000000000";
	TEMP_25_mux_1 <= port_payload_1_i when entry_port_idx_oh_12(1) = '1' else "00000000000000000000000000000000";
	TEMP_25_mux_2 <= port_payload_2_i when entry_port_idx_oh_12(2) = '1' else "00000000000000000000000000000000";
	TEMP_26_res_0 <= TEMP_25_mux_0 or TEMP_25_mux_2;
	TEMP_26_res_1 <= TEMP_25_mux_1;
	-- Layer End
	entry_payload_12_o <= TEMP_26_res_0 or TEMP_26_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_13, port_payload, entry_port_idx_oh_13)
	TEMP_27_mux_0 <= port_payload_0_i when entry_port_idx_oh_13(0) = '1' else "00000000000000000000000000000000";
	TEMP_27_mux_1 <= port_payload_1_i when entry_port_idx_oh_13(1) = '1' else "00000000000000000000000000000000";
	TEMP_27_mux_2 <= port_payload_2_i when entry_port_idx_oh_13(2) = '1' else "00000000000000000000000000000000";
	TEMP_28_res_0 <= TEMP_27_mux_0 or TEMP_27_mux_2;
	TEMP_28_res_1 <= TEMP_27_mux_1;
	-- Layer End
	entry_payload_13_o <= TEMP_28_res_0 or TEMP_28_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_14, port_payload, entry_port_idx_oh_14)
	TEMP_29_mux_0 <= port_payload_0_i when entry_port_idx_oh_14(0) = '1' else "00000000000000000000000000000000";
	TEMP_29_mux_1 <= port_payload_1_i when entry_port_idx_oh_14(1) = '1' else "00000000000000000000000000000000";
	TEMP_29_mux_2 <= port_payload_2_i when entry_port_idx_oh_14(2) = '1' else "00000000000000000000000000000000";
	TEMP_30_res_0 <= TEMP_29_mux_0 or TEMP_29_mux_2;
	TEMP_30_res_1 <= TEMP_29_mux_1;
	-- Layer End
	entry_payload_14_o <= TEMP_30_res_0 or TEMP_30_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(entry_payload_15, port_payload, entry_port_idx_oh_15)
	TEMP_31_mux_0 <= port_payload_0_i when entry_port_idx_oh_15(0) = '1' else "00000000000000000000000000000000";
	TEMP_31_mux_1 <= port_payload_1_i when entry_port_idx_oh_15(1) = '1' else "00000000000000000000000000000000";
	TEMP_31_mux_2 <= port_payload_2_i when entry_port_idx_oh_15(2) = '1' else "00000000000000000000000000000000";
	TEMP_32_res_0 <= TEMP_31_mux_0 or TEMP_31_mux_2;
	TEMP_32_res_1 <= TEMP_31_mux_1;
	-- Layer End
	entry_payload_15_o <= TEMP_32_res_0 or TEMP_32_res_1;
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
	entry_waiting_for_port_0 <= entry_port_idx_oh_0 when entry_ptq_ready_0 else "000";
	entry_waiting_for_port_1 <= entry_port_idx_oh_1 when entry_ptq_ready_1 else "000";
	entry_waiting_for_port_2 <= entry_port_idx_oh_2 when entry_ptq_ready_2 else "000";
	entry_waiting_for_port_3 <= entry_port_idx_oh_3 when entry_ptq_ready_3 else "000";
	entry_waiting_for_port_4 <= entry_port_idx_oh_4 when entry_ptq_ready_4 else "000";
	entry_waiting_for_port_5 <= entry_port_idx_oh_5 when entry_ptq_ready_5 else "000";
	entry_waiting_for_port_6 <= entry_port_idx_oh_6 when entry_ptq_ready_6 else "000";
	entry_waiting_for_port_7 <= entry_port_idx_oh_7 when entry_ptq_ready_7 else "000";
	entry_waiting_for_port_8 <= entry_port_idx_oh_8 when entry_ptq_ready_8 else "000";
	entry_waiting_for_port_9 <= entry_port_idx_oh_9 when entry_ptq_ready_9 else "000";
	entry_waiting_for_port_10 <= entry_port_idx_oh_10 when entry_ptq_ready_10 else "000";
	entry_waiting_for_port_11 <= entry_port_idx_oh_11 when entry_ptq_ready_11 else "000";
	entry_waiting_for_port_12 <= entry_port_idx_oh_12 when entry_ptq_ready_12 else "000";
	entry_waiting_for_port_13 <= entry_port_idx_oh_13 when entry_ptq_ready_13 else "000";
	entry_waiting_for_port_14 <= entry_port_idx_oh_14 when entry_ptq_ready_14 else "000";
	entry_waiting_for_port_15 <= entry_port_idx_oh_15 when entry_ptq_ready_15 else "000";
	-- Reduction Begin
	-- Reduce(port_ready_vec, entry_waiting_for_port, or)
	TEMP_33_res_0 <= entry_waiting_for_port_0 or entry_waiting_for_port_8;
	TEMP_33_res_1 <= entry_waiting_for_port_1 or entry_waiting_for_port_9;
	TEMP_33_res_2 <= entry_waiting_for_port_2 or entry_waiting_for_port_10;
	TEMP_33_res_3 <= entry_waiting_for_port_3 or entry_waiting_for_port_11;
	TEMP_33_res_4 <= entry_waiting_for_port_4 or entry_waiting_for_port_12;
	TEMP_33_res_5 <= entry_waiting_for_port_5 or entry_waiting_for_port_13;
	TEMP_33_res_6 <= entry_waiting_for_port_6 or entry_waiting_for_port_14;
	TEMP_33_res_7 <= entry_waiting_for_port_7 or entry_waiting_for_port_15;
	-- Layer End
	TEMP_34_res_0 <= TEMP_33_res_0 or TEMP_33_res_4;
	TEMP_34_res_1 <= TEMP_33_res_1 or TEMP_33_res_5;
	TEMP_34_res_2 <= TEMP_33_res_2 or TEMP_33_res_6;
	TEMP_34_res_3 <= TEMP_33_res_3 or TEMP_33_res_7;
	-- Layer End
	TEMP_35_res_0 <= TEMP_34_res_0 or TEMP_34_res_2;
	TEMP_35_res_1 <= TEMP_34_res_1 or TEMP_34_res_3;
	-- Layer End
	port_ready_vec <= TEMP_35_res_0 or TEMP_35_res_1;
	-- Reduction End

	port_ready_0_o <= port_ready_vec(0);
	port_ready_1_o <= port_ready_vec(1);
	port_ready_2_o <= port_ready_vec(2);
	entry_port_options_0(0) <= entry_waiting_for_port_0(0) and port_valid_0_i;
	entry_port_options_0(1) <= entry_waiting_for_port_0(1) and port_valid_1_i;
	entry_port_options_0(2) <= entry_waiting_for_port_0(2) and port_valid_2_i;
	entry_port_options_1(0) <= entry_waiting_for_port_1(0) and port_valid_0_i;
	entry_port_options_1(1) <= entry_waiting_for_port_1(1) and port_valid_1_i;
	entry_port_options_1(2) <= entry_waiting_for_port_1(2) and port_valid_2_i;
	entry_port_options_2(0) <= entry_waiting_for_port_2(0) and port_valid_0_i;
	entry_port_options_2(1) <= entry_waiting_for_port_2(1) and port_valid_1_i;
	entry_port_options_2(2) <= entry_waiting_for_port_2(2) and port_valid_2_i;
	entry_port_options_3(0) <= entry_waiting_for_port_3(0) and port_valid_0_i;
	entry_port_options_3(1) <= entry_waiting_for_port_3(1) and port_valid_1_i;
	entry_port_options_3(2) <= entry_waiting_for_port_3(2) and port_valid_2_i;
	entry_port_options_4(0) <= entry_waiting_for_port_4(0) and port_valid_0_i;
	entry_port_options_4(1) <= entry_waiting_for_port_4(1) and port_valid_1_i;
	entry_port_options_4(2) <= entry_waiting_for_port_4(2) and port_valid_2_i;
	entry_port_options_5(0) <= entry_waiting_for_port_5(0) and port_valid_0_i;
	entry_port_options_5(1) <= entry_waiting_for_port_5(1) and port_valid_1_i;
	entry_port_options_5(2) <= entry_waiting_for_port_5(2) and port_valid_2_i;
	entry_port_options_6(0) <= entry_waiting_for_port_6(0) and port_valid_0_i;
	entry_port_options_6(1) <= entry_waiting_for_port_6(1) and port_valid_1_i;
	entry_port_options_6(2) <= entry_waiting_for_port_6(2) and port_valid_2_i;
	entry_port_options_7(0) <= entry_waiting_for_port_7(0) and port_valid_0_i;
	entry_port_options_7(1) <= entry_waiting_for_port_7(1) and port_valid_1_i;
	entry_port_options_7(2) <= entry_waiting_for_port_7(2) and port_valid_2_i;
	entry_port_options_8(0) <= entry_waiting_for_port_8(0) and port_valid_0_i;
	entry_port_options_8(1) <= entry_waiting_for_port_8(1) and port_valid_1_i;
	entry_port_options_8(2) <= entry_waiting_for_port_8(2) and port_valid_2_i;
	entry_port_options_9(0) <= entry_waiting_for_port_9(0) and port_valid_0_i;
	entry_port_options_9(1) <= entry_waiting_for_port_9(1) and port_valid_1_i;
	entry_port_options_9(2) <= entry_waiting_for_port_9(2) and port_valid_2_i;
	entry_port_options_10(0) <= entry_waiting_for_port_10(0) and port_valid_0_i;
	entry_port_options_10(1) <= entry_waiting_for_port_10(1) and port_valid_1_i;
	entry_port_options_10(2) <= entry_waiting_for_port_10(2) and port_valid_2_i;
	entry_port_options_11(0) <= entry_waiting_for_port_11(0) and port_valid_0_i;
	entry_port_options_11(1) <= entry_waiting_for_port_11(1) and port_valid_1_i;
	entry_port_options_11(2) <= entry_waiting_for_port_11(2) and port_valid_2_i;
	entry_port_options_12(0) <= entry_waiting_for_port_12(0) and port_valid_0_i;
	entry_port_options_12(1) <= entry_waiting_for_port_12(1) and port_valid_1_i;
	entry_port_options_12(2) <= entry_waiting_for_port_12(2) and port_valid_2_i;
	entry_port_options_13(0) <= entry_waiting_for_port_13(0) and port_valid_0_i;
	entry_port_options_13(1) <= entry_waiting_for_port_13(1) and port_valid_1_i;
	entry_port_options_13(2) <= entry_waiting_for_port_13(2) and port_valid_2_i;
	entry_port_options_14(0) <= entry_waiting_for_port_14(0) and port_valid_0_i;
	entry_port_options_14(1) <= entry_waiting_for_port_14(1) and port_valid_1_i;
	entry_port_options_14(2) <= entry_waiting_for_port_14(2) and port_valid_2_i;
	entry_port_options_15(0) <= entry_waiting_for_port_15(0) and port_valid_0_i;
	entry_port_options_15(1) <= entry_waiting_for_port_15(1) and port_valid_1_i;
	entry_port_options_15(2) <= entry_waiting_for_port_15(2) and port_valid_2_i;
	-- Priority Masking Begin
	-- CyclicPriorityMask(entry_port_transfer, entry_port_options, queue_head_oh)
	TEMP_36_double_in_0(0) <= entry_port_options_0(0);
	TEMP_36_double_in_0(16) <= entry_port_options_0(0);
	TEMP_36_double_in_0(1) <= entry_port_options_1(0);
	TEMP_36_double_in_0(17) <= entry_port_options_1(0);
	TEMP_36_double_in_0(2) <= entry_port_options_2(0);
	TEMP_36_double_in_0(18) <= entry_port_options_2(0);
	TEMP_36_double_in_0(3) <= entry_port_options_3(0);
	TEMP_36_double_in_0(19) <= entry_port_options_3(0);
	TEMP_36_double_in_0(4) <= entry_port_options_4(0);
	TEMP_36_double_in_0(20) <= entry_port_options_4(0);
	TEMP_36_double_in_0(5) <= entry_port_options_5(0);
	TEMP_36_double_in_0(21) <= entry_port_options_5(0);
	TEMP_36_double_in_0(6) <= entry_port_options_6(0);
	TEMP_36_double_in_0(22) <= entry_port_options_6(0);
	TEMP_36_double_in_0(7) <= entry_port_options_7(0);
	TEMP_36_double_in_0(23) <= entry_port_options_7(0);
	TEMP_36_double_in_0(8) <= entry_port_options_8(0);
	TEMP_36_double_in_0(24) <= entry_port_options_8(0);
	TEMP_36_double_in_0(9) <= entry_port_options_9(0);
	TEMP_36_double_in_0(25) <= entry_port_options_9(0);
	TEMP_36_double_in_0(10) <= entry_port_options_10(0);
	TEMP_36_double_in_0(26) <= entry_port_options_10(0);
	TEMP_36_double_in_0(11) <= entry_port_options_11(0);
	TEMP_36_double_in_0(27) <= entry_port_options_11(0);
	TEMP_36_double_in_0(12) <= entry_port_options_12(0);
	TEMP_36_double_in_0(28) <= entry_port_options_12(0);
	TEMP_36_double_in_0(13) <= entry_port_options_13(0);
	TEMP_36_double_in_0(29) <= entry_port_options_13(0);
	TEMP_36_double_in_0(14) <= entry_port_options_14(0);
	TEMP_36_double_in_0(30) <= entry_port_options_14(0);
	TEMP_36_double_in_0(15) <= entry_port_options_15(0);
	TEMP_36_double_in_0(31) <= entry_port_options_15(0);
	TEMP_36_double_out_0 <= TEMP_36_double_in_0 and not std_logic_vector( unsigned( TEMP_36_double_in_0 ) - unsigned( "0000000000000000" & queue_head_oh_i ) );
	entry_port_transfer_0(0) <= TEMP_36_double_out_0(0) or TEMP_36_double_out_0(16);
	entry_port_transfer_1(0) <= TEMP_36_double_out_0(1) or TEMP_36_double_out_0(17);
	entry_port_transfer_2(0) <= TEMP_36_double_out_0(2) or TEMP_36_double_out_0(18);
	entry_port_transfer_3(0) <= TEMP_36_double_out_0(3) or TEMP_36_double_out_0(19);
	entry_port_transfer_4(0) <= TEMP_36_double_out_0(4) or TEMP_36_double_out_0(20);
	entry_port_transfer_5(0) <= TEMP_36_double_out_0(5) or TEMP_36_double_out_0(21);
	entry_port_transfer_6(0) <= TEMP_36_double_out_0(6) or TEMP_36_double_out_0(22);
	entry_port_transfer_7(0) <= TEMP_36_double_out_0(7) or TEMP_36_double_out_0(23);
	entry_port_transfer_8(0) <= TEMP_36_double_out_0(8) or TEMP_36_double_out_0(24);
	entry_port_transfer_9(0) <= TEMP_36_double_out_0(9) or TEMP_36_double_out_0(25);
	entry_port_transfer_10(0) <= TEMP_36_double_out_0(10) or TEMP_36_double_out_0(26);
	entry_port_transfer_11(0) <= TEMP_36_double_out_0(11) or TEMP_36_double_out_0(27);
	entry_port_transfer_12(0) <= TEMP_36_double_out_0(12) or TEMP_36_double_out_0(28);
	entry_port_transfer_13(0) <= TEMP_36_double_out_0(13) or TEMP_36_double_out_0(29);
	entry_port_transfer_14(0) <= TEMP_36_double_out_0(14) or TEMP_36_double_out_0(30);
	entry_port_transfer_15(0) <= TEMP_36_double_out_0(15) or TEMP_36_double_out_0(31);
	TEMP_36_double_in_1(0) <= entry_port_options_0(1);
	TEMP_36_double_in_1(16) <= entry_port_options_0(1);
	TEMP_36_double_in_1(1) <= entry_port_options_1(1);
	TEMP_36_double_in_1(17) <= entry_port_options_1(1);
	TEMP_36_double_in_1(2) <= entry_port_options_2(1);
	TEMP_36_double_in_1(18) <= entry_port_options_2(1);
	TEMP_36_double_in_1(3) <= entry_port_options_3(1);
	TEMP_36_double_in_1(19) <= entry_port_options_3(1);
	TEMP_36_double_in_1(4) <= entry_port_options_4(1);
	TEMP_36_double_in_1(20) <= entry_port_options_4(1);
	TEMP_36_double_in_1(5) <= entry_port_options_5(1);
	TEMP_36_double_in_1(21) <= entry_port_options_5(1);
	TEMP_36_double_in_1(6) <= entry_port_options_6(1);
	TEMP_36_double_in_1(22) <= entry_port_options_6(1);
	TEMP_36_double_in_1(7) <= entry_port_options_7(1);
	TEMP_36_double_in_1(23) <= entry_port_options_7(1);
	TEMP_36_double_in_1(8) <= entry_port_options_8(1);
	TEMP_36_double_in_1(24) <= entry_port_options_8(1);
	TEMP_36_double_in_1(9) <= entry_port_options_9(1);
	TEMP_36_double_in_1(25) <= entry_port_options_9(1);
	TEMP_36_double_in_1(10) <= entry_port_options_10(1);
	TEMP_36_double_in_1(26) <= entry_port_options_10(1);
	TEMP_36_double_in_1(11) <= entry_port_options_11(1);
	TEMP_36_double_in_1(27) <= entry_port_options_11(1);
	TEMP_36_double_in_1(12) <= entry_port_options_12(1);
	TEMP_36_double_in_1(28) <= entry_port_options_12(1);
	TEMP_36_double_in_1(13) <= entry_port_options_13(1);
	TEMP_36_double_in_1(29) <= entry_port_options_13(1);
	TEMP_36_double_in_1(14) <= entry_port_options_14(1);
	TEMP_36_double_in_1(30) <= entry_port_options_14(1);
	TEMP_36_double_in_1(15) <= entry_port_options_15(1);
	TEMP_36_double_in_1(31) <= entry_port_options_15(1);
	TEMP_36_double_out_1 <= TEMP_36_double_in_1 and not std_logic_vector( unsigned( TEMP_36_double_in_1 ) - unsigned( "0000000000000000" & queue_head_oh_i ) );
	entry_port_transfer_0(1) <= TEMP_36_double_out_1(0) or TEMP_36_double_out_1(16);
	entry_port_transfer_1(1) <= TEMP_36_double_out_1(1) or TEMP_36_double_out_1(17);
	entry_port_transfer_2(1) <= TEMP_36_double_out_1(2) or TEMP_36_double_out_1(18);
	entry_port_transfer_3(1) <= TEMP_36_double_out_1(3) or TEMP_36_double_out_1(19);
	entry_port_transfer_4(1) <= TEMP_36_double_out_1(4) or TEMP_36_double_out_1(20);
	entry_port_transfer_5(1) <= TEMP_36_double_out_1(5) or TEMP_36_double_out_1(21);
	entry_port_transfer_6(1) <= TEMP_36_double_out_1(6) or TEMP_36_double_out_1(22);
	entry_port_transfer_7(1) <= TEMP_36_double_out_1(7) or TEMP_36_double_out_1(23);
	entry_port_transfer_8(1) <= TEMP_36_double_out_1(8) or TEMP_36_double_out_1(24);
	entry_port_transfer_9(1) <= TEMP_36_double_out_1(9) or TEMP_36_double_out_1(25);
	entry_port_transfer_10(1) <= TEMP_36_double_out_1(10) or TEMP_36_double_out_1(26);
	entry_port_transfer_11(1) <= TEMP_36_double_out_1(11) or TEMP_36_double_out_1(27);
	entry_port_transfer_12(1) <= TEMP_36_double_out_1(12) or TEMP_36_double_out_1(28);
	entry_port_transfer_13(1) <= TEMP_36_double_out_1(13) or TEMP_36_double_out_1(29);
	entry_port_transfer_14(1) <= TEMP_36_double_out_1(14) or TEMP_36_double_out_1(30);
	entry_port_transfer_15(1) <= TEMP_36_double_out_1(15) or TEMP_36_double_out_1(31);
	TEMP_36_double_in_2(0) <= entry_port_options_0(2);
	TEMP_36_double_in_2(16) <= entry_port_options_0(2);
	TEMP_36_double_in_2(1) <= entry_port_options_1(2);
	TEMP_36_double_in_2(17) <= entry_port_options_1(2);
	TEMP_36_double_in_2(2) <= entry_port_options_2(2);
	TEMP_36_double_in_2(18) <= entry_port_options_2(2);
	TEMP_36_double_in_2(3) <= entry_port_options_3(2);
	TEMP_36_double_in_2(19) <= entry_port_options_3(2);
	TEMP_36_double_in_2(4) <= entry_port_options_4(2);
	TEMP_36_double_in_2(20) <= entry_port_options_4(2);
	TEMP_36_double_in_2(5) <= entry_port_options_5(2);
	TEMP_36_double_in_2(21) <= entry_port_options_5(2);
	TEMP_36_double_in_2(6) <= entry_port_options_6(2);
	TEMP_36_double_in_2(22) <= entry_port_options_6(2);
	TEMP_36_double_in_2(7) <= entry_port_options_7(2);
	TEMP_36_double_in_2(23) <= entry_port_options_7(2);
	TEMP_36_double_in_2(8) <= entry_port_options_8(2);
	TEMP_36_double_in_2(24) <= entry_port_options_8(2);
	TEMP_36_double_in_2(9) <= entry_port_options_9(2);
	TEMP_36_double_in_2(25) <= entry_port_options_9(2);
	TEMP_36_double_in_2(10) <= entry_port_options_10(2);
	TEMP_36_double_in_2(26) <= entry_port_options_10(2);
	TEMP_36_double_in_2(11) <= entry_port_options_11(2);
	TEMP_36_double_in_2(27) <= entry_port_options_11(2);
	TEMP_36_double_in_2(12) <= entry_port_options_12(2);
	TEMP_36_double_in_2(28) <= entry_port_options_12(2);
	TEMP_36_double_in_2(13) <= entry_port_options_13(2);
	TEMP_36_double_in_2(29) <= entry_port_options_13(2);
	TEMP_36_double_in_2(14) <= entry_port_options_14(2);
	TEMP_36_double_in_2(30) <= entry_port_options_14(2);
	TEMP_36_double_in_2(15) <= entry_port_options_15(2);
	TEMP_36_double_in_2(31) <= entry_port_options_15(2);
	TEMP_36_double_out_2 <= TEMP_36_double_in_2 and not std_logic_vector( unsigned( TEMP_36_double_in_2 ) - unsigned( "0000000000000000" & queue_head_oh_i ) );
	entry_port_transfer_0(2) <= TEMP_36_double_out_2(0) or TEMP_36_double_out_2(16);
	entry_port_transfer_1(2) <= TEMP_36_double_out_2(1) or TEMP_36_double_out_2(17);
	entry_port_transfer_2(2) <= TEMP_36_double_out_2(2) or TEMP_36_double_out_2(18);
	entry_port_transfer_3(2) <= TEMP_36_double_out_2(3) or TEMP_36_double_out_2(19);
	entry_port_transfer_4(2) <= TEMP_36_double_out_2(4) or TEMP_36_double_out_2(20);
	entry_port_transfer_5(2) <= TEMP_36_double_out_2(5) or TEMP_36_double_out_2(21);
	entry_port_transfer_6(2) <= TEMP_36_double_out_2(6) or TEMP_36_double_out_2(22);
	entry_port_transfer_7(2) <= TEMP_36_double_out_2(7) or TEMP_36_double_out_2(23);
	entry_port_transfer_8(2) <= TEMP_36_double_out_2(8) or TEMP_36_double_out_2(24);
	entry_port_transfer_9(2) <= TEMP_36_double_out_2(9) or TEMP_36_double_out_2(25);
	entry_port_transfer_10(2) <= TEMP_36_double_out_2(10) or TEMP_36_double_out_2(26);
	entry_port_transfer_11(2) <= TEMP_36_double_out_2(11) or TEMP_36_double_out_2(27);
	entry_port_transfer_12(2) <= TEMP_36_double_out_2(12) or TEMP_36_double_out_2(28);
	entry_port_transfer_13(2) <= TEMP_36_double_out_2(13) or TEMP_36_double_out_2(29);
	entry_port_transfer_14(2) <= TEMP_36_double_out_2(14) or TEMP_36_double_out_2(30);
	entry_port_transfer_15(2) <= TEMP_36_double_out_2(15) or TEMP_36_double_out_2(31);
	-- Priority Masking End

	-- Reduction Begin
	-- Reduce(entry_wen_0, entry_port_transfer_0, or)
	TEMP_37_res(0) <= entry_port_transfer_0(0) or entry_port_transfer_0(2);
	TEMP_37_res(1) <= entry_port_transfer_0(1);
	-- Layer End
	entry_wen_0_o <= TEMP_37_res(0) or TEMP_37_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_1, entry_port_transfer_1, or)
	TEMP_38_res(0) <= entry_port_transfer_1(0) or entry_port_transfer_1(2);
	TEMP_38_res(1) <= entry_port_transfer_1(1);
	-- Layer End
	entry_wen_1_o <= TEMP_38_res(0) or TEMP_38_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_2, entry_port_transfer_2, or)
	TEMP_39_res(0) <= entry_port_transfer_2(0) or entry_port_transfer_2(2);
	TEMP_39_res(1) <= entry_port_transfer_2(1);
	-- Layer End
	entry_wen_2_o <= TEMP_39_res(0) or TEMP_39_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_3, entry_port_transfer_3, or)
	TEMP_40_res(0) <= entry_port_transfer_3(0) or entry_port_transfer_3(2);
	TEMP_40_res(1) <= entry_port_transfer_3(1);
	-- Layer End
	entry_wen_3_o <= TEMP_40_res(0) or TEMP_40_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_4, entry_port_transfer_4, or)
	TEMP_41_res(0) <= entry_port_transfer_4(0) or entry_port_transfer_4(2);
	TEMP_41_res(1) <= entry_port_transfer_4(1);
	-- Layer End
	entry_wen_4_o <= TEMP_41_res(0) or TEMP_41_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_5, entry_port_transfer_5, or)
	TEMP_42_res(0) <= entry_port_transfer_5(0) or entry_port_transfer_5(2);
	TEMP_42_res(1) <= entry_port_transfer_5(1);
	-- Layer End
	entry_wen_5_o <= TEMP_42_res(0) or TEMP_42_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_6, entry_port_transfer_6, or)
	TEMP_43_res(0) <= entry_port_transfer_6(0) or entry_port_transfer_6(2);
	TEMP_43_res(1) <= entry_port_transfer_6(1);
	-- Layer End
	entry_wen_6_o <= TEMP_43_res(0) or TEMP_43_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_7, entry_port_transfer_7, or)
	TEMP_44_res(0) <= entry_port_transfer_7(0) or entry_port_transfer_7(2);
	TEMP_44_res(1) <= entry_port_transfer_7(1);
	-- Layer End
	entry_wen_7_o <= TEMP_44_res(0) or TEMP_44_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_8, entry_port_transfer_8, or)
	TEMP_45_res(0) <= entry_port_transfer_8(0) or entry_port_transfer_8(2);
	TEMP_45_res(1) <= entry_port_transfer_8(1);
	-- Layer End
	entry_wen_8_o <= TEMP_45_res(0) or TEMP_45_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_9, entry_port_transfer_9, or)
	TEMP_46_res(0) <= entry_port_transfer_9(0) or entry_port_transfer_9(2);
	TEMP_46_res(1) <= entry_port_transfer_9(1);
	-- Layer End
	entry_wen_9_o <= TEMP_46_res(0) or TEMP_46_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_10, entry_port_transfer_10, or)
	TEMP_47_res(0) <= entry_port_transfer_10(0) or entry_port_transfer_10(2);
	TEMP_47_res(1) <= entry_port_transfer_10(1);
	-- Layer End
	entry_wen_10_o <= TEMP_47_res(0) or TEMP_47_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_11, entry_port_transfer_11, or)
	TEMP_48_res(0) <= entry_port_transfer_11(0) or entry_port_transfer_11(2);
	TEMP_48_res(1) <= entry_port_transfer_11(1);
	-- Layer End
	entry_wen_11_o <= TEMP_48_res(0) or TEMP_48_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_12, entry_port_transfer_12, or)
	TEMP_49_res(0) <= entry_port_transfer_12(0) or entry_port_transfer_12(2);
	TEMP_49_res(1) <= entry_port_transfer_12(1);
	-- Layer End
	entry_wen_12_o <= TEMP_49_res(0) or TEMP_49_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_13, entry_port_transfer_13, or)
	TEMP_50_res(0) <= entry_port_transfer_13(0) or entry_port_transfer_13(2);
	TEMP_50_res(1) <= entry_port_transfer_13(1);
	-- Layer End
	entry_wen_13_o <= TEMP_50_res(0) or TEMP_50_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_14, entry_port_transfer_14, or)
	TEMP_51_res(0) <= entry_port_transfer_14(0) or entry_port_transfer_14(2);
	TEMP_51_res(1) <= entry_port_transfer_14(1);
	-- Layer End
	entry_wen_14_o <= TEMP_51_res(0) or TEMP_51_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_wen_15, entry_port_transfer_15, or)
	TEMP_52_res(0) <= entry_port_transfer_15(0) or entry_port_transfer_15(2);
	TEMP_52_res(1) <= entry_port_transfer_15(1);
	-- Layer End
	entry_wen_15_o <= TEMP_52_res(0) or TEMP_52_res(1);
	-- Reduction End


end architecture;
