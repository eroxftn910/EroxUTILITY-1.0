$url = "https://discord.com/api/download?platform=win"
$path = "$env:TEMP\DiscordSetup.exe"

Write-Host "Téléchargement Discord..."
Invoke-WebRequest $url -OutFile $path

Write-Host "Installation..."
Start-Process $path -ArgumentList "-s" -Wait

Write-Host "Discord installé."
