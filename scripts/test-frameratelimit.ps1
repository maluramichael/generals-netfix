# Builds and runs the regression test for FrameRateLimit (render fps presets, logic time scale, limiter).
# Uses the same v141 x86 toolset as build-xp.ps1. Exit code 0 means all checks passed.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$vs = "C:\Program Files\Microsoft Visual Studio\2022\Community"
Import-Module "$vs\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell -VsInstallPath $vs -SkipAutomaticLocation -DevCmdArguments "-arch=x86 -host_arch=x64 -vcvars_ver=14.16" 2>$null | Out-Null
$test = "$root\scripts\tests\frameratelimit"
$out = "$root\build\tests\frameratelimit"
New-Item -ItemType Directory -Force $out | Out-Null
cl /nologo /EHsc /W3 /I"$test" /I"$root\GeneralsMD\Code\GameEngine\Include" /Fo"$out\\" /Fe"$out\frameratelimit_test.exe" "$test\frameratelimit_test.cpp" "$root\GeneralsMD\Code\GameEngine\Source\Common\FrameRateLimit.cpp"
if ($LASTEXITCODE) { exit $LASTEXITCODE }
& "$out\frameratelimit_test.exe"
exit $LASTEXITCODE
