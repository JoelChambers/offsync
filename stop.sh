#!/usr/bin/env bash
# offsync/stop.sh
# interrupts the offsite job in the morning

MYDIR=$(dirname $0)
source "${MYDIR}/config"

if -z "${PIDFILE}"; then
  echo "Check your configuration!" 2>&1
fi

kill $(cat "$PIDFILE") && rm "${PIDFILE}"
