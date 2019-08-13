#!/bin/sh

SOURCE_DIRECTORY="$(dirname $0)"
cd ${SOURCE_DIRECTORY}
PWD=`pwd`
SOURCE_DIRECTORY="${PWD}"

PATH=${SOURCE_DIRECTORY}:${PATH}

XCODE=`xcode-select -print-path`
echo XCODE=${XCODE}

IOS_PLATFORMDIR=${XCODE}/Platforms/iPhoneOS.platform
echo IOS_PLATFORMDIR=${IOS_PLATFORMDIR}

IOS_SYSROOT=($IOS_PLATFORMDIR/Developer/SDKs/iPhoneOS*.sdk)
echo IOS_SYSROOT=${IOS_SYSROOT}

DEBUG_FLAGS=-Os

# uncomment these to enable debug symbols
#DEBUG_FLAGS=-g


#
# ARMv8 (64-bit)
#
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/build/ios-armv8"
BUILD_DIRECTORY_ARMV8=${BUILD_DIRECTORY}

# export host_alias=aarch64-apple-darwin
# export CC=${XCODE}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
# export CFLAGS="-isysroot ${IOS_SYSROOT[0]} -arch arm64 -miphoneos-version-min=11.0 -funwind-tables ${DEBUG_FLAGS} -fembed-bitcode"

# cd ${SOURCE_DIRECTORY}
# autoreconf -fiv
# mkdir -p ${BUILD_DIRECTORY}
# cd ${BUILD_DIRECTORY}
# sh ${SOURCE_DIRECTORY}/configure \
#   --host=${host_alias} \
#   --prefix=${BUILD_DIRECTORY}/install \
#   --enable-static --disable-shared \
#   $*

# # make
# make ${INSTALL_TARGET}

export CFLAGS="-Wall -arch arm64 -miphoneos-version-min=11.0 -funwind-tables ${DEBUG_FLAGS} -fembed-bitcode"

mkdir -p ${BUILD_DIRECTORY}
cd ${BUILD_DIRECTORY}

cat <<EOF >toolchain.cmake
set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(CMAKE_C_COMPILER /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang)
EOF

cmake -G"Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
  -DCMAKE_OSX_SYSROOT=${IOS_SYSROOT[0]} \
  -DCMAKE_INSTALL_PREFIX=install \
  -DENABLE_STATIC=TRUE -DENABLE_SHARED=FALSE \
  ${SOURCE_DIRECTORY}
make install

# #
# # Unified multi-architecture library
# #
# BUILD_DIRECTORY="${SOURCE_DIRECTORY}/output/ios-all"
# LIBNAME=libjpeg.a
# cd ${SOURCE_DIRECTORY}
# mkdir -p ${BUILD_DIRECTORY}
# lipo -create -output ${BUILD_DIRECTORY}/${LIBNAME} \
#   -arch armv7 ${BUILD_DIRECTORY_ARMV7}/install/lib/${LIBNAME} \
#   -arch armv7s ${BUILD_DIRECTORY_ARMV7S}/install/lib/${LIBNAME} \
#   -arch arm64v8 ${BUILD_DIRECTORY_ARMV8}/install/lib/${LIBNAME}

