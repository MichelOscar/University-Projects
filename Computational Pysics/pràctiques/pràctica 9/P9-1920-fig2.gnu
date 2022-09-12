file1="P9-1920-res.dat"
set term png
set output "P9-1920-fig2.png"
set title "Ti=220"
set xlabel "niter"
set ylabel "T(ºC)"
set xrange[0:10000]
set yrange[0:250]

plot file1 index 1 u 1:2,file1 index 4 u 1:2
pause -1
