file1="P6-1920-res.dat"
set term png
set output "P6-1920-fig3.png"
set xlabel "ndat"
set ylabel "I(micras)"
set yrange[2.5:3]
set xrange[0:250000]

plot file1 index 2 u 1:2:3 w errorbars t "I2(ndat)"

pause -1
