set xzeroaxis
set yzeroaxis
set xlabel "t[s]"
set ylabel "x[cm]"
set xrange[0:5.01]
set yrange[0:45]

set term png
set output "P2-19-20-fig1-b.png"

plot "P2-19-20-res1-b.dat" u 1:2 t"pistó 1","P2-19-20-res1-b.dat" u 1:3 t"pistó 2","P2-19-20-res1-b.dat" u 1:7 t"pistó 6"



pause -1

