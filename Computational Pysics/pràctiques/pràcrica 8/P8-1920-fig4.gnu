file1="P8-1920-res.dat"
set term png
set output "P8-1920-fig4.png"
set xlabel "t"
set ylabel "E"
set xrange[-4:4]
set yrange[0:1]

plot file1 index 10 u 1:2 w l t"b=0",file1 index 11 u 1:2 w l t"b=1",file1 index 12 u 1:2 w l t"b=5"
pause -1
