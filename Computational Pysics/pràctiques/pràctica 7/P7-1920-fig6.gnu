file1="P7-1920-res.dat"
set term png
set output "P7-1920-fig6.png"
set xlabel "t(s)"
set ylabel "E(J)"
set xrange[0:22]
set yrange[10.3:11.8]

plot file1 index 8 u 1:4 w l t"300",file1 index 9 u 1:4 w l t"550",file1 index 10 u 1:4 w l t"1000",file1 index 11 u 1:4 w l t"20000"
pause -1
