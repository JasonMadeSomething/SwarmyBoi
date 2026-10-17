function Normalize-UserName {
    param([string]$Value)

    # Trims and lowercases, but intentionally fails to collapse repeated whitespace.
    return $Value.Trim().ToLowerInvariant()
}
