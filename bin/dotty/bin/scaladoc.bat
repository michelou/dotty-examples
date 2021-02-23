@echo off
setlocal

for %%f in ("%~dp0.") do set "_ROOT_DIR=%%~dpf"

call "%_ROOT_DIR%bin\common.bat" "%_ROOT_DIR%dist\target\pack\bin\scaladoc.bat" %*
