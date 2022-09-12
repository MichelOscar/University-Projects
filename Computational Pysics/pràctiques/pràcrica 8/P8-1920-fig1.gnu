file1="P8-1920-res.dat"
set term png
set output "P8-1920-fig1.png"
set xlabel "t"
set ylabel "E"
set xrange[-4:0.5714]
set yrange[0:0.0005]

plot file1 index 0 u 1:2 w l t"E1",file1 index 1 u 1:2 w l t"E2",file1 index 2 u 1:2 w l t"E3",file1 index 3 u 1:2 w l t"E4"
pause -1
