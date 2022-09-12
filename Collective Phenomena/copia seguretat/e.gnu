file1="8.dat"
file2="16.dat"
file3="32.dat"
file4="64.dat"
set term png
set output "e.png"

set xlabel "Temperatura reduïda T"
set ylabel "Energia per partícula e=E/N"

set xrange[0:4]
set yrange[-2:0]


plot file1 index 0 u 1:2:9 w errorbars pointsize 0.5  t "L=8",file2 index 0 u 1:2:9 w errorbars pointsize 0.5  t "L=16",\
	file3 index 0 u 1:2:9 w errorbars pointsize 0.5  t "L=32",file4 index 0 u 1:2:9 w errorbars pointsize 0.5  t "L=64"	
	
pause -1
