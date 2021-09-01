#!/bin/bash
## HOWTORUN gpublast  BROKEN LINKS, CANT GET DATASETS ##

gpublast_bin=$topdir/bin
gpublast_data=$topdir/samples

# Step 1. Sorting a database
mkdir $gpublast_data
$gpublast_bin/makeblastdb -dbtype prot -in $gpublast_data/samples/database/env_nr -out $gpublast_data/samples/database/sorted_env_nr -sort_volumes -max_file_sz 500MB

# Step2. Creating a database
# The datasets located on ftp://ftp.ncbi.nlm.nih.gov/blast/db/FASTA are deprecated and the links are broken
# Before running the simulations must go to the directory called database, unless it will give an error
cd $gpublast_data/samples/database
mkdir $gpublast_data/TEST01
$gpublast_bin/blastp -query $gpublast_data/samples/queries/SequenceLength_00000100.txt -db $gpublast_data/samples/database/sorted_env_nr -gpu t -method 2 -gpu_blocks 256 -gpu_threads 32

# Step3. Execute gpu-blast
$gpublast_bin/blastp -query $gpublast_data/samples/queries/SequenceLength_00000100.txt -db $gpublast_data/samples/database/sorted_env_nr -gpu t


