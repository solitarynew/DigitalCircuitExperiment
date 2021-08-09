transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp1/mux_2bits_41 {D:/data/Homework/FPGA/Exp/Exp1/mux_2bits_41/mux_2bits_41.v}

vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp1/mux_2bits_41/simulation/modelsim {D:/data/Homework/FPGA/Exp/Exp1/mux_2bits_41/simulation/modelsim/mux_2bits_41.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  mux_2bits_41_vlg_tst

add wave *
view structure
view signals
run -all
