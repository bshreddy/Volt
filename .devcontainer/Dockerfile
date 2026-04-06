FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y build-essential valgrind libstdc++6 binutils python3 uuid-dev ccache cmake wget git zlib1g-dev libtinfo-dev libncurses-dev

RUN apt-get install -y manpages-dev software-properties-common && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get install -y gcc-11 g++-11

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11


RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN wget https://apt.llvm.org/llvm.sh -O /tmp/llvm.sh && \
    chmod +x /tmp/llvm.sh && \
    /tmp/llvm.sh 21 && \
    apt install clangd-21

ENV PRJ=/workspaces/volt
ENV TOOLDIR=$PRJ/tools

ENV CuPBoP_PATH=$PRJ/cupbop

ENV POCL_ROOT=$PRJ/pocl/build/

ENV VORTEX_HOME=$PRJ/vortex
ENV VORTEX_PREFIX=$VORTEX_HOME/build
ENV VORTEX_PATH=$VORTEX_HOME/build
ENV VORTEX_ARCHITECTURE=64

ENV LLVM_PREFIX=$PRJ/llvm/build
ENV LLVM_CONFIG_PATH=$LLVM_PREFIX/bin/llvm-config

ENV POCL_PREFIX=$TOOLDIR/pocl
ENV PATH="$PRJ/cmake/bin:$LLVM_PREFIX/bin:$PATH"

ENV LD_LIBRARY_PATH="$CuPBoP_PATH/build/runtime:$CuPBoP_PATH/build/runtime/threadPool:$LD_LIBRARY_PATH"
ENV LD_LIBRARY_PATH="$CuPBoP_PATH/cuda-12.1/lib64:$LD_LIBRARY_PATH"
ENV LD_LIBRARY_PATH="${LLVM_PREFIX}/lib:${LD_LIBRARY_PATH}"
ENV LD_LIBRARY_PATH="${VORTEX_PATH}/runtime/:${LD_LIBRARY_PATH}"
ENV RISCV_TOOLCHAIN="${TOOLDIR}/riscv64-gnu-toolchain"
ENV RISCV_TOOLCHAIN_ELF_PATH=$RISCV_TOOLCHAIN/riscv64-unknown-elf

RUN echo "source $VORTEX_HOME/build/ci/toolchain_env.sh" >> ~/.bashrc
