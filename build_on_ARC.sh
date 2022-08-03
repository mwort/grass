
cd $(realpath .)

installdir=$PROJECT_ROOT/bin

git pull

module purge

module load \
    zlib/1.2.11-GCCcore-10.2.0 \
    zstd/1.4.5-GCCcore-10.2.0 \
    bzip2/1.0.8-GCCcore-10.2.0 \
    PROJ/7.2.1-GCCcore-10.2.0 \
    GDAL/3.2.1-fosscuda-2020b \
    cairo/1.16.0-GCCcore-10.2.0 \
    GEOS/3.9.1-GCC-10.2.0 \
    netCDF/4.7.4-iimpi-2020b
module unload Python/3.8.6-GCCcore-10.2.0 SciPy-bundle/2020.11-fosscuda-2020b
module -q load OpenSSL/1.1.1h-GCCcore-10.2.0

# install conda environment with wxpython
conda create -p $installdir/conda/grass-gui
source activate $installdir/conda/grass-gui
conda install wxpython matplotlib ipython pillow argcomplete pandas svn


make clean

CFLAGS=-O2 LDFLAGS="-s" ./configure --prefix=$installdir \
    --enable-largefile \
    --without-opengl \
    --with-readline \
    --with-openmp \
    --with-geos \
    --with-netcdf

make -j 16


# issue in python/libgrass_interface_generator, solved by:
#module unload zlib zstd PROJ GDAL cairo GEOS netCDF
#make

# install
make install

