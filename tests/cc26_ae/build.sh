#!/bin/bash

AE_HOME_DIR=$(pwd)

: "${PRJ:?ERROR: $PRJ is not set. Please provide $PRJ(Path-to-Volt-repo)}"

printf "Volt Path: %s\n" "$PRJ"
printf "Vortex Architecture: %d\n" "$VORTEX_ARCHITECTURE"

# Create necessary directories
cd $PRJ 
mkdir -p tools 
echo "Created tools directory: $PRJ/tools"

#-----------------------------------------------------#
# Build VORTEX

printf "Starting VORTEX build for %d-bit architecture...\n" "$VORTEX_ARCHITECTURE"
cd $PRJ/vortex 
#sudo ./ci/install_dependencies.sh

mkdir -p build
cd build

../configure --xlen=64 --tooldir=$TOOL_DIR --prefix=$VORTEX_PREFIX
./ci/toolchain_install.sh --all 
source ./ci/toolchain_env.sh
make -s
make install

./ci/blackbox.sh --cores=4 --warps=16 --threads=32 --app=vecadd   

echo "VORTEX build and installation completed."
ls $VORTEX_HOME/build 

#-----------------------------------------------------#
# Build LLVM-VORTEX
cd $PRJ
mv $LLVM_PREFIX $TOOL_DIR/llvm-vortex-prebuilt 
mkdir $TOOL_DIR/llvm-vortex
printf "Starting LLVM-VORTEX build" $LLVM_PREFIX "\n"

cd $PRJ/llvm
mkdir -p build
cd build

cmake -G "Unix Makefiles" -DLLVM_ABI_BREAKING_CHECKS=FORCE_OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DBUILD_SHARED_LIBS=True -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_PROJECTS="clang" -DCMAKE_INSTALL_PREFIX=$LLVM_PREFIX -DDEFAULT_SYSROOT=$RISCV_TOOLCHAIN_ELF_PATH -DLLVM_DEFAULT_TARGET_TRIPLE="riscv64-unknown-elf" -DLLVM_TARGETS_TO_BUILD="X86;RISCV;NVPTX" ../llvm
make -j`nproc`

make install

echo "LLVM-VORTEX build and installation completed."
ls $LLVM_PREFIX

#-----------------------------------------------------#
# Build POCL-VORTEX
cd $PRJ
mv $POCL_PREFIX $TOOL_DIR/pocl-vortex-prebuilt 
mkdir $TOOL_DIR/pocl-vortex
printf "Starting POCL-VORTEX build...\n"

cd $PRJ/pocl
mkdir -p build
cd build

cmake -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_INSTALL_PREFIX=$POCL_PREFIX \
  -DWITH_LLVM_CONFIG=$LLVM_PREFIX/bin/llvm-config \
  -DVORTEX_HOME=$VORTEX_HOME \
  -DVORTEX_BUILD=$VORTEX_PREFIX \
  -DENABLE_VORTEX=ON \
  -DKERNEL_CACHE_DEFAULT=OFF \
  -DENABLE_HOST_CPU_DEVICES=OFF \
  -DENABLE_TESTS=OFF \
  -DPOCL_DEBUG_MESSAGES=ON \
  -DENABLE_ICD=OFF ..

make -j`nproc`
make install

cd $PRJ/vortex/build
./ci/blackbox.sh --cores=4 --warps=16 --threads=32 --app=opencl/vecadd   

echo "POCL-VORTEX build and installation completed."
ls $POCL_PREFIX

#-----------------------------------------------------#
# Build CuPBoP-VORTEX
printf "Starting CuPBoP-VORTEX build...\n"

cd $PRJ/cupbop
export CuPBoP_PATH=$PRJ/cupbop
export LD_LIBRARY_PATH=$CuPBoP_PATH/build/runtime:$CuPBoP_PATH/build/runtime/threadPool:$LD_LIBRARY_PATH

wget "https://dl.dropboxusercontent.com/scl/fi/m9ap1tiybau4zk720t2z7/cuda-header.tar.gz?rlkey=zmdpst5l66t48ywrbtkj426nu&st=luao6zy7" -O cuda-header.tar.gz
tar -xzf 'cuda-header.tar.gz'
cp -r include/* runtime/threadPool/include/

wget https://developer.download.nvidia.com/compute/cuda/12.1.1/local_installers/cuda_12.1.1_530.30.02_linux.run
mkdir -p cuda-12.1
sh cuda_12.1.1_530.30.02_linux.run --silent --toolkit --toolkitpath=$CuPBoP_PATH/cuda-12.1

$CuPBoP_PATH/CuPBoP_env_setup_wo_PoCL.sh
mkdir -p build
cd build
cmake .. -DLLVM_CONFIG_PATH=$LLVM_PREFIX/bin/llvm-config
make 

cd $PRJ/cupbop/examples/vecadd
./kjrun_llvm18.sh

echo "CuPBoP-VORTEX build and installation completed."

cd $AE_HOME_DIR
