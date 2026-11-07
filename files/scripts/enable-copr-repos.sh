#!/usr/bin/env bash

set -oue pipefail

# secureblue reports its os-release ID as "secureblue", so dnf copr would look
# for a nonexistent secureblue-XX chroot. Pin the Fedora chroot to the base
# image's release instead, so it follows version bumps automatically.
CHROOT="fedora-$(rpm -E %fedora)-$(uname -m)"

for repo in \
    bazzite-org/bazzite \
    hhd-dev/hhd; do
    dnf -y copr enable "$repo" "$CHROOT"
done
