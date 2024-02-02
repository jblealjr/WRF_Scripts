#!/bin/bash

## WRF recompilation with parallel process (Extra).
# Recompile ARWPost WRF.
# Built in 64-bit system

############## Setup environment variables ########################
export HOME=`cd;pwd`
cd $HOME/WRF
export DIR=$HOME/WRF/Libs
export CC=icc
export CXX=icpc
export FC=ifort
export F77=ifort
export F90=ifort
export LDFLAGS=-L$DIR/lib
export CPPFLAGS=-I$DIR/include
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH
export PATH=$DIR/bin:$PATH
export HDF5=$DIR
export NETCDF=$DIR

export WRF_EM_CORE=1                 # explicitly defines which WRF model core to build
export WRF_DA_CORE=0                 # explicitly defines no data assimilation
########################################################################
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
cd $HOME/WRF/WRF-4.3.1
./compile -j 2 em_real

export WRF_DIR=$HOME/WRF/WRF-4.3.1

