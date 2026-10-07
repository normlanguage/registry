param([Parameter(Mandatory)][string]$Archive, [Parameter(Mandatory)][string]$License)
$ErrorActionPreference = 'Stop'
$digest = (Get-FileHash -LiteralPath $Archive -Algorithm SHA256).Hash.ToLowerInvariant()
$declared = (Get-Content -LiteralPath "$Archive.sha256" -Raw).Trim().Split(' ')[0]
if ($digest -cne $declared) { throw 'NAR checksum does not match its sidecar' }
$zip = [IO.Compression.ZipFile]::OpenRead((Resolve-Path -LiteralPath $Archive))
try {
    $metadata = $zip.GetEntry('module.json')
    $licenseEntry = $zip.GetEntry('resources/LICENSE')
    if (!$metadata -or !$licenseEntry) { throw 'NAR requires module.json and resources/LICENSE' }
    $reader = [IO.StreamReader]::new($metadata.Open())
    try { $module = ($reader.ReadToEnd() | ConvertFrom-Json).module } finally { $reader.Dispose() }
    if ($module.name -notmatch '^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)*$' -or $module.version -lt 1) { throw 'Invalid published module identity' }
    $reader = [IO.StreamReader]::new($licenseEntry.Open())
    try { $actualLicense = $reader.ReadToEnd() } finally { $reader.Dispose() }
    if ($actualLicense -cne (Get-Content -LiteralPath $License -Raw)) { throw 'NAR license differs from repository LICENSE' }
    [pscustomobject]@{ name = $module.name; version = $module.version; archive = [IO.Path]::GetFullPath($Archive) }
} finally { $zip.Dispose() }
