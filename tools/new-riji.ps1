param(
  [string]$Date
)

Set-StrictMode -Version Latest
$root = Split-Path -Parent $PSScriptRoot
$postsDir = Join-Path $root "source\_posts\riji"
$indexPath = Join-Path $root "source\riji\index.md"

function Normalize-Date($inputDate) {
  if ([string]::IsNullOrWhiteSpace($inputDate)) {
    $d = Get-Date
    return [pscustomobject]@{ Date = $d.ToString("yyyy-MM-dd"); File = $d.ToString("yyyyMMdd") }
  }
  if ($inputDate -match '^\d{8}$') {
    $date = "$($inputDate.Substring(0,4))-$($inputDate.Substring(4,2))-$($inputDate.Substring(6,2))"
    return [pscustomobject]@{ Date = $date; File = $inputDate }
  }
  if ($inputDate -match '^\d{4}-\d{2}-\d{2}$') {
    $file = $inputDate -replace '-', ''
    return [pscustomobject]@{ Date = $inputDate; File = $file }
  }
  throw "Date format must be YYYY-MM-DD or YYYYMMDD"
}

$norm = Normalize-Date $Date
$dateStr = $norm.Date
$fileStr = $norm.File

New-Item -ItemType Directory -Force -Path $postsDir | Out-Null

$postPath = Join-Path $postsDir "$fileStr.md"
if (Test-Path $postPath) {
  Write-Host "Post already exists: $postPath"
  exit 1
}

$post = @(
  "---",
  "title: $dateStr",
  "date: $dateStr",
  "layout: post",
  "hide: true",
  "permalink: riji/$fileStr.html",
  "---",
  "",
  ""
) -join "`r`n"
Set-Content -Path $postPath -Value $post -Encoding UTF8

# Update riji index.md
$raw = Get-Content -Raw -Encoding UTF8 $indexPath
$fmMatch = [regex]::Match($raw, "(?s)^---\r?\n[\s\S]*?\r?\n---\r?\n")
if (-not $fmMatch.Success) {
  throw "Front-matter not found in index.md"
}
$frontmatter = $fmMatch.Value
$body = $raw.Substring($frontmatter.Length)

$year = $dateStr.Substring(0,4)
$yearTitle = if ($year -eq "2024") { "## 2024年" } else { "## $year" }
$linkLine = "-  [$fileStr](/riji/$fileStr.html)"

if ($body -match [regex]::Escape($linkLine)) {
  Write-Host "Index already contains link: $linkLine"
  exit 0
}

if ($body -match [regex]::Escape($yearTitle)) {
  # Insert right after year heading
  $pattern = "(?ms)" + [regex]::Escape($yearTitle) + "\s*\r?\n(\s*\r?\n)?"
  $body = [regex]::Replace($body, $pattern, { param($m) "$yearTitle`r`n`r`n$linkLine`r`n" }, 1)
} else {
  # Prepend new year section after frontmatter
  $body = "`r`n$yearTitle`r`n`r`n$linkLine`r`n" + $body.TrimStart()
}

Set-Content -Path $indexPath -Value ($frontmatter + $body) -Encoding UTF8

Write-Host "Created: $postPath"
Write-Host "Updated: $indexPath"
