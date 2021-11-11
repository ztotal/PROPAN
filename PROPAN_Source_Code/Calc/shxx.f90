!-----------------------------------------------------------------------------------------------!
DOUBLE PRECISION FUNCTION SHXX(Y)
!-----------------------------------------------------------------------------------------------!
IMPLICIT NONE
DOUBLE PRECISION :: Y,YM1,Y2,Y3,X,V,W,W2
!-----------------------------------------------------------------------------------------------!
IF (Y < 2.7829681D0) THEN
   YM1=Y-1.D0
   Y2=YM1*YM1
   Y3=Y2*YM1
   X=1.D0-0.15D0*YM1+0.057321429D0*Y2-0.024907295D0*Y3+0.0077424461D0*Y2*Y2
   X=DSQRT(6.D0*YM1)*(X-0.0010794123D0*Y2*Y3)
ELSE
   V=DLOG(Y)
   W=1.D0/Y-0.028527431D0
   W2=W*W
   X=V+(1.D0+1.D0/V)*DLOG(2.D0*V)-0.02041793D0+0.24902722D0*W+1.9496443D0*W2
   X=X-2.6294547D0*W2*W+8.56795911D0*W2*W2
ENDIF
!-----------------------------------------------------------------------------------------------!
SHXX=X
!-----------------------------------------------------------------------------------------------!
END FUNCTION SHXX
!-----------------------------------------------------------------------------------------------!
