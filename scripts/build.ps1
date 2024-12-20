# Set the repository root as the current directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $scriptPath\..

# Build engine executable
.\engine\build.ps1

# Ensure that the assets directory exists
New-Item -ItemType Directory -Path ".\assets\engine" -Force | Out-Null

# Set engine executable source and destination paths
$platform = [System.Environment]::OSVersion.Platform
if ($platform -eq [System.PlatformID]::Win32NT) {
    $engineExeSrc = ".\engine\build\AnthemEngine_artefacts\Debug\AnthemEngine.exe"
    $engineExeDest = ".\assets\engine\AnthemEngine.exe"
} else {
    $engineExeSrc = "./engine/build/AnthemEngine_artefacts/AnthemEngine"
    $engineExeDest = "./assets/engine/AnthemEngine"
}

Copy-Item -Path $engineExeSrc -Destination $engineExeDest

Pop-Location
