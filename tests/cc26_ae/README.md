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

For installing toolchain dependency for Vortex,
```bash
cd $PRJ/vortex
sudo sudo ./ci/install_dependencies.sh
```

## 2. Build Toolchain 
```bash 
./build.sh 
```
For trouble shooting, please check `tests/cc26_ae/troubleshoot.md`

## 3. Test OpenCL 

For test opencl evaluation, perform following command.
```bash 
./../opencl/run_evaluation.sh
```

The result will be,
```bash 
Regression Test vs Expected (row-wise, 1% tol):

[TOTAL]
pass=40, fail_verification=0, fail_run=0
```
And also show Instructions Reduction Table, Speedup Table, Coverage Tables.

## 3. Test CUDA warp-level features in case study 1

In this evaluation, we want to show extended support of cupbop with warp-level features. For test CUDA warp-level feature supports, perform following command.

```bash 
./../cuda/run_case_study1.sh
```

The result will be
```bash
=== DONE: 5 jobs, fail=0 ===
=== ALL DONE: total_fail=0 ===
```

## 4. Test CUDA memory features

In this evaluation, we want to show performance impact under memory configuration changes.

```bash 
./../cuda/run_case_study1.sh
```

The result will be
```bash

```