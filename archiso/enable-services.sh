#!/usr/bin/env bash
# Enable systemd services in the airootfs overlay for the LIVE ISO.
# MUST be run as root on the Linux build host BEFORE mkarchiso,
# because Windows cannot create the symlinks directly:
#   sudo ./enable-services.sh ./airootfs
#
# NOTE: sddm is deliberately NOT enabled here. archiso's live root account
# works via getty autologin, but is locked for graphical logins — starting
# SDDM on the live ISO would strand the user at an unusable login screen.
# SDDM is meant to be enabled on the *installed* system instead:
#   sudo systemctl enable --now sddm NetworkManager
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "error: run me as root (sudo) on the Linux build machine" >&2
  exit 1
fi

AIROOTFS="${1:-$(dirname "$(readlink -f "$0")")/airootfs}"
WANTS="$AIROOTFS/etc/systemd/system/multi-user.target.wants"
mkdir -p "$WANTS"

for svc in NetworkManager.service systemd-timesyncd.service; do
  ln -sfn "/usr/lib/systemd/system/$svc" "$WANTS/$svc"
  echo "enabled $svc -> $WANTS/$svc"
done

echo "Service enablement done. Now run mkarchiso."
echo "Reminder: after installing to disk, enable SDDM with:"
echo "  sudo systemctl enable --now sddm NetworkManager"