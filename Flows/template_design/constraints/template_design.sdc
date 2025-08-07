#period set in nano-seconds - currently: 2.5ns = 400 MHz freq
set clk_period 2.5
if { [info exists ::env(CLK_PERIOD)] } {
  set clk_period   $::env(CLK_PERIOD)
}

set clk_port [get_ports clk_i -quiet]
if {[llength $clk_port] > 0} {
    create_clock -name core_clock -period $clk_period $clk_port
}
