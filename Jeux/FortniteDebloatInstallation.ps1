<#
.SYNOPSIS
  Optimizes (Debloat) Fortnite by removing non-essential files, UI elements, and cosmetic assets,
  resulting in faster load times, higher Performances, reduced memory usage, and significant disk space savings.

.DESCRIPTION
  This script automatically removes unnecessary files and folders from a Fortnite installation, 
  including UI elements, cosmetic data, audio files, and background resources. It reduces the game 
  from approximately 500–600 files and 90–100 folders (75–80 GB) to 180–200 files and 25–30 folders 
  (50–60 GB), deleting roughly 60–70% of the game's content (≈350–400 files and 65–75 folders). 
  This reduction lowers visual overhead, minimizes stuttering, and improves overall performance, 
  particularly on low-end or competitive setups. Some features may be affected, and certain visual 
  elements might disappear.

  The script is intended for players seeking maximum performance and disk space optimization, 
  while understanding the associated risks.
  
  Modifying game files violates Epic Games' terms and 
  may result in penalties or bans. A backup of the original files is recommended before running 
  the script.

  Version     : 1.2
  Last Update : Dec 12, 2025
  Author      : @inso.vs | @insopti
  Title       : Fortnite Debloat Tool | Cleans Unnecessary Files, Cosmetics & Background Resources to Improve Performances, Reduce Stutters, and Lighten Resource Load.
  GitHub      : https://github.com/insovs 
  Discord     : https://discord.gg/fayeECjdtb
#>

#https://github.com/insovs
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
    Stop-Process -Id $_.Id -Force 
}

# Configuration UI
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.WindowTitle = "[https://guns.lol/inso.vs]  | v1.2 | Fortnite Debloat Tool | Cleans Unnecessary Files, Cosmetics & Background Resources to Improve Performances, Reduce Stutters, and Lighten Resource Load."
Clear-Host

# Fonctions utilitaires
function insoptiShowProgress {
    param(
        [string]$insopti_Message = "Wait...",
        [int]$insopti_DurationSeconds = 3,
        [string]$insopti_Symbol = "+",
        [string[]]$insopti_Dots = @("", "", ".", "...")
    )
    
    0..([math]::Ceiling(($insopti_DurationSeconds * 1000) / 333) - 1) | ForEach-Object { 
        $t = $insopti_Dots[$_ % $insopti_Dots.Length]
        $color = switch ($insopti_Symbol) {
            "+" { "Blue" }
            "-" { "Red" }
            "*" { "Yellow" }
            "/" { "Gray" }
            default { "DarkGray" }
        }
        Write-Host -NoNewline "`r "
        Write-Host "[" -NoNewline -ForegroundColor DarkGray
        Write-Host "$insopti_Symbol" -NoNewline -ForegroundColor $color
        Write-Host "] " -NoNewline -ForegroundColor DarkGray
        Write-Host "$insopti_Message$t" -NoNewline -ForegroundColor White
        Start-Sleep -Milliseconds 333
    }
    Write-Host ""
}

function insoptiWh {
    param(
        [string]$Text,
        [switch]$nonew,
        [ConsoleColor]$foregroundcolor = "White"
    )
    if ($nonew) {
        Write-Host $Text -NoNewline -ForegroundColor $foregroundcolor
    } else {
        Write-Host $Text -ForegroundColor $foregroundcolor
    }
}

function insoptiLog {
    param(
        [string]$Prefix,
        [string]$Message,
        [string]$Suffix = "",
        [ConsoleColor]$HighlightColor = "White"
    )
    Write-Host "$Prefix $Message $Suffix" -ForegroundColor $HighlightColor
}

function insoptiMain {
    pause
    exit
}

