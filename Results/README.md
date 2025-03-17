# Experiment Results
This directory contains scripts to process the experiment results.
```
efficient-DDE-experiments/
 |-- Results/
     |-- HLA_like/                      /* Results with the HLA-like approach  */
     |-- Solution/                      /* Results with out solution approach */
     |-- SOTA/                          /* Results with the SOTA approach */
     |-- combineCSVAverage.py           /* Python script to combine CSV files storing the measured lags*/
     |-- generateGnuplot.py             /* Python script to modify Gnuplot files according to the measured lags*/
     |-- numSignal.py                   /* Python script to convert the Lingua Franca trace files (*.lft) to CSV files and combine them */
     |-- generateTable.py               /* Python script to create the Latex format table that summarizes the number of network signals */
     |-- SporadicSenderLags.gnuplot     /* Gnuplot code to generate Figure 15a in the paper */
     |-- SporadicSenderLags.pdf         /* Generated Figure 15a in the paper */
     |-- DistanceSensingLags.gnuplot    /* Gnuplot code to generate Figure 15b in the paper */
     |-- DistanceSensingLags.pdf        /* Generated Figure 15b in the paper */
     |-- CycleWithDelayLags.gnuplot     /* Gnuplot code to generate Figure 15c in the paper */
     |-- CycleWithDelayLags.pdf         /* Generated Figure 15c in the paper */
     |-- table_num_signals              /* Generated Table 3 in the paper */
     |-- process_results.sh             /* Run every python script and generate figures and table at once */
```