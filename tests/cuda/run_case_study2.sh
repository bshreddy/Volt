#!/bin/bash 

AE_HOME_DIR=$(pwd)

pip intstall pandas

cd $VORTEX_PREFIX
./ci/blackbox.sh --cores=4 --warps=16 --threads=32 --app=opencl/vecadd


cd $CuPBoP_PATH/examples

./CC_batch_run.sh

cd $VORTEX_PREFIX
./ci/blackbox.sh --cores=4 --warps=16 --threads=32 --app=opencl/vecadd


cd $CuPBoP_PATH/examples
./CC_batch_run.sh

python collect_result.py -s test_tmp

python result_comparison.py perf_summary_localmem_l2_sums.csv

cd $HOME_DIR
