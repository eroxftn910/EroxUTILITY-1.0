# FiveM Optimization Tool - Fixed for EroxUTILITY

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

$PerfKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM_GTAProcess.exe\PerfOptions"
$QoSKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\QoS\FiveM_GTAProcess.exe"
$GpuKey = "HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences"

function Log($msg, $color = "White") {
    Write-Host "[EroxUTILITY] $msg" -ForegroundColor $color
}

function Get-FiveMExe {
    $default = "$env:LOCALAPPDATA\FiveM\FiveM.app\data\cache\subprocess\FiveM_GTAProcess.exe"

    if (Test-Path $default) {
        return $default
    }

    foreach ($drive in Get-PSDrive -PSProvider FileSystem) {
        $path = "$($drive.Root)FiveM\FiveM.app\data\cache\subprocess\FiveM_GTAProcess.exe"
        if (Test-Path $path) {
            return $path
        }
    }

    return $null
}

function Get-FiveMDir {
    $exe = Get-FiveMExe
    if ($exe) {
        return Split-Path $exe -Parent
    }
    return $null
}

function Apply-PerfOptions {
    try {
        New-Item -Path $PerfKey -Force | Out-Null
        New-ItemProperty -Path $PerfKey -Name "CpuPriorityClass" -Value 3 -PropertyType DWord -Force | Out-Null
        New-ItemProperty -Path $PerfKey -Name "IoPriority" -Value 3 -PropertyType DWord -Force | Out-Null
        Log "CPU and I/O priority set to High." "Green"
    }
    catch {
        Log "Erreur CPU priority : $($_.Exception.Message)" "Red"
    }
}

function Apply-QoS {
    try {
        $exe = Get-FiveMExe
        if (-not $exe) {
            Log "FiveM executable introuvable." "Red"
            return
        }

        New-Item -Path $QoSKey -Force | Out-Null

        $values = @{
            "Application Name" = "FiveM_GTAProcess.exe"
            "AppPathName" = $exe
            "DSCP Value" = "46"
            "Local IP" = "*"
            "Local IP Prefix Length" = "*"
            "Local Port" = "*"
            "Protocol" = "*"
            "Remote IP" = "*"
            "Remote IP Prefix Length" = "*"
            "Remote Port" = "*"
            "Throttle Rate" = "-1"
            "Version" = "1.0"
        }

        foreach ($item in $values.GetEnumerator()) {
            New-ItemProperty -Path $QoSKey -Name $item.Key -Value $item.Value -PropertyType String -Force | Out-Null
        }

        Log "QoS réseau appliqué avec DSCP 46." "Green"
    }
    catch {
        Log "Erreur QoS : $($_.Exception.Message)" "Red"
    }
}

function Apply-GPU {
    try {
        $exe = Get-FiveMExe
        if (-not $exe) {
            Log "FiveM executable introuvable." "Red"
            return
        }

        if (-not (Test-Path $GpuKey)) {
            New-Item -Path $GpuKey -Force | Out-Null
        }

        New-ItemProperty -Path $GpuKey -Name $exe -Value "GpuPreference=2" -PropertyType String -Force | Out-Null
        Log "GPU High Performance activé pour FiveM." "Green"
    }
    catch {
        Log "Erreur GPU : $($_.Exception.Message)" "Red"
    }
}

function Apply-RunAsAdmin {
    try {
        $exe = Get-FiveMExe
        if (-not $exe) {
            Log "FiveM executable introuvable." "Red"
            return
        }

        $layers = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
        New-Item -Path $layers -Force | Out-Null
        New-ItemProperty -Path $layers -Name $exe -Value "~ RUNASADMIN" -PropertyType String -Force | Out-Null

        $ifeo = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM_GTAProcess.exe"
        New-Item -Path $ifeo -Force | Out-Null
        New-ItemProperty -Path $ifeo -Name "RunAsAdmin" -Value 1 -PropertyType DWord -Force | Out-Null

        Log "Run as administrator activé pour FiveM." "Green"
    }
    catch {
        Log "Erreur RunAsAdmin : $($_.Exception.Message)" "Red"
    }
}

function Apply-Firewall {
    try {
        $exe = Get-FiveMExe
        if (-not $exe) {
            Log "FiveM executable introuvable." "Red"
            return
        }

        New-NetFirewallRule -DisplayName "FiveMClient In" -Direction Inbound -Program $exe -Action Allow -ErrorAction SilentlyContinue | Out-Null
        New-NetFirewallRule -DisplayName "FiveMClient Out" -Direction Outbound -Program $exe -Action Allow -ErrorAction SilentlyContinue | Out-Null

        Log "Règles firewall Inbound and Outbound ajoutées." "Green"
    }
    catch {
        Log "Erreur Firewall : $($_.Exception.Message)" "Red"
    }
}

function Apply-Defender {
    try {
        $dir = Get-FiveMDir
        if (-not $dir) {
            Log "Dossier FiveM introuvable." "Red"
            return
        }

        Add-MpPreference -ExclusionPath $dir -ErrorAction SilentlyContinue
        Log "Exclusion Windows Defender ajoutée." "Green"
    }
    catch {
        Log "Erreur Defender : $($_.Exception.Message)" "Red"
    }
}

