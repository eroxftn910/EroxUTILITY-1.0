<#
.SYNOPSIS
  Optimizes (Debloat) Fortnite by removing non-essential files, UI elements, and cosmetic assets,
  resulting in faster load times, higher Performances, reduced memory usage, and significant disk space savings.

.DESCRIPTION
  This script automatically removes unnecessary files and folders from a Fortnite installation, 
  including UI elements, cosmetic data, audio files, and background resources. It reduces the game 
  from approximately 500–600 files and 90–100 folders (75–80 GB) to 180–200 files and 25–30 folders 
  (50–60 GB), deleting roughly 60–70% of the game’s content (≈350–400 files and 65–75 folders). 
  This reduction lowers visual overhead, minimizes stuttering, and improves overall performance, 
  particularly on low-end or competitive setups. Some features may be affected, and certain visual 
  elements might disappear.

  The script is intended for players seeking maximum performance and disk space optimization, 
  while understanding the associated risks.
  
  Modifying game files violates Epic Games’ terms and 
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
Set-Alias insoptiwrht Write-Host;if (-not ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) { insoptiwrht "restart" -ForegroundColor DarkCyan -NoNewline; " the script as administrator.."; Start-Process -FilePath "powershell" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;PAUSE; exit }
$ErrorActionPreference = 'SilentlyContinue'; Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Get-Process | Where-Object { $_.ProcessName -like "epic*" -or $_.ProcessName -like "fortnite*" } | ForEach-Object { Stop-Process -Id $_.Id -Force }
$Host.UI.RawUI.BackgroundColor = "Black"; $Host.UI.RawUI.WindowTitle = "[https://guns.lol/inso.vs]  | v1.2 | Fortnite Debloat Tool | Cleans Unnecessary Files, Cosmetics & Background Resources to Improve Performances, Reduce Stutters, and Lighten Resource Load."; Clear-Host
function insoptiShowProgress { param([string]$insopti_Message="Wait...",[int]$insopti_DurationSeconds=3,[string]$insopti_Symbol="+",[string[]]$insopti_Dots=@("","",".","...")); 0..([math]::Ceiling(($insopti_DurationSeconds*1000)/333)-1)|%{ $t=$insopti_Dots[$_%$insopti_Dots.Length]; $color=switch($insopti_Symbol){ "+" {"Blue"} "-" {"Red"} "*" {"Yellow"} "/" {"Gray"} default {"DarkGray"} }; insoptiwrht -NoNewline "`r "; insoptiwrht "[" -NoNewline -ForegroundColor DarkGray; insoptiwrht "$insopti_Symbol" -NoNewline -ForegroundColor $color; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; insoptiWrht "$insopti_Message$t" -NoNewline -ForegroundColor White; Start-Sleep -Milliseconds 333 }; insoptiwrht "" }
function insoptiWh { param([string]$Text,[switch]$nonew,[ConsoleColor]$foregroundcolor="White"); if($nonew){ insoptiwrht $Text -NoNewline -ForegroundColor $foregroundcolor } else { insoptiwrht $Text -ForegroundColor $foregroundcolor } }
function insoptiLog{param([string]$Prefix,[string]$Message,[string]$Suffix="",[ConsoleColor]$HighlightColor="White");insoptiwrht "$Prefix $Message $Suffix" -ForegroundColor $HighlightColor}
function insoptiMain{pause;exit}
function insopti_ShowWarningMessage {
    insoptiwrht "`n────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray;echo "`n"
    insoptiwrht "                                             " -NoNewline; insoptiwrht "Fortnite Installation Debloat" -NoNewline -ForegroundColor black -BackgroundColor DarkGray ;insoptiwrht ".`n" -ForegroundColor Black; insoptiWh "                                      Removes 60–70% of Fortnite's internal files." -NoNewline; insoptiWh "                            including UI elements, cosmetic data, and background resources."; insoptiWh "                  This cleanup can slightly boost performance, reduce stutters, and free up disk space."; insoptiWh "              However, it may also affect the visual fidelity of the game, causing missing icons or textures."; insoptiWh "               Some in-game features like replays, the item shop, or locker previews might stop functioning."; insoptiWh "                          That said, when playing with Performance Mode, most of it goes unnoticed."; echo ""; insoptiWh "              Use this tweak only if you're aiming for max performance on a low-end or competitive setup." -ForegroundColor white
    Write-Host "                  " -ForegroundColor White -NoNewline; Write-Host "Modifying game files" -ForegroundColor DarkGray -NoNewline; Write-Host " violates " -ForegroundColor White -NoNewline; Write-Host "'Epic Games' terms" -ForegroundColor darkRed -NoNewline; Write-Host " and may result in " -ForegroundColor White -NoNewline; Write-Host "penalties or bans" -ForegroundColor darkRed -NoNewline; Write-Host "." -ForegroundColor White
    Write-Host "                       Proceed at your own risk — I take " -ForegroundColor White -NoNewline; Write-Host "no responsibility" -ForegroundColor darkRed -NoNewline; Write-Host " for any consequences." -ForegroundColor White 
    insoptiwrht "`n`n────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
echo "`n"
}
function insoptiDebloat {
    insoptiwrht "`n────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray;echo "`n"
    insoptiwrht "                                             " -NoNewline; insoptiwrht "Fortnite Installation Debloat" -NoNewline -ForegroundColor black -BackgroundColor DarkGray ;insoptiwrht ".`n" -ForegroundColor Black; insoptiWh "                                      Removes 60–70% of Fortnite's internal files." -NoNewline; insoptiWh "                            including UI elements, cosmetic data, and background resources."; insoptiWh "                  This cleanup can slightly boost performance, reduce stutters, and free up disk space."; insoptiWh "              However, it may also affect the visual fidelity of the game, causing missing icons or textures."; insoptiWh "               Some in-game features like replays, the item shop, or locker previews might stop functioning."; insoptiWh "                          That said, when playing with Performance Mode, most of it goes unnoticed."; echo ""; insoptiWh "              Use this tweak only if you're aiming for max performance on a low-end or competitive setup." -ForegroundColor white
    Write-Host "                  " -ForegroundColor White -NoNewline; Write-Host "Modifying game files" -ForegroundColor DarkGray -NoNewline; Write-Host " violates " -ForegroundColor White -NoNewline; Write-Host "'Epic Games' terms" -ForegroundColor darkRed -NoNewline; Write-Host " and may result in " -ForegroundColor White -NoNewline; Write-Host "penalties or bans" -ForegroundColor darkRed -NoNewline; Write-Host "." -ForegroundColor White
    Write-Host "                       Proceed at your own risk — I take " -ForegroundColor White -NoNewline; Write-Host "no responsibility" -ForegroundColor darkRed -NoNewline; Write-Host " for any consequences." -ForegroundColor White 
    insoptiwrht "`n`n────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
echo "`n"
insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " For personal use only. " -ForegroundColor Gray -NoNewline; insoptiwrht "Modifying" -ForegroundColor Red -NoNewline; insoptiwrht "," -ForegroundColor White -NoNewline; insoptiwrht " copying" -ForegroundColor Red -NoNewline; insoptiwrht "," -ForegroundColor White -NoNewline; insoptiwrht " or" -ForegroundColor White -NoNewline; insoptiwrht " redistributing" -ForegroundColor Red -NoNewline; insoptiwrht " this script is " -ForegroundColor Gray -NoNewline; insoptiwrht "prohibited" -ForegroundColor Red -NoNewline; insoptiwrht "." -ForegroundColor Gray; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray;insoptiwrht " This script must be downloaded only from the official source: " -ForegroundColor Gray -NoNewline; insoptiwh "https://guns.lol/inso.vs" -foregroundcolor darkgray;
insoptiwrht "`n [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " " -NoNewline; insoptiwrht "modifying" -ForegroundColor darkRed -NoNewline; insoptiwrht " game files is not supported by Epic Games," -ForegroundColor DarkGray -NoNewline; insoptiwrht " Proceed at your own risk" -ForegroundColor DarkRed -NoNewline; insoptiwrht "." -ForegroundColor White ;insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiWrht " It only deletes files, it does not modify or add anything; it simply debloats your game installation." -ForegroundColor White; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiWrht " Continue if you understand its function (Debloat) and what it does.`n" -ForegroundColor White
insoptiWh " [" -nonew -ForegroundColor DarkGray; insoptiWh "1" -foregroundcolor Blue -nonew; insoptiWh "] " -ForegroundColor DarkGray -nonew; insoptiWh "Debloat"; insoptiWh " [" -nonew -ForegroundColor DarkGray; insoptiWh "2" -foregroundcolor Blue -nonew; insoptiWh "] " -ForegroundColor DarkGray -nonew; insoptiWh "Exit"; insoptiWh " [" -nonew -ForegroundColor DarkGray; insoptiWh "3" -foregroundcolor Blue -nonew; insoptiWh "] " -ForegroundColor DarkGray -nonew; insoptiWh "What is a debloat ?"; echo ""; insoptiWh " [" -nonew -ForegroundColor DarkGray; insoptiWh ">" -ForegroundColor Blue -nonew; insoptiWh "] " -ForegroundColor DarkGray -nonew; $insoptiChoice = Read-Host
    switch ($insoptiChoice) { 
        "1" {} 
        "2" { exit } 
        "3" { 
            Clear-Host; insoptiwrht "`n────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
            echo "`n"; insoptiwrht "                                                  " -nonewline; insoptiwrht "WHAT IS A DEBLOAT ?" -ForegroundColor black -BackgroundColor DarkGray -nonewline; insoptiwrht "." -ForegroundColor Black; echo ""
            insoptiWh "           A debloat is the process of removing unnecessary, redundant, or non-essential files from software" -ForegroundColor White; insoptiWh "         to optimize performance, reduce storage usage, and minimize system resource consumption. For Fortnite," -ForegroundColor White; insoptiWh "          this involves deleting UI elements, cosmetic assets, localization files, promotional content, replay" -ForegroundColor White; insoptiWh "           data, unnecessary animations, and high-resolution textures that are not critical for core gameplay." -ForegroundColor White; echo ""; insoptiWh "                                                       BENEFITS" -ForegroundColor Green -NoNewline; insoptiWh "                Significantly improve performances and reduced stuttering during gameplay, faster loading" -ForegroundColor Gray; insoptiWh "         times, reduced memory usage, and frees up massive disk space (typically 20-30 GB). The debloat reduces" -ForegroundColor Gray
            insoptiWh "      Fortnite from ~500-600 files/90-100 folders (75-80 GB) to ~180-200 files/25-30 folders (50-60 GB) on average." -ForegroundColor Gray; insoptiWh "       This means it deletes approximately 350-400 files and 65-75 folders, removing 60-70% of the game's content." -ForegroundColor Gray; echo ""; insoptiWh "                                                      DRAWBACKS " -ForegroundColor Red -NoNewline; insoptiWh "                   You may experience missing textures, icons, or visual elements in menus and lobbies." -ForegroundColor Gray
            insoptiWh "               Features like item shop, locker previews and replays, may malfunction or become unavailable." -ForegroundColor Gray; echo ""; insoptiWh "                                                         NOTE " -ForegroundColor Yellow -NoNewline; insoptiWh "              This script only DELETES files — it does not modify, patch, or inject anything into the game." -ForegroundColor White; insoptiWh "         However, any alteration to game files can be detected by Epic's anti-cheat and may result in warnings," -ForegroundColor White; insoptiWh "         temporary suspensions, or permanent account penalties. Use at your own risk and only for personal use." -ForegroundColor White
            echo "`n"; insoptiwrht "────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
            echo "`n";insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; insoptiWh "Press any key to return to the menu." -ForegroundColor White
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown"); Clear-host; insoptiDebloat
        }
