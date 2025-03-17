# Source Codes
This directory contains scripts to process the experiment results.
```
efficient-DDE-experiments/
 |-- Results/                           /* Results and scripts to process them */
     |-- HLA_like/                      /* Results with the HLA-like approach  */
     |-- Solution/                      /* Results with out solution approach */
     |-- SOTA/                          /* Results with the SOTA approach */
     |-- combineCSVAverage.py           /* Combine CSV files storing the measured lags*/
     |-- generateGnuplot.py             /* Generate Gnuplot files according to the measured lags*/
     |-- numSignal.py                   /* Convert the Lingua Franca trace files (*.lft) to CSV files and combine them */
     |-- generateTable.py               /* Create the Latex format table that summarizes the number of network signals */
     |-- SporadicSenderLags.gnuplot     /* Generated Figure 15a in the paper */
     |-- DistanceSensingLags.gnuplot    /* Generated Figure 15b in the paper */
     |-- CycleWithDelayLags.gnuplot     /* Generated Figure 15c in the paper */
     |-- table_num_signals              /* Generated Table 3 in the paper */
     |-- process_results.sh             /* Run every python script and generate figures and table at once */
```