@echo off
set bin_path=D:/Apps/1_LearningApps/ModelSim_v10.5Se/win64
cd D:/01_Learning_projects/PDS_projects/SINGAL/HDMI/sim/synth
call "%bin_path%/modelsim"   -do "do {run_post_syn_compile.tcl};do {run_post_syn_simulate.tcl}" -l run_post_syn_simulate.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
