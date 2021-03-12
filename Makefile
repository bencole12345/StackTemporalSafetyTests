SDK = /home/ben/cheri/output/sdk
RISCV_TESTS = /home/ben/clones/riscv-tests

# TODO: Decide whether to keep
# FILESYSTEM ?= /home/ben/cheri/output/rootfs-riscv64-hybrid/root/installed-binaries

CC = $(SDK)/utils/cheribsd-riscv64-clang
CFLAGS = -O0 -gdwarf-5 \
	-target riscv64-unknown-freebsd \
    -march=rv64gcxcheri -mabi=lp64 \
	-Wl,-Tlinker.ld \
    -fuse-ld=lld -nostdlib -nostartfiles -mno-relax -static

all: build/BreathingTest

build/%: tests/%.S build
	$(CC) $(CFLAGS) -o $@ $<

.PHONY: clean
clean:
	rm -rf build

build:
	mkdir build

# TODO: Decide whether to keep
# .PHONY: loadfiles
# loadfiles: all
# 	cp build/HelloWorldTest $(FILESYSTEM)
# 	cp build/pte-bits $(FILESYSTEM)
# 	cp build/CheckStoreCapCapLifetimesTest $(FILESYSTEM)
