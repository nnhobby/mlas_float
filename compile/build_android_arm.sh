#!/bin/bash

set -ex

REPO_ROOT=$(git rev-parse --show-toplevel)

for TARGET_DIR in "android_arm64_v8a" "android_armeabi_v7a"
do
    mkdir -p ${REPO_ROOT}/build/${TARGET_DIR}

    pushd ${REPO_ROOT}/build/${TARGET_DIR}

    INSTALL_DIR=$(pwd)/${TARGET_DIR}

    ANDROID_ABI=""

    if [[ "${TARGET_DIR}" == "android_arm64_v8a" ]]; then
        ANDROID_ABI="arm64-v8a"
    elif [[ "${TARGET_DIR}" == "android_armeabi_v7a" ]]; then
        ANDROID_ABI="armeabi-v7a"
    fi

    cmake -S ${REPO_ROOT} \
            -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake \
            -DANDROID_ABI=${ANDROID_ABI} \
            -DANDROID_PLATFORM=android-21 \
            -GNinja \
            -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

    cmake --build . --config Release --parallel

    cmake --install .

    tar -cf ${TARGET_DIR}.tar ${TARGET_DIR}

    mv ${TARGET_DIR}.tar ../

    popd
done
