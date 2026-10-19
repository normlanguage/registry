$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$skill = Get-Content (Join-Path $root 'SKILL.md') -Raw
$required = @('# Registry Skill','## Registry contract','## Lookup and Skill URL','## Registering a module','## Releases and installation','## Agent workflow')
foreach ($heading in $required) { if ($skill -notmatch [regex]::Escape($heading)) { throw "Missing Skill section: $heading" } }
if ($skill -notmatch 'registry\.schema\.json') { throw 'Skill must link to the registry schema' }
if ($skill -notmatch 'raw\.githubusercontent\.com') { throw 'Skill must define immutable Skill discovery' }
Write-Output 'Registry Skill: contract passed'
