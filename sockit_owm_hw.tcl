# sockit_owm
# Iztok Jeras 2010.06.13.18:29:39
# 1-wire (onewire) master

# request TCL package from ACDS 9.1
package require -exact sopc 9.1

# module sockit_owm
set_module_property DESCRIPTION "1-wire (onewire) master"
set_module_property NAME sockit_owm
set_module_property VERSION 1.1
set_module_property INTERNAL false
set_module_property GROUP "Interface Protocols/Serial"
set_module_property AUTHOR "Iztok Jeras"
set_module_property DISPLAY_NAME "1-wire (onewire)"
set_module_property TOP_LEVEL_HDL_FILE sockit_owm.v
set_module_property TOP_LEVEL_HDL_MODULE sockit_owm
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE

set_module_property  VALIDATION_CALLBACK  validation_callback
set_module_property ELABORATION_CALLBACK elaboration_callback

# TODO add_documentation_link

# RTL files
add_file sockit_owm.v {SYNTHESIS SIMULATION}

# parameters
add_parameter BDW INTEGER
set_parameter_property BDW DESCRIPTION "CPU interface data bus width"
#set_parameter_property BDW DISPLAY_NAME BDW
set_parameter_property BDW DISPLAY_HINT "radio"
set_parameter_property BDW DEFAULT_VALUE 32
set_parameter_property BDW ALLOWED_RANGES {8 32}
set_parameter_property BDW UNITS bits
set_parameter_property BDW ENABLED false
set_parameter_property BDW AFFECTS_GENERATION false
set_parameter_property BDW HDL_PARAMETER true

add_parameter OVD_E BOOLEAN
set_parameter_property OVD_E DESCRIPTION "Implementation of overdrive enable, disabling it can spare a small amount of logic."
#set_parameter_property OVD_E DISPLAY_NAME OVD_E
set_parameter_property OVD_E DEFAULT_VALUE 1
set_parameter_property OVD_E UNITS None
set_parameter_property OVD_E AFFECTS_GENERATION false
set_parameter_property OVD_E HDL_PARAMETER true

add_parameter OWN INTEGER
set_parameter_property OWN DESCRIPTION "Nummber of 1-wire channels"
#set_parameter_property OWN DISPLAY_NAME OWN
#set_parameter_property BTP_N DISPLAY_HINT "drop-down"
set_parameter_property OWN DEFAULT_VALUE 1
set_parameter_property OWN ALLOWED_RANGES {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16}
set_parameter_property OWN AFFECTS_GENERATION false
set_parameter_property OWN AFFECTS_ELABORATION true
set_parameter_property OWN HDL_PARAMETER true

add_parameter BTP_N STRING
set_parameter_property BTP_N DESCRIPTION "Base time period for normal mode"
#set_parameter_property BTP_N DISPLAY_NAME BTP_N
set_parameter_property BTP_N DISPLAY_HINT "radio"
set_parameter_property BTP_N DEFAULT_VALUE "5.0"
set_parameter_property BTP_N ALLOWED_RANGES {"5.0:5.0us (preferred)" "7.5:7.5us" "6.0:6.0us - 7.5us"}
set_parameter_property BTP_N AFFECTS_GENERATION false
set_parameter_property BTP_N HDL_PARAMETER true

add_parameter BTP_O STRING
set_parameter_property BTP_O DESCRIPTION "Base time period for overdrive mode"
#set_parameter_property BTP_O DISPLAY_NAME BTP_N
set_parameter_property BTP_O DISPLAY_HINT "radio"
set_parameter_property BTP_O DEFAULT_VALUE "1.0"
set_parameter_property BTP_O ALLOWED_RANGES {"1.0:1.0us (preferred)" "0.5:0.5us - 0.66us"}
set_parameter_property BTP_O AFFECTS_GENERATION false
set_parameter_property BTP_O HDL_PARAMETER true

add_parameter F_CLK INTEGER
set_parameter_property F_CLK SYSTEM_INFO {CLOCK_RATE clock_reset}
set_parameter_property F_CLK DISPLAY_NAME F_CLK
set_parameter_property F_CLK DESCRIPTION "System clock frequency"
set_parameter_property F_CLK UNITS megahertz

add_parameter CDR_N POSITIVE
set_parameter_property CDR_N DERIVED true
set_parameter_property CDR_N DESCRIPTION "Clock divider ratio for normal mode"
set_parameter_property CDR_N DISPLAY_NAME CDR_N
set_parameter_property CDR_N DEFAULT_VALUE 5
set_parameter_property CDR_N AFFECTS_GENERATION false
set_parameter_property CDR_N HDL_PARAMETER true

add_parameter CDR_O POSITIVE
set_parameter_property CDR_O DERIVED true
set_parameter_property CDR_O DESCRIPTION "Clock divider ratio for overdrive mode"
set_parameter_property CDR_O DISPLAY_NAME CDR_O
set_parameter_property CDR_O DEFAULT_VALUE 1
set_parameter_property CDR_O AFFECTS_GENERATION false
set_parameter_property CDR_O HDL_PARAMETER true

