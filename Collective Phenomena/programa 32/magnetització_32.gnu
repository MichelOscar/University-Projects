file1="32.dat"
set term png
set output "magnetització_32.png"

set title "Magnetització per partícula"
set xlabel "Temperatura reduïda T"
set ylabel "Magnetització per partícula M/N"
set xrange[0:4]
set yrange[0:1.2]



plot file1 index 0 u 1:3:10 w errorbars t "<|m|>",\
file1 index 0 u 1:(sqrt($8)) w l linewidth 2 t"sqrt(<m²>)"

	
pause -1
