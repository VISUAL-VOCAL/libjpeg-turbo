@echo off
setlocal
path=%ProgramFiles%\CMake\bin;%ProgramFiles%\NASM;%path%
if not exist output\win64vs mkdir output\win64vs
pushd output\win64vs
cmake -G"Visual Studio 15 2017 Win64" %~dp0
popd
endlocal