add_display_item "Base time period options" BTP_N parameter
add_display_item "Base time period options" BTP_O parameter
add_display_item "Clock dividers" F_CLK parameter
add_display_item "Clock dividers" CDR_N parameter
add_display_item "Clock dividers" CDR_O parameter

# connection point clock_reset
add_interface clock_reset clock end

set_interface_property clock_reset ENABLED true

add_interface_port clock_reset clk clk Input 1
add_interface_port clock_reset rst reset Input 1

# connection point s1
add_interface s1 avalon end
set_interface_property s1 addressAlignment DYNAMIC
set_interface_property s1 associatedClock clock_reset
set_interface_property s1 burstOnBurstBoundariesOnly false
set_interface_property s1 explicitAddressSpan 0
set_interface_property s1 holdTime 0
set_interface_property s1 isMemoryDevice false
set_interface_property s1 isNonVolatileStorage false
set_interface_property s1 linewrapBursts false
set_interface_property s1 maximumPendingReadTransactions 0
set_interface_property s1 printableDevice false
set_interface_property s1 readLatency 0
set_interface_property s1 readWaitStates 0
set_interface_property s1 readWaitTime 0
set_interface_property s1 setupTime 0
set_interface_property s1 timingUnits Cycles
set_interface_property s1 writeWaitTime 0

set_interface_property s1 ASSOCIATED_CLOCK clock_reset
set_interface_property s1 ENABLED true

add_interface_port s1 bus_read read Input 1
add_interface_port s1 bus_write write Input 1
add_interface_port s1 bus_writedata writedata Input BDW
add_interface_port s1 bus_readdata readdata Output BDW

# connection point irq
add_interface irq interrupt end
set_interface_property irq associatedClock clock_reset
set_interface_property irq associatedAddressablePoint s1

set_interface_property irq ASSOCIATED_CLOCK clock_reset
set_interface_property irq ENABLED true

add_interface_port irq bus_interrupt irq Output 1

# connection point conduit
add_interface ext conduit end

set_interface_property ext ENABLED true

add_interface_port ext onewire_p export Output 1
add_interface_port ext onewire_e export Output 1
add_interface_port ext onewire_i export Input  1

proc validation_callback {} {
  # check if overdrive is enabled
  set ovd [get_parameter_value OVD_E]
  # get clock frequency in Hz
  set f [get_parameter_value F_CLK]
  # get base time periods
  set btp_n [get_parameter_value BTP_N]
  set btp_o [get_parameter_value BTP_O]
  # disable editing od dividers
  set_parameter_property BTP_O ENABLED [expr {$ovd ? "true" : "false"}]
  # compute normal mode divider
  if {$btp_n=="5.0"} {
    set d_n [expr {$f/200000}]
    set t_n [expr {1000000.0/($f/$d_n)}]
    set e_n [expr {$t_n/5.0-1}]
  } elseif {$btp_n=="7.5"} {
    set d_n [expr {$f/133333}]
    set t_n [expr {1000000.0/($f/$d_n)}]
    set e_n [expr {$t_n/7.5-1}]
  } elseif {$btp_n=="6.0"} {
    set d_n [expr {$f/133333}]
    set t_n [expr {1000000.0/($f/$d_n)}]
    if {(6.0<=$t_n) && ($t_n<=7.5)} {
      set e_n 0.0
    } else {
      set e_n [expr {$t_n/6.0-1}]
    }
  }
  # compute overdrive mode divider
  if {$btp_o=="1.0"} {
    set d_o [expr {$f/1000000}]
    set t_o [expr {1000000.0/($f/$d_o)}]
    set e_o [expr {$t_o/1.0-1}]
  } elseif {$btp_o=="0.5"} {
    set d_o [expr {$f/1500000}]
    set t_o [expr {1000000.0/($f/$d_o)}]
    if {(0.5<=$t_o) && ($t_o<=(2.0/3))} {
      set e_o 0.0
    } else {
      set e_o [expr {$t_o/0.5-1}]
    }
  }
  # set divider values
             set_parameter_value CDR_N $d_n
  if {$ovd} {set_parameter_value CDR_O $d_o}
  # report BTP values and relative errors
  send_message info "BTP_N (normal    mode 'base time period') is [format %.2f $t_n], relative error is [format %.1f [expr {$e_n*100}]]%."
  send_message info "BTP_O (overdrive mode 'base time period') is [format %.2f $t_o], relative error is [format %.1f [expr {$e_o*100}]]%."
  # repport validatio errors if relative error are outside accepted bounds (2%)
  if {abs($e_n)>0.02} {send_message error "BTP_N is outside accepted bounds (relative error > 2%). Use a different 'base time period' or system frequency."}
  if {abs($e_o)>0.02} {send_message error "BTP_O is outside accepted bounds (relative error > 2%). Use a different 'base time period' or system frequency."}
}

proc elaboration_callback {} {
  # add software defines
  set_module_assignment embeddedsw.CMacro.OWN          [get_parameter_value OWN  ]
  set_module_assignment embeddedsw.CMacro.OVD_E [expr {[get_parameter_value OVD_E]?1:0}]
  set_module_assignment embeddedsw.CMacro.BTP_N        [get_parameter_value BTP_N]
  set_module_assignment embeddedsw.CMacro.BTP_O        [get_parameter_value BTP_O]
}
