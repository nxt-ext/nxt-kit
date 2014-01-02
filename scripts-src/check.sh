#!/bin/bash
if [ -z "$(pgrep java)" ] || [ -z "$(wget -qO- http://localhost:7874/nxt?requestType=getState)" ]
  then
     # nxt is not running
    echo 'ERROR: nxt is NOT running correctly'
    ~/nxt-kit/sbin/restart.nxt.sh
    echo 'RESTARTED: nxt'
  else
     # nxt is running
    echo "OK: nxt is running"
fi
