# Volt Artifact Evaluation for CC 2025

## 0. Clone Volt
```bash
git clone --recurse-submodules git@github.com:vortexgpgpu/Volt.git
```

## 1. Setup Environment

```bash
cd tests/cc26_ae
source set_env.sh
```

For installing toolchain dependency for Vortex,
```bash
cd $PRJ/vortex
sudo sudo ./ci/install_dependencies.sh
```

## 2. Build Toolchain 
```bash 
./build.sh 
```