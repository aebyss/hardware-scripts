#!/usr/bin/env bash

set -euo pipefail

echo "======================================"
echo " Fedora Video / Kdenlive Setup"
echo "======================================"

if [[ $EUID -eq 0 ]]; then
    echo "Do not run this script directly as root."
    echo "Run it as your normal user. sudo will be used when needed."
    exit 1
fi

FEDORA_VERSION="$(rpm -E %fedora)"

echo
echo "Fedora version: ${FEDORA_VERSION}"

echo
echo "[1/6] Installing RPM Fusion repositories..."

sudo dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"

echo
echo "[2/6] Refreshing package metadata..."

sudo dnf makecache

echo
echo "[3/6] Replacing Fedora ffmpeg-free with full FFmpeg..."

sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing || {
    echo "ffmpeg-free was probably not installed or FFmpeg is already configured."
}

echo
echo "[4/6] Installing multimedia codecs..."

sudo dnf install -y \
    ffmpeg \
    libavcodec-freeworld \
    vlc \
    mpv \
    mediainfo

echo
echo "[5/6] Installing Kdenlive..."

sudo dnf install -y kdenlive

echo
echo "[6/6] Checking video decoding support..."

echo
echo "FFmpeg:"
ffmpeg -version | head -n 1

echo
echo "HEVC decoders:"
ffmpeg -decoders 2>/dev/null | grep -i hevc || true

echo
echo "H.264 decoders:"
ffmpeg -decoders 2>/dev/null | grep -i h264 || true

echo
echo "Installed multimedia packages:"
rpm -qa | grep -E 'ffmpeg|libavcodec|kdenlive|vlc|mpv' | sort

echo
echo "======================================"
echo " Setup finished"
echo "======================================"

echo
echo "Recommended Kdenlive steps:"
echo "1. Restart Kdenlive."
echo "2. Open Settings -> Run Config Wizard if available."
echo "3. Enable Proxy Clips for GoPro/4K/HEVC footage."
echo "4. Use ffprobe <video.MP4> to inspect a GoPro clip."
