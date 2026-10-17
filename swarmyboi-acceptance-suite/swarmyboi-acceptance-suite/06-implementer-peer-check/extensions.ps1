function Get-ExtensionSummary {
    param(
        [string[]]$Names
    )

    $result = @{}

    foreach ($name in $Names) {
        $ext = [System.IO.Path]::GetExtension($name)

        if (-not $result.ContainsKey($ext)) {
            $result[$ext] = 0
        }

        $result[$ext]++
    }

    return $result
}
