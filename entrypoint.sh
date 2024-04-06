#!/usr/bin/env bash

LOG="/root/insaned.log"

service cups start
service dbus start
service saned start
insaned --events-dir=/root/events --log-file=$LOG
#insaned --dont-fork --events-dir=/root/events -vv | tee $LOG
sleep infinity