function Remove-All {
    try {
        if (Test-Path $PerfKey) {
            Remove-Item $PerfKey -Recurse -Force
        }

        if (Test-Path $QoSKey) {
            Remove-Item $QoSKey -Recurse -Force
        }

        $exe = Get-FiveMExe

        if ($exe) {
            if (Test-Path $GpuKey) {
                Remove-ItemProperty -Path $GpuKey -Name $exe -Force -ErrorAction SilentlyContinue
            }

            $layers = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
            Remove-ItemProperty -Path $layers -Name $exe -Force -ErrorAction SilentlyContinue
        }

        $ifeo = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FiveM_GTAProcess.exe"
        if (Test-Path $ifeo) {
            Remove-Item $ifeo -Recurse -Force
        }

        Remove-NetFirewallRule -DisplayName "FiveMClient In" -ErrorAction SilentlyContinue
        Remove-NetFirewallRule -DisplayName "FiveMClient Out" -ErrorAction SilentlyContinue

        $dir = Get-FiveMDir
        if ($dir) {
            Remove-MpPreference -ExclusionPath $dir -ErrorAction SilentlyContinue
        }

        Log "Toutes les optimisations ont été supprimées." "Yellow"
    }
    catch {
        Log "Erreur suppression : $($_.Exception.Message)" "Red"
    }
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "EroxUTILITY - FiveM Optimization"
$form.Size = New-Object System.Drawing.Size(540, 620)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(25,25,25)
$form.ForeColor = [System.Drawing.Color]::White

$title = New-Object System.Windows.Forms.Label
$title.Text = "FiveM Optimization Toolkit"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::FromArgb(0,140,255)
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(40, 25)
$form.Controls.Add($title)

$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = "Made for EroxUTILITY - Optimizes FiveM performance for Windows."
$subtitle.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Italic)
$subtitle.ForeColor = [System.Drawing.Color]::Gray
$subtitle.AutoSize = $true
$subtitle.Location = New-Object System.Drawing.Point(42, 62)
$form.Controls.Add($subtitle)

$checkboxes = @{}
$items = @(
    @("All-in-One", "Apply all recommended optimizations."),
    @("CPU Priority", "Set CPU and I/O priority to High."),
    @("Network Optimization", "Add optimized QoS rules."),
    @("GPU High Performance", "Force GPU high performance mode."),
    @("Run As Admin", "Make FiveM run as administrator."),
    @("Firewall Rules", "Add Inbound and Outbound firewall rules."),
    @("Defender Exclusion", "Exclude FiveM from Defender scans."),
    @("Remove All", "Remove all optimizations and restore defaults.")
)

$y = 110

foreach ($item in $items) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $item[0]
    $cb.Location = New-Object System.Drawing.Point(45, $y)
    $cb.Width = 440
    $cb.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $cb.ForeColor = [System.Drawing.Color]::White
    $cb.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($cb)
    $checkboxes[$item[0]] = $cb

    $desc = New-Object System.Windows.Forms.Label
    $desc.Text = $item[1]
    $desc.Location = New-Object System.Drawing.Point(65, $y + 23)
    $desc.Width = 430
    $desc.ForeColor = [System.Drawing.Color]::Gray
    $desc.BackColor = [System.Drawing.Color]::Transparent
    $form.Controls.Add($desc)

    $y += 52
}

$button = New-Object System.Windows.Forms.Button
$button.Text = "Apply"
$button.Size = New-Object System.Drawing.Size(220, 45)
$button.Location = New-Object System.Drawing.Point(150, 515)
$button.BackColor = [System.Drawing.Color]::FromArgb(0,120,255)
$button.ForeColor = [System.Drawing.Color]::White
$button.FlatStyle = "Flat"
$button.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($button)

$button.Add_Click({
    if ($checkboxes["Remove All"].Checked) {
        Remove-All
        [System.Windows.Forms.MessageBox]::Show("Optimisations supprimées.")
        return
    }

    if ($checkboxes["All-in-One"].Checked) {
        Apply-PerfOptions
        Apply-QoS
        Apply-GPU
        Apply-RunAsAdmin
        Apply-Firewall
        Apply-Defender
        [System.Windows.Forms.MessageBox]::Show("Toutes les optimisations ont été appliquées.")
        return
    }

    if ($checkboxes["CPU Priority"].Checked) { Apply-PerfOptions }
    if ($checkboxes["Network Optimization"].Checked) { Apply-QoS }
    if ($checkboxes["GPU High Performance"].Checked) { Apply-GPU }
    if ($checkboxes["Run As Admin"].Checked) { Apply-RunAsAdmin }
    if ($checkboxes["Firewall Rules"].Checked) { Apply-Firewall }
    if ($checkboxes["Defender Exclusion"].Checked) { Apply-Defender }

    [System.Windows.Forms.MessageBox]::Show("Opérations terminées.")
})

[void]$form.ShowDialog()
