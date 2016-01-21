#!/bin/bash

export CFLAGS="-I$PREFIX/include -L$PREFIX/lib"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"

./autogen.sh
./configure --prefix=${PREFIX}
make
make install

exit 0
