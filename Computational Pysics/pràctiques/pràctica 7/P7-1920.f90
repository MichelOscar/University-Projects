IMPLICIT NONE
!Se definen todas las variables del programa.
real*8 phi,p,t,l,g,m,per,wn,n,h,phi0,po,to,tf,pi,phi1,p1,t1,ecin,epot
!El vactor dat contiene los valores de ndat del apartado e
integer i,u,ndat,dat(4)
external pen, pen_aprox
pi=acos(-1.0)
g=10.44
m=0.98
l=1.07
wn=sqrt(g/l)
per=2*pi/wn
dat(1)=300
dat(2)=550
dat(3)=1000
dat(4)=20000

!APARTADO A
!este print sirbe para seber en que indice del fixero de datos esta cada calculo
print*,"a euler i0"
!Se definen las condiciones iniciales en cada caso
ndat=1500
to=0
tf=7*per
n=ndat
h=(tf-to)/n
phi0=0.025
po=0
open(1,file="P7-1920-res.dat")
write(1,100)to,phi0,po
!Para cada tiempo se hace un paso de euler, se escriben los resultados y se redefinen las condiciones iniciales.
do i=1,ndat
call euler(to,phi0,po,h,t,phi,p,pen_aprox)
write(1,100)t,phi,p
phi0=phi
po=p
to=t
enddo
write(1,*)
write(1,*)

!Predictor
print*,"a predictor i1"
ndat=1500
to=0
tf=7*per
n=ndat
h=(tf-to)/n
phi0=0.025
po=0
write(1,100)to,phi0,po
do i=1,ndat
!Primero se hace un paso de euler para obtener los valores n+1 predichos
call euler(to,phi0,po,h,t,phi,p,pen_aprox)
!Luego se usan esos para calcular los valores corregidos con un paso predictor-corrector.
call predic(to,phi0,po,t,phi,p,h,phi1,p1,t1,pen_aprox)
write(1,100)t1,phi1,p1
phi0=phi1
po=p1
to=t1
enddo
write(1,*)
write(1,*)

!APARTADO B
!Igual al apartado A pero usando la ecuacion del péndulo para cualquier valor de phi.
print*,"b euler i2"
ndat=1500
to=0
tf=7*per
n=ndat
h=(tf-to)/n
phi0=pi-0.15
po=0
open(1,file="P7-1920-res.dat")
write(1,100)to,phi0,po
do i=1,ndat
call euler(to,phi0,po,h,t,phi,p,pen)
write(1,100)t,phi,p
phi0=phi
po=p
to=t
enddo
write(1,*)
write(1,*)

!Predictor
print*,"b predictor i3"
ndat=1500
to=0
tf=7*per
n=ndat
h=(tf-to)/n
phi0=pi-0.15
po=0
write(1,100)to,phi0,po
do i=1,ndat
call euler(to,phi0,po,h,t,phi,p,pen)
call predic(to,phi0,po,t,phi,p,h,phi1,p1,t1,pen)
write(1,100)t1,phi1,p1
phi0=phi1
po=p1
to=t1
enddo
write(1,*)
write(1,*)

!APARTAT C
!Se ejecutan los métodos de euler y predictor-corrector y además se escribe las energias cinética,potencial y total de cada valor.
print*,"c euler i4"
ndat=1500
n=ndat
to=0
phi0=pi-0.025
po=0.12
h=(tf-to)/n
write(1,200)to,phi0,po,ecin(po),epot(phi0),(ecin(po)+epot(phi0))
do i=1,ndat
call euler(to,phi0,po,h,t,phi,p,pen)
write(1,200)t,phi,p,ecin(p),epot(phi),(ecin(p)+epot(phi))
phi0=phi
po=p
to=t
enddo
write(1,*)
write(1,*)

