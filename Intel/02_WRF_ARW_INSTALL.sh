#!/bin/bash

## WRF installation with parallel process (Part 02/03).
# Install ARWPost WRF and WPS.
# Built in 64-bit system

############## Setup environment variables ########################
export HOME=/home/wrf
export DIR=$HOME/WRF/Libs
export CC=icx
export CXX=icpx
export FC=ifx
export F77=ifx
export F90=ifx
export LDFLAGS=-L$DIR/lib
export CPPFLAGS=-I$DIR/include
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include
export PATH=$DIR/bin:${PATH}
export LD_LIBRARY_PATH=$DIR/lib:${LD_LIBRARY_PATH}
export HDF5=$DIR
export NETCDF=$DIR
export WRFIO_NCD_LARGE_FILE_SUPPORT=1

cd $HOME/WRF

export WRF_EM_CORE=1                 # explicitly defines which WRF model core to build - 1 => ARW
export WRF_DA_CORE=0                 # explicitly defines no data assimilation

############################ WRF 4.6.0 #################################
## WRF v4.6.0
## Downloaded from git clone
########################################################################

cd $HOME/WRF/Downloads

git clone --recurse-submodules https://github.com/wrf-model/WRF
mv WRF ../WRF-4.6.0
cd $HOME/WRF/WRF-4.6.0
./clean -a
./cleanCMake.sh -a
sed -i -e 's/WRF = "FALSE" ;/WRF = "TRUE" ;/g' $HOME/WRF/WRF-4.6.0/arch/Config.pl
./configure	# option 79 for intel LLVM
./compile -j 4 em_real

export WRF_DIR=$HOME/WRF/WRF-4.6.0/install
export WRF_ROOT=$HOME/WRF/WRF-4.6.0

############################WPSV4.6#####################################
## WPS v4.6
## Downloaded from git tagged releases
########################################################################

cd $HOME/WRF/Downloads
git clone https://github.com/wrf-model/WPS 
mv WPS ../WPS-4.6
cd $HOME/WRF/WPS-4.6
./clean -a
./configure	# option 17 for intel (serial)
./compile

######################## ARWpost V3.1  ############################
# ARWpost
#
# Please select from among the following supported platforms.
#
# 1.  PC Linux i486 i586 i686 x86_64, PGI compiler
# 2.  PC Linux i486 i586 i686 x86_64, Intel compiler
# 3.  PC Linux i486 i586 i686 x86_64, gfortran compiler
#
###################################################################

## Please execute these commands independently in the bash

# cd $HOME/WRF/Downloads
# wget -c http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
# tar -xvzf ARWpost_V3.tar.gz -C $HOME/WRF
# cd $HOME/WRF/ARWpost
# ./clean -a
# sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $HOME/WRF/ARWpost/src/Makefile
# ./configure  
# sed -i -e 's/-C -P/-P/g' $HOME/WRF/ARWpost/configure.arwp
# ./compile

