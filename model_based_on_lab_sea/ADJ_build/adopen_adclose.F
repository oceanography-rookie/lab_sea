










CBOP
C !ROUTINE: AUTODIFF_OPTIONS.h
C !INTERFACE:
C #include "AUTODIFF_OPTIONS.h"

C !DESCRIPTION:
C *==================================================================*
C | CPP options file for AutoDiff (autodiff) package:
C | Control which optional features to compile in this package code.
C *==================================================================*
CEOP







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



C   ==================================================================
C-- Package-specific Options & Macros go here

C o Include/exclude code in order to be able to automatically
C   differentiate the MITgcmUV by using the Tangent Linear and
C   Adjoint Model Compiler (TAMC).

C       >>> Checkpointing as handled by TAMC

C       >>> Extract adjoint state
C       >>> and DYNVARS_DIAG adjoint state

C       >>> DO 2-level checkpointing instead of 3-level
c#undef AUTODIFF_2_LEVEL_CHECKPOINT

C extend to 4-level checkpointing
C#undef AUTODIFF_4_LEVEL_CHECKPOINT

C o use divided adjoint to split adjoint computations


C o This flag is incredibly useful as it reduces the number of
C   tape-files on the disc. Maybe it should even be the default.

C o use standard MDSFINDUINTS instead of local pkg/autodiff version for
C   WHTAPEIO code I/O.
C   Note: comment out the #define below (instead of having an #undef) to
C   enable to set this Option in CPP command line (from the optfile)
c#define AUTODIFF_USE_MDSFINDUNITS

C o use the deprecated autodiff_store/restore method where multiple fields
C   are collected in a single buffer field array before storing to tape.
C   This functionality has been replaced by WHTAPEIO method (see above).
C   Might still be used for OBCS since WHTAPEIO does not support OBCS fields.

C o allow using viscFacInAd to recompute viscosities in AD

C o for output of AD-variables (), specific code (e.g.,
C   in addummy_in_stepping.F) relies on adexch_uv_xy_rs and adexch_xy_rs S/R
C   which might not always be generated by TAF (e.g., when controls do not
C   include any 2D forcing field). In those cases, defining this cpp-option
C   allows to circumvent this missing code issue.

C   ==================================================================

c     ==================================================================
c
c     adopen_adclose.F: Routines to handle the I/O of the TAMC generated
c                       code. All files are direct access files.
c     Routines:
c
c     o  adopen  - Open file  (here a dummy routine).
c     o  adclose - Close file (here a dummy routine).
c
c
c     The following input veriables are used throughout in the argument
c     lists:
c
c     name   -  character
c                 On entry, name is the extended tape name.
c     len    -  integer
c                 On entry, len is the number of characters in name.
c     tid    -  integer
c                 On entry, tid identifies the tape.
c     vid    -  integer
c                 On entry, vid identifies the variable to be stored on
c                 the tape.
c     var    -  real array of dimension length
c                 On entry, var contains the values to be stored.
c                           var must not be changed.
c     size   -  integer
c                 On entry, size is the size in bytes of the type of
c                           variable var.
c     length -  integer
c                 On entry, length is the dimension of the variable
c                           stored on the tape.
c     irec   -  integer
c                 On entry, irec is the record number to be written.
c     mythid -  integer
c                 On entry, mythid is the number of the thread or
c                           instance of the program.
c     myiter -  integer
c                 On entry, myiter is the current iteration step during
c                           the integration.
c
c     For further details on this see the TAMC Users Manual, Appendix B,
c     User defined Storage Subroutines.
c
c     TAMC does not provide the two leading arguments mythid and myiter
c     when compiling the MITgcmUV code. Instead the is a sed script avail-
c     able that does change the TAMC-generated adjoint code.
c
c     Only the master thread is allowed to write data and only gobal
c     model arrays are allowed to be written be the subsequent routines.
c     Tiled data are to be stored in common blocks. This implies that at
c     least a two level checkpointing for the adjoint code has to be
c     available.
c
c     ==================================================================


CBOP
C     !ROUTINE: adopen
C     !INTERFACE:
      subroutine adopen(
     I                   mythid,
cph(
cph     I                   myiter,
cph)
     I                   name,
     I                   len,
     I                   tid,
     I                   vid,
     I                   size,
     I                   length
     &                 )

C     !DESCRIPTION: \bv
c     ==================================================================
c     SUBROUTINE adopen
c     ==================================================================
c     o Dummy routine expected to be available by TAMC I/O.
c     This routine is simply a dummy routine expected to be available by
c     the Tangent Linear and Adjoint Model Compiler(TAMC). Files are
c     opened and closed by the routines that are called by *adread* and
c     *adwrite*.
c     started: Christian Eckert eckert@mit.edu 30-Jun-1999
c     ==================================================================
c     SUBROUTINE adopen
c     ==================================================================
C     \ev

C     !USES:
      implicit none

c     == global variables ==

C     !INPUT/OUTPUT PARAMETERS:
c     == routine arguments ==
c     name   -  extended tape name.
c     len    -  number of characters in name.
c     tid    -  tape identifier.
c     vid    -  identifies the variable to be stored on tape.
c     size   -  size in bytes of the type of variable var.
c     length -  dimension of the variable stored on the tape.
c     mythid -  number of the thread or instance of the program.

      integer mythid
cph(
cph      integer myiter
cph)
      character*(*) name
      integer len
      integer tid
      integer vid
      integer size
      integer length

C     !LOCAL VARIABLES:
c     == local variables ==

c     == end of interface ==
CEOP

      return
      end


CBOP
C     !ROUTINE: adclose
C     !INTERFACE:
      subroutine adclose(
     I                    mythid,
cph(
cph     I                    myiter,
cph)
     I                    name,
     I                    len,
     I                    tid,
     I                    vid,
     I                    size,
     I                    length
     &                  )


C     !DESCRIPTION: \bv
c     ==================================================================
c     SUBROUTINE adclose
c     ==================================================================
c     o Dummy routine expected to be available by TAMC I/O.
c     This routine is simply a dummy routine expected to be available by
c     the Tangent Linear and Adjoint Model Compiler(TAMC). Files are
c     opened and closed by the routines that are called by *adread* and
c     *adwrite*.
c     started: Christian Eckert eckert@mit.edu 30-Jun-1999
c     ==================================================================
c     SUBROUTINE adclose
c     ==================================================================
C     \ev

C     !USES:
      implicit none

c     == global variables ==

C     !INPUT/OUTPUT PARAMETERS:
c     == routine arguments ==
c     name   -  extended tape name.
c     len    -  number of characters in name.
c     tid    -  tape identifier.
c     vid    -  identifies the variable to be stored on tape.
c     size   -  size in bytes of the type of variable var.
c     length -  dimension of the variable stored on the tape.
c     mythid -  number of the thread or instance of the program.

      integer mythid
cph(
cph      integer myiter
cph)
      character*(*) name
      integer len
      integer tid
      integer vid
      integer size
      integer length

C     !LOCAL VARIABLES:
c     == local variables ==

c     == end of interface ==
CEOP

      return
      end
