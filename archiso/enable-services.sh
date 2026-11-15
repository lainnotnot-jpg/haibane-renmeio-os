#!/usr/bin/env bash
# Create the symlinks the archiso runtime expects inside the airootfs.
# MUST be run as root on the Linux build host BEFORE mkarchiso
# (Windows cannot create them):
#   sudo ./enable-services.sh ./airootfs
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "error: run me as root (sudo) on the Linux build machine" >&2
  exit 1
fi

AIROOTFS="${1:-$(dirname "$(readlink -f "$0")")/airootfs}"

MU="$AIROOTFS/etc/systemd/system/multi-user.target.wants"
SY="$AIROOTFS/etc/systemd/system/sysinit.target.wants"
mkdir -p "$MU" "$SY"

# NetworkManager for the live environment + NTP sync
ln -sfn /usr/lib/systemd/system/NetworkManager.service      "$MU/NetworkManager.service"
ln -sfn /usr/lib/systemd/system/systemd-timesyncd.service   "$SY/systemd-timesyncd.service"
ln -sfn /usr/lib/systemd/system/systemd-time-wait-sync.service "$SY/systemd-time-wait-sync.service"

# pacman keyring initialization on first boot of the live system
ln -sfn /etc/systemd/system/pacman-init.service             "$MU/pacman-init.service"
ln -sfn /usr/lib/systemd/system/systemd-timesyncd.service   "$AIROOTFS/etc/systemd/system/dbus-org.freedesktop.timesync1.service"

# runtime symlinks (same as upstream releng)
ln -sfn ../usr/share/zoneinfo/UTC                           "$AIROOTFS/etc/localtime"
ln -sfn /run/systemd/resolve/stub-resolv.conf               "$AIROOTFS/etc/resolv.conf"

echo "airootfs symlinks created in $AIROOTFS:"
ls -l "$MU" "$SY" | sed 's/^/  /'
echo "Done. Now run mkarchiso."
