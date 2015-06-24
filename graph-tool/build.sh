#!/usr/bin/env bash

# Ensure we are not using MacPorts, but the native OS X compilers
export PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin

# This is really important. Conda build sets the deployment target to 10.5 and
# this seems to be the main reason why the build environment is different in
# conda compared to compiling on the command line. Linking against libc++ does
export MACOSX_DEPLOYMENT_TARGET="10.10"
export OS=osx-64

# Seems that sometimes this is required
chmod -R 777 .*

# Setup the boost building, this is fairly simple.
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig":/opt/X11/lib/pkgconfig
export CPPFLAGS="-I${PREFIX}/include"
# export LDFLAGS="-L${PREFIX}/lib -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET} -arch x86_64"
export ARCHFLAGS="-arch x86_64"
#export DYLD_FALLBACK_LIBRARY_PATH="${PREFIX}/lib"
export CXXFLAGS="-std=c++11 -stdlib=libc++"
#export PYTHON_EXTRA_LDFLAGS="-L${PREFIX}/bin"
export DYLD_LIBRARY_PATH=${prefix}/lib
export LD_LIBRARY_PATH=${prefix}/lib

# on the Mac, using py34 with at least conda 3.7.3 requires a symlink for the shared library:
if [ $OSX_ARCH == "x86_64" -a $PY_VER == "3.4" ]; then
  ( cd $PREFIX/include/pycairo && ln -s py3cairo.h pycairo.h )
  echo "# Build symbolic link from py3cairo.h"
fi

if [ $OSX_ARCH == "x86_64" -a $PY_VER == "3.3" ]; then
  ( cd $PREFIX/include/pycairo && ln -s py3cairo.h pycairo.h )
  echo "# Build symbolic link from py3cairo.h"
fi

./autogen.sh
./configure --prefix="${PREFIX}" \
  CC=/usr/bin/clang \
  CXX=/usr/bin/clang \
  CPPFLAGS="-I${PREFIX}/include" \
  CXXFLAGS="-std=c++11 -stdlib=libc++" \
  ARCHFLAGS="-arch x86_64" \
  PYTHON_EXTRA_LDFLAGS="-lpython2.7 -ldl -framework CoreFoundation -u _PyMac_Error" \
  PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:/opt/X11/lib/pkgconfig" \
  LDFLAGS="-L${PREFIX}/lib -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET} -arch x86_64 -Wl,-headerpad_max_install_names -fPIC -fno-common" \
  --disable-debug \
  --disable-dependency-tracking \
  --disable-optimization
#--with-boost="${PREFIX}/lib/" \
#--with-cgal="${PREFIX}/lib/" \
#--with-python-module-path="${PREFIX}/lib/python2.7/site-packages" \
#LDFLAGS -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET} -arch x86_64 -Wl,-headerpad_max_install_names -fPIC -fno-common
make
make install

exit 0
