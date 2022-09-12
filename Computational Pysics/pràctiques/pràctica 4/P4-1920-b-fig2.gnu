set xzeroaxis
set yzeroaxis
set xlabel "hm(1E6 km)"
set ylabel "error(1E6 km)"
set logscale y
set logscale x
set xrange[0.0004:65]
set yrange[0.0001:0.06]

set term png
set output "P4-1929-b-fig2.png"

f(x)=x**3/12.0


plot f(x) t"e teorico trapecios","P4-1920-b-res.dat" index 1 u 1:3 t"error numerico"


pause -1
