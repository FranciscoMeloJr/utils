#!/usr/bin/env bash
set -x

ssh root@ubuntu 'echo 0 > /sys/kernel/debug/tracing/tracing_on'
#ssh root@ubuntu 'echo mutex_lock > /sys/kernel/debug/tracing/set_ftrace_filter'
ssh root@ubuntu 'echo function_graph> /sys/kernel/debug/tracing/current_tracer'

lttng create kernelspace-tracing
lttng enable-channel -k --subbuf-size=2097152 --num-subbuf=32 vm_channel
lttng enable-event -k "kvm_x86_hypercall" -c vm_channel
#lttng enable-event -k -a -c vm_channel
lttng start
#ssh ubuntu 'sudo insmod ~/fgraph/fgraph.ko; ./simple-program-ins-dohypercall; sudo rmmod fgraph;'


ssh root@ubuntu '
echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable;
echo 1 > /sys/kernel/debug/tracing/tracing_on;'
ssh ubuntu './simple-program-ins-dohypercall;'
ssh root@ubuntu 'echo 0 > /sys/kernel/debug/tracing/tracing_on;
echo 0 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable;'

lttng stop
lttng destroy

ssh ubuntu "nm -an simple-program-ins-dohypercall > program-symbols.txt"
ssh ubuntu "sudo cat /proc/kallsyms > symbols.txt"
scp ubuntu:~/symbols.txt .
scp ubuntu:~/program-symbols.txt .
