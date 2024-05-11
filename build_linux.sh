#!/bin/bash
# 64-bit only

cd luajit-2.1 || exit
make clean
make -j8 BUILDMODE=static CC="gcc -fPIC -m64 -O3" XCFLAGS=-DLUAJIT_ENABLE_GC64
echo -e "\n[MAINTENANCE] build libluajit.a done\n"
cd ..

mkdir -p Plugins/Linux
gcc -m64 -O3 -Wall -Wextra -Wpedantic -Wstrict-prototypes -std=gnu99 -shared \
 src/int64.c \
 src/tolua.c \
 src/uint64.c \
 -fPIC \
 -Isrc \
 -Iluajit-2.1/src \
 -Wl,--whole-archive luajit-2.1/src/libluajit.a \
 -Wl,--no-whole-archive \
 -static-libgcc -static-libstdc++ \
 -o Plugins/Linux/libtolua.so
if [ "$?" = "0" ]; then
    echo -e "\n[MAINTENANCE] build libtolua.so done"
else
    echo -e "\n[MAINTENANCE] build libtolua.so failed"
fi
