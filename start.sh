#!/usr/bin/env bash
# offsync/start.sh
# run the offsite backup

MYDIR=$(dirname $0)
source "${MYDIR}/config"

if -z "${RSYNC_TARGET}"; then
  echo "Check your configuration!" 2>&1
  exit 1
fi

if [[ -e "$PIDFILE" ]]; then
  echo "Offsync already running, exiting" 2>&1
  exit 1
fi

date >> "${LOGFILE}"
/usr/local/bin/rsync -auvhNHXxrz\
  --stats --protect-args --fileflags --force-change --delete\
  --files-from="$MYDIR/offsync.include" --no-relative\
  / "${RSYNC_TARGET}" >> "$LOGFILE" 2>&1 &

echo $! > "$PIDFILE"

# wait for rsync to finish
wait $(cat "$PIDFILE")

# stop may have already deleted it
if [[ -e "$PIDFILE" ]]; then
  rm "$PIDFILE"
fi

tail "$LOGFILE" | mail -E -s "Offsite backup of $(hostname) completed" $MAILTO
