#!/usr/bin/env bash

#
# !! THIS SCRIPT SHOULD BE RUN AT LEAST ONCE BEFORE USING SYSTEMD UNIT !!
#

IMAGE="insaned_srv"
# SET THIS TO THE ABSOLUTE PATH of INSANED-CTR
CWD="/var/home/opt/insaned"
# SET THIS TO YOUR NON-ROOT SYSTEM ACCOUNT
LUSER="srvacct"
LGROUP="srvacct"

LUID=$(id -u $LUSER)
LGID=$(id -g $LGROUP)
LOG="$CWD/insaned.log"

if [ $(id -u) -ne 0 ]; then
	echo "Error: this build script is intended to be run as root!"
	exit 1
fi
if [[ -z "$LUID" ]] && [[ -z "$LGID" ]]; then
	echo "Error: the specified system account does not exist..."
	echo "Set an appropriate non-root system account in this build script and rerun!"
	exit 1
else
	chown -R $LUSER:$LGROUP "$CWD"
	sudo rm -f $LOG && sudo -u \#$LUID touch $LOG
fi

if [ "$#" -eq 1 ] && [ "$1" == "-b" ]; then
	docker build -t "$IMAGE" .
fi
if [ "$#" -eq 0 ] || [ "$1" == "-r" ]; then
	docker build -t "$IMAGE" .
	docker stop -t=3 -i "$IMAGE"
	#
	# NOTE: host volume mounts assume SELinux is in permissive mode
	# ... this is because access to cups.sock could be an issue in enforcing mode
	# ... but enforcing mode can also cause problems with the remote share
	#
	# NOTE: "remote" vol assumes you're using a CIFS share for remote backup
	# ... and that this cifs mount is at "./remote" and under the uid/gid of the service account
	#
	docker run --replace --rm -d \
		--uidmap=0:$LUID:1 --gidmap=0:$LGID:1 \
		--device "/dev/bus/usb/003/004" \
		-v "/var/run/cups/cups.sock:/run/cups/cups.sock" \
		-v "$CWD/insaned.log:/root/insaned.log" \
		-v "$CWD/scanned:/root/scanned" \
		-v "$CWD/remote:/root/remote" \
		--name "$IMAGE" "$IMAGE"
fi
