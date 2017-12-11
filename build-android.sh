#!/bin/sh

# Set these variables to suit your needs
SOURCE_DIRECTORY="$(dirname $0)"
cd ${SOURCE_DIRECTORY}
PWD=`pwd`
SOURCE_DIRECTORY="${PWD}"
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/output/android"

NDK_PATH="${SOURCE_DIRECTORY}/../ndk/android-ndk-r16"
TOOLCHAIN="${SOURCE_DIRECTORY}/../ndk/toolchains/r16-arm-19"
SYSROOT="${TOOLCHAIN}/sysroot"
BUILD_PLATFORM="linux-x86_64"
TOOLCHAIN_VERSION="4.9"
ANDROID_VERSION="19"

# It should not be necessary to modify the rest
TARGET_HOST=arm-linux-androideabi
ANDROID_CFLAGS="-fvisibility=hidden -march=armv7-a -mfloat-abi=softfp -fprefetch-loop-arrays --sysroot=${SYSROOT} -D__ANDROID_API__=${ANDROID_VERSION}"

ANDROID_INCLUDES="-I${SYSROOT}/usr/include -I${TOOLCHAIN}/lib/gcc/${TARGET_HOST}/${TOOLCHAIN_VERSION}.x/include -I${TOOLCHAIN}/prebuilt_include/clang/include"

export CC=${TOOLCHAIN}/bin/${TARGET_HOST}-clang
export CXX=${TOOLCHAIN}/bin/${TARGET_HOST}-clang++
export AR=${TOOLCHAIN}/bin/${TARGET_HOST}-ar
export RANLIB=${TOOLCHAIN}/bin/${TARGET_HOST}-ranlib
export NM=${TOOLCHAIN}/bin/${TARGET_HOST}-nm

export CPP=${TOOLCHAIN}/bin/${TARGET_HOST}-cpp
export AS=${TOOLCHAIN}/bin/${TARGET_HOST}-clang
export LD=${TOOLCHAIN}/bin/${TARGET_HOST}-ld
export OBJDUMP=${TOOLCHAIN}/bin/${TARGET_HOST}-objdump
export STRIP=${TOOLCHAIN}/bin/${TARGET_HOST}-strip

export PATH=${PATH}:${TOOLCHAIN}/bin
export NDK=${NDK_PATH}
export ANDROID_NDK_ROOT=${NDK_PATH}
export SYSROOT=${SYSROOT}

export CFLAGS="${ANDROID_INCLUDES} ${ANDROID_CFLAGS} -O3 -fPIC -pie"
export CXXFLAGS="${ANDROID_INCLUDES} ${ANDROID_CFLAGS} -O3 -fPIC -pie"
export CPPFLAGS="${ANDROID_INCLUDES} ${ANDROID_CFLAGS}"
export ASFLAGS="${ANDROID_CFLAGS}"
export LDFLAGS="${ANDROID_CFLAGS} -fPIC -pie"

cd ${SOURCE_DIRECTORY}
autoreconf -fiv
mkdir --parents ${BUILD_DIRECTORY}
cd ${BUILD_DIRECTORY}
sh ${SOURCE_DIRECTORY}/configure \
  --host=${TARGET_HOST} \
  --prefix=${BUILD_DIRECTORY}/install \
  --enable-static --disable-shared \
  CFLAGS="${CFLAGS}" \
  CPPFLAGS="${CPPFLAGS}" \
  LDFLAGS="${LDFLAGS}" \
  --with-simd ${1+"$@"}

make
make install-strip
