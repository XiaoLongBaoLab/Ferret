#!/usr/bin/env bash

set -oue pipefail

# Replaces the BlueBuild akmods module, which hardcodes `rpm-ostree install`
# and fails on Fedora 45 bases ("This system was not booted via libostree").
# Pulls prebuilt kmods from Universal Blue's akmods image matching the base
# image's Fedora release and installs them with dnf5.
KMODS=(
    xone
)

AKMODS_IMAGE="ghcr.io/ublue-os/akmods:main-$(rpm -E %fedora)"
WORKDIR="$(mktemp -d)"

TOOLS_INSTALLED=()
for tool in skopeo jq; do
    if ! command -v "$tool" &> /dev/null; then
        TOOLS_INSTALLED+=("$tool")
    fi
done
if [[ ${#TOOLS_INSTALLED[@]} -gt 0 ]]; then
    dnf5 -y install "${TOOLS_INSTALLED[@]}"
fi

skopeo copy --retry-times 3 "docker://${AKMODS_IMAGE}" "dir:${WORKDIR}/image"
for layer in $(jq -r '.layers[].digest' "${WORKDIR}/image/manifest.json" | cut -d: -f2); do
    tar -xzf "${WORKDIR}/image/${layer}" -C "${WORKDIR}"
done

RPMS=()
for kmod in "${KMODS[@]}"; do
    RPMS+=("${WORKDIR}"/rpms/kmods/kmod-"${kmod}"-*.rpm)
    RPMS+=("${WORKDIR}"/rpms/common/"${kmod}"-kmod-common-*.rpm)
done

echo "Installing kmods from ${AKMODS_IMAGE}: ${KMODS[*]}"
dnf5 -y install "${RPMS[@]}"

if [[ ${#TOOLS_INSTALLED[@]} -gt 0 ]]; then
    dnf5 -y remove "${TOOLS_INSTALLED[@]}"
fi
rm -rf "${WORKDIR}"