default { 
    echo ""; 
    insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "-" -NoNewline -ForegroundColor darkRed; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; insoptiwrht "Invalid choice." -NoNewline -ForegroundColor white; 
    Start-Sleep 2; Clear-Host; insoptiDebloat }}
    Clear-Host;insopti_ShowWarningMessage; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiWrht " Select the drive containing your Fortnite installation." -ForegroundColor darkgray; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiWh " Enter the drive letter " -nonew -ForegroundColor White; insoptiWh "(ex:" -nonew -ForegroundColor Gray; insoptiWh " C" -nonew -ForegroundColor Blue; insoptiWh "," -nonew -ForegroundColor Gray; insoptiWh " D" -nonew -ForegroundColor Blue; insoptiWh "," -nonew -ForegroundColor Gray; insoptiWh " E" -nonew -ForegroundColor Blue; insoptiWh "," -nonew -ForegroundColor Gray; insoptiWh " F" -nonew -ForegroundColor Blue; insoptiWh ")" -nonew -ForegroundColor Gray; echo ""; insoptiwrht "`n [" -NoNewline -ForegroundColor DarkGray; insoptiwrht ">" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; $insoptiDriveLetter = Read-Host;
    $Host.UI.RawUI.CursorPosition = @{X=0;Y=($Host.UI.RawUI.CursorPosition.Y - 1)};insoptiwhrt (" " * ($Host.UI.RawUI.WindowSize.Width)) -NoNewLine;$Host.UI.RawUI.CursorPosition = @{X=0;Y=($Host.UI.RawUI.CursorPosition.Y)};insoptiwhrt ""
    insoptiShowProgress -insopti_Message "Searching for Fortnite path, please wait" -insopti_DurationSeconds 3
    if ($insoptiDriveLetter -match '^[A-Z]$') {
        $insoptiDrivePath = $insoptiDriveLetter + ":\"  
        $insoptiFNPath = $null
    try {
        $insoptiFNPath = Get-ChildItem -Path $insoptiDrivePath -Filter "Fortnite" -Directory -Recurse -ErrorAction SilentlyContinue |
            Where-Object { Test-Path "$($_.FullName)\FortniteGame" } | Select-Object -First 1 -ExpandProperty FullName
        if ($insoptiFNPath) {
            insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " Fortnite path found:" -ForegroundColor White -NoNewline; insoptiwrht " $insoptiFNPath" -ForegroundColor Green; Start-Sleep 2
        } else {
            Clear-host;insopti_ShowWarningMessage;insoptiwrht " [" -NoNewline -ForegroundColor Darkgray; insoptiwrht "+" -NoNewline -ForegroundColor blue; insoptiwrht "]" -NoNewline -ForegroundColor Darkgray
            insoptiLog " Fortnite directory not found on drive ${insoptiDriveLetter}" -HighlightColor Red; Start-Sleep 2; insoptiMain
        }
    } catch {
        insoptiwrht " [" -NoNewline -ForegroundColor Darkgray; insoptiwrht "+" -NoNewline -ForegroundColor blue; insoptiwrht "]" -NoNewline -ForegroundColor Darkgray
        insoptiLog " Error accessing drive ${insoptiDriveLetter}:\ " -HighlightColor darkred; insoptiwrht " [" -NoNewline -ForegroundColor Darkgray; insoptiwrht "!" -NoNewline -ForegroundColor yellow; insoptiwrht "]" -NoNewline -ForegroundColor Darkgray; insoptiwrht " Please ensure you've specified the correct drive letter."; Start-Sleep 4; clear-host; insoptidebloat
    } } else { insoptiwrht " [" -NoNewline -ForegroundColor Darkgray; insoptiwrht "!" -NoNewline -ForegroundColor yellow; insoptiwrht "]" -NoNewline -ForegroundColor Darkgray; insoptiLog " Invalid drive letter input." -HighlightColor darkRed; Start-Sleep 3;clear-host; insoptiDebloat
}

