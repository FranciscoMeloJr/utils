all:
	# compile the lib ftrace
	gcc -DDO_HYPERCALL=1 -c -o libftrace-dohypercall.o libftrace.c
	gcc -c -o libftrace.o libftrace.c
	# Instrumented
	gcc -g -finstrument-functions -c -o simple-program-instrumented.o simple-program.c
	# Not instrumented
	gcc -c -o simple-program-not-instrumented.o simple-program.c

	gcc simple-program-instrumented.o libftrace-dohypercall.o -o simple-program-ins-dohypercall

	gcc simple-program-instrumented.o libftrace.o -o simple-program-ins

	gcc simple-program-not-instrumented.o -o simple-program-noins


	# send it to vm
	scp input*.txt simple-program-ins simple-program-noins simple-program-ins-dohypercall ubuntu:~

clean:
	rm libftrace.o libftrace-dohypercall.o simple-program-*.o simple-program-ins simple-program-noins simple-program-ins-dohypercall

