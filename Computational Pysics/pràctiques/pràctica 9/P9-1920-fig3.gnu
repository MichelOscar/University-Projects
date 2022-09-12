file1="P9-1920-res.dat"
set term png
set output "P9-1920-fig3.png"
set title "Ti=1280"
set xlabel "niter"
set ylabel "T(ºC)"
set xrange[0:10000]
set yrange[0:1300]

plot file1 index 2 u 1:2,file1 index 5 u 1:2
pause -1
