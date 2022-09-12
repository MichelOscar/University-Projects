IMPLICIT NONE
!Se definen las variables del problema y las de las subrutina histograma(he usado la del campus virtual)
INTEGER NB,I,ndat,ierr,k
DOUBLE PRECISION XA,XB,BOXSIZE,PI,x,f,a,b,M,l,integral,sigma
external f1,f2

real*8,allocatable :: XHIS(:)
real*8,allocatable :: VHIS(:) 
real*8,allocatable :: ERRHIS(:)
real*8,allocatable :: xnums(:)
!Se da dimension a los vectores y valores a las constantes
NB=100
pi=acos(-1.0)
ndat=50000
l=4.0
sigma=3
a=-l*pi
b=l*pi
M=0.2

allocate(XHIS(NB))
allocate(VHIS(NB))
allocate(ERRHIS(NB))
allocate(xnums(ndat))

!APARTAD0 1,a
!Se llama a la subrutina accep para aplicar el método acepto-rechazo a la funcion
!de densidad de probabilidad deseada y luego se crea el histograma.
call accep(ndat,xnums,a,b,M,f1) 

call histograma(ndat,xnums,a,b,nb,XHIS,VHIS,ERRHIS,BOXSIZE,IERR)
      OPEN(1,FILE="P5-1920-res.dat")
      DO I=1,NB
        WRITE(1,*) XHIS(I),VHIS(I),BOXSIZE,ERRHIS(I)
      ENDDO
      CLOSE(1)

!APARTADO 1,b
!Aqui se usa el método simpson para calcular las integrales de la funcion f1 y se imprimen
b=l*pi/2
k=12
call simpson(a,b,k,f1,integral)
print*,"Integral:",integral
a=-l*pi
b=l*pi
call simpson(a,b,k,f1,integral)
print*,"Normalización",integral

!APARTADO 2
!Primero se redefinen los extremos y se repite el proceso del primer apartado con 
!la segunda función.
ndat=20000
a=-pi*sigma
b=pi*sigma
M=0.2

call accep(ndat,xnums,a,b,M,f2) 

call histograma(ndat,xnums,a,b,nb,XHIS,VHIS,ERRHIS,BOXSIZE,IERR)
      OPEN(2,FILE="P5-1920-res2.dat")
      DO I=1,NB
        WRITE(2,*) XHIS(I),VHIS(I),BOXSIZE,ERRHIS(I)
      ENDDO
      CLOSE(2)
END

!Las dos primeras subrutinas evaluan las funciones
subroutine f1(x,f)
real*8 x,f,pi,l
l=4
pi=acos(-1.0)
f=(sin(x/l))**2/(l*pi)
return
END


subroutine f2(x,f)
real*8 x,f,pi,sigma
sigma=3
pi=acos(-1.0)
f=6/(pi*(2*pi**2-3)*sigma)*(x/sigma)**2*(sin(x/sigma))**2
return
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


!Subrutina histograma
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


!Subrutina simpson
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



       


