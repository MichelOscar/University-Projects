file1="8.dat"
set term png
set output "mag8.png"

set xrange[0:4]
set yrange[0:1.2]


plot file1 index 0 u 1:3:10 w errorbars   t "<|m|>",\
	file1 index 0 u 1:(sqrt($8)) w l t"sqrt(<m²>)"
pause -1
