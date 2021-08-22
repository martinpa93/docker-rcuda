#!/bin/bash

env() {
  echo -n 'Installation host path:'
  read host_path
  checkHostPath
  echo -n 'Cores:'
  read cores
  checkCores
}

build() {
    for D in `find apps/ -maxdepth 1 -type d ! -path "apps/"`
    do
      app_name=`basename $D`
      docker build -t $app_name -f $D/$app_name.dockerfile --build-arg jobs=$cores . 
      copyToHost $app_name
    done
}

copyToHost() {
  mkdir -p $host_path/$1 
  docker create -it --name $1 $1 && \
  docker cp $1:"/install/$1/build/." $host_path/$1 && \ 
  docker rm -f $1
}

checkHostPath() {
  if [ -z "$host_path" ]; then
    host_path=test
  fi
}

checkCores() {
  if ! [ "$cores" = ^[0-9]+$ ]; then
    cores=1
  fi
}

env
build

