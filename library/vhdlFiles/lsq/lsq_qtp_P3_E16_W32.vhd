

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lsq_qtp_P3_E16_W32 is
	port(
		rst : in std_logic;
		clk : in std_logic;
		port_payload_0_o : out std_logic_vector(31 downto 0);
		port_payload_1_o : out std_logic_vector(31 downto 0);
		port_payload_2_o : out std_logic_vector(31 downto 0);
		port_valid_0_o : out std_logic;
		port_valid_1_o : out std_logic;
		port_valid_2_o : out std_logic;
		port_ready_0_i : in std_logic;
		port_ready_1_i : in std_logic;
		port_ready_2_i : in std_logic;
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
		entry_payload_0_i : in std_logic_vector(31 downto 0);
		entry_payload_1_i : in std_logic_vector(31 downto 0);
		entry_payload_2_i : in std_logic_vector(31 downto 0);
		entry_payload_3_i : in std_logic_vector(31 downto 0);
		entry_payload_4_i : in std_logic_vector(31 downto 0);
		entry_payload_5_i : in std_logic_vector(31 downto 0);
		entry_payload_6_i : in std_logic_vector(31 downto 0);
		entry_payload_7_i : in std_logic_vector(31 downto 0);
		entry_payload_8_i : in std_logic_vector(31 downto 0);
		entry_payload_9_i : in std_logic_vector(31 downto 0);
		entry_payload_10_i : in std_logic_vector(31 downto 0);
		entry_payload_11_i : in std_logic_vector(31 downto 0);
		entry_payload_12_i : in std_logic_vector(31 downto 0);
		entry_payload_13_i : in std_logic_vector(31 downto 0);
		entry_payload_14_i : in std_logic_vector(31 downto 0);
		entry_payload_15_i : in std_logic_vector(31 downto 0);
		entry_reset_0_o : out std_logic;
		entry_reset_1_o : out std_logic;
		entry_reset_2_o : out std_logic;
		entry_reset_3_o : out std_logic;
		entry_reset_4_o : out std_logic;
		entry_reset_5_o : out std_logic;
		entry_reset_6_o : out std_logic;
		entry_reset_7_o : out std_logic;
		entry_reset_8_o : out std_logic;
		entry_reset_9_o : out std_logic;
		entry_reset_10_o : out std_logic;
		entry_reset_11_o : out std_logic;
		entry_reset_12_o : out std_logic;
		entry_reset_13_o : out std_logic;
		entry_reset_14_o : out std_logic;
		entry_reset_15_o : out std_logic;
		queue_head_oh_i : in std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of lsq_qtp_P3_E16_W32 is
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
	signal entry_allocated_for_port_0 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_1 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_2 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_3 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_4 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_5 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_6 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_7 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_8 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_9 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_10 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_11 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_12 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_13 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_14 : std_logic_vector(2 downto 0);
	signal entry_allocated_for_port_15 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_0 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_1 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_2 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_3 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_4 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_5 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_6 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_7 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_8 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_9 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_10 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_11 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_12 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_13 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_14 : std_logic_vector(2 downto 0);
	signal oldest_entry_allocated_per_port_15 : std_logic_vector(2 downto 0);
	signal TEMP_1_double_in_0 : std_logic_vector(31 downto 0);
	signal TEMP_1_double_out_0 : std_logic_vector(31 downto 0);
	signal TEMP_1_double_in_1 : std_logic_vector(31 downto 0);
	signal TEMP_1_double_out_1 : std_logic_vector(31 downto 0);
	signal TEMP_1_double_in_2 : std_logic_vector(31 downto 0);
	signal TEMP_1_double_out_2 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_3 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_4 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_5 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_6 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_7 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_8 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_9 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_10 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_11 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_12 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_13 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_14 : std_logic_vector(31 downto 0);
	signal TEMP_2_mux_15 : std_logic_vector(31 downto 0);
	signal TEMP_3_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_3_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_3_res_2 : std_logic_vector(31 downto 0);
	signal TEMP_3_res_3 : std_logic_vector(31 downto 0);
	signal TEMP_3_res_4 : std_logic_vector(31 downto 0);
	signal TEMP_3_res_5 : std_logic_vector(31 downto 0);
	signal TEMP_3_res_6 : std_logic_vector(31 downto 0);
	signal TEMP_3_res_7 : std_logic_vector(31 downto 0);
	signal TEMP_4_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_4_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_4_res_2 : std_logic_vector(31 downto 0);
	signal TEMP_4_res_3 : std_logic_vector(31 downto 0);
	signal TEMP_5_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_5_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_3 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_4 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_5 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_6 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_7 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_8 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_9 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_10 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_11 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_12 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_13 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_14 : std_logic_vector(31 downto 0);
	signal TEMP_6_mux_15 : std_logic_vector(31 downto 0);
	signal TEMP_7_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_7_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_7_res_2 : std_logic_vector(31 downto 0);
	signal TEMP_7_res_3 : std_logic_vector(31 downto 0);
	signal TEMP_7_res_4 : std_logic_vector(31 downto 0);
	signal TEMP_7_res_5 : std_logic_vector(31 downto 0);
	signal TEMP_7_res_6 : std_logic_vector(31 downto 0);
	signal TEMP_7_res_7 : std_logic_vector(31 downto 0);
	signal TEMP_8_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_8_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_8_res_2 : std_logic_vector(31 downto 0);
	signal TEMP_8_res_3 : std_logic_vector(31 downto 0);
	signal TEMP_9_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_9_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_0 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_1 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_2 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_3 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_4 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_5 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_6 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_7 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_8 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_9 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_10 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_11 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_12 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_13 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_14 : std_logic_vector(31 downto 0);
	signal TEMP_10_mux_15 : std_logic_vector(31 downto 0);
	signal TEMP_11_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_11_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_11_res_2 : std_logic_vector(31 downto 0);
	signal TEMP_11_res_3 : std_logic_vector(31 downto 0);
	signal TEMP_11_res_4 : std_logic_vector(31 downto 0);
	signal TEMP_11_res_5 : std_logic_vector(31 downto 0);
	signal TEMP_11_res_6 : std_logic_vector(31 downto 0);
	signal TEMP_11_res_7 : std_logic_vector(31 downto 0);
	signal TEMP_12_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_12_res_1 : std_logic_vector(31 downto 0);
	signal TEMP_12_res_2 : std_logic_vector(31 downto 0);
	signal TEMP_12_res_3 : std_logic_vector(31 downto 0);
	signal TEMP_13_res_0 : std_logic_vector(31 downto 0);
	signal TEMP_13_res_1 : std_logic_vector(31 downto 0);
	signal entry_waiting_for_port_valid_0 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_1 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_2 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_3 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_4 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_5 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_6 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_7 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_8 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_9 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_10 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_11 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_12 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_13 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_14 : std_logic_vector(2 downto 0);
	signal entry_waiting_for_port_valid_15 : std_logic_vector(2 downto 0);
	signal port_valid_vec : std_logic_vector(2 downto 0);
	signal TEMP_14_res_0 : std_logic_vector(2 downto 0);
	signal TEMP_14_res_1 : std_logic_vector(2 downto 0);
	signal TEMP_14_res_2 : std_logic_vector(2 downto 0);
	signal TEMP_14_res_3 : std_logic_vector(2 downto 0);
	signal TEMP_14_res_4 : std_logic_vector(2 downto 0);
	signal TEMP_14_res_5 : std_logic_vector(2 downto 0);
	signal TEMP_14_res_6 : std_logic_vector(2 downto 0);
	signal TEMP_14_res_7 : std_logic_vector(2 downto 0);
	signal TEMP_15_res_0 : std_logic_vector(2 downto 0);
	signal TEMP_15_res_1 : std_logic_vector(2 downto 0);
	signal TEMP_15_res_2 : std_logic_vector(2 downto 0);
	signal TEMP_15_res_3 : std_logic_vector(2 downto 0);
	signal TEMP_16_res_0 : std_logic_vector(2 downto 0);
	signal TEMP_16_res_1 : std_logic_vector(2 downto 0);
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
	signal TEMP_17_res : std_logic_vector(1 downto 0);
	signal TEMP_18_res : std_logic_vector(1 downto 0);
	signal TEMP_19_res : std_logic_vector(1 downto 0);
	signal TEMP_20_res : std_logic_vector(1 downto 0);
	signal TEMP_21_res : std_logic_vector(1 downto 0);
	signal TEMP_22_res : std_logic_vector(1 downto 0);
	signal TEMP_23_res : std_logic_vector(1 downto 0);
	signal TEMP_24_res : std_logic_vector(1 downto 0);
	signal TEMP_25_res : std_logic_vector(1 downto 0);
	signal TEMP_26_res : std_logic_vector(1 downto 0);
	signal TEMP_27_res : std_logic_vector(1 downto 0);
	signal TEMP_28_res : std_logic_vector(1 downto 0);
	signal TEMP_29_res : std_logic_vector(1 downto 0);
	signal TEMP_30_res : std_logic_vector(1 downto 0);
	signal TEMP_31_res : std_logic_vector(1 downto 0);
	signal TEMP_32_res : std_logic_vector(1 downto 0);
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

	entry_allocated_for_port_0 <= entry_port_idx_oh_0 when entry_alloc_0_i else "000";
	entry_allocated_for_port_1 <= entry_port_idx_oh_1 when entry_alloc_1_i else "000";
	entry_allocated_for_port_2 <= entry_port_idx_oh_2 when entry_alloc_2_i else "000";
	entry_allocated_for_port_3 <= entry_port_idx_oh_3 when entry_alloc_3_i else "000";
	entry_allocated_for_port_4 <= entry_port_idx_oh_4 when entry_alloc_4_i else "000";
	entry_allocated_for_port_5 <= entry_port_idx_oh_5 when entry_alloc_5_i else "000";
	entry_allocated_for_port_6 <= entry_port_idx_oh_6 when entry_alloc_6_i else "000";
	entry_allocated_for_port_7 <= entry_port_idx_oh_7 when entry_alloc_7_i else "000";
	entry_allocated_for_port_8 <= entry_port_idx_oh_8 when entry_alloc_8_i else "000";
	entry_allocated_for_port_9 <= entry_port_idx_oh_9 when entry_alloc_9_i else "000";
	entry_allocated_for_port_10 <= entry_port_idx_oh_10 when entry_alloc_10_i else "000";
	entry_allocated_for_port_11 <= entry_port_idx_oh_11 when entry_alloc_11_i else "000";
	entry_allocated_for_port_12 <= entry_port_idx_oh_12 when entry_alloc_12_i else "000";
	entry_allocated_for_port_13 <= entry_port_idx_oh_13 when entry_alloc_13_i else "000";
	entry_allocated_for_port_14 <= entry_port_idx_oh_14 when entry_alloc_14_i else "000";
	entry_allocated_for_port_15 <= entry_port_idx_oh_15 when entry_alloc_15_i else "000";
	-- Priority Masking Begin
	-- CyclicPriorityMask(oldest_entry_allocated_per_port, entry_allocated_for_port, queue_head_oh)
	TEMP_1_double_in_0(0) <= entry_allocated_for_port_0(0);
	TEMP_1_double_in_0(16) <= entry_allocated_for_port_0(0);
	TEMP_1_double_in_0(1) <= entry_allocated_for_port_1(0);
	TEMP_1_double_in_0(17) <= entry_allocated_for_port_1(0);
	TEMP_1_double_in_0(2) <= entry_allocated_for_port_2(0);
	TEMP_1_double_in_0(18) <= entry_allocated_for_port_2(0);
	TEMP_1_double_in_0(3) <= entry_allocated_for_port_3(0);
	TEMP_1_double_in_0(19) <= entry_allocated_for_port_3(0);
	TEMP_1_double_in_0(4) <= entry_allocated_for_port_4(0);
	TEMP_1_double_in_0(20) <= entry_allocated_for_port_4(0);
	TEMP_1_double_in_0(5) <= entry_allocated_for_port_5(0);
	TEMP_1_double_in_0(21) <= entry_allocated_for_port_5(0);
	TEMP_1_double_in_0(6) <= entry_allocated_for_port_6(0);
	TEMP_1_double_in_0(22) <= entry_allocated_for_port_6(0);
	TEMP_1_double_in_0(7) <= entry_allocated_for_port_7(0);
	TEMP_1_double_in_0(23) <= entry_allocated_for_port_7(0);
	TEMP_1_double_in_0(8) <= entry_allocated_for_port_8(0);
	TEMP_1_double_in_0(24) <= entry_allocated_for_port_8(0);
	TEMP_1_double_in_0(9) <= entry_allocated_for_port_9(0);
	TEMP_1_double_in_0(25) <= entry_allocated_for_port_9(0);
	TEMP_1_double_in_0(10) <= entry_allocated_for_port_10(0);
	TEMP_1_double_in_0(26) <= entry_allocated_for_port_10(0);
	TEMP_1_double_in_0(11) <= entry_allocated_for_port_11(0);
	TEMP_1_double_in_0(27) <= entry_allocated_for_port_11(0);
	TEMP_1_double_in_0(12) <= entry_allocated_for_port_12(0);
	TEMP_1_double_in_0(28) <= entry_allocated_for_port_12(0);
	TEMP_1_double_in_0(13) <= entry_allocated_for_port_13(0);
	TEMP_1_double_in_0(29) <= entry_allocated_for_port_13(0);
	TEMP_1_double_in_0(14) <= entry_allocated_for_port_14(0);
	TEMP_1_double_in_0(30) <= entry_allocated_for_port_14(0);
	TEMP_1_double_in_0(15) <= entry_allocated_for_port_15(0);
	TEMP_1_double_in_0(31) <= entry_allocated_for_port_15(0);
	TEMP_1_double_out_0 <= TEMP_1_double_in_0 and not std_logic_vector( unsigned( TEMP_1_double_in_0 ) - unsigned( "0000000000000000" & queue_head_oh_i ) );
	oldest_entry_allocated_per_port_0(0) <= TEMP_1_double_out_0(0) or TEMP_1_double_out_0(16);
	oldest_entry_allocated_per_port_1(0) <= TEMP_1_double_out_0(1) or TEMP_1_double_out_0(17);
	oldest_entry_allocated_per_port_2(0) <= TEMP_1_double_out_0(2) or TEMP_1_double_out_0(18);
	oldest_entry_allocated_per_port_3(0) <= TEMP_1_double_out_0(3) or TEMP_1_double_out_0(19);
	oldest_entry_allocated_per_port_4(0) <= TEMP_1_double_out_0(4) or TEMP_1_double_out_0(20);
	oldest_entry_allocated_per_port_5(0) <= TEMP_1_double_out_0(5) or TEMP_1_double_out_0(21);
	oldest_entry_allocated_per_port_6(0) <= TEMP_1_double_out_0(6) or TEMP_1_double_out_0(22);
	oldest_entry_allocated_per_port_7(0) <= TEMP_1_double_out_0(7) or TEMP_1_double_out_0(23);
	oldest_entry_allocated_per_port_8(0) <= TEMP_1_double_out_0(8) or TEMP_1_double_out_0(24);
	oldest_entry_allocated_per_port_9(0) <= TEMP_1_double_out_0(9) or TEMP_1_double_out_0(25);
	oldest_entry_allocated_per_port_10(0) <= TEMP_1_double_out_0(10) or TEMP_1_double_out_0(26);
	oldest_entry_allocated_per_port_11(0) <= TEMP_1_double_out_0(11) or TEMP_1_double_out_0(27);
	oldest_entry_allocated_per_port_12(0) <= TEMP_1_double_out_0(12) or TEMP_1_double_out_0(28);
	oldest_entry_allocated_per_port_13(0) <= TEMP_1_double_out_0(13) or TEMP_1_double_out_0(29);
	oldest_entry_allocated_per_port_14(0) <= TEMP_1_double_out_0(14) or TEMP_1_double_out_0(30);
	oldest_entry_allocated_per_port_15(0) <= TEMP_1_double_out_0(15) or TEMP_1_double_out_0(31);
	TEMP_1_double_in_1(0) <= entry_allocated_for_port_0(1);
	TEMP_1_double_in_1(16) <= entry_allocated_for_port_0(1);
	TEMP_1_double_in_1(1) <= entry_allocated_for_port_1(1);
	TEMP_1_double_in_1(17) <= entry_allocated_for_port_1(1);
	TEMP_1_double_in_1(2) <= entry_allocated_for_port_2(1);
	TEMP_1_double_in_1(18) <= entry_allocated_for_port_2(1);
	TEMP_1_double_in_1(3) <= entry_allocated_for_port_3(1);
	TEMP_1_double_in_1(19) <= entry_allocated_for_port_3(1);
	TEMP_1_double_in_1(4) <= entry_allocated_for_port_4(1);
	TEMP_1_double_in_1(20) <= entry_allocated_for_port_4(1);
	TEMP_1_double_in_1(5) <= entry_allocated_for_port_5(1);
	TEMP_1_double_in_1(21) <= entry_allocated_for_port_5(1);
	TEMP_1_double_in_1(6) <= entry_allocated_for_port_6(1);
	TEMP_1_double_in_1(22) <= entry_allocated_for_port_6(1);
	TEMP_1_double_in_1(7) <= entry_allocated_for_port_7(1);
	TEMP_1_double_in_1(23) <= entry_allocated_for_port_7(1);
	TEMP_1_double_in_1(8) <= entry_allocated_for_port_8(1);
	TEMP_1_double_in_1(24) <= entry_allocated_for_port_8(1);
	TEMP_1_double_in_1(9) <= entry_allocated_for_port_9(1);
	TEMP_1_double_in_1(25) <= entry_allocated_for_port_9(1);
	TEMP_1_double_in_1(10) <= entry_allocated_for_port_10(1);
	TEMP_1_double_in_1(26) <= entry_allocated_for_port_10(1);
	TEMP_1_double_in_1(11) <= entry_allocated_for_port_11(1);
	TEMP_1_double_in_1(27) <= entry_allocated_for_port_11(1);
	TEMP_1_double_in_1(12) <= entry_allocated_for_port_12(1);
	TEMP_1_double_in_1(28) <= entry_allocated_for_port_12(1);
	TEMP_1_double_in_1(13) <= entry_allocated_for_port_13(1);
	TEMP_1_double_in_1(29) <= entry_allocated_for_port_13(1);
	TEMP_1_double_in_1(14) <= entry_allocated_for_port_14(1);
	TEMP_1_double_in_1(30) <= entry_allocated_for_port_14(1);
	TEMP_1_double_in_1(15) <= entry_allocated_for_port_15(1);
	TEMP_1_double_in_1(31) <= entry_allocated_for_port_15(1);
	TEMP_1_double_out_1 <= TEMP_1_double_in_1 and not std_logic_vector( unsigned( TEMP_1_double_in_1 ) - unsigned( "0000000000000000" & queue_head_oh_i ) );
	oldest_entry_allocated_per_port_0(1) <= TEMP_1_double_out_1(0) or TEMP_1_double_out_1(16);
	oldest_entry_allocated_per_port_1(1) <= TEMP_1_double_out_1(1) or TEMP_1_double_out_1(17);
	oldest_entry_allocated_per_port_2(1) <= TEMP_1_double_out_1(2) or TEMP_1_double_out_1(18);
	oldest_entry_allocated_per_port_3(1) <= TEMP_1_double_out_1(3) or TEMP_1_double_out_1(19);
	oldest_entry_allocated_per_port_4(1) <= TEMP_1_double_out_1(4) or TEMP_1_double_out_1(20);
	oldest_entry_allocated_per_port_5(1) <= TEMP_1_double_out_1(5) or TEMP_1_double_out_1(21);
	oldest_entry_allocated_per_port_6(1) <= TEMP_1_double_out_1(6) or TEMP_1_double_out_1(22);
	oldest_entry_allocated_per_port_7(1) <= TEMP_1_double_out_1(7) or TEMP_1_double_out_1(23);
	oldest_entry_allocated_per_port_8(1) <= TEMP_1_double_out_1(8) or TEMP_1_double_out_1(24);
	oldest_entry_allocated_per_port_9(1) <= TEMP_1_double_out_1(9) or TEMP_1_double_out_1(25);
	oldest_entry_allocated_per_port_10(1) <= TEMP_1_double_out_1(10) or TEMP_1_double_out_1(26);
	oldest_entry_allocated_per_port_11(1) <= TEMP_1_double_out_1(11) or TEMP_1_double_out_1(27);
	oldest_entry_allocated_per_port_12(1) <= TEMP_1_double_out_1(12) or TEMP_1_double_out_1(28);
	oldest_entry_allocated_per_port_13(1) <= TEMP_1_double_out_1(13) or TEMP_1_double_out_1(29);
	oldest_entry_allocated_per_port_14(1) <= TEMP_1_double_out_1(14) or TEMP_1_double_out_1(30);
	oldest_entry_allocated_per_port_15(1) <= TEMP_1_double_out_1(15) or TEMP_1_double_out_1(31);
	TEMP_1_double_in_2(0) <= entry_allocated_for_port_0(2);
	TEMP_1_double_in_2(16) <= entry_allocated_for_port_0(2);
	TEMP_1_double_in_2(1) <= entry_allocated_for_port_1(2);
	TEMP_1_double_in_2(17) <= entry_allocated_for_port_1(2);
	TEMP_1_double_in_2(2) <= entry_allocated_for_port_2(2);
	TEMP_1_double_in_2(18) <= entry_allocated_for_port_2(2);
	TEMP_1_double_in_2(3) <= entry_allocated_for_port_3(2);
	TEMP_1_double_in_2(19) <= entry_allocated_for_port_3(2);
	TEMP_1_double_in_2(4) <= entry_allocated_for_port_4(2);
	TEMP_1_double_in_2(20) <= entry_allocated_for_port_4(2);
	TEMP_1_double_in_2(5) <= entry_allocated_for_port_5(2);
	TEMP_1_double_in_2(21) <= entry_allocated_for_port_5(2);
	TEMP_1_double_in_2(6) <= entry_allocated_for_port_6(2);
	TEMP_1_double_in_2(22) <= entry_allocated_for_port_6(2);
	TEMP_1_double_in_2(7) <= entry_allocated_for_port_7(2);
	TEMP_1_double_in_2(23) <= entry_allocated_for_port_7(2);
	TEMP_1_double_in_2(8) <= entry_allocated_for_port_8(2);
	TEMP_1_double_in_2(24) <= entry_allocated_for_port_8(2);
	TEMP_1_double_in_2(9) <= entry_allocated_for_port_9(2);
	TEMP_1_double_in_2(25) <= entry_allocated_for_port_9(2);
	TEMP_1_double_in_2(10) <= entry_allocated_for_port_10(2);
	TEMP_1_double_in_2(26) <= entry_allocated_for_port_10(2);
	TEMP_1_double_in_2(11) <= entry_allocated_for_port_11(2);
	TEMP_1_double_in_2(27) <= entry_allocated_for_port_11(2);
	TEMP_1_double_in_2(12) <= entry_allocated_for_port_12(2);
	TEMP_1_double_in_2(28) <= entry_allocated_for_port_12(2);
	TEMP_1_double_in_2(13) <= entry_allocated_for_port_13(2);
	TEMP_1_double_in_2(29) <= entry_allocated_for_port_13(2);
	TEMP_1_double_in_2(14) <= entry_allocated_for_port_14(2);
	TEMP_1_double_in_2(30) <= entry_allocated_for_port_14(2);
	TEMP_1_double_in_2(15) <= entry_allocated_for_port_15(2);
	TEMP_1_double_in_2(31) <= entry_allocated_for_port_15(2);
	TEMP_1_double_out_2 <= TEMP_1_double_in_2 and not std_logic_vector( unsigned( TEMP_1_double_in_2 ) - unsigned( "0000000000000000" & queue_head_oh_i ) );
	oldest_entry_allocated_per_port_0(2) <= TEMP_1_double_out_2(0) or TEMP_1_double_out_2(16);
	oldest_entry_allocated_per_port_1(2) <= TEMP_1_double_out_2(1) or TEMP_1_double_out_2(17);
	oldest_entry_allocated_per_port_2(2) <= TEMP_1_double_out_2(2) or TEMP_1_double_out_2(18);
	oldest_entry_allocated_per_port_3(2) <= TEMP_1_double_out_2(3) or TEMP_1_double_out_2(19);
	oldest_entry_allocated_per_port_4(2) <= TEMP_1_double_out_2(4) or TEMP_1_double_out_2(20);
	oldest_entry_allocated_per_port_5(2) <= TEMP_1_double_out_2(5) or TEMP_1_double_out_2(21);
	oldest_entry_allocated_per_port_6(2) <= TEMP_1_double_out_2(6) or TEMP_1_double_out_2(22);
	oldest_entry_allocated_per_port_7(2) <= TEMP_1_double_out_2(7) or TEMP_1_double_out_2(23);
	oldest_entry_allocated_per_port_8(2) <= TEMP_1_double_out_2(8) or TEMP_1_double_out_2(24);
	oldest_entry_allocated_per_port_9(2) <= TEMP_1_double_out_2(9) or TEMP_1_double_out_2(25);
	oldest_entry_allocated_per_port_10(2) <= TEMP_1_double_out_2(10) or TEMP_1_double_out_2(26);
	oldest_entry_allocated_per_port_11(2) <= TEMP_1_double_out_2(11) or TEMP_1_double_out_2(27);
	oldest_entry_allocated_per_port_12(2) <= TEMP_1_double_out_2(12) or TEMP_1_double_out_2(28);
	oldest_entry_allocated_per_port_13(2) <= TEMP_1_double_out_2(13) or TEMP_1_double_out_2(29);
	oldest_entry_allocated_per_port_14(2) <= TEMP_1_double_out_2(14) or TEMP_1_double_out_2(30);
	oldest_entry_allocated_per_port_15(2) <= TEMP_1_double_out_2(15) or TEMP_1_double_out_2(31);
	-- Priority Masking End

	-- Mux1H Begin
	-- Mux1H(port_payload_0, entry_payload, oldest_entry_allocated_per_port)
	TEMP_2_mux_0 <= entry_payload_0_i when oldest_entry_allocated_per_port_0(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_1 <= entry_payload_1_i when oldest_entry_allocated_per_port_1(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_2 <= entry_payload_2_i when oldest_entry_allocated_per_port_2(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_3 <= entry_payload_3_i when oldest_entry_allocated_per_port_3(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_4 <= entry_payload_4_i when oldest_entry_allocated_per_port_4(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_5 <= entry_payload_5_i when oldest_entry_allocated_per_port_5(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_6 <= entry_payload_6_i when oldest_entry_allocated_per_port_6(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_7 <= entry_payload_7_i when oldest_entry_allocated_per_port_7(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_8 <= entry_payload_8_i when oldest_entry_allocated_per_port_8(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_9 <= entry_payload_9_i when oldest_entry_allocated_per_port_9(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_10 <= entry_payload_10_i when oldest_entry_allocated_per_port_10(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_11 <= entry_payload_11_i when oldest_entry_allocated_per_port_11(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_12 <= entry_payload_12_i when oldest_entry_allocated_per_port_12(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_13 <= entry_payload_13_i when oldest_entry_allocated_per_port_13(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_14 <= entry_payload_14_i when oldest_entry_allocated_per_port_14(0) = '1' else "00000000000000000000000000000000";
	TEMP_2_mux_15 <= entry_payload_15_i when oldest_entry_allocated_per_port_15(0) = '1' else "00000000000000000000000000000000";
	TEMP_3_res_0 <= TEMP_2_mux_0 or TEMP_2_mux_8;
	TEMP_3_res_1 <= TEMP_2_mux_1 or TEMP_2_mux_9;
	TEMP_3_res_2 <= TEMP_2_mux_2 or TEMP_2_mux_10;
	TEMP_3_res_3 <= TEMP_2_mux_3 or TEMP_2_mux_11;
	TEMP_3_res_4 <= TEMP_2_mux_4 or TEMP_2_mux_12;
	TEMP_3_res_5 <= TEMP_2_mux_5 or TEMP_2_mux_13;
	TEMP_3_res_6 <= TEMP_2_mux_6 or TEMP_2_mux_14;
	TEMP_3_res_7 <= TEMP_2_mux_7 or TEMP_2_mux_15;
	-- Layer End
	TEMP_4_res_0 <= TEMP_3_res_0 or TEMP_3_res_4;
	TEMP_4_res_1 <= TEMP_3_res_1 or TEMP_3_res_5;
	TEMP_4_res_2 <= TEMP_3_res_2 or TEMP_3_res_6;
	TEMP_4_res_3 <= TEMP_3_res_3 or TEMP_3_res_7;
	-- Layer End
	TEMP_5_res_0 <= TEMP_4_res_0 or TEMP_4_res_2;
	TEMP_5_res_1 <= TEMP_4_res_1 or TEMP_4_res_3;
	-- Layer End
	port_payload_0_o <= TEMP_5_res_0 or TEMP_5_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(port_payload_1, entry_payload, oldest_entry_allocated_per_port)
	TEMP_6_mux_0 <= entry_payload_0_i when oldest_entry_allocated_per_port_0(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_1 <= entry_payload_1_i when oldest_entry_allocated_per_port_1(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_2 <= entry_payload_2_i when oldest_entry_allocated_per_port_2(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_3 <= entry_payload_3_i when oldest_entry_allocated_per_port_3(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_4 <= entry_payload_4_i when oldest_entry_allocated_per_port_4(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_5 <= entry_payload_5_i when oldest_entry_allocated_per_port_5(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_6 <= entry_payload_6_i when oldest_entry_allocated_per_port_6(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_7 <= entry_payload_7_i when oldest_entry_allocated_per_port_7(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_8 <= entry_payload_8_i when oldest_entry_allocated_per_port_8(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_9 <= entry_payload_9_i when oldest_entry_allocated_per_port_9(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_10 <= entry_payload_10_i when oldest_entry_allocated_per_port_10(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_11 <= entry_payload_11_i when oldest_entry_allocated_per_port_11(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_12 <= entry_payload_12_i when oldest_entry_allocated_per_port_12(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_13 <= entry_payload_13_i when oldest_entry_allocated_per_port_13(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_14 <= entry_payload_14_i when oldest_entry_allocated_per_port_14(1) = '1' else "00000000000000000000000000000000";
	TEMP_6_mux_15 <= entry_payload_15_i when oldest_entry_allocated_per_port_15(1) = '1' else "00000000000000000000000000000000";
	TEMP_7_res_0 <= TEMP_6_mux_0 or TEMP_6_mux_8;
	TEMP_7_res_1 <= TEMP_6_mux_1 or TEMP_6_mux_9;
	TEMP_7_res_2 <= TEMP_6_mux_2 or TEMP_6_mux_10;
	TEMP_7_res_3 <= TEMP_6_mux_3 or TEMP_6_mux_11;
	TEMP_7_res_4 <= TEMP_6_mux_4 or TEMP_6_mux_12;
	TEMP_7_res_5 <= TEMP_6_mux_5 or TEMP_6_mux_13;
	TEMP_7_res_6 <= TEMP_6_mux_6 or TEMP_6_mux_14;
	TEMP_7_res_7 <= TEMP_6_mux_7 or TEMP_6_mux_15;
	-- Layer End
	TEMP_8_res_0 <= TEMP_7_res_0 or TEMP_7_res_4;
	TEMP_8_res_1 <= TEMP_7_res_1 or TEMP_7_res_5;
	TEMP_8_res_2 <= TEMP_7_res_2 or TEMP_7_res_6;
	TEMP_8_res_3 <= TEMP_7_res_3 or TEMP_7_res_7;
	-- Layer End
	TEMP_9_res_0 <= TEMP_8_res_0 or TEMP_8_res_2;
	TEMP_9_res_1 <= TEMP_8_res_1 or TEMP_8_res_3;
	-- Layer End
	port_payload_1_o <= TEMP_9_res_0 or TEMP_9_res_1;
	-- Mux1H End

	-- Mux1H Begin
	-- Mux1H(port_payload_2, entry_payload, oldest_entry_allocated_per_port)
	TEMP_10_mux_0 <= entry_payload_0_i when oldest_entry_allocated_per_port_0(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_1 <= entry_payload_1_i when oldest_entry_allocated_per_port_1(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_2 <= entry_payload_2_i when oldest_entry_allocated_per_port_2(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_3 <= entry_payload_3_i when oldest_entry_allocated_per_port_3(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_4 <= entry_payload_4_i when oldest_entry_allocated_per_port_4(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_5 <= entry_payload_5_i when oldest_entry_allocated_per_port_5(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_6 <= entry_payload_6_i when oldest_entry_allocated_per_port_6(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_7 <= entry_payload_7_i when oldest_entry_allocated_per_port_7(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_8 <= entry_payload_8_i when oldest_entry_allocated_per_port_8(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_9 <= entry_payload_9_i when oldest_entry_allocated_per_port_9(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_10 <= entry_payload_10_i when oldest_entry_allocated_per_port_10(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_11 <= entry_payload_11_i when oldest_entry_allocated_per_port_11(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_12 <= entry_payload_12_i when oldest_entry_allocated_per_port_12(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_13 <= entry_payload_13_i when oldest_entry_allocated_per_port_13(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_14 <= entry_payload_14_i when oldest_entry_allocated_per_port_14(2) = '1' else "00000000000000000000000000000000";
	TEMP_10_mux_15 <= entry_payload_15_i when oldest_entry_allocated_per_port_15(2) = '1' else "00000000000000000000000000000000";
	TEMP_11_res_0 <= TEMP_10_mux_0 or TEMP_10_mux_8;
	TEMP_11_res_1 <= TEMP_10_mux_1 or TEMP_10_mux_9;
	TEMP_11_res_2 <= TEMP_10_mux_2 or TEMP_10_mux_10;
	TEMP_11_res_3 <= TEMP_10_mux_3 or TEMP_10_mux_11;
	TEMP_11_res_4 <= TEMP_10_mux_4 or TEMP_10_mux_12;
	TEMP_11_res_5 <= TEMP_10_mux_5 or TEMP_10_mux_13;
	TEMP_11_res_6 <= TEMP_10_mux_6 or TEMP_10_mux_14;
	TEMP_11_res_7 <= TEMP_10_mux_7 or TEMP_10_mux_15;
	-- Layer End
	TEMP_12_res_0 <= TEMP_11_res_0 or TEMP_11_res_4;
	TEMP_12_res_1 <= TEMP_11_res_1 or TEMP_11_res_5;
	TEMP_12_res_2 <= TEMP_11_res_2 or TEMP_11_res_6;
	TEMP_12_res_3 <= TEMP_11_res_3 or TEMP_11_res_7;
	-- Layer End
	TEMP_13_res_0 <= TEMP_12_res_0 or TEMP_12_res_2;
	TEMP_13_res_1 <= TEMP_12_res_1 or TEMP_12_res_3;
	-- Layer End
	port_payload_2_o <= TEMP_13_res_0 or TEMP_13_res_1;
	-- Mux1H End

	entry_waiting_for_port_valid_0 <= oldest_entry_allocated_per_port_0 when entry_payload_valid_0_i else "000";
	entry_waiting_for_port_valid_1 <= oldest_entry_allocated_per_port_1 when entry_payload_valid_1_i else "000";
	entry_waiting_for_port_valid_2 <= oldest_entry_allocated_per_port_2 when entry_payload_valid_2_i else "000";
	entry_waiting_for_port_valid_3 <= oldest_entry_allocated_per_port_3 when entry_payload_valid_3_i else "000";
	entry_waiting_for_port_valid_4 <= oldest_entry_allocated_per_port_4 when entry_payload_valid_4_i else "000";
	entry_waiting_for_port_valid_5 <= oldest_entry_allocated_per_port_5 when entry_payload_valid_5_i else "000";
	entry_waiting_for_port_valid_6 <= oldest_entry_allocated_per_port_6 when entry_payload_valid_6_i else "000";
	entry_waiting_for_port_valid_7 <= oldest_entry_allocated_per_port_7 when entry_payload_valid_7_i else "000";
	entry_waiting_for_port_valid_8 <= oldest_entry_allocated_per_port_8 when entry_payload_valid_8_i else "000";
	entry_waiting_for_port_valid_9 <= oldest_entry_allocated_per_port_9 when entry_payload_valid_9_i else "000";
	entry_waiting_for_port_valid_10 <= oldest_entry_allocated_per_port_10 when entry_payload_valid_10_i else "000";
	entry_waiting_for_port_valid_11 <= oldest_entry_allocated_per_port_11 when entry_payload_valid_11_i else "000";
	entry_waiting_for_port_valid_12 <= oldest_entry_allocated_per_port_12 when entry_payload_valid_12_i else "000";
	entry_waiting_for_port_valid_13 <= oldest_entry_allocated_per_port_13 when entry_payload_valid_13_i else "000";
	entry_waiting_for_port_valid_14 <= oldest_entry_allocated_per_port_14 when entry_payload_valid_14_i else "000";
	entry_waiting_for_port_valid_15 <= oldest_entry_allocated_per_port_15 when entry_payload_valid_15_i else "000";
	-- Reduction Begin
	-- Reduce(port_valid_vec, entry_waiting_for_port_valid, or)
	TEMP_14_res_0 <= entry_waiting_for_port_valid_0 or entry_waiting_for_port_valid_8;
	TEMP_14_res_1 <= entry_waiting_for_port_valid_1 or entry_waiting_for_port_valid_9;
	TEMP_14_res_2 <= entry_waiting_for_port_valid_2 or entry_waiting_for_port_valid_10;
	TEMP_14_res_3 <= entry_waiting_for_port_valid_3 or entry_waiting_for_port_valid_11;
	TEMP_14_res_4 <= entry_waiting_for_port_valid_4 or entry_waiting_for_port_valid_12;
	TEMP_14_res_5 <= entry_waiting_for_port_valid_5 or entry_waiting_for_port_valid_13;
	TEMP_14_res_6 <= entry_waiting_for_port_valid_6 or entry_waiting_for_port_valid_14;
	TEMP_14_res_7 <= entry_waiting_for_port_valid_7 or entry_waiting_for_port_valid_15;
	-- Layer End
	TEMP_15_res_0 <= TEMP_14_res_0 or TEMP_14_res_4;
	TEMP_15_res_1 <= TEMP_14_res_1 or TEMP_14_res_5;
	TEMP_15_res_2 <= TEMP_14_res_2 or TEMP_14_res_6;
	TEMP_15_res_3 <= TEMP_14_res_3 or TEMP_14_res_7;
	-- Layer End
	TEMP_16_res_0 <= TEMP_15_res_0 or TEMP_15_res_2;
	TEMP_16_res_1 <= TEMP_15_res_1 or TEMP_15_res_3;
	-- Layer End
	port_valid_vec <= TEMP_16_res_0 or TEMP_16_res_1;
	-- Reduction End

	port_valid_0_o <= port_valid_vec(0);
	port_valid_1_o <= port_valid_vec(1);
	port_valid_2_o <= port_valid_vec(2);
	entry_port_transfer_0(0) <= entry_waiting_for_port_valid_0(0) and port_ready_0_i;
	entry_port_transfer_0(1) <= entry_waiting_for_port_valid_0(1) and port_ready_1_i;
	entry_port_transfer_0(2) <= entry_waiting_for_port_valid_0(2) and port_ready_2_i;
	entry_port_transfer_1(0) <= entry_waiting_for_port_valid_1(0) and port_ready_0_i;
	entry_port_transfer_1(1) <= entry_waiting_for_port_valid_1(1) and port_ready_1_i;
	entry_port_transfer_1(2) <= entry_waiting_for_port_valid_1(2) and port_ready_2_i;
	entry_port_transfer_2(0) <= entry_waiting_for_port_valid_2(0) and port_ready_0_i;
	entry_port_transfer_2(1) <= entry_waiting_for_port_valid_2(1) and port_ready_1_i;
	entry_port_transfer_2(2) <= entry_waiting_for_port_valid_2(2) and port_ready_2_i;
	entry_port_transfer_3(0) <= entry_waiting_for_port_valid_3(0) and port_ready_0_i;
	entry_port_transfer_3(1) <= entry_waiting_for_port_valid_3(1) and port_ready_1_i;
	entry_port_transfer_3(2) <= entry_waiting_for_port_valid_3(2) and port_ready_2_i;
	entry_port_transfer_4(0) <= entry_waiting_for_port_valid_4(0) and port_ready_0_i;
	entry_port_transfer_4(1) <= entry_waiting_for_port_valid_4(1) and port_ready_1_i;
	entry_port_transfer_4(2) <= entry_waiting_for_port_valid_4(2) and port_ready_2_i;
	entry_port_transfer_5(0) <= entry_waiting_for_port_valid_5(0) and port_ready_0_i;
	entry_port_transfer_5(1) <= entry_waiting_for_port_valid_5(1) and port_ready_1_i;
	entry_port_transfer_5(2) <= entry_waiting_for_port_valid_5(2) and port_ready_2_i;
	entry_port_transfer_6(0) <= entry_waiting_for_port_valid_6(0) and port_ready_0_i;
	entry_port_transfer_6(1) <= entry_waiting_for_port_valid_6(1) and port_ready_1_i;
	entry_port_transfer_6(2) <= entry_waiting_for_port_valid_6(2) and port_ready_2_i;
	entry_port_transfer_7(0) <= entry_waiting_for_port_valid_7(0) and port_ready_0_i;
	entry_port_transfer_7(1) <= entry_waiting_for_port_valid_7(1) and port_ready_1_i;
	entry_port_transfer_7(2) <= entry_waiting_for_port_valid_7(2) and port_ready_2_i;
	entry_port_transfer_8(0) <= entry_waiting_for_port_valid_8(0) and port_ready_0_i;
	entry_port_transfer_8(1) <= entry_waiting_for_port_valid_8(1) and port_ready_1_i;
	entry_port_transfer_8(2) <= entry_waiting_for_port_valid_8(2) and port_ready_2_i;
	entry_port_transfer_9(0) <= entry_waiting_for_port_valid_9(0) and port_ready_0_i;
	entry_port_transfer_9(1) <= entry_waiting_for_port_valid_9(1) and port_ready_1_i;
	entry_port_transfer_9(2) <= entry_waiting_for_port_valid_9(2) and port_ready_2_i;
	entry_port_transfer_10(0) <= entry_waiting_for_port_valid_10(0) and port_ready_0_i;
	entry_port_transfer_10(1) <= entry_waiting_for_port_valid_10(1) and port_ready_1_i;
	entry_port_transfer_10(2) <= entry_waiting_for_port_valid_10(2) and port_ready_2_i;
	entry_port_transfer_11(0) <= entry_waiting_for_port_valid_11(0) and port_ready_0_i;
	entry_port_transfer_11(1) <= entry_waiting_for_port_valid_11(1) and port_ready_1_i;
	entry_port_transfer_11(2) <= entry_waiting_for_port_valid_11(2) and port_ready_2_i;
	entry_port_transfer_12(0) <= entry_waiting_for_port_valid_12(0) and port_ready_0_i;
	entry_port_transfer_12(1) <= entry_waiting_for_port_valid_12(1) and port_ready_1_i;
	entry_port_transfer_12(2) <= entry_waiting_for_port_valid_12(2) and port_ready_2_i;
	entry_port_transfer_13(0) <= entry_waiting_for_port_valid_13(0) and port_ready_0_i;
	entry_port_transfer_13(1) <= entry_waiting_for_port_valid_13(1) and port_ready_1_i;
	entry_port_transfer_13(2) <= entry_waiting_for_port_valid_13(2) and port_ready_2_i;
	entry_port_transfer_14(0) <= entry_waiting_for_port_valid_14(0) and port_ready_0_i;
	entry_port_transfer_14(1) <= entry_waiting_for_port_valid_14(1) and port_ready_1_i;
	entry_port_transfer_14(2) <= entry_waiting_for_port_valid_14(2) and port_ready_2_i;
	entry_port_transfer_15(0) <= entry_waiting_for_port_valid_15(0) and port_ready_0_i;
	entry_port_transfer_15(1) <= entry_waiting_for_port_valid_15(1) and port_ready_1_i;
	entry_port_transfer_15(2) <= entry_waiting_for_port_valid_15(2) and port_ready_2_i;
	-- Reduction Begin
	-- Reduce(entry_reset_0, entry_port_transfer_0, or)
	TEMP_17_res(0) <= entry_port_transfer_0(0) or entry_port_transfer_0(2);
	TEMP_17_res(1) <= entry_port_transfer_0(1);
	-- Layer End
	entry_reset_0_o <= TEMP_17_res(0) or TEMP_17_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_1, entry_port_transfer_1, or)
	TEMP_18_res(0) <= entry_port_transfer_1(0) or entry_port_transfer_1(2);
	TEMP_18_res(1) <= entry_port_transfer_1(1);
	-- Layer End
	entry_reset_1_o <= TEMP_18_res(0) or TEMP_18_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_2, entry_port_transfer_2, or)
	TEMP_19_res(0) <= entry_port_transfer_2(0) or entry_port_transfer_2(2);
	TEMP_19_res(1) <= entry_port_transfer_2(1);
	-- Layer End
	entry_reset_2_o <= TEMP_19_res(0) or TEMP_19_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_3, entry_port_transfer_3, or)
	TEMP_20_res(0) <= entry_port_transfer_3(0) or entry_port_transfer_3(2);
	TEMP_20_res(1) <= entry_port_transfer_3(1);
	-- Layer End
	entry_reset_3_o <= TEMP_20_res(0) or TEMP_20_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_4, entry_port_transfer_4, or)
	TEMP_21_res(0) <= entry_port_transfer_4(0) or entry_port_transfer_4(2);
	TEMP_21_res(1) <= entry_port_transfer_4(1);
	-- Layer End
	entry_reset_4_o <= TEMP_21_res(0) or TEMP_21_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_5, entry_port_transfer_5, or)
	TEMP_22_res(0) <= entry_port_transfer_5(0) or entry_port_transfer_5(2);
	TEMP_22_res(1) <= entry_port_transfer_5(1);
	-- Layer End
	entry_reset_5_o <= TEMP_22_res(0) or TEMP_22_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_6, entry_port_transfer_6, or)
	TEMP_23_res(0) <= entry_port_transfer_6(0) or entry_port_transfer_6(2);
	TEMP_23_res(1) <= entry_port_transfer_6(1);
	-- Layer End
	entry_reset_6_o <= TEMP_23_res(0) or TEMP_23_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_7, entry_port_transfer_7, or)
	TEMP_24_res(0) <= entry_port_transfer_7(0) or entry_port_transfer_7(2);
	TEMP_24_res(1) <= entry_port_transfer_7(1);
	-- Layer End
	entry_reset_7_o <= TEMP_24_res(0) or TEMP_24_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_8, entry_port_transfer_8, or)
	TEMP_25_res(0) <= entry_port_transfer_8(0) or entry_port_transfer_8(2);
	TEMP_25_res(1) <= entry_port_transfer_8(1);
	-- Layer End
	entry_reset_8_o <= TEMP_25_res(0) or TEMP_25_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_9, entry_port_transfer_9, or)
	TEMP_26_res(0) <= entry_port_transfer_9(0) or entry_port_transfer_9(2);
	TEMP_26_res(1) <= entry_port_transfer_9(1);
	-- Layer End
	entry_reset_9_o <= TEMP_26_res(0) or TEMP_26_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_10, entry_port_transfer_10, or)
	TEMP_27_res(0) <= entry_port_transfer_10(0) or entry_port_transfer_10(2);
	TEMP_27_res(1) <= entry_port_transfer_10(1);
	-- Layer End
	entry_reset_10_o <= TEMP_27_res(0) or TEMP_27_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_11, entry_port_transfer_11, or)
	TEMP_28_res(0) <= entry_port_transfer_11(0) or entry_port_transfer_11(2);
	TEMP_28_res(1) <= entry_port_transfer_11(1);
	-- Layer End
	entry_reset_11_o <= TEMP_28_res(0) or TEMP_28_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_12, entry_port_transfer_12, or)
	TEMP_29_res(0) <= entry_port_transfer_12(0) or entry_port_transfer_12(2);
	TEMP_29_res(1) <= entry_port_transfer_12(1);
	-- Layer End
	entry_reset_12_o <= TEMP_29_res(0) or TEMP_29_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_13, entry_port_transfer_13, or)
	TEMP_30_res(0) <= entry_port_transfer_13(0) or entry_port_transfer_13(2);
	TEMP_30_res(1) <= entry_port_transfer_13(1);
	-- Layer End
	entry_reset_13_o <= TEMP_30_res(0) or TEMP_30_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_14, entry_port_transfer_14, or)
	TEMP_31_res(0) <= entry_port_transfer_14(0) or entry_port_transfer_14(2);
	TEMP_31_res(1) <= entry_port_transfer_14(1);
	-- Layer End
	entry_reset_14_o <= TEMP_31_res(0) or TEMP_31_res(1);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_15, entry_port_transfer_15, or)
	TEMP_32_res(0) <= entry_port_transfer_15(0) or entry_port_transfer_15(2);
	TEMP_32_res(1) <= entry_port_transfer_15(1);
	-- Layer End
	entry_reset_15_o <= TEMP_32_res(0) or TEMP_32_res(1);
	-- Reduction End


end architecture;
