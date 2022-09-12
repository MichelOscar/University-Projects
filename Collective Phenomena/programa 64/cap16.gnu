file1="8.dat"
set term png
set output "s64.png"

set yrange[0:3]



plot file1 index 0 u 1:5:12 w errorbars  t "m",\
	
pause -1
