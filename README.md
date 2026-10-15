# sentry-nuget

Builds the `x64sentry-native` NuGet package: sentry-native with the crashpad backend, for Windows x64.

    build.bat 0.6.1

The first argument is the sentry-native release; its `sentry-native.zip` asset carries the vendored crashpad. The second, optional, picks an installed platform toolset (default: the newest Visual Studio's own). Needs Visual Studio with the C++ workload (CMake comes with it) and `nuget.exe` on `PATH`.
