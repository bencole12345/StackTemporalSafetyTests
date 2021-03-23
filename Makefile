SDK = /home/ben/cheri/output/sdk

CC_BAREMETAL = $(SDK)/utils/cheribsd-riscv64-clang
CFLAGS_BAREMETAL = -O0 -gdwarf-5 \
	-target riscv64-unknown-freebsd \
	-march=rv64gcxcheri -mabi=lp64 \
	-Wl,-Tlinker.ld \
	-fuse-ld=lld -nostdlib -nostartfiles -mno-relax -static

CC_USERSPACE = $(SDK)/utils/cheribsd-riscv64-purecap-clang
CFLAGS_USERSPACE = -O0

BAREMETAL_SRC_DIR = tests/baremetal
BAREMETAL_BUILD_DIR = build/baremetal
USERSPACE_SRC_DIR = tests/userspace
USERSPACE_BUILD_DIR = build/userspace
ASM_DIR = $(USERSPACE_BUILD_DIR)/asm

# The files to compile
srcs_baremetal = $(wildcard $(BAREMETAL_SRC_DIR)/*.S)
srcs_userspace = $(wildcard $(USERSPACE_SRC_DIR)/*.c)

# The binaries to create
# TODO: Get rid of _preamble.S
baremetal_binaries := $(addprefix $(BAREMETAL_BUILD_DIR)/, $(basename $(notdir $(srcs_baremetal))))
userspace_binaries := $(addprefix $(USERSPACE_BUILD_DIR)/, $(basename $(notdir $(srcs_userspace))))

.PHONY: all
all: $(baremetal_binaries) $(userspace_binaries)


# COMPILATION
# -----------------------------------------------------------------------------

$(baremetal_binaries): $(srcs_baremetal)
	@mkdir -p $(BAREMETAL_BUILD_DIR)
	$(CC_BAREMETAL) $(CFLAGS_BAREMETAL) $< -o $@

$(userspace_binaries): $(srcs_userspace)
	@mkdir -p $(USERSPACE_BUILD_DIR)
	$(CC_USERSPACE) $(CFLAGS_USERSPACE) $< -o $@


# FIDDLING WITH INTERMEDIATE .S FILES
# -----------------------------------------------------------------------------

userspace_asm_binaries := $(addprefix $(ASM_DIR)/, $(basename $(notdir $(srcs_userspace))))
userspace_asm_s_files := $(addsuffix .S, $(userspace_asm_binaries))

$(userspace_asm_s_files): $(ASM_DIR)/%.S: $(USERSPACE_SRC_DIR)/%.c
	@mkdir -p $(ASM_DIR)
	$(CC_USERSPACE) $(CFLAGS_USERSPACE) -S $< -o $@

$(userspace_asm_binaries): $(ASM_DIR)/%: $(ASM_DIR)/%.S
	@mkdir -p $(ASM_DIR)
	$(CC_USERSPACE) $(CFLAGS_USERSPACE) $< -o $@

.PHONY: asm-s
asm-s: $(userspace_asm_s_files)

.PHONY: asm-binaries
asm-binaries: $(userspace_asm_binaries)


# COPYING TO EMULATOR
# -----------------------------------------------------------------------------

FILESYSTEM = /home/ben/cheri/output/rootfs-riscv64-purecap

.PHONY: copy-to-emulator
copy-to-emulator: all
	mkdir -p $(FILESYSTEM)/root/tests
	mkdir -p $(FILESYSTEM)/root/tests_c
	mkdir -p $(FILESYSTEM)/root/tests_asm
	cp -r $(USERSPACE_BUILD_DIR)/* $(FILESYSTEM)/root/tests_c
	cp -r $(ASM_DIR)/* $(FILESYSTEM)/root/tests_asm


# MISC
# -----------------------------------------------------------------------------

.PHONY: clean
clean:
	rm -rf build

.PHONY: test
test: all
	./run_tests.sh
