#!/usr/bin/bash
set -e
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 
    exit 1
fi

apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y
(cd /tmp && curl -s https://julianfairfax.codeberg.page/package-repo/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/julians-package-repo.gpg && echo 'deb [ signed-by=/usr/share/keyrings/julians-package-repo.gpg ] https://julianfairfax.codeberg.page/package-repo/debs packages main' | sudo tee /etc/apt/sources.list.d/julians-package-repo.list)
(cd /tmp && curl -s https://biernacik.org/repo/debian/biernacik.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/biernacik.gpg && echo 'deb [ signed-by=/usr/share/keyrings/biernacik.gpg ] https://biernacik.org/repo/debian stable main' | sudo tee /etc/apt/sources.list.d/biernacik.list)
apt update && DEBIAN_FRONTEND=noninteractive apt install rectify-gnome-meta -y

laptop-detect && {
  DEBIAN_FRONTEND=noninteractive apt install tlp tlp-rdw -y
} || {
  echo "Not a laptop, skipping tlp installation."
}

echo "Done"
