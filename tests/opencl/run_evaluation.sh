#!/bin/bash 

HOME_DIR=$(pwd)
export TEST_HOME=$PRJ/tests/opencl

cd $VORTEX_PREFIX
./ci/blackbox.sh --cores=4 --warps=16 --threads=32 --l2cache --app=opencl/vecadd

cd $VORTEX_PREFIX/tests/opencl
echo $(pwd)

cp $TEST_HOME/test_divergence_opt.sh .
cp $TEST_HOME/test_coverage.sh .
cp $TEST_HOME/subtest_divergence_opt.sh .
cp $TEST_HOME/parser.py .
cp $TEST_HOME/Figure7_expected.csv .
cp $TEST_HOME/Figure8_expected.csv .
cp $TEST_HOME/coverage_expected.csv .

./test_divergence_opt.sh
./test_coverage.sh

python3 parser.py
#cat Figure7.csv
#cat Figure8.csv
#cat coverage.csv

mv Figure7.csv $TEST_HOME/Figure_7_result.csv
mv Figure8.csv $TEST_HOME/Figure_8_result.csv
mv coverage.csv $TEST_HOME/coverage_result.csv

cd $HOME_DIR
