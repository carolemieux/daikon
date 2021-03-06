@ECHO OFF

REM daikonenv.bat
REM Set up environment variables to run Daikon in a Windows NT command window.
REM (This file should be kept in synch with daikon.bashrc and daikon.cshrc.)

REM Wherever you source this file, you should set two environment variables:
REM   DAIKONDIR      absolute pathname of the "daikon" directory
REM   JAVA_HOME      absolute pathname of the directory containing the JDK
REM Optionally, you may set the following environment variables:
REM   DAIKONCLASS_SOURCES   to any value, if you want to run Daikon from .class
REM        files, instead of the default, which is to use daikon.jar.  This is
REM        useful if you have made changes to Daikon and compiled the .java
REM        files to .class files but have not re-made the daikon.jar file.
REM You should not need to edit this file.

if "%JAVA_HOME%"=="" (
  echo JAVA_HOME environment variable is not set.
  echo Please fix this before proceeding.  Aborting daikonenv.bat .
  exit /b 2
) else (
  if not exist "%JAVA_HOME%" (
    echo JAVA_HOME is set to non-existent directory: %JAVA_HOME%
    echo Please fix this before proceeding.  Aborting daikonenv.bat .
    exit /b 2
  )
)

if "%DAIKONDIR%"=="" (
  echo DAIKONDIR environment variable is not set.
  echo Please fix this before proceeding.  Aborting daikonenv.bat .
  exit /b 2
) else (
  if not exist "%DAIKONDIR%" (
    echo DAIKONDIR is set to non-existent directory: %DAIKONDIR%
    echo Please fix this before proceeding.  Aborting daikonenv.bat .
    exit /b 2
  )
)

if "$DAIKONBIN"=="" (
  if exist "%DAIKONDIR%\bin" (
    set DAIKONBIN=%DAIKONDIR%\bin
  ) else (
    if exist "%DAIKONDIR%\scripts" (
      set DAIKONBIN=%DAIKONDIR%\scripts
    ) else (
      echo Cannot choose a value for environment variable DAIKONBIN.
      echo Please fix this before proceeding.  Aborting daikonenv.bat .
      exit /b 2
    )
  )
)

if "$PLUMEBIN"=="" (
  set PLUMEBIN=%DAIKONDIR%\plume-lib\bin
)

REM set DAIKONCLASS_SOURCES=1

REM For Windows, adjacent semicolons in CLASSPATH are harmless, but keep
REM the CPADD logic for parallelism with daikon.bashrc and daikon.cshrc.
if not "%DAIKONCLASS_SOURCES%"=="" (
  set CPADD=%DAIKONDIR%\java
) else (
  set CPADD=%DAIKONDIR%\daikon.jar
)
if not "%CLASSPATH%"=="" (
  set CLASSPATH=%CPADD%;%CLASSPATH%
) else (
  set CLASSPATH=%CPADD%
)

REM tools.jar must be on your classpath.
set CLASSPATH=%CLASSPATH%;%JAVA_HOME%\jre\lib\rt.jar;%JAVA_HOME%\lib\tools.jar

REM Add the Daikon binaries to your path
set PATH=%DAIKONBIN%;%DAIKONDIR%\front-end\java\src;%JAVA_HOME%\bin;%PATH%

REM Indicate where to find Perl modules such as util_daikon.pm.
if not "%PERLLIB%"=="" (
  set PERLLIB=%DAIKONBIN%;%PLUMEBIN%;%PERLLIB%
) else (
  set PERLLIB=%DAIKONBIN%;%PLUMEBIN%
)
