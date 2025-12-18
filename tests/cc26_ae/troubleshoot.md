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