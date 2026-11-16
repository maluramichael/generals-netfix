# Builds Zero Hour (z_generals) for Windows XP SP3 with the official MSVC v141 toolset.
# Mirrors the v141_xp MSBuild toolset (MSBuild\Microsoft\VC\v150\Platforms\Win32\PlatformToolsets\v141_xp\Toolset.props):
# Windows SDK 7.1A headers and libs, _USING_V110_SDK71_, minimum OS 5.01.
# The UCRT comes from Windows SDK 10.0.10240, the oldest UCRT release.
# Needs VS 2022 with the components "MSVC v141 x86/x64 (14.16)", "C++ Windows XP Support for VS 2017 (v141)" and MFC for v141.
# -Config RelWithDebInfo builds into build/xp-relwithdebinfo with a PDB for crash analysis.
param([string]$Config = "Release")
$ErrorActionPreference = "Stop"
$dir = if ($Config -eq "Release") { "build/xp" } else { "build/xp-$($Config.ToLower())" }
$root = Split-Path -Parent $PSScriptRoot
$vs = "C:\Program Files\Microsoft Visual Studio\2022\Community"

Import-Module "$vs\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell -VsInstallPath $vs -SkipAutomaticLocation -DevCmdArguments "-arch=x86 -host_arch=x64 -vcvars_ver=14.16"

$sdk71 = "${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v7.1A"
$kits = "${env:ProgramFiles(x86)}\Windows Kits\10"
$ucrt = "10.0.10240.0"
function Swap-Sdk([string]$list, [string[]]$add) {
	$keep = $list -split ';' | Where-Object { $_ -and $_ -notlike "$kits*" }
	return (@($keep) + $add) -join ';'
}
$env:INCLUDE = Swap-Sdk $env:INCLUDE @("$kits\Include\$ucrt\ucrt", "$sdk71\Include")
$env:LIB = Swap-Sdk $env:LIB @("$kits\Lib\$ucrt\ucrt\x86", "$sdk71\Lib")
$env:LIBPATH = Swap-Sdk $env:LIBPATH @()
$env:CFLAGS = "/D_USING_V110_SDK71_"
$env:CXXFLAGS = "/D_USING_V110_SDK71_"
$env:RCFLAGS = "/D_USING_V110_SDK71_"

Set-Location $root
cl 2>&1 | Select-Object -First 1
cmake -S . -B $dir -G Ninja "-DCMAKE_BUILD_TYPE=$Config" -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DGENZH_BUILD_GENERALS=OFF "-DCMAKE_EXE_LINKER_FLAGS=/SUBSYSTEM:WINDOWS,5.01"
if ($LASTEXITCODE) { exit $LASTEXITCODE }
cmake --build $dir --target z_generals -- -k 0
exit $LASTEXITCODE
