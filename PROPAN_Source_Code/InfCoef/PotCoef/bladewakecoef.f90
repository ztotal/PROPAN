!-----------------------------------------------------------------------------------------------!
!    Blade wake influence coefficients                                                          !
!    Copyright (C) 2021  J. Baltazar and J.A.C. Falcão de Campos                                !
!                                                                                               !
!    This program is free software: you can redistribute it and/or modify it under the terms of !
!    the GNU Affero General Public License as published by the Free Software Foundation, either !
!    version 3 of the License, or (at your option) any later version.                           !
!                                                                                               !
!    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;  !
!    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  !
!    See the GNU Affero General Public License for more details.                                !
!                                                                                               !
!    You should have received a copy of the GNU Affero General Public License                   !
!    along with this program.  If not, see <https://www.gnu.org/licenses/>.                     !
!-----------------------------------------------------------------------------------------------!
SUBROUTINE BLADEWAKECOEF
!-----------------------------------------------------------------------------------------------!
!    Created by: J.A.C. Falcao de Campos, IST                                                   !
!    Modified  : 02122013, J. Baltazar, 2014 version 1.0                                        !
!    Modified  : 30052014, J. Baltazar, revised                                                 !
!    Modified  : 27112014, J. Baltazar, 2014 version 3.3, Super-Cavitation Model                !
!    Modified  : 07012015, J. Baltazar, 2015 version 1.0, Wing Case                             !
!    Modified  : 11022016, J. Baltazar, Potential at field points included                      !
!    Modified  : 26102016, J. Baltazar, 2016 version 1.4                                        !
!-----------------------------------------------------------------------------------------------!
USE PROPAN_MOD
IMPLICIT NONE
INTEGER :: I,J,II,JJ,K,KK,L,KB
DOUBLE PRECISION :: XX(4),YY(4),ZZ(4),TE(4),TL,D1,D2,D,R0
DOUBLE PRECISION :: X0,Y0,Z0,UNX0,UNY0,UNZ0,A0
DOUBLE PRECISION :: A1X,A1Y,A1Z,A2X,A2Y,A2Z
DOUBLE PRECISION :: PHIS,PHID,PDL,PDR
!-----------------------------------------------------------------------------------------------!
IF (NT == 0) WIJ(:,1:NRW,:)=0.D0
!-----------------------------------------------------------------------------------------------!
!    Loop on Blade Wake Panels                                                                  !
!-----------------------------------------------------------------------------------------------!
DO J=1,NRW
   DO I=1,NPW
      K=(J-1)*NPW+I
!-----------------------------------------------------------------------------------------------!
!    Loop on the Number of Blades                                                               !
!-----------------------------------------------------------------------------------------------!
      DO KB=1,NB
!-----------------------------------------------------------------------------------------------!
!    Define Panel                                                                               !
!-----------------------------------------------------------------------------------------------!
         TL=DFLOAT(KB-1)*2.D0*PI/DFLOAT(NB)
         TE(1)=TPW(I  ,J  )+TL
         TE(2)=TPW(I+1,J  )+TL
         TE(3)=TPW(I+1,J+1)+TL
         TE(4)=TPW(I  ,J+1)+TL
         XX(1)=XPW(I  ,J  )
         XX(2)=XPW(I+1,J  )
         XX(3)=XPW(I+1,J+1)
         XX(4)=XPW(I  ,J+1)
         YY(1)=RPW(I  ,J  )*DCOS(TE(1))
         YY(2)=RPW(I+1,J  )*DCOS(TE(2))
         YY(3)=RPW(I+1,J+1)*DCOS(TE(3))
         YY(4)=RPW(I  ,J+1)*DCOS(TE(4))
         ZZ(1)=RPW(I  ,J  )*DSIN(TE(1))
         ZZ(2)=RPW(I+1,J  )*DSIN(TE(2))
         ZZ(3)=RPW(I+1,J+1)*DSIN(TE(3))
         ZZ(4)=RPW(I  ,J+1)*DSIN(TE(4))
	 IF ((IROTOR == -1).AND.(KB == 2)) THEN
            XX(1)= XPW(I+1,J  )
            XX(2)= XPW(I  ,J  )
            XX(3)= XPW(I  ,J+1)
            XX(4)= XPW(I+1,J+1)
            YY(1)=-YPW(I+1,J  )
            YY(2)=-YPW(I  ,J  )
            YY(3)=-YPW(I  ,J+1)
            YY(4)=-YPW(I+1,J+1)
            ZZ(1)= ZPW(I+1,J  )
            ZZ(2)= ZPW(I  ,J  )
            ZZ(3)= ZPW(I  ,J+1)
            ZZ(4)= ZPW(I+1,J+1)
         END IF !((IROTOR == -1).AND.(KB == 2))
