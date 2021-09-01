=======================
#!/bin/bash
## HOWTORUN gromacs ##

# Una forma de lanzar Gromacs es haciendo uso de samples predefinidos. Estos se ubican en:
# $gromacs_data.

# Dado que la ejecución de Gromacs arroja muchos ficheros de logs en el directorio donde se encuentra el usuario que realiza la ejecución, se recomienda ejecutar Gromacs desde un directorio temporal de forma que los ficheros de logs no sean creados en el propio directorio de la aplicación, por ejemplo en:
# /tmp/gromacs

# Es recomendable usar la opcion -nobackup para que asi no genere nuevos ficheros de log.
# Para la versión MPI, también es posible especificar un fichero con la lista de hosts con el parámetro -hostfile. También hay que tener en cuenta que si se usan diferentes host, la carpeta temporal en la que se lanza el comando ha de existir en todos los hosts.
# Le ejecución de Gromacs es igual en todas sus versiones. A continuación se muestra un ejemplo de como seria la ejecución de cada tipo de compilación usando Gromacs 5.1.4 y CUDA 8.0:

gromacs_bin=$topdir/bin/gmx
gromacs_data=$topdir/samples

# FOR RUN IN UBUNTU18.04
# export LD_LIBRARY_PATH=
source /opt/intel/bin/compilervars.sh intel64 # libomp5.so

# Versión GPU:
$gromacs_bin mdrun -s $gromacs_data/bpti.tpr -pin on
$gromacs_bin mdrun -s $gromacs_data/ion_channel.tpr -pin on
$gromacs_bin mdrun -s $gromacs_data/lignocellulose.tpr -pin on

# Versión GPU+NVML:
$gromacs_bin mdrun -s $gromacs_data/samples/bpti.tpr -pin on
$gromacs_bin mdrun -s $gromacs_data/ion_channel.tpr -pin on
$gromacs_bin mdrun -s $gromacs_data/lignocellulose.tpr -pin on

#Versión GPU+MPI:
mpirun_rsh -ssh -np 2 mlxc1 mlxc17 MV2_ENABLE_AFFINITY=0 MV2_SMP_USE_LIMIC2=1 MV2_IBA_HCA=mlx4_0 MV2_NUM_PORTS=1 $gromacs_bin mdrun -s $gromacs_data/bpti.tpr -ntomp 6 -pin on
mpirun_rsh -ssh -np 2 mlxc1 mlxc17 MV2_ENABLE_AFFINITY=0 MV2_SMP_USE_LIMIC2=1 MV2_IBA_HCA=mlx4_0 MV2_NUM_PORTS=1 $gromacs_bin mdrun -s $gromacs_data/ion_channel.tpr -ntomp 6 -pin on
mpirun_rsh -ssh -np 2 mlxc1 mlxc17 MV2_ENABLE_AFFINITY=0 MV2_SMP_USE_LIMIC2=1 MV2_IBA_HCA=mlx4_0 MV2_NUM_PORTS=1 $gromacs_bin mdrun -s $gromacs_data/lignocellulose.tpr -ntomp 6 -pin on

# Versión GPU+MPI+NVML:
mpirun_rsh -ssh -np 2 mlxc1 mlxc17 MV2_ENABLE_AFFINITY=0 MV2_SMP_USE_LIMIC2=1 MV2_IBA_HCA=mlx4_0 MV2_NUM_PORTS=1 $gromacs_bin mdrun -s $gromacs_data/bpti.tpr -ntomp 6 -pin on
mpirun_rsh -ssh -np 2 mlxc1 mlxc17 MV2_ENABLE_AFFINITY=0 MV2_SMP_USE_LIMIC2=1 MV2_IBA_HCA=mlx4_0 MV2_NUM_PORTS=1 $gromacs_bin mdrun -s $gromacs_data/ion_channel.tpr -ntomp 6 -pin on
mpirun_rsh -ssh -np 2 mlxc1 mlxc17 MV2_ENABLE_AFFINITY=0 MV2_SMP_USE_LIMIC2=1 MV2_IBA_HCA=mlx4_0 MV2_NUM_PORTS=1 $gromacs_bin mdrun -s $gromacs_data/lignocellulose.tpr -ntomp 6 -pin on

