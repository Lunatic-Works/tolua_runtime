#!/bin/bash

mkdir -p Plugins/macOS
cd macnojit/
xcodebuild clean
xcodebuild -configuration=Release ONLY_ACTIVE_ARCH=NO
cp -r build/Release/tolua.bundle ../Plugins/macOS/
