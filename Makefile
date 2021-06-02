SDK := /home/ben/cheri/output/sdk

CC_BAREMETAL = $(SDK)/utils/cheribsd-riscv64-clang
CFLAGS_BAREMETAL = -O0 -gdwarf-5 \
	-target riscv64-unknown-freebsd \
	-march=rv64gcxcheri -mabi=lp64 \
	-Wl,-Tlinker.ld \
	-fuse-ld=lld -nostdlib -nostartfiles -mno-relax -static

CC_USERSPACE = $(SDK)/utils/cheribsd-riscv64-purecap-clang
CFLAGS_USERSPACE = -O2 \
	-mllvm -enable-stack-temporal-safety-mitigations \
	-mllvm -do-escape-analysis-for-lifetime-checks

OPT = $(SDK)/bin/opt

BAREMETAL_SRC_DIR = tests/baremetal
BAREMETAL_BUILD_DIR = build/baremetal
USERSPACE_SRC_DIR = tests/userspace
USERSPACE_BUILD_DIR = build/userspace
ASM_DIR = $(USERSPACE_BUILD_DIR)/asm
LLVM_IR_DIR = $(USERSPACE_BUILD_DIR)/llvm-ir
NATIVE_BUILD_DIR = $(USERSPACE_BUILD_DIR)/native

# The files to compile
srcs_baremetal = $(wildcard $(BAREMETAL_SRC_DIR)/*.S)
srcs_userspace = $(wildcard $(USERSPACE_SRC_DIR)/*.c)
srcs_userspace_cpp = $(wildcard $(USERSPACE_SRC_DIR)/*.cpp)

# The binaries to create
baremetal_binaries := $(addprefix $(BAREMETAL_BUILD_DIR)/, $(basename $(notdir $(srcs_baremetal))))
userspace_binaries := $(addprefix $(USERSPACE_BUILD_DIR)/, $(basename $(notdir $(srcs_userspace))))
# TODO: Build these too
userspace_cpp_binaries := $(addprefix $(USERSPACE_BUILD_DIR)/, $(basename $(notdir $(srcs_userspace_cpp))))
native_binaries := $(addprefix $(NATIVE_BUILD_DIR)/, $(basename $(notdir $(srcs_userspace))))
native_cpp_binaries := $(addprefix $(NATIVE_BUILD_DIR)/, $(basename $(notdir $(srcs_userspace_cpp))))

.PHONY: all
all: baremetal userspace native native-cpp asm-s asm-binaries llvm-ir

# BASIC COMPILATION
# -----------------------------------------------------------------------------

$(BAREMETAL_BUILD_DIR)/%: tests/baremetal/%.S
	@mkdir -p $(BAREMETAL_BUILD_DIR)
	$(CC_BAREMETAL) $(CFLAGS_BAREMETAL) $< -o $@

$(USERSPACE_BUILD_DIR)/%: tests/userspace/%.c
	@mkdir -p $(USERSPACE_BUILD_DIR)
	$(CC_USERSPACE) $(CFLAGS_USERSPACE) $< -o $@

$(NATIVE_BUILD_DIR)/%: tests/userspace/%.c
	@mkdir -p $(NATIVE_BUILD_DIR)
	$(CC) -O0 -fno-stack-protector $< -o $@

$(NATIVE_BUILD_DIR)/%: tests/userspace/%.cpp
	@mkdir -p $(NATIVE_BUILD_DIR)
	$(CXX) -O0 -fno-stack-protector $< -o $@

.PHONY: baremetal userspace native native-cpp
baremetal: $(baremetal_binaries)
userspace: $(userspace_binaries)
native: $(native_binaries)
native-cpp: $(native_cpp_binaries)

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
asm-binaries: $(userspace_asm_binaries) asm-s


# GENERATING LLVM IR FILES
# -----------------------------------------------------------------------------

userspace_llvm_ir_before_pass_files = $(addsuffix _BeforePass.ll, \
	$(addprefix $(LLVM_IR_DIR)/, $(basename $(notdir $(srcs_userspace)))))
userspace_llvm_ir_after_pass_files = $(addsuffix _AfterPass.ll, \
	$(addprefix $(LLVM_IR_DIR)/, $(basename $(notdir $(srcs_userspace)))))

$(userspace_llvm_ir_before_pass_files): $(LLVM_IR_DIR)/%_BeforePass.ll: $(USERSPACE_SRC_DIR)/%.c
	@mkdir -p $(LLVM_IR_DIR)
	$(CC_USERSPACE) $(CFLAGS_USERSPACE) -S -emit-llvm $< -o $@

$(userspace_llvm_ir_after_pass_files): $(LLVM_IR_DIR)/%_AfterPass.ll: $(LLVM_IR_DIR)/%_BeforePass.ll
	$(OPT) -S --cheri-cap-derived-lifetimes $< > $@

.PHONY: llvm-ir
llvm-ir: $(userspace_llvm_ir_before_pass_files) $(userspace_llvm_ir_after_pass_files)


# COPYING TO QEMU
# -----------------------------------------------------------------------------

FILESYSTEM = /home/ben/cheri/output/rootfs-riscv64-purecap

.PHONY: copy-to-qemu
copy-to-qemu: all asm-binaries
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

.PHONY: test-baremetal
test-baremetal: all
	scripts/run_baremetal_tests.sh

# Uncomment if you wanna see all variables printed (for debugging this Makefile!)
#$(foreach v, $(.VARIABLES), $(info $(v) = $($(v))))

