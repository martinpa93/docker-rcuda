#!/bin/bash
## HOWTORUN darknet ##
darknet_data=$topdir/samples

#donwload data
mkdir $darknet_data
cd $darknet_data
wget https://pjreddie.com/media/files/darknet19.weights

#launch classifier
$topdir/bin/darknet classifier predict $topdir/cfg/imagenet1k.data $topdir/cfg/darknet19.cfg darknet19.weights data/dog.jpg
