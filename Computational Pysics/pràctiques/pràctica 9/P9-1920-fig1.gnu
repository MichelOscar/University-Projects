file1="P9-1920-res.dat"
set term png
set output "P9-1920-fig1.png"
set title "Ti=15"
set xlabel "niter"
set ylabel "T(ºC)"
set xrange[0:10000]
set yrange[0:210]

plot file1 index 0 u 1:2,file1 index 3 u 1:2
pause -1
