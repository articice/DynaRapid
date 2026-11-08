

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lsq_qtp_P1_E16_W32 is
	port(
		rst : in std_logic;
		clk : in std_logic;
		port_payload_0_o : out std_logic_vector(31 downto 0);
		port_valid_0_o : out std_logic;
		port_ready_0_i : in std_logic;
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

architecture arch of lsq_qtp_P1_E16_W32 is
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
	signal entry_allocated_for_port_0 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_1 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_2 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_3 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_4 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_5 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_6 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_7 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_8 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_9 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_10 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_11 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_12 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_13 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_14 : std_logic_vector(0 downto 0);
	signal entry_allocated_for_port_15 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_0 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_1 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_2 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_3 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_4 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_5 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_6 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_7 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_8 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_9 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_10 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_11 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_12 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_13 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_14 : std_logic_vector(0 downto 0);
	signal oldest_entry_allocated_per_port_15 : std_logic_vector(0 downto 0);
	signal TEMP_1_double_in_0 : std_logic_vector(31 downto 0);
	signal TEMP_1_double_out_0 : std_logic_vector(31 downto 0);
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
	signal entry_waiting_for_port_valid_0 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_1 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_2 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_3 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_4 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_5 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_6 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_7 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_8 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_9 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_10 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_11 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_12 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_13 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_14 : std_logic_vector(0 downto 0);
	signal entry_waiting_for_port_valid_15 : std_logic_vector(0 downto 0);
	signal port_valid_vec : std_logic_vector(0 downto 0);
	signal TEMP_6_res_0 : std_logic_vector(0 downto 0);
	signal TEMP_6_res_1 : std_logic_vector(0 downto 0);
	signal TEMP_6_res_2 : std_logic_vector(0 downto 0);
	signal TEMP_6_res_3 : std_logic_vector(0 downto 0);
	signal TEMP_6_res_4 : std_logic_vector(0 downto 0);
	signal TEMP_6_res_5 : std_logic_vector(0 downto 0);
	signal TEMP_6_res_6 : std_logic_vector(0 downto 0);
	signal TEMP_6_res_7 : std_logic_vector(0 downto 0);
	signal TEMP_7_res_0 : std_logic_vector(0 downto 0);
	signal TEMP_7_res_1 : std_logic_vector(0 downto 0);
	signal TEMP_7_res_2 : std_logic_vector(0 downto 0);
	signal TEMP_7_res_3 : std_logic_vector(0 downto 0);
	signal TEMP_8_res_0 : std_logic_vector(0 downto 0);
	signal TEMP_8_res_1 : std_logic_vector(0 downto 0);
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
	entry_allocated_for_port_0 <= entry_port_idx_oh_0 when entry_alloc_0_i else "0";
	entry_allocated_for_port_1 <= entry_port_idx_oh_1 when entry_alloc_1_i else "0";
	entry_allocated_for_port_2 <= entry_port_idx_oh_2 when entry_alloc_2_i else "0";
	entry_allocated_for_port_3 <= entry_port_idx_oh_3 when entry_alloc_3_i else "0";
	entry_allocated_for_port_4 <= entry_port_idx_oh_4 when entry_alloc_4_i else "0";
	entry_allocated_for_port_5 <= entry_port_idx_oh_5 when entry_alloc_5_i else "0";
	entry_allocated_for_port_6 <= entry_port_idx_oh_6 when entry_alloc_6_i else "0";
	entry_allocated_for_port_7 <= entry_port_idx_oh_7 when entry_alloc_7_i else "0";
	entry_allocated_for_port_8 <= entry_port_idx_oh_8 when entry_alloc_8_i else "0";
	entry_allocated_for_port_9 <= entry_port_idx_oh_9 when entry_alloc_9_i else "0";
	entry_allocated_for_port_10 <= entry_port_idx_oh_10 when entry_alloc_10_i else "0";
	entry_allocated_for_port_11 <= entry_port_idx_oh_11 when entry_alloc_11_i else "0";
	entry_allocated_for_port_12 <= entry_port_idx_oh_12 when entry_alloc_12_i else "0";
	entry_allocated_for_port_13 <= entry_port_idx_oh_13 when entry_alloc_13_i else "0";
	entry_allocated_for_port_14 <= entry_port_idx_oh_14 when entry_alloc_14_i else "0";
	entry_allocated_for_port_15 <= entry_port_idx_oh_15 when entry_alloc_15_i else "0";
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

	entry_waiting_for_port_valid_0 <= oldest_entry_allocated_per_port_0 when entry_payload_valid_0_i else "0";
	entry_waiting_for_port_valid_1 <= oldest_entry_allocated_per_port_1 when entry_payload_valid_1_i else "0";
	entry_waiting_for_port_valid_2 <= oldest_entry_allocated_per_port_2 when entry_payload_valid_2_i else "0";
	entry_waiting_for_port_valid_3 <= oldest_entry_allocated_per_port_3 when entry_payload_valid_3_i else "0";
	entry_waiting_for_port_valid_4 <= oldest_entry_allocated_per_port_4 when entry_payload_valid_4_i else "0";
	entry_waiting_for_port_valid_5 <= oldest_entry_allocated_per_port_5 when entry_payload_valid_5_i else "0";
	entry_waiting_for_port_valid_6 <= oldest_entry_allocated_per_port_6 when entry_payload_valid_6_i else "0";
	entry_waiting_for_port_valid_7 <= oldest_entry_allocated_per_port_7 when entry_payload_valid_7_i else "0";
	entry_waiting_for_port_valid_8 <= oldest_entry_allocated_per_port_8 when entry_payload_valid_8_i else "0";
	entry_waiting_for_port_valid_9 <= oldest_entry_allocated_per_port_9 when entry_payload_valid_9_i else "0";
	entry_waiting_for_port_valid_10 <= oldest_entry_allocated_per_port_10 when entry_payload_valid_10_i else "0";
	entry_waiting_for_port_valid_11 <= oldest_entry_allocated_per_port_11 when entry_payload_valid_11_i else "0";
	entry_waiting_for_port_valid_12 <= oldest_entry_allocated_per_port_12 when entry_payload_valid_12_i else "0";
	entry_waiting_for_port_valid_13 <= oldest_entry_allocated_per_port_13 when entry_payload_valid_13_i else "0";
	entry_waiting_for_port_valid_14 <= oldest_entry_allocated_per_port_14 when entry_payload_valid_14_i else "0";
	entry_waiting_for_port_valid_15 <= oldest_entry_allocated_per_port_15 when entry_payload_valid_15_i else "0";
	-- Reduction Begin
	-- Reduce(port_valid_vec, entry_waiting_for_port_valid, or)
	TEMP_6_res_0 <= entry_waiting_for_port_valid_0 or entry_waiting_for_port_valid_8;
	TEMP_6_res_1 <= entry_waiting_for_port_valid_1 or entry_waiting_for_port_valid_9;
	TEMP_6_res_2 <= entry_waiting_for_port_valid_2 or entry_waiting_for_port_valid_10;
	TEMP_6_res_3 <= entry_waiting_for_port_valid_3 or entry_waiting_for_port_valid_11;
	TEMP_6_res_4 <= entry_waiting_for_port_valid_4 or entry_waiting_for_port_valid_12;
	TEMP_6_res_5 <= entry_waiting_for_port_valid_5 or entry_waiting_for_port_valid_13;
	TEMP_6_res_6 <= entry_waiting_for_port_valid_6 or entry_waiting_for_port_valid_14;
	TEMP_6_res_7 <= entry_waiting_for_port_valid_7 or entry_waiting_for_port_valid_15;
	-- Layer End
	TEMP_7_res_0 <= TEMP_6_res_0 or TEMP_6_res_4;
	TEMP_7_res_1 <= TEMP_6_res_1 or TEMP_6_res_5;
	TEMP_7_res_2 <= TEMP_6_res_2 or TEMP_6_res_6;
	TEMP_7_res_3 <= TEMP_6_res_3 or TEMP_6_res_7;
	-- Layer End
	TEMP_8_res_0 <= TEMP_7_res_0 or TEMP_7_res_2;
	TEMP_8_res_1 <= TEMP_7_res_1 or TEMP_7_res_3;
	-- Layer End
	port_valid_vec <= TEMP_8_res_0 or TEMP_8_res_1;
	-- Reduction End

	port_valid_0_o <= port_valid_vec(0);
	entry_port_transfer_0(0) <= entry_waiting_for_port_valid_0(0) and port_ready_0_i;
	entry_port_transfer_1(0) <= entry_waiting_for_port_valid_1(0) and port_ready_0_i;
	entry_port_transfer_2(0) <= entry_waiting_for_port_valid_2(0) and port_ready_0_i;
	entry_port_transfer_3(0) <= entry_waiting_for_port_valid_3(0) and port_ready_0_i;
	entry_port_transfer_4(0) <= entry_waiting_for_port_valid_4(0) and port_ready_0_i;
	entry_port_transfer_5(0) <= entry_waiting_for_port_valid_5(0) and port_ready_0_i;
	entry_port_transfer_6(0) <= entry_waiting_for_port_valid_6(0) and port_ready_0_i;
	entry_port_transfer_7(0) <= entry_waiting_for_port_valid_7(0) and port_ready_0_i;
	entry_port_transfer_8(0) <= entry_waiting_for_port_valid_8(0) and port_ready_0_i;
	entry_port_transfer_9(0) <= entry_waiting_for_port_valid_9(0) and port_ready_0_i;
	entry_port_transfer_10(0) <= entry_waiting_for_port_valid_10(0) and port_ready_0_i;
	entry_port_transfer_11(0) <= entry_waiting_for_port_valid_11(0) and port_ready_0_i;
	entry_port_transfer_12(0) <= entry_waiting_for_port_valid_12(0) and port_ready_0_i;
	entry_port_transfer_13(0) <= entry_waiting_for_port_valid_13(0) and port_ready_0_i;
	entry_port_transfer_14(0) <= entry_waiting_for_port_valid_14(0) and port_ready_0_i;
	entry_port_transfer_15(0) <= entry_waiting_for_port_valid_15(0) and port_ready_0_i;
	-- Reduction Begin
	-- Reduce(entry_reset_0, entry_port_transfer_0, or)
	entry_reset_0_o <= entry_port_transfer_0(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_1, entry_port_transfer_1, or)
	entry_reset_1_o <= entry_port_transfer_1(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_2, entry_port_transfer_2, or)
	entry_reset_2_o <= entry_port_transfer_2(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_3, entry_port_transfer_3, or)
	entry_reset_3_o <= entry_port_transfer_3(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_4, entry_port_transfer_4, or)
	entry_reset_4_o <= entry_port_transfer_4(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_5, entry_port_transfer_5, or)
	entry_reset_5_o <= entry_port_transfer_5(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_6, entry_port_transfer_6, or)
	entry_reset_6_o <= entry_port_transfer_6(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_7, entry_port_transfer_7, or)
	entry_reset_7_o <= entry_port_transfer_7(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_8, entry_port_transfer_8, or)
	entry_reset_8_o <= entry_port_transfer_8(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_9, entry_port_transfer_9, or)
	entry_reset_9_o <= entry_port_transfer_9(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_10, entry_port_transfer_10, or)
	entry_reset_10_o <= entry_port_transfer_10(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_11, entry_port_transfer_11, or)
	entry_reset_11_o <= entry_port_transfer_11(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_12, entry_port_transfer_12, or)
	entry_reset_12_o <= entry_port_transfer_12(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_13, entry_port_transfer_13, or)
	entry_reset_13_o <= entry_port_transfer_13(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_14, entry_port_transfer_14, or)
	entry_reset_14_o <= entry_port_transfer_14(0);
	-- Reduction End

	-- Reduction Begin
	-- Reduce(entry_reset_15, entry_port_transfer_15, or)
	entry_reset_15_o <= entry_port_transfer_15(0);
	-- Reduction End


end architecture;