!-----------------------------------------------------------------------------------------------!
!    Compute Panel Centroid Data                                                                !
!-----------------------------------------------------------------------------------------------!
         CALL PANEL(XX,YY,ZZ,X0,Y0,Z0,A1X,A1Y,A1Z,A2X,A2Y,A2Z,UNX0,UNY0,UNZ0,A0)
!-----------------------------------------------------------------------------------------------!
!    For Flat Panel Redefine Corner Points                                                      !
!-----------------------------------------------------------------------------------------------!
         IF (IPAN == 0) CALL PANELFLAT(XX,YY,ZZ,X0,Y0,Z0,UNX0,UNY0,UNZ0)
!-----------------------------------------------------------------------------------------------!
!    Compute Panel Diagonals                                                                    !
!-----------------------------------------------------------------------------------------------!
         D1=DSQRT((XX(3)-XX(1))**2+(YY(3)-YY(1))**2+(ZZ(3)-ZZ(1))**2)
         D=D1
         D2=DSQRT((XX(4)-XX(2))**2+(YY(4)-YY(2))**2+(ZZ(4)-ZZ(2))**2)
         IF (D2 > D1) D=D2
!-----------------------------------------------------------------------------------------------!
!    Loop on Hub Control Points                                                                 !
!-----------------------------------------------------------------------------------------------!
         DO JJ=1,NHTP
            DO II=1,NHX
               L=(JJ-1)*NHX+II
!-----------------------------------------------------------------------------------------------!
!    Influence Coefficients                                                                     !
!-----------------------------------------------------------------------------------------------!
               R0=DSQRT((XH0(II,JJ)-X0)**2+(YH0(II,JJ)-Y0)**2+(ZH0(II,JJ)-Z0)**2)
!-----------------------------------------------------------------------------------------------!
               IF (IFARP == 1) THEN
                  IF (R0/D >= FARTOL2) CALL FARFIELD(X0,Y0,Z0,UNX0,UNY0,UNZ0,A0, &
                                                     XH0(II,JJ),YH0(II,JJ),ZH0(II,JJ),PHIS,PHID)
                  IF (R0/D >= FARTOL1.AND.R0/D < FARTOL2) CALL GAUSSPAN(2,XX,YY,ZZ, &
                                                     XH0(II,JJ),YH0(II,JJ),ZH0(II,JJ),PHIS,PHID)
               END IF !(IFARP == 1)
!-----------------------------------------------------------------------------------------------!
               IF (R0/D < FARTOL1.OR.IFARP == 0) THEN
                  IF (INTE == 0) CALL POTPANH(XX,YY,ZZ,X0,Y0,Z0,UNX0,UNY0,UNZ0, &
                                                     XH0(II,JJ),YH0(II,JJ),ZH0(II,JJ),PHIS,PHID)
                  IF (INTE /= 0) CALL MSTRPAN_ADP(TOLS,MMAX,XX,YY,ZZ, &
                                                     XH0(II,JJ),YH0(II,JJ),ZH0(II,JJ),PHIS,PHID)
               END IF !(R0/D < FARTOL1.OR.IFARP == 0)
!-----------------------------------------------------------------------------------------------!
               IF ((NT > 0).AND.(KB == 1).AND.(I == 1)) THEN
                  CALL POTLINSUB(TOLS,MMAX,XX,YY,ZZ,XH0(II,JJ),YH0(II,JJ),ZH0(II,JJ),PDL,PDR)
                  KIJ(L,J,1)=PDL
                  KIJ(L,J,2)=PDR
               END IF !((NT > 0).AND.(KB == 1).AND.(I == 1))
!-----------------------------------------------------------------------------------------------!
!    Define Influence Coefficient                                                               !
!-----------------------------------------------------------------------------------------------!
               IF (NT == 0) WIJ(L,J,KB)=WIJ(L,J,KB)+PHID
               IF (NT  > 0) WIJ(L,K,KB)=PHID
               IF (I <= IABS(NCPW)) THEN
                  KK=NHPAN+NPPAN+NNPAN+(J-1)*IABS(NCPW)+I
                  SIJ(L,KK,KB)=PHIS
               END IF !(I <= IABS(NCPW))
            END DO !II=1,NHX
         END DO !JJ=1,NHTP
!-----------------------------------------------------------------------------------------------!
!    Loop on Blade Control Points                                                               !
!-----------------------------------------------------------------------------------------------!
         DO JJ=1,NRP
            DO II=1,NCP
               L=NHPAN+(JJ-1)*NCP+II
