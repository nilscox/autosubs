#!/bin/bash

set -e

if [ "$1" == "--verbose" ] || [ "$1" == "-v" ]; then
  VERBOSE=1
  shift
fi

if [ -z "$SUBS_LANG" ]; then SUBS_LANG="$1"; fi

if [ -z "$SUBS_WATCHDIR" ]; then SUBS_WATCHDIR="$2"; fi

if [ -z "$SUBS_LANG" ] || [ -z "$SUBS_WATCHDIR" ]; then
  echo "usage: $0 [-v | --verbose] lang directory" >&2
  exit 1
fi

if [ ! -d "$SUBS_WATCHDIR" ]; then
  echo "error: $SUBS_WATCHDIR is not a directory" >&2
  exit 1
fi

if [ "$VERBOSE" ]; then
  echo "VERBOSE: $VERBOSE"
  echo "USER: $USER"
  echo "PWD: $PWD"
  echo "SUBS_LANG: $SUBS_LANG"
  echo "SUBS_WATCHDIR: $SUBS_WATCHDIR"
  echo "$(subliminal --version)"
fi

dlsubs() {
  if [ "$VERBOSE" ]; then
    echo "exec: subliminal download -l $SUBS_LANG $1"
  fi

  subliminal download -l "$SUBS_LANG" "$1"

  if [ ! "$?" ]; then
    echo "error downloading subtitles" >&2
    return
  fi
}

start() {
  if ! which inotifywait > /dev/null 2>&1; then
    echo "missing inotifywait"
    return 1
  fi

  echo "starting autosubs with LANG=$SUBS_LANG, WATCHDIR=$SUBS_WATCHDIR"

  inotifywait -r -m -e create "$SUBS_WATCHDIR" 2> /dev/null | while read entry; do
    IFS=' ' read path event filename <<< "$entry"
    ext=${filename##*.}

    if echo $ext | grep -E "^(avi|mp4|mkv)$" > /dev/null 2>&1; then
      echo "downloading subtitles for ${path}${filename}"
      dlsubs "${path}${filename}"
    fi
  done
}

start
