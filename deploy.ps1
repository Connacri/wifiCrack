# Stopper le script en cas d'erreur
$ErrorActionPreference = "Stop"

$Description = "Mise en place de l'automatisation du deploiement : script PowerShell integrant le build Flutter avec obfuscation, le commit/push Git et la mise a jour automatique de la release GitHub 1.0.2."

Write-Host "--- DEBUT DU DEPLOIEMENT ---"

# 1. Git : Synchronisation et Sauvegarde
try {
    Write-Host "Sauvegarde du code..."
    git add .
    # On tente le commit, on ignore s'il n'y a rien de nouveau
    git commit -m "$Description" 2>$null 
    
    Write-Host "Synchronisation avec GitHub (Pull)..."
    git pull --rebase origin main
    
    Write-Host "Envoi vers GitHub (Push)..."
    git push origin main
} catch {
    Write-Host "Erreur Git : Le script s'arrete pour securite."
    exit 1
}

# 2. Flutter : Build
Write-Host "Compilation de l'APK (Release + Obfuscation)..."
# On change l'action preference temporairement car flutter build peut emettre des warnings consideres comme erreurs
$ErrorActionPreference = "Continue"
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erreur Build : Echec de la compilation."
    exit 1
}

# 3. GitHub : Release
try {
    $tag = "1.0.2"
    $apkPath = "build\app\outputs\flutter-apk\app-release.apk"

    Write-Host "Remplacement de la release $tag..."
    # On ignore les erreurs si la release n'existe pas encore
    gh release delete $tag --yes 2>$null
    git push --delete origin $tag 2>$null

    Write-Host "Upload de l'APK..."
    gh release create $tag $apkPath --title "WI-FI Crack Fiber DZ" --notes "$Description"

    Write-Host "TERMINE ! Release a jour : https://github.com/Connacri/wifiCrack/releases/tag/1.0.2"
} catch {
    Write-Host "Erreur GitHub : Echec de la mise a jour de la release."
    exit 1
}