insoptiShowProgress -insopti_Message "Removing files, please wait.." -insopti_DurationSeconds 3;Clear-Host; insopti_ShowWarningMessage;insoptiShowProgress -insopti_Message "Cleaning Fortnite Saved content Files.." -insopti_DurationSeconds 2
@("Logs", "Config\CrashReportClient", "Cloud", "PersistentDownloadDir\EMS", "PersistentDownloadDir\ManifestCache", "PersistentDownloadDir\BackgroundHttp", "PersistentDownloadDir\ias", "PersistentDownloadDir\StagingBundles", "PersistentDownloadDir\InstalledBundles") | ForEach-Object {
    $p = "$env:LOCALAPPDATA\FortniteGame\Saved\$_"; if (Test-Path $p) { Remove-Item $p -Recurse -Force; insoptiwrht " [" -NoNewline -ForegroundColor Darkgray; insoptiwrht "+" -NoNewline -ForegroundColor blue; insoptiwrht "]" -ForegroundColor Darkgray -NoNewline; insoptiwrht " Deleted: $p" -ForegroundColor DarkGray }
};Start-Sleep 2;Clear-Host

insopti_ShowWarningMessage;insoptiShowProgress -insopti_Message "Cleaning Fortnite DLLs from Binaries\Win64.." -insopti_DurationSeconds 2
$bin64 = Join-Path $insoptiFNPath "FortniteGame\Binaries\Win64"
@("api-ms-win*", "dbgman*", "msvcp*", "ucrtbase*", "vc*", "concrt*", "boost_atomic*", "boost_chrono*", "boost_iostreams*", "boost_python311*", "boost_regex*", "DML*") | ForEach-Object {
    Get-ChildItem $bin64 -Filter $_ -ErrorAction SilentlyContinue | ForEach-Object {
        if (Test-Path $_.FullName) { Remove-Item $_.FullName -Recurse -Force;insoptiwrht " [" -NoNewline -ForegroundColor Darkgray; insoptiwrht "+" -NoNewline -ForegroundColor blue; insoptiwrht "]" -ForegroundColor Darkgray -NoNewline; insoptiwrht " Deleted: $($_.FullName)" -ForegroundColor DarkGray }
    }
};Start-Sleep 2;Clear-Host

