file1="P7-1920-res.dat"
set term png
set output "P7-1920-fig5.png"
set xlabel "phi(rad)"
set ylabel "p(rad/s)"
set xrange[-5:30]
set yrange[-10:10]

plot file1 index 6 u 2:3 w l t"euler",file1 index 7 u 2:3 w l t"corrector"
pause -1
