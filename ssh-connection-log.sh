#!/bin/bash
echo ""
echo "Below is the last access Information for IP " $(/sbin/ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}')
LOG=/var/log/auth.log
if [ -n "$1" ]
then
NEWUSER="$1"
else
NEWUSER="root"
fi
#MESSAGE="session opened"
#MESSAGE="session opened for user $NEWUSER"
grep sshd "$LOG" | grep "session " | tail -20 | awk -F" " '{ print $1,$2, $3, $7, $8 }'
#egrep  'sshd|session' "$LOG" | tail -5 #| awk -F" " '{ print $1,$2, $3, $5 }'
#grep -i "$MESSAGE" "$LOG" | tail -5 | awk -F" " '{ print $1,$2, $3 }'
#awk -F" {2,}" '{print $2}' /tmp/test.txt