!-----------------------------------------------------------------------------------------------!
!    Influence Coefficients                                                                     !
!-----------------------------------------------------------------------------------------------!
               R0=DSQRT((XP0(II,JJ)-X0)**2+(YP0(II,JJ)-Y0)**2+(ZP0(II,JJ)-Z0)**2)
!-----------------------------------------------------------------------------------------------!
               IF (IFARP == 1) THEN
                  IF (R0/D >= FARTOL2) CALL FARFIELD(X0,Y0,Z0,UNX0,UNY0,UNZ0,A0, &
                                                     XP0(II,JJ),YP0(II,JJ),ZP0(II,JJ),PHIS,PHID)
                  IF (R0/D >= FARTOL1.AND.R0/D < FARTOL2) CALL GAUSSPAN(2,XX,YY,ZZ, &
                                                     XP0(II,JJ),YP0(II,JJ),ZP0(II,JJ),PHIS,PHID)
               END IF !(IFARP == 1)
!-----------------------------------------------------------------------------------------------!
               IF (R0/D < FARTOL1.OR.IFARP == 0) THEN
                  IF (INTE == 0) CALL POTPANH(XX,YY,ZZ,X0,Y0,Z0,UNX0,UNY0,UNZ0, &
                                                     XP0(II,JJ),YP0(II,JJ),ZP0(II,JJ),PHIS,PHID)
                  IF (INTE /= 0) CALL MSTRPAN_ADP(TOLS,MMAX,XX,YY,ZZ, &
                                                     XP0(II,JJ),YP0(II,JJ),ZP0(II,JJ),PHIS,PHID)
               END IF !(R0/D < FARTOL1.OR.IFARP == 0)
!-----------------------------------------------------------------------------------------------!
               IF ((NT > 0).AND.(KB == 1).AND.(I == 1)) THEN
                  CALL POTLINSUB(TOLS,MMAX,XX,YY,ZZ,XP0(II,JJ),YP0(II,JJ),ZP0(II,JJ),PDL,PDR)
                  KIJ(L,J,1)=PDL
                  KIJ(L,J,2)=PDR
               END IF !((NT > 0).AND.(KB == 1).AND.(I == 1))
!-----------------------------------------------------------------------------------------------!
!    Define Influence Coefficient                                                               !
!-----------------------------------------------------------------------------------------------!
               IF (NT == 0) WIJ(L,J,KB)=WIJ(L,J,KB)+PHID
               IF (NT  > 0) WIJ(L,K,KB)=PHID
               IF (I <= IABS(NCPW)) THEN
                  KK=NHPAN+NPPAN+NNPAN+(J-1)*IABS(NCPW)+I
                  SIJ(L,KK,KB)=PHIS
               END IF !(I <= IABS(NCPW))
            END DO !II=1,NCP
         END DO !JJ=1,NRP
!-----------------------------------------------------------------------------------------------!
!    Loop on Nozzle Control Points                                                              !
!-----------------------------------------------------------------------------------------------!
         DO JJ=1,NNTP
            DO II=1,NNXT1
               L=NHPAN+NPPAN+(JJ-1)*NNXT1+II
!-----------------------------------------------------------------------------------------------!
!    Influence Coefficients                                                                     !
!-----------------------------------------------------------------------------------------------!
               R0=DSQRT((XN0(II,JJ)-X0)**2+(YN0(II,JJ)-Y0)**2+(ZN0(II,JJ)-Z0)**2)
!-----------------------------------------------------------------------------------------------!
               IF (IFARP == 1) THEN
                  IF (R0/D >= FARTOL2) CALL FARFIELD(X0,Y0,Z0,UNX0,UNY0,UNZ0,A0, &
                                                     XN0(II,JJ),YN0(II,JJ),ZN0(II,JJ),PHIS,PHID)
                  IF (R0/D >= FARTOL1.AND.R0/D < FARTOL2) CALL GAUSSPAN(2,XX,YY,ZZ, &
                                                     XN0(II,JJ),YN0(II,JJ),ZN0(II,JJ),PHIS,PHID)
               END IF !(IFARP == 1)
!-----------------------------------------------------------------------------------------------!
               IF (R0/D < FARTOL1.OR.IFARP == 0) THEN
                  IF (INTE == 0) CALL POTPANH(XX,YY,ZZ,X0,Y0,Z0,UNX0,UNY0,UNZ0, &
                                                     XN0(II,JJ),YN0(II,JJ),ZN0(II,JJ),PHIS,PHID)
                  IF (INTE /= 0) CALL MSTRPAN_ADP(TOLS,MMAX,XX,YY,ZZ, &
                                                     XN0(II,JJ),YN0(II,JJ),ZN0(II,JJ),PHIS,PHID)
               END IF !(R0/D < FARTOL1.OR.IFARP == 0)
