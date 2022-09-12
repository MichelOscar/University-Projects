file1="8.dat"
set term png
set output "s8.png"


plot file1 index 0 u 1:5:12 w errorbars   t "s8"
pause -1
