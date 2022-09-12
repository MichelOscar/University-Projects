file1="8.dat"
set term png
set output "cap8.png"



x0=NaN
y0=NaN

plot file1 index 0 u 1:4:11 w l   t "C_v",\
	file1 index 0 u 1:(dx=$2-x0,x0=$2,dy=$1-y0,y0=$1,dx/dy) with lines t"d<e>/dT"
pause -1
