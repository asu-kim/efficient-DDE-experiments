#!/bin/sh

pushd src
./run_HLA_like_tests
./run_solution_tests
./run_SOTA_tests
popd