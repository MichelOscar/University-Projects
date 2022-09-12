file1="32.dat"
set term png
set output "capacitat_32.png"

set title "Capacitat calorífica"
set xlabel "Temperatura reduïda T"
set ylabel "Capacitat calorífica c_{v}=C_{v}/K_{B}N"
set xrange[0:4]
set yrange[0:2.25]

x0=NaN
y0=NaN


plot file1 index 0 u 1:(dx=$2-x0,x0=$2,dy=$1-y0,y0=$1,dx/dy) with lines lw 4 lc rgb "red" t"d<e>/dT"\
,file1 index 0 u 1:4:11 w errorbars linewidth 1 lc rgb "blue"  pointtype 2  t "C_{v}"

	


	
pause -1
