file1="8.dat"
file2="16.dat"
file3="32.dat"
file4="64.dat"
set term png
set output "s.png"

set xlabel "Temperatura reduïda T"
set ylabel "susceptibilitat {/Symbol c}"
set xrange[0:4]
set yrange[0:75]


plot file1 index 0 u 1:5:12 w errorbars  t "L=8",file2 index 0 u 1:5:12 w errorbars  t "L=16",\
	file3 index 0 u 1:5:12 w errorbars  t "L=32",file4 index 0 u 1:5:12 w errorbars  t "L=64"	
	
pause -1
