#!/bin/bash

# Check for sudo privileges at the start
if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo privileges. Please run with sudo."
    exit 1
fi

# Get the actual user who ran sudo
ACTUAL_USER=${SUDO_USER:-$(whoami)}

pushd src
./run_HLA_like_tests.sh
./run_solution_tests.sh
./run_SOTA_tests.sh
popd

# Change ownership of generated files back to the actual user
chown -R $ACTUAL_USER:$ACTUAL_USER ./Results