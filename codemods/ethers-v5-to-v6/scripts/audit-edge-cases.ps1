param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath
)

$ErrorActionPreference = "Stop"

$resolvedTarget = (Resolve-Path $TargetPath).Path
$reportDir = Join-Path $resolvedTarget "codemod-reports"
$reportJson = Join-Path $reportDir "ethers-v5-to-v6-edge-cases.json"
$reportMd = Join-Path $reportDir "ethers-v5-to-v6-edge-cases.md"

New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

$patterns = @(
    @{
        id = "web3-provider"
        label = "Web3Provider to BrowserProvider"
        regex = "ethers\.providers\.Web3Provider"
        risk = "high"
        action = "Review manually. In v6, BrowserProvider replaces Web3Provider and may affect async flow."
    },
    @{
        id = "bignumber"
        label = "BigNumber usage"
        regex = "ethers\.BigNumber|BigNumber\.from\("
        risk = "high"
        action = "Review manually. BigNumber to BigInt migration can change runtime behavior and serialization."
    },
    @{
        id = "deploy-wait"
        label = "Contract deploy flow"
        regex = "\.deploy\("
        risk = "medium"
        action = "Review manually. Some deployments in v6 need waitForDeployment() or follow-up checks."
    },
    @{
        id = "legacy-utils"
        label = "Remaining ethers.utils usage"
        regex = "ethers\.utils\."
        risk = "medium"
        action = "Review manually. Remaining utils usage may require new mapping or may be outside the safe whitelist."
    },
    @{
        id = "legacy-providers"
        label = "Remaining ethers.providers usage"
        regex = "ethers\.providers\."
        risk = "medium"
        action = "Review manually. Remaining providers usage may need additional safe mappings."
    }
)

$files = Get-ChildItem -Path $resolvedTarget -Recurse -File -Include *.js,*.jsx,*.ts,*.tsx |
    Where-Object {
        $_.FullName -notmatch '[\\/]node_modules[\\/]' -and
        $_.FullName -notmatch '[\\/]artifacts[\\/]' -and
        $_.FullName -notmatch '[\\/]cache[\\/]' -and
        $_.FullName -notmatch '[\\/]\.git[\\/]'
    }

$results = @()

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName
    for ($index = 0; $index -lt $content.Length; $index++) {
        $line = $content[$index]

        foreach ($pattern in $patterns) {
            if ($line -match $pattern.regex) {
                $results += [PSCustomObject]@{
                    id = $pattern.id
                    label = $pattern.label
                    risk = $pattern.risk
                    action = $pattern.action
                    file = $file.FullName.Replace($resolvedTarget + "\", "")
                    line = $index + 1
                    snippet = $line.Trim()
                }
            }
        }
    }
}

$summary = $results |
    Group-Object id |
    ForEach-Object {
        $sample = $_.Group[0]
        [PSCustomObject]@{
            id = $_.Name
            label = $sample.label
            risk = $sample.risk
            count = $_.Count
            action = $sample.action
        }
    }

[PSCustomObject]@{
    target = $resolvedTarget
    generated_at = (Get-Date).ToString("s")
    total_findings = $results.Count
    summary = @($summary)
    findings = @($results)
} | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

$md = New-Object System.Collections.Generic.List[string]
$md.Add("# Ethers v5 to v6 Edge Case Audit")
$md.Add("")
$md.Add(("Target: {0}" -f $resolvedTarget))
$md.Add("")
$md.Add(("Total findings: **{0}**" -f $results.Count))
$md.Add("")
$md.Add("## Summary")
$md.Add("")

if ($summary.Count -eq 0) {
    $md.Add("- No risky patterns found in scanned source files.")
} else {
    foreach ($item in $summary) {
        $md.Add(("- **{0}**: {1} finding(s) | risk: {2}" -f $item.label, $item.count, $item.risk))
        $md.Add(("  Action: {0}" -f $item.action))
    }
}

$md.Add("")
$md.Add("## Findings")
$md.Add("")

if ($results.Count -eq 0) {
    $md.Add("- No findings.")
} else {
    foreach ($finding in $results) {
        $md.Add(("- **{0}** in {1}:{2}" -f $finding.label, $finding.file, $finding.line))
        $md.Add(("  Risk: {0}" -f $finding.risk))
        $md.Add(("  Snippet: {0}" -f $finding.snippet))
        $md.Add(("  Action: {0}" -f $finding.action))
    }
}

$md | Set-Content -Path $reportMd -Encoding UTF8

Write-Host "Edge-case audit written to:"
Write-Host " - $reportMd"
Write-Host " - $reportJson"
