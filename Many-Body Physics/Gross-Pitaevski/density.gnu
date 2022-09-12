file1="fort.15"
file2="fort.16"
file3="fort.17"
file4="fort.18"
set term png
set output "density1000.png"
set title "N=1000"

set xlabel "r"
set ylabel "{/Symbol r}(r)"
set xrange[0:7]
set yrange[0:0.7]


plot file4 i 0 u 1:2 w l lc rgb "blue" t  "Gross-Pitaevskii"\
,file1 i 0 u 1:2 w l lc rgb "green" t "Thomas-Fermi" 


pause -1

