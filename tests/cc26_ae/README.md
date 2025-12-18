# Volt Artifact Evaluation for CC 2026

## 0. Clone Volt
```bash
git clone --recurse-submodules git@github.com:vortexgpgpu/Volt.git
```

## 1. Setup Environment
```bash
cd tests/cc26_ae
source set_env.sh
```

To install toolchain dependencies for Vortex:
```bash
cd $PRJ/vortex
sudo ./ci/install_dependencies.sh
```

## 2. Build Toolchain
```bash
./build.sh
```

For troubleshooting, please check `tests/cc26_ae/troubleshoot.md`.

## 3. Test OpenCL

To run the OpenCL evaluation, execute the following command:
```bash
./../opencl/run_evaluation.sh
```

The output will look like:
```bash
Regression Test vs Expected (row-wise, 1% tol):

[TOTAL]
pass=40, fail_verification=0, fail_run=0
```

It will also print the Instruction Reduction Table, Speedup Table, and Coverage Tables.

## 4. Test CUDA warp-level features (Case Study 1)

This evaluation demonstrates the extended CuPBoP support for warp-level features. To run the CUDA warp-level feature evaluation, execute the following command:
```bash
./../cuda/run_case_study1.sh
```

The output will look like:
```bash
=== DONE: 5 jobs, fail=0 ===
=== ALL DONE: total_fail=0 ===
```

## 5. Test CUDA memory features

This evaluation demonstrates the performance impact of memory-configuration changes.

```bash
./../cuda/run_case_study2.sh
```

The output will look like:
```bash
# (example output)
```
