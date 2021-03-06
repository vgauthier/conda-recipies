#!/bin/bash



export CFLAGS="-I$PREFIX/include -L$PREFIX/lib"

# As of Mac OS 10.8, X11 is no longer included by default ( https://support.apple.com/en-us/HT201341 ).
# Due to this change, we disable building X11 support for cairo on Mac by default.
export XWIN_ARGS=""
if [ `uname` == Darwin ]; then
   export XWIN_ARGS="--disable-gtk-doc --disable-xlib -disable-xcb --disable-glitz"
fi


./configure                 \
    --prefix=$PREFIX        \
    --disable-static        \
    --disable-gobject       \
    --enable-warnings       \
    --enable-ft             \
    --enable-ps             \
    --enable-pdf            \
    --enable-svg            \
    --disable-gtk-doc       \
    $XWIN_ARGS
make
make install

rm -rf $PREFIX/share

exit 0
