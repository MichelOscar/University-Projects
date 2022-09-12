!Programa de simulació del model Ising 2-d-Oscar Michel Gonzalez, E01
IMPLICIT NONE
! Definició de totes les variables del programa
! primerament totes les variables integer que serviran com a comptadors dels bucles
! i paràmetres del programa, L, nombre de llavors, etc...
integer*4 SEED,i,j,L,MCTOT,n,m,npas,DE,MCINI,MCD,SEED0,NSEED,ntemp
! es defineixen les variables termodinàmiques del sistema així com les variables 
! que s'utilitzaran en l'algorisme de metrópolis.
real*8 genrand_real2,E,energia,mag,magne,cap,sus,temp,x,y,delta,u,ebis,W(-8:8)
! variables que controlen el temps d'execució
real*8 time1,time2,date
! variables relacionades amb el tractament estadístic dels resultats finals
real*8 SUMA,SUME,SUME2,SUMM,SUMM2,SUMAM,vare,varm,erre,errm,ecap,esus
! la matriu d'spins i el vector de les condicions de contorn es defineixen com a arrays
! als quals s'els assignarà dimensió posteriorment
integer*2,allocatable:: S(:,:)
integer*4,allocatable:: PBC(:)


call cpu_time(time1)
! es defineixen tots els paràmetres de la simulacio:
! tamany de la quadrícula, nombre de pases de montecarlo, nombre de llavors
! entre altres
L=32
MCTOT=40000
MCINI=2000
MCD=20
npas=L*L
SEED0=5175020
NSEED=10

! es dona dimensió a la matriu S i vector de condicions periòdiques
allocate(S(1:L,1:L))
allocate(PBC(0:L+1))

! es defineixen les condicions periòdiques de contorn
PBC(0)=L
PBC(L+1)=1
do i=1,L
PBC(i)=i
enddo

open(UNIT=12,FILE="dades.dat")




! comença al bucle de temperatures, aquest és el més extern
do ntemp=0,200
temp=dfloat(ntemp)*0.01d0+1.4d0

! per a cada temperatura es defineix el vector W que té la informació sobre
! els increments d'energia. Serà utilitzat més endavant en l'algorisme 
! de metrópolis
do DE=-8,8
W(DE)=exp(-dfloat(DE)/temp)
enddo

SUMA=0D0
SUME=0D0
SUME2=0D0
SUMM=0D0
SUMM2=0D0
SUMAM=0D0

! dins del bucle de temperatures es crea el bucle de seeds
do SEED=SEED0,SEED0+NSEED-1,1
! per a cada llavor cridem el generador de nombres aleatoris
call init_genrand(SEED)
! i després generem la matriu d'spins aleatòriament amb la llavor corresponent
do i=1,L
do j=1,L
if (genrand_real2().lt.0.5D0) then
S(i,j)=1
else
S(i,j)=-1
endif
enddo
enddo

E=energia(S,L,PBC)

!ALGORITME DE METRÓPOLIS
! el primer bucle és sobre el nombre de pases
do n=1,MCTOT
! el segón fa L*L pases de metropolis que consistiran en cnviar aleatòriament
! un spin de la xarxa
do m=1,npas
! primer es tria l'spin que volem canviar
x=genrand_real2()
y=genrand_real2()
i=int(L*x)+1
j=int(L*y)+1
! es calcula l'increment de temperatura que resultaria de canviar de 
! signe l'spin triat
DE=2*S(I,J)*(S(PBC(I+1),J)+S(PBC(I-1),J)+S(I,PBC(J+1))+S(I,PBC(J-1)))
! s'apliquen les condicions de metropolis:
! primer que sigui negatiu
if (DE.le.0d0) then
S(i,j)=-S(i,j)
E=E+DE
! i si no ho es s'agafa un nombre uniforme [0,1] i es mira que sigui
! menor a l'index corresponent del vector W
else if (genrand_real2().le.W(DE)) then
S(i,j)=-S(i,j)
E=E+DE
endif
! si qualsevol de les dues condicions es compleix es canvia el signe de l'spin 
! i es procedeix al següent pas. Si no compleix cap es procedeix igualment pero
! sense alterar la matriu S
enddo
! Un cop acabada la passa de montecarlo es calculen tots els promitjos pero només quan
! es superior a mcini o multiple de mcd
if ((n.gt.MCINI).and.(MCD*(n/MCD).eq.n)) then
mag=magne(S,L)
SUMA=SUMA+1D0
SUME=SUME+E
SUME2=SUME2+E*E
SUMM=SUMM+mag
SUMM2=SUMM2+abs(mag)*abs(mag)
SUMAM=SUMAM+abs(mag)
endif
enddo

