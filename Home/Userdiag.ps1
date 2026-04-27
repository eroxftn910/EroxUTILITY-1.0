# URL officielle UserDiag
$url = "https://userdiag.com/download/UserDiag.exe"
$tempPath = "$env:TEMP\UserDiag.exe"

Write-Host "Téléchargement de UserDiag..."
Invoke-WebRequest -Uri $url -OutFile $tempPath

Write-Host "Lancement de UserDiag..."
Start-Process $tempPath

Write-Host "Terminé."
