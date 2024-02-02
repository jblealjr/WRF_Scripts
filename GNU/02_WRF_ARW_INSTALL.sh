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
export HDF5=$DIR
export NETCDF=$DIR
export WRFIO_NCD_LARGE_FILE_SUPPORT=1

cd $HOME/WRF

export WRF_EM_CORE=1                 # explicitly defines which WRF model core to build - 1 => ARW
export WRF_DA_CORE=0                 # explicitly defines no data assimilation

############################ WRF 4.4.2 #################################
## WRF v4.4.2
## Downloaded from github releases

## See below for configure options:
#------------------------------------------------------------------------
#Please select from among the following Linux x86_64 options:
#
#  1. (serial)   2. (smpar)   3. (dmpar)   4. (dm+sm)   PGI (pgf90/gcc)
#  5. (serial)   6. (smpar)   7. (dmpar)   8. (dm+sm)   PGI (pgf90/pgcc): SGI MPT
#  9. (serial)  10. (smpar)  11. (dmpar)  12. (dm+sm)   PGI (pgf90/gcc): PGI accelerator
# 13. (serial)  14. (smpar)  15. (dmpar)  16. (dm+sm)   INTEL (ifort/icc)
#                                         17. (dm+sm)   INTEL (ifort/icc): Xeon Phi (MIC architecture)
# 18. (serial)  19. (smpar)  20. (dmpar)  21. (dm+sm)   INTEL (ifort/icc): Xeon (SNB with AVX mods)
# 22. (serial)  23. (smpar)  24. (dmpar)  25. (dm+sm)   INTEL (ifort/icc): SGI MPT
# 26. (serial)  27. (smpar)  28. (dmpar)  29. (dm+sm)   INTEL (ifort/icc): IBM POE
# 30. (serial)               31. (dmpar)                PATHSCALE (pathf90/pathcc)
# 32. (serial)  33. (smpar)  34. (dmpar)  35. (dm+sm)   GNU (gfortran/gcc)
# 36. (serial)  37. (smpar)  38. (dmpar)  39. (dm+sm)   IBM (xlf90_r/cc_r)
# 40. (serial)  41. (smpar)  42. (dmpar)  43. (dm+sm)   PGI (ftn/gcc): Cray XC CLE
# 44. (serial)  45. (smpar)  46. (dmpar)  47. (dm+sm)   CRAY CCE (ftn $(NOOMP)/cc): Cray XE and XC
# 48. (serial)  49. (smpar)  50. (dmpar)  51. (dm+sm)   INTEL (ftn/icc): Cray XC
# 52. (serial)  53. (smpar)  54. (dmpar)  55. (dm+sm)   PGI (pgf90/pgcc)
# 56. (serial)  57. (smpar)  58. (dmpar)  59. (dm+sm)   PGI (pgf90/gcc): -f90=pgf90
# 60. (serial)  61. (smpar)  62. (dmpar)  63. (dm+sm)   PGI (pgf90/pgcc): -f90=pgf90
# 64. (serial)  65. (smpar)  66. (dmpar)  67. (dm+sm)   INTEL (ifort/icc): HSW/BDW
# 68. (serial)  69. (smpar)  70. (dmpar)  71. (dm+sm)   INTEL (ifort/icc): KNL MIC
# 72. (serial)  73. (smpar)  74. (dmpar)  75. (dm+sm)   FUJITSU (frtpx/fccpx): FX10/FX100 SPARC64 IXfx/Xlfx

# option 34 for GNU (gfortran/gcc)
# option 1 for basic nesting
# large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1

########################################################################

cd $HOME/WRF/Downloads
wget -c -4 https://github.com/wrf-model/WRF/releases/download/v4.4.2/v4.4.2.tar.gz
mv v4.4.2.tar.gz WRF_v4.4.2.tar.gz
tar -xvzf WRF_v4.4.2.tar.gz
mv WRF ../WRF-4.4.2
cd $HOME/WRF/WRF-4.4.2
./clean -a
sed -i -e 's/WRF = "FALSE" ;/WRF = "TRUE" ;/g' $HOME/WRF/WRF-4.4.2/arch/Config.pl
sed -i -e 's/"$USENETCDFPAR" == "1"/"$USENETCDFPAR" = "1"/g' $HOME/WRF/WRF-4.4.2/configure
./configure	# option 34 for GNU (gfortran/gcc)
./compile -j 4 em_real

