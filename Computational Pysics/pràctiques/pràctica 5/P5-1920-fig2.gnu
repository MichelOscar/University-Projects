file1="P5-1920-res2.dat"
set term png
set output "P5-1920-fig2.png"
f(x)=6/(pi*(2*pi**2-3)*3)*(x/3)**2*(sin(x/3))**2
set xlabel "x[micras]"
set ylabel "p(x)"
set yrange[0:0.2]
set xrange[-3*pi:3*pi]

plot f(x), file1 u 1:2:4 w yerrorbars t"Montecarlo","" u 1:2 w histeps t"PDF"

pause -1
