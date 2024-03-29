# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
set_param synth.incrementalSynthesisCache C:/Users/User/AppData/Roaming/Xilinx/Vivado/.Xil/Vivado-10612-DESKTOP-SIR6EJM/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.cache/wt [current_project]
set_property parent.project_path C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo c:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/imports/new/ALU.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/imports/new/Control_Unit.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/FlagFF.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/Flag_Register.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/I.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/MUXTwoOne-1Bit.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/MuxFourOne.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/MuxTwoOne.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/MuxTwoOne_10bit.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/imports/new/PC.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/RAT_MCU.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/RegisterFile.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/SCR.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/SP.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/imports/Debounce_OneShot_FSM/counter_for_one_shot.vhd
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/imports/Debounce_OneShot_FSM/debounce_one_shot_FSM.vhd
  {C:/Users/User/Desktop/CPE233/RatSim v0.61/RatSimulator/prog_rom.vhd}
  {C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/imports/assignment 1 support files/univ_sseg_dec.vhd}
  C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/sources_1/new/RAT_wrapper.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/constrs_1/new/Basys3_RAT_constraints.xdc
set_property used_in_implementation false [get_files C:/Users/User/Desktop/CPE233/RAT_MCU/RAT_MCU.srcs/constrs_1/new/Basys3_RAT_constraints.xdc]


synth_design -top RAT_wrapper -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef RAT_wrapper.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file RAT_wrapper_utilization_synth.rpt -pb RAT_wrapper_utilization_synth.pb"
