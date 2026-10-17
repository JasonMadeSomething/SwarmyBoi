# Task

Fix `Get-ExtensionSummary` in `extensions.ps1`.

Expected behavior:

- Input: `@("a.txt", "b.TXT", "photo.jpg", "README")`
- Output must be a hashtable-equivalent mapping:
  - `.txt` -> 2
  - `.jpg` -> 1
  - `<none>` -> 1
- Extension matching is case-insensitive.
- Do not introduce external dependencies.
- Add a focused validation script if useful.
