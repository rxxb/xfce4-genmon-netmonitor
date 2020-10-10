#!/bin/bash

#get interface name
interface=`/usr/sbin/route | grep 'default' | sed 's/default.*\s//g'`

#check interface
if [ -z $interface ]; then

#display Offline if there's no interface
	echo "<txt>Offline</txt>"
elif [ ! -f ~/.cache/rx_prev_bytes ]; then

#create "usage" cache
	echo 0 > ~/.cache/rx_prev_bytes
	echo 0 > ~/.cache/tx_prev_bytes
else

	rx_prev=`cat ~/.cache/rx_prev_bytes`
  tx_prev=`cat ~/.cache/tx_prev_bytes`
	rx_curr=`cat /sys/class/net/$interface/statistics/rx_bytes`
  tx_curr=`cat /sys/class/net/$interface/statistics/tx_bytes`
  
  #distract current usage with previous usage
	rx_comp=$(($rx_curr-$rx_prev-73))
	tx_comp=$(($tx_curr-$tx_prev-131))
  
  #formatting
	numfmt --to=iec-i --suffix=B --field=2,4 --format='%.2f' <<< "<txt>Incoming: $rx_comp Outcoming: $tx_comp </txt>"
  
  #cache-ing for next
	echo $rx_curr > ~/.cache/rx_prev_bytes
	echo $tx_curr > ~/.cache/tx_prev_bytes
fi
