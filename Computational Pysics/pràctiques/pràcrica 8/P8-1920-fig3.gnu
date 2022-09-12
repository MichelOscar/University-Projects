file1="P8-1920-res.dat"
set term png
set output "P8-1920-fig3.png"
set xlabel "t"
set ylabel "E"
set xrange[-4:4]
set yrange[-1:1]

plot file1 index 5 u 1:2 w l t"E1",file1 index 7 u 1:2 w l t"E2",file1 index 9 u 1:2 w l t"E3"
pause -1
