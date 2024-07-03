@ECHO OFF
REM ------------------------------------------------------------------------------------------------
REM Quick and nasty installer
REM

	SET APPNAME=CsApp.TcpConnectionTest
	SET UPDATEDATE=3/Jul/2024
	SET VERSION=0.1
	SET AUTHOR=https://github.com/cshawky/CsApp.TcpConnectionTest

	setlocal ENABLEEXTENSIONS
	setlocal ENABLEDELAYEDEXPANSION
	SET BASEPATH=%~dp0
	SET DOPROMPT=False
	SET ERROR=0
	
	SET SRC=%BASEPATH%%APPNAME%
	set DEST=C:\Program Files\CShawky\%APPNAME%
	SET DESKTOP=%USERPROFILE%\Desktop
	SET APP=%DEST%\%APPNAME%.exe

	CLS	
	ECHO **************************************************************************
	ECHO:
	ECHO Installer Version %VERSION% %UPDATEDATE%
	ECHO:
	ECHO Application	    %APPNAME%
	ECHO:
	ECHO Installation Path %DEST%
	ECHO:
	ECHO **************************************************************************
	ECHO:
	IF NOT EXIST "%DEST%" (
		ECHO INFO: Creating Program path...
		MKDIR "%DEST%" > NUL 2>&1
		TIMEOUT /T 5 /NOBREAK > NUL
		IF NOT EXIST "%DEST%" (
			ECHO:
			ECHO ERROR: Could not create %DEST%. 
			ECHO ERROR: Is the installer being run with administrative rights?
			ECHO:
			PAUSE
			GOTO :END
		)
	) ELSE IF EXIST "%DEST%\*.*" (
		ECHO INFO: Deleting existing installation files
		DEL /F /S /Q "%DEST%\*.*" > NUL 2>&1
		TIMEOUT /T 10 /NOBREAK > NUL
		IF EXIST "%DEST%\%APPNAME%.exe" (
			ECHO:
			ECHO ERROR: Could not delete files in %DEST%. 
			ECHO ERROR: Is the installer being run with administrative rights?
			ECHO:
			PAUSE
			GOTO :END
		)
	)

	ECHO INFO: Copying the programme to "!DEST!"
	XCOPY /I /Y "!SRC!" "!DEST!"
	ECHO INFO: Creating folder "%DESKTOP%\CsApp.TcpTests" for example usage
	XCOPY /I /Y "%BASEPATH%CsApp.TcpTests" "%DESKTOP%\CsApp.TcpTests"
	ECHO:
	ECHO INFO: Done. Enjoy
	ECHO:
	EXPLORER.EXE "%DESKTOP%\CsApp.TcpTests"
	PAUSE

REM ------------------------------------------------------------------------------------------------
:END
