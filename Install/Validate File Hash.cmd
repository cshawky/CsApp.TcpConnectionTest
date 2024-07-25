@ECHO OFF
REM ------------------------------------------------------------------------------------------------

SET APPNAME=GetFileHash
SET VERSION=2017.2.4
SET UPDATEDATE=17 Feb 2021
SET AUTHOR=Chris Shawcross Sydney Water
setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION
SET BASEPATH=%~dp0

SET FILE=%BASEPATH%\Validate File Hash.ps1
SET LOG=%APPNAME% Hash Results.txt
POWERSHELL.EXE -NoProfile -NoLogo -NonInteractive -ExecutionPolicy Unrestricted -File "%FILE%" > "%LOG%"

TYPE "%LOG%"

PAUSE