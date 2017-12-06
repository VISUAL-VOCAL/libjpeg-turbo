#!/bin/sh

SOURCE_DIRECTORY="$(dirname $0)"
cd ${SOURCE_DIRECTORY}
PWD=`pwd`
SOURCE_DIRECTORY="${PWD}"

PATH=${SOURCE_DIRECTORY}:${PATH}

XCODE=`xcode-select -print-path`
echo XCODE=${XCODE}

IOS_PLATFORMDIR=${XCODE}/Platforms/iPhoneOS.platform
echo IOS_PLATFORMDIR=IOS_PLATFORMDIR=${OS_PLATFORMDIR}

IOS_SYSROOT=($IOS_PLATFORMDIR/Developer/SDKs/iPhoneOS*.sdk)
echo IOS_SYSROOT=${IOS_SYSROOT}

DEBUG_FLAGS=-O3
INSTALL_TARGET=install-strip

# uncomment these to enable debug symbols
#DEBUG_FLAGS=-g
#INSTALL_TARGET=install

#
# ARMv7 (32-bit)
#
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/output/ios-armv7"
BUILD_DIRECTORY_ARMV7=${BUILD_DIRECTORY}

export host_alias=arm-apple-darwin10
export CC=${XCODE}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
export CFLAGS="-mfloat-abi=softfp -isysroot ${IOS_SYSROOT[0]} -arch armv7 -miphoneos-version-min=8.0 ${DEBUG_FLAGS}"
export CCASFLAGS="$CFLAGS -no-integrated-as"

cd ${SOURCE_DIRECTORY}
autoreconf -fiv
mkdir -p ${BUILD_DIRECTORY}
cd ${BUILD_DIRECTORY}
sh ${SOURCE_DIRECTORY}/configure \
  --host=${host_alias} \
  --prefix=${BUILD_DIRECTORY}/install \
  --enable-static --disable-shared \
  $*

make
make ${INSTALL_TARGET}

#
# ARMv7s (32-bit)
#
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/output/ios-armv7s"
BUILD_DIRECTORY_ARMV7S=${BUILD_DIRECTORY}

export host_alias=arm-apple-darwin10
export CC=${XCODE}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
export CFLAGS="-mfloat-abi=softfp -isysroot ${IOS_SYSROOT[0]} -arch armv7s -miphoneos-version-min=8.0 ${DEBUG_FLAGS}"
export CCASFLAGS="$CFLAGS -no-integrated-as"

cd ${SOURCE_DIRECTORY}
autoreconf -fiv
mkdir -p ${BUILD_DIRECTORY}
cd ${BUILD_DIRECTORY}
sh ${SOURCE_DIRECTORY}/configure \
  --host=${host_alias} \
  --prefix=${BUILD_DIRECTORY}/install \
  --enable-static --disable-shared \
  $*

make
make ${INSTALL_TARGET}

#
# ARMv8 (64-bit)
#
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/output/ios-armv8"
BUILD_DIRECTORY_ARMV8=${BUILD_DIRECTORY}

export host_alias=aarch64-apple-darwin
export CC=${XCODE}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
export CFLAGS="-isysroot ${IOS_SYSROOT[0]} -arch arm64 -miphoneos-version-min=8.0 -funwind-tables ${DEBUG_FLAGS}"

cd ${SOURCE_DIRECTORY}
autoreconf -fiv
mkdir -p ${BUILD_DIRECTORY}
cd ${BUILD_DIRECTORY}
sh ${SOURCE_DIRECTORY}/configure \
  --host=${host_alias} \
  --prefix=${BUILD_DIRECTORY}/install \
  --enable-static --disable-shared \
  $*

make
make ${INSTALL_TARGET}

#
# Unified multi-architecture library
#
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/output/ios-all"
LIBNAME=libjpeg.a
cd ${SOURCE_DIRECTORY}
mkdir -p ${BUILD_DIRECTORY}
lipo -create -output ${BUILD_DIRECTORY}/${LIBNAME} \
  -arch armv7 ${BUILD_DIRECTORY_ARMV7}/install/lib/${LIBNAME} \
  -arch armv7s ${BUILD_DIRECTORY_ARMV7S}/install/lib/${LIBNAME} \
  -arch arm64v8 ${BUILD_DIRECTORY_ARMV8}/install/lib/${LIBNAME}

