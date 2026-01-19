#!/bin/bash
set -e

ROTATOR="/usr/local/bin/proton-rotator.sh"
LOGFILE="/var/log/proton-rotator.log"
LOCKFILE="/var/run/proton-rotator.lock"
PROTONVPN_BIN="/usr/bin/protonvpn"

echo "Installing ProtonVPN country rotator..."

if [ "$EUID" -ne 0 ]; then
  echo "Run as root (sudo)"
  exit 1
fi

# Create log file safely
touch $LOGFILE
chmod 644 $LOGFILE

cat > $ROTATOR << EOF
#!/bin/bash

LOCKFILE="$LOCKFILE"
LOGFILE="$LOGFILE"
PROTONVPN_BIN="$PROTONVPN_BIN"

# Prevent overlapping runs
exec 9>"\$LOCKFILE"
flock -n 9 || exit 0

COUNTRIES=("US" "CA" "MX" "NL" "RO" "PL" "NO" "CH" "JP" "SG")

PICK=\${COUNTRIES[\$RANDOM % \${#COUNTRIES[@]}]}

echo "\$(date) - Switching to \$PICK" >> "\$LOGFILE"

\$PROTONVPN_BIN disconnect >> "\$LOGFILE" 2>&1
sleep 5

if ! \$PROTONVPN_BIN connect --cc "\$PICK" >> "\$LOGFILE" 2>&1; then
    echo "\$(date) - Connection FAILED to \$PICK" >> "\$LOGFILE"
fi
EOF

chmod +x $ROTATOR

# Install cron jobs safely
( crontab -l 2>/dev/null | grep -v proton-rotator ; \
  echo "@reboot $ROTATOR # proton-rotator"; \
  echo "0 */3 * * * $ROTATOR # proton-rotator"; \
  echo "30 */3 * * * $ROTATOR # proton-rotator" ) | crontab -

echo "Installed successfully."
echo "Rotation schedule: every 90 minutes"
echo "Log file: $LOGFILE"
