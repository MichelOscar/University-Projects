file1="t1.dat"
file2="t229.dat"
file3="t5.dat"

set term png
set output "configuration.png"

L=64
symbsize=0.17
set size square


set multiplot layout 1,3 title 
set bmargin 5
set tmargin 5
#
set title "T=1,00"
unset key
set tics font",10"
set xlabel "L"
set xrange [0.5:L+0.5]
set yrange [0.5:L+0.5]

plot file1 using 1:2 with points pt 5 ps symbsize lc rgb "blue"
#
set title "T=2,29"
unset key
set tics font",10"
set xlabel "L"
set xrange [0.5:L+0.5]
set yrange [0.5:L+0.5]

plot file2 using 1:2 with points pt 5 ps symbsize lc rgb "blue"
#
set title "T=10,00"
unset key
set tics font",10"
set xlabel "L"
set xrange [0.5:L+0.5]
set yrange [0.5:L+0.5]

plot file3 using 1:2 with points pt 5 ps symbsize lc rgb "blue"
#
unset multiplot

pause -1


