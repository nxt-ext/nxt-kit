#!/bin/bash
state=$(wget -qO- http://localhost:7874/nxt?requestType=getState)
cd ~/nxt-kit/nxt
pkill java
if [ -z "$state" ]; then
  rm -f blockchain.nrs blocks.nxt transactions.nxt
  if [ -f ../distrib/chain.tar.gz ]; then
    echo "Restoring cached chain"
    tar -xzvf ../distrib/chain.tar.gz
  elif [ -f ../distrib/chain-original.tar.gz ]; then
    echo "Restoring original chain"
    tar -xzvf ../distrib/chain-original.tar.gz
  fi
else
  echo "Caching chain"
  tar -czvf ../distrib/chain.tar.gz blockchain.nrs blocks.nxt transactions.nxt
fi
nohup java -jar start.jar &
