export PRJ="$(cd ../../. && pwd)"

: "${PRJ:?ERROR: $PRJ is not set. Please provide $PRJ(Path-to-Volt-repo)}"

export TOOL_DIR=$PRJ/tools

# env setup for VORTEX
export VORTEX_HOME=$PRJ/vortex
export VORTEX_ARCHITECTURE=64
export VORTEX_PREFIX=$VORTEX_HOME/build
export LD_LIBRARY_PATH=$TOOL_DIR/verilator/bin:$LD_LIBRARY_PATH

VORTEX_TOOLCHAIN_ENV="$PRJ/vortex/build/ci/toolchain_env.sh"
if [ -f "$VORTEX_TOOLCHAIN_ENV" ]; then
  source $PRJ/vortex/build/ci/toolchain_env.sh
else
  echo "WARN: toolchain env not found: $VORTEX_TOOLCHAIN_ENV" >&2
fi

# env setup for LLVM-VORTEX build
export RISCV_TOOLCHAIN_ELF_PATH=$PRJ/tools/riscv${VORTEX_ARCHITECTURE}-gnu-toolchain/riscv${VORTEX_ARCHITECTURE}-unknown-elf
export LLVM_PREFIX=$TOOL_DIR/llvm-vortex
  
# env setup for POCL-VORTEX build
export POCL_PREFIX=$TOOL_DIR/pocl
  
# env setup for CuPBoP-Vortex
export TOOLDIR=$TOOL_DIR
export POCL_ROOT=$POCL_PREFIX
export CuPBoP_PATH=$PRJ/cupbop
export LLVM_VORTEX=$LLVM_PREFIX
export VORTEX_PATH=$VORTEX_PREFIX

CUPBOP_ENV_SETUP="$CuPBoP_PATH/CuPBoP_env_setup_wo_PoCL.sh"
if [ -f "$CUPBOP_ENV_SETUP" ]; then
  source $CuPBoP_PATH/CuPBoP_env_setup_wo_PoCL.sh
else
  echo "WARN: CuPBoP env setup not found: $CUPBOP_ENV_SETUP" >&2
fi
