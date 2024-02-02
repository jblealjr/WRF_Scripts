#!/bin/bash

## WRF installation with parallel process (Part 01/03).
# Download and install required library and data files for WRF.
# Built in 64-bit system - Last edited: Jan 2024
# IMPORTANT: This script must be executed in root environment

#############################basic package managment############################
#sudo apt -y update
#sudo apt -y upgrade
#sudo apt -y install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git ncview python3 python3-dev mlocate curl cmake libcurl4-openssl-dev clang

############################## Preparing the Directory Environmet ############################
export HOME=/home/wrf
mkdir -p $HOME/WRF
cd $HOME/WRF
mkdir -p Downloads
mkdir -p Libs

############################## Downloading Libraries ############################
cd $HOME/WRF/Downloads
wget -c -4 https://zlib.net/fossils/zlib-1.2.13.tar.gz
#wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.12.tar.gz
wget -c -4 https://github.com/HDFGroup/hdf5/releases/download/hdf5-1_14_1-2/hdf5-1_14_1-2.tar.gz
wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.2.tar.gz
wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz
#wget -c -4 https://sourceforge.net/projects/libpng/files/libpng16/1.6.37/libpng-1.6.37.tar.gz
#wget -c -4 https://sourceforge.net/projects/libpng/files/libpng16/1.6.39/libpng-1.6.39.tar.gz
wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.40.tar.gz
wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip

############################# Setting Intel Compilers ############################
export DIR=$HOME/WRF/Libs
export CC=icx
export CXX=icpx
export FC=ifort
export F77=ifort
export F90=ifort

############################# Build zlib ############################
cd $HOME/WRF/Downloads
tar -xvzf zlib-1.2.13.tar.gz
cd zlib-1.2.13/
sudo ./configure --prefix=$DIR   # remember: one must force root environment to avoid "too hash error for ./configure"
make -j 2
make install
#make check

cd $HOME/WRF/Downloads
rm -rf zlib-1.2.13/

############################# Build libpng ############################
cd $HOME/WRF/Downloads
export LDFLAGS=-L$DIR/lib
export CPPFLAGS=-I$DIR/include
tar -xvzf libpng-1.6.40.tar.gz
cd libpng-1.6.40/
./configure --prefix=$DIR
make -j 2
make install
#make check

cd $HOME/WRF/Downloads
rm -rf libpng-1.6.40/

############################# Build JasPer ############################
cd $HOME/WRF/Downloads
unzip jasper-1.900.1.zip
cd jasper-1.900.1/
./configure --prefix=$DIR
make
make install

export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include

cd $HOME/WRF/Downloads
rm -rf jasper-1.900.1/

#############################hdf5 library for netcdf4 functionality############################
cd $HOME/WRF/Downloads
tar -xvzf hdf5-1_12_2.tar.gz
cd hdf5-1_14_1-2
CC=mpicc FC=mpifc F77=mpif77 F90=mpif90 CXX=mpicxx ./configure --prefix=$DIR --with-zlib=$DIR --enable-hl --enable-fortran
make -j 2
#make check
make install
#make check-install

export HDF5=$DIR
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH

cd $HOME/WRF/Downloads
rm -rf hdf5-hdf5-1_12_2/

##############################Install NETCDF C Library############################
cd $HOME/WRF/Downloads
tar -xzvf v4.9.2.tar.gz
cd netcdf-c-4.9.2/
export CPPFLAGS=-I$DIR/include 
export LDFLAGS=-L$DIR/lib
export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lm -ldl"
CC=mpicc FC=mpifc F77=mpif77 F90=mpif90 CXX=mpicxx ./configure --prefix=$DIR --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared
make -j 2
make install
#make check

export PATH=$DIR/bin:$PATH
export NETCDF=$DIR

cd $HOME/WRF/Downloads
rm -rf netcdf-c-4.9.0/

##############################NetCDF fortran library############################
cd $HOME/WRF/Downloads
tar -xvzf v4.6.1.tar.gz
cd netcdf-fortran-4.6.1/
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH
export LIBS="-lnetcdf -lm -lcurl -lhdf5_hl -lhdf5 -lz -ldl"
CC=mpicc FC=mpifc F77=mpif77 F90=mpif90 CXX=mpicxx ./configure --prefix=$DIR --enable-netcdf-4 --enable-netcdf4 --enable-shared
make -j 2
#make check
make install

cd $HOME/WRF/Downloads
rm -rf netcdf-fortran-4.6.0/

#Proceed to script #02...
