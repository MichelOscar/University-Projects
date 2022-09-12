IMPLICIT NONE
!Se definen las variables enteras, k el numero que pide el programa
!M y N los numeros que se dan en el enunciado e i,B para hacer los bucles

integer k,i,M,N,B

!pk es el valor de la funcion de k, la suma es el sumatorio, as el valor asintotico
! y funcion y asint las funciones que se usaran

real pk,pi,funcion,suma,as,asint

!se definen los valores iniciales de las variables
suma=0
pi=acos(-1.0)
M=14
N=70

!se pide un numero y se comprueba que esta dentro del rango deseado
5 print*,"Escribe un numero entre 5 y 301"
read*,k

IF((k.LT.5).OR.(k.GT.301))THEN
	PRINT*,"El numero tiene que estar entre 5 y 301"
	GOTO 5
ENDIF
print*,"k=",k

!APARTADO 1
pk=funcion(k,pi)
print*,pk

!APARTAT 2
call sumatori(pk,suma,i,N,M)
print*,"la suma es",suma
suma=0
pk=0

!APARTAT 3
OPEN(1,FILE="P1-19-20-res1.dat")
!se definen los nuevos valores de M y N
!Para cada M se llama la subrutina y luego se escribe el valor de M y su suma
M=3
DO B=2,105
N=2*B
CALL sumatori(pk,suma,i,N,M)
WRITE(1,*)N,suma
ENDDO
 CLOSE(1)

!APARTAT 4
OPEN(2,FILE="P1-19-20-res2.dat")
!Similar al apartado anterior pero aparte de usar la subrutina se usa la 
!función asint y se escribe en un fixero los numeros pedidos
M=3
DO B=2,105
N=2*B
CALL sumatori(pk,suma,i,N,M)
as=asint(N)
WRITE(2,*)N,suma/as
ENDDO
 CLOSE(2)




END
!La primera funcion calcula la funcion dada en el enucnciado para k
real function funcion(k,pi)
integer k
funcion=5.0*(k**2)/3.0+pi-2*k
return

END
!La subrutina hace un bucle en el que llama la funcion anterior para cada numero 
!entre M y N y los suma todos
subroutine sumatori(pk,suma,i,N,M)
integer i,M,N
real suma,pk,pi
suma=0
DO i=M,N
pk=funcion(i,pi)
suma=suma+pk
ENDDO
RETURN
END

!La funcion asint usa la formula dada en el apartado 5 para los M
real function asint(N)
integer N
asint=5.0*N**3/9.0
return
END


