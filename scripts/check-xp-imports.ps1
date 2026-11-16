# Checks that every function the EXE imports exists in the Windows XP SP3 system DLLs.
# -XpDlls: folder with the system DLLs from an XP SP3 install, e.g. extracted from the CD:
#   7z e <xp-sp3.iso> -o<dir> I386\KERNEL32.DL_ I386\USER32.DL_ ...   then   expand <dir>\KERNEL32.DL_ <dir>\kernel32.dll
# Exit code 1 lists every import that XP lacks.
param(
	[Parameter(Mandatory)][string]$XpDlls,
	[string]$Exe = "$(Split-Path -Parent $PSScriptRoot)\build\xp\GeneralsMD\generalszh.exe"
)
$ErrorActionPreference = "Stop"
$vs = "C:\Program Files\Microsoft Visual Studio\2022\Community"
Import-Module "$vs\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell -VsInstallPath $vs -SkipAutomaticLocation -DevCmdArguments "-arch=x86 -host_arch=x64" 2>$null | Out-Null

$imports = @{}
$dll = $null
foreach ($line in (dumpbin /nologo /imports $Exe)) {
	if ($line -match '^\s*Summary') { break }
	if ($line -match '^\s{4}(\S+\.dll)\s*$') { $dll = $Matches[1].ToLower(); $imports[$dll] = @(); continue }
	if (-not $dll) { continue }
	if ($line -match '^\s+[0-9A-F]+\s+([A-Za-z_]\w*)\s*$') { $imports[$dll] += $Matches[1] }
	elseif ($line -match '^\s+Ordinal\s+(\d+)\s*$') { $imports[$dll] += "#" + $Matches[1] }
}

$missing = @()
$total = 0
foreach ($dll in $imports.Keys | Sort-Object) {
	$path = Join-Path $XpDlls $dll
	if (-not (Test-Path $path)) { $missing += "$dll (DLL not in $XpDlls)"; continue }
	$exports = @{}
	foreach ($line in (dumpbin /nologo /exports $path)) {
		if ($line -match '^\s+(\d+)\s+[0-9A-F]+\s+(?:[0-9A-F]{8}\s+)?([A-Za-z_]\w*)') { $exports[$Matches[2]] = 1; $exports["#" + $Matches[1]] = 1 }
		elseif ($line -match '^\s+(\d+)\s+[0-9A-F]{8}\s+\[NONAME\]') { $exports["#" + $Matches[1]] = 1 }
	}
	if ($exports.Count -eq 0) { throw "No exports parsed from $path" }
	foreach ($fn in $imports[$dll]) {
		$total++
		if (-not $exports.ContainsKey($fn)) { $missing += "${dll}: $fn" }
	}
}

if ($total -eq 0) { throw "No imports parsed from $Exe" }
"$total imports from $($imports.Count) DLLs checked against $XpDlls"
if ($missing) { "Missing on XP SP3:"; $missing | ForEach-Object { "  $_" }; exit 1 }
"All present on XP SP3."
