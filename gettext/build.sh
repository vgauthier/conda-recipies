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
#export LDFLAGS="-L${PREFIX}/lib"
export LDFLAGS="-L${PREFIX}/lib"
export CPPFLAGS="-I${PREFIX}/include"

./configure --prefix="${PREFIX}" \
    --disable-dependency-tracking \
    --disable-silent-rules \
    --disable-debug \
    --with-included-gettext \
    --with-included-glib \
    --with-included-libcroco \
    --with-included-libunistring \
    --without-included \
    --disable-java \
    --disable-csharp \
    --without-git \
    --without-cvs \
    --without-xz \

make
make install

exit 0
