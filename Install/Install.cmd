@ECHO OFF
REM ------------------------------------------------------------------------------------------------
REM App Installer
REM
:INIT
SET APPNAME=CsApp.TcpConnectionTest
SET UPDATEDATE=25/Jul/2024
SET VERSION=0.1.0
SET AUTHOR=CShawky
REM ------------------------------------------------------------------------------------------------
setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION
SET BASEPATH=%~dp0
SET DOPROMPT=False
SET ERRORCODE=0
IF "%1"=="SILENT" (SET QUIET=True)
IF "%1"=="/SILENT" (SET QUIET=True)
IF "%1"=="/QUIET" (SET QUIET=True)
IF "%1"=="QUIET" (SET QUIET=True)

SET SRC=%BASEPATH%%APPNAME%
SET APPPATH=%ProgramFiles%\%AUTHOR%\%APPNAME%
SET DESKTOP=%USERPROFILE%\Desktop
SET APP=%APPPATH%\%APPNAME%.exe
SET VERREG=%BASEPATH%%APPNAME% Registration.reg

REM ------------------------------------------------------------------------------------------------
REM Set up the log
SET LOGPATH=%ProgramData%\%AUTHOR%
SET LOG=%LOGPATH%\%APPNAME%_Install.log
IF NOT EXIST "%LOGPATH%" (
	MKDIR "%LOGPATH%" > NUL 2>&1
	TIMEOUT /T 5 /NOBREAK > NUL 2>&1
)

REM ------------------------------------------------------------------------------------------------
REM Do everything to log
	IF NOT "%QUIET%"=="True" CLS	
	ECHO **************************************************************************
	ECHO:
	ECHO Installer Version %VERSION% %UPDATEDATE%
	ECHO:
	ECHO Application       %APPNAME%
	ECHO:
	ECHO Installation Path %APPPATH%
	ECHO:
	ECHO **************************************************************************
	ECHO:
	ECHO Please wait...
	ECHO:
	CALL :MAIN > "%LOG%" 2>&1
	IF NOT "%QUIET%"=="True" "%LOG%"
	GOTO :END

REM ------------------------------------------------------------------------------------------------
REM ------------------------------------------------------------------------------------------------
:MAIN
REM ------------------------------------------------------------------------------------------------
	IF NOT EXIST "%APPPATH%" (
		ECHO INFO: Creating Program path...
		MKDIR "%APPPATH%" > NUL 2>&1
		TIMEOUT /T 5 /NOBREAK > NUL
		IF NOT EXIST "%APPPATH%" (
			SET ERRORCODE=2001
			ECHO:
			ECHO ERROR: Could not create %APPPATH%. 
			ECHO ERROR: Is the installer being run with administrative rights?
			ECHO:
			GOTO :EOF
		)
	) ELSE IF EXIST "%APPPATH%\*.*" (
		ECHO INFO: Deleting existing installation files
		DEL /F /S /Q "%APPPATH%\*.*" > NUL 2>&1
		TIMEOUT /T 10 /NOBREAK > NUL
		IF EXIST "%APPPATH%\%APPNAME%.exe" (
			SET ERRORCODE=2002
			ECHO:
			ECHO ERROR: Could not delete files in %APPPATH%. 
			ECHO ERROR: Is the installer being run with administrative rights?
			ECHO:
			GOTO :EOF
		)
	)

	REM Copy application files
	ECHO INFO: Copying the programme to "%APPPATH%"
	XCOPY /I /Y "%SRC%" "%APPPATH%"
	
	REM Copy README and uninstall
	XCOPY /Y "%BASEPATH%README.html" "%APPPATH%"
	XCOPY /Y "%BASEPATH%Uninstall.cmd" "%APPPATH%"
	XCOPY /Y "%BASEPATH%~README-VERSION.txt" "%APPPATH%"
	
	REM Copy example folder setup
	ECHO INFO: Creating folder "%DESKTOP%\CsApp.TcpTests" for example usage
	XCOPY /I /Y /S /E "%BASEPATH%CsApp.TcpTests" "%DESKTOP%\CsApp.TcpTests"
	
	REM Firewall rule
	ECHO:	
	ECHO Deleting existing firewall rule
	netsh advfirewall firewall delete  rule name="!APPNAME!" 
	ECHO:
	ECHO Adding application firewall rule "!APPNAME!"
	netsh.exe advfirewall firewall add rule name="!APPNAME!" program="!APP!" protocol=any dir=in enable=yes action=allow
	
	REM ------------------------------------------------------------------------------------------------
	REM Register this installation...
	IF NOT EXIST "%VERREG%" (
		ECHO ERROR: Missing %VERREG%. Cannot register installation, aborting...
		SET ERRORCODE=1005
		GOTO :EOF
	)
	ECHO Info: Registering this installation using "%VERREG%"
	REG IMPORT "%VERREG%"
	ECHO:
	SET DISPLAYNAME=%APPNAME%
	SET REGBASE=HKLM\Software\%AUTHOR%\%DISPLAYNAME%
	REG ADD "%REGBASE%" /V Version /D "%VERSION% - %UPDATEDATE%" /F
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%DISPLAYNAME%" /V InstallDate /D "%DATECODE%" /F
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%DISPLAYNAME%" /V DisplayVersion /D "%VERSION%" /F
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%DISPLAYNAME%" /V MajorVersion /D "%MAJORVERSION%" /F
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%DISPLAYNAME%" /V MinorVersion /D "%MINORVERSION%" /F
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%DISPLAYNAME%" /V PatchVersion /D "%PATCHVERSION%" /F

	REM Version install tracking for updates
	REG ADD "%REGBASE%\Installs" /V VersionUpdate.%VERSION% /D "%UPDATEDATE%" /F
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%DISPLAYNAME%" /V VersionUpdate.%VERSION% /D "%UPDATEDATE%" /F

REM ------------------------------------------------------------------------------------------------
	
	REM DONE, display the example folder
	ECHO:
	ECHO INFO: Done. Enjoy
	ECHO:
	IF NOT "%QUIET%"=="True" EXPLORER.EXE "%DESKTOP%\CsApp.TcpTests"

	GOTO :EOF
	
REM ------------------------------------------------------------------------------------------------
REM ------------------------------------------------------------------------------------------------
:END
	IF "!ERRORCODE!"=="0" (
		ECHO Install successful...
		IF NOT "%QUIET%"=="True" TIMEOUT /T 10 /NOBREAK > NUL
	) ELSE (
		ECHO ERROR !ERRORCODE!: Install Failed...
		IF "%QUIET%"=="True" GOTO :END2
		PAUSE
	)
:END2
EXIT /B !ERRORCODE!
REM ------------------------------------------------------------------------------------------------
