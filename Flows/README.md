# Synthesis, Place & Route (SP&R):
The setups to run SP&R on the available testcases for the given enablements are available in *./\<enablement_name\>/\<testcase_name\>/* directories.  

Inside each directory are the following sub-directories containing all the files required to run the full SP&R flow.  
  - The *constraints* directory contains the SDC constraint file for current design and enablement.
  - The *def* directory contains the floorplan DEF file used in the SP&R flow. We provide two DEF files, one with just the core.
    area and pin placements that are used for the logical synthesis flow [Flow-1](./figures/flow-1.PNG)
  - The *netlist* directory contains the synthesized netlist from [Flow-1](./figures/flow-1.PNG).
  - The *scripts* directory contains the setup and scripts to run the full SP&R flow using both commercial and open-source tools.
  - The *run* directory is provided to perfom the SP&R runs using the runscripts available in the *scripts* directory.

The runscripts for all the flows are available in the *./\<enablement\>/\<testcase\>/scripts/* directory. Inside the *script* directory are the following sub-directories.
- The *cadence* directory contains all the runscripts related to [Flow-1](./figures/flow-1.PNG).

All the flows use the *.lef*, *.lib*, and *qrc* files from the [*Enablements*](../Enablements/) directory. The required SRAM models for each testcase are generated and available under the [*Enablements*](../Enablements/) directory. The detailed steps for different tools are as follows.
  - [**Cadence tools**](#using-cadence-genus-and-innovus)
  

## **Using Cadence Genus and Innovus:**
All the required runscripts are available in the *./scripts/cadence/* directory. The steps to modify *run.sh* to launch SP&R runs for Flow-1 are as follows.
- To launch Flow-1, set the **PHY_SYNTH** environment variable to *0* in the *run.sh* file.  
``` export PHY_SYNTH=0 ```
- To start the SP&R run, use the following command.  
``` ./run.sh ```


**Synthesis:** The *run_genus_hybrid.tcl* is used to run the logical synthesis using Genus and physical synthesis using Genus iSpatial. It utilizes the **PHY_SYNTH** environment variable to determine the flow. Minor details of each synthesis flow are as follows.
- Logical synthesis using Genus (Flow-1): We use the *elaborate*, *syn_generic*, *syn_map* and *syn_opt* commands to generate the synthesized netlist. This synthesized netlist is copied into the *netlist* directory.

The command to launch only the synthesis run is as follows.
```
# export PHY_SYNTH=0   #For Flow-1 uncomment this line
genus -overwrite -log log/genus.log -no_gui -files run_genus_hybrid.tcl
```  
<!-- We use the constraint file available in the *constraint* directory for the synthesis run. We set the target clock period to a reasonable value that is not too easy or hard for the tool to achieve. -->

**P\&R:** The *run_invs.tcl* is used to run the place and route using Cadence Innovus. The netlist and constraint generated during synthesis flow are used in this step. It also utilizes the **PHY_SYNTH** environment variable to choose which flow to run. Minor details of each P&R flow are as follows.
- Flow-1
  - It uses *place_opt_design*, *ccopt_design* and *routeDesign* commands for placement, CTS and routing of the design.

The command to launch the P&R run is as follows.  
```
### Make sure you have run the synthesis step. run_invs.tcl uses the output files generated synthesis ###
# export PHY_SYNTH=0   #For Flow-1 uncomment this line
innovus -64 -init run_invs.tcl -log log/innovus.log
```  

This script was written and developed by ABKGroup students at UCSD; however, the underlying commands and reports are copyrighted by Cadence. We thank Cadence for granting permission to share our research to help promote and foster the next generation of innovators.  

