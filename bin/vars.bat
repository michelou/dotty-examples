@echo off

for /f "delims=^= tokens=1,*" %%i in ('set ^| findstr /b "_"') do set %%i=

exit /b %ERRORLEVEL%
