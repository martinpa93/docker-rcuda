#!/bin/bash
## HOWTORUN cudameme ##

cudameme_bin=$topdir/bin/cudameme
mcudameme_bin=$topdir/bin/mcuda-meme
cudameme_data=$topdir/samples

# Download datasets
mkdir $cudameme_data
wget https://sourceforge.net/projects/cuda-meme/files/data/g_testcases.zip/download
unzip g_testcases.zip

# cuda-meme
$cudameme_bin $cudameme_data/samples/nrsf_500.fasta -dna -mod oops -maxsize 1000000
$cudameme_bin $cudameme_data/samples/nrsf_1000.fasta -dna -mod oops -maxsize 1000000
$cudameme_bin $cudameme_data/samples/nrsf_2000.fasta -dna -mod oops -maxsize 1000000

# mcuda-meme ...
mpirun -n 4 -hostfile hosts $mcudameme_bin $cudameme_data/samples/nrsf_500.fasta -dna -mod oops -maxsize 1000000
mpirun -n 4 -hostfile hosts $mcudameme_bin $cudameme_data/samples/nrsf_1000.fasta -dna -mod oops -maxsize 1000000
mpirun -n 4 -hostfile hosts $mcudameme_bin $cudameme_data/samples/nrsf_2000.fasta -dna -mod oops -maxsize 1000000
