$ErrorActionPreference = 'Stop'

$source = Join-Path $PSScriptRoot 'src/settings.template.json'
$target = Join-Path $PSScriptRoot 'generated/settings.json'

$content = Get-Content -Raw $source
"// GENERATED FILE - DO NOT EDIT DIRECTLY`n$content" | Set-Content -NoNewline $target
