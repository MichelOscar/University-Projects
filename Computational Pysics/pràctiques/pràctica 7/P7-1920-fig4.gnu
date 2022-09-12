file1="P7-1920-res.dat"
set term png
set output "P7-1920-fig4.png"
set xlabel "t(s)"
set ylabel "E(J)"
set xrange[0:15]
set yrange[0:30]

plot file1 index 4 u 1:4 w l t"euler_cin",file1 index 4 u 1:6 w l t"euler_pot",file1 index 5 u 1:4 w l t"corrector_cin",file1 index 5 u 1:6 w l t"correc_pot"
pause -1
