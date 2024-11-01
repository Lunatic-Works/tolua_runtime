#!/bin/bash

NDKDIR=/c/android-ndk-r19
NDKABI=21
NDKBIN="$NDKDIR/toolchains/llvm/prebuilt/windows-x86_64/bin"
NDKCROSS="$NDKBIN/arm-linux-androideabi-"
NDKCC="$NDKBIN/armv7a-linux-androideabi$NDKABI-clang"

cd luajit-2.1/src || exit
make clean
make -j8 \
 HOST_CC="gcc -m32 -std=gnu99" \
 CROSS="$NDKCROSS" \
 STATIC_CC="$NDKCC" \
 DYNAMIC_CC="$NDKCC -fPIC" \
 TARGET_SYS=Linux \
 TARGET_LD="$NDKCC" \
 TARGET_AR="$NDKBIN/llvm-ar rcus" \
 TARGET_STRIP="$NDKBIN/llvm-strip" \
 || exit
cp libluajit.a ../../android/jni/
cd ../..

mkdir -p Plugins/Android/armeabi-v7a
if [[ "$OSTYPE" == "msys" ]]; then
    cmd /c link_android_armeabi.bat
else
    cd android || exit
    "$NDKDIR/ndk-build" clean APP_ABI=armeabi-v7a,x86,arm64-v8a APP_PLATFORM="android-$NDKABI"
    "$NDKDIR/ndk-build" APP_ABI=armeabi-v7a APP_PLATFORM="android-$NDKABI"
    cp libs/armeabi-v7a/libtolua.so ../Plugins/Android/armeabi-v7a/
fi
