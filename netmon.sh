#!/bin/bash
interface=`ip r | grep '^default' | awk '{print $5}'`
if [ -z $interface ]; then
	echo "<txt>Offline</txt>"
	if [ -f ~/.cache/rx_prev_bytes ]; then
		rm ~/.cache/rx_prev_bytes
		rm ~/.cache/tx_prev_bytes
	fi
else
	rx_curr=`cat /sys/class/net/$interface/statistics/rx_bytes`
	tx_curr=`cat /sys/class/net/$interface/statistics/tx_bytes`
	if [ ! -f ~/.cache/rx_prev_bytes ]; then
		echo $rx_curr > ~/.cache/rx_prev_bytes
		echo $tx_curr > ~/.cache/tx_prev_bytes
	fi
	rx_prev=`cat ~/.cache/rx_prev_bytes`
	tx_prev=`cat ~/.cache/tx_prev_bytes`
	rx_comp=$((($rx_curr-$rx_prev)*4))
	tx_comp=$((($tx_curr-$tx_prev)*4))
	numfmt --to=iec-i --suffix=B --field=2,4 --format='%.2f' <<< "<txt>Incoming: $rx_comp Outcoming: $tx_comp </txt>"
	echo $rx_curr > ~/.cache/rx_prev_bytes
	echo $tx_curr > ~/.cache/tx_prev_bytes
fi
