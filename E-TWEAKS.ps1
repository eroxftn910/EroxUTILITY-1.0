# =========================================================
# E-Tweaks PowerPlan Importer
# Télécharge un powerplan depuis GitHub, l'importe,
# le renomme en "E-Tweaks", puis l'active.
# =========================================================

$ErrorActionPreference = "Stop"

# ===== CONFIG =====
$PowerPlanUrl = "https://github.com/insovs/insopti-PowerPlan/releases/download/v1/insopti.pow"
$TempPowFile  = Join-Path $env:TEMP "E-Tweaks.pow"
$TargetName   = "E-Tweaks"
# ==================

function Write-Info($msg) {
    Write-Host "[INFO] $msg" -ForegroundColor Cyan
}

function Write-Success($msg) {
    Write-Host "[OK] $msg" -ForegroundColor Green
}

function Write-Warn($msg) {
    Write-Host "[WARN] $msg" -ForegroundColor Yellow
}

function Write-Err($msg) {
    Write-Host "[ERROR] $msg" -ForegroundColor Red
}

try {
    Clear-Host
    Write-Info "Téléchargement du power plan depuis GitHub..."
    Invoke-WebRequest -Uri $PowerPlanUrl -OutFile $TempPowFile -UseBasicParsing
    Write-Success "Fichier téléchargé : $TempPowFile"

    Write-Info "Import du power plan..."
    $importOutput = powercfg -import $TempPowFile 2>&1 | Out-String

    # Essaye de récupérer le GUID depuis la sortie de la commande
    $ImportedGuid = $null
    if ($importOutput -match '([a-fA-F0-9\-]{36})') {
        $ImportedGuid = $matches[1]
    }

    # Si pas trouvé dans la sortie, on prend le dernier plan apparu
    if (-not $ImportedGuid) {
        Write-Warn "GUID non trouvé directement, recherche dans la liste des plans..."
        $plansOutput = powercfg -list | Out-String
        $guids = [regex]::Matches($plansOutput, '([a-fA-F0-9\-]{36})') | ForEach-Object { $_.Value }
        if ($guids.Count -gt 0) {
            $ImportedGuid = $guids[$guids.Count - 1]
        }
    }

    if (-not $ImportedGuid) {
        throw "Impossible de récupérer le GUID du power plan importé."
    }

    Write-Success "GUID détecté : $ImportedGuid"

    Write-Info "Renommage du plan en '$TargetName'..."
    powercfg -changename $ImportedGuid $TargetName | Out-Null
    Write-Success "Plan renommé en $TargetName"

    Write-Info "Activation du plan..."
    powercfg -setactive $ImportedGuid | Out-Null
    Write-Success "$TargetName activé"

    Write-Info "Vérification du plan actif..."
    $activePlan = powercfg -getactivescheme | Out-String
    Write-Host $activePlan -ForegroundColor Gray

    Write-Info "Ouverture des options d'alimentation..."
    Start-Process "control.exe" -ArgumentList "/name Microsoft.PowerOptions"

    Write-Success "Terminé."
}
catch {
    Write-Err $_.Exception.Message
}
finally {
    if (Test-Path $TempPowFile) {
        Remove-Item $TempPowFile -Force -ErrorAction SilentlyContinue
    }
}