#!/bin/bash
if [ -z "$(pgrep java)" ]
  then
     # nxt is not running
    echo 'ERROR: nxt is NOT running'
    ~/restart.nxt.sh
    echo 'RESTARTED: nxt'
  else
     # nxt is running
    echo "OK: nxt is running"
fi
