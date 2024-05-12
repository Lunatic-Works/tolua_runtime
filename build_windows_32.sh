#!/bin/bash

cd luajit-2.1 || exit
make clean
make -j8 BUILDMODE=static CC="gcc -fPIC -m32 -std=gnu99" || exit
cd ..

mkdir -p Plugins/Windows/32
gcc -fPIC -shared -m32 -O2 -std=gnu99 -Wall -Wextra -Wpedantic -Wstrict-prototypes \
 src/int64.c \
 src/tolua.c \
 src/uint64.c \
 -Isrc \
 -Iluajit-2.1/src \
 -Wl,--whole-archive luajit-2.1/src/libluajit.a \
 -Wl,--no-whole-archive \
 -static-libgcc \
 -o Plugins/Windows/32/tolua.dll
