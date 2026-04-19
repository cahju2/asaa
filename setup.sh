#!/bin/bash
set -e
echo "=========================================================="
echo " Nimbus OS Shell - Level 100 Setup Script (Linux/Mac)     "
echo "=========================================================="

echo "[1/3] Installing System Dependencies..."
if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get update
    sudo apt-get install -y build-essential curl pkg-config \
        libxcb-shape0-dev libxcb-xfixes0-dev libxext-dev libfontconfig1-dev \
        libxkbcommon-x11-dev libwayland-dev libx11-xcb-dev xkb-data
elif [ -x "$(command -v pacman)" ]; then
    sudo pacman -S --needed base-devel curl pkgconf libx11 libxcb \
        fontconfig libxkbcommon wayland libxkbcommon-x11
else
    echo "Warning: Supported package manager not found. Please install Slint dependencies manually."
fi

echo "[2/3] Setting up Rust Toolchain..."
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    rustup update
fi

echo "[3/3] Setup Complete!"
echo "To build the project, run:"
echo "  cargo build --release"
