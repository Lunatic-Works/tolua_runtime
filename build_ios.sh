#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIPO="xcrun -sdk iphoneos lipo"
STRIP="xcrun -sdk iphoneos strip"

SRCDIR=$DIR/luajit-2.1
DESTDIR=$DIR/ios
PLUGINDIR=$DIR/Plugins/iOS

IXCODE=$(xcode-select -print-path)
ISDK=$IXCODE/Platforms/iPhoneOS.platform/Developer
ISDKD=$IXCODE/Toolchains/XcodeDefault.xctoolchain
ISDKVER=iPhoneOS.sdk
ISDKP=$IXCODE/usr/bin

if [ ! -e "$ISDKP"/ar ]; then
    sudo cp "$ISDKD"/usr/bin/ar "$ISDKP"
fi

if [ ! -e "$ISDKP"/ranlib ]; then
    sudo cp "$ISDKD"/usr/bin/ranlib "$ISDKP"
fi

if [ ! -e "$ISDKP"/strip ]; then
    sudo cp "$ISDKD"/usr/bin/strip "$ISDKP"
fi

rm "$DESTDIR"/lib/*.a
cd "$SRCDIR" || exit
mkdir -p "$DESTDIR"/lib

# make clean
# ISDKF="-arch armv7 -isysroot $ISDK/SDKs/$ISDKVER -miphoneos-version-min=12.0 -fembed-bitcode"
# make HOST_CC="gcc -m32" TARGET_FLAGS="$ISDKF" TARGET=armv7 TARGET_SYS=iOS BUILDMODE=static || exit
# mv "$SRCDIR"/src/libluajit.a "$DESTDIR"/lib/libluajit-armv7.a

# make clean
# ISDKF="-arch armv7s -isysroot $ISDK/SDKs/$ISDKVER -miphoneos-version-min=12.0 -fembed-bitcode"
# make HOST_CC="gcc -m32" TARGET_FLAGS="$ISDKF" TARGET=armv7s TARGET_SYS=iOS BUILDMODE=static || exit
# mv "$SRCDIR"/src/libluajit.a "$DESTDIR"/lib/libluajit-armv7s.a

make clean
ISDKF="-arch arm64 -isysroot $ISDK/SDKs/$ISDKVER -miphoneos-version-min=12.0 -fembed-bitcode"
make HOST_CC=gcc TARGET_FLAGS="$ISDKF" TARGET=arm64 TARGET_SYS=iOS BUILDMODE=static || exit
mv "$SRCDIR"/src/libluajit.a "$DESTDIR"/lib/libluajit-arm64.a

cd "$DESTDIR" || exit
$LIPO -create "$DESTDIR"/lib/libluajit-*.a -output "$DESTDIR"/lib/libluajit.a
$STRIP -S "$DESTDIR"/lib/libluajit.a
xcodebuild clean
xcodebuild -configuration=Release

mkdir -p "$PLUGINDIR"
cp build/Release-iphoneos/libtolua.a "$PLUGINDIR"
