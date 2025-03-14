#!/bin/bash

pushd src
./run_HLA_like_tests.sh
./run_solution_tests.sh
./run_SOTA_tests.sh
popd