print*,"c predic i5"
ndat=1500
n=ndat
to=0
phi0=pi-0.025
po=0.12
h=(tf-to)/n
write(1,200)to,phi0,po,ecin(po),epot(phi0),(ecin(po)+epot(phi0))
do i=1,ndat
call euler(to,phi0,po,h,t,phi,p,pen)
call predic(to,phi0,po,t,phi,p,h,phi1,p1,t1,pen)
write(1,200)t1,phi1,p1,ecin(p1),epot(phi1),(ecin(p1)+epot(phi1))
phi0=phi1
po=p1
to=t1
enddo
write(1,*)
write(1,*)

!APARTADO D
print*,"D predictor + i6"
ndat=6000
to=0
tf=15*per
n=ndat
h=(tf-to)/n
phi0=0
po=2*sqrt(g/l)+0.05
write(1,100)to,phi0,po
do i=1,ndat
call euler(to,phi0,po,h,t,phi,p,pen)
call predic(to,phi0,po,t,phi,p,h,phi1,p1,t1,pen)
write(1,100)t1,phi1,p1
phi0=phi1
po=p1
to=t1
enddo
write(1,*)
write(1,*)

print*,"D predictor - i7"
ndat=6000
to=0
tf=15*per
n=ndat
h=(tf-to)/n
phi0=0
po=2*sqrt(g/l)-0.05
write(1,100)to,phi0,po
do i=1,ndat
call euler(to,phi0,po,h,t,phi,p,pen)
call predic(to,phi0,po,t,phi,p,h,phi1,p1,t1,pen)
write(1,100)t1,phi1,p1
phi0=phi1
po=p1
to=t1
enddo
write(1,*)
write(1,*)

!APARTAT E
!Se hace el método para cada valor de ndat y se calcula la energia
print*,"e millor 300 i8"
print*,"e millor 550 i9"
print*,"e millor 100 i10"
print*,"e millor 20000 i11"
tf=11*per
do u=1,4
ndat=dat(u)
to=0
n=ndat
h=(tf-to)/n
phi0=2.87
po=0
write(1,300)to,phi0,po,(ecin(po)+epot(phi0))
do i=1,ndat
call euler(to,phi0,po,h,t,phi,p,pen)
call predic(to,phi0,po,t,phi,p,h,phi1,p1,t1,pen)
write(1,300)t1,phi1,p1,(ecin(p1)+epot(phi1))
phi0=phi1
po=p1
to=t1
enddo
write(1,*)
write(1,*)
enddo

100 format(f12.6,2x,f12.6,2x,f12.6)
200 format(f12.6,2x,f12.6,2x,f12.6,f12.6,2x,f12.6,2x,f12.6)
300 format(f12.6,2x,f12.6,2x,f12.6,f12.6,2x)
END

!Las dos primeras funciones calculan la energia cinetica y potencial
real*8 function ecin(p)
real*8 p,m,l,g
g=10.44
m=0.98
l=1.07
ecine=0.5*m*p**2*l**2
end

!Estas subrutinas calculan la función del péndulo
real*8 function epot(phi)
real*8 phi,m,l,g
g=10.44
m=0.98
l=1.07
epot=-m*g*l*cos(phi)
end

subroutine pen(x,y,p,f)
real*8 x,y,p,f,g,l
g=10.44
m=0.98
l=1.07
f=-g*sin(y)/l
return
END

subroutine pen_aprox(x,y,p,f)
real*8 x,y,p,f,g,l
g=10.44
m=0.98
l=1.07
f=-g*y/l
return
END


subroutine euler(xo,yo,po,h,x,y,p,fun)
real*8 xo,yo,po,x,h,y,p,f
call fun(xo,yo,po,f)
!Para los valores dados se aplica elalgoritmo de euler
p=po+h*f
y=yo+h*po
x=xo+h
return
END


subroutine predic(xo,yo,po,x,y,p,h,y1,p1,x1,fun)
real*8 xo,yo,po,x,y,p,h,y1,p1,x1,f1,f2
!Se reciben los valores n y n+1 dados por euler y se evalua la funcion en los 2
!Luego se aplica el algoritmo predictor-corrector.
call fun(xo,yo,po,f1)
call fun(x,y,p,f2)
p1=po+h*(f1+f2)/2.0
y1=yo+h*(po+p)/2.0
x1=xo+h
return
END


