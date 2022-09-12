file1="P5-1920-res.dat"
set term png
set output "P5-1920-fig1.png"
f(x)=(sin(x/4))**2/(4*pi)
set xlabel "x[nm]"
set ylabel "p(x)"
set yrange[0:0.2]
set xrange[-4*pi:4*pi]

plot f(x), file1 u 1:2:4 w yerrorbars t"Montecarlo","" u 1:2 w histeps t"PDF"

pause -1
