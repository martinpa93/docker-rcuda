#!/bin/bash
## HOWTORUN magma ##

# Most testers accept ngpu -1 to test the multi-GPU code on a single GPU. (Using ngpu 1 will usually invoke the single-GPU code.)
# Go to samples directory unless the python script dont found the tests
cd $topdir/testing
#python2 run_tests.py [--small | --medium | --large] [--tol 100] [--ngpu 2]
python2 run_tests.py --medium --tol 100 --p sd --ngpu 1

# Another test:
# python2 run_tests.py --lu --precision s --small

# Run a functional test:
# ./testing_zunmql_gpu --ngpu 2 --nthread 12 --medium --tol 100
