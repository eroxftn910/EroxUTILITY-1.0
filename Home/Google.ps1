$url = "https://www.google.com/chrome/install/ChromeSetup.exe"
$path = "$env:TEMP\ChromeSetup.exe"

Write-Host "Téléchargement Chrome..."
Invoke-WebRequest $url -OutFile $path

Write-Host "Installation..."
Start-Process $path -Wait

Write-Host "Chrome installé."
