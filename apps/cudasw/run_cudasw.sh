#!/bin/bash
## HOWTORUN cudameme ##
cudasw_bin=$topdir/bin/cudasw
cudasw_data=$topdir/samples

# Download data
wget https://sourceforge.net/projects/cudasw/files/data/simdb.fasta.gz/download \
     https://sourceforge.net/projects/cudasw/files/data/Queries.zip/download

# For execute with single GPU:
$cudasw_bin -query $cudasw_data/Queries/P01008.fasta -db $cudasw_data/DataBases/uniprot_sprot.fasta -use_single 0

# For execute with multiple GPUs:
$cudasw_bin -query $cudasw_data/Queries/P01008.fasta -db $cudasw_data/DataBases/uniprot_sprot.fasta -num_gpus 2

