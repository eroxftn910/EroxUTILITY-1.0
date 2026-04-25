<#
.SYNOPSIS
Fortnite Performance & Latency Optimization Toolkit v1.2.
Applies OS-level tweaks to boost performance, enhance responsiveness, reduce input delay, and lower network latency. 
Automatically assigns high CPU priority, prioritizes network traffic via QoS rules, and adds custom firewall exceptions. 
Excludes the Fortnite directory from Windows Defender scans to improve stability, latency, and competitive performance. 
All optimizations are 100% safe and non-invasive.

.NOTES
Author : [insopti] - (https://guns.lol/inso.vs)
Title : "Fortnite Windows System-level Tweaks performance"
Version : 1.2 / Last Update: Dec 8, 2025
#>

# https://guns.lol/inso.vs
if (-not ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {Write-Host "restart" -ForegroundColor DarkCyan -NoNewline; " the script as administrator.."; Start-Process -FilePath "powershell" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit};Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
$insoptiWindow=$Host.UI.RawUI;$insoptiWindow.WindowTitle="PowerShell Script | @insopti";$insoptiWindow.BackgroundColor="Black";Clear-Host

function insoptiwh($txt,$type="info"){;switch($type){"success"{$s="+";$c1="White";$c2="Green";if($txt -match "(.*)(successfully)(.*)"){$part1=$matches[1];$part2=$matches[2];$part3=$matches[3]}else{$part1=$txt;$part2="";$part3=""}};"error"{$s="!";$c1="DarkRed";$c2="Red"};"warning"{$s="?";$c1="Yellow";$c2="DarkYellow"};default{$s="+";$c1="DarkCyan";$c2="Cyan"}};Write-Host "[" -NoNewline -ForegroundColor $c1; Write-Host $s -NoNewline -ForegroundColor $c2; Write-Host "] " -NoNewline -ForegroundColor $c1
if($type -eq "success" -and $part2){Write-Host $part1 -NoNewline -ForegroundColor "White"; Write-Host $part2 -NoNewline -ForegroundColor "Green"; Write-Host $part3 -ForegroundColor "White"}else{Write-Host $txt -ForegroundColor $c2}}
function banner-Fortnite {;Clear-Host;echo "";Write-Host "                                 " -nonewline;Write-Host "Fortnite Performance & Latency Optimization Toolkit" -ForegroundColor black -BackgroundColor Blue -NoNewline;Write-Host " (v1.2)" -nonewline;echo "";echo "";Write-Host "                                    Copyright (C) insopti (https://guns.lol/inso.vs)." -ForegroundColor DarkGray;Write-Host "                For personal use only. Modifying, copying, or redistributing this script is prohibited." -ForegroundColor DarkGray;Write-Host "                              This script must be downloaded only from the official source." -ForegroundColor DarkGray;echo "";Write-Host "                      Provides optional OS tweaks to improve system performance and responsiveness." -ForegroundColor White;Write-Host "              Users can choose which optimizations to apply. CPU & I/O priority is raised to allocate more" -ForegroundColor White;Write-Host "              resources to Fortnite for smoother gameplay. Network tuning Throttle Rate off + DSCP 46 via QoS" -ForegroundColor White;Write-Host "                      optimized for lower latency and removes throttling for the game executable." -ForegroundColor White;Write-Host "                    Firewall rules ensure proper access without unnecessary connection interruptions." -ForegroundColor White;Write-Host "                Defender exclusions prevent background scans from negatively affecting game performance." -ForegroundColor White;Write-Host "             These changes affect only the Windows registry — They are " -ForegroundColor White -NoNewline;Write-Host "safe" -ForegroundColor Green -NoNewline;Write-Host ", " -ForegroundColor White -NoNewline;Write-Host "efficient" -ForegroundColor Cyan -NoNewline;Write-Host ", and " -ForegroundColor White -NoNewline;Write-Host "fully reversible" -ForegroundColor Yellow -NoNewline;Write-Host "." -ForegroundColor White;Write-Host "                 Important: in some cases, your game may refuse to launch or display an error on startup." -ForegroundColor Yellow
Write-Host "               If this happens, uncheck the option 'Run this program as administrator' for the executable." -ForegroundColor Yellow
echo "";Write-Host " ‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗" -ForegroundColor DarkGray;echo ""
}

banner-Fortnite;echo "";$msg = "                                            Press any key to continue...";Write-Host $msg -NoNewline
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
$pos = $host.UI.RawUI.CursorPosition;$host.UI.RawUI.CursorPosition = @{X=0;Y=$pos.Y}
Write-Host (" " * $msg.Length) -NoNewline;$host.UI.RawUI.CursorPosition = @{X=0;Y=$pos.Y}

Get-Process | Where-Object { $_.ProcessName -like "Fortinte*" } | ForEach-Object { Stop-Process -Id $_.Id -Force }
$insoptiperf,$insoptiQoS,$insoptigpu='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions','HKLM:\SOFTWARE\Policies\Microsoft\Windows\QoS\FortniteClient-Win64-Shipping','HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences'

function Get-FortniteExe {;$roots=Get-PSDrive -PSProvider FileSystem|%{$_.Root}
    $paths=foreach($r in $roots){@("$r`Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe",
                                  "$r`Program Files (x86)\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe")}
    $paths|?{Test-Path $_}|Select-Object -First 1}

function ApplyPerfOptions {;try {;New-Item -Path $insoptiperf -Force|Out-Null;@{'CpuPriorityClass'=3;'IoPriority'=3}.GetEnumerator()|%{New-ItemProperty -Path $insoptiperf -Name $_.Key -Value $_.Value -PropertyType DWord -Force|Out-Null}
        insoptiwh "Successfully set to 'High' CPU and I/O priority for the executable." "success";} catch {insoptiwh "Failed to create PerfOptions." "error"}
}

function ApplyQoS {;try {
    $ftnexe=Get-FortniteExe; if(-not $ftnexe){insoptiwh "Fortnite executable not found." "error";return}
    $ftndir=Split-Path $ftnexe
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        insoptiwh "ApplyQoS requires administrator rights." "error"; return
    }
    New-Item -Path $insoptiQoS -Force -ErrorAction Stop | Out-Null
    @{'Application Name'='FortniteClient-Win64-Shipping.exe';'AppPathName'=$ftndir;'DSCP Value'='46';'Local IP'='*';'Local IP Prefix Length'='*';'Local Port'='*';'Protocol'='*';'Remote IP'='*';'Remote IP Prefix Length'='*';'Remote Port'='*';'Throttle Rate'='-1';'Version'='1.0'}.GetEnumerator() | % {
        New-ItemProperty -Path $insoptiQoS -Name $_.Key -Value $_.Value -PropertyType String -Force -ErrorAction Stop | Out-Null
    }
    insoptiwh "Successfully set DSCP 46 (EF) with ThrottleRate disabled for prioritized network traffic." "success"
} catch {insoptiwh "QoS creation error: $($_.Exception.Message)" "error"}}

function ApplyGPU {;try {;
        if (-not (Test-Path $insoptigpu)) {New-Item -Path $insoptigpu -ItemType Directory|Out-Null}
        $ftnexe=Get-FortniteExe; if (-not $ftnexe){insoptiwh "Fortnite executable not found." "error";return}
        New-ItemProperty -Path $insoptigpu -Name $ftnexe -Value 'GpuPreference=2' -PropertyType String -Force|Out-Null
        insoptiwh "Successfully set High Performance GPU for Fortnite." "success";}
    catch {insoptiwh "GPU configuration error." "error"}}

function ApplyRunAsAdmin {;try {;
        $ftnexe=Get-FortniteExe; if (-not $ftnexe){insoptiwh "Fortnite executable not found." "error";return}
        New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" -Name $ftnexe -Value "~ RUNASADMIN" -PropertyType String -Force|Out-Null
        insoptiwh "Fortnite configured to run as admin (Compatibility)." "success"

        $ifeopath="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe"
        if (-not (Test-Path $ifeopath)) {New-Item -Path $ifeopath -Force|Out-Null}
        New-ItemProperty -Path $ifeopath -Name "RunAsAdmin" -Value 1 -PropertyType DWord -Force|Out-Null
        insoptiwh "Fortnite configured to run as admin (IFEO)." "success";}
    catch {insoptiwh "Error configuring RUNASADMIN." "error"}}

function ApplyFirewall {;try {;
        $ftnexe=Get-FortniteExe; if (-not $ftnexe) {return insoptiwh "Fortnite introuvable." "warning"}
        "In","Out" | % {New-NetFirewallRule -DisplayName "FortniteClient ($_)" -Direction "${_}bound" -Program $ftnexe -Action Allow -ErrorAction SilentlyContinue|Out-Null}
        $rules=Get-NetFirewallRule -DisplayName "FortniteClient*" -ErrorAction SilentlyContinue
        if ($rules) {
            insoptiwh "Firewall rules detected : $($rules.Count)" "info"
            $rules|%{$s=if ($_.Enabled){'Enabled'}else{'Disabled'}; insoptiwh "→ $($_.DisplayName) [$s]" "success"}
        } else {
            insoptiwh "No rules found after adding." "warning"
        }
        insoptiwh "Successfully allowed inbound and outbound traffic for Fortnite." "success";}
    catch {insoptiwh "Firewall error: $($_.Exception.Message)" "error"}}

function ApplyDefender {;try {;
        $ftndir=Get-FortniteDir; if (-not (Test-Path $ftndir)) {return insoptiwh "Fortnite directory not found." "warning"}
        Add-MpPreference -ExclusionPath $ftndir -ErrorAction SilentlyContinue

        if ($?) {insoptiwh "Successfully set Defender exclusion for Fortnite." "success"}
        else {insoptiwh "Windows Defender might be missing or the exclusion could not be applied." "warning"}}
    catch {insoptiwh "Windows Defender is missing or disabled on this system." "warning"}}

function RemoveAll {;try{if(Test-Path $insoptiperf){Remove-Item $insoptiperf -Recurse -Force};insoptiwh "Performance options removed (CPU and I/O Priority set to High)." "success"}catch{insoptiwh "Error removing performance options." "error"}
try{if(Test-Path $insoptiQoS){Remove-Item $insoptiQoS -Recurse -Force};insoptiwh "QoS removed (traffic prioritization disabled)." "success"}catch{insoptiwh "Error removing QoS." "error"}
try{$ftnexe=Get-FortniteExe;if($ftnexe -and (Test-Path $insoptigpu)){Remove-ItemProperty -Path $insoptigpu -Name $ftnexe -Force -ErrorAction SilentlyContinue};insoptiwh "GPU preference removed." "success"}catch{insoptiwh "Error removing GPU preference." "error"}
try{$layers="HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers";$ftnexe=Get-FortniteExe;if($ftnexe){Remove-ItemProperty -Path $layers -Name $ftnexe -Force -ErrorAction SilentlyContinue}
$ifeo="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe";if(Test-Path $ifeo){Remove-Item $ifeo -Recurse -Force};insoptiwh "RunAsAdmin removed." "success"}catch{insoptiwh "Error removing RunAsAdmin." "error"}
try{Remove-NetFirewallRule -DisplayName "FortniteClient (In)" -ErrorAction SilentlyContinue;Remove-NetFirewallRule -DisplayName "FortniteClient (Out)" -ErrorAction SilentlyContinue;insoptiwh "Firewall rules removed." "success"}catch{insoptiwh "Error removing firewall rules." "error"}
try{$ftndir=Get-FortniteDir;if($ftndir){Remove-MpPreference -ExclusionPath $ftndir -ErrorAction SilentlyContinue};insoptiwh "Defender exclusion removed." "success"}catch{insoptiwh "Error removing Defender exclusion." "error"}
insoptiwh "All Fortnite optimizations removed." "success"}
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
$f=New-Object Windows.Forms.Form
$f.Size=New-Object Drawing.Size(520,650);$f.StartPosition="CenterScreen"
$f.FormBorderStyle="FixedDialog";$f.MaximizeBox=$false;$f.MinimizeBox=$false
$f.BackColor=[Drawing.Color]::FromArgb(25,25,25);$f.Font=New-Object Drawing.Font("Segoe UI",9)
$f.ForeColor=[Drawing.Color]::White;$f.Opacity=0
function L($t,$s,$b,$c,$x,$y){
 $l=New-Object Windows.Forms.Label
 $l.Text=$t;$l.AutoSize=$true
 $l.Font=New-Object Drawing.Font("Segoe UI",$s,($(if($b){[Drawing.FontStyle]::Bold}else{[Drawing.FontStyle]::Regular})))
 $l.ForeColor=[Drawing.Color]::FromArgb($c[0],$c[1],$c[2])
 $l.Location=New-Object Drawing.Point($x,$y)
 $l.BackColor=[Drawing.Color]::Transparent
 $f.Controls.Add($l);return $l}
L "  ⚙" 25 $true @(0,140,255) 9 26|Out-Null;L "Fortnite Optimization Toolkit (version 1.2)" 15 $true @(0,140,255) 70 24|Out-Null
$made=New-Object Windows.Forms.Label;$made.Text="Made by @insopti";$made.AutoSize=$true
$made.Font=New-Object Drawing.Font("Segoe UI",9,[Drawing.FontStyle]::Italic)
$made.ForeColor=[Drawing.Color]::FromArgb(130,130,130)
$made.Location=New-Object Drawing.Point(72,54);$made.BackColor=[Drawing.Color]::Transparent;$f.Controls.Add($made)
$cbx=@{};$y=105;$o=@(
"All-in-One (Apply everything at once)","Automatically applies all recommended optimizations.",
"PerfOptions (CPU and I/O Priority set to High)","Sets Fortnite to higher priority on system resources for improved performance.",
"Network Optimization (add optimized QoS rules)","QoS rules optimized to stabilize network connection and reduce latency/ping.",
"GPU (High Performance)","Forces GPU usage in high performance mode in Windows for Fortnite.",
"RunAsAdmin (IFEO and Compatibility)","Configures Fortnite to always run as Administrator.",
"Firewall (Permissions)","Adds required rules to Windows Firewall to prevent blocking.",
"Defender (Exclusion)","Excludes Fortnite folder from Windows Defender to avoid slowdowns.",
"Remove all optimizations","Restores default settings and removes all applied optimizations.")
for($i=0;$i -lt $o.Count;$i+=2){
 $c=New-Object Windows.Forms.CheckBox;$c.Text=$o[$i];$c.Location=New-Object Drawing.Point(40,$y);$c.Width=440
 $c.Font=New-Object Drawing.Font("Segoe UI Semibold",9.8)
 $c.ForeColor=[Drawing.Color]::FromArgb(245,245,245);$c.BackColor=[Drawing.Color]::Transparent
 $f.Controls.Add($c);$cbx[$o[$i]]=$c
 $d=L $o[$i+1] 8.8 $false @(170,170,170) 56 ($y+22)
 $d.MaximumSize=New-Object Drawing.Size(460,0);$y+=48}
$b=New-Object Windows.Forms.Button;$b.Text="Apply"
$b.Size=New-Object Drawing.Size(220,46);$b.BackColor=[Drawing.Color]::FromArgb(0,120,255)
$b.ForeColor=[Drawing.Color]::White
$b.Font=New-Object Drawing.Font("Segoe UI Semibold",10,[Drawing.FontStyle]::Bold)
$b.FlatStyle="Flat";$b.FlatAppearance.BorderSize=0
$b.Location=New-Object Drawing.Point((($f.ClientSize.Width-$b.Width)/2),520);$f.Controls.Add($b)
$b.Add_MouseEnter({$b.BackColor=[Drawing.Color]::FromArgb(30,150,255)})
$b.Add_MouseLeave({$b.BackColor=[Drawing.Color]::FromArgb(0,120,255)})
$lf=L "  ©insopti (https://guns.lol/inso.vs)" 8 $false @(130,130,130) 0 585
$lf.Location=New-Object Drawing.Point((($f.ClientSize.Width-$lf.PreferredWidth)/2),575)
$b.Add_Click({
 if($cbx["Remove all optimizations"].Checked){RemoveAll;[Windows.Forms.MessageBox]::Show("     All optimizations have been successfully removed.")|Out-Null;return}
 if($cbx["All-in-One (Apply everything at once)"].Checked){ApplyPerfOptions;ApplyQoS;ApplyGPU;ApplyRunAsAdmin;ApplyFirewall;ApplyDefender
 [Windows.Forms.MessageBox]::Show("     ✅  All optimizations have been applied successfully !")|Out-Null;return}
 if($cbx["PerfOptions (CPU and I/O Priority set to High)"].Checked){ApplyPerfOptions}
 if($cbx["Network Optimization (add optimized QoS rules)"].Checked){ApplyQoS}
 if($cbx["GPU (High Performance)"].Checked){ApplyGPU}
 if($cbx["RunAsAdmin (IFEO and Compatibility)"].Checked){ApplyRunAsAdmin}
 if($cbx["Firewall (Permissions)"].Checked){ApplyFirewall}
 if($cbx["Defender (Exclusion)"].Checked){ApplyDefender}
 [Windows.Forms.MessageBox]::Show("       Operations completed.")|Out-Null})
$t=New-Object Windows.Forms.Timer;$t.Interval=15
$t.Add_Tick({if($f.Opacity -lt 1){$f.Opacity+=0.05}else{$t.Stop()}});$t.Start()
[void]$f.ShowDialog()
# https://guns.lol/inso.vs