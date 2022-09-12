IMPLICIT NONE
!A la hora de comentar he tocado algo del programa y no hace bien las figuras pero enteoria el procedimiento esta bien
!Se definen todas las variables del programa
integer i,ndat,neq,j,iter,extrem
real*8 xo,yo(2),xf,y(2),h,vo,a,delta,L,E,EI(6),n,E1,E2,E3,p1,p2,p3,error,norma,b,bvalors(3)
real*8,allocatable :: plot(:)
external derivada
common/energia/E,b
!Se da valor a las constantes y a las energias dadas.
error=1d-6
neq=2
vo=-20
a=2
delta=0.05
l=8
EI(1)=-21
EI(2)=-20.5
EI(3)=-14
EI(4)=-13
EI(5)=-8
EI(6)=-7.5
ndat=400
allocate(plot(ndat))
n=ndat
xf=l/2.0
open(1,file="P8-1920-res.dat")
open(2,file="P8-1920-res1.dat")


!APARTAT 1
!Se hace un bucle para los 4 valores de la energia y se usa la subrutina ralston 
!para resolver la ecuación.
b=0
do j=1,4
E=EI(j)
xo=-l/2.0
h=(xf-xo)/n
yo(1)=0
yo(2)=0.000002
write(1,*)xo,yo
do i=1,ndat
call RK3(xo,h,neq,yo,y)
!Despues de cada paso se redefinen las variables y se escriben en el fixero
xo=xo+h
yo=y
write(1,*)xo,yo
enddo
write(1,*)
write(1,*)
enddo

!APARTAT 2
!Se hace un bucle de 3 iteraciones para los 3 pares de energias
do j=1,3
iter=0
E1=EI(2*j-1)
E2=EI(2*j)
p3=1
xo=-l/2.0
yo(1)=0
yo(2)=0.000002
h=(xf-xo)/n
!Se aplica el método de la secante mientras no se cumpla la condicion.
do while(abs(p3).gt.error)
xo=-l/2.0
yo(1)=0
yo(2)=0.000002
E=E1
!Se resuelve la ecuacion para E1 y E2
do i=1,ndat
call RK3(xo,h,neq,yo,y)
xo=xo+h
yo=y
enddo
p1=y(1)
E=E2
xo=-l/2.0
yo(1)=0
yo(2)=0.000002
do i=1,ndat
call RK3(xo,h,neq,yo,y)
xo=xo+h
yo=y
enddo
p2=y(1)
!Se calula E3 y se resuelve la ecuacion otra vez
E3=(E1*P2-E2*P1)/(P2-P1)
E=E3
xo=-l/2.0
yo(1)=0
yo(2)=0.000002
do i=1,ndat
call RK3(xo,h,neq,yo,y)
xo=xo+h
yo=y
enddo
p3=y(1)
iter=iter+1
write(1,*)iter,E3
E1=E2
E2=E3
enddo
print*,
write(1,*)
write(1,*)
enddo
!Una vez encontrado el autovalor se resuelve la ecuacion guardando todos los valores de la funcion.
E=E2
xo=-l/2.0
yo(1)=0
yo(2)=0.000002
plot(1)=yo(1)
do i=1,ndat
call RK3(xo,h,neq,yo,y)
xo=xo+h
plot(i)=y(1)
yo=y
enddo

!Usando los valores anteriores se calcula la norma y se redefinen dividiendolos por la misma.
call trapecis(plot,ndat,h,norma)
print*,"norma=",norma
xo=-l/2.0
do i=1,ndat
plot(i)=plot(i)/sqrt(norma)
write(1,*)xo,plot(i)
xo=xo+h
enddo
write(1,*)
write(1,*)




!APARTAT 3
!(Para este apartado he vuelto a encontrar los autovalores aunque en realidad no era necesario,pero ya no me daba tiempo a cambiarlo)
bvalors(1)=0
bvalors(2)=1
bvalors(3)=5
E1=EI(1)
E2=EI(2)
!Para cada beta se encuentra la energia (que es la misma que la del estado fundamental)
p3=1
do j=1,3
E1=EI(1)
E2=EI(2)
p3=1
b=bvalors(j)
do while(abs(p3).gt.error)
xo=-l/2.0
yo(1)=0
yo(2)=0.000002
E=E1
do i=1,ndat
call RK3(xo,h,neq,yo,y)
xo=xo+h
yo=y
enddo
p1=y(1)
E=E2
xo=-l/2.0
yo(1)=0
yo(2)=0.000002
do i=1,ndat
call RK3(xo,h,neq,yo,y)
xo=xo+h
yo=y
enddo
p2=y(1)
E3=(E1*P2-E2*P1)/(P2-P1)
E=E3
xo=-l/2.0
yo(1)=0
yo(2)=0.000002
do i=1,ndat
call RK3(xo,h,neq,yo,y)
xo=xo+h
yo=y
enddo
p3=y(1)
iter=iter+1
E1=E2
E2=E3
enddo
print*,
write(1,*)
write(1,*)
!Se calcula la norma de la funcion y se escribe en un fixero para representarlo
E=E2
xo=-l/2.0
yo(1)=0
yo(2)=0.000002
plot(1)=yo(1)
do i=1,ndat
call RK3(xo,h,neq,yo,y)
xo=xo+h
plot(i)=y(1)
yo=y
enddo

call trapecis(plot,ndat,h,norma)
print*,"norma=",norma
xo=-l/2.0
do i=1,ndat
plot(i)=plot(i)/sqrt(norma)
write(1,*)xo,plot(i)
xo=xo+h
enddo
write(1,*)
write(1,*)

!La probabilidad se encuentra determinando los indices de la lista de valores que corresponden a los extremos de la integral y se integra la funcion entre esos dos extremos.
xo=-1.3
xf=1.3
extrem=int((l/2.0+xo)/h)
print*,h,extrem
norma=0
do i=extrem,ndat-extrem
norma=norma+h/2.0*((abs(plot(i)))**2+(abs(plot(i+1)))**2)
enddo
write(2,*)b,norma
enddo

END





subroutine derivada(neq,x,yin,yout)
integer neq
real*8 x,yin(neq),yout(neq),V,E,vo,a,delta,b
common/energia/E,b
vo=-20
a=2
delta=0.05
V=vo*sinh(a/delta)/(cosh(a/delta)+cosh(x/delta))+b*x**2
yout(1)=yin(2)
yout(2)=2*(V-E)*yin(1)/7.6199
return
END


subroutine RK3(x,h,neq,yin,yout)
integer neq
real*8 yin(neq),yout(neq),x,h,k1(neq),k2(neq),k3(neq)
call derivada(neq,x,yin,k1)
call derivada(neq,x+h/2.0,yin+h/2.0*k1,k2)
call derivada(neq,x+3*h/4.0,yin+3*h/4.0*k2,k3)
yout=yin+h/9.0*(2*k1+3*k2+4*k3)
return
END

subroutine trapecis(xdat,ndat,h,norm)
integer ndat,i
real*8 xdat(ndat),h,norm
norm=0
do i=1,ndat-1
norm=norm+h/2.0*((abs(xdat(i)))**2+(abs(xdat(i+1)))**2)
enddo
return
END









