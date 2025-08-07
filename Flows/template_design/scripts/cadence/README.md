# **Synthesis, Place & Route (SP&R) using Cadence Genus and Innovus:**
Here we provide all the required scripts to run logical synthesis, physical synthesis using Genus and Genus-iSpatial, and place and route using Innovus. The [run.sh](./run.sh) file can be modified to launch the SP&R run using Flow-1 and Flow-2. Use the following steps to
- Launch Flow-1 set the **PHY_SYNTH** environment variable to *0* in the *run.sh* file  
``` export PHY_SYNTH=0 ```
- Start the SP&R run use the following command  
``` ./run.sh ```
  
**Synthesis:** The [*run_genus_hybrid.tcl*](./run_genus_hybrid.tcl) is used to run the logical synthesis using Genus and physical synthesis using Genus iSpatial. It utilizes the **PHY_SYNTH** environment variable to determine the flow. Minor details of each synthesis flow are as follows.
- Logical synthesis using Genus (Flow-1): We use the *elaborate*, *syn_generic*, *syn_map* and *syn_opt* commands to generate the synthesized netlist. This synthesized netlist is copied into the *netlist* directory.

The command to launch only the synthesis run is as follows.
```
# export PHY_SYNTH=0   #For Flow-1 uncomment this line
genus -overwrite -log log/genus.log -no_gui -files run_genus_hybrid.tcl
```

**P\&R:** The [*run_invs.tcl*](./run_invs.tcl) is used to run the place and route using Cadence Innovus. The netlist and constraint generated during synthesis flow are used in this step. It also utilizes the **PHY_SYNTH** environment variable to choose which flow to run. Minor details of each P&R flow are as follows.
- Flow-1
  - It uses *place_opt_design*, *ccopt_design* and *routeDesign* commands for placement, CTS and routing of the design.

The command to launch the P&R run is as follows.  
```
### Make sure you have run the synthesis step. run_invs.tcl uses the output files generated synthesis ###
# export PHY_SYNTH=0   #For Flow-1 uncomment this line
innovus -64 -init run_invs.tcl -log log/run.log
```
