#!/bin/bash

python3 combineCSVAverage.py
python3 generateGnuplot.py
python3 numSignal.py
python3 generateTable.py

gnuplot SporadicSenderLags.gnuplot
gnuplot DistanceSensingLags.gnuplot 
gnuplot CycleWithDelayLags.gnuplot