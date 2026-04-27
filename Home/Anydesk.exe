# Téléchargement AnyDesk
$url = "https://download.anydesk.com/AnyDesk.exe"
$tempPath = "$env:TEMP\AnyDesk.exe"

Write-Host "Téléchargement de AnyDesk..."
Invoke-WebRequest -Uri $url -OutFile $tempPath

Write-Host "Lancement de AnyDesk..."
Start-Process $tempPath

Write-Host "Terminé."
