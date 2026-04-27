$url = "https://download.scdn.co/SpotifySetup.exe"
$path = "$env:TEMP\SpotifySetup.exe"

Write-Host "Téléchargement Spotify..."
Invoke-WebRequest $url -OutFile $path

Write-Host "Installation..."
Start-Process $path -Wait

Write-Host "Spotify installé."
