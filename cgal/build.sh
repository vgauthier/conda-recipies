#!/usr/bin/env bash

# Ensure we are not using MacPorts, but the native OS X compilers
export PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin

# This is really important. Conda build sets the deployment target to 10.5 and
# this seems to be the main reason why the build environment is different in
# conda compared to compiling on the command line. Linking against libc++ does
export MACOSX_DEPLOYMENT_TARGET="10.10"

# Seems that sometimes this is required
chmod -R 777 .*


export BOOST_ROOT=${PREFIX}
export GMP_ROOT=${PREFIX}
export MPFR_ROOT=${PREFIX}

# Setup the boost building, this is fairly simple.
cmake -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DWITH_CGAL_Qt3=OFF \
  -DWITH_CGAL_Qt4=OFF \
  -DWITH_CGAL_ImageIO=OFF \
  -DCMAKE_LIBRARY_PATH=${PREFIX}/lib .
make
make install

exit 0
