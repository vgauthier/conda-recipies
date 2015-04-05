#!/bin/bash

# Ensure we are not using MacPorts, but the native OS X compilers
export PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin

# This is really important. Conda build sets the deployment target to 10.5 and
# this seems to be the main reason why the build environment is different in
# conda compared to compiling on the command line. Linking against libc++ does
export MACOSX_DEPLOYMENT_TARGET="10.10"
export ARCHFLAGS="-arch x86_64"

if [ $OSX_ARCH == "x86_64" ]; then
  export OS=osx-64
fi

#export CFLAGS="-I$PREFIX/include -I/usr/include -L$PREFIX/lib"

# Seems that sometimes this is required
chmod -R 777 .*

# Setup the boost building, this is fairly simple.
./configure --prefix="${PREFIX}" \
            LDFLAGS="-L${PREFIX}/lib -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}" \
            ARCHFLAGS="-arch x86_64"
make
make install

exit 0
