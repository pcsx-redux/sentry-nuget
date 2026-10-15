@echo off
setlocal
rem Usage: build.bat [sentry-native version] [platform toolset, e.g. v145]
rem The Visual Studio generator is required: crashpad enables crashpad_wer only when
rem CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION is set.
set VERSION=%~1
if "%VERSION%"=="" set VERSION=0.6.1
set TOOLSET=
if not "%~2"=="" set TOOLSET=-T %~2

for /f "usebackq delims=" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -prerelease -latest -property installationPath`) do set INSTALLDIR=%%i
call "%INSTALLDIR%\Common7\Tools\vsdevcmd.bat" -arch=amd64 || exit /b 1

if exist src rmdir /s /q src
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
curl -sSfL -o sentry-native-%VERSION%.zip https://github.com/getsentry/sentry-native/releases/download/%VERSION%/sentry-native.zip || exit /b 1
mkdir src && tar -xf sentry-native-%VERSION%.zip -C src || exit /b 1

cmake -S src -B build -A x64 %TOOLSET% -DSENTRY_BACKEND=crashpad -DSENTRY_BUILD_TESTS=OFF -DSENTRY_BUILD_EXAMPLES=OFF || exit /b 1
cmake --build build --config Release || exit /b 1
cmake --install build --config Release --prefix dist || exit /b 1

nuget pack x64sentry-native.nuspec -Version %VERSION% || exit /b 1
