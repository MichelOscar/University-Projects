file1="P7-1920-res.dat"
set term png
set output "P7-1920-fig1.png"
set xlabel "t(s)"
set ylabel "p(rad/s)"
set xrange[0:14]
set yrange[-0.1:0.1]

plot file1 index 0 u 1:2 w l t"euler",file1 index 1 u 1:2 w l t"corrector"
pause -1
