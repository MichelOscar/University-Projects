file1="8.dat"
file2="16.dat"
file3="32.dat"
file4="64bis.dat"
set term png
set output "c.png"
set xlabel "Temperatura reduïda T"
set ylabel "Capacitat calorífica c_{v}=C_{v}/K_{B}N"
set xrange[0:4]
set yrange[0:2.5]



plot file1 index 0 u 1:4:11 w errorbars ps 0.5 t "L=8",file2 index 0 u 1:4:11 w errorbars ps 0.5 t "L=16",\
	file3 index 0 u 1:4:11 w errorbars ps 0.5 t "L=32",file4 index 0 u 1:4:11 w errorbars ps 0.5 t "L=64"	
	
pause -1
