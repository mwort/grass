
PROJECT_ROOT=/data/ouce-evoflood

ml Anaconda3/2024.02-1
ml Mamba/23.11.0-0

cd $(realpath .)

installdir=$(realpath $PROJECT_ROOT)/bin/conda/ef-base3

git pull

# install conda environment with wxpython
rm -rf $installdir
mamba env create -f ../conda_environment_base.yaml -p $installdir

# this is needed to work with the self-compiled grass
cat > $installdir/etc/conda/activate.d/env_vars.sh <<EOF
#!/bin/bash
export LD_LIBRARY_PATH=\$CONDA_PREFIX/lib:\$LD_LIBRARY_PATH
EOF
chmod +x $installdir/etc/conda/activate.d/env_vars.sh

conda deactivate
conda activate $installdir

make clean

export PKG_CONFIG_PATH="$installdir/lib/pkgconfig:$PKG_CONFIG_PATH"
export LD_LIBRARY_PATH=$installdir/lib
CFLAGS=-O2 LDFLAGS="-L$installdir/lib -liconv" ./configure \
    --prefix=$installdir \
    --with-includes=$installdir/include \
    --with-libs=$installdir/lib \
    --enable-largefile \
    --enable-shared \
    --without-opengl \
    --with-readline \
    --with-openmp \
    --with-geos \
    --with-netcdf \
    --without-pdal \
    --without-fftw

make -j 32

# install
make install
