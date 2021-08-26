ARG jobs=1
FROM barracuda as barracuda
FROM cudameme as cudameme
FROM cudasw as cudasw
FROM darknet as darknet
FROM gpublast as gpublast
FROM gromacs as gromacs
FROM hpl as hpl
FROM lammps as lammps
FROM magma as magma
FROM namd as namd
FROM pytorch as pytorch
FROM tensorflow as tensorflow
FROM thundersvm as tensorflow

FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Martin Palacios <marpaal@inf.upv.es>
ARG topdir=docker-test/
COPY --from=barracuda /install/barracuda/build $topdir/barracuda
COPY --from=cudameme /install/cudameme/build $topdir/cudameme
COPY --from=cudasw /install/cudasw/build $topdir/cudasw
COPY --from=darknet /install/darknet/build $topdir/darknet
COPY --from=gpublast /install/gpublast/build $topdir/gpublast
COPY --from=gromacs /install/gromacs/build $topdir/gromacs
COPY --from=hpl /install/hpl/build $topdir/hpl
COPY --from=lammps /install/lammps/build $topdir/lammps
COPY --from=magma /install/magma/build $topdir/magma
COPY --from=namd /install/namd/build $topdir/namd
COPY --from=pytorch /install/pytorch/build $topdir/pytorch
COPY --from=tensorflow /install/tensorflow/build $topdir/tensorflow
COPY --from=thundersvm /install/thundersvm/build $topdir/thundersvm