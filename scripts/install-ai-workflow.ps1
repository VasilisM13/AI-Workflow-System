#Requires -Version 5.1
<#
.SYNOPSIS
    Adopt the AI Workflow System into a target project folder.

.DESCRIPTION
    Copies only the runtime framework files into the target project, preserving
    the folder layout so all internal references resolve:

        .claude/
        agents/
        prompts/
        checklists/
        docs/task-schema.md

    Existing files in the target are NEVER overwritten unless -Force is given;
    they are reported as skipped. The script prints exactly what it copied and
    what it skipped.

.PARAMETER TargetPath
    Path to the project folder to adopt the framework into. Must already exist.

.PARAMETER Force
    Overwrite files that already exist in the target.

.EXAMPLE
    .\scripts\install-ai-workflow.ps1 -TargetPath C:\code\my-project

.EXAMPLE
    .\scripts\install-ai-workflow.ps1 -TargetPath C:\code\my-project -Force
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$TargetPath,

    [switch]$Force
)

$ErrorActionPreference = 'Stop'

# The framework root is the parent of this script's folder (scripts\).
$FrameworkRoot = Split-Path -Parent $PSScriptRoot

# Runtime items to copy, relative to the framework root.
$Items = @('.claude', 'agents', 'prompts', 'checklists', 'docs/task-schema.md')

# --- Validate target -------------------------------------------------------
if (-not (Test-Path -LiteralPath $TargetPath)) {
    throw "Target path does not exist: $TargetPath"
}
$TargetRoot = (Resolve-Path -LiteralPath $TargetPath).Path

# Safety: refuse to install into the framework repository itself.
if ((Resolve-Path -LiteralPath $FrameworkRoot).Path -eq $TargetRoot) {
    throw "Target is the framework repository itself. Choose a different project folder."
}

$copied  = New-Object System.Collections.Generic.List[string]
$skipped = New-Object System.Collections.Generic.List[string]

function Copy-OneFile {
    param(
        [string]$SrcFile,
        [string]$RelPath
    )
    $destFile = Join-Path $TargetRoot $RelPath
    $destDir  = Split-Path -Parent $destFile
    if (-not (Test-Path -LiteralPath $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    if ((Test-Path -LiteralPath $destFile) -and -not $Force) {
        $skipped.Add($RelPath)
        return
    }
    Copy-Item -LiteralPath $SrcFile -Destination $destFile -Force
    $copied.Add($RelPath)
}

# --- Copy ------------------------------------------------------------------
foreach ($item in $Items) {
    $srcPath = Join-Path $FrameworkRoot $item
    if (-not (Test-Path -LiteralPath $srcPath)) {
        Write-Warning "Source not found, skipping: $item"
        continue
    }

    if (Test-Path -LiteralPath $srcPath -PathType Container) {
        # Directory: copy each file, preserving its relative path.
        $base = (Resolve-Path -LiteralPath $srcPath).Path
        Get-ChildItem -LiteralPath $srcPath -Recurse -File | ForEach-Object {
            $rel     = $_.FullName.Substring($base.Length).TrimStart('\', '/')
            $relPath = Join-Path $item $rel
            Copy-OneFile -SrcFile $_.FullName -RelPath $relPath
        }
    }
    else {
        # Single file (e.g. docs/task-schema.md).
        Copy-OneFile -SrcFile $srcPath -RelPath $item
    }
}

# --- Report ----------------------------------------------------------------
Write-Host ""
Write-Host "AI Workflow System  ->  $TargetRoot" -ForegroundColor Cyan
Write-Host ""

if ($copied.Count -gt 0) {
    Write-Host "Copied ($($copied.Count)):" -ForegroundColor Green
    $copied | Sort-Object | ForEach-Object { Write-Host "  + $_" }
}
else {
    Write-Host "Copied (0): nothing new was copied." -ForegroundColor Yellow
}

if ($skipped.Count -gt 0) {
    Write-Host ""
    Write-Host "Skipped - already exist ($($skipped.Count)):" -ForegroundColor Yellow
    $skipped | Sort-Object | ForEach-Object { Write-Host "  ! $_" }
    Write-Host ""
    Write-Host "Re-run with -Force to overwrite the skipped files." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next: open the project in Claude Code and run /initialize-project" -ForegroundColor Cyan
Write-Host ""
