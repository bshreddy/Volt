#!/bin/bash 

AE_HOME_DIR=$(pwd)

pip3 install pandas


export VORTEX_L2_FLAG=0
cd $VORTEX_PREFIX
./ci/blackbox.sh --cores=4 --warps=16 --threads=32 --app=opencl/vecadd


cd $CuPBoP_PATH/examples

./CC_batch_run.sh

export VORTEX_L2_FLAG=1
cd $VORTEX_PREFIX
./ci/blackbox.sh --cores=4 --warps=16 --threads=32 --l2cache --app=opencl/vecadd


cd $CuPBoP_PATH/examples
./CC_batch_run.sh

python3 collect_result.py -s test_tmp

python3 result_comparison.py perf_summary_localmem_l2_sums.csv

cd $HOME_DIR
