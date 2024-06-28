#!/bin/bash

## WRF installation with parallel process (Part 01/03).
# Download and install required library and data files for WRF.
# Built in 64-bit system - Last edited: June 2024
# Must be executed in root environment

#############################basic package managment############################
#sudo apt -y update
#sudo apt -y upgrade
#sudo apt -y install --install-recommends --install-suggests build-essential gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git ncview python3 python3-dev mlocate curl cmake libcurl4-openssl-dev clang perl

##### Use the command below if you decide to install the default libraries - See Optional below
#sudo apt -y install --install-recommends --install-suggests libsz2 zlib1g libnetcdf-c++4 libnetcdf-c++4-dev libnetcdff-dev netcdf-bin ncview libpnetcdf-dev libhdf5-dev libhdf5-hl-100 libjpeg-dev libpng-dev mpich libhdf5-mpich-dev flex-old bison libpnetcdf-dev libnetcdf-pnetcdf-dev pnetcdf-bin

############################## Preparing the Directory Environmet ############################
export HOME=/home/wrf
mkdir -p $HOME/WRF
cd $HOME/WRF
mkdir -p Downloads
mkdir -p Libs
rm -rf $HOME/WRF/Libs/*

############################## Downloading Libraries ############################
cd $HOME/WRF/Downloads
#wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.12.tar.gz
#wget -c -4 https://zlib.net/fossils/zlib-1.2.13.tar.gz
#wget -c -4 https://zlib.net/fossils/zlib-1.3.1.tar.gz
#wget -c -4 https://sourceforge.net/projects/libpng/files/libpng16/1.6.37/libpng-1.6.37.tar.gz
#wget -c -4 https://sourceforge.net/projects/libpng/files/libpng16/1.6.39/libpng-1.6.39.tar.gz
#wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.40.tar.gz
#wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.43.tar.xz
#wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
#wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.2.tar.gz
#wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.3.tar.gz
#wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.4.tar.gz
#wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.5.tar.gz
#wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.13.tar.gz
#wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.16.tar.gz
#wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.19.tar.gz
#wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.21.tar.gz
#wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.22.tar.gz
#wget -c -4 https://src.fedoraproject.org/repo/pkgs/jasper/jasper-1.900.23.tar.gz/ed0e9a3cdc5f9a408e62df0d85876ff2/jasper-1.900.23.tar.gz
#wget -c -4 https://github.com/HDFGroup/hdf5/releases/download/hdf5-1_12_3/hdf5-1_12_3.tar.gz
#wget -c -4 https://github.com/HDFGroup/hdf5/releases/download/hdf5_1.14.4.3/hdf5-1.14.4-3.tar.gz
#wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz
#wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.2.tar.gz
#wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz
#wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz
#wget -c -4 https://www.mpich.org/static/downloads/4.2.1/mpich-4.2.1.tar.gz

############################# Setting GNU Compilers and ENV Vars ############################
export DIR=$HOME/WRF/Libs
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran
export FCFLAGS="-m64"
export FFLAGS="-m64"
export LDFLAGS=-L$DIR/lib
export CPPFLAGS=-I$DIR/include
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include
export PATH=$DIR/bin:${PATH}
export LD_LIBRARY_PATH=$DIR/lib:${LD_LIBRARY_PATH}
export HDF5=$DIR
export NETCDF=$DIR

############################# Build MPICH ############################
#cd $HOME/WRF/Downloads
#tar -xvf mpich-4.2.1.tar.gz
#cd mpich-4.2.1/
#./configure --prefix=$DIR
#make
#make install
#make testing

#cd $HOME/WRF/Downloads
#rm -rf mpich-4.2.1/

############################# Build zlib ############################
cd $HOME/WRF/Downloads
tar -xvf zlib-1.3.1.tar.gz
cd zlib-1.3.1/
./configure --prefix=$DIR
make -j 4
make install
#make check

cd $HOME/WRF/Downloads
rm -rf zlib-1.3.1/

############################# Build libpng ############################
cd $HOME/WRF/Downloads
tar -xvf libpng-1.6.43.tar.xz
cd libpng-1.6.43/
./configure --prefix=$DIR
make -j 4
make install
#make check

cd $HOME/WRF/Downloads
rm -rf libpng-1.6.43/

############################# Build JasPer ############################
cd $HOME/WRF/Downloads
unzip jasper-1.900.1.zip
cd jasper-1.900.1/
./configure --prefix=$DIR
make
make install
#make check

cd $HOME/WRF/Downloads
rm -rf jasper-1.900.1/

############################# Build HDF5 library for NETCDF4 functionality ############################
cd $HOME/WRF/Downloads
tar -xvf hdf5-1.14.4-3.tar.gz
#cd hdfsrc/
cd ./hdf5-1.14.4-3/
#CC=mpicc FC=mpifc F77=mpif77 F90=mpif90 CXX=mpicxx
./configure --prefix=$DIR --with-zlib=$DIR --enable-hl --enable-fortran --enable-shared
make -j 4
#make check
make install
#make check-install

cd $HOME/WRF/Downloads
#rm -rf hdfsrc/
rm -rf hdf5-1.14.4-3/

##############################Install NETCDF C Library############################
cd $HOME/WRF/Downloads
tar -xzvf v4.9.2.tar.gz
cd netcdf-c-4.9.2/
export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lm -ldl"
CC=mpicc CXX=mpicxx ./configure --prefix=$DIR --disable-dap --enable-shared --disable-filter-testing #--enable-netcdf-4 --enable-netcdf4
make -j 4
#make check
make install

cd $HOME/WRF/Downloads
rm -rf netcdf-c-4.9.2/

##############################NetCDF fortran library############################
cd $HOME/WRF/Downloads
tar -xvzf v4.6.1.tar.gz
cd netcdf-fortran-4.6.1/
export LIBS="-lnetcdf -lm -lcurl -lhdf5_hl -lhdf5 -lz -ldl"
#CC=mpicc FC=mpifc F77=mpif77 F90=mpif90 CXX=mpicxx
./configure --prefix=$DIR --enable-netcdf-4 --enable-netcdf4 --enable-shared
make -j 4
#make check
make install

cd $HOME/WRF/Downloads
rm -rf netcdf-fortran-4.6.1/

cd $HOME
chown -R wrf:wrf WRF

############################# Optional below ##########################################################################
############################# Build JasPer for the case of default libs (root environment) ############################
export HOME=/home/wrf
mkdir -p $HOME/WRF
cd $HOME/WRF
mkdir -p Downloads
mkdir -p Libs
rm -rf $HOME/WRF/Libs/*

#wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip

export DIR=$HOME/WRF/Libs
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran
export FCFLAGS="-m64"
export FFLAGS="-m64"
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include

cd /home/wrf/WRF/Downloads
unzip jasper-1.900.1.zip
cd jasper-1.900.1/
./configure --prefix=/home/wrf/WRF/Libs
make
make install
#make check

cd /home/wrf//WRF/Downloads
rm -rf jasper-1.900.1/

cd $HOME
chown -R wrf:wrf WRF

#Proceed to script #02...
