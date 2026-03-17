param(
    [string]$ProjectRef = 'rfhogskyetnmtmxglmxo',
    [string]$SqlFile = 'scripts/apply_storage_policies.sql'
)

if (-not (Test-Path $SqlFile)) {
    Write-Error "SQL file '$SqlFile' does not exist."
    exit 1
}

$secureKey = Read-Host "Enter service_role key" -AsSecureString
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)
try {
    $serviceKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto($ptr)
} finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
}

Write-Host "→ Uploading SQL via REST API..."
$curlArgs = @(
    '-s', '-X', 'POST',
    "https://$ProjectRef.supabase.co/rest/v1/rpc",
    '-H', "apikey: $serviceKey",
    '-H', "Authorization: Bearer $serviceKey",
    '-H', 'Content-Type: application/sql',
    '--data-binary', "@$SqlFile"
)
& curl.exe @curlArgs
$curlExit = $LASTEXITCODE
if ($curlExit -ne 0) {
    Write-Warning "curl failed with exit code $curlExit"
} else {
    Write-Host "curl completed (exit code 0)."
}

Write-Host "→ Applying SQL via psql..."
$env:PGPASSWORD = $serviceKey
try {
    & psql `
        -h "db.$ProjectRef.supabase.co" `
        -p 5432 `
        -d postgres `
        -U postgres `
        -v sslmode=require `
        -f $SqlFile
} finally {
    Remove-Item Env:PGPASSWORD -ErrorAction SilentlyContinue
}
