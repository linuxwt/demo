@echo off
setlocal enabledelayedexpansion

set APP_NAME=user-management
set SCRIPT_DIR=%~dp0
set PROJECT_DIR=%SCRIPT_DIR%..

rem ---- 默认配置 ----
if "%PORT%"=="" set PORT=8080
if "%PROFILE%"=="" set PROFILE=dev
if "%SKIP_TESTS%"=="" set SKIP_TESTS=true

rem ---- 检测 JAVA_HOME ----
if "%JAVA_HOME%"=="" (
  where java >nul 2>&1
  if !errorlevel! equ 0 (
    for /f "delims=" %%i in ('where java') do set JAVA_BIN=%%i
  ) else (
    echo Error: JAVA_HOME not set and java not found in PATH
    exit /b 1
  )
) else (
  set JAVA_BIN=%JAVA_HOME%\bin\java.exe
)

if not exist "!JAVA_BIN!" (
  echo Error: java not found at !JAVA_BIN!
  exit /b 1
)
echo [OK] JAVA_HOME=%JAVA_HOME%

rem ---- 检测 MAVEN_HOME ----
set MVN_BIN=
if not "%MAVEN_HOME%"=="" (
  set MVN_BIN=%MAVEN_HOME%\bin\mvn.cmd
) else (
  where mvn >nul 2>&1
  if !errorlevel! equ 0 (
    for /f "delims=" %%i in ('where mvn') do set MVN_BIN=%%i
  )
)

if "%MVN_BIN%"=="" (
  echo Warning: Maven not found, using mvnw wrapper...
  set MVN_BIN=%PROJECT_DIR%\mvnw.cmd
  if not exist "!MVN_BIN!" (
    echo Error: no mvnw wrapper found at !MVN_BIN!
    exit /b 1
  )
) else if not exist "!MVN_BIN!" (
  echo Error: mvn not found at !MVN_BIN!
  exit /b 1
)
echo [OK] MAVEN_HOME=%MAVEN_HOME%

rem ---- 参数化 ----
:parse_args
if "%~1"=="" goto :build_start
if "%~1"=="--profile" ( set PROFILE=%~2 & shift & shift & goto :parse_args )
if "%~1"=="--port" ( set PORT=%~2 & shift & shift & goto :parse_args )
if "%~1"=="--skip-tests" ( set SKIP_TESTS=%~2 & shift & shift & goto :parse_args )
if "%~1"=="--help" goto :print_help
if "%~1"=="-h" goto :print_help
echo Unknown option: %~1
exit /b 1

:print_help
echo Usage: %~nx0 [options]
echo   --profile ^<dev^|prod^>   Active profile (default: dev)
echo   --port ^<port^>          Server port (default: 8080)
echo   --skip-tests ^<bool^>    Skip tests (default: true)
exit /b 0

rem ---- 构建与启动 ----
:build_start
set SKIP_FLAG=
if "%SKIP_TESTS%"=="true" set SKIP_FLAG=-DskipTests

echo ^>^>^> Building %APP_NAME% (profile=%PROFILE%, port=%PORT%) ...
call "%MVN_BIN%" clean package %SKIP_FLAG% -B
if %errorlevel% neq 0 (
  echo Error: build failed
  exit /b 1
)

rem find the first non-sources jar
set JAR_FILE=
for /f "delims=" %%f in ('dir /b "%PROJECT_DIR%\target\*.jar" 2^>nul') do (
  echo %%f | findstr /v "sources" >nul
  if !errorlevel! equ 0 (
    set JAR_FILE=%PROJECT_DIR%\target\%%f
    goto :run_app
  )
)

if "%JAR_FILE%"=="" (
  echo Error: no jar found in target\
  exit /b 1
)

:run_app
echo ^>^>^> Starting %APP_NAME% ...
"%JAVA_BIN%" -jar "%JAR_FILE%" ^
  --server.port="%PORT%" ^
  --spring.profiles.active="%PROFILE%"
endlocal
