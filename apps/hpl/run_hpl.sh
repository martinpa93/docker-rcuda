#!/bin/bash
## HOWTORUN hpl ##

cd $topdir/bin
# Test with the specific number of GPUs
mpirun -np 1 $topdir/bin/run_linpack


