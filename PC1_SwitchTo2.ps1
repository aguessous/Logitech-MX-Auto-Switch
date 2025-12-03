# =======================================================
# SCRIPT POUR LE PC 1 (Canal 1)
# Ce script détecte quand le clavier QUITTE ce PC
# et envoie la souris vers le PC 2.
# =======================================================

# --- ZONE DE CONFIGURATION (MODIFIEZ ICI) ---

# Mettez ici l'ID trouvé avec le script '0_Get_IDs.ps1'
# Exemple : $KeyboardID = "046D:B378"
$KeyboardID   = "VOTRE_ID_CLAVIER_ICI"

# Exemple : $MouseID = "046D:B034"
$MouseID      = "VOTRE_ID_SOURIS_ICI"

# Vers quel canal envoyer la souris quand le clavier part ?
# 0x01 = PC 2 (Canal 2)
# 0x02 = PC 3 (Canal 3)
$TargetForMouse = "0x01" 

# =======================================================
# NE PAS TOUCHER EN DESSOUS
# =======================================================
$ExePath = Join-Path $PSScriptRoot "hidapitester.exe"
$CmdPush = "0x11,0x00,0x0a,0x1b,$TargetForMouse,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00"
$WasPresent = $true

if (-not (Test-Path $ExePath)) { Write-Host "hidapitester.exe manquant !"; exit }

While ($true) {
    $output = & $ExePath --vidpid $KeyboardID --list 2>&1
    # On remplace : par / pour matcher la sortie de hidapitester
    $IsPresent = ($output -match ($KeyboardID -replace ":", "/"))

    # Si le clavier était là, et qu'il disparaît -> DÉPART
    if ($WasPresent -and -not $IsPresent) {
        # On pousse la souris
        & $ExePath --vidpid $MouseID --usage 0x0202 --usagePage 0xFF43 --open --length 20 --send-output $CmdPush | Out-Null
    }
    
    $WasPresent = $IsPresent
    Start-Sleep -Seconds 1
}