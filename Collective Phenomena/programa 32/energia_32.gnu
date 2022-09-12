file1="32.dat"
set term png
set output "energia_32.png"

set title "Energia per partícula"
set xlabel "Temperatura reduïda T"
set ylabel "Energia per partícula e=E/N"
set xrange[0:4]
set yrange[-2:0]



plot file1 index 0 u 1:2:9 w errorbars lc 2  t "<e>",\
	
pause -1
