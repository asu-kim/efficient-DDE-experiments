# set terminal pdfcairo enhanced crop color size 40.0,30.0 solid linewidth 4 font "Helvetica, 270"
set key autotitle columnhead
set terminal pdfcairo enhanced
set output 'CycleWithDelayLags.pdf'

bm = 0.15
lm = 0.12
rm = 0.95
gap = 0.03
size = 0.7
bk = 0.6 # relative height of bottom plot
mk = 0.2 # relative height of middle plot
tk = 0.2 # relative height of top plot

xx = 0.8 # the margine between graphs
ww = 0.7 # width of graphs
y1 = 0.0; y2 = 4.5; y3 = 10050; y4 = 10250; y5 = 269050; y6 = 269360

set xlabel "Timer Period (ms)" font ",16"
set ylabel "Average Lag (ms)" font ",16"

set multiplot
set style fill solid 0.5 border -1
set boxwidth 0.85
set datafile separator ","

set xtics font ", 16"
set ytics font ", 16"

set lmargin at screen lm
set rmargin at screen rm
set bmargin at screen bm
set tmargin at screen bm + size * bk

set key font ",16"

set yrange [y1:y2]
set ytics (1, 2, 3, 4)
set xtics ('5' 3, '10' 6, '20' 9)
plot 'CycleWithDelayHLA_likeStatistics.csv' using (3*$1-xx):3:(ww) lt 1 w boxes notitle,\
    '' u (3*$1-xx):3:(sprintf("{/Symbol m}: %.2f", $3)) w labels offset 0,1.4 font ",12" notitle,\
    '' u (3*$1-xx):3:(sprintf("{/Symbol s}: %.1f", $4)) w labels offset 0,0.6 font ",12" notitle,\
    'CycleWithDelaySOTAStatistics.csv' using (3*$1):3:(ww) lt 2 w boxes notitle,\
    '' u (3*$1):3:(sprintf("{/Symbol m}: %.2f", $3)) w labels offset 0,1.4 font ",12" notitle,\
    '' u (3*$1):3:(sprintf("{/Symbol s}: %.1f", $4)) w labels offset 0,0.6 font ",12" notitle,\
    'CycleWithDelaySolutionStatistics.csv' using (3*$1+xx):3:(ww) lt 4 w boxes title 'Our Solution',\
    '' u (3*$1+xx):3:(sprintf("{/Symbol m}: %.2f", $3)) w labels offset 0,1.4 font ",12" notitle,\
    '' u (3*$1+xx):3:(sprintf("{/Symbol s}: %.1f", $4)) w labels offset 0,0.6 font ",12" notitle

unset xtics
unset xlabel
unset ytics
unset ylabel
set ytics ((y3 + y4)/2) font ", 14"
set border 2+8
set bmargin at screen bm + size * bk + gap
set tmargin at screen bm + size * bk + size * mk + gap
set tmargin at screen bm + size + gap + gap
set yrange [y5:y6]
plot 'CycleWithDelayHLA_likeStatistics.csv' using (3*$1-xx):3:(ww) lt 1 w boxes title 'HLA-like',\
    '' u (3*$1-xx-0.15):3:(sprintf("{/Symbol m}: %d", $3)) w labels offset 0,1.7 font ",13" notitle,\
    '' u (3*$1-xx-0.15):3:(sprintf("{/Symbol s}: %d", $4)) w labels offset 0,0.6 font ",13" notitle,\
    'CycleWithDelaySOTAStatistics.csv' using (3*$1):3:(ww) lt 2 w boxes notitle,\
    '' u (3*$1):3:(sprintf("{/Symbol m}: %d", $3)) w labels offset 0,1.7 font ",13" notitle,\
    '' u (3*$1):3:(sprintf("{/Symbol s}: %d", $4)) w labels offset 0,0.6 font ",13" notitle,\
    'CycleWithDelaySolutionStatistics.csv' using (3*$1+xx):3:(ww) lt 4 w boxes notitle

unset multiplot
