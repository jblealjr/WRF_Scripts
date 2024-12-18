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
export FCFLAGS=-m64
export FFLAGS=-m64
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include
export NETCDF=/usr
export HDF5=/usr/lib/x86_64-linux-gnu/hdf5/serial
export LDFLAGS="-L/usr/lib -L/usr/lib/x86_64-linux-gnu/hdf5/serial/"
export CPPFLAGS="-I/usr/include -I/usr/include/hdf5/serial/"
export LD_LIBRARY_PATH=/usr/lib
export FLEX_LIB_DIR=/usr/lib/x86_64-linux-gnu
export WRFIO_NCD_LARGE_FILE_SUPPORT=1

cd $HOME/WRF

export WRF_EM_CORE=1
export WRF_DA_CORE=0
export WRF_CHEM=0
export WRF_KPP=0

############################ WRF 4.6.1 #################################
## WRF v4.6.1
## Downloaded from git tagged releases
########################################################################

cd $HOME/WRF/Downloads

git clone --recurse-submodules https://github.com/wrf-model/WRF
mv WRF ../WRF-4.6.1
cd $HOME/WRF/WRF-4.6.1
./clean -a
./cleanCMake.sh -a
sed -i 's#$NETCDF/lib#$NETCDF/lib/x86_64-linux-gnu#g' configure
( echo 34 ; echo 1 ) | ./configure
sed -i 's#-L/usr/lib -lnetcdff #-L/usr/lib/x86_64-linux-gnu -lnetcdff #g' configure.wrf
/usr/sbin/logsave compile.log ./compile -j 4 em_real

export WRF_DIR=$HOME/WRF/WRF-4.6.1
export WRF_ROOT=$HOME/WRF/WRF-4.6.1/install   # In case o compilation using cmake

############################ WPSV4.6.0 #####################################
## WPS v4.6.0
## Downloaded from git tagged releases
########################################################################

cd $HOME/WRF/Downloads
git clone https://github.com/wrf-model/WPS 
mv WPS ../WPS-4.6.0
cd $HOME/WRF/WPS-4.6.0
./clean -a
sed -i '163s/.*/    NETCDFF="-lnetcdff"/' configure
echo 3 | ./configure
/usr/sbin/logsave compile.log ./compile
./compile

######################## ARWpost V3.1  ############################
# ARWpost
###################################################################

## Please execute these commands independently in the bash

cd $HOME/WRF/Downloads
wget -c http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
tar -xvzf ARWpost_V3.tar.gz -C $HOME/WRF
cd $HOME/WRF/ARWpost
./clean -a
sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $HOME/WRF/ARWpost/src/Makefile
echo 3 | ./configure  

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
/usr/sbin/logsave compile.log ./compile

