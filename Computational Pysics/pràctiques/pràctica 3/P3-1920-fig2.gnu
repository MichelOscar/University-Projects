set xzeroaxis
set yzeroaxis
set xlabel "x(E)"
set ylabel "y(E)"
set xrange[-40:5]
set yrange[-6:6]

set term png
set output "P3-1920-fig2.png"

plot "P3-1920-res.dat"index 2 u 3:4 t"x(y)" 


pause -1
