Scripts for synthesis and place-and-route using **Cadence Genus and Innovus**, adapted from [here](https://github.com/TILOS-AI-Institute/MacroPlacement).

## Input RTL
Input RTL for a ```<module>``` needs to be Verilog files (.v), and shall be placed in ```src/<module>/<module>.v```.
The Verilog top module requires a name ```<module>```.

## Synthesis

```bash auto_syn.sh $technode $module``` runs the synthesis using [flow-1](Flows/figures/flow-1.PNG).


```$technode``` can be ```ASAP7``` or ```NanGate45```, and defaults to ```ASAP7``` if not specified.

```$module``` is optional. If specified, it must match the exact module name. If not specified, it will traverse all modules in ```src```.


