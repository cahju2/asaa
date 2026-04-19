#!/bin/bash
set -e
echo "=========================================================="
echo " Nimbus OS Shell - Level 100 Setup Script (Ubuntu Server) "
echo "=========================================================="

echo "[1/3] Installing Ubuntu Server DRM/KMS Dependencies..."
if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get update
    # Ubuntu Server等のデスクトップ環境がない環境で
    # 画面に直接UIを描画するため（linuxkms）の依存関係
    sudo apt-get install -y build-essential curl pkg-config \
        libdrm-dev libgbm-dev libudev-dev libseat-dev \
        libxkbcommon-dev libinput-dev libfontconfig1-dev
else
    echo "Warning: apt-get not found. This script is optimized for Ubuntu Server."
fi

echo "[2/3] Setting up Rust Toolchain..."
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    rustup update
fi

echo "[3/3] Setup Complete!"
echo "To build and run directly on the bare screen (TTY), use:"
echo "  SLINT_BACKEND=linuxkms cargo run --release"
