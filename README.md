        Distribution	  Kernel   GCC	GLIBC	GCC2,3	ICC3	NVHPC3	XLC3	CLANG	Arm C/C++
        ___________________________________________________________________________________
10.0    Ubuntu 18.04.1	 4.15.0	  7.3.0	 2.27         18.0           NO   6.0.0
11.0    Ubuntu 18.04.z   5.3.0    7.5.0  2.27  

12 applications 

For create volume:
 docker volume create --name $tag

For build image:
 docker build -t $tag -f $app/$app.dockerfile --build-arg jobs=4 --build-arg topdir=$topdir .

For run container:
 docker run -it --name $app --gpus all --network host --rm $app

Copy installation to host:
docker create -ti --name dummy IMAGE_NAME bash
docker cp dummy:/path/to/file /dest/to/file
docker rm -f dummy

To delete all containers including its volumes use:
docker rm -vf $(docker ps -a -q)

To delete all the images:
docker rmi -f $(docker images -a -q)

Easy install, run_install.sh script for build the images and copy installation to host, by default uses host folder point to ./test, rcuda folder point to /install/$app/build and one core to use during build:
./run_install.sh

Toma nota de tu versión de Docker con docker -v. Las versiones anteriores a 19.03 requieren nvidia-docker2 y la marca --runtime=nvidia. La versión 19.03 inclusive y las posteriores requieren el paquete nvidia-container-toolkit y la marca --gpus all. Puedes consultar los detalles de cada opción en la página del vínculo de más arriba.