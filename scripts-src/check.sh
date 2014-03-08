#!/bin/bash
if [[ "`pidof -x $(basename $0) -o %PPID`" ]]; then exit 0; fi
cd {{ nxt_remote_folder }}/nxt
typeset -i curr_block_id=$(wget -qO- http://{{ (kit_ServerHost.stdout|default(kit_ServerHost)) if kit_ServerHost is defined else "localhost" }}:{{ kit_apiServerPort if kit_apiServerPort is defined else 7876 }}/nxt?requestType=getState | grep -oP '"numberOfBlocks":\d+' | awk -F ":" '{print $2}')
if (( $curr_block_id != 0 )); then
  prev_block_id=0
  if [ -f ../distrib/blockID ]; then
      typeset -i prev_block_id=$(cat ../distrib/blockID)
  fi
  if (( $curr_block_id != $prev_block_id )); then
    echo "$(date) OK: caching chain with block $curr_block_id" >> ../distrib/cron.log
    echo $curr_block_id > ../distrib/blockID
    echo 1 > ../distrib/blockCnt
    tar -czvf ../distrib/chain.tar.gz nxt_db/
  else
    prev_block_cnt=0
    if [ -f ../distrib/blockCnt ]; then
        typeset -i prev_block_cnt=$(cat ../distrib/blockCnt)
    fi
    if (( $prev_block_cnt < 60 )); then
      ((prev_block_cnt++))
      echo $prev_block_cnt > ../distrib/blockCnt
      echo "$(date) OK: block $curr_block_id repeated $prev_block_cnt times" >> ../distrib/cron.log
    else
       echo "$(date) ERROR: I can't stand block $curr_block_id anymore" >> ../distrib/cron.log
       # Obsolete and will be removed
       pkill -f 'java -jar start.jar'
       pkill -f 'java -cp nxt.jar:lib/*:{{ nxt_conf_folder }} ' && while pgrep -f 'java -cp nxt.jar:lib/*:{{ nxt_conf_folder }} ' > /dev/null; do sleep 1; done
       rm -f ../distrib/chain.tar.gz
    fi
  fi
else
  echo "$(date) ERROR: nxt is NOT running correctly" >> ../distrib/cron.log
  # Obsolete and will be removed
  pkill -f 'java -jar start.jar'
  pkill -f 'java -cp nxt.jar:lib/*:{{ nxt_conf_folder }} ' && while pgrep -f 'java -cp nxt.jar:lib/*:{{ nxt_conf_folder }} ' > /dev/null; do sleep 1; done
  rm -rf nxt_db/ ../distrib/blockID ../distrib/blockCnt
  if [ -f ../distrib/chain.tar.gz ]; then
    echo "$(date) Restoring cached chain" >> ../distrib/cron.log
    tar -xzvf ../distrib/chain.tar.gz
    rm -f ../distrib/chain.tar.gz
  elif [ -f ../distrib/chain-original.tar.gz ]; then
    echo "$(date) Restoring original chain" >> ../distrib/cron.log
    tar -xzvf ../distrib/chain-original.tar.gz
  fi
  nohup java -cp nxt.jar:lib/*:{{ nxt_conf_folder }} nxt.Nxt > /dev/null 2>&1 &
  # Restoing sometimes requires more time than 1 minute
  sleep 250
#  nxt_pid=$!
#  typeset -i nxt_start_time=$(date +%s)
#  tail -f ../distrib/nohup.log | while read LOGLINE
#  do
#    if ! ps -p $nxt_pid > /dev/null || \
#       (( $(date +%s) - nxt_start_time < 20 * 60 )) || \
#       [[ "${LOGLINE}" == *"Exception"* ]]
#       then pkill -P $$ tail && exit 1
#    elif [[ "${LOGLINE}" == *"started successfully"* ]]
#       then pkill -P $$ tail && exit 0
#    fi
#  done
fi
