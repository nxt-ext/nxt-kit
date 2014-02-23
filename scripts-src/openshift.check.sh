#!/bin/bash
if (( $(date "+%M") % 10 )); then exit 0; fi
cd {{ nxt_remote_folder }}/nxt
l_TELNET=`echo "quit" | telnet $OPENSHIFT_DIY_IP $OPENSHIFT_DIY_PORT | grep "Escape character is"`
if [ "$?" -eq 0 ]; then
  echo "$(date) OK: nxt seems working" >> ../distrib/cron.log
  touch ../distrib/wasWorking
else
  echo "$(date) ERROR: nxt is NOT running correctly" >> ../distrib/cron.log
  # Obsolete and will be removed
  pkill -f 'java -jar start.jar'
  pkill -f 'nxt.jar'
  if [ ! -f ../distrib/wasWorking ]; then
    rm -rf nxt_db/
    if [ -f ../distrib/chain-original.tar.gz ]; then
      echo "    Restoring original chain" >> ../distrib/cron.log
      tar -xzvf ../distrib/chain-original.tar.gz
    fi
  fi
  rm -f ../distrib/wasWorking
  nohup java -cp nxt.jar:lib/*:conf nxt.Nxt > /dev/null 2>&1 &
fi
