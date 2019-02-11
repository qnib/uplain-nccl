#!/usr/bin/env bash

: ${CFLAG_MARCH=x86-64}

if [[ "X${BUILD_THREADS}" == "X" ]];then
  BUILD_THREADS=$(nproc --all)
fi

CFLAGS="${CFLAGS} -march=${CFLAG_MARCH}"
echo ">> Use CFLAGS: ${CFLAGS}"
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
  make -j${BUILD_THREADS} pkg.debian.build NVCC_GENCODE="-gencode=arch=${GENCODE}" CFLAGS="${CFLAGS}"
  ;;
*)
  echo ">> make pkg.debian.build"
  make -j${BUILD_THREADS} pkg.debian.build CFLAGS="${CFLAGS}"
  ;;
esac
