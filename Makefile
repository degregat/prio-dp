.PHONY: all
all: init prio

prio: libint-scale-gaussian-c
	cd libprio && \
	scons SANITIZE=1 DEBUG=1;

libint-scale-gaussian-c:
	cd differential-privacy/cc/ && \
	bazel build //algorithms:libint-scale-gaussian-c && \
	test -f ../../libprio/dp/libint-scale-gaussian-c.a || \
	cp bazel-bin/algorithms/libint-scale-gaussian-c.a ../../libprio/dp

init:
	git submodule update --init
