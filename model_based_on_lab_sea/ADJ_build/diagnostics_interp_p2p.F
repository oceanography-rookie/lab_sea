
















C $Header: /u/gcmpack/MITgcm_contrib/SOSE/BoxAdj/code_ad/CPP_OPTIONS.h,v 1.1 2011/01/18 19:33:08 mmazloff Exp $
C $Name:  $



C CPP flags controlling particular source code features

C o Shortwave heating as extra term in external_forcing.F
C Note: this should be a run-time option

C o Include/exclude phi_hyd calculation code

C o Include/exclude call to S/R CONVECT

C o Include/exclude call to S/R CALC_DIFFUSIVITY

C o Include/exclude Implicit vertical advection code

C o Include/exclude nonHydrostatic code

C o Include pressure loading code


C o Use "Exact Convervation" of fluid in Free-Surface formulation
C   so that d/dt(eta) is exactly equal to - Div.Transport

C o Allow the use of Non-Linear Free-Surface formulation
C   this implies that surface thickness (hFactors) vary with time

C o Use "OLD" UV discretisation near boundaries (*not* recommended)
C   Note - only works with  #undef NO_SLIP_LATERAL  in calc_mom_rhs.F
C          because the old code did not have no-slip BCs

C o Execution environment support options
CBOP
C     !ROUTINE: CPP_EEOPTIONS.h
C     !INTERFACE:
C     include "CPP_EEOPTIONS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP\_EEOPTIONS.h                                         |
C     *==========================================================*
C     | C preprocessor "execution environment" supporting        |
C     | flags. Use this file to set flags controlling the        |
C     | execution environment in which a model runs - as opposed |
C     | to the dynamical problem the model solves.               |
C     | Note: Many options are implemented with both compile time|
C     |       and run-time switches. This allows options to be   |
C     |       removed altogether, made optional at run-time or   |
C     |       to be permanently enabled. This convention helps   |
C     |       with the data-dependence analysis performed by the |
C     |       adjoint model compiler. This data dependency       |
C     |       analysis can be upset by runtime switches that it  |
C     |       is unable to recoginise as being fixed for the     |
C     |       duration of an integration.                        |
C     |       A reasonable way to use these flags is to          |
C     |       set all options as selectable at runtime but then  |
C     |       once an experimental configuration has been        |
C     |       identified, rebuild the code with the appropriate  |
C     |       options set at compile time.                       |
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C=== Macro related options ===
C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working set size.
C     However, on vector CRAY systems this degrades performance.
C     Enable to switch REAL4_IS_SLOW from genmake2 (with LET_RS_BE_REAL4):

C--   Control use of "double" precision constants.
C     Use D0 where it means REAL*8 but not where it means REAL*16

C=== IO related options ===
C--   Flag used to indicate whether Fortran formatted write
C     and read are threadsafe. On SGI the routines can be thread
C     safe, on Sun it is not possible - if you are unsure then
C     undef this option.

C--   Flag used to indicate whether Binary write to Local file (i.e.,
C     a different file for each tile) and read are thread-safe.

C--   Flag to turn off the writing of error message to ioUnit zero

C--   Alternative formulation of BYTESWAP, faster than
C     compiler flag -byteswapio on the Altix.

C--   Flag to turn on old default of opening scratch files with the
C     STATUS='SCRATCH' option. This method, while perfectly FORTRAN-standard,
C     caused filename conflicts on some multi-node/multi-processor platforms
C     in the past and has been replace by something (hopefully) more robust.

C--   Flag defined for eeboot_minimal.F, eeset_parms.F and open_copy_data_file.F
C     to write STDOUT, STDERR and scratch files from process 0 only.
C WARNING: to use only when absolutely confident that the setup is working
C     since any message (error/warning/print) from any proc <> 0 will be lost.

C=== MPI, EXCH and GLOBAL_SUM related options ===
C--   Flag turns off MPI_SEND ready_to_receive polling in the
C     gather_* subroutines to speed up integrations.

C--   Control use of communication that might overlap computation.
C     Under MPI selects/deselects "non-blocking" sends and receives.
C--   Control use of communication that is atomic to computation.
C     Under MPI selects/deselects "blocking" sends and receives.

C--   Control XY periodicity in processor to grid mappings
C     Note: Model code does not need to know whether a domain is
C           periodic because it has overlap regions for every box.
C           Model assume that these values have been
C           filled in some way.

C--   disconnect tiles (no exchange between tiles, just fill-in edges
C     assuming locally periodic subdomain)

C--   Always cumulate tile local-sum in the same order by applying MPI allreduce
C     to array of tiles ; can get slower with large number of tiles (big set-up)

C--   Alternative way of doing global sum without MPI allreduce call
C     but instead, explicit MPI send & recv calls. Expected to be slower.

