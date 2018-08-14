#!/bin/sh

docker build -t autosubs .

if [ -z "$SUBS_LANG" ]; then
  SUBS_LANG='fr'
fi

if [ -z "$SUBS_WATCHDIR" ]; then
  SUBS_WATCHDIR='/data/media'
fi

docker run -dt \
  --name autosubs \
  -e SUBS_LANG="$SUBS_LANG" \
  -v "${SUBS_WATCHDIR}:/media" \
  -u "$(id -u):$(id -g)" \
  autosubs
