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
    if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -C "(Get-Item '!__DIR!') -is [System.IO.DirectoryInfo]" 1>&2
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

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _RESET=[0m
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m
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

if %_DEBUG%==1 echo %_DEBUG_LABEL% powershell -C "..." 1>&2
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
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
