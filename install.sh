#!/bin/sh
set -e

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

check_packages curl unzip

echo "Activating feature 'deno'"

TARGET_DENO_VERSION=${VERSION:-"latest"}

if [ "${TARGET_DENO_VERSION}" = "latest" ] || "${TARGET_DENO_VERSION}" = "none";
then
    curl -fsSL https://deno.land/x/install/install.sh | DENO_INSTALL=/usr/local sh
else
    curl -fsSL https://deno.land/x/install/install.sh | DENO_INSTALL=/usr/local sh -s "v${TARGET_DENO_VERSION}"
fi
