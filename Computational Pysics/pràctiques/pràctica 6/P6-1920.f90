IMPLICIT NONE
!Definimos todas las variables del programa y las que se usan para hacer el histograma
real*8 x,f,a,b,I,sig,res(5),L,pi,XA,XB,BOXSIZE,M
integer u,ndat,nb,ierr


real*8,allocatable :: XHIS(:)
real*8,allocatable :: VHIS(:) 
real*8,allocatable :: ERRHIS(:)
real*8,allocatable :: xnums(:)
!Se definen todas las funciones que se usaran en el programa
external ux,dx,px,i2,phi
pi=acos(-1.0)
l=pi
!APARTADO 1A
open(1,file="P6-1920-res.dat")
do u=1,300
ndat=u*150
!Para cada valor de ndat se calculan las 2 integrales y los errores reales y se guardan los resultados en un vector para después escribirlos en el fixero.
res(1)=ndat
a=1d-12
b=1.0
call montecru(a,b,ndat,ux,res(2),res(3))
a=1d-12
b=1.0
call montecru(a,b,ndat,dx,res(4),res(5))
write(1,100)res(1),res(2),res(3),res(4),res(5)
enddo
write(1,*)
write(1,*)

!APARTADO 1B
!Se crean los valores segun la distribución dada y se genera un histograma para
!Comprobar que los numeros coinciden con la densidad de probabilidad.
ndat=1000000
a=-L
b=L
M=0.4
nb=100
allocate(XHIS(NB))
allocate(VHIS(NB))
allocate(ERRHIS(NB))
allocate(xnums(ndat))
call accep(ndat,xnums,a,b,M,px)
call histograma(ndat,xnums,a,b,nb,XHIS,VHIS,ERRHIS,BOXSIZE,IERR)
      OPEN(2,FILE="Histograma.dat")
      DO u=1,NB
        WRITE(2,*) XHIS(u),VHIS(u),BOXSIZE,ERRHIS(u)
      ENDDO
      CLOSE(2)


!APARTADO 1D
!Se ejecuta la subrutina de montecarlo con sampleo de importancia para la funcion dada.
ndat=1000000
a=-l
b=l
call montesmple(a,b,ndat,xnums,px,i2,I,sig)

100 format(f12.0,2x,f12.5,2x,f12.5,2x,f12.5,2x,f12.5,2x)


!APARTADO 2
!Se hace lo mismo que en el apartado anterior pero con la función de múltiples variables.
ndat=250000
a=-l
b=l
call multiple(a,b,ndat,xnums,px,phi,I,sig)
END

!Se crean todas las funciones que se usan.
subroutine ux(x,f)
real*8 x,f
f=5.109*x**(0.8002-1.0)*(1-x)**3
return
END

subroutine dx(x,f)
real*8 x,f
f=3.058*x**(0.803-1.0)*(1-x)**4
return
END

subroutine px(x,f)
real*8 x,f,pi,l
pi=acos(-1.0)
l=pi
f=(1/l)*(sin(pi*(x-l)/(2*l)))**2
return
END

subroutine i2(x,f)
real*8 x,f,pi,l
pi=acos(-1.0)
l=pi
f=(sin(8*pi*(x-l)/(2*l)))**2*(1/l)*(sin(pi*(x-l)/(2*l)))**2
return
END

subroutine phi(x,f)
real*8 x(3),f,pi,l
integer i,j,k
pi=acos(-1.0)
l=pi
f=1
!Se hace el productorio. El primer bucle es para el primero.
do i=1,3
f=f*sin(pi*(x(i)-l)/(2*l))
!En el segundo solo se cojen los terminos en los que j es menor que k
!Se multiplican 3 factores, los correspondientes a j=1 k=2,3 y el j=1 k=2
enddo
do j=1,2
do k=j+1,3
f=f*(cos(pi*(x(j)-l)/(2*l))-cos(pi*(x(k)-l)/(2*l)))
enddo
enddo
f=f**2
return
END

!Subrutina montecarlo crudo
subroutine montecru(a,b,ndat,fun,I,sig)
real*8 x,a,b,fi,si,ss,I,sig,n
integer u,ndat
si=0
ss=0
n=ndat
!Se generan números aleatorios uniformes entre a y b
do u=1,ndat
 10 x=(b-a)*rand()+a
!Se evalua la funcion en cada número y se calcula la media y el error(I,sigma)
call fun(x,fi)
if (fi.eq.0) then 
go to 10
endif
si=si+fi
ss=ss+fi**2
enddo
I=(b-a)*si/n
sig=sqrt((b-a)**2*ss/n-(I)**2)/sqrt(n)
return
END


!SUBRUTINA MONTESAMPLEO
!La subrutina toma una lista de números calculados con la densidad de probabilidad deseada y usa dos funciones (la funcion a integrar(fun2) y la que da la dsitribucion de los numeros xdata(fun1)).
subroutine montesmple(a,b,ndat,xdata,fun1,fun2,I,sig)
integer u,ndat
real*8 a,b,I,sig,xdata(ndat),n,fi,gi,si,ss
si=0
ss=0
!Se evaluan las dos funciones en cada punto y se hace la media del cociente de las dos funciones para calcular la integral.
do u=1,ndat
call fun1(xdata(u),fi)
call fun2(xdata(u),gi)
!Este condicional sirve para evitar que un número lleve a un cálculo infinito.(en algunos tests me dava NaN a partir de cierto punto)
if (fi.eq.0) then
go to 1
endif
si=si+gi/fi
ss=ss+(gi/fi)**2
!Cada cierto tiempo el programa calcula la integral y el error y los escribe en el fixero. Solo hace falta llamar a la subrutina una vez desde el programa principal.
 1 if (mod(u,10000).eq.0) then
