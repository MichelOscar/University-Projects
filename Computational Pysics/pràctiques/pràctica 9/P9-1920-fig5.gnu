set xlabel "x(cm)"
set ylabel "y(cm)"
set zlabel "T(ºC)"
set term png
set output "P9-1920-fig5.png"
plot "P9-1920-res.dat" index 7 with image 
pause -1