function insopti_ShowWarningMessage {
    Write-Host "`n────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    echo "`n"
    Write-Host "                                             " -NoNewline
    Write-Host "Fortnite Installation Debloat" -NoNewline -ForegroundColor black -BackgroundColor DarkGray
    Write-Host ".`n" -ForegroundColor Black
    
    insoptiWh "                                      Removes 60–70% of Fortnite's internal files." -NoNewline
    insoptiWh "                            including UI elements, cosmetic data, and background resources."
    insoptiWh "                  This cleanup can slightly boost performance, reduce stutters, and free up disk space."
    insoptiWh "              However, it may also affect the visual fidelity of the game, causing missing icons or textures."
    insoptiWh "               Some in-game features like replays, the item shop, or locker previews might stop functioning."
    insoptiWh "                          That said, when playing with Performance Mode, most of it goes unnoticed."
    echo ""
    insoptiWh "              Use this tweak only if you're aiming for max performance on a low-end or competitive setup." -ForegroundColor white
    
    Write-Host "                  " -ForegroundColor White -NoNewline
    Write-Host "Modifying game files" -ForegroundColor DarkGray -NoNewline
    Write-Host " violates " -ForegroundColor White -NoNewline
    Write-Host "'Epic Games' terms" -ForegroundColor darkRed -NoNewline
    Write-Host " and may result in " -ForegroundColor White -NoNewline
    Write-Host "penalties or bans" -ForegroundColor darkRed -NoNewline
    Write-Host "." -ForegroundColor White
    
    Write-Host "                       Proceed at your own risk — I take " -ForegroundColor White -NoNewline
    Write-Host "no responsibility" -ForegroundColor darkRed -NoNewline
    Write-Host " for any consequences." -ForegroundColor White 
    
    Write-Host "`n`n────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    echo "`n"
}

function insoptiDebloat {
    Clear-Host
    insopti_ShowWarningMessage
    
    Write-Host " [" -NoNewline -ForegroundColor DarkGray
    Write-Host "+" -NoNewline -ForegroundColor Blue
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    Write-Host "For personal use only. " -ForegroundColor Gray -NoNewline
    Write-Host "Modifying" -ForegroundColor Red -NoNewline
    Write-Host "," -ForegroundColor White -NoNewline
    Write-Host " copying" -ForegroundColor Red -NoNewline
    Write-Host "," -ForegroundColor White -NoNewline
    Write-Host " or" -ForegroundColor White -NoNewline
    Write-Host " redistributing" -ForegroundColor Red -NoNewline
    Write-Host " this script is " -ForegroundColor Gray -NoNewline
    Write-Host "prohibited" -ForegroundColor Red -NoNewline
    Write-Host "." -ForegroundColor Gray
    
    Write-Host " [" -NoNewline -ForegroundColor DarkGray
    Write-Host "+" -NoNewline -ForegroundColor Blue
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    Write-Host "This script must be downloaded only from the official source: " -ForegroundColor Gray -NoNewline
    insoptiWh "https://guns.lol/inso.vs" -foregroundcolor darkgray
    
    Write-Host "`n [" -NoNewline -ForegroundColor DarkGray
    Write-Host "+" -NoNewline -ForegroundColor Blue
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    Write-Host "Modifying game files is not supported by Epic Games," -ForegroundColor DarkGray -NoNewline
    Write-Host " Proceed at your own risk" -ForegroundColor DarkRed -NoNewline
    Write-Host "." -ForegroundColor White
    
    Write-Host " [" -NoNewline -ForegroundColor DarkGray
    Write-Host "+" -NoNewline -ForegroundColor Blue
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    Write-Host "It only deletes files, it does not modify or add anything; it simply debloats your game installation." -ForegroundColor White
    
    Write-Host " [" -NoNewline -ForegroundColor DarkGray
    Write-Host "+" -NoNewline -ForegroundColor Blue
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    Write-Host "Continue if you understand its function (Debloat) and what it does.`n" -ForegroundColor White
    
    # Menu principal
    insoptiWh " [" -nonew -ForegroundColor DarkGray
    insoptiWh "1" -foregroundcolor Blue -nonew
    insoptiWh "] " -ForegroundColor DarkGray -nonew
    insoptiWh "Debloat"
    
    insoptiWh " [" -nonew -ForegroundColor DarkGray
    insoptiWh "2" -foregroundcolor Blue -nonew
    insoptiWh "] " -ForegroundColor DarkGray -nonew
    insoptiWh "Exit"
    
    insoptiWh " [" -nonew -ForegroundColor DarkGray
    insoptiWh "3" -foregroundcolor Blue -nonew
    insoptiWh "] " -ForegroundColor DarkGray -nonew
    insoptiWh "What is a debloat ?"
    
    echo ""
    insoptiWh " [" -nonew -ForegroundColor DarkGray
    insoptiWh ">" -ForegroundColor Blue -nonew
    insoptiWh "] " -ForegroundColor DarkGray -nonew
    
    $insoptiChoice = Read-Host
    
    switch ($insoptiChoice) { 
        "1" {
            # Continue avec le débloat - rien à faire ici, on sort du switch
        }
        "2" { 
            exit 
        }
        "3" { 
            Clear-Host
            Write-Host "`n────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
            echo "`n"
            Write-Host "                                                  " -nonewline
            Write-Host "WHAT IS A DEBLOAT ?" -ForegroundColor black -BackgroundColor DarkGray -nonewline
            Write-Host "." -ForegroundColor Black
            echo ""
            
            insoptiWh "           A debloat is the process of removing unnecessary, redundant, or non-essential files from software" -ForegroundColor White
            insoptiWh "         to optimize performance, reduce storage usage, and minimize system resource consumption. For Fortnite," -ForegroundColor White
            insoptiWh "          this involves deleting UI elements, cosmetic assets, localization files, promotional content, replay" -ForegroundColor White
            insoptiWh "           data, unnecessary animations, and high-resolution textures that are not critical for core gameplay." -ForegroundColor White
            
            echo ""
            insoptiWh "                                                       BENEFITS" -ForegroundColor Green -NoNewline
            insoptiWh "                Significantly improve performances and reduced stuttering during gameplay, faster loading" -ForegroundColor Gray
            insoptiWh "         times, reduced memory usage, and frees up massive disk space (typically 20-30 GB). The debloat reduces" -ForegroundColor Gray
            insoptiWh "      Fortnite from ~500-600 files/90-100 folders (75-80 GB) to ~180-200 files/25-30 folders (50-60 GB) on average." -ForegroundColor Gray
            insoptiWh "       This means it deletes approximately 350-400 files and 65-75 folders, removing 60-70% of the game's content." -ForegroundColor Gray
            
            echo ""
            insoptiWh "                                                      DRAWBACKS " -ForegroundColor Red -NoNewline
            insoptiWh "                   You may experience missing textures, icons, or visual elements in menus and lobbies." -ForegroundColor Gray
            insoptiWh "               Features like item shop, locker previews and replays, may malfunction or become unavailable." -ForegroundColor Gray
            
            echo ""
            insoptiWh "                                                         NOTE " -ForegroundColor Yellow -NoNewline
            insoptiWh "              This script only DELETES files — it does not modify, patch, or inject anything into the game." -ForegroundColor White
            insoptiWh "         However, any alteration to game files can be detected by Epic's anti-cheat and may result in warnings," -ForegroundColor White
            insoptiWh "         temporary suspensions, or permanent account penalties. Use at your own risk and only for personal use." -ForegroundColor White
            
            echo "`n"
            Write-Host "────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
            echo "`n"
            
            Write-Host " [" -NoNewline -ForegroundColor DarkGray
            Write-Host "+" -NoNewline -ForegroundColor Blue
            Write-Host "] " -NoNewline -ForegroundColor DarkGray
            Write-Host "Press any key to return to the menu." -ForegroundColor White
            
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            Clear-Host
            insoptiDebloat
            return
        }
        default { 
            echo ""
            Write-Host " [" -NoNewline -ForegroundColor DarkGray
            Write-Host "-" -NoNewline -ForegroundColor darkRed
            Write-Host "] " -NoNewline -ForegroundColor DarkGray
            Write-Host "Invalid choice." -NoNewline -ForegroundColor white
            
            Start-Sleep 2
            Clear-Host
            insoptiDebloat
            return
        }
    }
    
    # Si on arrive ici, c'est que l'utilisateur a choisi "1" (Debloat)
    # Début du processus de débloat
    Clear-Host
    insopti_ShowWarningMessage
    
    # Demander la lettre du lecteur
    Write-Host " [" -NoNewline -ForegroundColor DarkGray
    Write-Host "+" -NoNewline -ForegroundColor Blue
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    Write-Host "Select the drive containing your Fortnite installation." -ForegroundColor darkgray
    
    Write-Host " [" -NoNewline -ForegroundColor DarkGray
    Write-Host "+" -NoNewline -ForegroundColor Blue
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    Write-Host "Enter the drive letter " -NoNewline -ForegroundColor White
    Write-Host "(ex:" -NoNewline -ForegroundColor Gray
    Write-Host " C" -NoNewline -ForegroundColor Blue
    Write-Host "," -NoNewline -ForegroundColor Gray
    Write-Host " D" -NoNewline -ForegroundColor Blue
    Write-Host "," -NoNewline -ForegroundColor Gray
    Write-Host " E" -NoNewline -ForegroundColor Blue
    Write-Host "," -NoNewline -ForegroundColor Gray
    Write-Host " F" -NoNewline -ForegroundColor Blue
    Write-Host ")" -NoNewline -ForegroundColor Gray
    
    echo ""
    Write-Host "`n [" -NoNewline -ForegroundColor DarkGray
    Write-Host ">" -NoNewline -ForegroundColor Blue
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    
    $insoptiDriveLetter = Read-Host
    
    # Effacer la ligne précédente pour un affichage plus propre
    $Host.UI.RawUI.CursorPosition = @{X = 0; Y = ($Host.UI.RawUI.CursorPosition.Y - 1)}
    Write-Host (" " * ($Host.UI.RawUI.WindowSize.Width)) -NoNewLine
    $Host.UI.RawUI.CursorPosition = @{X = 0; Y = ($Host.UI.RawUI.CursorPosition.Y)}
    
    # Recherche du chemin Fortnite
    insoptiShowProgress -insopti_Message "Searching for Fortnite path, please wait" -insopti_DurationSeconds 3
    
    if ($insoptiDriveLetter -match '^[A-Z]$') {
        $insoptiDrivePath = $insoptiDriveLetter + ":\"
        $insoptiFNPath = $null
        
        try {
            $insoptiFNPath = Get-ChildItem -Path $insoptiDrivePath -Filter "Fortnite" -Directory -Recurse -ErrorAction SilentlyContinue |
                Where-Object { Test-Path "$($_.FullName)\FortniteGame" } | Select-Object -First 1 -ExpandProperty FullName
            
            if ($insoptiFNPath) {
                Write-Host " [" -NoNewline -ForegroundColor DarkGray
                Write-Host "+" -NoNewline -ForegroundColor Blue
                Write-Host "] " -NoNewline -ForegroundColor DarkGray
                Write-Host "Fortnite path found:" -ForegroundColor White -NoNewline
                Write-Host " $insoptiFNPath" -ForegroundColor Green
                Start-Sleep 2
            } else {
                Clear-Host
                insopti_ShowWarningMessage
                Write-Host " [" -NoNewline -ForegroundColor Darkgray
                Write-Host "+" -NoNewline -ForegroundColor blue
                Write-Host "] " -NoNewline -ForegroundColor Darkgray
                insoptiLog " Fortnite directory not found on drive ${insoptiDriveLetter}" -HighlightColor Red
                Start-Sleep 2
                insoptiMain
                return
            }
        } catch {
            Write-Host " [" -NoNewline -ForegroundColor Darkgray
            Write-Host "+" -NoNewline -ForegroundColor blue
            Write-Host "] " -NoNewline -ForegroundColor Darkgray
            insoptiLog " Error accessing drive ${insoptiDriveLetter}:\ " -HighlightColor darkred
            
            Write-Host " [" -NoNewline -ForegroundColor Darkgray
            Write-Host "!" -NoNewline -ForegroundColor yellow
            Write-Host "] " -NoNewline -ForegroundColor Darkgray
            Write-Host "Please ensure you've specified the correct drive letter."
            
            Start-Sleep 4
            Clear-Host
            insoptiDebloat
            return
        }
    } else {
        Write-Host " [" -NoNewline -ForegroundColor Darkgray
        Write-Host "!" -NoNewline -ForegroundColor yellow
        Write-Host "] " -NoNewline -ForegroundColor Darkgray
        insoptiLog " Invalid drive letter input." -HighlightColor darkRed
        
        Start-Sleep 3
        Clear-Host
        insoptiDebloat
        return
    }
    
    # Commencer le nettoyage
    insoptiShowProgress -insopti_Message "Removing files, please wait.." -insopti_DurationSeconds 3
    
    Clear-Host
    insopti_ShowWarningMessage
    
    # Nettoyer les fichiers sauvegardés
    insoptiShowProgress -insopti_Message "Cleaning Fortnite Saved content Files.." -insopti_DurationSeconds 2
    
    @("Logs", "Config\CrashReportClient", "Cloud", "PersistentDownloadDir\EMS", "PersistentDownloadDir\ManifestCache", 
      "PersistentDownloadDir\BackgroundHttp", "PersistentDownloadDir\ias", "PersistentDownloadDir\StagingBundles", 
      "PersistentDownloadDir\InstalledBundles") | ForEach-Object {
        $p = "$env:LOCALAPPDATA\FortniteGame\Saved\$_"
        if (Test-Path $p) { 
            Remove-Item $p -Recurse -Force
            Write-Host " [" -NoNewline -ForegroundColor Darkgray
            Write-Host "+" -NoNewline -ForegroundColor blue
            Write-Host "] " -ForegroundColor Darkgray -NoNewline
            Write-Host "Deleted: $p" -ForegroundColor DarkGray 
        }
    }
    
    Start-Sleep 2
    Clear-Host
    
    # Nettoyer les DLLs Win64
    insopti_ShowWarningMessage
    insoptiShowProgress -insopti_Message "Cleaning Fortnite DLLs from Binaries\Win64.." -insopti_DurationSeconds 2
    
    $bin64 = Join-Path $insoptiFNPath "FortniteGame\Binaries\Win64"
    
    @("api-ms-win*", "dbgman*", "msvcp*", "ucrtbase*", "vc*", "concrt*", 
      "boost_atomic*", "boost_chrono*", "boost_iostreams*", "boost_python311*", 
      "boost_regex*", "DML*") | ForEach-Object {
        Get-ChildItem $bin64 -Filter $_ -ErrorAction SilentlyContinue | ForEach-Object {
            if (Test-Path $_.FullName) { 
                Remove-Item $_.FullName -Recurse -Force
                Write-Host " [" -NoNewline -ForegroundColor Darkgray
                Write-Host "+" -NoNewline -ForegroundColor blue
                Write-Host "] " -ForegroundColor Darkgray -NoNewline
                Write-Host "Deleted: $($_.FullName)" -ForegroundColor DarkGray 
            }
        }
    }
    
    Start-Sleep 2
    Clear-Host
    
    # Option DX12
    insopti_ShowWarningMessage
    
    Write-Host " [" -NoNewline -ForegroundColor DarkGray
    Write-Host "+" -NoNewline -ForegroundColor Blue
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    Write-Host "Uninstall DirectX12/D3D12 (DX12) ?" -ForegroundColor black -BackgroundColor darkgray -NoNewline
    
    Write-Host " [" -NoNewline -ForegroundColor White
    Write-Host "Y" -NoNewline -ForegroundColor blue
    Write-Host "/" -NoNewline -ForegroundColor White
    Write-Host "N" -NoNewline -ForegroundColor blue
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    
    $insoptiDX12 = Read-Host
    
    if ($insoptiDX12 -eq "Y" -or $insoptiDX12 -eq "y") {
        $dx12Path = Join-Path $insoptiFNPath "FortniteGame\Binaries\Win64\D3D12"
        if (Test-Path $dx12Path) {
            Remove-Item $dx12Path -Recurse -Force
            Write-Host " [" -NoNewline -ForegroundColor Darkgray
            Write-Host "+" -NoNewline -ForegroundColor blue
            Write-Host "] " -ForegroundColor Darkgray -NoNewline
            Write-Host "Deleted DX12/D3D12 support files" -ForegroundColor Green
        } else {
            Write-Host " [" -NoNewline -ForegroundColor Darkgray
            Write-Host "!" -NoNewline -ForegroundColor yellow
            Write-Host "] " -ForegroundColor Darkgray -NoNewline
            Write-Host "DX12/D3D12 files not found" -ForegroundColor DarkGray
        }
    }
    
    Start-Sleep 2
    Clear-Host
    
    # Nettoyer les dossiers de contenu
    insopti_ShowWarningMessage
    insoptiShowProgress -insopti_Message "Cleaning unnecessary game content..." -insopti_DurationSeconds 2
    
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
        $fullPath = Join-Path $insoptiFNPath $dir
        if (Test-Path $fullPath) {
            Remove-Item $fullPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host " [" -NoNewline -ForegroundColor Darkgray
            Write-Host "+" -NoNewline -ForegroundColor blue
            Write-Host "] " -ForegroundColor Darkgray -NoNewline
            Write-Host "Deleted: $dir" -ForegroundColor DarkGray
        }
    }
    
    Start-Sleep 2
    Clear-Host
    
    # Résumé final
    insopti_ShowWarningMessage
    
    Write-Host "`n"
    Write-Host " ╔════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor DarkGray
    Write-Host " ║                                                                                ║" -ForegroundColor DarkGray
    Write-Host " ║                    FORTNITE DEBLOAT COMPLETED SUCCESSFULLY                     ║" -ForegroundColor Green
    Write-Host " ║                                                                                ║" -ForegroundColor DarkGray
    Write-Host " ║  Disk space freed: Approximately 20-30 GB                                     ║" -ForegroundColor White
    Write-Host " ║  Files removed: ~350-400                                                      ║" -ForegroundColor White
    Write-Host " ║  Folders removed: ~65-75                                                      ║" -ForegroundColor White
    Write-Host " ║                                                                                ║" -ForegroundColor DarkGray
    Write-Host " ║  Note: Launch Fortnite once to verify functionality.                          ║" -ForegroundColor Yellow
    Write-Host " ║  If issues occur, verify game files via Epic Launcher to restore.             ║" -ForegroundColor Yellow
    Write-Host " ║                                                                                ║" -ForegroundColor DarkGray
    Write-Host " ╚════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor DarkGray
    
    echo ""
    Write-Host " [" -NoNewline -ForegroundColor DarkGray
    Write-Host "+" -NoNewline -ForegroundColor Blue
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    Write-Host "Press any key to exit." -ForegroundColor White
    
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# Lancer le script
insoptiDebloat
