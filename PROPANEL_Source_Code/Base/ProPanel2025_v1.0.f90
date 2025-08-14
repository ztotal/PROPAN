!-----------------------------------------------------------------------------------------------!
!    PROGRAM PROPANEL : PRE-PROCESSOR FOR THE PROPAN PANEL CODE                                 !
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
!                                                                                               !
!    The program PROPANEL generates the panel distribution for:                                 !
!    1. Blade grid.                                                                             !
!    2. Blade wake grid.                                                                        !
!    3. Nozzle grid.                                                                            !
!    4. Nozzle wake grid.                                                                       !
!    5. Hub grid.                                                                               !
!                                                                                               !
!    The output panel distribution is used as input to the hydrodynamic propeller panel code    !
!    PROPAN.                                                                                    !
!                                                                                               !
!    Created by: J.A.C. Falcao de Campos, IST                                                   !
!    Modified  : 21102013, J. Baltazar, 2013 version 1.0                                        !
!    Modified  : 09052014, J. Baltazar, 2014 version 1.0                                        !
!    Modified  : 08102014, J. Baltazar, 2014 version 1.1                                        !
!    Modified  : 02122014, J. Baltazar, 2014 version 1.2                                        !
!    Modified  : 09122014, J. Baltazar, 2014 version 1.3                                        !
!    Modified  : 07012015, J. Baltazar, 2015 version 1.0                                        !
!    Modified  : 19012015, J. Baltazar, 2015 version 1.1                                        !
!    Modified  : 25062015, J. Baltazar, 2015 version 1.2                                        !
!    Modified  : 02072015, J. Baltazar, 2015 version 1.3                                        !
!    Modified  : 05072017, J. Baltazar, 2017 version 1.0                                        !
!    Modified  : 02102018, J. Baltazar, 2018 version 1.0                                        !
!    Modified  : 18042019, J. Baltazar, 2019 version 1.0                                        !
!    Modified  : 09042020, J. Baltazar, 2020 version 1.0                                        !
!    Modified  : 17062020, J. Baltazar, 2020 version 1.1                                        !
!    Modified  : 00002021, J. Baltazar, 2021 version 1.1                                        !
!    Modified  : 14082025, J. Baltazar, 2025 version 1.0                                        !
!-----------------------------------------------------------------------------------------------!
PROGRAM PROPANEL
!-----------------------------------------------------------------------------------------------!
!    Input Description                                                                          !
!                                                                                               !
!    IP          = 1: blade and blade wake panelling (0 no panelling)                           !
!    IN          = 1: nozzle and nozzle wake panelling (0 no panelling)                         !
!    IH          = 1: hub panelling (0 no panelling)                                            !
!                =-1: no-hub but closure of blade root with panels                              !
!    NB          = Number of Blades                                                             !
!-----------------------------------------------------------------------------------------------!
!    Blade Input Description                                                                    !
!                                                                                               !
!    IDENTP      = Propeller/grid identification (10 characters)                                !
!                                                                                               !
!    INTERP      = Choice on the interpolations                                                 !
!                  INTERP=0: Linear interpolation                                               !
!                  INTERP=1: Quadratic interpolation                                            !
!                  INTERP=2: Cubic interpolation                                                !
!                                                                                               !
!    RPH         = Propeller hub reference radius rh/Rp                                         !
!    RMAX        = Maximum radius of propeller for grid generation rt/Rp (default rmax = 1)     !
!                                                                                               !
!    ISC         = Chordwise coordinate                                                         !
!                  ISC=0: along section chord                                                   !
!                  ISC=1: along section geometry                                                !
!                                                                                               !
!    ALPHAH      = Angle in radial cosine distribution to control panel size at hub (in deg.)   !
!    ALPHAT      = Angle in radial cosine distribution to control panel size at tip (in deg.)   !
!    ALPHALE     = Angle in the chordwise cosine distribution to control panel size at the      !
!                  leading edge (in deg.)                                                       !
!    ALPHATE     = Angle in the chordwise cosine distribution to control panel size at the      !
!                  trailing edge (in deg.)                                                      !
!                                                                                               !
!    ISTRIP      = Input option to exclude last tip panel strip                                 !
!                  ISTRIP=0: zero and finite tip (default value)                                !
!                  ISTRIP=1: include last panel strip for gap model                             !
!                  ISTRIP=2: include last panel strip for closed tip                            !
!                                                                                               !
!    ANGPITCH    = Controlable pitch angle (in deg.)                                            !
!                                                                                               !
!    PGAP        = Pitch at gap strip (if different from blade tip pitch)                       !
!    IHCORR      = Correction to match the blade root with hub surface                          !
!                  IHCORR=0: no correction                                                      !
!                  IHCORR=1: with correction                                                    !
!                                                                                               !
!    NRP         = Number of panel strips in radial direction                                   !
!    NC          = Number of chordwise panels on each blade side                                !
!-----------------------------------------------------------------------------------------------!
!    Blade Wake Input Description                                                               !
!                                                                                               !
!    IDENTPW     = Blade wake identification (10 characters)                                    !
!                                                                                               !
!    NRIW        = Number of input radii (max 50)                                               !
!    RIW  (NRI)  = Dimensionless input radii r/Rp                                               !
!    PTW0I(NRI)  = Wake pitch at the trailing edge / Diameter (rotor)                           !
!    PTWI (NRI)  = Wake pitch at the ultimate wake / Diameter (rotor)                           !
!                                                                                               !
!    INTERPW     = Choice on the interpolations                                                 !
!                  INTERPW=0: Linear interpolation                                              !
!                  INTERPW=1: Quadratic interpolation                                           !
!                  INTERPW=2: Cubic interpolation                                               !
!                                                                                               !
!    JI          = Initial strip of the blade wake                                              !
!    JF          = Last strip of the blade wake                                                 !
!                                                                                               !
!    ITYPEPW     = Stretching function along the streamwise direction                           !
!    ST1PW       = Stretching parameter                                                         !
!    ST2PW       = Stretching parameter                                                         !
!    ST3PW       = Stretching parameter                                                         !
!    ST4PW       = Stretching parameter                                                         !
!                                                                                               !
!    IMODELPW    = Empirical Wake Model                                                         !
!                  IMODELPW=0: No wake model                                                    !
!                  IMODELPW=1: Hoshino (1989)                                                   !
!                  IMODELPW=2: Kawakita (1992)                                                  !
!                  IMODELPW=3: ProPan empirical model for ducted propellers                     !
!                  IMODELPW=4: Hermite interpolation for pitch                                  !
!                  IMODELPW=5: Linear interpolation for pitch at five (5) stations              !
!                                                                                               !
!    R0          = Hub radius (IF IMODELPW /= 0)                                                !
!    R1          = Tip radius (IF IMODELPW /= 0)                                                !
!    ADVJ        = Advance coefficient from tip radius (IF IMODELPW /= 0 and R1 = 0)            !
!    A0,A1       = Tip pitch: PT=A0+A1*SS (IF IMODELPW = 3)                                     !
!    DPTW0       = Pitch derivative at trailing edge (IF IMODELPW = 4)                          !
!    NMW         = Number of axial stations (IF IMODELPW = 5)                                   !
!    XMW(NMW)    = Axial location of the stations / Radius (rotor) (max 10) (IF IMODELPW = 5)   !
!    NRM         = Number of input radii (max 50) (IF IMODELPW = 5)                             !
!    RMW(NRM,NMW)= Dimensionless input radii r/Rp (IF IMODELPW = 5)                             !
!    PMW(NRM,NMW)= Wake pitch / Diameter (rotor) (IF IMODELPW = 5)                              !
!                                                                                               !
!    ISTEADY     = Choice on the wake                                                           !
!                  ISTEADY=0: Steady wake                                                       !
!                  ISTEADY=1: Unsteady wake based on theta                                      !
!                                                                                               !
!    NTETA       = Number of points along one revolution (IF ISTEADY = 1)                       !
!                                                                                               !
!    XPWW        = Ultimate wake station nondimensional by the propeller radius (xw/rp)         !
!    XPWT        = Length of the blade wake                                                     !
!                                                                                               !
!    INTECORR    = Radial coordinate correction due to thick nozzle at t.e.                     !
!                  INTECORR=0: No correction                                                    !
!                  INTECORR=1: Correction                                                       !
!    XI          = Initial x coordinate (IF INTECORR = 1)                                       !
!    XF          = Final x coordinate  (IF INTECORR = 0)                                        !
!                                                                                               !
!    NPW         = Number of wake panels on each strip                                          !
!    NRW         = Number of panels along the radial direction                                  !
!-----------------------------------------------------------------------------------------------!
!    Nozzle Input Description                                                                   !
!                                                                                               !
!    IDENTN      = Nozzle identification (10 characters)                                        !
!                                                                                               !
!    LD          = Length ratio of the nozzle                                                   !
!    CR          = Clearance of the nozzle / Rp                                                 !
!                                                                                               !
!    IGRIDI      = Grid topology in the inner side of the nozzle                                !
!                  IGRIDI=0: conventional topology                                              !
!                  IGRIDI=1: topology with tip section blade geometry                           !
!                                                                                               !
!    IGRIDO      = Grid topology in the outer side of the nozzle                                !
!                  IGRIDO=0: conventional topology                                              !
!                  IGRIDO=1: topology with tip section blade geometry                           !
!                                                                                               !
!    INTERN      = Choice on the interpolations                                                 !
!                  INTERN=0: Linear interpolation                                               !
!                  INTERN=1: Quadratic interpolation                                            !
!                  INTERN=2: Cubic interpolation                                                !
!                                                                                               !
!    NRNI        = Number of input points of the inner surface of the nozzle (max 50)           !
!    XIL(NRNI)   = Axial coordinates of nozzle input points at the inner side / Ln              !
!    YIL(NRNI)   = Inner coordinates of nozzle input points / Ln                                !
!                                                                                               !
!    NRNO        = Number of input points of the outer surface of the nozzle (max 50)           !
!    XOL(NRNO)   = Axial coordinates of nozzle input points at the outer side / Ln              !
!    YOL(NRNO)   = Outer coordinates of nozzle input points / Ln                                !
!                                                                                               !
!    NNT         = Number of nozzle panels on half sector: PI/NB                                !
!    NNU         = Number of nozzle panels on each strip upstream of the propeller              !
!    NND         = Number of nozzle panels on each strip downstream of the propeller            !
!                                                                                               !
!    ALPHAN      = Angle in circumferential cosine distribution (in deg.)                       !
!                  (IF ALPHAN = 0 uniform)                                                      !
!    PTN         = Pitch at blade tip                                                           !
!-----------------------------------------------------------------------------------------------!
!    Nozzle Wake Input Description                                                              !
!                                                                                               !
!    IDENTNW     = Nozzle identification (10 characters)                                        !
!                                                                                               !
!    ITYPENW     = Stretching function along the streamwise direction (IF ISTRIP /= 1)          !
!    ST1NW       = Stretching parameter (IF ISTRIP /= 1)                                        !
!    ST2NW       = Stretching parameter (IF ISTRIP /= 1)                                        !
!    ST3NW       = Stretching parameter (IF ISTRIP /= 1)                                        !
!    ST4NW       = Stretching parameter (IF ISTRIP /= 1)                                        !
!                                                                                               !
!    NNW         = Number of nozzle wake panels on each strip (IF ISTRIP /= 1)                  !
!                                                                                               !
!    ICONTRNW    = Contraction of the nozzle wake                                               !
!                  ICONTRNW=0: No contraction                                                   !
!                  ICONTRNW=1: Contraction following Hoshino (1989)                             !
!                                                                                               !
!    R2          = Radius of the far nozzle wake (IF ICONTRNW = 1)                              !
!                                                                                               !
!    XNWW        = Length of the intermediate nozzle wake                                       !
!    XNWT        = Length of the nozzle wake                                                    !
!-----------------------------------------------------------------------------------------------!
!    Hub Input Description                                                                      !
!                                                                                               !
!    IDENTH      = Hub identification (10 characters)                                           !
!                                                                                               !
!    INTERH      = Choice on the interpolations (IF IH = 1)                                     !
!                  INTERH=0: Linear interpolation                                               !
!                  INTERH=1: Quadratic interpolation                                            !
!                  INTERH=2: Cubic interpolation                                                !
!                                                                                               !
!    NHI         = Number of input points of hub (max 100) (IF IH = 1)                          !
!    XHI(NHI)    = Axial coordinates of hub input points / Rp (IF IH = 1)                       !
!    RHI(NHI)    = Radial coordinates of hub input points / Rp (IF IH = 1)                      !
!                                                                                               !
!    XH0         = Axial coordinate of hub upstream end of first panel / Rp (IF IH = 1)         !
!    XH3         = Axial coordinate of hub downstream end of last panel / Rp (IF IH = 1)        !
!    NHT         = Number of hub panels on half sector: PI/NB (IF IH = 1)                       !
!    NHU         = Number of hub panels on each strip upstream of the propeller (IF IH = 1)     !
!    NHD         = Number of hub panels on each strip downstream of the propeller (IF IH = 1)   !
!                                                                                               !
!    NHP         = Number of input point for pitch distribution (max 50) (IF IH = 1)            !
!    XHP(NHP)    = Axial coordinate of pitch distribution / Rp (IF IH = 1)                      !
!    PTH(NHP)    = Pitch distribution on the hub / Diameter (IF IH = 1)                         !
!                                                                                               !
!    IHR         = Choice on the downstream distribution (IF IH = 1)                            !
!                  IHR=0: Cosine distribution                                                   !
!                  IHR=1: Wake distribution                                                     !
!    ISTEP       = Grid halving (IF IH = 1 AND IHR = 1)                                         !
!                                                                                               !
!    ITHETA      = Theta distribution                                                           !
!                  ITHETA=0: Cosine distribution                                                !
!                  ITHETA=1: Equidistant distribution                                           !
!    ALPHAHT     = Angle of the cosine distribution (in deg.) (IF ITHETA = 0)                   !
!                                                                                               !
!    ITERH       = Maximum number of Grape iterations                                           !
!-----------------------------------------------------------------------------------------------!
!    Declarations                                                                               !
!-----------------------------------------------------------------------------------------------!
USE PROPANEL_MOD
REAL*4 :: TIME,TIME1,TIME2
!-----------------------------------------------------------------------------------------------!
NAMELIST /INPUT/ IP,IN,IH,NB,IDENTP,INTERP,RPH,RMAX,ISC,ALPHAH,ALPHAT,ALPHALE,ALPHATE,ISTRIP,  &
                 ANGPITCH,PGAP,IHCORR,NRP,NC,IDENTPW,NRIW,RIW,PTW0I,PTWI,INTERPW,JI,JF,        &
                 ITYPEPW,ST1PW,ST2PW,ST3PW,ST4PW,IMODELPW,R0,R1,ADVJ,A0,A1,DPTW0,NMW,XMW,NRM,  &
                 RMW,PMW,ISTEADY,NTETA,XPWW,XPWT,INTECORR,XI,XF,NPW,NRW,IDENTN,LD,CR,IGRIDI,   &
                 IGRIDO,INTERN,NRNI,XIL,YIL,NRNO,XOL,YOL,NNT,NNU,NND,ALPHAN,PTN,IDENTNW,       &
                 ITYPENW,ST1NW,ST2NW,ST3NW,ST4NW,NNW,ICONTRNW,R2,XNWW,XNWT,IDENTH,INTERH,NHI,  &
                 XHI,RHI,XH0,XH3,NHT,NHU,NHD,NHP,XHP,PTH,IHR,ISTEP,ITHETA,ALPHAHT,ITERH