n=u
I=si/n
sig=sqrt(ss/n-(I)**2)/sqrt(n)
write(1,200)n,I,sig
endif
enddo
write(1,*)
write(1,*)
200 format(f12.0,2x,f12.5,2x,f12.5)
return
END

!SUBRUTINA MONTE MULTIPLE
!Funciona similar a la anterior subrutina pero con una funcion de 3 variables.
subroutine multiple(a,b,ndat,xdata,fun1,fun2,I,sig)
integer u,ndat,m
real*8 a,b,I,sig,xdata(ndat),n,f1,f2,f3,gi,si,ss,x(3)
si=0
ss=0
do u=1,ndat
!Para cada valor de ndat se cojen 3 valores distintos de la lista xdata.
!Se guardan en un vector de dim. 3 para usar la funcion a integrar y se evaluan en la funcion px
m=u*3-2
x(1)=xdata(m)
x(2)=xdata(m+1)
x(3)=xdata(m+2)
call fun1(xdata(m),f1)
call fun1(xdata(m+1),f2)
call fun1(xdata(m+2),f3)
if ((f1.eq.0).or.(f2.eq.0).or.(f3.eq.0)) then
go to 2
endif
!Se llama a la funcion phi y se hace el calculo de la intergal para el caso de múltiples variables.
call fun2(x,gi)
si=si+gi/(f1*f2*f3)
ss=ss+(gi/(f1*f2*f3))**2
!Se escriben los resultados a intervalos de 10000 valores.
 2 if (mod(u,10000).eq.0) then
n=u
I=si/(n)
sig=sqrt(ss/(n)-(I)**2)/sqrt(n)
write(1,300)(n),I,sig
endif
enddo
write(1,*)
write(1,*)
300 format(f12.0,2x,f12.5,2x,f12.5)
END

!Subrutina acepto/rechazo
subroutine accep(ndat,xnums,a,b,M,fun)
integer ndat,i
real*8 a,b,M,x,p,x1,x2,su,var,n,xnums(ndat),f
n=ndat
!Se generan dos numeros aleatorios
do i=0,ndat
1 x1=rand()
x2=rand()
!Se convierten a una distribucion uniforme entre los intervalos deseados
x=(b-a)*x1+a
p=M*x2
call fun(x,f)
!Si la funcion de x es  mayor que p se acepta el numero. Cuanto más alta sea la probabilidad de x más probable es que sea aceptado.
if (f.ge.p) then
xnums(i)=x
f=0
	else
	x1=0
	x2=0
	f=0
	go to 1
endif
enddo
!Luego se calcula la media, la varainza y la desviación típica
su=0
do i=0,ndat
su=su+xnums(i)
enddo
print*,"Media:",su/n
do i=0,ndat
var=var+(xnums(i)-su/n)**2
enddo
print*,"Varianza:",var/n,"Desviación:",sqrt(var/n)
return
END

!Subrutina histograma(Se ha usado la del campus virtual)
       SUBROUTINE HISTOGRAMA(NDAT,XDATA,XA,XB,NBOX,XHIS,VHIS,ERRHIS,BOXSIZE,IERR)
      



       INTEGER NDAT,NBOX
       DOUBLE PRECISION XDATA(NDAT),XA,XB
       DOUBLE PRECISION XHIS(NBOX),VHIS(NBOX),ERRHIS(NBOX)
       INTEGER IERR
 
       INTEGER I,IBOX,ICOUNT
       DOUBLE PRECISION BOXSIZE

       IF (XA.GE.XB) THEN 
          IERR=1
          RETURN
       ENDIF

         BOXSIZE=(XB-XA)/NBOX


       ICOUNT=0


       DO I=1,NBOX
          VHIS(I)=0
          ERRHIS(I)=0
       ENDDO


       DO I=1,NDAT

         IF (XDATA(I).GE.XA.AND.XDATA(I).LE.XB) THEN 
            IBOX=INT((XDATA(I)-XA)/BOXSIZE)+1

            IF (IBOX.EQ.NBOX+1) IBOX=NBOX 

            VHIS(IBOX)=VHIS(IBOX)+1
            ICOUNT=ICOUNT+1
         ENDIF
        ENDDO

        IF (ICOUNT.EQ.0) THEN 
           IERR=2
           RETURN
        ENDIF

        IERR=0
        PRINT*,"ACCEPTED:",ICOUNT,  " OUT OF:",NDAT

        DO I=1,NBOX

           XHIS(I)=XA+BOXSIZE/2.D0+(I-1)*BOXSIZE

           ERRHIS(I)=SQRT(VHIS(I)/ICOUNT*(1.D0-VHIS(I)/ICOUNT))/BOXSIZE / 		SQRT(DBLE(ICOUNT))

           VHIS(I)=VHIS(I)/ICOUNT/BOXSIZE
        ENDDO
        END
