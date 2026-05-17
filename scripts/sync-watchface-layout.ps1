param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..").Path
)

$targetRoot = Join-Path $Root "catfish-pipboy\usr\share\asteroid-launcher"
$watchfaceDir = Join-Path $targetRoot "watchfaces"
$previewDir = Join-Path $targetRoot "watchfaces-preview\480x480"
$imgDir = Join-Path $targetRoot "watchface-img"

New-Item -ItemType Directory -Force -Path $watchfaceDir,$previewDir,$imgDir | Out-Null

Copy-Item -LiteralPath (Join-Path $Root "qml\Main.qml") -Destination (Join-Path $watchfaceDir "catfish-pipboy.qml") -Force
Remove-Item -LiteralPath (Join-Path $watchfaceDir "logic") -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath (Join-Path $watchfaceDir "ui") -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath (Join-Path $watchfaceDir "settings") -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath (Join-Path $watchfaceDir "assets") -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -LiteralPath (Join-Path $Root "qml\logic") -Destination $watchfaceDir -Recurse -Force
Copy-Item -LiteralPath (Join-Path $Root "qml\ui") -Destination $watchfaceDir -Recurse -Force
Copy-Item -LiteralPath (Join-Path $Root "qml\settings") -Destination $watchfaceDir -Recurse -Force
New-Item -ItemType Directory -Force -Path (Join-Path $watchfaceDir "assets\logos"), (Join-Path $watchfaceDir "assets\map-icons"), (Join-Path $watchfaceDir "assets\other-icons") | Out-Null
Copy-Item -Path (Join-Path $Root "Logos\*.png") -Destination (Join-Path $watchfaceDir "assets\logos") -Force
Copy-Item -Path (Join-Path $Root "Map Icons\*.png") -Destination (Join-Path $watchfaceDir "assets\map-icons") -Force
Copy-Item -Path (Join-Path $Root "Other Icons\*.png") -Destination (Join-Path $watchfaceDir "assets\other-icons") -Force
Copy-Item -LiteralPath (Join-Path $Root "assets\icons\catfishpipboy_preview.svg") -Destination (Join-Path $previewDir "catfish-pipboy.svg") -Force
Copy-Item -LiteralPath (Join-Path $Root "assets\icons\catfishpipboy_preview.svg") -Destination (Join-Path $imgDir "catfish-pipboy.svg") -Force

Write-Host "AsteroidOS watchface layout synced to $targetRoot"
