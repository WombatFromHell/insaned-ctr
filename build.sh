#!/usr/bin/env bash

IMAGE="insaned_srv"
CWD="/var/home/opt/insaned"
LOG="$CWD/insaned.log"
OUT="$CWD/scanned"

echo "" > $LOG
if [ "$#" -eq 1 ] && [ "$1" == "-b" ]; then
  docker build -t "$IMAGE" .
fi
if [ "$#" -eq 0 ] || [ "$1" == "-r" ]; then
  docker build -t "$IMAGE" .
  docker stop -t=3 -i "$IMAGE"
  docker run --replace --rm --privileged -d \
    --device "/dev/bus/usb/003/004" \
    -v "/run/cups/cups.sock:/run/cups/cups.sock" \
    -v "$CWD/insaned.log:/root/insaned.log" \
    -v "$OUT:/root/scanned" \
    -v "$CWD/remote:/root/remote" \
    --name "$IMAGE" "$IMAGE"
fi
