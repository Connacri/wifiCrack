# Stopper le script en cas d'erreur
$ErrorActionPreference = "Stop"

Write-Host "--- DEBUT DU DEPLOIEMENT AUTOMATISE ---"

# 1. Recuperation de la version actuelle depuis GitHub
Write-Host "Recuperation de la derniere version sur GitHub..."
try {
    # On recupere la derniere release via l'API GitHub CLI
    $latestTag = gh release list --limit 1 --json tagName --jq ".[0].tagName"
    if ($latestTag) {
        Write-Host "Dernier tag detecte : $latestTag"
        
        # Extraction des composants (v1.0.5 -> 1, 0, 5)
        $versionStr = $latestTag.TrimStart('v')
        $parts = $versionStr.Split('.')
        $major = [int]$parts[0]
        $minor = [int]$parts[1]
        $patch = [int]$parts[2]
        
        # Increment du patch pour la nouvelle version
        $patch++
        $newVersion = "$major.$minor.$patch"
    } else {
        $newVersion = "1.0.0"
        Write-Host "Aucune release trouvee. Initialisation a v1.0.0"
    }
} catch {
    Write-Host "Erreur gh cli ou aucune release. On lit pubspec.yaml..."
    $pubspec = Get-Content "pubspec.yaml" -Raw
    if ($pubspec -match "version: (\d+\.\d+\.\d+)\+(\d+)") {
        $newVersion = $matches[1]
        Write-Host "Version lue depuis pubspec : $newVersion"
    } else {
        $newVersion = "1.0.0"
    }
}

$newTag = "v$newVersion"
Write-Host ">>> Nouvelle version cible : $newTag <<<"

# 2. Mise a jour des fichiers (Versionnage)
Write-Host "Mise a jour de pubspec.yaml..."
$pubspecPath = "pubspec.yaml"
$pubspecContent = Get-Content $pubspecPath -Raw
if ($pubspecContent -match "version: (\d+\.\d+\.\d+)\+(\d+)") {
    $oldBuildNumber = [int]$matches[2]
    $newBuildNumber = $oldBuildNumber + 1
    $newFullVersion = "$newVersion+$newBuildNumber"
    $pubspecContent = $pubspecContent -replace "version: \d+\.\d+\.\d+\+\d+", "version: $newFullVersion"
    Set-Content $pubspecPath $pubspecContent
    Write-Host "   -> pubspec.yaml : $newFullVersion"
}

Write-Host "Mise a jour de pubspec.lock..."
$lockPath = "pubspec.lock"
if (Test-Path $lockPath) {
    $lockContent = Get-Content $lockPath -Raw
    # Remplacement spécifique pour le package principal si possible, sinon global pour la version '1.0.x'
    $lockContent = $lockContent -replace 'version: "\d+\.\d+\.\d+"', "version: `"$newVersion`""
    Set-Content $lockPath $lockContent
    Write-Host "   -> pubspec.lock mis a jour."
}

Write-Host "Mise a jour de index.html..."
$indexPath = "index.html"
if (Test-Path $indexPath) {
    $indexContent = Get-Content $indexPath -Raw
    # On remplace toutes les occurrences de v1.0.x ou V1.0.x par le nouveau tag (insensible à la casse)
    $indexContent = [regex]::Replace($indexContent, "(?i)v\d+\.\d+\.\d+", $newTag)
    # On remplace aussi les mentions "Version 1.0.x"
    $indexContent = [regex]::Replace($indexContent, "Version \d+\.\d+\.\d+", "Version $newVersion")
    # Mise a jour du lien de telechargement APK specifique
    $indexContent = [regex]::Replace($indexContent, "/download/v\d+\.\d+\.\d+/", "/download/$newTag/")
    
    Set-Content $indexPath $indexContent
    Write-Host "   -> index.html mis a jour avec $newTag."
}

## 3. Generation de la description basee sur l'historique
#$history = git log -n 5 --pretty=format:"- %s" | Out-String
#$description = "Release $newTag`n`nModifications recentes :`n$history"
#Write-Host "Description preparee."

 # 3. Description manuelle + fallback auto
Write-Host "Ecris la description de la release (laisser vide pour auto) :"
$userInput = Read-Host

if ([string]::IsNullOrWhiteSpace($userInput)) {
    Write-Host "Aucune description saisie → génération automatique..."
    $history = git log -n 5 --pretty=format:"- %s" | Out-String
    $description = "Release $newTag`n`nModifications recentes :`n$history"
} else {
    $description = "Release $newTag`n`n$userInput"
}

Write-Host "Description prête."
# 4. Git : Commit & Push
Write-Host "Synchronisation Git..."
git add .
$commitMsg = "chore: bump version to $newTag and update metadata"
# On ignore l'erreur si rien a committer
git commit -m "$commitMsg" 2>$null
git push origin main

# 5. Flutter : Build
Write-Host "Compilation Flutter APK (Obfuscated)..."
$ErrorActionPreference = "Continue"
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR : La compilation a echoue."
    exit 1
}

# 6. GitHub Release
Write-Host "Publication de la release sur GitHub..."
$apkPath = "build\app\outputs\flutter-apk\app-release.apk"
try {
    # On supprime si tag deja localement ou erreur de tag pre-existant
    gh release create $newTag $apkPath --title "WI-FI Crack Fiber DZ $newTag" --notes "$description"
    Write-Host "SUCCES ! Release $newTag est en ligne."
} catch {
    Write-Host "ERREUR : Impossible de creer la release GitHub (peut-etre que le tag existe deja ?)."
    exit 1
}

Write-Host "--- DEPLOIEMENT TERMINE ---"