C--   Alternative way of doing global sum on a single CPU
C     to eliminate tiling-dependent roundoff errors. Note: This is slow.

C=== Other options (to add/remove pieces of code) ===
C--   Flag to turn on checking for errors from all threads and procs
C     (calling S/R STOP_IF_ERROR) before stopping.

C--   Control use of communication with other component:
C     allow to import and export from/to Coupler interface.


CBOP
C     !ROUTINE: CPP_EEMACROS.h
C     !INTERFACE:
C     include "CPP_EEMACROS.h"
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP_EEMACROS.h
C     *==========================================================*
C     | C preprocessor "execution environment" supporting
C     | macros. Use this file to define macros for  simplifying
C     | execution environment in which a model runs - as opposed
C     | to the dynamical problem the model solves.
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C     Flag used to indicate which flavour of multi-threading
C     compiler directives to use. Only set one of these.
C     USE_SOLARIS_THREADING  - Takes directives for SUN Workshop
C                              compiler.
C     USE_KAP_THREADING      - Takes directives for Kuck and
C                              Associates multi-threading compiler
C                              ( used on Digital platforms ).
C     USE_IRIX_THREADING     - Takes directives for SGI MIPS
C                              Pro Fortran compiler.
C     USE_EXEMPLAR_THREADING - Takes directives for HP SPP series
C                              compiler.
C     USE_C90_THREADING      - Takes directives for CRAY/SGI C90
C                              system F90 compiler.






C--   Define the mapping for the _BARRIER macro
C     On some systems low-level hardware support can be accessed through
C     compiler directives here.

C--   Define the mapping for the BEGIN_CRIT() and  END_CRIT() macros.
C     On some systems we simply execute this section only using the
C     master thread i.e. its not really a critical section. We can
C     do this because we do not use critical sections in any critical
C     sections of our code!

C--   Define the mapping for the BEGIN_MASTER_SECTION() and
C     END_MASTER_SECTION() macros. These are generally implemented by
C     simply choosing a particular thread to be "the master" and have
C     it alone execute the BEGIN_MASTER..., END_MASTER.. sections.

CcnhDebugStarts
C      Alternate form to the above macros that increments (decrements) a counter each
C      time a MASTER section is entered (exited). This counter can then be checked in barrier
C      to try and detect calls to BARRIER within single threaded sections.
C      Using these macros requires two changes to Makefile - these changes are written
C      below.
C      1 - add a filter to the CPP command to kill off commented _MASTER lines
C      2 - add a filter to the CPP output the converts the string N EWLINE to an actual newline.
C      The N EWLINE needs to be changes to have no space when this macro and Makefile changes
C      are used. Its in here with a space to stop it getting parsed by the CPP stage in these
C      comments.
C      #define IF ( a .EQ. 1 ) THEN  IF ( a .EQ. 1 ) THEN  N EWLINE      CALL BARRIER_MS(a)
C      #define ENDIF    CALL BARRIER_MU(a) N EWLINE        ENDIF
C      'CPP = cat $< | $(TOOLSDIR)/set64bitConst.sh |  grep -v '^[cC].*_MASTER' | cpp  -traditional -P'
C      .F.f:
C      $(CPP) $(DEFINES) $(INCLUDES) |  sed 's/N EWLINE/\n/' > $@
CcnhDebugEnds

C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working
C     set size. However, on vector CRAY systems this degrades
C     performance.
C- Note: global_sum/max macros were used to switch to  JAM routines (obsolete);
C  in addition, since only the R4 & R8 S/R are coded, GLOBAL RS & RL macros
C  enable to call the corresponding R4 or R8 S/R.



C- Note: a) exch macros were used to switch to  JAM routines (obsolete)
C        b) exch R4 & R8 macros are not practically used ; if needed,
C           will directly call the corrresponding S/R.

C--   Control use of JAM routines for Artic network (no longer supported)
C     These invoke optimized versions of "exchange" and "sum" that
C     utilize the programmable aspect of Artic cards.
CXXX No longer supported ; started to remove JAM routines.
CXXX #ifdef LETS_MAKE_JAM
CXXX #define CALL GLOBAL_SUM_R8 ( a, b) CALL GLOBAL_SUM_R8_JAM ( a, b)
CXXX #define CALL GLOBAL_SUM_R8 ( a, b ) CALL GLOBAL_SUM_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RS ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RL ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RS ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RL ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #endif

C--   Control use of "double" precision constants.
C     Use d0 where it means REAL*8 but not where it means REAL*16

C--   Substitue for 1.D variables
C     Sun compilers do not use 8-byte precision for literals
C     unless .Dnn is specified. CRAY vector machines use 16-byte
C     precision when they see .Dnn which runs very slowly!

