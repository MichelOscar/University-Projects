file1="32.dat"
set term png
set output "susceptibilitat_32.png"

set title "Susceptibilitat "
set xlabel "Temperatura reduïda T"
set ylabel "susceptibilitat {/Symbol c}"
set xrange[0:4]
set yrange[0:25]



plot file1 index 0 u 1:5:12 w errorbars lc rgb "green"  t "{/Symbol c}",\
	
pause -1
