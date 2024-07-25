@ECHO OFF
REM ------------------------------------------------------------------------------------------------
REM APP NINSTALLER
REM
SET APPNAME=CsApp.TcpConnectionTest
SET UPDATEDATE=25/Jul/2024
SET VERSION=0.1.0
SET AUTHOR=CShawky
REM ------------------------------------------------------------------------------------------------
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
SET HOMEPATH=%~dp0
CD /d %HOMEPATH%
SET ERRORCODE=0
IF "%1"=="SILENT" (SET QUIET=True)
IF "%1"=="/SILENT" (SET QUIET=True)
IF "%1"=="/QUIET" (SET QUIET=True)
IF "%1"=="QUIET" (SET QUIET=True)

SET APPPATH=%ProgramFiles%\%AUTHOR%\%APPNAME%
SET APP=%APPNAME%.exe
SET UNINSTALL=Uninstall.cmd
SET VERREG=%APPNAME% Registration.reg

REM ------------------------------------------------------------------------------------------------
REM Set up the log
SET LOGPATH=%ProgramData%\%AUTHOR%
SET LOG=%LOGPATH%\%APPNAME%_Uninstall.log
SET LOG2=%LOGPATH%\%APPNAME%_Uninstall2.log
IF NOT EXIST "%LOGPATH%" (
	MKDIR "%LOGPATH%" > NUL 2>&1
	TIMEOUT /T 2 /NOBREAK > NUL 2>&1
)
SET P1=%APPPATH%\
SET P2=%TEMP%\%UNINSTALL%

REM ------------------------------------------------------------------------------------------------
REM Do everything to log
	IF "%P1%"=="%HOMEPATH%" (
		CALL :CREATEUNINSTALL > "%LOG2%" 2>&1
		ECHO Running "%P2%" %1 >> "%LOG2%" 2>&1
		ECHO Log File: %LOG% >> "%LOG2%" 2>&1
		CALL "%P2%" %1
	)
	CALL :MAIN  > "%LOG%" 2>&1

	IF NOT "%QUIET%"=="True" "%LOG%"
	GOTO :END

REM ------------------------------------------------------------------------------------------------
REM ------------------------------------------------------------------------------------------------
:CREATEUNINSTALL
	ECHO Info: Creating temp uninstaller
	IF NOT EXIST "%TEMP%" MKDIR "%TEMP%"
	ECHO XCOPY /Y "%UNINSTALL%" "%P2%"
	COPY /Y "Uninstall.cmd" "%P2%"
	GOTO :EOF

REM ------------------------------------------------------------------------------------------------
REM ------------------------------------------------------------------------------------------------
:MAIN

ECHO Info: %APPNAME% %UPDATEDATE% %VERSION% %AUTHOR%
ECHO Info: Uninstalling %APPNAME%...
ECHO Info: All user configuration is maintained
ECHO Info: Cleaning up registry reg delete errors may be ignored...
SET DISPLAYNAME=%APPNAME%

REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\%AUTHOR%\%DISPLAYNAME%" /F >NUL 2>&1
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%DISPLAYNAME%" /F >NUL 2>&1
REG DELETE "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" /v "%ProgramFiles%\%AUTHOR%\%APPNAME%\Uninstall.cmd.FriendlyAppName" /F >NUL 2>&1
REG DELETE "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" /v "%ProgramFiles%\%AUTHOR%\%APPNAME%\%APPNAME%.exe.FriendlyAppName" /F >NUL 2>&1

ECHO Info: Deleting firewall rule "!APPNAME!"
netsh advfirewall firewall delete  rule name="!APPNAME!" >NUL 2>&1

REM Delete the application path. This also kills the script if run from that path
RMDIR /S /Q "%APPPATH%" >NUL 2>&1
IF EXIST "%APPPATH%" (
	ECHO ERROR: Failed to uninstall %APPNAME%
        SET ERRORCODE=1001
	GOTO :END
)

REM This next command will kill this script if uninstalling from C:\Program Files or Control Panel.
REM This is fine.
IF EXIST "%P2%" (
	ECHO Info: Deleting temporary file %P2%
	DEL /F /Q "%P2%" >NUL 2>&1
)
GOTO :END

REM ------------------------------------------------------------------------------------------------
:END
	IF "!ERRORCODE!"=="0" (
		ECHO Uninstall successful...
		IF NOT "%QUIET%"=="True" TIMEOUT /T 5 /NOBREAK > NUL
	) ELSE (
		ECHO ERROR !ERRORCODE!: Uninstall Failed...
		IF "%QUIET%"=="True" GOTO :END2
		PAUSE
	)
:END2
	EXIT /B !ERRORCODE!