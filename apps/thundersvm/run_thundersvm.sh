#!/bin/bash
## HOWTORUN thundersvm ## 

# Runing the thundersvm-train
$topdir/bin/thundersvm-train -c 100 -g 0.5 $topdir/samples/test_dataset.txt
# thundersvm-train generates a local file called test_dataset.txt.model

# Runing the thundersvm-predict (It uses the local file generated by thundersvm-train)
$topdir/bin/thundersvm-predict $topdir/samples/test_dataset.txt test_dataset.txt.model test_dataset.predict
# The accuracy result must be 0.98
# thundersvm-predict generates a local file called test_dataset.predict

# Running mnist
$topdir/bin/thundersvm-train -s 0 -t 2 -g 0.125 -c 10  $topdir/samples/mnist.scale  $topdir/samples/minst.model
$topdir/bin/thundersvm-predict $topdir/samples/mnist.scale $topdir/samples/minst.model $topdir/samples/minst.predict