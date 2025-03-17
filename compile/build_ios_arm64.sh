#!/bin/bash

set -ex

REPO_ROOT=$(git rev-parse --show-toplevel)

TARGET_DIR=ios_arm64

mkdir -p ${REPO_ROOT}/build/${TARGET_DIR}

pushd ${REPO_ROOT}/build/${TARGET_DIR}

INSTALL_DIR=$(pwd)/${TARGET_DIR}

cmake -S ${REPO_ROOT} \
    -G Xcode \
    -DCMAKE_TOOLCHAIN_FILE=${REPO_ROOT}/cmake/ios.toolchain.cmake \
    -DPLATFORM=OS64 \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

cmake --build . --config Release --parallel

cmake --install . --config Release

tar -cf ${TARGET_DIR}.tar ${TARGET_DIR}

mv ${TARGET_DIR}.tar ../

popd
