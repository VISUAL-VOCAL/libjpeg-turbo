#!/bin/sh

SOURCE_DIRECTORY="$(dirname $0)"
cd ${SOURCE_DIRECTORY}
PWD=`pwd`
SOURCE_DIRECTORY="${PWD}"
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/build/android"

NDK_PATH="${SOURCE_DIRECTORY}/../ndk/android-ndk-r18b"
TOOLCHAIN="${SOURCE_DIRECTORY}/../ndk/toolchains/r18b-arm-24"
SYSROOT="${TOOLCHAIN}/sysroot"
BUILD_PLATFORM="linux-x86_64"
TOOLCHAIN_VERSION="4.9"
ANDROID_VERSION="24"

mkdir -p ${BUILD_DIRECTORY}
cd ${BUILD_DIRECTORY}
cmake -G"Unix Makefiles" \
  -DANDROID_ABI=armeabi-v7a \
  -DANDROID_ARM_MODE=arm \
  -DANDROID_PLATFORM=android-${ANDROID_VERSION} \
  -DANDROID_TOOLCHAIN=${TOOLCHAIN} \
  -DCMAKE_ASM_FLAGS="--target=arm-linux-androideabi${ANDROID_VERSION}" \
  -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
  -DCMAKE_INSTALL_PREFIX=install \
  -DENABLE_STATIC=TRUE -DENABLE_SHARED=FALSE \
  -DWITH_SIMD=TRUE \
  ${SOURCE_DIRECTORY}
cmake --build .
cmake --build . --target install/strip
