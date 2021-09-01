#!/bin/bash
## HOWTORUN namd ##

# Download samples?
namd_bin=$topdir/bin/namd2
namd_data=$topdir/samples

mkdir $namd_data

# Short test:
$namd_bin $namd_data/samples/apoa1/apoa1.namd

# Medium test:
$namd_bin $namd_data/samples/f1atpase/f1atpase.namd

# Large test:
$namd_bin $namd_data/samples/stmv/stmv.namd