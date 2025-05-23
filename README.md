# [efficient-DDE-experiments](https://github.com/asu-kim/efficient-DDE-experiments)

[![DOI](https://zenodo.org/badge/946745961.svg)](https://doi.org/10.5281/zenodo.15263644)

This is an artifact for evaluation of the paper (PADS'25):

"Improving the Efficiency of Coordinating Timed Events in Distributed Systems"

Accepted to ACM SIGSIM PADS 2025.

This repository can be accessed via: [https://github.com/asu-kim/efficient-DDE-experiments](https://github.com/asu-kim/efficient-DDE-experiments)

## Authors & Contacts
* **Byeonggil Jun** \<<byeonggil@asu.edu>\>
* Edward A. Lee \<<eal@berkeley.edu>\>
* Marten Lohstroh \<<marten@berkeley.edu>\>
* Hokeun Kim \<<hokeun@asu.edu>\> \[[Website](https://hokeun.github.io/)\]

## Requirements
* Linux system with gcc toolchain and [linux traffic control](https://man7.org/linux/man-pages/man8/tc.8.html) 
* Root privileges for [linux traffic control](https://man7.org/linux/man-pages/man8/tc.8.html) to change the network setting
* 5GB of memory space

The hardware/software configurations used by the authors are:
* Configuration 1
    * CPU: Intell 14900k
    * RAM: 128GB
    * OS: Ubuntu 22.04
* Configuration 2
    * Hardware: Raspberry Pi 4
    * RAM: 4GB
    * OS: Raspberry Pi OS (64-bit) (Linux raspberrypi 6.6.28+rpt-rpi-v8 #1 SMP PREEMPT Debian 1:6.6.28-1+rpt1 (2024- 04-22) aarch64 GNU/Linux)

## Dependencies
* For running tests: `bash, git, java (>=17), cmake (>=3.13), gcc, make, iproute2`
* For processing data and generating figures: `bash, python3, pip3, pandas, gnuplot`

## Structure of the Artifact
```
efficient-DDE-experiments/
 |-- fed-gen/       /* Reactor programs generated during runs */
 |-- lingua-franca-HLA-like/ /* Baseline Lingua Franca toolchain */
 |-- lingua-franca-solution/ /* Lingua Franca with our solution */
 |-- lingua-franca-SOTA/ /* Lingua Franca with DNET signal capability */
 |-- Results/       /* Raw results and scripts to process them */
 |-- src/           /* Lingua Franca programs for testing and scripts to run tests for each approach */
 |-- LICENSE        /* License */
 |-- README.md      /* This file */
 |-- clean_all.sh   /* Script to clean up the generated codes */
 |-- run_all.sh     /* Script to run all tests */
 |-- setup.sh       /* Script to set up the environment */
```

## License
The software is released with the BSD 2-Clause License.

## Article Claims
The article has two major claims:
* C1: Our solution prevents the programs `DistanceSensing` and `CycleWithDelay` from suffering excessive lags even with shorter timer periods, e.g., 5ms and 10 ms, where HLA-like and SOTA approaches fail.
* C2: Our solution reduces communication overhead, i.e., the number of exchanged signals, for all programs.

## Reproducing the Results.
The paper has 1 figure (3 subfigures) and 1 table that can be reproduced. The following table summarizes the mapping between claims with figures and table.

| Claim |  Figures and Table of our PADS'25 Paper  |
|-------|------------------------------------------|
| C1    |   Figure 15a, Figure 15b, Figure 15c     |
| C2    |               Table 3                    |

### Instructions
1. Set up environments, including cloning Lingua Franca and building the Lingua Franca compiler, the runtime infrastructure (RTI), and the tracing tool.
```
./setup.sh
```

2. Run the tests with the root privilege. This script runs the scripts `src/run_HLA_like_tests.sh`, `src/run_solution_tests.sh`, and `src/run_SOTA_tests.sh`.
```
sudo ./run_all.sh
```

3. Process the results, specifically, generate the CSV files containing the measured lags, draw graphs based on the CSV files, and create the Latex table with the measured number of exchanged network signals.
```
cd Results/
./process_results.sh
```

This script runs the following Python scripts:
```
combineCSVAverage.py /* Combine CSV files storing the measured lags*/
generateGnuplot.py /* Generate Gnuplot files according to the measured lags*/
numSignal.py /* Convert the Lingua Franca trace files (*.lft) to CSV files and combine them */
generateTable.py /* Create the Latex format table that summarizes the number of network signals */
```
and generates plots by running the following commands:
```
gnuplot SporadicSenderLags.gnuplot
gnuplot DistanceSensingLags.gnuplot 
gnuplot CycleWithDelayLags.gnuplot
```

### Expected Runtime
The expected runtime is `500 sec` (each program's timeout time) * 15 (number of programs) * 3 (number of approaches) = `6.25 hours` excluding the compilation and setup time. 

### Result Graphs and Table
After the tests are complete, you can find `SporadicSenderLags.pdf`, `DistanceSensingLags.pdf`, and `CycleWithDelayLags.pdf`, which are Figure 15a, Figure 15b, and Figure 15c of our PADS'25 paper, respectively.
You can also find `table_num_signals.tex`, which is Table 3 of our PADS'25 paper.

## Notes for Repeatability of Experiments
All scripts assume that they run on the directory they locate.

Before running the tests, make sure the command `sudo tc qdisc add dev lo root netem delay 5ms 1ms` runs correctly by running the following commands:
```
sudo tc qdisc add dev lo root netem delay 5ms 1ms
ping localhost
sudo tc qdisc del dev lo root # Reset the network delay.
```
and checking whether the measured delay is around `10 msec` or not.
We tested this on VMs and saw that VMs usually fail to report the stable network delay due to the VM scheduling issue, virtualized network overhead, etc.
Our solution can make sure that the delay won't be accumulated even with the network delay much higher than `10 ms` such as `100 msec` but the average delay will be higher than the results in the paper.
