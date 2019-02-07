#!/usr/bin/env bash

echo ">> ${CUDA_COMPUTE_CAPABILITIES}"
case ${CUDA_COMPUTE_CAPABILITIES} in
 [1-9]*)
  SHORT=$(echo ${CUDA_COMPUTE_CAPABILITIES} |sed -e 's/\.//')
  if [[ "X${CUDA_PTX}" == "Xtrue" ]];then
    GENCODE="compute_${SHORT},code=compute_${SHORT}"
  else
    GENCODE="compute_${SHORT},code=sm_${SHORT}"
  fi
  echo ">> make pkg.debian.build NVCC_GENCODE='-gencode=arch=${GENCODE}'"
  make pkg.debian.build NVCC_GENCODE="-gencode=arch=${GENCODE}"
  ;;
*)
  echo ">> make pkg.debian.build"
  make pkg.debian.build
  ;;
esac
