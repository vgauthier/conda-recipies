#!/bin/bash

# Ensure we are not using MacPorts, but the native OS X compilers
export PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin

# Seems that sometimes this is required
chmod -R 777 .*

export CFLAGS="-m64 -pipe -O2 -march=x86-64 -fPIC -shared"
export CXXFLAGS="${CFLAGS}"
export BZIP2_INCLUDE="${PREFIX}/include"
export BZIP2_LIBPATH="${PREFIX}/lib"
export ZLIB_INCLUDE="${PREFIX}/include"
export ZLIB_LIBPATH="${PREFIX}/lib"

# This is really important. Conda build sets the deployment target to 10.5 and
# this seems to be the main reason why the build environment is different in
# conda compared to compiling on the command line. Linking against libc++ does
export MACOSX_DEPLOYMENT_TARGET="10.10"

# Setup the boost building, this is fairly simple.

mkdir -vp ${PREFIX}/lib;

./bootstrap.sh --prefix="${PREFIX}" \
  --with-python-version="${PY_VER}" \
  --with-python-root="${PREFIX}" \
  --with-python="${PYTHON}" \
  --libdir="${LIBRARY_PATH}" \
  --with-libraries=all;

sed -i'.bak' -e's/^using python.*;//' ./project-config.jam

PY_INC=`$PYTHON -c "from distutils import sysconfig; print (sysconfig.get_python_inc(0, '$PREFIX'))"`

echo "using python" >> ./project-config.jam
echo "     : $PY_VER" >> ./project-config.jam
echo "     : $PYTHON" >> ./project-config.jam
echo "     : $PY_INC" >> ./project-config.jam
echo "     : $PREFIX/lib" >> ./project-config.jam
echo "     ;" >> ./project-config.jam


if [ "$OSX_ARCH" == "" ]; then

  # Linux
  ./b2 \
    --layout=tagged \
    stage;

else

  # OSX
  export OS=osx-64

  # on the Mac, using py34 with at least conda 3.7.3 requires a symlink for the shared library:
  if [ "$OSX_ARCH" == "x86_64" -a "$PY_VER" == "3.4" ]; then
    ( cd $PREFIX/lib && ln -s libpython3.4m.dylib libpython3.4.dylib )
    echo "# Build symbolic link to libpython3.4"
  fi

  if [ "$OSX_ARCH" == "x86_64" -a "$PY_VER" == "3.3" ]; then
    ( cd $PREFIX/lib && ln -s libpython3.3m.dylib libpython3.3.dylib )
    echo "# Build symbolic link to libpython3.3"
  fi

  # address-model=64
  #   --with-toolset=clang \
  ./b2 -j4 -q toolset=clang \
    cxxflags="-std=c++11 -stdlib=libc++ -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}" \
    linkflags="-stdlib=libc++ -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}" \
    include="${PY_INC}" \
    address-model=64 \
    --with-python \
    --layout=tagged \
    stage;
fi

./b2 install

exit 0
