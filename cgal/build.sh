#!/usr/bin/env bash

# Ensure we are not using MacPorts, but the native OS X compilers
export PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin

# This is really important. Conda build sets the deployment target to 10.5 and
# this seems to be the main reason why the build environment is different in
# conda compared to compiling on the command line. Linking against libc++ does
export MACOSX_DEPLOYMENT_TARGET="10.10"

# Seems that sometimes this is required
chmod -R 777 .*

export GMP_LIBRARIES=$PREFIX/lib
export GMP_INCLUDE_DIR=$PREFIX/lib
export MPFR_LIBRARIES=$PREFIX/lib
export MPFR_INCLUDE_DIR=$PREFIX/lib

export CXXFLAGS="-arch x86_64 -fPIC"

# Setup the boost building, this is fairly simple.
cmake -DGMP_LIBRARIES="-L$PREFIX/lib -lgmp" \
    -DCGAL_CXX_FLAGS="-I$PREFIX/include" \
    -DCGAL_MODULE_LINKER_FLAGS="-L$PREFIX/lib" \
    -DCGAL_SHARED_LINKER_FLAGS="-L$PREFIX/lib" \
    -DWITH_CGAL_Qt3=OFF \
    -DWITH_CGAL_Qt4=OFF \
    -DWITH_CGAL_Qt5=OFF \
    -DWITH_CGAL_ImageIO=OFF \
    -DGMP_INCLUDE_DIR=$PREFIX/include \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    '-DCMAKE_INSTALL_RPATH=$ORIGIN/../lib' .

unset GMP_LIBRARIES GMP_INCLUDE_DIR MPFR_LIBRARIES MPFR_INCLUDE_DIR

make
make install

exit 0
