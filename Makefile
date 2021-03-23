SDK = /home/ben/cheri/output/sdk

CC_BAREMETAL = $(SDK)/utils/cheribsd-riscv64-clang
CFLAGS_BAREMETAL = -O0 -gdwarf-5 \
	-target riscv64-unknown-freebsd \
	-march=rv64gcxcheri -mabi=lp64 \
	-Wl,-Tlinker.ld \
	-fuse-ld=lld -nostdlib -nostartfiles -mno-relax -static

CC_USERSPACE = $(SDK)/utils/cheribsd-riscv64-purecap-clang
CFLAGS_USERSPACE = -O0

BAREMETAL_BUILD_DIR = build/baremetal
BAREMETAL_SRC_DIR = tests/baremetal
USERSPACE_BUILD_DIR = build/userspace
USERSPACE_SRC_DIR = tests/userspace

BAREMETAL_TESTS = $(BAREMETAL_BUILD_DIR)/BreathingTest \
				  $(BAREMETAL_BUILD_DIR)/ContainsNewInstruction \
				  $(BAREMETAL_BUILD_DIR)/CorrectLifetimeOrientations

USERSPACE_TESTS = $(USERSPACE_BUILD_DIR)/HelloWorld \
				  $(USERSPACE_BUILD_DIR)/LifetimesTest

.PHONY: all
all: $(BAREMETAL_TESTS) $(USERSPACE_TESTS)

$(BAREMETAL_BUILD_DIR)/%: $(BAREMETAL_SRC_DIR)/%.S $(BAREMETAL_BUILD_DIR)
	$(CC_BAREMETAL) $(CFLAGS_BAREMETAL) -o $@ $<

$(USERSPACE_BUILD_DIR)/%: $(USERSPACE_SRC_DIR)/%.c $(USERSPACE_BUILD_DIR)
	$(CC_USERSPACE) $(CFLAGS_USERSPACE) -o $@ $<

asm:
	mkdir -p asm

asm/%.S: $(USERSPACE_SRC_DIR)/%.c asm
	$(CC_USERSPACE) -S -o $@ $<

build_asm:
	mkdir -p build_asm

build_asm/%: asm/%.S build_asm
	$(CC_USERSPACE) -o $@ $<

.PHONY: clean
clean:
	rm -rf build

build:
	mkdir build

$(BAREMETAL_BUILD_DIR): build
	mkdir -p $(BAREMETAL_BUILD_DIR)

$(USERSPACE_BUILD_DIR): build
	mkdir -p $(USERSPACE_BUILD_DIR)

test: all
	./run_tests.sh

# This stuff is just for copying the built binaries to QEMU
FILESYSTEM = /home/ben/cheri/output/rootfs-riscv64-purecap

.PHONY: copy-to-emulator
copy-to-emulator: all
	mkdir -p $(FILESYSTEM)/root/tests
	mkdir -p $(FILESYSTEM)/root/tests_c
	mkdir -p $(FILESYSTEM)/root/tests_asm
	cp $(USERSPACE_BUILD_DIR)/* $(FILESYSTEM)/root/tests_c
	cp build_asm/* $(FILESYSTEM)/root/tests_asm
