#!/bin/bash
if [[ "`pidof -x $(basename $0) -o %PPID`" ]]; then exit 0; fi
cd ~/nxt-kit/nxt
pid=$(pgrep -f 'java -jar start.jar')
state=$(wget -qO- http://localhost:7874/nxt?requestType=getState)
if [[ $state ]] && [[ $state != *\"numberOfBlocks\":0* ]] && [[ $pid ]]; then
  echo 'OK: caching chain'
  tar -czvf ../distrib/chain.tar.gz blockchain.nrs blocks.nxt transactions.nxt
else
  echo 'ERROR: nxt is NOT running correctly'
  pkill -f 'java -jar start.jar'
  rm -f blockchain.nrs blocks.nxt transactions.nxt
  if [ -f ../distrib/chain.tar.gz ]; then
    echo 'Restoring cached chain'
    tar -xzvf ../distrib/chain.tar.gz
    rm -f ../distrib/chain.tar.gz
  elif [ -f ../distrib/chain-original.tar.gz ]; then
    echo 'Restoring original chain'
    tar -xzvf ../distrib/chain-original.tar.gz
  fi
  nohup java -jar start.jar &
fi
