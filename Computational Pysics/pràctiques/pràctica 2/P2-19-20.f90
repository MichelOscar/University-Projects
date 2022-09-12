!El programa calcula la posicion de 6 pistones para diferentes valores de tiempo
!Luego lee los datos de uno de los pistones y hace una interpolacion lineal y una
!de orden 0

implicit none
!se definen las variables reales, las 6 primeras son las variables para
!calcular las posiciones, el vector x guarda los valores de los pistones. 
!XI y TI los datos deltercer piston y x1 y x0 se usan para la interpolacion.

real*8 ri,l,w,phi,pi,t,x(6),i,XI(51),TI(51),x1,x0
integer k
common/posis/XI,TI
pi=acos(-1.0)
w=5
l=22.5

!APARTADO 3
!Se abre un fichero y para cada valor de tiempo se llama la subrutina para calcular la
!posicion de los pistones y luego se escriben los valores en el fichero
open(1,file="P2-19-20-res1-b.dat")
do k=0,50
t=k*0.1
call posiT1(w,l,t,x)
write(1,100)t,x(1),x(2),x(3),x(4),x(5),x(6)
enddo
100 format(f4.2,x,f9.5,x,f9.5,x,f9.5,x,f9.5,x,f9.5,x,f9.5)
 close(1)

!APARTADO 6
!Aqui se lee las primeras 4 columnas del fichero y se guardan la primera y cuarta
!en dos vectores
open(1,file="P2-19-20-res1-b.dat")
do k=1,51
read(1,*)t,x(1),x(2),x(3)
TI(k)=t
XI(k)=x(3)
enddo
 close(1)

!APARTADO 7
!Para distintos valores de tiempo se llama las subrutinas interpol y se guardan los 
!valores de la interpolacion en otro fichero.
open(2,file="P2-19-20-res2-b.dat")
do k=0,1500
t=k*3/1500.0
call interpol1(t,x1)
call interpol0(t,x0)
write(2,200)t,x1,x0
enddo
200 format(f6.4,2x,f9.5,2x,f9.5)
 close(2)



END


!Las funciones ri y phi calculan el radio y la fase inicial de los pistones segun
!la formula dada.

! FUNCION RADIO
real*8 function ri(l,i)
real*8 l,i
ri=L/i-0.01
return
END

!FUNCION PHI
real*8 function phi(i)
real*8 i,pi
pi=acos(-1.0)
phi= i*pi/6.0
END

!SUBRUTINA POSICION
!Para cada piston se calcula la posicion usando las dos funciones anteriores.
subroutine posiT1(w,l,t,x)
real*8 w,l,t,x(6),i,ri,phi,pi
integer k
pi=acos(-1.0)
do k=1,6
i=k
x(k)=ri(l,i)*cos(w*t+phi(i))+sqrt(l**2-(ri(l,i)*sin(w*t+phi(i)))**2)
enddo
return
END

!INTERPOLACION LINEAL
!En esta subrutina primero se busca el valor de tiempo del vector TI por debajo del
!tiempo dado. Luego se evalua el tiempo en una recta que une los puntos superior
!e inferior del tercer piston. 
subroutine interpol1(tin,xout)
real*8 tin,xout,XI,TI
integer k
common/posis/XI(51),TI(51)
k=1
do while (.not.(tin-TI(k)).lt.0.0)
k=k+1
enddo
xout=XI(k-1)+(tin-TI(k-1))*(XI(k)-XI(k-1))/(TI(k)-TI(k-1))
return
END

!INTERPOLACION ORDEN 0
!Al igual que la subrutina anterior se busca el tiempo de TI más cercano y se le 
!asigna el valor medio de las posiciones superior e inferior.
subroutine interpol0(tin,xout)
real*8 tin,xout,XI,TI
integer k
common/posis/XI(51),TI(51)
k=1
do while (.not.(tin-TI(k)).lt.0.0)
k=k+1
enddo
xout=(XI(k)+XI(k-1))/2.0
return
END
