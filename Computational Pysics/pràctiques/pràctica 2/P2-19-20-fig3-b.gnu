set xzeroaxis
set yzeroaxis
set xlabel "t[s]"
set ylabel "x[cm]"
set xrange[0:3]
set yrange[14:32]
set term png
set output "P2-19-20-fig3-b.png"

plot "P2-19-20-res1-b.dat" u 1:4 t"dades","P2-19-20-res2-b.dat" u 1:2 t"interpol1" w l, "P2-19-20-res2-b.dat" u 1:3 t"interpol0" w l
pause -1
