#!/bin/bash

lastTag="$1"
includeHashes=$2
linePrefix="$3"

# get git log range
if [ ${#lastTag} -gt 0 ]; then
  range="$lastTag..@"
else
  range="@"
fi

# get commit messages
log="$(git log $range --oneline)"

if [ ${#log} -gt 0 ]; then

  # remove hashes
  if [ $includeHashes == false ]; then
    log="$(echo "$log" | sed -r -e 's/^.{8}//')"
  fi

  # add line prefixes
  if [ ${#linePrefix} -gt 0 ]; then
    log="$(echo "$log" | sed -r -e "s/^/$linePrefix/")"
  fi

  # replace linebreaks
  log="${log//'%'/'%25'}"
  log="${log//$'\n'/'%0A'}"
  log="${log//$'\r'/'%0D'}"

fi

echo "::set-output name=log::$log"
