#!/usr/bin/bash
set -e
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 
    exit 1
fi

apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y
DEBIAN_FRONTEND=noninteractive apt install gnupg curl -y
(cd /tmp && curl -s https://julianfairfax.codeberg.page/package-repo/pub.gpg | gpg --dearmor | dd of=/usr/share/keyrings/julians-package-repo.gpg && echo 'deb [ signed-by=/usr/share/keyrings/julians-package-repo.gpg ] https://julianfairfax.codeberg.page/package-repo/debs packages main' | tee /etc/apt/sources.list.d/julians-package-repo.list)
apt update

# The part of the script responsible for installing the meta package was broken, so I’ve removed it for now. As a result, the script is currently non-functional.

laptop-detect && {
  DEBIAN_FRONTEND=noninteractive apt install tlp tlp-rdw -y
} || {
  echo "Not a laptop, skipping tlp installation."
}

echo "Done"
