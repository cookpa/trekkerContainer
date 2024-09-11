#!/bin/bash -e

buildType=Release
buildShared=OFF

threads=4

baseDir=$(pwd)

trekker_tag=$1

echo "Cloning source"
mkdir src
git clone --depth 1 --recurse-submodules https://github.com/nibrary/nibrary src/nibrary
git clone --depth 1 -b $trekker_tag https://github.com/dmritrekker/trekker src/trekker

mkdir -p build/nibrary build/trekker

# Note - both nibrary and trekker install to build_dir/install, regardless of
# -DCMAKE_INSTALL_PREFIX

cd build/nibrary

echo
echo "Building nibrary"
echo

cmake \
    -DCMAKE_BUILD_TYPE=${buildType} \
    -DBUILD_SHARED_LIBS=${buildShared} \
    ../../src/nibrary

cmake \
    --build . \
    --config ${buildType} \
    --target install \
    --parallel $threads


cd ../trekker

echo
echo "Building trekker"
echo

inc_path="${baseDir}/build/nibrary/install/include/nibrary_v0.1.0"
lib_path="${baseDir}/build/nibrary/install/lib/nibrary_v0.1.0"

cmake \
    -DCMAKE_BUILD_TYPE=${buildType} \
    -DBUILD_SHARED_LIBS=${buildShared} \
    -DCMAKE_INCLUDE_PATH=${inc_path} \
    -DCMAKE_LIBRARY_PATH=${lib_path} \
    ../../src/trekker

cmake \
    --build . \
    --config ${buildType} \
    --target install \
    --parallel $threads
