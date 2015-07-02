#!/usr/bin/env bash

# Ensure we are not using MacPorts, but the native OS X compilers
export PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin
# Seems that sometimes this is required
chmod -R 777 .*

if [ `uname` == Darwin ]; then
  # This is really important. Conda build sets the deployment target to 10.5 and
  # this seems to be the main reason why the build environment is different in
  # conda compared to compiling on the command line. Linking against libc++ does
  export MACOSX_DEPLOYMENT_TARGET="10.10"
  export MACOSX_VERSION_MIN="10.8"
  export LIBRARY_PATH="${PREFIX}/lib"
  export PYTHON_LDFLAGS="-lpython3.4m -ldl -framework CoreFoundation -framework CoreFoundation"
  export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:/opt/X11/lib/pkgconfig"
  export CXXFLAGS="-mmacosx-version-min=${MACOSX_VERSION_MIN}"
  export CXXFLAGS="${CXXFLAGS} -std=c++11 -stdlib=libc++"
  export LINKFLAGS="-mmacosx-version-min=${MACOSX_VERSION_MIN} "
  export LINKFLAGS="${LINKFLAGS} -stdlib=libc++ -L${LIBRARY_PATH} -L${PREFIX}/lib/python3.4/config-3.4m -Wl,-headerpad_max_install_names -fPIC -fno-common"
  export INCLUDE_PATH="${PREFIX}/include"

  ./autogen.sh
  ./configure --prefix="${PREFIX}" \
    CC=/usr/bin/clang \
    CXX=/usr/bin/clang \
    CPPFLAGS="-I${PREFIX}/include" \
    CXXFLAGS="${CXXFLAGS}" \
    ARCHFLAGS="-arch x86_64" \
    PYTHON_EXTRA_LDFLAGS="${PYTHON_LDFLAGS}" \
    PKG_CONFIG_PATH="${PKG_CONFIG_PATH}" \
    LDFLAGS="${LINKFLAGS}" \
    --with-boost="${LIBRARY_PATH}" \
    --disable-dependency-tracking \
    --with-python-module-path="${PREFIX}/lib/python3.4/site-packages" \
    --with-boost-python=boost_python3

  make
  make install
fi

exit 0
