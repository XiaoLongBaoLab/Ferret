#!/usr/bin/env bash

set -oue pipefail

systemctl enable disable-power-wakeups.timer
