$url = "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi"
$path = "$env:TEMP\EpicInstaller.msi"

Write-Host "Téléchargement Epic Games..."
Invoke-WebRequest $url -OutFile $path

Write-Host "Installation..."
Start-Process msiexec.exe -ArgumentList "/i `"$path`" /qn" -Wait -Verb RunAs

Write-Host "Epic Games installé."
