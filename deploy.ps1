# Description generee a partir de notre historique de conversation
$Description = "Mise en place de l'automatisation du deploiement : script PowerShell integrant le build Flutter avec obfuscation, le commit/push Git et la mise a jour automatique de la release GitHub 1.0.2."

Write-Host "Description utilisee : $Description"

# 1. Git : Sauvegarde et envoi du code
Write-Host "Envoi du code vers GitHub..."
git add .
# On ignore l'erreur si rien n'a change
git commit -m "$Description" 2>$null 
git push

# 2. Flutter : Lancement du build avec obfuscation
Write-Host "Compilation de l'APK (Release + Obfuscation)..."
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build reussi ! Preparation de la release GitHub..."
    
    $tag = "1.0.2"
    $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
    $releaseTitle = "WI-FI Crack Fiber DZ"

    # 3. GitHub : Suppression de l'ancienne release et du tag
    Write-Host "Remplacement de la release $tag..."
    gh release delete $tag --yes
    git push --delete origin $tag 2>$null

    # 4. GitHub : Creation de la nouvelle release avec la description
    Write-Host "Upload de l'APK vers GitHub..."
    gh release create $tag $apkPath --title $releaseTitle --notes "$Description"
    
    Write-Host "Tout est a jour ! Release : https://github.com/Connacri/wifiCrack/releases/tag/$tag"
} else {
    Write-Host "Erreur : Le build Flutter a echoue."
    exit $LASTEXITCODE
}
