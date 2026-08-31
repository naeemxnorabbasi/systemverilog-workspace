#!/bin/csh -f

start_time=$(date +%s)
echo "Simulation started at: $(date)"

xvlog -sv -f forever_filelist.f
xelab forever_tb -relax -s top -timescale 1ns/1ps
xsim top -runall

end_time=$(date +%s)
echo "Simulation ended at: $(date)"
runtime=$((end_time - start_time))
echo "Total simulation runtime: $runtime seconds"
