        Distribution	  Kernel   GCC	GLIBC	GCC2,3	ICC3	NVHPC3	XLC3	CLANG	Arm C/C++
        ___________________________________________________________________________________
10.0    Ubuntu 18.04.1	 4.15.0	  7.3.0	 2.27         18.0           NO   6.0.0
11.0    Ubuntu 18.04.z   5.3.0    7.5.0  2.27  



For create volume(persist data and get test reports):
# docker volume create --name rCUDA

For build image:
# docker build -t $(tag) -f $(app)/$(app).dockerfile .

For run container:
# docker run -it  -v rCUDA:/data --name barracuda --gpus all --network host --rm barracuda