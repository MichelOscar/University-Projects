file1="P7-1920-res.dat"
set term png
set output "P7-1920-fig2.png"
set xlabel "t(s)"
set ylabel "p(rad/s)"
set xrange[0:15]
set yrange[-50:10]

plot file1 index 2 u 1:2 w l t"euler",file1 index 3 u 1:2 w l t"corrector"
pause -1
