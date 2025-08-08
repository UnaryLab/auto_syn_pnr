#period set in nano-seconds - currently: 2.5ns = 400 MHz freq

set clk_name iClk
set rstn_name iRstN

set clk_period 2.5
if { [info exists ::env(CLK_PERIOD)] } {
  set clk_period   $::env(CLK_PERIOD)
}

echo "Clock period: $clk_period"

set clk_port [get_ports $clk_name -quiet]
if {[llength $clk_port] > 0} {
    set clk_half_period [expr $clk_period / 2.0]
    create_clock -name core_clock -period $clk_period \
                 -waveform "0 $clk_half_period" $clk_port
    set_clock_uncertainty 0.15 [get_clocks core_clock]
    # set_clock_transition -rise 0.1 [get_clocks core_clock]
    # set_clock_transition -fall 0.1 [get_clocks core_clock]
}

set_input_transition 0.1 [remove_from_collection [all_inputs] $clk_port]
set_load 0.1 [all_outputs]

set rst_port [get_ports $rstn_name -quiet]
if {[llength $rst_port] > 0} {
    set_ideal_network $rst_port
    set_false_path -from $rst_port
}