insopti_ShowWarningMessage; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; insoptiWrht "Uninstall DirectX12/D3D12 (DX12) ?" -ForegroundColor black -BackgroundColor darkgray -NoNewline;insoptiWrht " [" -NoNewline -ForegroundColor White; insoptiWrht "Y" -NoNewline -ForegroundColor blue; insoptiWrht "/" -NoNewline -ForegroundColor White; insoptiWrht "N" -NoNewline -ForegroundColor Red; insoptiWrht "]" -ForegroundColor White
insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiWrht " If you choose to remove the DX12 component, this will uninstal DX12 support and force the game to use DX11." -ForegroundColor White
insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; insoptiwrht "Not recommended" -ForegroundColor Red -NoNewline; insoptiwrht " If you are using the new " -ForegroundColor white -NoNewline; insoptiwrht "Performance Mode" -ForegroundColor Red -NoNewline; insoptiwrht " !" -ForegroundColor White; insoptiwrht "`n [" -NoNewline -ForegroundColor DarkGray; insoptiwrht ">" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; $insoptiDX12 = Read-Host; if ($insoptiDX12 -eq "Y") { Remove-Item "$bin64\D3D12" -Recurse -Force -ErrorAction SilentlyContinue }
Start-Sleep 2;Clear-Host; insopti_ShowWarningMessage;insoptiShowProgress -insopti_Message "Removing Unused Game Content.." -insopti_DurationSeconds 2
@(
    "$insoptiFNPath\FortniteGame\Content\DefaultTags", "$bin64\EasyAntiCheat\Licenses", "$bin64\EasyAntiCheat\EasyAntiCheat_EOS_Setup.exe", "$insoptiFNPath\FortniteGame\Content\Splash",
    "$insoptiFNPath\Engine\Binaries\ThirdParty\MaterialX", "$insoptiFNPath\Engine\Binaries\ThirdParty\Windows\WinPixEventRuntime", "$insoptiFNPath\FortniteGame\Content\PackagedReplays",
    "$insoptiFNPath\FortniteGame\Content\Legal", "$insoptiFNPath\FortniteGame\Content\Movies", "$insoptiFNPath\Engine\Programs", "$insoptiFNPath\Engine\Content", "$insoptiFNPath\Engine\Plugins",
    "$insoptiFNPath\Engine\Binaries\Win64", "$insoptiFNPath\Engine\Binaries\ThirdParty\CEF3", "$insoptiFNPath\Engine\Binaries\ThirdParty\Dbgman", "$insoptiFNPath\Engine\Binaries\ThirdParty\NVIDIA",
    "$insoptiFNPath\Engine\Binaries\ThirdParty\PhysX3"
) | ForEach-Object {
    if (Test-Path $_) { Remove-Item $_ -Recurse -Force -ErrorAction SilentlyContinue;insoptiwrht " [" -NoNewline -ForegroundColor Darkgray; insoptiwrht "+" -NoNewline -ForegroundColor blue; insoptiwrht "]" -ForegroundColor Darkgray -NoNewline; insoptiwrht " Deleted: $_" -ForegroundColor DarkGray }
};Start-Sleep 2;Clear-Host

