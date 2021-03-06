#!/usr/bin/env bash
set -x

rm -rf ~/lttng-traces/bootup-tracing-*

#ssh root@ubuntu 'cat /dev/null > /sys/kernel/debug/tracing/trace'

lttng create bootup-tracing
lttng enable-channel -k --subbuf-size=2097152 --num-subbuf=32 vm_channel
lttng enable-event -k "kvm_x86_hypercall" -c vm_channel
#lttng enable-event -k -a -c vm_channel
lttng start

#ssh root@ubuntu 'echo 0 > /sys/kernel/debug/tracing/tracing_on'
#ssh root@ubuntu 'echo mutex_lock > /sys/kernel/debug/tracing/set_ftrace_filter'
#ssh root@ubuntu 'echo function > /sys/kernel/debug/tracing/current_tracer'


virsh start ubuntu
sleep 15;

#ssh root@ubuntu 'echo 1 > /sys/kernel/debug/tracing/tracing_on;
#/home/abder/hypercall_sampler;
#sleep 2;
#echo 0 > /sys/kernel/debug/tracing/tracing_on;'

lttng stop
#lttng view
lttng destroy

scp ubuntu:~/symbols.txt .
ssh root@ubuntu 'cat /sys/kernel/debug/tracing/trace > /home/abder/bootup-logs.txt'
scp ubuntu:~/bootup-logs.txt .

babeltrace ~/lttng-traces/bootup-tracing-* | grep hypercall
