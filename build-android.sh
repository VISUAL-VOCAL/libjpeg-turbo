#!/bin/sh

SOURCE_DIRECTORY="$(dirname $0)"
cd ${SOURCE_DIRECTORY}
PWD=`pwd`
SOURCE_DIRECTORY="${PWD}"

BUILD_PLATFORM="linux-x86_64"
NDK_PATH="${SOURCE_DIRECTORY}/../ndk/android-ndk-r20"
SYSROOT="${TOOLCHAIN}/sysroot"
TOOLCHAIN_VERSION="4.9"
ANDROID_VERSION="28"

#
# ARMv7 (32-bit)
#
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/build/android/armeabi-v7a"
TOOLCHAIN="${SOURCE_DIRECTORY}/../ndk/toolchains/r20-arm-28"

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


#
# ARMv8 (64-bit)
#
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/build/android/arm64-v8a"
TOOLCHAIN="${SOURCE_DIRECTORY}/../ndk/toolchains/r20-arm64-28"

mkdir -p ${BUILD_DIRECTORY}
cd ${BUILD_DIRECTORY}
cmake -G"Unix Makefiles" \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_ARM_MODE=arm \
  -DANDROID_PLATFORM=android-${ANDROID_VERSION} \
  -DANDROID_TOOLCHAIN=${TOOLCHAIN} \
  -DCMAKE_ASM_FLAGS="--target=aarch64-linux-android${ANDROID_VERSION}" \
  -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
  -DCMAKE_INSTALL_PREFIX=install \
  -DENABLE_STATIC=TRUE -DENABLE_SHARED=FALSE \
  -DWITH_SIMD=TRUE \
  ${SOURCE_DIRECTORY}
cmake --build .
cmake --build . --target install/strip
