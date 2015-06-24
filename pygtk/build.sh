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
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig":/usr/local/lib/pkgconfig
export LDFLAGS="-L${PREFIX}/lib -L/usr/local/lib"
export CPPFLAGS="-I/usr/local/include -I${PREFIX}/include -I${PREFIX}/include/python3.4m"
export CFLAGS="-I/usr/local/include -I${PREFIX}/include -I${PREFIX}/include/python3.4m"

# on the Mac, using py34 with at least conda 3.7.3 requires a symlink for the shared library:
if [ "$OSX_ARCH" == "x86_64" -a "$PY_VER" == "3.4" ]; then
  ( cd $PREFIX/lib && ln -s libpython3.4m.dylib libpython3.4.dylib )
  echo "# Build symbolic link to libpython3.4"
fi

./configure --prefix="${PREFIX}" --disable-dependency-tracking

make
make install

exit 0
