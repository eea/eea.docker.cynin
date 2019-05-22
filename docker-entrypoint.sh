#!/bin/bash
set -e



COMMANDS="debug help logtail show stop adduser fg kill quit run wait console foreground logreopen reload shell status"
START="start restart zeoserver"

CYNIN_PATH="${INSTANCEDIR:-/var/local/community.eea.europa.eu}"
SERVICES=${SERVICES:-"zope"}


if [[ "${SERVICES}" == "zope" ]]; then
   CMD=${CYNIN_PATH}/bin/www1
fi

if [[ "${SERVICES}" == "zeo" ]]; then
   CMD=${CYNIN_PATH}/bin/zeoserver
fi




if [ -z "$HEALTH_CHECK_TIMEOUT" ]; then
  HEALTH_CHECK_TIMEOUT=1
fi

if [ -z "$HEALTH_CHECK_INTERVAL" ]; then
  HEALTH_CHECK_INTERVAL=1
fi


if [[ $START == *"$1"* ]]; then
  _stop() {
    gosu cynin $CMD stop
    kill -TERM $child 2>/dev/null
  }

  trap _stop SIGTERM SIGINT
  gosu cynin $CMD start
  child=$!

  pid=`$CMD status | sed 's/[^0-9]*//g'`
  if [ ! -z "$pid" ]; then
    echo "Application running on pid=$pid"
    sleep "$HEALTH_CHECK_TIMEOUT"
    gosu cynin $CMD logtail &
    while kill -0 "$pid" 2> /dev/null; do
      sleep "$HEALTH_CHECK_INTERVAL"
    done
  else
    echo "Application didn't start normally. Shutting down!"
    _stop
  fi


else
  if [[ $COMMANDS == *"$1"* ]]; then
    exec gosu cynin $CMD "$@"
  fi
  exec "$@"
fi

