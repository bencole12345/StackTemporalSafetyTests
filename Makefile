SDK = /home/ben/cheri/output/sdk

CC = $(SDK)/utils/cheribsd-riscv64-clang
CFLAGS = -O0 -gdwarf-5 \
	-target riscv64-unknown-freebsd \
	-march=rv64gcxcheri -mabi=lp64 \
	-Wl,-Tlinker.ld \
	-fuse-ld=lld -nostdlib -nostartfiles -mno-relax -static

all: build/BreathingTest build/ContainsNewInstruction

build/%: tests/%.S build
	$(CC) $(CFLAGS) -o $@ $<

.PHONY: clean
clean:
	rm -rf build

build:
	mkdir build

# TODO: Decide whether to keep
# FILESYSTEM ?= /home/ben/cheri/output/rootfs-riscv64-hybrid/root/installed-binaries
# .PHONY: loadfiles
# loadfiles: all
# 	cp build/HelloWorldTest $(FILESYSTEM)
# 	cp build/pte-bits $(FILESYSTEM)
# 	cp build/CheckStoreCapCapLifetimesTest $(FILESYSTEM)
