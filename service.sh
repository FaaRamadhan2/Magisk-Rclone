#!/system/bin/sh
# Jalankan daemon rclone rcd saat boot jika /data/adb/rclone/.autostart ada

MODDIR=${0%/*}
RC_DIR="/data/adb/rclone"
BIN="$MODDIR/system/bin/rclone"
CONF="$RC_DIR/rclone.conf"
LOGF="$RC_DIR/rcd.log"
PIDF="$RC_DIR/rcd.pid"
ADDR="127.0.0.1:5572"

(
  # Tunggu boot selesai
  until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 3
  done
  sleep 5

  [ -f "$RC_DIR/.autostart" ] || exit 0
  [ -x "$BIN" ] || exit 0
  mkdir -p "$RC_DIR"

  # Hindari duplikat proses
  if [ -f "$PIDF" ] && kill -0 "$(cat "$PIDF")" 2>/dev/null; then
    exit 0
  fi

  ARGS="--config $CONF --log-file $LOGF --log-level INFO --rc-addr $ADDR"
  [ -f "$RC_DIR/.webgui" ] && ARGS="$ARGS --rc-web-gui"

  "$BIN" rcd $ARGS >/dev/null 2>&1 &
  echo $! > "$PIDF"
) &
