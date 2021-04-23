# Files-for-My-Favourite-HDL-Workflow-in-ModelSim-and-Quartus
https://youtube.com/playlist?list=PLSHT1m-5ou5ZhkHk_wnCtQn0pbrVI8jwD

# Useful ModelSim/VSIM commands
## Simulate for the first time
Note: WLF stands for wave log format
```
vsim -wlf <design>.wlf work.<design>_tb
run -all
quit -sim
```

## View the waveform without re-simulation
```
vsim -view <design>.wlf -do <design>.do
dataset close <design>
```

## Re-simulation using the same waveform configuration
```
vsim -wlf <design>.wlf -do <design>.do -do "run -all" work.<design>_tb
```
