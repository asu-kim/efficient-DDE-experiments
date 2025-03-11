#!/bin/sh

pushd lingua-franca/core/src/main/resources/lib/c/reactor-c/util/tracing
make clean
make trace_to_csv
popd
