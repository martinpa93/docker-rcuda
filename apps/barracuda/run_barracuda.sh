#!/bin/bash
## HOWTORUN cudameme ##

# Download and uncompress datasets
barracuda_aws=https://s3-eu-west-1.amazonaws.com/cegx-test-001/tmwg-example-files
mkdir $topdir/&& cd $topdir/samples
wget -c --no-check-certificate $barracuda_aws/SIM01_S1_L001_R1_001.fastq.gz
wget -c --no-check-certificate $barracuda_aws/SIM01_S1_L001_R2_001.fastq.gz
wget -c --no-check-certificate $barracuda_aws/SIM02_S1_L001_R1_001.fastq.gz
wget -c --no-check-certificate $barracuda_aws/SIM02_S1_L001_R2_001.fastq.gz
wget -c --no-check-certificate $barracuda_aws/SIM03_S1_L001_R1_001.fastq.gz
wget -c --no-check-certificate $barracuda_aws/SIM03_S1_L001_R2_001.fastq.gz
wget -c --no-check-certificate $barracuda_aws/SIM04-WGBS_S1_L001_R1_001.fastq.gz
wget -c --no-check-certificate $barracuda_aws/SIM04-WGBS_S1_L001_R2_001.fastq.gz
mkdir genome_refs
cd genome_refs
wget -c --no-check-certificate$barracuda_aws/hs38DH_bwameth.tar.gz
tar xzf hs38DH_bwameth.tar.gz

# Run tests:
barracuda_bin=$topdir/bin/barracuda
barracuda_data=$topdir/samples

#deviceQuery
$barracuda_bin deviceQuery
#Samples
mkdir $barracuda_data/TEST01
$barracuda_bin index $barracuda_data/sample_data/Saccharomyces_cerevisiae.SGD1.01.50.dna_rm.toplevel.fa
$barracuda_bin aln $barracuda_data/sample_data/Saccharomyces_cerevisiae.SGD1.01.50.dna_rm.toplevel.fa $barracuda_data/sample_data/sample_reads.fastq > $barracuda_data/TEST01/quicktest.sai
$barracuda_bin samse $barracuda_data/sample_data/Saccharomyces_cerevisiae.SGD1.01.50.dna_rm.toplevel.fa $barracuda_data/TEST01/quicktest.sai $barracuda_data/sample_data/sample_reads.fastq > $barracuda_data/TEST01/quicktest.sam
#1er dataset
mkdir $barracuda_data/TEST02
$barracuda_bin aln $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/SIM01_S1_L001_R1_001.fastq.gz > $barracuda_data/TEST02/SIM01_S1_L001_R1_001.sai
$barracuda_bin aln $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/SIM01_S1_L001_R2_001.fastq.gz > $barracuda_data/TEST02/SIM01_S1_L001_R2_001.sai
$barracuda_bin sampe $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/TEST02/SIM01_S1_L001_R1_001.sai $barracuda_data/TEST02/SIM01_S1_L001_R2_001.sai $barracuda_data/SIM01_S1_L001_R2_001.fastq.gz $barracuda_data/SIM01_S1_L001_R2_001.fastq.gz | gzip -c > $barracuda_data/TEST02/SIM01_S1_L001.sam.gz
#2o dataset
mkdir $barracuda_data/TEST03
$barracuda_bin aln $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/SIM02_S1_L001_R1_001.fastq.gz > $barracuda_data/TEST03/SIM02_S1_L001_R1_001.sai
$barracuda_bin aln $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/SIM02_S1_L001_R2_001.fastq.gz > $barracuda_data/TEST03/SIM02_S1_L001_R2_001.sai
$barracuda_bin sampe $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/TEST03/SIM02_S1_L001_R1_001.sai $barracuda_data/TEST03/SIM02_S1_L001_R2_001.sai $barracuda_data/SIM02_S1_L001_R2_001.fastq.gz $barracuda_data/SIM02_S1_L001_R2_001.fastq.gz | gzip -c > $barracuda_data/TEST03/SIM02_S1_L001.sam.gz
#3er dataset
mkdir $barracuda_data/TEST04
$barracuda_bin aln $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/SIM03_S1_L001_R1_001.fastq.gz > $barracuda_data/TEST04/SIM03_S1_L001_R1_001.sai
$barracuda_bin aln $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/SIM03_S1_L001_R2_001.fastq.gz > $barracuda_data/TEST04/SIM03_S1_L001_R2_001.sai
$barracuda_bin sampe $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/TEST04/SIM03_S1_L001_R1_001.sai $barracuda_data/TEST04/SIM03_S1_L001_R2_001.sai $barracuda_data/SIM03_S1_L001_R2_001.fastq.gz $barracuda_data/SIM03_S1_L001_R2_001.fastq.gz | gzip -c > $barracuda_data/TEST04/SIM03_S1_L001.sam.gz
#4o dataset
mkdir $barracuda_data/TEST05
$barracuda_bin aln $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/SIM04-WGBS_S1_L001_R1_001.fastq.gz > $barracuda_data/TEST05/SIM04-WGBS_S1_L001_R1_001.sai
$barracuda_bin aln $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/SIM04-WGBS_S1_L001_R2_001.fastq.gz > $barracuda_data/TEST05/SIM04-WGBS_S1_L001_R2_001.sai
$barracuda_bin sampe $barracuda_data/genome_refs/hs38DH_bwameth/hs38DH.fa.bwameth.c2t $barracuda_data/TEST05/SIM04-WGBS_S1_L001_R1_001.sai $barracuda_data/TEST05/SIM04-WGBS_S1_L001_R2_001.sai $barracuda_data/SIM04-WGBS_S1_L001_R2_001.fastq.gz $barracuda_data/SIM04-WGBS_S1_L001_R2_001.fastq.gz | gzip -c > $barracuda_data/TEST05/SIM04-WGBS_S1_L001.sam.gz
