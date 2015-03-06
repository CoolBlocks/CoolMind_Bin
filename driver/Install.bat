@echo off
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    echo "OS is 64bit"
    set dpinst=dpinst-amd64.exe
) else (
    echo "OS is 32bit"
    set dpinst=dpinst-x86.exe
)

rem call :BatchGotAdmin

:BatchGotAdmin
:-------------------------------------
REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges...
goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
exit /B

:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%CD%"
CD /D "%~dp0"
:--------------------------------------

rem win8
ver |find "6.3" && ( 
  echo Win8
  bcdedit.exe -set loadoptions DDISABLE_INTEGRITY_CHECKS
) || (
  Echo Not Win8
)

:installDriver
rem cd driver

for /D %%i in (*) do (
	echo  %%i
	%dpinst% /PATH "%%i" /A /Q
)
pause
Goto :eof

rem for /F %%i in ('dir . /ad /b /W /N') do (
rem    echo  %%i
rem )

echo %dpinst%
rem call %dpinst% /A
call %dpinst% /PATH "./CoolMakers FTDI_VCP_Win2K_XP_Vista/" /A
call %dpinst% /PATH "./CoolMakers CP210x_VCP_Windows/" /A

pause