insopti_ShowWarningMessage;insoptiShowProgress -insopti_Message "Cleaning Epic Games Launcher.." -insopti_DurationSeconds 2
@("$env:LOCALAPPDATA\EpicGamesLauncher\Saved\Cache", "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\Logs", "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\Config\CrashReportClient") | ForEach-Object {
    if (Test-Path $_) { Remove-Item $_ -Recurse -Force -ErrorAction SilentlyContinue; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " Deleted: $_" -ForegroundColor DarkGray }
}
Get-ChildItem "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\WebCache_*" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-Item $_.FullName -Recurse -Force
    insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " Deleted: $($_.FullName)" -ForegroundColor DarkGray
};Start-Sleep 2;Clear-Host
insopti_ShowWarningMessage;insoptiShowProgress -insopti_Message "Cleaning BattlEye and EAC files.." -insopti_DurationSeconds 2
$beye = "$insoptiFNPath\FortniteGame\Binaries\Win64\BattlEye"
Get-ChildItem "$beye\Text" -ErrorAction SilentlyContinue | ForEach-Object {
    if (Test-Path $_.FullName) { Remove-Item $_.FullName -Recurse -Force; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " Deleted: $($_.FullName)" -ForegroundColor DarkGray }
}
@("$beye\Privacy", "$beye\Uninstall_BattlEye.bat", "$beye\Install_BattlEye.bat", "$beye\Licenses.txt", "$beye\EULA.txt", "$bin64\EasyAntiCheat\SplashScreen.png", "$bin64\EasyAntiCheat\Localization", "$insoptiFNPath\Cloud") |
ForEach-Object {
    if (Test-Path $_) { Remove-Item $_ -Recurse -Force -ErrorAction SilentlyContinue; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " Deleted: $_" -ForegroundColor DarkGray }
};Start-Sleep 2;Clear-Host;insopti_ShowWarningMessage
insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; insoptiwrht "Remove high resolution textures ?" -ForegroundColor black -BackgroundColor darkgray -NoNewline; insoptiwrht " [" -NoNewline -ForegroundColor White; insoptiwrht "Y" -NoNewline -ForegroundColor blue; insoptiwrht "/" -NoNewline -ForegroundColor White; insoptiwrht "N" -NoNewline -ForegroundColor Red; insoptiwrht "]" -ForegroundColor White; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " This removes HD textures (skins, maps, items). Expect lower detail and blurrier cosmetics.`n" -ForegroundColor White; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht ">" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; $insoptiCosmetics = Read-Host
if ($insoptiCosmetics -eq "Y") {
$Host.UI.RawUI.CursorPosition = @{X=0;Y=($Host.UI.RawUI.CursorPosition.Y - 1)};insoptiwrht (" " * ($Host.UI.RawUI.WindowSize.Width)) -NoNewLine;$Host.UI.RawUI.CursorPosition = @{X=0;Y=($Host.UI.RawUI.CursorPosition.Y)};insoptiwrht ""
    Get-ChildItem -Path "$insoptiFNPath\FortniteGame\Content\Paks\pakchunk*optional-WindowsClient*" -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " Deleted: $($_.FullName)" -ForegroundColor DarkGray
    }
    Get-ChildItem -Path "$insoptiFNPath\FortniteGame\Content\Paks\pakChunkEarly-WindowsClient*" -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " Deleted: $($_.FullName)" -ForegroundColor DarkGray
    }
    Get-ChildItem -Path "$insoptiFNPath\FortniteGame\Content\Paks\pakchunk*ondemand-WindowsClient*" -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " Deleted: $($_.FullName)" -ForegroundColor DarkGray
    }
};Start-Sleep 2;Clear-Host
    insopti_ShowWarningMessage;insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; insoptiwrht "Remove XInput / Handles controller input ?" -ForegroundColor black -BackgroundColor darkgray -NoNewline; insoptiwrht " [" -NoNewline -ForegroundColor White; insoptiwrht "Y" -NoNewline -ForegroundColor Blue; insoptiwrht "/" -NoNewline -ForegroundColor White; insoptiwrht "N" -NoNewline -ForegroundColor Red; insoptiwrht "]" -ForegroundColor White
insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " Disabling XInput will remove support for Xbox controllers and other DirectInput-compatible gamepads.`n" -ForegroundColor White
insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht ">" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; $insoptiController = Read-Host
    if ($insoptiController -eq "Y") {
    $Host.UI.RawUI.CursorPosition = @{X=0;Y=($Host.UI.RawUI.CursorPosition.Y - 1)};insoptiwrht (" " * ($Host.UI.RawUI.WindowSize.Width)) -NoNewLine;$Host.UI.RawUI.CursorPosition = @{X=0;Y=($Host.UI.RawUI.CursorPosition.Y)};insoptiwrht ""
        if (Test-Path "$insoptiFNPath\FortniteGame\Binaries\Win64\xinput1_3.dll") { Remove-Item -Path "$insoptiFNPath\FortniteGame\Binaries\Win64\xinput1_3.dll" -Force -ErrorAction SilentlyContinue; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "]" -NoNewline -ForegroundColor DarkGray; insoptiwrht " Deleted: $insoptiFNPath\FortniteGame\Binaries\Win64\xinput1_3.dll" -ForegroundColor DarkGray }
    }; Start-Sleep 2;Clear-Host; insopti_ShowWarningMessage
       insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; insoptiwrht "Script " -NoNewline; insoptiwrht "completed successfully !" -ForegroundColor Green
       insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; insoptiwrht "If you wish to revert the changes " -NoNewline -ForegroundColor DarkGray; insoptiwrht "you will need to verify your game files via the Epic Games Launcher," -ForegroundColor white; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; insoptiwrht "or reinstall the game completely for a full rollback/clean installation." -ForegroundColor white; insoptiwrht " [" -NoNewline -ForegroundColor DarkGray; insoptiwrht "+" -NoNewline -ForegroundColor Blue; insoptiwrht "] " -NoNewline -ForegroundColor DarkGray; insoptiwrht "Press any key to exit." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown");Clear-host}; insoptidebloat

insoptidebloat
#https://github.com/insovs
