#!/bin/bash
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig":/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig
export CFLAGS="-I$PREFIX/include  -I/usr/local/include -L$PREFIX/lib -L/usr/local/lib"
export CPPFLAGS="-I${PREFIX}/include -I/usr/local/include"
export LDFLAGS="-L$PREFIX/lib -L/usr/local/lib"

./configure                 \
    --prefix=$PREFIX        \
    --disable-static        \
    --enable-gobject        \
    --disable-warnings       \
    --enable-ft             \
    --enable-ps             \
    --enable-pdf            \
    --enable-svg            \
    --disable-gtk-doc
make
make install

rm -rf $PREFIX/share

exit 0
