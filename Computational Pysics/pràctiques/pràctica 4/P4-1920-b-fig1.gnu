set xzeroaxis
set yzeroaxis
set xlabel "h(1E6 km)"
set ylabel "error(1E6 km)"
set logscale y
set logscale x
set xrange[0.0002:65]
set yrange[0.0001:170]

set term png
set output "P4-1929-b-fig1.png"

f(x)=x**3/12.0
g(x)=x**5/90.0

plot f(x) t"e teorico trapecios",g(x) t"e teorico simpson","P4-1920-b-res.dat" index 0 u 1:4 t"e trapecios","P4-1920-b-res.dat" index 0 u 1:5 t"e simpson"


pause -1
