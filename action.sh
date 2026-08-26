#!/system/bin/sh
# Tombol ACTION di Magisk app: toggle daemon rclone rcd + autostart

MODDIR=${0%/*}
RC_DIR="/data/adb/rclone"
BIN="$MODDIR/system/bin/rclone"
CONF="$RC_DIR/rclone.conf"
LOGF="$RC_DIR/rcd.log"
PIDF="$RC_DIR/rcd.pid"
ADDR="127.0.0.1:5572"

mkdir -p "$RC_DIR"

is_running() {
  [ -f "$PIDF" ] && kill -0 "$(cat "$PIDF")" 2>/dev/null
}

stop_rcd() {
  if is_running; then
    kill "$(cat "$PIDF")" 2>/dev/null
    sleep 1
  fi
  rm -f "$PIDF"
}

start_rcd() {
  ARGS="--config $CONF --log-file $LOGF --log-level INFO --rc-addr $ADDR"
  [ -f "$RC_DIR/.webgui" ] && ARGS="$ARGS --rc-web-gui"
  "$BIN" rcd $ARGS >/dev/null 2>&1 &
  echo $! > "$PIDF"
}

if [ -f "$RC_DIR/.autostart" ]; then
  stop_rcd
  rm -f "$RC_DIR/.autostart"
  echo "rclone rcd STOPPED (autostart OFF)"
else
  touch "$RC_DIR/.autostart"
  stop_rcd
  start_rcd
  echo "rclone rcd STARTED di http://$ADDR (autostart ON)"
fi
