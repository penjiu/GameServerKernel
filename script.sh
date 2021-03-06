#!/bin/bash
# __________________________________________________________________________________________
PROCESS_NAMES=(
  srcds_linux
);

for pid in $(for executable in ${PROCESS_NAMES[@]}; do pgrep ${executable} ;done) ;do
  chrt -ar -p 98 $pid
  renice 1 -p $pid
done

# __________________________________________________________________________________________
# ****** NETWORK Optimizer for RT KERNEL. - (no-delay data transfer.) **********************
for pid in $(ps ax | grep -E "\s+\[irq\/[0-9]+-\S+[0-9]+(-.+|)\]$" | awk '{print $1}'); do
  chrt -r -p 98 $pid
  renice 1 -p $pid
done

# __________________________________________________________________________________________
# ****** ksoftirqd scheduling Optimizer for RT KERNEL. - ( ) *******************************
for pid in $(pgrep ksoftirqd); do
  chrt -ar -p 50 $pid
  renice -1 -p $pid
done

# __________________________________________________________________________________________
# ****** kworker scheduling Optimizer for RT KERNEL. - ( ) *********************************
PIDS=`ps ax | grep kworker | grep -v grep | sed -e "s/^ *//" -e "s/ .*$//"`
for p in $PIDS; do
  renice -20 -p $p
done

# __________________________________________________________________________________________
# ****** TOP Process Optimizer for RT KERNEL. - ( ) ****************************************
for pid in $(pidof top); do
  chrt -ar -p 54 $pid
  renice 0 -p $pid
done

# __________________________________________________________________________________________
# ****** kswapd0 scheduling Optimizer for RT KERNEL. - ( ) *********************************
for pid in $(pgrep kswapd0); do
  chrt -af -p 64 $pid
  renice 0 -p $pid
done
