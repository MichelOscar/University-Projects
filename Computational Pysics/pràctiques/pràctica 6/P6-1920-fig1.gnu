file1="P6-1920-res.dat"
set term png
set output "P6-1920-fig1.png"
set xlabel "ndat"
set ylabel "I(micras)"
set yrange[0:2.5]
set xrange[0:45000]

plot file1 index 0 u 1:2:3 w errorbars t "u(x)",file1 index 0 u 1:4:5 w errorbars t "dx" 

pause -1
