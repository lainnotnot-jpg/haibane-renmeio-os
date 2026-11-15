# Haibane RenmeiOS

> *"Our wings are not for flying — they are for learning to walk."*

An **Arch Linux**-based distribution themed after the Haibane Renmei series,
built to be beautiful out of the box: **Hyprland** + **Shadow Shell**
([DarkShadowShell](https://github.com/shadowww-dev/DarkShadowShell) — a
Material 3 Quickshell shell by *shadoww.dev*) and a hand-tuned **fastfetch**
that greets you with the Haibane Renmei ASCII portrait in white, grey and
halo-gold.

![Haibane RenmeiOS fastfetch](assets/haibane-renmei.txt)

## What's inside

| Piece | Ships |
|---|---|
| Base | Arch Linux, `linux-zen` kernel, rolling release |
| Desktop | Hyprland (Wayland), SDDM login manager (enabled on the installed system) |
| Shell | Shadow Shell v3.60 (bar, island, launcher, dock, widgets, lock screen, Settings app `SUPER+U`) |
| Terminal | kitty + fish |
| Fastfetch | custom logo at `/usr/share/haibane-renmei-os/haibane-renmei.txt`, config in `~/.config/fastfetch/config.jsonc` (both for new users via `/etc/skel` and for root/live) |
| Audio | PipeWire + WirePlumber |
| Network | NetworkManager (enabled at boot in the ISO) |
| Browser | Firefox & Chromium |
| Wallpapers | 3 preinstalled Haibane Renmei artworks — system-wide in `/usr/share/haibane-renmei-os/wallpapers/` **and** per-user in `~/Pictures/Wallpapers/` (picked up by Shadow Shell's wallpaper sheet, `SUPER+W`). hyprpaper shows `rakka-halo.jpg` by default |
| Installer | `archinstall` (included in the live ISO) |
| Offline assets | Shadow Shell tarball bundled at `/usr/share/darkshadowshell/` — no network needed for first setup |

## Repository layout

```
HaibaneRenmeiOS/
├── build.sh                     # one-shot ISO build (Arch Linux, root)
├── assets/
│   ├── haibane-renmei.txt       # the fastfetch ASCII portrait
│   └── haibane-renmei-os.svg    # halo/wings logo
├── LICENSE
└── archiso/                     # archiso profile — this *is* the distro
    ├── profiledef.sh            # ISO name/label, boot modes, permissions
    ├── packages.x86_64          # everything that goes into the ISO
    ├── pacman.conf
    ├── enable-services.sh       # systemd enablement (needs Linux root)
    └── airootfs/                # files overlaid on top of the live system
        ├── usr/lib/os-release   # NAME="Haibane RenmeiOS", ID=haibane-renmeio-os
        ├── etc/hostname, motd, issue
        ├── etc/skel/.config/fastfetch/config.jsonc   # ← your fastfetch look
        ├── root/.config/fastfetch/config.jsonc       # ← same for the live root user
        ├── etc/skel/.config/hypr/                    # default Hyprland + hyprpaper (Rakka wallpaper)
        ├── etc/skel/Pictures/Wallpapers/             # ← per-user wallpaper copies
        ├── usr/local/bin/haibane-setup               # installs Shadow Shell offline
        └── usr/share/haibane-renmei-os/              # logo + about.txt + wallpapers/
```

## Building the ISO

### Route A — GitHub Actions (no admin, no Linux needed on your PC)

A ready-to-use workflow lives at [`.github/workflows/build-iso.yml`](.github/workflows/build-iso.yml).
Push this repo to GitHub and run it — the ISO is built in an Arch container and
uploaded as a downloadable artifact:

```bash
git init && git add . && git commit -m "Haibane RenmeiOS 1.0 (Rakka)"
git branch -M main
git remote add origin https://github.com/<you>/haibane-renmeio-os.git
git push -u origin main
```

Then: **Actions → Build Haibane RenmeiOS ISO → Run workflow**. When it finishes
(~15–40 min), download the `haibane-renmeio-os-iso` artifact from the run page
and move the `.iso` anywhere — e.g. `C:\Users\<you>\Downloads\`.
Pushing a tag (`git tag v1.0 && git push --tags`) additionally attaches the ISO
to a GitHub Release, so it stays a permanent download link.

> You need [Git](https://git-scm.com/download/win) (any install works). If you
> don't want to install Git at all: create the repo on github.com, use
> **Add file → Upload files**, drag the whole `HaibaneRenmeiOS` folder in,
> commit, and then run the workflow from the Actions tab — same result.

### Route B — local Arch Linux build

You need an **Arch Linux** machine (or Arch VM/container with KVM). Windows
cannot create the airootfs symlinks or run `mkarchiso`, which is why
`enable-services.sh` exists — it enables `NetworkManager` and
`systemd-timesyncd` inside the image before packaging. (SDDM is intentionally
*not* started on the live image — see the note below.)

```bash
sudo pacman -S --needed archiso git
git clone https://github.com/lainn/haibane-renmeio-os
cd haibane-renmeio-os
sudo ./build.sh
# ISO → out/haibane-renmeio-os-YYYY.MM.DD-x86_64.iso
```

Or step by step:

```bash
cd archiso
sudo ./enable-services.sh ./airootfs   # creates systemd wants-symlinks
sudo mkarchiso -v -w /tmp/haibane-renmeio-work -o ../out .
```

> **Note on boot:** the live ISO deliberately boots to a text console
> (archiso autologins root on a getty). SDDM is *not* started in the live
> image because the live root account is locked for graphical logins —
> enabling it would strand users at an unusable login screen.

## Installing it to disk

1. Boot the ISO (UEFI or BIOS). You land in a root shell on a getty — read `motd`, and run `fastfetch` to see the branding.
2. Run `archinstall` and follow the wizard:
   - profile: **minimal** or **desktop → Hyprland** (or "no desktop" + paste `archiso/packages.x86_64` when it asks for extra packages)
   - bootloader: systemd-boot or GRUB
   - network: NetworkManager
3. Reboot into the installed system, log in as your user on the console (or press the SDDM button after enabling it), and enable the display manager:
   ```bash
   sudo systemctl enable --now sddm NetworkManager
   ```
4. Log in via SDDM → **Hyprland**, then **set up the desktop (offline)**:
   ```bash
   haibane-setup            # extracts bundled Shadow Shell, runs its installer
   ```
   This runs `install.sh --wm=hyprland --yes` from the bundled tarball and wires up the bar, launcher, dock, lock screen, wallpaper and Settings. Want niri instead? `haibane-setup --wm=niri`.
5. Open a terminal — you'll be greeted by the Haibane Renmei fastfetch.

## The fastfetch look

The logo file (`assets/haibane-renmei.txt`) is copied verbatim into the image.
Colours are assigned by character in `config.jsonc`:

| Chars | Colour (ANSI 256) | Meaning |
|---|---|---|
| `&` `+` | `255` white | wing/body highlights |
| `.` `:` `;` | `243` grey | soft shading |
| `X` `x` `$` | `221` gold | halo accents |

Keys are rendered in colour `217` (dusty rose). Tweak `archiso/airootfs/etc/skel/.config/fastfetch/config.jsonc` to taste — the modules list, separator, and `display.key` are all standard fastfetch. Re-deploy to an existing install with:

```bash
cp archiso/airootfs/etc/skel/.config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
```

Tip: the art is ~92 columns wide — use a terminal at least ~110 columns wide
or an ultrawide-friendly font (`JetBrainsMono Nerd Font` ships in the ISO).

## Branding cheat-sheet

- Distro ID: `haibane-renmeio-os` · `ID_LIKE=arch` (pacman/AUR helpers keep working)
- Hostname: `haibane` · Motto: *our wings are not for flying*
- Release codename: **Rakka** (Release 1.0, Nov 2026)
- ANSI_COLOR: `38;2;190;222;218` (pale teal) — good for installer themes
- Star logo asset: `assets/haibane-renmei-os.svg`

## Credits & disclaimer

- **Shadow Shell** is © shadoww.dev ([DarkShadowShell](https://github.com/shadowww-dev/DarkShadowShell),
  MIT). A vendored copy of v3.60 ships in the ISO so first-time setup works
  offline; `haibane-setup` prefers it over cloning from GitHub.
- Arch Linux is © the Arch Linux Team. This is not an official Arch derivative.
- The ASCII portrait and all Haibane Renmei imagery — including the bundled
  wallpapers (`haibane-renmei-cast.jpg`, `rakka-halo.jpg`, `rakka-sketch.jpg`,
  artbook-style scans provided by the project author) — are fans-made
  tributes.
  *Haibane Renmei* is the property of Pioneer LDC, Production I.G. and the
  original creators. This is an unofficial fan project — no affiliation, no
  endorsement. Do not sell it. The wallpapers are kept for personal,
  non-commercial use of the distro and may need to be swapped out before any
  public redistribution — use your own scans if that's a concern for you.
- Packaging scripts in this repo: MIT (see `LICENSE`).
