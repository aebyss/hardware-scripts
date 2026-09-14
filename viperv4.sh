#!/usr/bin/env bash

set -e

RULE_FILE="/etc/udev/rules.d/99-razer-viper-v4-pro.rules"

echo "Erstelle udev-Regel für Razer Viper V4 Pro..."

sudo tee "$RULE_FILE" > /dev/null <<'EOF'
ACTION=="add|change", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="00e5", MODE:="0666"
ACTION=="add|change", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="00e6", MODE:="0666"
EOF

echo "Lade udev-Regeln neu..."

sudo udevadm control --reload-rules
sudo udevadm trigger --subsystem-match=hidraw

echo
echo "Fertig."
echo "Bitte den Viper V4 Pro Dongle einmal abziehen und wieder einstecken."
echo
echo "Danach kannst du mit folgendem Befehl prüfen:"
echo
echo 'for d in /dev/hidraw*; do'
echo '    if udevadm info -a -n "$d" 2>/dev/null | grep -Eq '\''ATTRS{idProduct}=="00e5"|ATTRS{idProduct}=="00e6"'\''; then'
echo '        echo "$d"'
echo '        ls -l "$d"'
echo '    fi'
echo 'done'
