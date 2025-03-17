# Source Codes
This directory contains the programs under tests and scripts to run approaches, HLA-like, SOTA, and our solution.
```
efficient-DDE-experiments/
 |-- src/           /* Lingua Franca programs for testing and scripts to run tests for each approach */
     |-- CycleWithDelay/             /* LF programs described in Figure 13 in the paper with different timer periods */
     |-- DistanceSensing/            /* LF programs described in Figure 11 in the paper with different timer periods */
     |-- SporadicSender/             /* LF programs described in Figure 7 in the paper with different timer periods */
     |-- run_HLA_like_tests.sh      /* Script to run programs with the HLA-like approach */
     |-- run_solution_tests.sh      /* Script to run programs with the SOTA approach */
     |-- run_SOTA_tests.sh          /* Script to run programs with out solution approach */
```

To run each approach manaully, execute `./run_HLA_like_tests.sh`, `./run_solution_tests.sh`, or `./run_SOTA_tests.sh` in this directory.