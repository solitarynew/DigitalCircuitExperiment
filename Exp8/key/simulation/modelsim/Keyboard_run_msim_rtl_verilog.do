transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Yongp/Desktop/QUARTUS/EXP8 {C:/Users/Yongp/Desktop/QUARTUS/EXP8/Keyboard.v}
vlog -vlog01compat -work work +incdir+C:/Users/Yongp/Desktop/QUARTUS/EXP8 {C:/Users/Yongp/Desktop/QUARTUS/EXP8/display.v}
vlog -vlog01compat -work work +incdir+C:/Users/Yongp/Desktop/QUARTUS/EXP8 {C:/Users/Yongp/Desktop/QUARTUS/EXP8/toASCII.v}
vlog -vlog01compat -work work +incdir+C:/Users/Yongp/Desktop/QUARTUS/EXP8 {C:/Users/Yongp/Desktop/QUARTUS/EXP8/keyboardTop.v}

vlog -vlog01compat -work work +incdir+C:/Users/Yongp/Desktop/QUARTUS/EXP8 {C:/Users/Yongp/Desktop/QUARTUS/EXP8/ps2_keyboard_model.v}
vlog -vlog01compat -work work +incdir+C:/Users/Yongp/Desktop/QUARTUS/EXP8/simulation/modelsim {C:/Users/Yongp/Desktop/QUARTUS/EXP8/simulation/modelsim/keyboardTop.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  keyboardTop_vlg_tst

add wave *
view structure
view signals
run -all
