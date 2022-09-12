implicit none
!Se definen todas las variables del programa
real*8 x,y,a,E(100),dist(100),derD(100),exc,pi,n,A1,A2,eps,xarrel,fun,t(80),TH,E0
integer ndat,i,niter
!Se definen las funciones que se usaran en las subrutinas
external D
external f1
external f2
!Se da valor a las constantes
TH=75.3
A1=1.5
A2=5.8
eps=1d-10
ndat=100
a=17.857619
exc=0.967990
pi=acos(-1.0)
E0=pi/4.0

!APARTADO 1
!Se da valor a los elementos del vector E y se calcula la distancia para cada uno.
n=ndat
open(1,file="P3-1920-res.dat")
write(1,*)"Apartado 1: E, distancia, y derivada"
do i=1,ndat
E(i)=2*pi*i/n
call D(a,exc,E(i),dist(i),x,y)
enddo
!Luego se llama la funcion derivada y se calcula la derivada numerica usando los valores calculados en el bucle anterior y se escriben en el fixero.
call derfun(ndat,E,dist,derD)
do i=1,ndat
write(1,100)E(i),dist(i),derD(i)
enddo
write(1,*)
write(1,*)
100 format(f20.10,2x,f20.10,2x,f20.10,2x,f20.10)


!APARTADO 2
!SE USA... 
call bisection(A1,A2,eps,niter,xarrel,f1)
call D(a,exc,xarrel,fun,x,y)
write(1,*)"Apartado 2: E máximo y distancia"
write(1,100)xarrel,fun
write(1,*)
write(1,*)


!APARTADO 3
write(1,*)"Apartado 3: tiempos, E, y posiciones x e y"
eps=1d-12
do i=1,80
t(i)=th*i/80.0
call newtonrap(E0,eps,niter,xarrel,f2,t(i))
call D(a,exc,xarrel,dist(1),x,y)
write(1,200)t(i),xarrel,x,y
enddo
200 format(f8.4,2x,f20.12,2x,f20.12,2x,f20.12)

END

!SUBRUTINA D
subroutine D(a,exc,E,dist,x,y)
real*8 a,exc,E,x,y,pi,dist
x=a*(cos(E)-exc)
y=a*sqrt(1-exc**2)*sin(E)
dist=sqrt(x**2+y**2)
return
END

!SUBRUTINA F1(E)
subroutine f1(E,fun,df)
real*8 E,exc,fun,df
exc=1d-10
fun=sin(2*E)*(1-exc**2)-(cos(E)*(2-exc**2)-exc)*sin(E)
return
END



!SUBRUTINA F2(t)
subroutine f2(E,fun,df,t)
real*8 E,fun,df,t,exc,th,pi
pi=acos(-1.0)
TH=75.3
fun=2*pi*t/th-E-exc*sin(E)
df=-1-exc*cos(E)
return
END

!SUBRUTINA DERIVADA
subroutine derfun(ndat,x,f,df)
integer ndat,i
real*8 x(ndat),f(ndat),df(ndat),n,pi
n=ndat
pi=acos(-1.0)
df(1)=(f(2)-f(1))/(x(2)-x(1))
df(ndat)=(f(ndat)-f(ndat-1))/(x(2)-x(1))
do i=2,ndat-1
df(i)=(f(i+1)-f(i-1))/(x(i+1)-x(i-1))
enddo
return
END


!SUBRUTINA BISECCIÓ
subroutine Bisection(A,B,eps,niter,xarrel,fun)
real*8 A,B,C,eps,xarrel,fu,dfu,fa,fb,fc
integer niter,i
!Se calcula en número de iteraciones que serán necesarias.
niter= abs(int(log((B-A)/eps)/log(2.0)))+1
!Se verifica que la función cambia de signo entre los extremos dados.
call fun(A,fa,dfu)
call fun(B,fb,dfu)
if (fa*fb.lt.0.0) then
!Se coje el punto medio y se mira en què sentido hay un cambio de signo, y se reasignan los valores de A o B según el caso
	do i=1,niter
 	C=(A+B)/2.0
	call fun(A,fa,dfu)
	call fun(B,fb,dfu)
	call fun(C,fc,dfu)
	if (fa*fc.lt.0.0) then
		B=C
	else 
		A=C
	endif
	enddo
	xarrel=C
	return
	
else
	print*,"La funcion no cambia de signo en el intervalo dado"
	return
endif
END



!SUBRUTINA NEWTON-RAPSON
!Esta subrutina realiza el proceso de newton rapson hasta que el punto encontrado tenga la precisión deseada. Hace una recta tangente desde x0 para encontrar el siguiente punto, redefine las variables y repite.
subroutine NewtonRap(x0,eps,niter,xarrel,fun,t)
real*8 x0,x1,eps,xarrel,fu,dfu,t
integer niter,i
i=0
niter=0
fu=1
dfu=1
do while (abs(fu/dfu).gt.eps)
call fun(x0,fu,dfu,t)
x1=x0-fu/dfu
x0=x1

!Aquí se cuentan las iteraciones y si superan un cierto número significa que el método no converge para el punto dado.
niter=niter+1
i=i+1
if (i.eq.500) then
print*,"no se puede encontrar raiz"
return
endif
enddo
xarrel=x0
return
END
