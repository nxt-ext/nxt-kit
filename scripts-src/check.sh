#!/bin/bash
if [[ "`pidof -x $(basename $0) -o %PPID`" ]]; then exit 0; fi
cd ~/nxt-kit/nxt
pid=$(pgrep -f 'java -jar start.jar')
typeset -i curr_block_id=$(wget -qO- http://localhost:7874/nxt?requestType=getState | grep -oP '"numberOfBlocks":\d+' | awk -F ":" '{print $2}')
if (( $curr_block_id != 0 )) && [[ $pid ]]; then
  prev_block_id=0
  if [ -f ../distrib/blockID ]; then
      typeset -i prev_block_id=$(cat ../distrib/blockID)
  fi
  if (( $curr_block_id != $prev_block_id )); then
    echo 'OK: caching chain'
    echo $curr_block_id > ../distrib/blockID
    echo 1 > ../distrib/blockCnt
    tar -czvf ../distrib/chain.tar.gz blockchain.nrs blocks.nxt transactions.nxt
  else
    prev_block_cnt=0
    if [ -f ../distrib/blockCnt ]; then
        typeset -i prev_block_cnt=$(cat ../distrib/blockCnt)
    fi
    if (( $prev_block_cnt < 180 )); then
      ((prev_block_cnt++))
      echo $prev_block_cnt > ../distrib/blockCnt
      echo "OK: block repeated $prev_block_cnt times"
    else
       echo "ERROR: I can't stand this block anymore"
       pkill -f 'java -jar start.jar'
       rm -f ../distrib/chain.tar.gz
    fi
  fi
else
  echo 'ERROR: nxt is NOT running correctly'
  pkill -f 'java -jar start.jar'
  rm -f blockchain.nrs blocks.nxt transactions.nxt ../distrib/blockID ../distrib/blockCnt
  if [ -f ../distrib/chain.tar.gz ]; then
    echo 'Restoring cached chain'
    tar -xzvf ../distrib/chain.tar.gz
    rm -f ../distrib/chain.tar.gz
  elif [ -f ../distrib/chain-original.tar.gz ]; then
    echo 'Restoring original chain'
    tar -xzvf ../distrib/chain-original.tar.gz
  fi
  nohup java -jar start.jar &
  # Restoing sometimes requires more time than 1 minute
  sleep 150
fi
