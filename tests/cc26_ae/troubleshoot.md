## CMake version error (LLVM-VORTEX build)

If you see this error, your CMake version is too old. Install/upgrade CMake (>= 3.20).

```bash
Starting LLVM-VORTEX build
CMake Error at CMakeLists.txt:3 (cmake_minimum_required):
CMake 3.20.0 or higher is required.  You are running version 3.x.x
```

Please update cmake version using 
```bash
sudo apt update
sudo apt install -y cmake
cmake --version
```

## VERILATOR ERROR 
If you following error, 
```bash 
%Error: verilator: VERILATOR_ROOT is set to inconsistent path. Suggest leaving it unset.
```

Please unser VERILATOR_ROOT
```bash 
unset VERILATOR_ROOT
```

## CuPBoP clang cannot find installed CUDA toolkit

If you see an error during CuPBoP clang compilation indicating that the **installed CUDA toolkit cannot be found**, install CUDA Toolkit locally under `CuPBoP_PATH` and retry.

Run:

```bash
cd "$CuPBoP_PATH"
wget https://developer.download.nvidia.com/compute/cuda/12.1.1/local_installers/cuda_12.1.1_530.30.02_linux.run
mkdir -p cuda-12.1
sh cuda_12.1.1_530.30.02_linux.run --toolkit --toolkitpath="$CuPBoP_PATH/cuda-12.1"
```

## Missing system libs (`-ltinfo`, `-lz`) on minimal Ubuntu/Docker

If the CMake build in CuPBoP_Vortex fails with linker errors like:

```bash
/usr/bin/ld: cannot find -ltinfo
collect2: error: ld returned 1 exit status
```

or

```bash
/usr/bin/ld: cannot find -lz
collect2: error: ld returned 1 exit status
```

install the missing development packages:

```bash
sudo apt-get update
sudo apt-get install -y libtinfo-dev zlib1g-dev
```

If -ltinfo still fails on your Ubuntu variant, try:
```bash
sudo apt-get update
sudo apt-get install -y libncurses-dev
```

