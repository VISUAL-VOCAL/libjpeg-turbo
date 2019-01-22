@echo off
setlocal

set VS150COMNTOOLS=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\Common7\Tools\
call "%VS150COMNTOOLS%VsDevCmd.bat"

path=%ProgramFiles%\NASM;%path%

set CMAKE_UWP=^
    -DCMAKE_SYSTEM_NAME=WindowsStore ^
    -DCMAKE_SYSTEM_VERSION=10.0 ^
    -DWITH_CRT_DLL=TRUE

set CMAKE_X64=^
    -G"Visual Studio 15 2017 Win64" ^
    -DCMAKE_SYSTEM_PROCESSOR=AMD64

set CMAKE_X86=^
    -G"Visual Studio 15 2017" ^
    -DCMAKE_SYSTEM_PROCESSOR=x86

set CMAKE_COMMON=^
    -DCMAKE_INSTALL_PREFIX=install

rem UWP x64
set BUILD_FOLDER=build\Windows\UWP64
if not exist %BUILD_FOLDER% mkdir %BUILD_FOLDER%
pushd %BUILD_FOLDER%
cmake %CMAKE_X64% %CMAKE_UWP% %CMAKE_COMMON% %~dp0
cmake --build . --config Debug --target INSTALL
cmake --build . --config RelWithDebInfo --target INSTALL
popd

rem UWP x86
set BUILD_FOLDER=build\Windows\UWP32
if not exist %BUILD_FOLDER% mkdir %BUILD_FOLDER%
pushd %BUILD_FOLDER%
cmake %CMAKE_X86% %CMAKE_UWP% %CMAKE_COMMON% %~dp0
cmake --build . --config Debug --target INSTALL
cmake --build . --config RelWithDebInfo --target INSTALL
popd

:desktop

rem Windows desktop x64
set BUILD_FOLDER=build\Windows\Desktop64
if not exist %BUILD_FOLDER% mkdir %BUILD_FOLDER%
pushd %BUILD_FOLDER%
cmake %CMAKE_X64% %CMAKE_COMMON% %~dp0
cmake --build . --config Debug --target INSTALL
cmake --build . --config RelWithDebInfo --target INSTALL
popd

rem Windows desktop x86
set BUILD_FOLDER=build\Windows\Desktop32
if not exist %BUILD_FOLDER% mkdir %BUILD_FOLDER%
pushd %BUILD_FOLDER%
cmake %CMAKE_X86% %CMAKE_COMMON% %~dp0
cmake --build . --config Debug --target INSTALL
cmake --build . --config RelWithDebInfo --target INSTALL
popd

:done
endlocal
