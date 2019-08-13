#!/bin/sh

SOURCE_DIRECTORY="$(dirname $0)"
cd ${SOURCE_DIRECTORY}
PWD=`pwd`
SOURCE_DIRECTORY="${PWD}"
NDK_PATH="${ANDROID_HOME}/android-ndk-r20"
TOOLCHAIN="clang"

#
# armeabi-v7a (32-bit)
#
echo ""
echo "Building armeabi-v7a ..."
echo ""

# Current minimum required version for Vv app is 19 aka KitKat:
ANDROID_VERSION="19"
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/build/android/armeabi-v7a"

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
cmake --build . --target install/strip

echo ""
echo "Build completed for armeabi-v7a!"

#
# arm64-v8a (64-bit)
#
echo ""
echo "Building arm64-v8a ..."
echo ""

# Minimum required Android version than can run on 64bit hardware is 21 aka Lollipop --  older hardware will never see this binary.
ANDROID_VERSION="21"
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/build/android/arm64-v8a"

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
cmake --build . --target install/strip

echo ""
echo "Build completed for arm64-v8a!"