!-----------------------------------------------------------------------------------------------!
               IF ((NT > 0).AND.(KB == 1).AND.(I == 1)) THEN
                  CALL POTLINSUB(TOLS,MMAX,XX,YY,ZZ,XN0(II,JJ),YN0(II,JJ),ZN0(II,JJ),PDL,PDR)
                  KIJ(L,J,1)=PDL
                  KIJ(L,J,2)=PDR
               END IF !((NT > 0).AND.(KB == 1).AND.(I == 1))
!-----------------------------------------------------------------------------------------------!
!    Define Influence Coefficient                                                               !
!-----------------------------------------------------------------------------------------------!
               IF (NT == 0) WIJ(L,J,KB)=WIJ(L,J,KB)+PHID
               IF (NT  > 0) WIJ(L,K,KB)=PHID
               IF (I <= IABS(NCPW)) THEN
                  KK=NHPAN+NPPAN+NNPAN+(J-1)*IABS(NCPW)+I
                  SIJ(L,KK,KB)=PHIS
               END IF !(I <= IABS(NCPW))
            END DO !II=1,NNXT1
         END DO !JJ=1,NNTP
!-----------------------------------------------------------------------------------------------!
!    Loop on Blade Wake Control Points                                                          !
!-----------------------------------------------------------------------------------------------!
         DO JJ=1,NRW
            DO II=1,IABS(NCPW)
               L=NHPAN+NPPAN+NNPAN+(JJ-1)*IABS(NCPW)+II
!-----------------------------------------------------------------------------------------------!
!    Influence Coefficients                                                                     !
!-----------------------------------------------------------------------------------------------!
               R0=DSQRT((XPW0(II,JJ)-X0)**2+(YPW0(II,JJ)-Y0)**2+(ZPW0(II,JJ)-Z0)**2)
!-----------------------------------------------------------------------------------------------!
               IF (IFARP == 1) THEN
                  IF (R0/D >= FARTOL2) CALL FARFIELD(X0,Y0,Z0,UNX0,UNY0,UNZ0,A0, &
                                                  XPW0(II,JJ),YPW0(II,JJ),ZPW0(II,JJ),PHIS,PHID)
                  IF (R0/D >= FARTOL1.AND.R0/D < FARTOL2) CALL GAUSSPAN(2,XX,YY,ZZ, &
                                                  XPW0(II,JJ),YPW0(II,JJ),ZPW0(II,JJ),PHIS,PHID)
               END IF !(IFARP == 1)
!-----------------------------------------------------------------------------------------------!
               IF (R0/D < FARTOL1.OR.IFARP == 0) THEN
                  IF (INTE /= 1) CALL POTPANH(XX,YY,ZZ,X0,Y0,Z0,UNX0,UNY0,UNZ0, &
                                                  XPW0(II,JJ),YPW0(II,JJ),ZPW0(II,JJ),PHIS,PHID)
                  IF (INTE == 1) CALL MSTRPAN_ADP(TOLS,MMAX,XX,YY,ZZ, &
                                                  XPW0(II,JJ),YPW0(II,JJ),ZPW0(II,JJ),PHIS,PHID)
               END IF !(R0/D < FARTOL1.OR.IFARP == 0)
!-----------------------------------------------------------------------------------------------!
               IF ((NT > 0).AND.(KB == 1).AND.(I == 1)) THEN
                  CALL POTLINSUB(TOLS,MMAX,XX,YY,ZZ,XPW0(II,JJ),YPW0(II,JJ),ZPW0(II,JJ),PDL,PDR)
                  KIJ(L,J,1)=PDL
                  KIJ(L,J,2)=PDR
               END IF !((NT > 0).AND.(KB == 1).AND.(I == 1))
!-----------------------------------------------------------------------------------------------!
!    Define Influence Coefficient                                                               !
!-----------------------------------------------------------------------------------------------!
               IF (NT == 0) WIJ(L,J,KB)=WIJ(L,J,KB)+PHID
               IF (NT  > 0) WIJ(L,K,KB)=PHID
               IF (I <= IABS(NCPW)) THEN
                  KK=NHPAN+NPPAN+NNPAN+(J-1)*IABS(NCPW)+I
                  SIJ(L,KK,KB)=PHIS
               END IF !(I <= IABS(NCPW))
            END DO !II=1,IABS(NCPW)
         END DO !JJ=1,NRW
!-----------------------------------------------------------------------------------------------!
      END DO !KB=1,NB
!-----------------------------------------------------------------------------------------------!
   END DO !I=1,NPW
END DO !J=1,NRW
!-----------------------------------------------------------------------------------------------!
END SUBROUTINE BLADEWAKECOEF
!-----------------------------------------------------------------------------------------------!
