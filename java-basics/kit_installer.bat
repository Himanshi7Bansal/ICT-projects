@echo off
setlocal ENABLEDELAYEDEXPANSION
CALL :start_spinner
ECHO======================================================================================
ECHO		Kandi kit installation process has begun
ECHO  ==============================================================
ECHO 	This kit installer works only on Windows OS
ECHO 	Based on your network speed, the installation may take a while
ECHO======================================================================================
SET KIT_NAME=java-basics
REM update below path if required
SET JAVA_LOCATION=C:\kandikits\java
SET JAVA_HOME=%JAVA_LOCATION%\jdk-17.0.7
SET WORKING_DIR=C:\kandikits\!KIT_NAME!
SET JAVA_DOWNLOAD_URL=https://download.oracle.com/java/17/archive/jdk-17.0.7_windows-x64_bin.zip
SET REPO_DOWNLOAD_URL=https://github.com/kandi1clickkits/java-basics/releases/download/v1.0.0/java-basics.zip
SET REPO_NAME=java-basics.zip
SET EXTRACTED_REPO_DIR=java-basics
SET FILE_NAME=Banking.java
SET ERROR_MSG=ERROR:There was an error while installing the kit
SET LOG_REDIRECT_LOCATION=!WORKING_DIR!\log.txt 2>&1
IF EXIST "!WORKING_DIR!\log.txt" (
    DEL !WORKING_DIR!\log.txt
)
IF EXIST !WORKING_DIR!\ (
    CALL :LOG "!WORKING_DIR! already exists"
) ELSE (
    mkdir !WORKING_DIR!
)

CD /D !WORKING_DIR!
SET STARTTIME=%TIME%
CALL :LOG "START TIME : %TIME%"
TITLE Installing %KIT_NAME% kit 5%% 

CALL :Main
CALL :exit_spinner
ECHO "%KIT_NAME% kit installed at location : !WORKING_DIR!"
SET ENDTIME=%TIME%
CALL :LOG "END TIME : %TIME%"

SET /P CONFIRM=Would you like to run the kit (Y/N)?
IF /I "%CONFIRM%" NEQ "Y" (
	ECHO 	To run the kit, follow further instructions of the kit in kandi	
	ECHO==========================================================================
) ELSE (
	ECHO kit starting...
	ECHO 	Extracting the repo ...	
	ECHO TO QUIT PRESS CTRL+C
	ECHO==========================================================================
	tar -xvf %REPO_NAME% 
	cd %EXTRACTED_REPO_DIR%
	%JAVA_HOME%\bin\javac %FILE_NAME%
	%JAVA_HOME%\bin\java %FILE_NAME%
)
PAUSE
EXIT /B %ERRORLEVEL%

:Main
	ECHO 1. Installing JDK and Java 
	TITLE Installing %KIT_NAME% kit 25%% 
	CALL :Install_java_and_modules
	CALL :Download_repo
	TITLE Installing %KIT_NAME% kit 100%% 

EXIT /B 0

:Download_repo
bitsadmin /transfer repo_download_job /download %REPO_DOWNLOAD_URL% "%cd%\%REPO_NAME%" >> !WORKING_DIR!\log.txt 2>&1
ECHO 3.	The repo has been downloaded successfully
TITLE Installing %KIT_NAME% kit 75%% 

EXIT /B 0


:Install_java_and_modules
CALL :LOG "Downloading java \ ... "
REM MKDIR "!WORKING_DIR!\java" >> !WORKING_DIR!\log.txt 2>&1
curl --output "!WORKING_DIR!\jdk-17.zip" %JAVA_DOWNLOAD_URL% >> !WORKING_DIR!\log.txt 2>&1
IF ERRORLEVEL 1 (
    EXIT /B 1
)
CALL :LOG "Installing Java %JAVA_VERSION% ..."
REM CD "!WORKING_DIR!\java"
MKDIR "%JAVA_LOCATION%" >> !WORKING_DIR!\log.txt 2>&1
MOVE jdk-17.zip %JAVA_LOCATION%
CD %JAVA_LOCATION%
tar -xvf "jdk-17.zip" >> !WORKING_DIR!\log.txt 2>&1
IF ERRORLEVEL 1 (
	SET ERROR_MSG=ERROR: While extracting python-%PY_VERSION%-embed-amd64.zip
	CALL :Show_Error_And_Exit
)

DEL "jdk-17.zip" >> !WORKING_DIR!\log.txt 2>&1

SET PATH=!JAVA_HOME!\bin;!PATH!

ECHO 2. Java JDK installed in path : %JAVA_LOCATION%
TITLE Installing %KIT_NAME% kit 50%% 


CD !WORKING_DIR!

IF ERRORLEVEL 1 (
	SET ERROR_MSG=ERROR: There was an error!
	CALL :Show_Error_And_Exit
	EXIT /B 1
)
EXIT /B 0

:Show_Error_And_Exit
ECHO !ERROR_MSG!
CALL :exit_spinner
CALL :exit_spinner
CALL :LOG "!ERROR_MSG!"
ECHO Please look at the log at !WORKING_DIR!\log.txt for more details
PAUSE
ECHO Exiting..
EXIT

:LOG
ECHO %~1 >> !WORKING_DIR!\log.txt 2>&1

::spinner
exit /b
:start_spinner
if defined __spin__ goto spin
set "__spin__=1"
for %%i in (v2Forced vtEnabled cursorHide cursorShow colorYellow colorGreen colorRed colorReset) do set "%%i="

for /f "tokens=3" %%i in ('2^>nul reg query "HKCU\Console" /v "ForceV2"') do set /a "v2Forced=%%i"
if "!v2Forced!" neq "0" for /f "tokens=2 delims=[]" %%i in ('ver') do for /f "tokens=2-4 delims=. " %%j in ("%%i") do (
  if %%j gtr 10 (
    set "vtEnabled=1"
  ) else if %%j equ 10 (
    if %%k gtr 0 (set "vtEnabled=1") else if %%l geq 10586 set "vtEnabled=1"
  )
)
if defined vtEnabled (
  for /f %%i in ('echo prompt $e^|cmd') do set "esc=%%i"
  set "cursorHide=!esc![?25l" &set "cursorShow=!esc![?25h"&set "colorYellow=!esc![33m" &set "colorGreen=!esc![32m" &set "colorRed=!esc![31m" &set "colorReset=!esc![m"
)

for /f %%i in ('copy /z "%~f0" nul') do set "cr=%%i"
for /f %%i in ('echo prompt $h^|cmd') do set "bs=%%i"
>"%temp%\spinner.~tmp" type nul
start /b cmd /c ""%~fs0" spin"
exit /b

:exit_spinner
del "%temp%\spinner.~tmp"
set "__spin__="
>nul ping -n 1 localhost
echo(!cr!  - - -!colorGreen!        Completed        !colorYellow!- - -  !colorReset!!cursorShow!
echo(
exit /b

:spin
echo(!cursorHide!!colorYellow!
for /l %%i in () do for %%j in ("\ | / -" "| / - \" "/ - \ |" "- \ | /") do for /f "tokens=1-4" %%k in (%%j) do (
  <nul set /p "=!bs!!cr!  %%k "
  >nul ping -n 1 localhost
  if not exist "%temp%\spinner.~tmp" exit
)