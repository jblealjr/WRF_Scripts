#!/bin/bash

## WRF installation with parallel process (Part 01/03).
# Download and install required library and data files for WRF.
# Built in 64-bit system - Last edited: Dec 2024

#############################basic package managment############################
#sudo apt -y update
#sudo apt -y upgrade
#sudo apt -y install --install-recommends --install-suggests build-essential gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git ncview python3 python3-dev mlocate curl cmake libcurl4-openssl-dev clang perl
#sudo apt -y install --install-recommends --install-suggests libsz2 zlib1g libnetcdf-c++4 libnetcdf-c++4-dev libnetcdff-dev netcdf-bin ncview libpnetcdf-dev libhdf5-dev libhdf5-hl-100 libjpeg-dev libpng-dev mpich libhdf5-mpich-dev flex bison libopenmpi-dev libhdf5-openmpi-dev

############################## Preparing the Directory Environmet ############################
export HOME=/home/wrf
mkdir -p $HOME/WRF
cd $HOME/WRF
mkdir -p Downloads
mkdir -p Libs
rm -rf $HOME/WRF/Libs/*

############################## Downloading Libraries ############################
cd $HOME/WRF/Downloads
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

############################# Setting GNU Compilers and ENV Vars ############################
export DIR=$HOME/WRF/Libs
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran
export FCFLAGS="-m64"
export FFLAGS="-m64"
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include
export NETCDF=/usr
export HDF5=/usr/lib/x86_64-linux-gnu/hdf5/serial
export LDFLAGS="-L/usr/lib/x86_64-linux-gnu/hdf5/serial/ -L/usr/lib"
export CPPFLAGS="-I/usr/include/hdf5/serial/ -I/usr/include"
export LD_LIBRARY_PATH=/usr/lib
export FLEX_LIB_DIR=/usr/lib/x86_64-linux-gnu

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

cd $HOME
chown -R wrf:wrf WRF

#Proceed to script #02...