export WRF_DIR=$HOME/WRF/WRF-4.4.2

############################ WPS v4.4 #####################################
## WPS v4.4
## Downloaded from github tagged releases
# Option 3 for Linux x86_64, gfortran (dmpar)

# Please select from among the following supported platforms.

#   1.  Linux x86_64, gfortran    (serial)
#   2.  Linux x86_64, gfortran    (serial_NO_GRIB2)
#   3.  Linux x86_64, gfortran    (dmpar)
#   4.  Linux x86_64, gfortran    (dmpar_NO_GRIB2)
#   5.  Linux x86_64, PGI compiler   (serial)
#   6.  Linux x86_64, PGI compiler   (serial_NO_GRIB2)
#   7.  Linux x86_64, PGI compiler   (dmpar)
#   8.  Linux x86_64, PGI compiler   (dmpar_NO_GRIB2)
#   9.  Linux x86_64, PGI compiler, SGI MPT   (serial)
#  10.  Linux x86_64, PGI compiler, SGI MPT   (serial_NO_GRIB2)
#  11.  Linux x86_64, PGI compiler, SGI MPT   (dmpar)
#  12.  Linux x86_64, PGI compiler, SGI MPT   (dmpar_NO_GRIB2)
#  13.  Linux x86_64, IA64 and Opteron    (serial)
#  14.  Linux x86_64, IA64 and Opteron    (serial_NO_GRIB2)
#  15.  Linux x86_64, IA64 and Opteron    (dmpar)
#  16.  Linux x86_64, IA64 and Opteron    (dmpar_NO_GRIB2)
#  17.  Linux x86_64, Intel compiler    (serial)
#  18.  Linux x86_64, Intel compiler    (serial_NO_GRIB2)
#  19.  Linux x86_64, Intel compiler    (dmpar)
#  20.  Linux x86_64, Intel compiler    (dmpar_NO_GRIB2)
#  21.  Linux x86_64, Intel compiler, SGI MPT    (serial)
#  22.  Linux x86_64, Intel compiler, SGI MPT    (serial_NO_GRIB2)
#  23.  Linux x86_64, Intel compiler, SGI MPT    (dmpar)
#  24.  Linux x86_64, Intel compiler, SGI MPT    (dmpar_NO_GRIB2)
#  25.  Linux x86_64, Intel compiler, IBM POE    (serial)
#  26.  Linux x86_64, Intel compiler, IBM POE    (serial_NO_GRIB2)
#  27.  Linux x86_64, Intel compiler, IBM POE    (dmpar)
#  28.  Linux x86_64, Intel compiler, IBM POE    (dmpar_NO_GRIB2)
#  29.  Linux x86_64 g95 compiler     (serial)
#  30.  Linux x86_64 g95 compiler     (serial_NO_GRIB2)
#  31.  Linux x86_64 g95 compiler     (dmpar)
#  32.  Linux x86_64 g95 compiler     (dmpar_NO_GRIB2)
#  33.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (serial)
#  34.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (serial_NO_GRIB2)
#  35.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (dmpar)
#  36.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (dmpar_NO_GRIB2)
#  37.  Cray XC CLE/Linux x86_64, Intel compiler   (serial)
#  38.  Cray XC CLE/Linux x86_64, Intel compiler   (serial_NO_GRIB2)
#  39.  Cray XC CLE/Linux x86_64, Intel compiler   (dmpar)
#  40.  Cray XC CLE/Linux x86_64, Intel compiler   (dmpar_NO_GRIB2)

########################################################################

cd $HOME/WRF/Downloads
wget -c -4 https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz
mv v4.4.tar.gz WPS_v4.4.tar.gz
tar -xvzf WPS_v4.4.tar.gz
mv WPS-4.4/ ..
cd $HOME/WRF/WPS-4.4
./clean -a
./configure	# Option 3 for Linux x86_64, gfortran (dmpar)
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

