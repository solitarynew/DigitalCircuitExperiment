transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp3/Calc {D:/data/Homework/FPGA/Exp/Exp3/Calc/Calc.v}

vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp3/Calc/simulation/modelsim {D:/data/Homework/FPGA/Exp/Exp3/Calc/simulation/modelsim/Calc.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  Calc_vlg_tst

add wave *
view structure
view signals
run -all
