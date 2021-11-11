!-----------------------------------------------------------------------------------------------!
SUBROUTINE STRET2(S,S0,S1,NP)
!-----------------------------------------------------------------------------------------------!
IMPLICIT NONE
INTEGER :: NP,NP1,I
DOUBLE PRECISION :: S(NP),S0,S1,RNP1,B,A,DX,SXX,SHXX,COEF,XI,ARG,U
!-----------------------------------------------------------------------------------------------!
S(1)=0.D0
S(NP)=1.D0
NP1=NP-1
RNP1=DFLOAT(NP1)
B=DSQRT(S0*S1)
A=DSQRT(S0/S1)
!-----------------------------------------------------------------------------------------------!
IF (B < 0.999D0) THEN
!-----------------------------------------------------------------------------------------------!
   DX=SXX(B)
   COEF=1.D0/(2.D0*DTAN(DX/2.D0))
   DO I=2,NP1
      XI=(DFLOAT(I)-1.D0)/RNP1
      ARG=DX*(XI-0.5D0)
      U=0.5D0+DTAN(ARG)*COEF
      S(I)=U/(A+(1.D0-A)*U)
   END DO !I=2,NP1
!-----------------------------------------------------------------------------------------------!
ELSEIF (B > 1.001D0) THEN
!-----------------------------------------------------------------------------------------------!
   DX=SHXX(B)
   COEF=1.D0/(2.D0*DTANH(DX/2.D0))
   DO I=2,NP1
      XI=(DFLOAT(I)-1.D0)/RNP1
      ARG=DX*(XI-0.5D0)
      U=0.5D0+DTANH(ARG)*COEF
      S(I)=U/(A+(1.D0-A)*U)
   END DO !I=2,NP1
!-----------------------------------------------------------------------------------------------!
ELSE
!-----------------------------------------------------------------------------------------------!
   DO I=2,NP1
      XI=(DFLOAT(I)-1.D0)/RNP1
      U=XI*(1.D0+2.D0*(B-1.D0)*(XI-0.5D0)*(1.D0-XI))
      S(I)=U/(A+(1.D0-A)*U)
   END DO !I=2,NP1
!-----------------------------------------------------------------------------------------------!
END IF
!-----------------------------------------------------------------------------------------------!
END SUBROUTINE STRET2
!-----------------------------------------------------------------------------------------------!
