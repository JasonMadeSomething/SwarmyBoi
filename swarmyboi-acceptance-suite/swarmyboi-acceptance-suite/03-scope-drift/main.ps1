param(
    [Parameter(Mandatory)]
    [string]$UserName
)

. "$PSScriptRoot/normalize.ps1"

Write-Output (Normalize-UserName $UserName)
