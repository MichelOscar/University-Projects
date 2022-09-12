file1="P6-1920-res.dat"
set term png
set output "P6-1920-fig2.png"
set xlabel "ndat"
set ylabel "I(micras)"
set yrange[0:1]
set xrange[0:1000000]

plot file1 index 1 u 1:2:3 w errorbars t "I2(ndat)"

pause -1
