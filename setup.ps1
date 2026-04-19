Write-Host "=========================================================="
Write-Host " Nimbus OS Shell - Level 100 Setup Script (Windows)       "
Write-Host "=========================================================="

Write-Host "[1/2] Setting up Rust Toolchain..."
if (!(Get-Command rustup -ErrorAction SilentlyContinue)) {
    Write-Host "Installing rustup..."
    Invoke-WebRequest https://win.rustup.rs -OutFile rustup-init.exe
    .\rustup-init.exe -y
    Remove-Item .\rustup-init.exe
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} else {
    Write-Host "Rustup found. Updating..."
    rustup update
}

Write-Host "[2/2] Setup Complete!"
Write-Host "Please ensure you have Visual Studio C++ Build Tools installed."
Write-Host "To build the project, run: cargo build --release"
