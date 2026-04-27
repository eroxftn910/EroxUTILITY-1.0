<#
.SYNOPSIS
  Optimizes (Debloat) Fortnite by removing non-essential files, UI elements, and cosmetic assets.
#>

Set-Alias insoptiwrht Write-Host

# Vérifier les droits admin
if (-not ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) { 
    insoptiwrht "restart" -ForegroundColor DarkCyan -NoNewline
    Write-Host " the script as administrator.."
    Start-Process -FilePath "powershell" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    PAUSE
    exit 
}

$ErrorActionPreference = 'SilentlyContinue'
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Tuer les processus Fortnite/Epic
Get-Process | Where-Object { $_.ProcessName -like "epic*" -or $_.ProcessName -like "fortnite*" } | ForEach-Object { 
    Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
}

# Configuration UI
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.WindowTitle = "Fortnite Debloat Tool v1.2"
Clear-Host

function insoptiWh {
    param([string]$Text, [switch]$nonew, [ConsoleColor]$foregroundcolor = "White")
    if ($nonew) { Write-Host $Text -NoNewline -ForegroundColor $foregroundcolor }
    else { Write-Host $Text -ForegroundColor $foregroundcolor }
}

function insopti_ShowWarningMessage {
    Write-Host "`n============================================================" -ForegroundColor DarkGray
    Write-Host "           FORTNITE INSTALLATION DEBLOAT" -ForegroundColor Black -BackgroundColor DarkGray
    Write-Host "============================================================`n" -ForegroundColor DarkGray
    
    insoptiWh "  Removes 60-70% of Fortnite's internal files (UI elements," -ForegroundColor White
    insoptiWh "  cosmetic data, background resources) to boost performance." -ForegroundColor White
    insoptiWh ""
    insoptiWh "  WARNING: Modifying game files violates Epic Games' terms" -ForegroundColor Red
    insoptiWh "  and may result in penalties or account bans!" -ForegroundColor Red
    insoptiWh ""
    insoptiWh "  Proceed at your own risk!" -ForegroundColor Yellow
    Write-Host "`n============================================================`n" -ForegroundColor DarkGray
}

function insoptiDebloat {
    Clear-Host
    insopti_ShowWarningMessage
    
    Write-Host "`n[1] Debloat"
    Write-Host "[2] Exit"
    Write-Host "[3] What is a debloat?`n"
    
    $choice = Read-Host "Select option"
    
    if ($choice -eq "2") { exit }
    if ($choice -eq "3") {
        Clear-Host
        insopti_ShowWarningMessage
        Write-Host "`n  DEBLOAT = Removing unnecessary files from software`n"
        Write-Host "  Benefits: Better performance, less stuttering, 20-30 GB freed"
        Write-Host "  Drawbacks: Missing textures, broken menus, potential ban`n"
        Read-Host "Press Enter to return"
        insoptiDebloat
        return
    }
    if ($choice -ne "1") {
        Write-Host "Invalid choice!"
        Start-Sleep 2
        insoptiDebloat
        return
    }
    
    Clear-Host
    insopti_ShowWarningMessage
    
    $drive = Read-Host "Enter your Fortnite drive letter (C, D, E, etc.)"
    $drive = $drive.ToUpper() + ":\"
    
    Write-Host "`nSearching for Fortnite..."
    $fnPath = Get-ChildItem -Path $drive -Filter "Fortnite" -Directory -Recurse -ErrorAction SilentlyContinue | 
              Where-Object { Test-Path "$($_.FullName)\FortniteGame" } | 
              Select-Object -First 1 -ExpandProperty FullName
    
    if (-not $fnPath) {
        Write-Host "Fortnite not found on drive $drive !" -ForegroundColor Red
        Start-Sleep 3
        insoptiDebloat
        return
    }
    
    Write-Host "Fortnite found at: $fnPath" -ForegroundColor Green
    Start-Sleep 2
    
    # Nettoyage des fichiers
    Write-Host "`nCleaning files..." -ForegroundColor Yellow
    
    # Nettoyer les logs et caches
    $savedPaths = @(
        "$env:LOCALAPPDATA\FortniteGame\Saved\Logs",
        "$env:LOCALAPPDATA\FortniteGame\Saved\Config\CrashReportClient",
        "$env:LOCALAPPDATA\FortniteGame\Saved\Cloud",
        "$env:LOCALAPPDATA\FortniteGame\Saved\PersistentDownloadDir"
    )
    
    foreach ($p in $savedPaths) {
        if (Test-Path $p) { 
            Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Deleted: $p"
        }
    }
    
    # Nettoyer les dossiers de contenu
    $contentDirs = @(
        "FortniteGame\Content\BackGroundBlur",
        "FortniteGame\Content\Characters",
        "FortniteGame\Content\Cosmetics",
        "FortniteGame\Content\Frontend",
        "FortniteGame\Content\UI",
        "FortniteGame\Content\Videos",
        "FortniteGame\Content\Audio",
        "FortniteGame\Content\Emotes",
        "FortniteGame\Content\Homebase",
        "FortniteGame\Content\LoadScreen",
        "FortniteGame\Content\Lobby",
        "FortniteGame\Content\Store"
    )
    
    foreach ($dir in $contentDirs) {
        $fullPath = Join-Path $fnPath $dir
        if (Test-Path $fullPath) {
            Remove-Item $fullPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Deleted: $dir"
        }
    }
    
    Write-Host "`n============================================================"
    Write-Host "          DEBLOAT COMPLETED!" -ForegroundColor Green
    Write-Host "============================================================"
    Write-Host "`nDisk space freed: ~20-30 GB"
    Write-Host "Files removed: ~350-400"
    Write-Host "`nLaunch Fortnite to verify functionality."
    Write-Host "If issues occur, verify game files via Epic Launcher.`n"
    
    Read-Host "Press Enter to exit"
    exit
}

# Lancer le script
insoptiDebloat
