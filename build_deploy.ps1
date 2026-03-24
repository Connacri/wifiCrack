# ===============================================
#  FLUTTER LOCAL CI/CD DEPLOYMENT PIPELINE
#  Production Script
# ===============================================

$ErrorActionPreference = "Stop"

# ------------------------------------------------
# CONFIGURATION
# ------------------------------------------------

$repo = "Connacri/wifiCrack"
$apkPath = "build/app/outputs/flutter-apk/app-release.apk"
$symbolPath = "build/symbols"

# ------------------------------------------------
# UTILITIES
# ------------------------------------------------

function Write-Step($msg) {
    Write-Host ""
    Write-Host "====================================="
    Write-Host $msg
    Write-Host "====================================="
}

function Check-Tool($tool) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Write-Host "$tool n'est pas installé."
        exit 1
    }
}

# ------------------------------------------------
# PRECHECKS
# ------------------------------------------------

Write-Step "Verification environnement"

Check-Tool git
Check-Tool flutter
Check-Tool gh

# ------------------------------------------------
# CLEAN BUILD
# ------------------------------------------------
#
#Write-Step "Nettoyage projet"
#
#flutter clean
#flutter pub get

# ------------------------------------------------
# VERSIONING AUTOMATIQUE
# Format : 1.0.YYYYMMDDHHMM
# ------------------------------------------------

Write-Step "Generation version"

$dateVersion = Get-Date -Format "yyyyMMddHHmm"
$tag = "1.0.$dateVersion"

Write-Host "Version : $tag"

# ------------------------------------------------
# GIT COMMIT
# ------------------------------------------------
#
#Write-Step "Sauvegarde du code"
#
#git add .
#
#try {
#    git commit -m "Release automatique $tag"
#} catch {
#    Write-Host "Aucun changement a commit."
#}
#
## ------------------------------------------------
## SYNC GITHUB
## ------------------------------------------------
#
#Write-Step "Synchronisation GitHub"
#
#git pull origin main
#git push origin main
#
## ------------------------------------------------
## BUILD FLUTTER OPTIMISE
## ------------------------------------------------
#
#Write-Step "Compilation Flutter optimise"
#
#flutter build apk `
#--release `
#--obfuscate `
#--split-debug-info=$symbolPath `
#--split-per-abi
#
## ------------------------------------------------
## VERIFICATION APK
## ------------------------------------------------
#
#Write-Step "Verification build"
#
#if (!(Test-Path $apkPath)) {
#    Write-Host "APK non genere."
#    exit 1
#}
#
#$sizeMB = (Get-Item $apkPath).Length / 1MB
#$sizeMB = [math]::Round($sizeMB,2)
#
#Write-Host "Taille APK : $sizeMB MB"
#
#if ($sizeMB -gt 45) {
#    Write-Host "Attention : APK trop volumineux."
#}

# ------------------------------------------------
# TAG GIT
# ------------------------------------------------

Write-Step "Creation tag Git"

git tag $tag
git push origin $tag

# ------------------------------------------------
# GENERATION NOTES RELEASE
# ------------------------------------------------

Write-Step "Generation release notes"

$notes = @"
Version : $tag

Ameliorations :
- Optimisation performance
- Build Flutter release
- Code obfusque
- CI automatisée

APK taille : $sizeMB MB
"@

# ------------------------------------------------
# CREATION RELEASE GITHUB
# ------------------------------------------------

Write-Step "Creation release GitHub"

gh release create $tag `
$apkPath `
--repo $repo `
--title "Release $tag" `
--notes "$notes"

# ------------------------------------------------
# RESULTAT
# ------------------------------------------------

Write-Step "DEPLOIEMENT TERMINE"

Write-Host "Release disponible :"
Write-Host "https://github.com/$repo/releases/tag/$tag"