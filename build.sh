#!/usr/bin/env bash
# Haibane RenmeiOS — one-shot ISO build script (run on Arch Linux, as root).
#   sudo ./build.sh
# Output ISO lands in ./out/
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "error: run me as root (sudo) on an Arch Linux machine" >&2
  exit 1
fi

command -v mkarchiso >/dev/null 2>&1 || {
  echo "Installing archiso…"
  pacman -Sy --needed --noconfirm archiso
}

cd "$(dirname "$(readlink -f "$0")")/archiso"

echo "==> Enabling services in the airootfs overlay"
./enable-services.sh ./airootfs

echo "==> Building the ISO (this takes a while)"
mkarchiso -v -w /tmp/haibane-renmeio-work -o "$PWD/../out" .

echo "==> Done! ISO is in ../out/"
sha256sum ../out/*.iso || true
