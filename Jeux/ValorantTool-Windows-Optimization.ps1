<#
.SYNOPSIS
Valorant Performance & Latency Optimization Toolkit (v1.3).
Applies OS-level tweaks to boost performance, enhance responsiveness, reduce input delay, and lower network latency. 
Automatically assigns high CPU priority, prioritizes network traffic via QoS rules, and adds custom firewall exceptions. 
Excludes the Valorant directory from Windows Defender scans to improve stability, latency, and competitive performance. 
All optimizations are 100% safe and non-invasive.

.NOTES
Author : [insopti/inso.vs] - (https://guns.lol/inso.vs)
Title : "Valorant Performance & Latency Optimization Toolkit System-level Tweaks."
Version : 1.3 / Last Update: Jan 21, 2026
#>

# https://guns.lol/inso.vs
if (-not ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "restart the script as administrator.." -ForegroundColor DarkCyan
    Start-Process -FilePath "powershell" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

$insoptiWindow = $Host.UI.RawUI
$insoptiWindow.WindowTitle = "[https://guns.lol/inso.vs] | Valorant Performance and Latency Optimization Toolkit."
$insoptiWindow.BackgroundColor = "Black"
Clear-Host

function insoptiwh {
    param($txt, $type = "info")
    
    switch($type) {
        "success" { $s = "+"; $c1 = "white"; $c2 = "Green" }
        "error" { $s = "!"; $c1 = "DarkRed"; $c2 = "Red" }
        "warning" { $s = "?"; $c1 = "red"; $c2 = "DarkYellow" }
        default { $s = "+"; $c1 = "DarkCyan"; $c2 = "Cyan" }
    }
    
    Write-Host "[" -NoNewline -ForegroundColor $c1
    Write-Host $s -NoNewline -ForegroundColor $c2
    Write-Host "] " -NoNewline -ForegroundColor $c1
    Write-Host $txt -ForegroundColor $c2
}

function insoptiwrth {
    param(
        [Parameter(ValueFromPipeline=$true)]$Object,
        [string]$ForegroundColor,
        [switch]$NoNewline,
        [string]$BackgroundColor
    )
    $params = @{}
    if ($Object) { $params['Object'] = $Object }
    if ($ForegroundColor) { $params['ForegroundColor'] = $ForegroundColor }
    if ($BackgroundColor) { $params['BackgroundColor'] = $BackgroundColor }
    if ($NoNewline) { $params['NoNewline'] = $true }
    Write-Host @params
}

function insoptibanner {
    Clear-Host
    Write-Output ""
    Write-Output ""
    Write-Host "                                   " -NoNewline
    Write-Host "Valorant Performance and Latency Optimization Toolkit" -ForegroundColor Black -BackgroundColor Blue -NoNewline
    Write-Host "." -NoNewline -ForegroundColor Black
    Write-Output ""
    Write-Output ""
    Write-Host "                For personal use only. " -ForegroundColor DarkGray -NoNewline
    Write-Host "Modifying" -ForegroundColor Red -NoNewline
    Write-Host ", " -ForegroundColor DarkGray -NoNewline
    Write-Host "copying" -ForegroundColor Red -NoNewline
    Write-Host ", or " -ForegroundColor DarkGray -NoNewline
    Write-Host "redistributing" -ForegroundColor Red -NoNewline
    Write-Host " this script is " -ForegroundColor DarkGray -NoNewline
    Write-Host "prohibited" -ForegroundColor Red -NoNewline
    Write-Host "." -ForegroundColor DarkGray
    Write-Host "                              This script must be downloaded only from the official source." -ForegroundColor DarkGray
    Write-Output ""
    Write-Host "                      Provides optional OS tweaks to improve system performance and responsiveness." -ForegroundColor White
    Write-Host "              Users can choose which optimizations to apply. CPU and I/O priority is raised to allocate more" -ForegroundColor White
    Write-Host "              resources to Valorant for smoother gameplay. Network tuning Throttle Rate off + DSCP 46 via QoS" -ForegroundColor White
    Write-Host "                      optimized for lower latency and removes throttling for the game executable." -ForegroundColor White
    Write-Host "                    Firewall rules ensure proper access without unnecessary connection interruptions." -ForegroundColor White
    Write-Host "                Defender exclusions prevent background scans from negatively affecting game performance." -ForegroundColor White
    Write-Host "             These changes affect only the Windows registry - They are " -ForegroundColor White -NoNewline
    Write-Host "safe" -ForegroundColor Blue -NoNewline
    Write-Host ", " -ForegroundColor White -NoNewline
    Write-Host "efficient" -ForegroundColor Cyan -NoNewline
    Write-Host ", and " -ForegroundColor White -NoNewline
    Write-Host "fully reversible" -ForegroundColor Blue -NoNewline
    Write-Host "." -ForegroundColor White
    Write-Host " "
    Write-Host "                    Note: in some cases, your game may refuse to launch or display an error on startup." -ForegroundColor Yellow
    Write-Host "               This is caused by 'runasadmin optimization' for some users, the game can may refuse to launch." -ForegroundColor Yellow
    Write-Output ""
    Write-Host " ------------------------------------------------------------------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Output ""
}

insoptibanner
Write-Output ""

$insoptimsg = "                                              Press any key to continue.."
Write-Host $insoptimsg -NoNewline
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$insoptipos = $host.UI.RawUI.CursorPosition
$host.UI.RawUI.CursorPosition = @{X = 0; Y = $insoptipos.Y}
Write-Host (" " * $insoptimsg.Length) -NoNewline
$host.UI.RawUI.CursorPosition = @{X = 0; Y = $insoptipos.Y}

Get-Process | Where-Object { $_.ProcessName -like "Valorant*" } | ForEach-Object {
    Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
}

$insoptiperf = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe\PerfOptions'
$insoptiQoS = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\QoS\VALORANT-Win64-Shipping.exe'
$insoptigpu = 'HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences'

function insoptiGetValorantExe {
    $insoptiroots = Get-PSDrive -PSProvider FileSystem | ForEach-Object { $_.Root }
    $insoptipaths = foreach ($r in $insoptiroots) {
        "${r}Riot Games\VALORANT\live\ShooterGame\Binaries\Win64\VALORANT-Win64-Shipping.exe"
        "${r}VALORANT\live\ShooterGame\Binaries\Win64\VALORANT-Win64-Shipping.exe"
    }
    $insoptipaths | Where-Object { Test-Path $_ } | Select-Object -First 1
}

function insoptiGetValorantDir {
    $insoptiexePath = insoptiGetValorantExe
    if ($insoptiexePath) {
        Split-Path $insoptiexePath -Parent -Parent -Parent -Parent
    } else {
        $null
    }
}

function insoptiApplyPerfOptions {
    try {
        New-Item -Path $insoptiperf -Force | Out-Null
        New-ItemProperty -Path $insoptiperf -Name "CpuPriorityClass" -Value 3 -PropertyType DWord -Force | Out-Null
        New-ItemProperty -Path $insoptiperf -Name "IoPriority" -Value 3 -PropertyType DWord -Force | Out-Null
        Write-Host "[" -NoNewline -ForegroundColor White
        Write-Host "+" -NoNewline -ForegroundColor Green
        Write-Host "] " -NoNewline -ForegroundColor White
        Write-Host "Successfully" -NoNewline -ForegroundColor Green
        Write-Host " set CPU and I/O priority to " -NoNewline -ForegroundColor White
        Write-Host "High" -NoNewline -ForegroundColor Green
        Write-Host ", Allocates more system resources to Valorant in foreground." -ForegroundColor White
    } catch {
        insoptiwh "Failed to configure performance options." "error"
    }
}

function insoptiApplyQoS {
    try {
        $insoptiValoexe = insoptiGetValorantExe
        if (-not $insoptiValoexe) {
            insoptiwh "Valorant executable not found." "error"
            return
        }
        New-Item -Path $insoptiQoS -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "Application Name" -Value "VALORANT-Win64-Shipping.exe" -PropertyType String -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "AppPathName" -Value $insoptiValoexe -PropertyType String -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "DSCP Value" -Value "46" -PropertyType String -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "Local IP" -Value "*" -PropertyType String -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "Local IP Prefix Length" -Value "*" -PropertyType String -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "Local Port" -Value "*" -PropertyType String -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "Protocol" -Value "*" -PropertyType String -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "Remote IP" -Value "*" -PropertyType String -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "Remote IP Prefix Length" -Value "*" -PropertyType String -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "Remote Port" -Value "*" -PropertyType String -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "Throttle Rate" -Value "-1" -PropertyType String -Force -ErrorAction Stop | Out-Null
        New-ItemProperty -Path $insoptiQoS -Name "Version" -Value "1.0" -PropertyType String -Force -ErrorAction Stop | Out-Null
        insoptiwh "Successfully created QoS rules and set DSCP 46 (EF) with ThrottleRate disabled for prioritized network traffic." "success"
    } catch {
        insoptiwh "QoS creation error: $($_.Exception.Message)" "error"
    }
}

function insoptiApplyGPU {
    try {
        if (-not (Test-Path $insoptigpu)) {
            New-Item -Path $insoptigpu -ItemType Directory | Out-Null
        }
        $insoptiValoexe = insoptiGetValorantExe
        if (-not $insoptiValoexe) {
            insoptiwh "Valorant executable not found." "error"
            return
        }
        New-ItemProperty -Path $insoptigpu -Name $insoptiValoexe -Value "GpuPreference=2" -PropertyType String -Force | Out-Null
        Write-Host "[" -NoNewline -ForegroundColor White
        Write-Host "+" -NoNewline -ForegroundColor Green
        Write-Host "] " -NoNewline -ForegroundColor White
        Write-Host "Successfully" -NoNewline -ForegroundColor Green
        Write-Host " set GPU preference to " -NoNewline -ForegroundColor White
        Write-Host "High Performance" -NoNewline -ForegroundColor Green
        Write-Host ", in Windows Settings." -ForegroundColor White
    } catch {
        insoptiwh "GPU configuration error." "error"
    }
}

function insoptiApplyRunAsAdmin {
    try {
        $insoptiValoexe = insoptiGetValorantExe
        if (-not $insoptiValoexe) {
            insoptiwh "Valorant executable not found." "error"
            return
        }
        New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" -Name $insoptiValoexe -Value "~ RUNASADMIN" -PropertyType String -Force | Out-Null
        $insoptiifeopath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe"
        if (-not (Test-Path $insoptiifeopath)) {
            New-Item -Path $insoptiifeopath -Force | Out-Null
        }
        New-ItemProperty -Path $insoptiifeopath -Name "RunAsAdmin" -Value 1 -PropertyType DWord -Force | Out-Null
        Write-Host "[" -NoNewline -ForegroundColor White
        Write-Host "+" -NoNewline -ForegroundColor Green
        Write-Host "] " -NoNewline -ForegroundColor White
        Write-Host "Successfully" -NoNewline -ForegroundColor Green
        Write-Host " configured Valorant to run as " -NoNewline -ForegroundColor White
        Write-Host "Administrator" -NoNewline -ForegroundColor Green
        Write-Host ", Grants elevated privileges for better compatibility." -ForegroundColor White
    } catch {
        insoptiwh "Error configuring administrator privileges." "error"
    }
}

function insoptiApplyFirewall {
    try {
        $insoptiValoexe = insoptiGetValorantExe
        if (-not $insoptiValoexe) {
            insoptiwh "Valorant executable not found." "error"
            return
        }
        New-NetFirewallRule -DisplayName "ValorantClient (In)" -Direction Inbound -Program $insoptiValoexe -Action Allow -ErrorAction SilentlyContinue | Out-Null
        New-NetFirewallRule -DisplayName "ValorantClient (Out)" -Direction Outbound -Program $insoptiValoexe -Action Allow -ErrorAction SilentlyContinue | Out-Null
        Write-Host "[" -NoNewline -ForegroundColor White
        Write-Host "+" -NoNewline -ForegroundColor Green
        Write-Host "] " -NoNewline -ForegroundColor White
        Write-Host "Successfully" -NoNewline -ForegroundColor Green
        Write-Host " added firewall rules " -NoNewline -ForegroundColor White
        Write-Host "Inbound and Outbound" -NoNewline -ForegroundColor Green
        Write-Host ", Prevents connection blocking and packet loss." -ForegroundColor White
    } catch {
        insoptiwh "Firewall configuration error: $($_.Exception.Message)" "error"
    }
}

function insoptiApplyDefender {
    try {
        $insoptiValodir = insoptiGetValorantDir
        if (-not (Test-Path $insoptiValodir)) {
            insoptiwh "Valorant directory not found." "error"
            return
        }
        Add-MpPreference -ExclusionPath $insoptiValodir -ErrorAction SilentlyContinue
        if ($?) {
            Write-Host "[" -NoNewline -ForegroundColor White
            Write-Host "+" -NoNewline -ForegroundColor Green
            Write-Host "] " -NoNewline -ForegroundColor White
            Write-Host "Successfully" -NoNewline -ForegroundColor Green
            Write-Host " added Windows Defender " -NoNewline -ForegroundColor White
            Write-Host "Exclusion" -NoNewline -ForegroundColor Green
            Write-Host ", Prevents background scans from impacting performance." -ForegroundColor White
        } else {
            insoptiwh "Windows Defender exclusion could not be applied." "warning"
        }
    } catch {
        insoptiwh "Error Defender exclusion: Windows Defender is disabled or unavailable on this system. No changes have been made." "error"
    }
}

function insoptiRemoveAll {
    try {
        if (Test-Path $insoptiperf) { Remove-Item $insoptiperf -Recurse -Force }
        Write-Host "[" -NoNewline -ForegroundColor White
        Write-Host "+" -NoNewline -ForegroundColor Yellow
        Write-Host "] " -NoNewline -ForegroundColor White
        Write-Host "Successfully" -NoNewline -ForegroundColor Yellow
        Write-Host " removed CPU and I/O priority, Restored to " -NoNewline -ForegroundColor White
        Write-Host "Normal" -NoNewline -ForegroundColor Cyan
        Write-Host " default priority." -ForegroundColor White
    } catch {
        insoptiwh "Error removing performance options." "error"
    }
    
    try {
        if (Test-Path $insoptiQoS) { Remove-Item $insoptiQoS -Recurse -Force }
        Write-Host "[" -NoNewline -ForegroundColor White
        Write-Host "+" -NoNewline -ForegroundColor Yellow
        Write-Host "] " -NoNewline -ForegroundColor White
        Write-Host "Successfully" -NoNewline -ForegroundColor Yellow
        Write-Host " removed Network Custom QoS rules traffic priority " -NoNewline -ForegroundColor White
        Write-Host "Deleted" -NoNewline -ForegroundColor Cyan
        Write-Host "." -ForegroundColor White
    } catch {
        insoptiwh "Error removing QoS." "error"
    }
    
    try {
        $insoptiValoexe = insoptiGetValorantExe
        if ($insoptiValoexe -and (Test-Path $insoptigpu)) {
            Remove-ItemProperty -Path $insoptigpu -Name $insoptiValoexe -Force -ErrorAction SilentlyContinue
        }
        Write-Host "[" -NoNewline -ForegroundColor White
        Write-Host "+" -NoNewline -ForegroundColor Yellow
        Write-Host "] " -NoNewline -ForegroundColor White
        Write-Host "Successfully" -NoNewline -ForegroundColor Yellow
        Write-Host " removed GPU preference, Restored to " -NoNewline -ForegroundColor White
        Write-Host "System Default" -NoNewline -ForegroundColor Cyan
        Write-Host " GPU settings." -ForegroundColor White
    } catch {
        insoptiwh "Error removing GPU preference." "error"
    }
    
    try {
        $insoptilayers = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
        $insoptiValoexe = insoptiGetValorantExe
        if ($insoptiValoexe) {
            Remove-ItemProperty -Path $insoptilayers -Name $insoptiValoexe -Force -ErrorAction SilentlyContinue
        }
        $insoptiifeo = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe"
        if (Test-Path $insoptiifeo) { Remove-Item $insoptiifeo -Recurse -Force }
        Write-Host "[" -NoNewline -ForegroundColor White
        Write-Host "+" -NoNewline -ForegroundColor Yellow
        Write-Host "] " -NoNewline -ForegroundColor White
        Write-Host "Successfully" -NoNewline -ForegroundColor Yellow
        Write-Host " removed administrator privileges, Runs as " -NoNewline -ForegroundColor White
        Write-Host "Standard User" -NoNewline -ForegroundColor Cyan
        Write-Host " mode." -ForegroundColor White
    } catch {
        insoptiwh "Error removing administrator privileges." "error"
    }
    
    try {
        Remove-NetFirewallRule -DisplayName "ValorantClient (In)" -ErrorAction SilentlyContinue
        Remove-NetFirewallRule -DisplayName "ValorantClient (Out)" -ErrorAction SilentlyContinue
        Write-Host "[" -NoNewline -ForegroundColor White
        Write-Host "+" -NoNewline -ForegroundColor Yellow
        Write-Host "] " -NoNewline -ForegroundColor White
        Write-Host "Successfully" -NoNewline -ForegroundColor Yellow
        Write-Host " removed firewall rules, Custom rules " -NoNewline -ForegroundColor White
        Write-Host "Deleted" -NoNewline -ForegroundColor Cyan
        Write-Host "." -ForegroundColor White
    } catch {
        insoptiwh "Error removing firewall rules." "error"
    }
    
    try {
        $insoptiValodir = insoptiGetValorantDir
        if ($insoptiValodir) {
            Remove-MpPreference -ExclusionPath $insoptiValodir -ErrorAction SilentlyContinue
        }
        Write-Host "[" -NoNewline -ForegroundColor White
        Write-Host "+" -NoNewline -ForegroundColor Yellow
        Write-Host "] " -NoNewline -ForegroundColor White
        Write-Host "Successfully" -NoNewline -ForegroundColor Yellow
        Write-Host " removed Defender exclusion, Folder protection " -NoNewline -ForegroundColor White
        Write-Host "'Re-enabled'" -NoNewline -ForegroundColor Cyan
        Write-Host "." -ForegroundColor White
    } catch {
        insoptiwh "Error removing Defender exclusion. Windows Defender is disabled or unavailable on this system." "error"
    }
    
    Write-Host "[" -NoNewline -ForegroundColor White
    Write-Host "+" -NoNewline -ForegroundColor Green
    Write-Host "] " -NoNewline -ForegroundColor White
    Write-Host "All optimizations successfully removed" -NoNewline -ForegroundColor Green
    Write-Host ", System restored to default Windows configuration." -ForegroundColor White
}

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

$insoptif = New-Object Windows.Forms.Form
$insoptif.Size = New-Object Drawing.Size(525, 650)
$insoptif.StartPosition = "CenterScreen"
$insoptif.FormBorderStyle = "FixedDialog"
$insoptif.MaximizeBox = $false
$insoptif.MinimizeBox = $false
$insoptif.BackColor = [Drawing.Color]::FromArgb(25, 25, 25)
$insoptif.Font = New-Object Drawing.Font("Segoe UI", 9)
$insoptif.ForeColor = [Drawing.Color]::White
$insoptif.Opacity = 0

function insoptiL {
    param($t, $s, $b, $c, $x, $y)
    
    $l = New-Object Windows.Forms.Label
    $l.Text = $t
    $l.AutoSize = $true
    $l.Font = New-Object Drawing.Font("Segoe UI", $s, ($(if ($b) { [Drawing.FontStyle]::Bold } else { [Drawing.FontStyle]::Regular })))
    $l.ForeColor = [Drawing.Color]::FromArgb($c[0], $c[1], $c[2])
    $l.Location = New-Object Drawing.Point($x, $y)
    $l.BackColor = [Drawing.Color]::Transparent
    $insoptif.Controls.Add($l)
    return $l
}

insoptiL "  ⚙" 25 $true @(0, 140, 255) 9 26 | Out-Null
insoptiL "Valorant Optimization Toolkit." 15 $true @(0, 140, 255) 70 24 | Out-Null

$insoptimade = New-Object Windows.Forms.Label
$insoptimade.Text = "Made by @insopti | Optimizes Valorant performance for Windows."
$insoptimade.AutoSize = $true
$insoptimade.Font = New-Object Drawing.Font("Segoe UI", 9, [Drawing.FontStyle]::Italic)
$insoptimade.ForeColor = [Drawing.Color]::FromArgb(130, 130, 130)
$insoptimade.Location = New-Object Drawing.Point(72, 54)
$insoptimade.BackColor = [Drawing.Color]::Transparent
$insoptif.Controls.Add($insoptimade)

$insopticbx = @{}
$insoptiy = 105
$insoptio = @(
    "All-in-One (Apply everything at once)", "Automatically applies all recommended optimizations.",
    "CPU Priority (CPU and I/O Priority set to High)", "Sets Valorant to higher priority on system resources for improved performance.",
    "Network Optimization (add optimized QoS rules)", "QoS rules optimized to stabilize network connection and reduce latency/ping.",
    "GPU (High Performance)", "Forces GPU usage in high performance mode in Windows for Valorant.",
    "RunAsAdmin (IFEO and Compatibility)", "Configures Valorant to always run as Administrator.",
    "Firewall (Permissions)", "Adds required rules to Windows Firewall to prevent blocking.",
    "Defender (Exclusion)", "Excludes Valorant folder from Windows Defender to avoid slowdowns.",
    "Remove all optimizations (deletes all changes)", "Restores default settings and removes all applied optimizations."
)

for ($i = 0; $i -lt $insoptio.Count; $i += 2) {
    $c = New-Object Windows.Forms.CheckBox
    $c.Text = $insoptio[$i]
    $c.Location = New-Object Drawing.Point(40, $insoptiy)
    $c.Width = 440
    $c.Font = New-Object Drawing.Font("Segoe UI Semibold", 9.8)
    $c.ForeColor = [Drawing.Color]::FromArgb(245, 245, 245)
    $c.BackColor = [Drawing.Color]::Transparent
    $insoptif.Controls.Add($c)
    $insopticbx[$insoptio[$i]] = $c
    
    $d = insoptiL $insoptio[$i + 1] 8.8 $false @(170, 170, 170) 56 ($insoptiy + 22)
    $d.MaximumSize = New-Object Drawing.Size(460, 0)
    $insoptiy += 48
}

$insoptib = New-Object Windows.Forms.Button
$insoptib.Text = "Apply"
$insoptib.Size = New-Object Drawing.Size(220, 46)
$insoptib.BackColor = [Drawing.Color]::FromArgb(0, 120, 255)
$insoptib.ForeColor = [Drawing.Color]::White
$insoptib.Font = New-Object Drawing.Font("Segoe UI Semibold", 10, [Drawing.FontStyle]::Bold)
$insoptib.FlatStyle = "Flat"
$insoptib.FlatAppearance.BorderSize = 0
$insoptib.Location = New-Object Drawing.Point((($insoptif.ClientSize.Width - $insoptib.Width) / 2), 520)
$insoptif.Controls.Add($insoptib)

$insoptib.Add_MouseEnter({
    $insoptib.BackColor = [Drawing.Color]::FromArgb(30, 150, 255)
})
$insoptib.Add_MouseLeave({
    $insoptib.BackColor = [Drawing.Color]::FromArgb(0, 120, 255)
})

$insoptilf = insoptiL "  ©insopti (https://guns.lol/inso.vs)" 8 $false @(130, 130, 130) 0 585
$insoptilf.Location = New-Object Drawing.Point((($insoptif.ClientSize.Width - $insoptilf.PreferredWidth) / 2), 575)

$insoptib.Add_Click({
    if ($insopticbx["Remove all optimizations (deletes all changes)"].Checked) {
        insoptiRemoveAll
        [Windows.Forms.MessageBox]::Show("     All optimizations have been successfully removed.") | Out-Null
        return
    }
    if ($insopticbx["All-in-One (Apply everything at once)"].Checked) {
        insoptiApplyPerfOptions
        insoptiApplyQoS
        insoptiApplyGPU
        insoptiApplyRunAsAdmin
        insoptiApplyFirewall
        insoptiApplyDefender
        [Windows.Forms.MessageBox]::Show("     [OK] All optimizations have been applied successfully !") | Out-Null
        return
    }
    if ($insopticbx["CPU Priority (CPU and I/O Priority set to High)"].Checked) { insoptiApplyPerfOptions }
    if ($insopticbx["Network Optimization (add optimized QoS rules)"].Checked) { insoptiApplyQoS }
    if ($insopticbx["GPU (High Performance)"].Checked) { insoptiApplyGPU }
    if ($insopticbx["RunAsAdmin (IFEO and Compatibility)"].Checked) { insoptiApplyRunAsAdmin }
    if ($insopticbx["Firewall (Permissions)"].Checked) { insoptiApplyFirewall }
    if ($insopticbx["Defender (Exclusion)"].Checked) { insoptiApplyDefender }
    [Windows.Forms.MessageBox]::Show("       Operations completed.") | Out-Null
})

$insoptit = New-Object Windows.Forms.Timer
$insoptit.Interval = 15
$insoptit.Add_Tick({
    if ($insoptif.Opacity -lt 1) {
        $insoptif.Opacity += 0.05
    } else {
        $insoptit.Stop()
    }
})
$insoptit.Start()

[void]$insoptif.ShowDialog()
# https://guns.lol/inso.vs
