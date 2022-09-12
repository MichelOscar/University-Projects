set xzeroaxis
set yzeroaxis
set xlabel "x1[cm]"
set ylabel "x2,6[cm]"
set xrange[0:45]
set yrange[0:45]

set term png
set output "P2-19-20-fig2-b.png"

plot "P2-19-20-res1-b.dat" u 2:3 t"pistó 2" ,"P2-19-20-res1-b.dat" u 2:6 t"pistó 5"



pause -1
