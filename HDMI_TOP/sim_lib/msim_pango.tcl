# ----------------------------------------
# Create compilation libraries
vlib usim
vmap usim "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/usim"
vlib vsim
vmap vsim "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/vsim"
vlib adc
vmap adc "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/adc"
vlib adc_e2
vmap adc_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/adc_e2"
vlib adc_e3
vmap adc_e3 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/adc_e3"
vlib ddc_e2
vmap ddc_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/ddc_e2"
vlib ddrc
vmap ddrc "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/ddrc"
vlib ddrphy
vmap ddrphy "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/ddrphy"
vlib dll_e2
vmap dll_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/dll_e2"
vlib emacx
vmap emacx "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/emacx"
vlib emacy
vmap emacy "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/emacy"
vlib emacz
vmap emacz "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/emacz"
vlib hsst
vmap hsst "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hsst"
vlib hsst_e2
vmap hsst_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hsst_e2"
vlib hssthp_bufds
vmap hssthp_bufds "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hssthp_bufds"
vlib hssthp_hpll
vmap hssthp_hpll "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hssthp_hpll"
vlib hssthp_lane
vmap hssthp_lane "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hssthp_lane"
vlib hsstlp_lane
vmap hsstlp_lane "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hsstlp_lane"
vlib hsstlp_pll
vmap hsstlp_pll "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hsstlp_pll"
vlib iolhp_fifo
vmap iolhp_fifo "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iolhp_fifo"
vlib iolhr_dft
vmap iolhr_dft "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iolhr_dft"
vlib ipal_e1
vmap ipal_e1 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/ipal_e1"
vlib ipal_e2
vmap ipal_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/ipal_e2"
vlib iserdes_e1
vmap iserdes_e1 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iserdes_e1"
vlib iserdes_e2
vmap iserdes_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iserdes_e2"
vlib iserdes_e3
vmap iserdes_e3 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iserdes_e3"
vlib iserdes_fifo
vmap iserdes_fifo "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iserdes_fifo"
vlib oserdes_e1
vmap oserdes_e1 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/oserdes_e1"
vlib oserdes_e2
vmap oserdes_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/oserdes_e2"
vlib oserdes_e3
vmap oserdes_e3 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/oserdes_e3"
vlib oserdes_fifo
vmap oserdes_fifo "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/oserdes_fifo"
vlib pciegen2
vmap pciegen2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/pciegen2"
vlib pciegen3
vmap pciegen3 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/pciegen3"
vlib pciegen5_cfg
vmap pciegen5_cfg "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/pciegen5_cfg"
vlib pciegen5_ctrl
vmap pciegen5_ctrl "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/pciegen5_ctrl"


