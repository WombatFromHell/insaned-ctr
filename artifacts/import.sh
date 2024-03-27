#!/usr/bin/env bash
gunzip -k insaned_src-ctr.tar.gz
docker import --change 'ENTRYPOINT ["/root/entrypoint.sh"]' insaned_srv-ctr.tar insaned_srv:latest
rm -f insaned_src-ctr.tar
