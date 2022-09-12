set xzeroaxis
set yzeroaxis
set xlabel "E"
set ylabel "D"
set xrange[0:2*pi]
set yrange[-20:40]

set term png
set output "P3-1920-fig1.png"

plot "P3-1920-res.dat"index 0 u 1:2 t"D" ,"P3-1920-res.dat" index 0 u 1:3 t"Derivada"



pause -1
