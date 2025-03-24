# set terminal pdfcairo enhanced crop color size 40.0,30.0 solid linewidth 4 font "Helvetica, 270"
set key autotitle columnhead
set terminal pdfcairo enhanced
set output 'SporadicSenderLags.pdf'

bm = 0.15
lm = 0.12
rm = 0.95
gap = 0.03
size = 0.7
# bk = 0.6 # relative height of bottom plot
# mk = 0.2 # relative height of middle plot
# tk = 0.2 # relative height of top plot

xx = 0.8 # the margine between graphs
ww = 0.7 # width of graphs
# y1 = 0.0; y2 = 4.5; y3 = 1570; y4 = 1630; y5 = 15430; y6 = 15555

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
set tmargin at screen bm + size + gap

set key font ",16"

set yrange [0:0.25]
set ytics (0.05, 0.1, 0.15, 0.2)
set xtics ('5' 3, '10' 6, '20' 9)

# Filter to only show rows with delay <= 20ms
plot 'SporadicSenderHLA_likeStatistics.csv' using ($2 <= 20 ? 3*$1-xx : 1/0):3:(ww) lt 1 w boxes title 'HLA-like',\
    '' using ($2 <= 20 ? 3*$1-xx : 1/0):3:(sprintf("{/Symbol m}: %.2f", $3)) w labels offset 0,1.4 font ",12" notitle,\
    '' using ($2 <= 20 ? 3*$1-xx : 1/0):3:(sprintf("{/Symbol s}: %.1f", $4)) w labels offset 0,0.6 font ",12" notitle,\
    'SporadicSenderSOTAStatistics.csv' using ($2 <= 20 ? 3*$1 : 1/0):3:(ww) lt 2 w boxes title 'SOTA',\
    '' using ($2 <= 20 ? 3*$1 : 1/0):3:(sprintf("{/Symbol m}: %.2f", $3)) w labels offset 0,1.4 font ",12" notitle,\
    '' using ($2 <= 20 ? 3*$1 : 1/0):3:(sprintf("{/Symbol s}: %.1f", $4)) w labels offset 0,0.6 font ",12" notitle,\
    'SporadicSenderSolutionStatistics.csv' using ($2 <= 20 ? 3*$1+xx : 1/0):3:(ww) lt 4 w boxes title 'Our Solution',\
    '' using ($2 <= 20 ? 3*$1+xx : 1/0):3:(sprintf("{/Symbol m}: %.2f", $3)) w labels offset 0,1.4 font ",12" notitle,\
    '' using ($2 <= 20 ? 3*$1+xx : 1/0):3:(sprintf("{/Symbol s}: %.1f", $4)) w labels offset 0,0.6 font ",12" notitle

unset multiplot