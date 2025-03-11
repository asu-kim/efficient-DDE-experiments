#!/bin/sh

pushd lingua-franca/core/src/main/resources/lib/c/reactor-c/core/federated/RTI
if [ -d "build" ]; then
    rm -rf build
fi
mkdir build
pushd build
cmake ../
make
popd
popd

#cp lingua-franca/core/src/main/resources/lib/c/reactor-c/core/federated/RTI/build/RTI ./

