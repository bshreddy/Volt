AE_HOME_DIR=$(pwd)

cd $CuPBoP_PATH/examples

#cd $VORTEX_PREFIX
#./ci/blackbox.sh --cores=4 --warps=16 --threads=32 --l2cache --app=opencl/vecadd

./CGO_batch_warp_feature_run.sh

cd $AE_HOME_DIR