#!/usr/bin/env bash
# Haibane RenmeiOS — archiso profile definition
# Build with:  sudo mkarchiso -v -w /tmp/haibane-work -o out/ .
# (or just push to main — .github/workflows/build-iso.yml builds it for you)
set -euo pipefail

iso_name="haibane-renmeio-os"
iso_label="HAIBANE_REMEI_OS"
iso_publisher="Haibane RenmeiOS Project <https://github.com/lainnotnot-jpg/haibane-renmeio-os>"
iso_application="Haibane RenmeiOS Live/Rescue ISO"
iso_version="$(date --utc +%Y.%m.%d)"
install_dir="haibane"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-b' '1M' '-Xbcj' 'x86')

file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/usr/local/bin/haibane-setup"]="0:0:755"
)