C--   Set the format for writing processor IDs, e.g. in S/R eeset_parms
C     and S/R open_copy_data_file. The default of I9.9 should work for
C     a long time (until we will use 10e10 processors and more)

C--   Set the format for writing ensemble task IDs in S/R eeset_parms
C     and S/R open_copy_data_file.

C--   Set ACTION= in OPEN instruction for input file (before doing IO)
C     leave it empty (if EXCLUDE_OPEN_ACTION) or set it to proper value



C o Include/exclude code specific to the ECCO/SEALION version.
C   AUTODIFF or EXF package.
C   Currently controled by a single header file
C   For this to work, PACKAGES_CONFIG.h needs to be included!
cph#if (defined () || cph     defined () || cph     defined ())
C#include "ECCO_CPPOPTIONS.h"
cph#endif

C o Allow full 3D specification of vertical diffusivity
C - otherwise, can be turned on or off hereafter:



C     Package-specific Options & Macros go here

C allow to define specific regions and the corresponding mask ;
C  used to perform regional statistics over a limited area

C allow to stop & restart at any time (i.e. not at a multiple of
C  the diagnostics frequency) reading diagnostics storage arrays
C  from pickup file.
C Note: Use with cautious since it does not work for all restart
C  cases (e.g., changing data.diagnostics).


CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C     !ROUTINE: DIAGNOSTICS_INTERP_P2P

C     !INTERFACE:
      SUBROUTINE DIAGNOSTICS_INTERP_P2P(
     O                       qprs,
     I                       qinp,pkz,pksrf,pktop,pk,
     I                       undef, pInc,ijm,lm, myThid )

C     !DESCRIPTION:
C***********************************************************************
C
C PURPOSE
C   To interpolate an arbitrary quantity to Specified Pressure Levels
C
C INPUT
C   QINP .. QINP (ijm,lm) Arbitrary Input Quantity
C   PKZ ... PKZ  (ijm,lm) Pressure to the Kappa at Input Levels
C   PKSRF . PKSRF(ijm) Surface Pressure to the Kappa
C   PKTOP . Pressure to the Kappa at Input-Level-Edge (1) (top of model)
C   PK .... Output Pressure to the Kappa Level (mb)
C   pInc .. if True, assume pressure increases with level index
C   IJM ... Horizontal Dimension of Input
C   LM .... Vertical  Dimension of Input
C
C OUTPUT
C   QPRS .. QPRS (ijm) Arbitrary Quantity at Pressure p
C
C NOTE
C   Quantity is interpolated Linear in P**Kappa.
C   Between  PTOP**Kappa and PKZ(1),  quantity is extrapolated.
C   Between PKSRF**Kappa and PKZ(LM), quantity is extrapolated.
C   Undefined Input quantities are not used.
C   Finally: This routine assumes that pressure levels are counted
C            top down -- ie, level 1 is the top, level lm is the bottom
C
C***********************************************************************
C     !USES:
      IMPLICIT NONE

C     !INPUT PARAMETERS:
      INTEGER  ijm,lm,myThid
      Real*8  qinp (ijm,lm)
      Real*8  pkz  (ijm,lm)
      Real*8  pksrf(ijm)
      Real*8  pktop,pk
      Real*8  undef
      LOGICAL pInc

C     !OUTPUT PARAMETERS:
      Real*8  qprs (ijm)
CEOP

C     !LOCAL VARIABLES:
      INTEGER  i,l
      Real*8  pkmin,pkmax,temp

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

c Initialize to UNDEFINED
c -----------------------
      DO i=1,ijm
       qprs(i) = undef
      ENDDO

      IF ( pInc ) THEN
C---  Case where Levels are orderd by increasing pressure

c Interpolate to Pressure Between Input Levels
c --------------------------------------------
      DO L=1,lm-1
       pkmin = pkz(1,L)
       pkmax = pkz(1,L+1)

       DO i=2,ijm
         IF ( pkz(i,L)  .LT.pkmin ) pkmin = pkz(i,L)
         IF ( pkz(i,L+1).GT.pkmax ) pkmax = pkz(i,L+1)
       ENDDO

       IF ( pk.LE.pkmax .AND. pk.GE.pkmin ) THEN
         DO i=1,ijm
           IF ( pk.GE.pkz(i,L) .AND. pk.LE.pkz(i,L+1) ) THEN
             temp = ( pk-pkz(i,L) ) / ( pkz(i,L+1)-pkz(i,L) )

             IF     ( qinp(i,L)  .NE.undef  .AND.
     &                qinp(i,L+1).NE.undef ) THEN
               qprs(i) = qinp(i,L+1)*temp + qinp(i,L)*(1.-temp)
             ELSEIF ( qinp(i,L+1).NE.undef  .AND. temp.GE.0.5 ) THEN
               qprs(i) = qinp(i,L+1)
             ELSEIF ( qinp(i,L)  .NE.undef  .AND. temp.LE.0.5 ) THEN
               qprs(i) = qinp(i,L)
             ENDIF
           ENDIF
         ENDDO
       ENDIF

      ENDDO

      DO i=1,ijm
