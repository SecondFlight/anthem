function echo-green {
    param([string]$text)
    Write-Host ""
    Write-Host -ForegroundColor Green $text
    Write-Host ""
}

function echo-red {
    param([string]$text)
    Write-Host ""
    Write-Host -ForegroundColor Red $text
    Write-Host ""
}

# Set the script's location as the current directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $scriptPath

# Build

echo-green "Test build started"

echo-green "Creating build directory..."
New-Item -ItemType Directory -Path .\build -Force

Push-Location -Path .\build

if ($IsLinux) {
    $env:CC = "/usr/bin/clang"
    $env:CXX = "/usr/bin/clang++"
}

echo-green "Running CMake..."
cmake ..

echo-green "Building..."
cmake --build . --target AnthemTest

if (-not $?) {
    echo-red "Test build failed."
} else {
    echo-green "Test build succeeded."
}

Pop-Location

Pop-Location
