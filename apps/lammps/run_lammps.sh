#!/bin/bash
## HOWTORUN lammps ##
lammps_data=$topdir/samples

# no MPI:
lmp_serial=$topdir/bin/lmp_serial

mkdir -p $lammps_data/TEST01
cd $lammps_data/TEST01
$lmp_serial -sf gpu -in $lammps_data/samples/in.lj -var x 4 -var y 4 -var z 4

# MPI:
lmp_mpi=/$topdir/bin/lmp_mpi

mkdir -p $lammps_data/TEST02
cd $lammps_data/TEST02
mpiexec -np 4 $lmp_mpi -sf gpu -in $lammps_data/samples/in.lj -var x 4 -var y 4 -var z 4
