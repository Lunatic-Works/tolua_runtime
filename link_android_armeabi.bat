REM @echo off
set NDKDIR=C:\android-ndk-r19
set NDKABI=21

cd android
call %NDKDIR%\ndk-build clean APP_ABI=armeabi-v7a,x86,arm64-v8a APP_PLATFORM=android-%NDKABI%
call %NDKDIR%\ndk-build APP_ABI=armeabi-v7a APP_PLATFORM=android-%NDKABI%
copy libs\armeabi-v7a\libtolua.so ..\Plugins\Android\libs\armeabi-v7a\
exit