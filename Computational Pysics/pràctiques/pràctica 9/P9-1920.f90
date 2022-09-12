IMPLICIT NONE

integer i,j,nx,ny,icontrol,niter,n,k
real*8 lx,ly,h,x,y,r1,r2,r3,w,ti(3),error,dold,dnew
real*8,allocatable :: tnew(:,:)
real*8,allocatable :: told(:,:)
dold=0
niter=10000
icontrol=0
error=1d-2
w=1.45
h=0.25
lx=45.5
ly=35.5
nx=(lx/h)+1
ny=(ly/h)+1

allocate(tnew(nx,ny))
allocate(told(nx,ny))
open(1,file="P9-1920-res.dat")


!Definicion del estado inicial
ti(1)=15
ti(2)=220
ti(3)=1280
do k=1,3
do i=1,nx
tnew(i,1)=17.0
tnew(i,ny)=25.3
enddo
do j=1,ny
tnew(1,j)=0.5
tnew(nx,j)=11.2
enddo
do i=2,nx-1
do j=2,ny-1
tnew(i,j)=ti(k)
enddo
enddo
told=tnew

!Lamamiento a la subrutina
do n=1,niter
if (n.eq.niter) then
print*,n,"faltan iteraciones"
endif
call solucio(told,nx,ny,h,w,icontrol,tnew)
write(1,*)n,tnew(103,55)
told=tnew
enddo

write(1,*)
write(1,*)
print*,tnew(103,55)
enddo



!Sobrerelaxació
icontrol=1
do k=1,3
do i=1,nx
tnew(i,1)=17.0
tnew(i,ny)=25.3
enddo
do j=1,ny
tnew(1,j)=0.5
tnew(nx,j)=11.2
enddo
do i=2,nx-1
do j=2,ny-1
tnew(i,j)=ti(k)
enddo
enddo

told=tnew
!Lamamiento a la subrutina
do n=1,niter
if (n.eq.niter) then
print*,n,"faltan iteraciones"
endif
call solucio(told,nx,ny,h,w,icontrol,tnew)
write(1,*)n,tnew(103,55)
told=tnew
enddo

write(1,*)
write(1,*)
print*,tnew(103,55)
enddo


!MAPAS
niter=10000
do i=1,nx
tnew(i,1)=17.0
tnew(i,ny)=25.3
enddo
do j=1,ny
tnew(1,j)=0.5
tnew(nx,j)=11.2
enddo
do i=2,nx-1
do j=2,ny-1
tnew(i,j)=0
enddo
enddo

told=tnew
!Lamamiento a la subrutina
do n=1,niter
if (n.eq.niter) then
print*,n,"faltan iteraciones"
endif
call solucio(told,nx,ny,h,w,icontrol,tnew)
told=tnew
enddo

!Se ecriben los resultados estacionarios para hacer el plot en 3D
do i=1,nx
x=h*(i-1)
do j=1,ny
y=h*(j-1)
write(1,*)x,y,tnew(i,j)
enddo
write(1,*)
enddo
write(1,*)
write(1,*)
 
!Sin fuentes

do i=1,nx
tnew(i,1)=17.0
tnew(i,ny)=25.3
enddo
do j=1,ny
tnew(1,j)=0.5
tnew(nx,j)=11.2
enddo
do i=2,nx-1
do j=2,ny-1
tnew(i,j)=0
enddo
enddo

told=tnew
!Lamamiento a la subrutina
do n=1,niter
if (n.eq.niter) then
print*,n,"faltan iteraciones"
endif
call solucio_2(told,nx,ny,h,w,icontrol,tnew)
told=tnew
enddo

!Se ecriben los resultados estacionarios para hacer el plot en 3D
do i=1,nx
x=h*(i-1)
do j=1,ny
y=h*(j-1)
write(1,*)x,y,tnew(i,j)
enddo
write(1,*)
enddo
write(1,*)
write(1,*)



END

real*8 function r1(x,y)
real*8 x,y,r,r0
r0=10.0
r=sqrt((x-22.5)**2+(y-8.0)**2)
r1=r0**exp(-((r-4.0)**2)/(0.7**2))
return
END

real*8 function r2(x,y)
real*8 x,y
if (x.gt.35.0.or.x.lt.29.0.or.(y.gt.22.0.or.y.lt.18.0)) then
r2=0
else
r2=7
endif
return
END

real*8 function r3(x,y)
real*8 x,y,r,r0
r0=5.5
r=sqrt((x-10.5)**2+(y-22)**2)
r1=r0**exp(-((r-5.0)**2)/(1.2**2))
return
END


!Subrutina del calculo de temperaturas
subroutine solucio(told,nx,ny,h,w,icontrol,tnew)
integer nx,ny,i,j,icontrol
real*8 told(nx,ny),tnew(nx,ny),x,y,h,w,r1,r2,r3
!Se caculan las coordenadas de cada elemento de la malla para calcular el efecto de los fogones
do i=2,nx-1
x=h*(i-1)
do j=2,ny-1
y=h*(j-1)
!Depeniendo del valor de la variable control se usa un método u otro
if (icontrol.eq.0) then
tnew(i,j)=(told(i-1,j)+told(i+1,j)+told(i,j-1)+told(i,j+1)+(r1(x,y)+r2(x,y)+r3(x,y))*h**2)/4.0
else
tnew(i,j)=told(i,j)+w*(tnew(i+1,j)+tnew(i-1,j)+tnew(i,j+1)+tnew(i,j-1)-4*told(i,j)+(r1(x,y)+r2(x,y)+r3(x,y))*h**2)/4.0
endif
enddo
enddo
return
END



!Subrutina del calculo de temperaturas sin fuentes
subroutine solucio_2(told,nx,ny,h,w,icontrol,tnew)
integer nx,ny,i,j,icontrol
real*8 told(nx,ny),tnew(nx,ny),x,y,h,w,r1,r2,r3
!Se caculan las coordenadas de cada elemento de la malla para calcular el efecto de los fogones
do i=2,nx-1
x=h*(i-1)
do j=2,ny-1
y=h*(j-1)
!Depeniendo del valor de la variable control se usa un método u otro
if (icontrol.eq.0) then
tnew(i,j)=(told(i-1,j)+told(i+1,j)+told(i,j-1)+told(i,j+1))/4.0
else
tnew(i,j)=(told(i,j)+w*(tnew(i+1,j)+tnew(i-1,j)+tnew(i,j+1)+tnew(i,j-1)-4*told(i,j)))/4.0
endif
enddo
enddo
return
END

