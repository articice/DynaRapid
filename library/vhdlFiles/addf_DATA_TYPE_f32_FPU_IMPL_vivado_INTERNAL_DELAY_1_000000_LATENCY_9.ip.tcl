# Xilinx IP cores of this variant for $ip_part (scripts/xilinx_ip.py, sourced by the synthesis tcl)
file mkdir $ip_dir
create_ip -name floating_point -vendor xilinx.com -library ip -version 7.1 -module_name w43b90b33_addf_vitis_hls_single_precision_lat_8 -dir $ip_dir
set_property -dict [list CONFIG.Operation_Type Add_Subtract CONFIG.Add_Sub_Value Add CONFIG.A_Precision_Type Single CONFIG.Flow_Control NonBlocking CONFIG.Has_ACLKEN true CONFIG.C_Optimization Speed_Optimized CONFIG.C_Mult_Usage Full_Usage CONFIG.Maximum_Latency false CONFIG.C_Latency 8] [get_ips w43b90b33_addf_vitis_hls_single_precision_lat_8]
set_property generate_synth_checkpoint false [get_files w43b90b33_addf_vitis_hls_single_precision_lat_8.xci]
generate_target synthesis [get_ips w43b90b33_addf_vitis_hls_single_precision_lat_8]
