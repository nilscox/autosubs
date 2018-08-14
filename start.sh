#!/bin/sh

docker build -t autosubs .

if [ -z "$SUBS_LANG" ]; then
  SUBS_LANG='fr'
fi

if [ -z "$SUBS_WATCHDIR" ]; then
  SUBS_WATCHDIR='/data/media'
fi

if [ -z "$CONTAINER_NAME" ]; then
  CONTAINER_NAME='autosubs'
fi

docker run -dt \
  --name "$CONTAINER_NAME" \
  -e SUBS_LANG="$SUBS_LANG" \
  -v "${SUBS_WATCHDIR}:/media" \
  -u "$(id -u):$(id -g)" \
  autosubs