#compile basic library
vlog -incr D:/Apps/1_LearningApps/PDS_2022.1/arch/vendor/pango/verilog/simulation/*.v -work usim
vlog -incr D:/Apps/1_LearningApps/PDS_2022.1/arch/vendor/pango/verilog/simulation/modelsim10.2c/*.vp -work usim


#compile basic library
vlog -incr D:/Apps/1_LearningApps/PDS_2022.1/arch/vendor/pango/verilog/bsim/*.v -work vsim
vlog -incr D:/Apps/1_LearningApps/PDS_2022.1/arch/vendor/pango/verilog/bsim/modelsim10.2c/*.vp -work vsim


#compile common library
cd "D:/Apps/1_LearningApps/PDS_2022.1/arch/vendor/pango/verilog/simulation/modelsim10.2c"
vmap adc "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/adc"
vlog -incr -f ./filelist_adc_gtp.f -work adc
vmap adc_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/adc_e2"
vlog -incr -f ./filelist_adc_e2_gtp.f -work adc_e2
vmap adc_e3 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/adc_e3"
vlog -incr -f ./filelist_adc_e3_gtp.f -work adc_e3
vmap ddc_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/ddc_e2"
vlog -incr -f ./filelist_ddc_e2_gtp.f -work ddc_e2
vmap ddrc "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/ddrc"
vlog -incr -f ./filelist_ddrc_gtp.f -work ddrc -sv -mfcu
vmap ddrphy "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/ddrphy"
vlog -incr -f ./filelist_ddrphy_gtp.f -work ddrphy
vmap dll_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/dll_e2"
vlog -incr -f ./filelist_dll_e2_gtp.f -work dll_e2
vmap emacx "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/emacx"
vlog -incr -f ./filelist_emacx_gtp.f -work emacx -sv -mfcu
vmap emacy "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/emacy"
vlog -incr -f ./filelist_emacy_gtp.f -work emacy -sv -mfcu
vmap emacz "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/emacz"
vlog -incr -f ./filelist_emacz_gtp.f -work emacz -sv -mfcu
vmap hsst "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hsst"
vlog -incr -f ./filelist_hsst_gtp.f -work hsst
vmap hsst_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hsst_e2"
vlog -incr -f ./filelist_hsst_e2_gtp.f -work hsst_e2
vmap hssthp_bufds "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hssthp_bufds"
vlog -incr -f ./filelist_hssthp_bufds_gtp.f -work hssthp_bufds
vmap hssthp_hpll "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hssthp_hpll"
vlog -incr -f ./filelist_hssthp_hpll_gtp.f -work hssthp_hpll
vmap hssthp_lane "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hssthp_lane"
vlog -incr -f ./filelist_hssthp_lane_gtp.f -work hssthp_lane
vmap hsstlp_lane "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hsstlp_lane"
vlog -incr -f ./filelist_hsstlp_lane_gtp.f -work hsstlp_lane
vmap hsstlp_pll "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/hsstlp_pll"
vlog -incr -f ./filelist_hsstlp_pll_gtp.f -work hsstlp_pll
vmap iolhp_fifo "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iolhp_fifo"
vlog -incr -f ./filelist_iolhp_fifo_gtp.f -work iolhp_fifo
vmap iolhr_dft "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iolhr_dft"
vlog -incr -f ./filelist_iolhr_dft_gtp.f -work iolhr_dft
vmap ipal_e1 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/ipal_e1"
vlog -incr -f ./filelist_ipal_e1_gtp.f -work ipal_e1
vmap ipal_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/ipal_e2"
vlog -incr -f ./filelist_ipal_e2_gtp.f -work ipal_e2
vmap iserdes_e1 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iserdes_e1"
vlog -incr -f ./filelist_iserdes_e1_gtp.f -work iserdes_e1
vmap iserdes_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iserdes_e2"
vlog -incr -f ./filelist_iserdes_e2_gtp.f -work iserdes_e2
vmap iserdes_e3 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iserdes_e3"
vlog -incr -f ./filelist_iserdes_e3_gtp.f -work iserdes_e3 -sv -mfcu
vmap iserdes_fifo "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/iserdes_fifo"
vlog -incr -f ./filelist_iserdes_fifo_gtp.f -work iserdes_fifo
vmap oserdes_e1 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/oserdes_e1"
vlog -incr -f ./filelist_oserdes_e1_gtp.f -work oserdes_e1
vmap oserdes_e2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/oserdes_e2"
vlog -incr -f ./filelist_oserdes_e2_gtp.f -work oserdes_e2
vmap oserdes_e3 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/oserdes_e3"
vlog -incr -f ./filelist_oserdes_e3_gtp.f -work oserdes_e3 -sv -mfcu
vmap oserdes_fifo "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/oserdes_fifo"
vlog -incr -f ./filelist_oserdes_fifo_gtp.f -work oserdes_fifo
vmap pciegen2 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/pciegen2"
vlog -incr -f ./filelist_pciegen2_gtp.f -work pciegen2 -sv -mfcu
vmap pciegen3 "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/pciegen3"
vlog -incr -f ./filelist_pciegen3_gtp.f -work pciegen3 -sv -mfcu
vmap pciegen5_cfg "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/pciegen5_cfg"
vlog -incr -f ./filelist_pciegen5_cfg_gtp.f -work pciegen5_cfg -sv -mfcu
vmap pciegen5_ctrl "D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim_lib/pciegen5_ctrl"
vlog -incr -f ./filelist_pciegen5_ctrl_gtp.f -work pciegen5_ctrl -sv -mfcu

quit -force

# ----------------------------------------
