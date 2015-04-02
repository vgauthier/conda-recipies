#!/bin/bash

export CFLAGS="-I$PREFIX/include -L$PREFIX/lib"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

./configure                 \
    --prefix=$PREFIX        \
    --disable-static        \
    --disable-gobject       \
    --enable-warnings       \
    --enable-ft             \
    --enable-ps             \
    --enable-pdf            \
    --enable-svg            \
    --disable-gtk-doc
make
make install

rm -rf $PREFIX/share

exit 0
