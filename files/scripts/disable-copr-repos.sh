#!/usr/bin/env bash

set -oue pipefail

# The COPRs are only needed while building. Turn them off in the finished image
# so the installed system doesn't pull packages from third-party repos.
# Keep this list in sync with enable-copr-repos.sh.
for repo in \
    bazzite-org:bazzite \
    hhd-dev:hhd; do
    sed -i 's/^enabled=1/enabled=0/' "/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:${repo}.repo"
done
