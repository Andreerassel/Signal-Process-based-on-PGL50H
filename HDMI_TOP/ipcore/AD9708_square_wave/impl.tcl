#Generated by Fabric Compiler ( version 2022.1 <build 99559> ) at Wed Jan  3 17:19:37 2024

add_design "D:/admin/desktop/AD_DA_50H/AD9708_square_wave/source/square_wave.v"
add_design D:/admin/desktop/AD_DA_50H/AD9708_square_wave/ipcore/ad_clock_125m/ad_clock_125m.idf
add_design D:/admin/desktop/AD_DA_50H/AD9708_square_wave/ipcore/rom_square_wave/rom_square_wave.idf
set_arch -family Logos -device PGL50G -speedgrade -6 -package FBG484
compile -top_module square_wave
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50G -speedgrade -6 -package FBG484
compile -top_module square_wave
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50G -speedgrade -6 -package FBG484
compile -top_module square_wave
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50G -speedgrade -6 -package FBG484
compile -top_module square_wave
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
add_constraint "D:/admin/desktop/AD_DA_50H/AD9708_square_wave/source/ad_9708_wave.fdc"
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 
set_arch -family Logos -device PGL50H -speedgrade -6 -package FBG484
compile -top_module square_wave
synthesize -ads -selected_syn_tool_opt 2 
dev_map 
pnr 
report_timing 
gen_bit_stream 