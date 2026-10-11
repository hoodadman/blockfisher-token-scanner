param(
    [string]$Command = "status",
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Rest
)

$Base = if ($env:TRUST_SCORE_URL) { $env:TRUST_SCORE_URL.TrimEnd("/") } else { "http://100.118.254.40:5179" }

function Show-Status {
    try {
        $response = Invoke-WebRequest -Uri $Base -UseBasicParsing -TimeoutSec 5
        Write-Output "Token scanner is up at $Base (HTTP $($response.StatusCode))."
        Write-Output "Scan one token with: scan <contract address>"
        exit 0
    } catch {
        Write-Output "Token scanner is not responding at $Base."
        Write-Output "Start it from the trust-score folder: npx vite --host 100.118.254.40 --port 5179 --strictPort"
        exit 1
    }
}

switch ($Command) {
    "status" { Show-Status }
    "scan" { }
    default {
        Write-Error "Unknown command '$Command'. Use status or scan."
        exit 1
    }
}

if (-not $Rest -or $Rest.Count -ne 1 -or -not $Rest[0].Trim()) {
    Write-Output "Scan takes one contract address. Example: scan 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
    exit 1
}

$body = @{ address = $Rest[0].Trim() } | ConvertTo-Json -Compress
try {
    $result = Invoke-RestMethod -Uri "$Base/api/scan" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 55
} catch {
    $detail = $_.ErrorDetails.Message
    if ($detail) {
        try {
            $parsed = $detail | ConvertFrom-Json
            if ($parsed.text) {
                Write-Output $parsed.text
                exit 1
            }
        } catch {
            # Fall through to the generic message.
        }
    }
    Write-Output "Could not scan through $Base. Start the token scanner, then try again."
    exit 1
}

if ($result.text) { Write-Output $result.text }
if (-not $result.ok) { exit 1 }
