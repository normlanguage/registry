$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$temporary = Join-Path ([IO.Path]::GetTempPath()) ('norm-artifact-' + [guid]::NewGuid())
New-Item -ItemType Directory -Path $temporary | Out-Null
try {
    $license = Join-Path $temporary 'LICENSE'
    Set-Content $license 'test-license' -NoNewline
    $archive = Join-Path $temporary 'demo-3.nar'
    $zip = [IO.Compression.ZipFile]::Open($archive, 'Create')
    foreach ($entry in @{'module.json'='{"module":{"name":"demo","version":3}}'; 'resources/LICENSE'='test-license'}.GetEnumerator()) {
        $writer = [IO.StreamWriter]::new($zip.CreateEntry($entry.Key).Open())
        $writer.Write($entry.Value)
        $writer.Dispose()
    }
    $zip.Dispose()
    Set-Content "$archive.sha256" (Get-FileHash $archive -Algorithm SHA256).Hash.ToLowerInvariant() -NoNewline
    $result = & "$root/.github/actions/package-module/verify-artifact.ps1" -Archive $archive -License $license
    if ($result.version -ne 3 -or $result.name -ne 'demo') { throw 'Manifest identity was not preserved' }
    Set-Content "$archive.sha256" ('0' * 64) -NoNewline
    $rejected = $false
    try { & "$root/.github/actions/package-module/verify-artifact.ps1" -Archive $archive -License $license } catch { $rejected = $true }
    if (!$rejected) { throw 'Corrupt checksum accepted' }
    Set-Content "$archive.sha256" (Get-FileHash $archive -Algorithm SHA256).Hash.ToLowerInvariant() -NoNewline
    Set-Content $license 'different-license' -NoNewline
    $rejected = $false
    try { & "$root/.github/actions/package-module/verify-artifact.ps1" -Archive $archive -License $license } catch { $rejected = $true }
    if (!$rejected) { throw 'Different license accepted' }
    Write-Output 'Artifact contract: 3 checks passed'
} finally {
    $resolved = [IO.Path]::GetFullPath($temporary)
    if (!$resolved.StartsWith([IO.Path]::GetTempPath(), [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe temporary path' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
