transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp8/Keyboard {D:/data/Homework/FPGA/Exp/Exp8/Keyboard/Keyboard.v}
vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp8/Keyboard {D:/data/Homework/FPGA/Exp/Exp8/Keyboard/ascii.v}
vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp8/Keyboard {D:/data/Homework/FPGA/Exp/Exp8/Keyboard/decode_ascii_hex.v}
vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp8/Keyboard {D:/data/Homework/FPGA/Exp/Exp8/Keyboard/out.v}
vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp8/Keyboard {D:/data/Homework/FPGA/Exp/Exp8/Keyboard/ps2_keyboard.v}
vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp8/Keyboard {D:/data/Homework/FPGA/Exp/Exp8/Keyboard/decode_hex.v}

vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp8/Keyboard/simulation/modelsim {D:/data/Homework/FPGA/Exp/Exp8/Keyboard/simulation/modelsim/Keyboard.vt}
vlog -vlog01compat -work work +incdir+D:/data/Homework/FPGA/Exp/Exp8/Keyboard {D:/data/Homework/FPGA/Exp/Exp8/Keyboard/ps2_keyboard_model.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  Keyboard_vlg_tst

add wave *
view structure
view signals
run -all
