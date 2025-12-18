# Volt Artifact Evaluation for CC 2026

## 0. Our Test Environment
We tested this artifact on two x86_64 hosts running Ubuntu 20.04 LTS: (i) AMD EPYC 7702P (64 cores) and (ii) Intel Xeon E5-2696. The entire tests need more than a day. 

## 1. Clone Volt
> Note: This artifact pins all dependencies via Git submodules. Please clone with `--recurse-submodules` (or run `git submodule update --init --recursive`) to check out the exact submodule commits used in our evaluation.

```bash
git clone --recurse-submodules https://github.com/vortexgpgpu/Volt.git
```

## 2. Setup Environment
```bash
cd tests/cc26_ae
source set_env.sh
```

To install toolchain dependencies for Vortex:
```bash
cd $PRJ/vortex
sudo ./ci/install_dependencies.sh
```

## 3. Build Toolchain
```bash
./build.sh
```

For troubleshooting, please check [troubleshoot](https://github.com/vortexgpgpu/Volt/blob/master/tests/cc26_ae/troubleshoot.md).

## 4. Test OpenCL (Figure 7 and 8)

To run the OpenCL divergence management evaluation, execute the following command:
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

The final results for Figure 7 and Figure 8 are located at:
- `tests/opencl/Figure7_result.csv`
- `tests/opencl/Figure8_result.csv`

The execution output for each benchmark row can be found under `vortex/build/tests/opencl/<benchmark-name>`, and the execution logs are located in `vortex/build/tests/opencl/log`.

## 5. Test CUDA Warp-level Features (Case Study 1)

This evaluation demonstrates the extended CuPBoP support for warp-level features in Case Study 1. In this case study, we introduce how to extend CuPBoP built-in kernel functions.

To validate that the CUDA warp-level features are implemented correctly, execute the following command:
```bash
./../cuda/run_case_study1.sh
```

The output will look like:
```bash
=== DONE: 5 jobs, fail=0 ===
=== ALL DONE: total_fail=0 ===
```
This case study is a functionality demonstration of new compiler/runtime support; therefore, we report correctness via successful execution rather than relative speedup.

## 6. Test CUDA memory features (Case Study 2, Figure 10)

This evaluation demonstrates the performance impact of memory-configuration changes in Case Study 2. The case study mainly extends shared-memory lowering support with local memory and compares performance under different cache configurations, as well as different approaches to supporting shared memory.

```bash
./../cuda/run_case_study2.sh
```

The output will look like:
```bash
=== Comparison Summary ===
benchmark   status  details
----------  ------  ----------------------------------------
backprop    passed  
bfs         passed  
btree       passed  
conv3       passed  
dotproduct  passed  
gauss       passed  
nn          passed  
pathfinder  passed  
psort       passed  
psum        passed  
saxpy       passed  
sgemm       passed  
stencil     passed  
transpose   passed  
vecadd      passed  

Counts:
  passed: 15
```

The final result of this evaluation is located in `cupbop/examples/perf_summary_localmem_l2_sums.csv`.

## 7. Play with Diverse Vortex Configuration

To explore Vortex’s highly reconfigurable architecture and the VOLT compiler, you can test a variety of configurations. In addition, you can run each benchmark with the following command:

```bash
cd $VORTEX_PREFIX
export VORTEX_DIVERGENCE_OPT_LEVEL=<vortex-branch-opt>
./ci/blackbox.sh --cores=`<#cores>` --warps=`<#warps>` --threads=`<#threads>` --l2cache --app=`opencl/<benchmark-name>`
```

For more details on changing the Vortex architecture and configuration, please check the [docs](https://github.com/vortexgpgpu/Volt/blob/master/docs/1.getting_started.md#2-changing-the-vortex-architecture-and-configuration)

For more details on changing `vortex-branch-opt`, please chec the [docs](https://github.com/vortexgpgpu/Volt/blob/master/docs/6.analysis_and_transform_passess.md)
