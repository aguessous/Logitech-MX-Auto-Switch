# =======================================================
# SCRIPT D'AIDE : TROUVER MES ID LOGITECH
# =======================================================
# Ce script scanne vos ports USB et vous donne les codes
# exacts à copier-coller dans les scripts de configuration.
# =======================================================

$ExePath = Join-Path $PSScriptRoot "hidapitester.exe"

if (-not (Test-Path $ExePath)) {
    Write-Host "ERREUR: hidapitester.exe est introuvable !" -ForegroundColor Red
    Write-Host "Veuillez mettre ce script dans le meme dossier que hidapitester.exe"
    Read-Host "Appuyez sur Entree pour quitter..."
    exit
}

Clear-Host
Write-Host "--- SCAN DES PERIPHERIQUES LOGITECH ---" -ForegroundColor Cyan
Write-Host "Recherche en cours..."

# On récupère les détails
$output = & $ExePath --list-detail 2>&1 | Out-String

# On sépare par bloc de périphériques (séparés par des lignes vides)
$devices = $output -split "\r\n\r\n"

# Une liste pour éviter d'afficher 10 fois le même clavier
$dejaVus = @{} 

foreach ($dev in $devices) {
    # On cherche le VendorID 046D (Logitech)
    if ($dev -match "vendorId:\s+0x046D") {
        
        # Extraction du ProductID (le code qu'on cherche)
        if ($dev -match "productId:\s+0x([0-9A-F]{4})") {
            $myPid = $Matches[1]
            $fullID = "046D:$myPid"
            
            # Si on n'a pas encore affiché cet ID, on le traite
            if (-not $dejaVus.ContainsKey($fullID)) {
                
                # On essaie de trouver le nom du produit (ex: MX_KEYS_S)
                $productName = "Inconnu"
                # CORRECTION ICI : Utilisation de ${myPid} pour éviter l'erreur de syntaxe
                if ($dev -match "046D/${myPid}: (.*)") {
                    $productName = $Matches[1]
                }
                
                # On l'affiche proprement
                Write-Host "------------------------------------------------"
                Write-Host "Appareil Trouve : $productName" -ForegroundColor Green
                Write-Host "ID a copier     : $fullID" -ForegroundColor Yellow
                
                # On l'ajoute à la liste des "déjà vus"
                $dejaVus[$fullID] = $true
            }
        }
    }
}

Write-Host "------------------------------------------------"
Write-Host "`nTERMINE !"
Write-Host "Si vous voyez plusieurs appareils :"
Write-Host "1. Reperez votre CLAVIER (souvent MX Keys, Keyboard...)"
Write-Host "2. Reperez votre SOURIS (souvent MX Master, Mouse...)"
Write-Host "3. Copiez leurs IDs dans les fichiers PC1_SwitchTo2.ps1 et PC2_SwitchTo1.ps1"
Write-Host "`nAppuyez sur Entree pour fermer."
Read-Host