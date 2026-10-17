function Get-DisplayName {
    param(
        [string]$First,
        [string]$Last
    )

    $x = $Last + ", " + $First
    if ($First -eq $null) { $First = "" }
    if ($Last -eq $null) { $Last = "" }
    return $x
}