!-----------------------------------------------------------------------------------------------!
!    Read Input                                                                                 !
!-----------------------------------------------------------------------------------------------!
CALL CPU_TIME(TIME1)
PRINT*
CALL PROGRESS(0)
OPEN(UNIT=10,FILE='PROPANEL.INP',STATUS='UNKNOWN')
READ(10,INPUT)
CLOSE(UNIT=10)
!-----------------------------------------------------------------------------------------------!
!    Initialise Variables                                                                       !
!-----------------------------------------------------------------------------------------------!
!*CALL INIVARS
!-----------------------------------------------------------------------------------------------!
!    Open Files                                                                                 !
!-----------------------------------------------------------------------------------------------!
OPEN(UNIT=20,FILE='PANELGRID.DAT',STATUS='UNKNOWN')
WRITE(20,'(A)') ' TITLE="PROPELLER"'
WRITE(20,'(A)') ' VARIABLES= "X" "Y" "Z" '
CALL PROGRESS(10)
!-----------------------------------------------------------------------------------------------!
!    Generate Blade Grid                                                                        !
!-----------------------------------------------------------------------------------------------!
IF (IP == 1) CALL BLADEGRID
CALL PROGRESS(20)
!-----------------------------------------------------------------------------------------------!
!    Generate Blade Wake Grid                                                                   !
!-----------------------------------------------------------------------------------------------!
IF (IP == 1) CALL BLADEWAKEGRID
CALL PROGRESS(40)
!-----------------------------------------------------------------------------------------------!
!    Generate Nozzle Grid                                                                       !
!-----------------------------------------------------------------------------------------------!
IF (IN == 1) CALL NOZZLEGRID
CALL PROGRESS(60)
!-----------------------------------------------------------------------------------------------!
!    Generate Nozzle Wake Grid                                                                  !
!-----------------------------------------------------------------------------------------------!
IF (IN == 1) CALL NOZZLEWAKEGRID
CALL PROGRESS(80)
!-----------------------------------------------------------------------------------------------!
!    Generate Hub Grid                                                                          !
!-----------------------------------------------------------------------------------------------!
IF (IABS(IH) == 1) CALL HUBGRID
CALL PROGRESS(90)
!-----------------------------------------------------------------------------------------------!
!    Close Files                                                                                !
!-----------------------------------------------------------------------------------------------!
CLOSE(UNIT=20)
!-----------------------------------------------------------------------------------------------!
!    Delete Variables                                                                           !
!-----------------------------------------------------------------------------------------------!
CALL DELVARS
CALL PROGRESS(100)
!-----------------------------------------------------------------------------------------------!
CALL CPU_TIME(TIME2)
TIME=TIME2-TIME1
PRINT*
IF (TIME < 60.D0) THEN
   WRITE(*,'(A,F4.1,A)')' Operation time = ',TIME,' seconds'
ELSEIF (TIME < 3600.D0) THEN
   TIME=TIME/60.D0
   WRITE(*,'(A,F4.0,A)')' Operation time = ',TIME,' minutes'
ELSE
   TIME=TIME/3600.D0
   WRITE(*,'(A,F4.0,A)')' Operation time = ',TIME,' hours'
END IF
PRINT*
!-----------------------------------------------------------------------------------------------!
END PROGRAM PROPANEL
!-----------------------------------------------------------------------------------------------!