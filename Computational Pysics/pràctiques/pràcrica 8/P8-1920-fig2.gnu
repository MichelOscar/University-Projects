file1="P8-1920-res.dat"
set term png
set output "P8-1920-fig2.png"
set xlabel "npas"
set ylabel "E"
set xrange[0:8]
set yrange[-19:-5]

plot file1 index 4 u 1:2 t"1",file1 index 6 u 1:2 t"2",file1 index 8 u 1:2 t"3",file1 
pause -1
