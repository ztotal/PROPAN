#!/bin/bash
# clean
mkdir -p Code
rm -f Code/*.*
rm -f ProPanel2025_v1.0_debug.out
# Source Folder
ifort -c -check bounds -traceback -fltconsistency -fpe0 Base/propanel_mod.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Base/ProPanel2025_v1.0.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Base/delvars.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Base/progress.f90
# Grids Folder
ifort -c -check bounds -traceback -fltconsistency -fpe0 Grids/bladegrid.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Grids/bladewakegrid.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Grids/nozzlegrid.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Grids/nozzlewakegrid.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Grids/nozzledef.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Grids/hubgrid.f90
cp Grids/geoduct37.o .
# Grape Folder
cp Grape/angri.o .
cp Grape/bord.o .
cp Grape/calcb.o .
cp Grape/calphi.o .
cp Grape/coef.o .
cp Grape/grape.o .
cp Grape/guessa.o .
cp Grape/rhs.o .
cp Grape/sip.o .
cp Grape/splin.o .
# Calc Folder
ifort -c -check bounds -traceback -fltconsistency -fpe0 Calc/linint.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Calc/intk1.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Calc/splint.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Calc/stret_choice.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Calc/dscal.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Calc/stret.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Calc/stret2.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Calc/sxx.f90
ifort -c -check bounds -traceback -fltconsistency -fpe0 Calc/shxx.f90
cp Calc/spline.o .
cp Calc/ispline.o .
# Linpack Folder
ifort -c -check bounds -traceback -fltconsistency -fpe0 Linpack/cubspl.f
ifort -c -check bounds -traceback -fltconsistency -fpe0 Linpack/ppvalu.f
ifort -c -check bounds -traceback -fltconsistency -fpe0 Linpack/interv.f
# Executable
ifort -o ProPanel2025_v1.0_debug.out *.o
mv *.o Code
mv *.mod Code
if [ -f ProPanel2025_v1.0_debug.out ]; then
   cp ProPanel2025_v1.0_debug.out Code
fi
