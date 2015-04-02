#!/bin/bash

# Ensure we are not using MacPorts, but the native OS X compilers
export PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin

# This is really important. Conda build sets the deployment target to 10.5 and
# this seems to be the main reason why the build environment is different in
# conda compared to compiling on the command line. Linking against libc++ does
export MACOSX_DEPLOYMENT_TARGET="10.10"

if [ $OSX_ARCH == "x86_64" ]; then
  export OS=osx-64
fi

echo "${PREFIX}"


export LDFLAGS="-L${PREFIX}/lib"
export DYLD_LIBRARY_PATH=${PREFIX}/lib:$DYLD_LIBRARY_PATH
export FREETYPE_CFLAGS="-I/usr/local/anaconda/envs/_build/include/freetype2 -I/usr/local/anaconda/envs/_build/include"
export FREETYPE_LIBS="-L/usr/local/anaconda/envs/_build/lib -lfreetype"

# Seems that sometimes this is required
chmod -R 777 .*

# Setup the boost building, this is fairly simple.
./configure --prefix="${PREFIX}" \
            --disable-docs \
            FREETYPE_CFLAGS="-I/usr/local/anaconda/envs/_build/include/freetype2 -I/usr/local/anaconda/envs/_build/include" \
            FREETYPE_LIBS="-L/usr/local/anaconda/envs/_build/lib -lfreetype" \
            LIBXML2_CFLAGS="-I/usr/local/anaconda/envs/_build/include/libxml2" \
            LIBXML2_LIBS="-L/usr/local/anaconda/envs/_build/lib -lxml2"
make
make install

# Remove computed cache with local fonts
rm -Rf $PREFIX/var/cache/fontconfig
rm -Rf $PREFIX/etc/fonts/conf.d

#/usr/local/anaconda/pkgs/fontconfig-2.11.93-py27_1/etc/fonts/conf.d/10-scale-bitmap-fonts.conf

# Leave cache directory, in case it's needed
mkdir -p $PREFIX/var/cache/fontconfig
touch $PREFIX/var/cache/fontconfig/.leave

exit 0
