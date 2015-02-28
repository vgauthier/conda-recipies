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

export CFLAGS="-m64 -pipe -O2 -march=x86-64 -fPIC -shared"
export CXXFLAGS="${CFLAGS}"
export BZIP2_INCLUDE="${PREFIX}/include"
export BZIP2_LIBPATH="${PREFIX}/lib"
export ZLIB_INCLUDE="${PREFIX}/include"
export ZLIB_LIBPATH="${PREFIX}/lib"

# Setup the boost building, this is fairly simple.
#./bootstrap.sh --prefix="${PREFIX}"

./bootstrap.sh --prefix="${PREFIX}" \
  --with-python-version="${PY_VER}" \
  --with-python-root="${PREFIX}" \
  --with-python="${PYTHON}" \
  --libdir="${LIBRARY_PATH}" \
  --with-toolset=clang \
  --with-libraries=python,regex;

sed -i'.bak' -e's/^using python.*;//' ./project-config.jam

PY_INC=`$PYTHON -c "from distutils import sysconfig; print (sysconfig.get_python_inc(0, '$PREFIX'))"`

echo "using python" >> ./project-config.jam
echo "     : $PY_VER" >> ./project-config.jam
echo "     : $PYTHON" >> ./project-config.jam
echo "     : $PY_INC" >> ./project-config.jam
echo "     : $PREFIX/lib" >> ./project-config.jam
echo "     ;" >> ./project-config.jam

echo "################## JAM ##################"
cat ./project-config.jam
echo "#########################################"

# on the Mac, using py34 with at least conda 3.7.3 requires a symlink for the shared library:
if [ $OSX_ARCH == "x86_64" -a $PY_VER == "3.4" ]; then
  tmpd=$PWD
  cd $PREFIX/lib
  ln -s libpython3.4m.dylib libpython3.4.dylib
  cd $tmpd
  echo "# Build symbolic link to libpython3.4"
fi


./b2 -q toolset=clang address-model=64 \
  cxxflags="-std=c++11 -stdlib=libc++ -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}" \
  linkflags="-stdlib=libc++ -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}" \
  include="${PY_INC}" \
  -j8 \
  --layout=tagged \
  --with-mpi \
  --with-regex \
  --with-python \
  stage;

./b2 install

exit 0
