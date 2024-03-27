#!/usr/bin/env bash
podman generate systemd --new --files --name insaned_srv
if [ "$1" == "-t" ]; then
  rm -f insaned_svr-ctr.tar.gz insaned_svr-ctr.tar
  docker export insaned_srv | gzip > insaned_srv-ctr.tar.gz
fi