c Extrapolate to Pressure between Ptop and Highest Input Level
c ----------------------------------------------------------
       IF ( pk.LE.pkz(i,1) .AND. pk.GE.pktop ) THEN
         temp = ( pk-pkz(i,1) ) / ( pkz(i,2)-pkz(i,1) )

         IF     ( qinp(i,1).NE.undef  .AND.
     &           qinp(i,2).NE.undef ) THEN
           qprs(i) = qinp(i,2)*temp + qinp(i,1)*(1.-temp)
         ELSEIF ( qinp(i,1).NE.undef ) THEN
           qprs(i) = qinp(i,1)
         ENDIF

       ENDIF

c Extrapolate to Pressure between Psurf and Lowest Input Level
c ------------------------------------------------------------
       IF ( pk.GE.pkz(i,lm) .AND. pk.LE.pksrf(i) ) THEN
         temp = ( pk-pkz(i,lm) ) / ( pkz(i,lm-1)-pkz(i,lm) )

         IF     ( qinp(i,lm)  .NE.undef  .AND.
     &            qinp(i,lm-1).NE.undef ) THEN
            qprs(i) = qinp(i,lm-1)*temp + qinp(i,lm)*(1.-temp)
         ELSEIF ( qinp(i,lm)  .NE.undef ) THEN
            qprs(i) = qinp(i,lm)
         ENDIF

       ENDIF
      ENDDO

      ELSE
C---  Case where Levels are orderd by decreasing pressure

c Interpolate to Pressure Between Input Levels
c --------------------------------------------
      DO L=1,lm-1
       pkmin = pkz(1,L+1)
       pkmax = pkz(1,L)

       DO i=2,ijm
         IF ( pkz(i,L+1).LT.pkmin ) pkmin = pkz(i,L+1)
         IF ( pkz(i,L)  .GT.pkmax ) pkmax = pkz(i,L)
       ENDDO

       IF ( pk.LE.pkmax .AND. pk.GE.pkmin ) THEN
         DO i=1,ijm
           IF ( pk.LE.pkz(i,L) .AND. pk.GE.pkz(i,L+1) ) THEN
             temp = ( pk-pkz(i,L) ) / ( pkz(i,L+1)-pkz(i,L) )

             IF     ( qinp(i,L)  .NE.undef  .AND.
     &                qinp(i,L+1).NE.undef ) THEN
               qprs(i) = qinp(i,L+1)*temp + qinp(i,L)*(1.-temp)
             ELSEIF ( qinp(i,L+1).NE.undef  .AND. temp.GE.0.5 ) THEN
               qprs(i) = qinp(i,L+1)
             ELSEIF ( qinp(i,L)  .NE.undef  .AND. temp.LE.0.5 ) THEN
               qprs(i) = qinp(i,L)
             ENDIF
           ENDIF
         ENDDO
       ENDIF

      ENDDO

      DO i=1,ijm
c Extrapolate to Pressure between Ptop and Highest Input Level
c ----------------------------------------------------------
       IF ( pk.LE.pkz(i,lm) .AND. pk.GE.pktop ) THEN
         temp = ( pk-pkz(i,lm) ) / ( pkz(i,lm-1)-pkz(i,lm) )

         IF     ( qinp(i,lm)  .NE.undef  .AND.
     &            qinp(i,lm-1).NE.undef ) THEN
            qprs(i) = qinp(i,lm-1)*temp + qinp(i,lm)*(1.-temp)
         ELSEIF ( qinp(i,lm)  .NE.undef ) THEN
            qprs(i) = qinp(i,lm)
         ENDIF

       ENDIF

c Extrapolate to Pressure between Psurf and Lowest Input Level
c ------------------------------------------------------------
       IF ( pk.GE.pkz(i,1) .AND. pk.LE.pksrf(i) ) THEN
         temp = ( pk-pkz(i,1) ) / ( pkz(i,2)-pkz(i,1) )

         IF     ( qinp(i,1).NE.undef  .AND.
     &            qinp(i,2).NE.undef ) THEN
           qprs(i) = qinp(i,2)*temp + qinp(i,1)*(1.-temp)
         ELSEIF ( qinp(i,1).NE.undef ) THEN
           qprs(i) = qinp(i,1)
         ENDIF

       ENDIF
      ENDDO

C---  End case increasing/decreasing pressure
      ENDIF

      RETURN
      END
