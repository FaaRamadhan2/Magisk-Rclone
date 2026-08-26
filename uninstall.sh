#!/system/bin/sh
# Cleanup saat module diuninstall (folder config sengaja dibiarkan)

RC_DIR="/data/adb/rclone"
if [ -f "$RC_DIR/rcd.pid" ]; then
  kill "$(cat "$RC_DIR/rcd.pid")" 2>/dev/null
  rm -f "$RC_DIR/rcd.pid"
fi
