IMPLICIT NONE
!Primero se definen todas las variables del programa y se asignan valores a las constantes
real*8 x,f,a,b,x1,x2,AT,AS,h,Area,pi,AM
integer i,m
external YKohoutek
pi=acos(-1.0)
a=508.663
b=429.074
Area=a*b*(3*sqrt(3.0)+2*pi)/24.0
open(1,file="P4-1920-b-res.dat")

!Apartados a y b:
write(1,*)"Columnas: h,AT,AS,error trapecios,error simpson"
!Para cada valor de m se calcula h y se llama a las subrutinas que calculan la integral.
do m=2,20
x1=-4*a
x2=-7*a/2.0
h=(x2-x1)/(2**m)
call trapezoids(x1,x2,m,YKohoutek,AT)
x1=-4*a
x2=-7*a/2.0
call simpson(x1,x2,m,YKohoutek,AS)
!Luego se escriben los resultados en un fixero junto a los errorres.
write(1,100)h,AT,AS,abs(area-AT),abs(area-AS)
enddo
write(1,*)
write(1,*)

!APARTADO c:
write(1,*)"Apartado c: hm,Am,error"
!Se llama a la subrutina trapezoids para los distintos valores de m y m+1
do m=2,19
x1=-4*a
x2=-7*a/2.0
h=(x2-x1)/(2**m)
call trapezoids(x1,x2,m,YKohoutek,AT)
x1=-4*a
x2=-7*a/2.0
!Se usa la variable AS para calcular T(m+1)
call trapezoids(x1,x2,m+1,YKohoutek,AS)
AM=(4*AS-AT)/3.0
!Se escriben los resultados y el error en el mismo fixero
write(1,200)h,AM,abs(area-AM)
enddo
 
 close(1)
100 format(f22.14,2x,f22.14,2x,f22.14,2x,f22.14,2x,f22.14)
200 format(f22.14,2x,f22.14,2x,f22.14)
END

!Esta subrutina calcula la funcion de x
subroutine YKohoutek(x,f)
real*8 x,f,a,b
a=508.663
b=429.074
f=b*sqrt(1-((x+4*a)/a)**2)
return
END

!TRAPECIOS
!Esta subrutina calcula primero el intervalo h en funcion del numero de pasos y
!evalua la funcion en todos los puntos x y x+h para aplicar la formula de los trapecios y luego los suma.
subroutine trapezoids(x1,x2,k,funci,integral)
real*8 x1,x2,integral,h,n,fx1,fx2,fx3,f
integer k
integral=0
n=2**k
h=(x2-x1)/(n)
do i=1,(2**k)
call funci(x1,f)
fx1=f
call funci(x1+h,f)
fx2=f
integral=integral+h*(fx2+fx1)/2.0
x1=x1+h
enddo
return
END


!SIMPSON
!Similar a la subrutina trapecios pero usando 3 puntos para cada paso y aplicando la fórmula de simpson
subroutine simpson(x1,x2,k,funci,integral)
real*8 x1,x2,integral,h,n,fx1,fx2,fx3,f
integer k
integral=0
n=2**k
h=(x2-x1)/(n)
!Al coger los puntos de 3 en 3 se hace la mitad de iteraciones en el bucle.
do i=1,(2**(k-1))
call funci(x1,f)
fx1=f
call funci(x1+h,f)
fx2=f
call funci(x1+2*h,f)
fx3=f
integral=integral+h*(fx1+4*fx2+fx3)/3.0
x1=x1+2*h
enddo
return
END
