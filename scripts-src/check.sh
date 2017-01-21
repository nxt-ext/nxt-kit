#!/bin/bash
if [[ "`pidof -x $(basename $0) -o %PPID`" ]]; then exit 0; fi
log_file="../distrib/cron-{{ nxt_conf_name }}.log"
block_id_file="../distrib/block-{{ nxt_conf_name }}-ID"
block_cnt_file="../distrib/block-{{ nxt_conf_name }}-Cnt"
db_folder="nxt_db/"
chain_cached_arc="../distrib/chain-cached-{{ nxt_conf_name }}.tar.xz"
chain_origin_arc="../distrib/chain-original-{{ nxt_conf_name }}.zip"
cd {{ nxt_remote_folder }}/nxt
api_url='http://{{ (kit_ServerHost.stdout|default(kit_ServerHost)) if kit_ServerHost is defined else "localhost" }}:{{ kit_apiServerPort if kit_apiServerPort is defined else 7876 }}/nxt?requestType'
blockchain_status=$(wget -qO- $api_url=getBlockchainStatus)
typeset -i curr_block_id=$(echo $blockchain_status | grep -oP '"numberOfBlocks":\d+' | awk -F ":" '{print $2}')
if (( $curr_block_id != 0 )); then
  prev_block_id=0
  if [ -f $block_id_file ]; then
      typeset -i prev_block_id=$(cat $block_id_file)
  fi
  if (( $curr_block_id != $prev_block_id )); then
    block_address=$(echo $blockchain_status | grep -oP '"lastBlock":"\d+"' | awk -F ":" '{print $2}' | sed 's/"//g')
    declare -A recent_blocks_generators
    for i in {1..5}
    do
      block_info=$(wget -qO- $api_url=getBlock\&block=$block_address)
      recent_blocks_generators[$(echo $block_info | grep -oP '"generator":"\d+"' | awk -F ":" '{print $2}' | sed 's/"//g')]='+'
      block_address=$(echo $block_info | grep -oP '"previousBlock":"\d+"' | awk -F ":" '{print $2}' | sed 's/"//g')
    done
    if (( {{ '${#recent_blocks_generators[@]}' }} > 1 )); then
      echo $curr_block_id > $block_id_file
      echo 1 > $block_cnt_file
      if (( RANDOM % 30 )); then
        echo "$(date) OK: it works with block $curr_block_id" >> $log_file
      else
        echo "$(date) OK: caching chain with block $curr_block_id" >> $log_file
        tar -cJf $chain_cached_arc $db_folder
      fi
    else
      echo "$(date) ERROR: The latest generator is too lucky. Looks like a fork" >> $log_file
      pkill -f 'java -cp classes:lib/\*:{{ nxt_conf_name }} ' && while pgrep -f 'java -cp classes:lib/\*:{{ nxt_conf_name }} ' > /dev/null; do sleep 1; done
      rm -f $chain_cached_arc
    fi
  else
    prev_block_cnt=0
    if [ -f $block_cnt_file ]; then
        typeset -i prev_block_cnt=$(cat $block_cnt_file)
    fi
    if (( $prev_block_cnt < 60 )); then
      ((prev_block_cnt++))
      echo $prev_block_cnt > $block_cnt_file
      echo "$(date) OK: block $curr_block_id repeated $prev_block_cnt times" >> $log_file
    else
      echo "$(date) ERROR: I can't stand block $curr_block_id any longer" >> $log_file
      pkill -f 'java -cp classes:lib/\*:{{ nxt_conf_name }} ' && while pgrep -f 'java -cp classes:lib/\*:{{ nxt_conf_name }} ' > /dev/null; do sleep 1; done
      rm -f $chain_cached_arc
    fi
  fi
else
  echo "$(date) ERROR: nxt is NOT running correctly" >> $log_file
  pkill -f 'java -cp classes:lib/\*:{{ nxt_conf_name }} ' && while pgrep -f 'java -cp classes:lib/\*:{{ nxt_conf_name }} ' > /dev/null; do sleep 1; done
  rm -rf $db_folder $block_id_file $block_cnt_file
  if [ -f $chain_cached_arc ]; then
    echo "$(date) Restoring cached chain" >> $log_file
    tar -xJf $chain_cached_arc
    rm -f $chain_cached_arc
  elif [ -f $chain_origin_arc ]; then
    echo "$(date) Restoring original chain" >> $log_file
    unzip $chain_origin_arc -d ..
  fi
  nohup java -cp classes:lib/\*:{{ nxt_conf_name }} nxt.Nxt > /dev/null 2>&1 &
  # Restoing sometimes requires more time than 3 minutes
  nxt_pid=$!
  for i in {1..10}
  do
    if ps -p $nxt_pid > /dev/null
    then
      sleep 100
    else
      exit 1
    fi
  done
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
