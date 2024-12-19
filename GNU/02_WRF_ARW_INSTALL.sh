#!/bin/bash

## WRF installation with parallel process (Part 02/03).
# Install ARWPost WRF and WPS.
# Built in 64-bit system

############## Setup environment variables ########################
export HOME=/home/wrf
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
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
#export HDF5=$DIR      # commented for the case of default libs
#export NETCDF=$DIR    # commented for the case of default libs

cd $HOME/WRF

export WRF_EM_CORE=1                 # explicitly defines which WRF model core to build - 1 => ARW
export WRF_DA_CORE=0                 # explicitly defines no data assimilation

############################ WRF 4.6 #################################
## WRF v4.6
## Downloaded from git clone
########################################################################

cd $HOME/WRF/Downloads

#wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz
#mv v4.4.2.tar.gz WRF_v4.4.2.tar.gz
#tar -xvzf WRF_v4.4.2.tar.gz
#mv WRF ../WRF-4.4.2

git clone --recurse-submodules https://github.com/wrf-model/WRF
mv WRF ../WRF-4.6.1
cd $HOME/WRF/WRF-4.6.1
./clean -a
./cleanCMake.sh -a
sed -i -e 's/WRF = "FALSE" ;/WRF = "TRUE" ;/g' $HOME/WRF/WRF-4.6.1/arch/Config.pl
sed -i -e 's/"$USENETCDFPAR" == "1"/"$USENETCDFPAR" = "1"/g' $HOME/WRF/WRF-4.6.1/configure
./configure
./compile -j 4 em_real

export WRF_DIR=$HOME/WRF/WRF-4.6.1/install
export WRF_ROOT=$HOME/WRF/WRF-4.6.1/install   # In case o compilation using cmake

############################ WPSV4.6 #####################################
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

cd $HOME/WRF/Downloads
wget -c http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
tar -xvzf ARWpost_V3.tar.gz -C $HOME/WRF
cd $HOME/WRF/ARWpost
./clean -a
sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $HOME/WRF/ARWpost/src/Makefile
./configure  

export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

export version_10="10"

if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
then
  sed -i '32s/-ffree-form -O -fno-second-underscore -fconvert=big-endian -frecord-marker=4/-ffree-form -O -fno-second-underscore -fconvert=big-endian -frecord-marker=4 -fallow-argument-mismatch /g' configure.arwp
fi

sed -i -e 's/-C -P -traditional/-P -traditional/g' $HOME/WRF/ARWpost/configure.arwp
./compile

