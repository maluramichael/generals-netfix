# Builds and runs the regression test for EnglishAudioLength (TSH issue #2320).
# Uses the same v141 x86 toolset as build-xp.ps1. Exit code 0 means all checks passed.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$vs = "C:\Program Files\Microsoft Visual Studio\2022\Community"
Import-Module "$vs\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell -VsInstallPath $vs -SkipAutomaticLocation -DevCmdArguments "-arch=x86 -host_arch=x64 -vcvars_ver=14.16" 2>$null | Out-Null
$test = "$root\scripts\tests\audiolength"
$out = "$root\build\tests\audiolength"
New-Item -ItemType Directory -Force $out | Out-Null
cl /nologo /EHsc /W3 /I"$root\GeneralsMD\Code\GameEngine\Include" /Fo"$out\\" /Fe"$out\audiolength_test.exe" "$test\audiolength_test.cpp"
if ($LASTEXITCODE) { exit $LASTEXITCODE }
& "$out\audiolength_test.exe"
exit $LASTEXITCODE
