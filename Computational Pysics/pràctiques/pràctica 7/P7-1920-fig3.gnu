file1="P7-1920-res.dat"
set term png
set output "P7-1920-fig3.png"
set xlabel "phi(rad)"
set ylabel "p(rad/s)"
set xrange[-30:4]
set yrange[-10:10]

plot file1 index 2 u 2:3 w l t"euler",file1 index 3 u 2:3 w l t"corrector"
pause -1
