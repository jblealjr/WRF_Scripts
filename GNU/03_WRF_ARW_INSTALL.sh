#!/bin/bash

## WRF installation with parallel process (Part 03/03).
# Download static geographical data.
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

######################## Static Geography Data inc/ Optional ####################
# http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
# Double check if Irrigation.tar.gz extracted into WPS_GEOG folder
# IF it didn't right click on the .tar.gz file and select 'extract here'
#################################################################################

cd $HOME/WRF/Downloads
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
mkdir $HOME/WRF/GEOG
tar -xvzf geog_high_res_mandatory.tar.gz -C $HOME/WRF/GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
tar -xvzf geog_thompson28_chem.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
tar -xvzf geog_noahmp.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
tar -xvzf irrigation.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
tar -xvzf geog_px.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
tar -xvzf geog_urban.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
tar -xvzf geog_ssib.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
tar -xvf lake_depth.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
tar -xvf topobath_30s.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
tar -xvf gsl_gwd.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/greenfrac_fpar_modis_5m.tar.bz2
tar -xvf greenfrac_fpar_modis_5m.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_5m_with_lakes.tar.bz2
tar -xvf modis_landuse_20class_5m_with_lakes.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/soiltype_bot_5m.tar.bz2
tar -xvf soiltype_bot_5m.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/soiltype_top_5m.tar.bz2
tar -xvf soiltype_top_5m.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/topo_gmted2010_5m.tar.bz2
tar -xvf topo_gmted2010_5m.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG

## export PATH and LD_LIBRARY_PATH
#echo "export PATH=$DIR/bin:${PATH}" >> ~/.bashrc
#echo "export LD_LIBRARY_PATH=$DIR/lib:${LD_LIBRARY_PATH}" >> ~/.bashrc
#echo " " >> ~/.bashrc
#echo "WRF Model" >> ~/.bashrc
#echo "export NETCDF=/home/wrf/WRF/Libs/    # all of the WRF components want both the lib and the include directories" >> ~/.bashrc
#echo "export OMP_NUM_THREADS=4             # if you have OpenMP on your system, this is how to specify the number of threads" >> ~/.bashrc
#echo "export MP_STACK_SIZE=64000000        # OpenMP blows through the stack size, set it large" >> ~/.bashrc
#echo " " >> ~/.bashrc
#echo "ulimit -s unlimited" >> ~/.bashrc



#####################################BASH Script Finished##############################
echo "Congratulations! You've successfully installed all required files to run the Weather Research Forecast Model verison 4.3.1"
echo "Thank you for using this script" 