enddo
! un com acabat el bucle de montecarlo i de seeds es calculen les variables reduïdes
SUME=(SUME/SUMA)/dfloat(L*L)
SUME2=(SUME2/SUMA)/((dfloat(L*L))**2)
SUMM=(SUMM/SUMA)/dfloat(L*L)
SUMM2=(SUMM2/SUMA)/((dfloat(L*L))**2)
SUMAM=(SUMAM/SUMA)/dfloat(L*L)
! es calculen tambe els errors
erre=sqrt((abs(sume2-sume*sume))/(suma))
errm=sqrt((abs(summ2-sumam*sumam))/(suma))
! i la capacitat calorífica i susceptibilitat
cap=dfloat(L*L)*(SUME2-SUME*SUME)/(temp*temp)
sus=dfloat(L*L)*(SUMM2-SUMAM*SUMAM)/(temp)
ecap=dfloat(L*L)*4d0*erre/(temp*temp)
esus=dfloat(L*L)*4d0*errm/(temp)
! finalment s'escriuen totes les dades i es passa a fer la següent temperatura
write(12,*)temp,sume,sumam,cap,sus,sume2,summ,summ2,erre,errm,ecap,esus
! s'imprimeixen els resultats per controlar el funcionament del programa
print*,temp,ntemp
! es redefineix la seed inicial per utilitzar diferents seeds a cada temperatura
SEED0=SEED
ENDDO

call cpu_time(time2)

print*,"time=",time2-time1


WRITE(12,*)
WRITE(12,*)

 close(12)
END






!FUNCIO ENERGIA
! calcula l'energia de la distribució S (només s'utilitza al principi pero
! no es fa servir durant l'execució del programa)
real*8 function energia(S,L,PBC)
! es defineixen les variables necesaries
integer*4 I,J,L
integer*2 S(1:L,1:L)
integer*4 PBC(0:L+1)
real*8 ene
ene=0.0D0
! partint de E=0 es fa la suma de totes les interaccions a primers veïns
! en u bucle sobre tots els elements de la xarxa
do I =1,L
do J=1,L
ene=ene-S(i,j)*S(PBC(i+1),j)-S(i,j)*S(i,PBC(j+1))
enddo
enddo
energia=ene
return
END

