#!/bin/sh

SOURCE_DIRECTORY="$(dirname $0)"
cd ${SOURCE_DIRECTORY}
PWD=`pwd`
SOURCE_DIRECTORY="${PWD}"
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/output/osx"

TARGET_HOST="x86_64-app-darwin"

#export CC="x86_64-w64-mingw32-gcc"
#export CXX="x86_64-w64-mingw32-g++"
#export AR="x86_64-w64-mingw32-ar"
#export RANLIB="x86_64-w64-mingw32-ranlib"
#export NM="x86_64-w64-mingw32-nm"
export NASM=/usr/local/bin/nasm

echo "$F: calling ./configure with env vars:"
echo " CC = ${CC}"
echo " CFLAGS = ${CFLAGS}"
echo " LDFLAGS = ${LDFLAGS}"
echo " CPPFLAGS = ${CPPFLAGS}"
echo " LIBS = ${LIBS}"
echo " AR = ${AR}"
echo " RANLIB = ${RANLIB}"
echo " TARGET_HOST = ${TARGET_HOST}"

cd ${SOURCE_DIRECTORY}
autoreconf -fiv
mkdir --parents ${BUILD_DIRECTORY}
cd ${BUILD_DIRECTORY}
sh ${SOURCE_DIRECTORY}/configure \
  --host=${TARGET_HOST} \
  --prefix=${BUILD_DIRECTORY}/install \
  $*

# make
# make install-strip

