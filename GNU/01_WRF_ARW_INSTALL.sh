#!/bin/bash

## WRF installation with parallel process (Part 01/03).
# Download and install required library and data files for WRF.
# Built in 64-bit system - Last edited: Jan 2024
# This script must be executed in root 


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
#wget -c -4 https://github.com/madler/zlib/archive/refs/tags/v1.2.12.tar.gz
wget -c -4 https://zlib.net/fossils/zlib-1.2.13.tar.gz
#wget -c -4 https://github.com/HDFGroup/hdf5/releases/download/hdf5-1_14_1-2/hdf5-1_14_1-2.tar.gz
#wget -c -4 https://github.com/HDFGroup/hdf5/releases/download/hdf5-1_14_3/hdf5-1_14_3.tar.gz
wget -c -4 https://github.com/HDFGroup/hdf5/releases/download/hdf5-1_12_3/hdf5-1_12_3.tar.gz
wget -c -4 https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.2.tar.gz
wget -c -4 https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz
#wget -c -4 https://sourceforge.net/projects/libpng/files/libpng16/1.6.37/libpng-1.6.37.tar.gz
#wget -c -4 https://sourceforge.net/projects/libpng/files/libpng16/1.6.39/libpng-1.6.39.tar.gz
wget -c -4 https://download.sourceforge.net/libpng/libpng-1.6.40.tar.gz
wget -c -4 https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
wget -c -4 https://www.mpich.org/static/downloads/4.2.0rc1/mpich-4.2.0rc1.tar.gz

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
cd $HOME/WRF/Downloads
tar -xvzf mpich-4.2.0rc1.tar.gz
cd mpich-4.2.0rc1/
./configure --prefix=$DIR
make
make install
#make testing

cd $HOME/WRF/Downloads
rm -rf mpich-4.2.0rc1/

############################# Build zlib ############################
cd $HOME/WRF/Downloads
tar -xvzf zlib-1.2.13.tar.gz
cd zlib-1.2.13/
./configure --prefix=$DIR
make -j 4
make install
#make check

cd $HOME/WRF/Downloads
rm -rf zlib-1.2.13/

############################# Build libpng ############################
cd $HOME/WRF/Downloads
tar -xvzf libpng-1.6.40.tar.gz
cd libpng-1.6.40/
./configure --prefix=$DIR
make -j 4
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

cd $HOME/WRF/Downloads
rm -rf jasper-1.900.1/

############################# Build HDF5 library for NETCDF4 functionality ############################
cd $HOME/WRF/Downloads
tar -xvzf hdf5-1_12_3.tar.gz
cd hdfsrc/
./configure --prefix=$DIR --with-zlib=$DIR --enable-fortran --enable-shared
make -j 4
#make check
make install
#make check-install

cd $HOME/WRF/Downloads
rm -rf hdfsrc/

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
CC=mpicc FC=mpifc F77=mpif77 F90=mpif90 CXX=mpicxx ./configure --prefix=$DIR --enable-netcdf-4 --enable-netcdf4 --enable-shared
make -j 4
#make check
make install

cd $HOME/WRF/Downloads
rm -rf netcdf-fortran-4.6.1/

#Proceed to script #02...
