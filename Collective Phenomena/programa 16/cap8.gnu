file1="8.dat"
set term png
set output "s16.png"





plot file1 index 0 u 1:5:12 w errorbars   t "e",\
	
pause -1
