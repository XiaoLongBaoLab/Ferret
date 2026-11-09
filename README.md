# Ferret &nbsp; [![bluebuild build badge](https://github.com/XiaoLongBaoLab/Ferret/actions/workflows/build.yml/badge.svg)](https://github.com/XiaoLongBaoLab/Ferret/actions/workflows/build.yml)

A personal [BlueBuild](https://blue-build.org/) image for a GPD Win Max 2 2025 (Ryzen AI 9 HX 370), based on [secureblue](https://secureblue.dev/)'s `kinoite-main-hardened`. It adds [Handheld Daemon](https://github.com/hhd-dev/hhd), the `xone` driver and a few command-line tools.

## Installation

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/xiaolongbaolab/ferret:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/xiaolongbaolab/ferret:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

## Updating

Automatic updates are turned off, so changes can be reviewed first:

```
rpm-ostree upgrade
rpm-ostree db diff
flatpak update
```

Nothing from `rpm-ostree upgrade` applies until the next reboot. `rpm-ostree cleanup -p` discards a staged update.

## TDP

Handheld Daemon's TDP control needs the `acpi_call` kernel module, which this image doesn't include. Set limits manually instead (values in milliwatts, reset at reboot):

```
run0 ryzenadj --stapm-limit=25000 --fast-limit=25000 --slow-limit=25000
```

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/xiaolongbaolab/ferret
```
