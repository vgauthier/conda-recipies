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
./bootstrap.sh --prefix="${PREFIX}"

./bootstrap.sh --prefix="${PREFIX}" \
  --with-python-version="${PY_VER}" \
  --with-python-root="${PREFIX}" \
  --with-python="${PYTHON}" \
  --libdir="${LIBRARY_PATH}" \
  --with-toolset=clang;

./b2 toolset=clang cxxflags="-std=c++11 -stdlib=libc++ -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}" \
  linkflags="-stdlib=libc++ -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}" \
  --layout=tagged \
  --without-mpi \
  stage;

./b2 install

exit 0
