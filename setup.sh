#!/bin/sh

# Set up the HLA-like Lingua Franca directory
if [[ -d "lingua-franca-HLA-like" ]]; then
    echo "The folder lingua-franca-HLA-like already exists"
    exit 1
fi
git clone https://github.com/lf-lang/lingua-franca.git lingua-franca-HLA-like
pushd lingua-franca-HLA-like/
git checkout v0.8.1
git submodule init && git submodule update

pushd core/src/main/resources/lib/c/reactor-c
# Build the HLA-like RTI
pushd core/federated/RTI
if [ -d "build" ]; then
    rm -rf build
fi
mkdir build
pushd build
cmake ../
make
popd
popd
# Build the trace tool
pushd util/tracing
make clean
make trace_to_csv
popd
popd
popd


# Set up the SOTA Lingua Franca directory
if [[ -d "lingua-franca-SOTA" ]]; then
    echo "The folder lingua-franca-SOTA already exists"
    exit 1
fi
git clone https://github.com/lf-lang/lingua-franca.git lingua-franca-SOTA
pushd lingua-franca-SOTA/
git checkout 9d6a84c3b36109e90379092ae70d822f362c01d7
git submodule init && git submodule update

pushd core/src/main/resources/lib/c/reactor-c
git checkout 463d49051dbe78fd7a7438f291517e60f5c99ac5

# Build the SOTA RTI
pushd core/federated/RTI
if [ -d "build" ]; then
    rm -rf build
fi
mkdir build
pushd build
cmake ../
make
popd
popd
# Build the trace tool
pushd util/tracing
make clean
make trace_to_csv
popd
popd
popd

# Set up the solution Lingua Franca directory
if [[ -d "lingua-franca-solution" ]]; then
    echo "The folder lingua-franca-solution already exists"
    exit 1
fi
git clone https://github.com/lf-lang/lingua-franca.git lingua-franca-solution
pushd lingua-franca-solution/
git checkout 695086320c4b6acdd6b44d627fb9d002acf96b72
git submodule init && git submodule update

pushd core/src/main/resources/lib/c/reactor-c
git checkout 0923caadb7f67818168bc255bde12150d2df271b

# Build the solution RTI
pushd core/federated/RTI
if [ -d "build" ]; then
    rm -rf build
fi
mkdir build
pushd build
cmake ../
make
popd
popd
# Build the trace tool
pushd util/tracing
make clean
make trace_to_csv
popd
popd
popd