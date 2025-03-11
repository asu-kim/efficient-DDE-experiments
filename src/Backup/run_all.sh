#!/bin/bash

pushd /home/byeonggil/project/lingua-franca
echo "Checkout Lingua Franca to plain"
git checkout plain
popd
pushd /home/byeonggil/project/lingua-franca/core/src/main/resources/lib/c/reactor-c
echo "Checkout REACTOR-C to plain"
git checkout plain
popd
pushd ./src
echo "Run Baseline tests at $(pwd)"
./run_Baseline_tests.sh
popd

pushd /home/byeonggil/project/lingua-franca
echo "Checkout Lingua Franca to only-dnet"
git checkout only-dnet
popd
pushd /home/byeonggil/project/lingua-franca/core/src/main/resources/lib/c/reactor-c
echo "Checkout REACTOR-C to only-dnet"
git checkout only-dnet
popd
pushd ./src
echo "Run DNET tests at $(pwd)"
./run_DNET_tests.sh
popd

pushd /home/byeonggil/project/lingua-franca
echo "Checkout Lingua Franca to rti-DNET"
git checkout rti-DNET
popd
pushd /home/byeonggil/project/lingua-franca/core/src/main/resources/lib/c/reactor-c
echo "Checkout REACTOR-C to rti-DNET"
git checkout rti-DNET
popd
pushd ./src
echo "Run Solution tests at $(pwd)"
./run_Solution_tests.sh
popd
