@ECHO off

REM color 0E
REM TITLE Test

SET LUA = "lua.exe"

:CHECK
FOR %%x IN (%LUA%) DO IF NOT [%%~$PATH:x]==[] GOTO MENU

ECHO The Lua cannot be found in PATH, Please specify it manually:
SET /p LUA="Where is the Lua: "
GOTO CHECK

:MENU
ECHO Hello, %USERNAME%
ECHO What would you like to do?
ECHO.
ECHO 1. Start to build CODE NEXUS
ECHO.
ECHO 0. Quit
ECHO.

SET /p choice="Enter your choice: "
IF "%choice%" == "1" GOTO BUILD
IF "%choice%" == "0" EXIT

ECHO Invalid choice: %choice%
ECHO.
PAUSE
CLS
GOTO MENU

:BUILD
CLS
%LUA% build.lua

REM copy /b love.exe+code-nexus.love code-nexus.exe

@ECHO on