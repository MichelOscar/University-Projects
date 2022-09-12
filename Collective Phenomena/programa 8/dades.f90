implicit none
real*8 x(12)
integer i

open(1,file="8.dat")
open(2,file="dades.csv")

do i=1,201
read(1,*)x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),x(11),x(12)
write(2,*)x(1),";",x(2),";",x(3),";",x(4),";",x(5),";",x(6),";",x(7),";",x(8),";",x(9),";",x(10),";",x(11),";",x(12)
enddo


close(1)
close(2)

end
