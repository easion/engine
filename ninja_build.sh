#!/bin/bash
set -e
RED='\033[0;31m'
NOCOLOR='\033[0m'
OUTPUT_POSTFIX=""

if [[ $(uname -m) == "arm64" ]]; then
	echo "Host: arm64"
	GN_SIM_ARGS="--simulator-cpu=arm64"
	GN_ARGS="--mac-cpu=arm64"
	OUTPUT_POSTFIX="_arm64"
else 
	echo "Host: x64"
	GN_SIM_ARGS=""
	GN_ARGS=""
	
fi

if [[ "$1" == "clean" ]]; then
	echo "Clean build ..."
	rm -rf ./out/ios_release$OUTPUT_POSTFIX
	rm -rf ./out/host_release$OUTPUT_POSTFIX
fi

if [[ "$1" == "clean" ]] || [[ ! -d ./out/ios_release$OUTPUT_POSTFIX ]]; then
	clear; ./flutter/tools/gn --ios --no-goma --runtime-mode=release $GN_ARGS
fi
ninja -C out/ios_release$OUTPUT_POSTFIX -v

if [[ "$1" == "clean" ]] || [[ ! -d ./out/host_release$OUTPUT_POSTFIX ]]; then
	clear; ./flutter/tools/gn --no-goma --no-lto --runtime-mode=release --no-prebuilt-dart-sdk $GN_ARGS
fi
ninja -C out/host_release$OUTPUT_POSTFIX