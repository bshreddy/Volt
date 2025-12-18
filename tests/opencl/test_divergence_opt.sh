#!/bin/bash 

if [ ! -d "log" ]; then
  mkdir log
fi

folders=(
"b+tree"
"hotspot3D"
"kmeans"
"sgemm3"
"srad"
"cfd"
"psort"
"pathfinder"
"transpose"
)

for folder in "${folders[@]}"; do
  echo "Processing app: $folder"
  ./subtest_divergence_opt.sh $folder &
done 

wait
