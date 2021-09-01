#!/bin/bash
## HOWTORUN pytorch ##

wget https://github.com/pytorch/examples.git
cd examples
./run_python_examples.sh "dcgan,fast_neural_style,imagenet,mnist,mnist_hogwild,regression,vae,word_language_model"