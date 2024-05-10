#!/bin/bash

NDKDIR=/c/android-ndk-r19
NDKABI=21
NDKBIN="$NDKDIR/toolchains/llvm/prebuilt/windows-x86_64/bin"
NDKCROSS="$NDKBIN/aarch64-linux-android-"
NDKCC="$NDKBIN/aarch64-linux-android$NDKABI-clang"

cd luajit-2.1/src || exit
make clean
make -j8 \
 HOST_CC="gcc -m64" \
 CROSS="$NDKCROSS" \
 STATIC_CC="$NDKCC" \
 DYNAMIC_CC="$NDKCC -fPIC" \
 TARGET_SYS=Linux \
 TARGET_LD="$NDKCC" \
 TARGET_AR="$NDKBIN/llvm-ar rcus" \
 TARGET_STRIP="$NDKBIN/llvm-strip"
cp libluajit.a ../../android/jni/
cd ../..

mkdir -p Plugins/Android/libs/arm64-v8a
if [[ "$OSTYPE" == "msys" ]]; then
    cd ../../
    # can't pass $NDKDIR to bat
    # cmd /c "link_android_arm64.bat"
else
    cd android || exit
    "$NDKDIR/ndk-build" clean APP_ABI=armeabi-v7a,x86,arm64-v8a APP_PLATFORM="android-$NDKABI"
    "$NDKDIR/ndk-build" APP_ABI=arm64-v8a APP_PLATFORM="android-$NDKABI"
    cp libs/arm64-v8a/libtolua.so ../Plugins/Android/libs/arm64-v8a/
fi
