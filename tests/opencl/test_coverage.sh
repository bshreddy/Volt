#!/bin/bash 

if [ ! -d "log" ]; then
  mkdir log
fi

folders=("backprop"
"bfs"
"blackscholes"
"b+tree"
"cfd"
"conv3"
"dotproduct"
"gaussian"
"hotspot3D"
"kmeans"
"lavaMD"
"nearn"
"lbm"
"pathfinder"
"psum"
"saxpy"
"sfilter"
"sgemm3"
"spmv"
"srad"
"transpose"
"vecadd"
"psort"
"stencil" 
"reduce0" ##
"VectorHypot" ##
"cutcp" ##
"mri-q" ##
"myocyte" ##
)


for folder in "${folders[@]}"; do
  echo "Processing app: $folder"
    if [[ ! -d "$folder" ]]; then
    echo "[skip] not a directory: $folder" >&2
    continue
  fi

  if compgen -G "$folder/*O8*.txt" > /dev/null; then
    echo "[skip] O8 result already exists in: $folder" >&2
    continue
  fi

  cd $folder
  echo "[RUN] VORTEX_DIVERGENCE_OPT_LEVEL=8 make run-simx in $folder"
  VORTEX_DIVERGENCE_OPT_LEVEL=8 make run-simx > ../log/log_opt_level_${folder}_8.txt 2>&1 & 
  cd ..
done 


wait