! es el mateix que la funció energia pero en forma de subrutina
!(no s'utilitza durant el programa)
SUBROUTINE energ(S,L,PBC,E)
integer*4 i,j,L
integer*2 S(1:L,1:L)
integer*4 PBC(0:L+1)
real*8 E
E=0.0D0
do I =1,L
do J=1,L
E=E-S(i,j)*S(PBC(i+1),i)-S(i,j)*S(i,PBC(j+1))
enddo
enddo
return
END

!FUNCIO MAGNETITZACIÓ
! calcula la magnetització sumant tots els spins de la xarxa
real*8 function magne(S,L)
integer L,i,j
integer*2 S(1:L,1:L)
real*8 mag
mag=0d0
do i=1,L
do j=1,L
mag=mag+S(i,j)
enddo
enddo
magne=mag
return
end



!GENERADOR DE NOMBRES ALEATÒRIS
subroutine init_genrand(s)
      integer s
      integer N
      integer DONE
      integer ALLBIT_MASK
      parameter (N=624)
      parameter (DONE=123456789)
      integer mti,initialized
      integer mt(0:N-1)
      common /mt_state1/ mti,initialized
      common /mt_state2/ mt
      common /mt_mask1/ ALLBIT_MASK

      call mt_initln
      mt(0)=iand(s,ALLBIT_MASK)
      do 100 mti=1,N-1
        mt(mti)=1812433253*ieor(mt(mti-1),ishft(mt(mti-1),-30))+mti
        mt(mti)=iand(mt(mti),ALLBIT_MASK)
  100 continue
      initialized=DONE

      return
      end

      subroutine init_by_array(init_key,key_length)
      integer init_key(0:*)
      integer key_length
      integer N
      integer ALLBIT_MASK
      integer TOPBIT_MASK
      parameter (N=624)
      integer i,j,k
      integer mt(0:N-1)
      common /mt_state2/ mt
      common /mt_mask1/ ALLBIT_MASK
      common /mt_mask2/ TOPBIT_MASK

      call init_genrand(19650218)
      i=1
      j=0
      do 100 k=max(N,key_length),1,-1
        mt(i)=ieor(mt(i),ieor(mt(i-1),ishft(mt(i-1),-30))*1664525)+init_key(j)+j
        mt(i)=iand(mt(i),ALLBIT_MASK)
        i=i+1
        j=j+1
        if(i.ge.N)then
          mt(0)=mt(N-1)
          i=1
        endif
        if(j.ge.key_length)then
          j=0
        endif
  100 continue
      do 200 k=N-1,1,-1
        mt(i)=ieor(mt(i),ieor(mt(i-1),ishft(mt(i-1),-30))*1566083941)-i
        mt(i)=iand(mt(i),ALLBIT_MASK)
        i=i+1
        if(i.ge.N)then
          mt(0)=mt(N-1)
          i=1
        endif
  200 continue
      mt(0)=TOPBIT_MASK

      return
      end


      function genrand_int32()
      integer genrand_int32
      integer N,M
      integer DONE
      integer UPPER_MASK,LOWER_MASK,MATRIX_A
      integer T1_MASK,T2_MASK
      parameter (N=624)
      parameter (M=397)
      parameter (DONE=123456789)
      integer mti,initialized
      integer mt(0:N-1)
      integer y,kk
      integer mag01(0:1)
      common /mt_state1/ mti,initialized
      common /mt_state2/ mt
      common /mt_mask3/ UPPER_MASK,LOWER_MASK,MATRIX_A,T1_MASK,T2_MASK
      common /mt_mag01/ mag01

      if(initialized.ne.DONE)then
        call init_genrand(21641)
      endif

      if(mti.ge.N)then
        do 100 kk=0,N-M-1
          y=ior(iand(mt(kk),UPPER_MASK),iand(mt(kk+1),LOWER_MASK))
          mt(kk)=ieor(ieor(mt(kk+M),ishft(y,-1)),mag01(iand(y,1)))
  100   continue
        do 200 kk=N-M,N-1-1
          y=ior(iand(mt(kk),UPPER_MASK),iand(mt(kk+1),LOWER_MASK))
          mt(kk)=ieor(ieor(mt(kk+(M-N)),ishft(y,-1)),mag01(iand(y,1)))
  200   continue
        y=ior(iand(mt(N-1),UPPER_MASK),iand(mt(0),LOWER_MASK))
        mt(kk)=ieor(ieor(mt(M-1),ishft(y,-1)),mag01(iand(y,1)))
        mti=0
      endif

      y=mt(mti)
      mti=mti+1

      y=ieor(y,ishft(y,-11))
      y=ieor(y,iand(ishft(y,7),T1_MASK))
      y=ieor(y,iand(ishft(y,15),T2_MASK))
      y=ieor(y,ishft(y,-18))

      genrand_int32=y
      return
      end

      function genrand_int31()
      integer genrand_int31
      integer genrand_int32
      genrand_int31=int(ishft(genrand_int32(),-1))
      return
      end

      function genrand_real1()
      double precision genrand_real1,r
      integer genrand_int32
      r=dble(genrand_int32())
      if(r.lt.0.d0)r=r+2.d0**32
      genrand_real1=r/4294967295.d0
      return
      end

      function genrand_real2()
      double precision genrand_real2,r
      integer genrand_int32
      r=dble(genrand_int32())
      if(r.lt.0.d0)r=r+2.d0**32
      genrand_real2=r/4294967296.d0
      return
      end

      function genrand_real3()
      double precision genrand_real3,r
      integer genrand_int32
      r=dble(genrand_int32())
      if(r.lt.0.d0)r=r+2.d0**32
      genrand_real3=(r+0.5d0)/4294967296.d0
      return
      end

      function genrand_res53()
      double precision genrand_res53
      integer genrand_int32
      double precision a,b
      a=dble(ishft(genrand_int32(),-5))
      b=dble(ishft(genrand_int32(),-6))
      if(a.lt.0.d0)a=a+2.d0**32
      if(b.lt.0.d0)b=b+2.d0**32
      genrand_res53=(a*67108864.d0+b)/9007199254740992.d0
      return
      end

      subroutine mt_initln
      integer ALLBIT_MASK
      integer TOPBIT_MASK
      integer UPPER_MASK,LOWER_MASK,MATRIX_A,T1_MASK,T2_MASK
      integer mag01(0:1)
      common /mt_mask1/ ALLBIT_MASK
      common /mt_mask2/ TOPBIT_MASK
      common /mt_mask3/ UPPER_MASK,LOWER_MASK,MATRIX_A,T1_MASK,T2_MASK
      common /mt_mag01/ mag01


      TOPBIT_MASK=1073741824
      TOPBIT_MASK=ishft(TOPBIT_MASK,1)
      ALLBIT_MASK=2147483647
      ALLBIT_MASK=ior(ALLBIT_MASK,TOPBIT_MASK)
      UPPER_MASK=TOPBIT_MASK
      LOWER_MASK=2147483647
      MATRIX_A=419999967
      MATRIX_A=ior(MATRIX_A,TOPBIT_MASK)
      T1_MASK=489444992
      T1_MASK=ior(T1_MASK,TOPBIT_MASK)
      T2_MASK=1875247104
      T2_MASK=ior(T2_MASK,TOPBIT_MASK)
      mag01(0)=0
      mag01(1)=MATRIX_A
      return


END

