#!/bin/bash

# Ensure we are not using MacPorts, but the native OS X compilers
export PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin

# Seems that sometimes this is required
chmod -R 777 .*

export BZIP2_INCLUDE="${PREFIX}/include"
export BZIP2_LIBPATH="${PREFIX}/lib"
export ZLIB_INCLUDE="${PREFIX}/include"
export ZLIB_LIBPATH="${PREFIX}/lib"

# This is really important. Conda build sets the deployment target to 10.5 and
# this seems to be the main reason why the build environment is different in
# conda compared to compiling on the command line. Linking against libc++ does
export MACOSX_DEPLOYMENT_TARGET="10.5"

# Setup the boost building, this is fairly simple.

mkdir -vp ${PREFIX}/lib;
mkdir -vp ${PREFIX}/bin;

export LIBRARY_PATH="${PREFIX}/lib"

if [ $(uname) == Darwin ]; then
  export MACOSX_VERSION_MIN=10.8
  export CXXFLAGS="-mmacosx-version-min=${MACOSX_VERSION_MIN}" #-arch x86_64 -fPIC
  export CXXFLAGS="${CXXFLAGS} -std=c++11 -stdlib=libc++"
  export LINKFLAGS="-mmacosx-version-min=${MACOSX_VERSION_MIN}"
  export LINKFLAGS="${LINKFLAGS} -stdlib=libc++ -L${LIBRARY_PATH} -L${LIBRARY_PATH} -Wl,-headerpad_max_install_names"
  export INCLUDE_PATH="${PREFIX}/include"

  # --without-libraries="mpi,log,wave,context,coroutine" \
  ./bootstrap.sh --prefix="${PREFIX}" \
    --with-python-version="${PY_VER}" \
    --with-python-root="${PREFIX}" \
    --with-python="${PYTHON}/bin/python3" \
    --with-libraries="python,graph,regex,thread,iostreams,math,graph_parallel" \
    --with-toolset=clang \
    --without-icu \
    address-model=64 \
    --libdir="${LIBRARY_PATH}";

  sed -i'.bak' -e's/^using python.*;//' ./project-config.jam

  export PY_PREFIX=`$PYTHON -c "from __future__ import print_function; import sys; print(sys.prefix)"`
  export PY_INC=`$PYTHON -c "from __future__ import print_function; import distutils.sysconfig; print(distutils.sysconfig.get_python_inc(True))"`

  #echo "using darwin : clang++ ;\n" >> ./project-config.jam
  #echo "using mpi ;" >> ./project-config.jam
  echo "using python" >> ./project-config.jam
  echo "     : $PY_VER" >> ./project-config.jam
  echo "     : $PYTHON" >> ./project-config.jam
  echo "     : $PY_INC" >> ./project-config.jam
  echo "     : $PY_PREFIX/lib" >> ./project-config.jam
  echo "     ;" >> ./project-config.jam

  ./b2 headers
  #--with-mpi \
  ./b2 \
    address-model=32_64 \
    architecture=x86 \
    pch=off \
    toolset=clang \
    link=shared,static \
    threading=multi,single \
    include="${PREFIX}/include/python3.4m" \
    cxxflags="${CXXFLAGS}" \
    linkflags="${LINKFLAGS}" \
    python="${PY_VER}" \
    --layout=tagged \
    -d2 \
    -j8 \
    --user-config=project-config.jam \
    install;
fi

exit 0
