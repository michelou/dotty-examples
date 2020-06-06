@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

for %%i in (%*) do (
    set __DIR=%%i
    set __DIR_TRUE=False
    if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -C "(Get-Item '!__DIR!') -is [System.IO.DirectoryInfo]"
    for /f %%i in ('powershell -C "(Get-Item '!__DIR!') -is [System.IO.DirectoryInfo]"') do set __DIR_TRUE=%%i
    if /i "!__DIR_TRUE!"=="True" (
        call :dir_size "!__DIR!"
        if not !_EXITCODE!==0 goto end
    ) else (
        echo %_ERROR_LABEL% !__DIR! is not a directory 1>&2
        set _EXITCODE=1
    )
)
goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0

@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
@rem background colors: 46m = Cyan (normal) 
@rem foreground colors: 32m = Green (normal),  91m = Red (strong), 93m = Yellow (strong)
set _COLOR_START=[32m
set _COLOR_END=[0m
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:
goto :eof

@rem input parameter: %1=directory path
:dir_size
set __DIR=%~1
set __DIR_SIZE=0

set __PS1_SCRIPT= ^
$total_size=[long]0; ^
Get-ChildItem '%__DIR%' -File -r -fo ^|%%{$total_size+=$_.length}; ^
If ($total_size -ge 1073741824) { $n = $total_size / 1073741824; $unit='Gb' } ^
Elseif ($total_size -ge 1048576) {  $n = $total_size / 1048576; $unit='Mb' } ^
Else { $n = $total_size/1024; $unit='Kb' } ^
Write-Host ([math]::Round($n,1))" "$unit

if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -C "..."
for /f "delims=" %%i in ('powershell -C "%__PS1_SCRIPT%"') do set __DIR_SIZE=%%i
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Execution of ps1 cmdlet failed 1>&2
    set _EXITCODE=1
    goto :eof
)
echo Size of directory "%__DIR%" is %__DIR_SIZE:,=.% %__UNIT%
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE%
exit /b %_EXITCODE%
endlocal
