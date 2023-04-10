










CBOP
C !ROUTINE: ECCO_OPTIONS.h
C !INTERFACE:
C #include "ECCO_OPTIONS.h"

C !DESCRIPTION:
C *==================================================================*
C | CPP options file for ECCO (ecco) package:
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




C-- Package-specific Options & Macros go here


Cc# define ALLOW_AQH_COST_CONTRIBUTION
Cc# define ALLOW_UWIND_COST_CONTRIBUTION
Cc# define ALLOW_VWIND_COST_CONTRIBUTION
Cc# define ALLOW_PRECIP_COST_CONTRIBUTION
Cc# define ALLOW_SNOWPRECIP_COST_CONTRIBUTION
Cc# define ALLOW_SWDOWN_COST_CONTRIBUTION
Cc# define ALLOW_LWDOWN_COST_CONTRIBUTION
Cc# undef ALLOW_EVAP_COST_CONTRIBUTION
Cc# define ALLOW_APRESSURE_COST_CONTRIBUTION
Cc# undef ALLOW_RUNOFF_COST_CONTRIBUTION

Cc# define ALLOW_THETA0_COST_CONTRIBUTION
Cc# define ALLOW_SALT0_COST_CONTRIBUTION
Cc# define ALLOW_THETA_COST_CONTRIBUTION
Cc# define ALLOW_SALT_COST_CONTRIBUTION
Cc# define ALLOW_SST_COST_CONTRIBUTION
Cc# define ALLOW_SSS_COST_CONTRIBUTION

CML# define ALLOW_SSH_MEAN_COST_CONTRIBUTION
CML# define ALLOW_SSH_TPANOM_COST_CONTRIBUTION
CML# define ALLOW_SSH_ERSANOM_COST_CONTRIBUTION
CML# undef  ALLOW_SPH_PROJECTION
CML# if (defined (ALLOW_SSH_MEAN_COST_CONTRIBUTION) || CML      defined (ALLOW_SSH_TPANOM_COST_CONTRIBUTION) || CML      defined (ALLOW_SSH_ERSANOM_COST_CONTRIBUTION))
CML#  define ALLOW_SSH_COST_CONTRIBUTION
CML# endif

c       >>> Open boundaries
c       >>> Make sure that  is defined!



C allow for generic cost function and integral terms
C allow for 3 dimensional generic terms

C include global mean steric sea level correction
C allow for near-shore and high-latitude altimetry

C allow for In-Situ Profiles cost function contribution

C cost function output format

C-- real options?

C include dump of snap shots for checks

cph >>>>>> !!!!!! SPECIAL SEAICE FLAG FOR TESTING !!!!!! <<<<<<
c#define SEAICE_EXCLUDE_FOR_EXACT_AD_TESTING
cph >>>>>> !!!!!! SPECIAL SEAICE FLAG FOR TESTING !!!!!! <<<<<<

C generate more text in STDOUT.0000

C allow cost function term for sigmaR

C--  fake options (only used to be printed in S/R ECCO_SUMMARY):

C allow ???
C Just do a "dry" run ( useful for testing ).
C Use the Yearly-Monthly-Daily-Stepping call tree.
C Do not call stepping
C Projection onto Spherical Harmonics

C   ==================================================================

      SUBROUTINE ECCO_SUMMARY( mythid )

c     ==================================================================
c     SUBROUTINE ecco_summary
c     ==================================================================
c
c     o Summarize the setup of the ECCO release.
c
c     ==================================================================
c     SUBROUTINE ecco_summary
c     ==================================================================

      implicit none

c     == global variables ==
CBOP
C     !ROUTINE: EEPARAMS.h
C     !INTERFACE:
C     include "EEPARAMS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | EEPARAMS.h                                               |
C     *==========================================================*
C     | Parameters for "execution environemnt". These are used   |
C     | by both the particular numerical model and the execution |
C     | environment support routines.                            |
C     *==========================================================*
CEOP

C     ========  EESIZE.h  ========================================

C     MAX_LEN_MBUF  :: Default message buffer max. size
C     MAX_LEN_FNAM  :: Default file name max. size
C     MAX_LEN_PREC  :: Default rec len for reading "parameter" files

      INTEGER MAX_LEN_MBUF
      PARAMETER ( MAX_LEN_MBUF = 512 )
      INTEGER MAX_LEN_FNAM
      PARAMETER ( MAX_LEN_FNAM = 512 )
      INTEGER MAX_LEN_PREC
      PARAMETER ( MAX_LEN_PREC = 200 )

C     MAX_NO_THREADS  :: Maximum number of threads allowed.
CC    MAX_NO_PROCS    :: Maximum number of processes allowed.
CC    MAX_NO_BARRIERS :: Maximum number of distinct thread "barriers"
      INTEGER MAX_NO_THREADS
      PARAMETER ( MAX_NO_THREADS =  4 )
c     INTEGER MAX_NO_PROCS
c     PARAMETER ( MAX_NO_PROCS   =  70000 )
c     INTEGER MAX_NO_BARRIERS
c     PARAMETER ( MAX_NO_BARRIERS = 1 )

C     Particularly weird and obscure voodoo numbers
C     lShare :: This wants to be the length in
C               [148]-byte words of the size of
C               the address "window" that is snooped
C               on an SMP bus. By separating elements in
C               the global sum buffer we can avoid generating
C               extraneous invalidate traffic between
C               processors. The length of this window is usually
C               a cache line i.e. small O(64 bytes).
C               The buffer arrays are usually short arrays
C               and are declared REAL ARRA(lShare[148],LBUFF).
C               Setting lShare[148] to 1 is like making these arrays
C               one dimensional.
      INTEGER cacheLineSize
      INTEGER lShare1
      INTEGER lShare4
      INTEGER lShare8
      PARAMETER ( cacheLineSize = 256 )
      PARAMETER ( lShare1 =  cacheLineSize )
      PARAMETER ( lShare4 =  cacheLineSize/4 )
      PARAMETER ( lShare8 =  cacheLineSize/8 )

CC    MAX_VGS  :: Maximum buffer size for Global Vector Sum
c     INTEGER MAX_VGS
c     PARAMETER ( MAX_VGS = 8192 )

C     ========  EESIZE.h  ========================================

C     Symbolic values
C     precXXXX :: precision used for I/O
      INTEGER precFloat32
      PARAMETER ( precFloat32 = 32 )
      INTEGER precFloat64
      PARAMETER ( precFloat64 = 64 )

C     Real-type constant for some frequently used simple number (0,1,2,1/2):
      Real*8     zeroRS, oneRS, twoRS, halfRS
      PARAMETER ( zeroRS = 0.0D0 , oneRS  = 1.0D0 )
      PARAMETER ( twoRS  = 2.0D0 , halfRS = 0.5D0 )
      Real*8     zeroRL, oneRL, twoRL, halfRL
      PARAMETER ( zeroRL = 0.0D0 , oneRL  = 1.0D0 )
      PARAMETER ( twoRL  = 2.0D0 , halfRL = 0.5D0 )

C     UNSET_xxx :: Used to indicate variables that have not been given a value
      Real*8  UNSET_FLOAT8
      PARAMETER ( UNSET_FLOAT8 = 1.234567D5 )
      Real*4  UNSET_FLOAT4
      PARAMETER ( UNSET_FLOAT4 = 1.234567E5 )
      Real*8     UNSET_RL
      PARAMETER ( UNSET_RL     = 1.234567D5 )
      Real*8     UNSET_RS
      PARAMETER ( UNSET_RS     = 1.234567D5 )
      INTEGER UNSET_I
      PARAMETER ( UNSET_I      = 123456789  )

C     debLevX  :: used to decide when to print debug messages
      INTEGER debLevZero
      INTEGER debLevA, debLevB,  debLevC, debLevD, debLevE
      PARAMETER ( debLevZero=0 )
      PARAMETER ( debLevA=1 )
      PARAMETER ( debLevB=2 )
      PARAMETER ( debLevC=3 )
      PARAMETER ( debLevD=4 )
      PARAMETER ( debLevE=5 )

C     SQUEEZE_RIGHT      :: Flag indicating right blank space removal
C                           from text field.
C     SQUEEZE_LEFT       :: Flag indicating left blank space removal
C                           from text field.
C     SQUEEZE_BOTH       :: Flag indicating left and right blank
C                           space removal from text field.
C     PRINT_MAP_XY       :: Flag indicating to plot map as XY slices
C     PRINT_MAP_XZ       :: Flag indicating to plot map as XZ slices
C     PRINT_MAP_YZ       :: Flag indicating to plot map as YZ slices
C     commentCharacter   :: Variable used in column 1 of parameter
C                           files to indicate comments.
C     INDEX_I            :: Variable used to select an index label
C     INDEX_J               for formatted input parameters.
C     INDEX_K
C     INDEX_NONE
      CHARACTER*(*) SQUEEZE_RIGHT
      PARAMETER ( SQUEEZE_RIGHT = 'R' )
      CHARACTER*(*) SQUEEZE_LEFT
      PARAMETER ( SQUEEZE_LEFT = 'L' )
      CHARACTER*(*) SQUEEZE_BOTH
      PARAMETER ( SQUEEZE_BOTH = 'B' )
      CHARACTER*(*) PRINT_MAP_XY
      PARAMETER ( PRINT_MAP_XY = 'XY' )
      CHARACTER*(*) PRINT_MAP_XZ
      PARAMETER ( PRINT_MAP_XZ = 'XZ' )
      CHARACTER*(*) PRINT_MAP_YZ
      PARAMETER ( PRINT_MAP_YZ = 'YZ' )
      CHARACTER*(*) commentCharacter
      PARAMETER ( commentCharacter = '#' )
      INTEGER INDEX_I
      INTEGER INDEX_J
      INTEGER INDEX_K
      INTEGER INDEX_NONE
      PARAMETER ( INDEX_I    = 1,
     &            INDEX_J    = 2,
     &            INDEX_K    = 3,
     &            INDEX_NONE = 4 )

C     EXCH_IGNORE_CORNERS :: Flag to select ignoring or
C     EXCH_UPDATE_CORNERS    updating of corners during an edge exchange.
      INTEGER EXCH_IGNORE_CORNERS
      INTEGER EXCH_UPDATE_CORNERS
      PARAMETER ( EXCH_IGNORE_CORNERS = 0,
     &            EXCH_UPDATE_CORNERS = 1 )

C     FORWARD_SIMULATION
C     REVERSE_SIMULATION
C     TANGENT_SIMULATION
      INTEGER FORWARD_SIMULATION
      INTEGER REVERSE_SIMULATION
      INTEGER TANGENT_SIMULATION
      PARAMETER ( FORWARD_SIMULATION = 0,
     &            REVERSE_SIMULATION = 1,
     &            TANGENT_SIMULATION = 2 )

C--   COMMON /EEPARAMS_L/ Execution environment public logical variables.
C     eeBootError    :: Flags indicating error during multi-processing
C     eeEndError     :: initialisation and termination.
C     fatalError     :: Flag used to indicate that the model is ended with an error
C     debugMode      :: controls printing of debug msg (sequence of S/R calls).
C     useSingleCpuIO :: When useSingleCpuIO is set, MDS_WRITE_FIELD outputs from
C                       master MPI process only. -- NOTE: read from main parameter
C                       file "data" and not set until call to INI_PARMS.
C     useSingleCpuInput :: When useSingleCpuInput is set, EXF_INTERP_READ
C                       reads forcing files from master MPI process only.
C                       -- NOTE: read from main parameter file "data"
C                          and defaults to useSingleCpuInput = useSingleCpuIO
C     printMapIncludesZeros  :: Flag that controls whether character constant
C                               map code ignores exact zero values.
C     useCubedSphereExchange :: use Cubed-Sphere topology domain.
C     useCoupler     :: use Coupler for a multi-components set-up.
C     useNEST_PARENT :: use Parent Nesting interface (pkg/nest_parent)
C     useNEST_CHILD  :: use Child  Nesting interface (pkg/nest_child)
C     useNest2W_parent :: use Parent 2-W Nesting interface (pkg/nest2w_parent)
C     useNest2W_child  :: use Child  2-W Nesting interface (pkg/nest2w_child)
C     useOASIS       :: use OASIS-coupler for a multi-components set-up.
      COMMON /EEPARAMS_L/
c    &  eeBootError, fatalError, eeEndError,
     &  eeBootError, eeEndError, fatalError, debugMode,
     &  useSingleCpuIO, useSingleCpuInput, printMapIncludesZeros,
     &  useCubedSphereExchange, useCoupler,
     &  useNEST_PARENT, useNEST_CHILD,
     &  useNest2W_parent, useNest2W_child, useOASIS,
     &  useSETRLSTK, useSIGREG
      LOGICAL eeBootError
      LOGICAL eeEndError
      LOGICAL fatalError
      LOGICAL debugMode
      LOGICAL useSingleCpuIO
      LOGICAL useSingleCpuInput
      LOGICAL printMapIncludesZeros
      LOGICAL useCubedSphereExchange
      LOGICAL useCoupler
      LOGICAL useNEST_PARENT
      LOGICAL useNEST_CHILD
      LOGICAL useNest2W_parent
      LOGICAL useNest2W_child
      LOGICAL useOASIS
      LOGICAL useSETRLSTK
      LOGICAL useSIGREG

C--   COMMON /EPARAMS_I/ Execution environment public integer variables.
C     errorMessageUnit    :: Fortran IO unit for error messages
C     standardMessageUnit :: Fortran IO unit for informational messages
C     maxLengthPrt1D :: maximum length for printing (to Std-Msg-Unit) 1-D array
C     scrUnit1      :: Scratch file 1 unit number
C     scrUnit2      :: Scratch file 2 unit number
C     eeDataUnit    :: Unit # for reading "execution environment" parameter file
C     modelDataUnit :: Unit number for reading "model" parameter file.
C     numberOfProcs :: Number of processes computing in parallel
C     pidIO         :: Id of process to use for I/O.
C     myBxLo, myBxHi :: Extents of domain in blocks in X and Y
C     myByLo, myByHi :: that each threads is responsble for.
C     myProcId      :: My own "process" id.
C     myPx          :: My X coord on the proc. grid.
C     myPy          :: My Y coord on the proc. grid.
C     myXGlobalLo   :: My bottom-left (south-west) x-index global domain.
C                      The x-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     myYGlobalLo   :: My bottom-left (south-west) y-index in global domain.
C                      The y-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     nThreads      :: No. of threads
C     nTx, nTy      :: No. of threads in X and in Y
C                      This assumes a simple cartesian gridding of the threads
C                      which is not required elsewhere but that makes it easier
C     ioErrorCount  :: IO Error Counter. Set to zero initially and increased
C                      by one every time an IO error occurs.
      COMMON /EEPARAMS_I/
     &  errorMessageUnit, standardMessageUnit, maxLengthPrt1D,
     &  scrUnit1, scrUnit2, eeDataUnit, modelDataUnit,
     &  numberOfProcs, pidIO, myProcId,
     &  myPx, myPy, myXGlobalLo, myYGlobalLo, nThreads,
     &  myBxLo, myBxHi, myByLo, myByHi,
     &  nTx, nTy, ioErrorCount
      INTEGER errorMessageUnit
      INTEGER standardMessageUnit
      INTEGER maxLengthPrt1D
      INTEGER scrUnit1
      INTEGER scrUnit2
      INTEGER eeDataUnit
      INTEGER modelDataUnit
      INTEGER ioErrorCount(MAX_NO_THREADS)
      INTEGER myBxLo(MAX_NO_THREADS)
      INTEGER myBxHi(MAX_NO_THREADS)
      INTEGER myByLo(MAX_NO_THREADS)
      INTEGER myByHi(MAX_NO_THREADS)
      INTEGER myProcId
      INTEGER myPx
      INTEGER myPy
      INTEGER myXGlobalLo
      INTEGER myYGlobalLo
      INTEGER nThreads
      INTEGER nTx
      INTEGER nTy
      INTEGER numberOfProcs
      INTEGER pidIO

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
C $Header: /u/gcmpack/MITgcm/model/inc/SIZE.h,v 1.26 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: SIZE.h
C    !INTERFACE:
C    include SIZE.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | SIZE.h Declare size of underlying computational grid.     
C     *==========================================================*
C     | The design here support a three-dimensional model grid    
C     | with indices I,J and K. The three-dimensional domain      
C     | is comprised of nPx*nSx blocks of size sNx along one axis 
C     | nPy*nSy blocks of size sNy along another axis and one     
C     | block of size Nz along the final axis.                    
C     | Blocks have overlap regions of size OLx and OLy along the 
C     | dimensions that are subdivided.                           
C     *==========================================================*
C     \ev
CEOP
C     Voodoo numbers controlling data layout.
C     sNx :: No. X points in sub-grid.
C     sNy :: No. Y points in sub-grid.
C     OLx :: Overlap extent in X.
C     OLy :: Overlat extent in Y.
C     nSx :: No. sub-grids in X.
C     nSy :: No. sub-grids in Y.
C     nPx :: No. of processes to use in X.
C     nPy :: No. of processes to use in Y.
C     Nx  :: No. points in X for the total domain.
C     Ny  :: No. points in Y for the total domain.
C     Nr  :: No. points in Z for full process domain.
      INTEGER sNx
      INTEGER sNy
      INTEGER OLx
      INTEGER OLy
      INTEGER nSx
      INTEGER nSy
      INTEGER nPx
      INTEGER nPy
      INTEGER Nx
      INTEGER Ny
      INTEGER Nr
      PARAMETER (
     &           sNx =   20,
     &           sNy =   20,
     &           OLx =   4,
     &           OLy =   4,
     &           nSx =   1,
     &           nSy =   1,
     &           nPx =   46,
     &           nPy =   36,
     &           Nx  = sNx*nSx*nPx,
     &           Ny  = sNy*nSy*nPy,
     &           Nr  =  50)

C     MAX_OLX  - Set to the maximum overlap region size of any array
C     MAX_OLY    that will be exchanged. Controls the sizing of exch
C                routine buffers.
      INTEGER MAX_OLX
      INTEGER MAX_OLY
      PARAMETER ( MAX_OLX = OLx,
     &            MAX_OLY = OLy )
      integer     nobcs
      parameter ( nobcs = 4 )

CBOP
C    !ROUTINE: ECCO_SIZE.h
C    !INTERFACE:
C #include ECCO_SIZE.h

C    !DESCRIPTION: \bv
C     ==================================================================
C     ECCO_SIZE.h
C     ==================================================================
C     Contains ECCO cost-term array dimension
C     \ev
CEOP

C     Number of User Cost terms:
C     =============================
      INTEGER NUSERCOST
      PARAMETER ( NUSERCOST=10 )

C     Number of Generic Cost terms:
C     =============================
      INTEGER NGENCOST
      PARAMETER ( NGENCOST=30 )

      INTEGER NGENCOST3D
      PARAMETER ( NGENCOST3D=6 )

      INTEGER NGENPPROC
      PARAMETER ( NGENPPROC=10 )

      INTEGER N1DDATA
      PARAMETER ( N1DDATA=300 )

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C    !ROUTINE: ECCO.h
C    !INTERFACE:
C #include ECCO.h

C    !DESCRIPTION: \bv
C     ==================================================================
C     ECCO.h
C     o Main header file for the ECCO pkg.
C       started: Christian Eckert eckert@mit.edu  23-Feb-1999
C     ==================================================================
C     \ev
CEOP

C     Version of the release and versions of used packages:
C     =====================================================
C
C     eccoVersion                - ecco release version.
C     usesCalendarVersion        - version of the calendar that has to
C                                  be used.
C     usesExternalForcingVersion - version of the external forcing that
C                                  has to be used.
C     usesAdjointSupportVersion  - version of the adjoint support routines
C                                  that have to be used.
C     usesOptimizationVersion    - version of the oof-line optimization
C                                  that has to be used.

      CHARACTER*(5) eccoVersion
      CHARACTER*(5) eccoUsesCalVersion
      CHARACTER*(5) eccoUsesExfVersion
      CHARACTER*(5) eccoUsesAdsuppVersion
      CHARACTER*(5) eccoUsesOptimVersion

      PARAMETER(    eccoVersion           = '0.1.0' )
      PARAMETER(    eccoUsesCalVersion    = '0.1.4' )
      PARAMETER(    eccoUsesExfVersion    = '0.1.1' )
      PARAMETER(    eccoUsesAdsuppVersion = '0.1.0' )
      PARAMETER(    eccoUsesOptimVersion  = '2.1.0' )

C     Experiment name:
C     ================

      COMMON /ECCO_C/
     &                expId
      CHARACTER*(10)  expId

C     Integration information:
C     ========================
C
C     nyears - number of calendar years that are affected by the
C              current integration.

      COMMON /ECCO_I/
     &                nyears, nmonths, ndays, numsteps,
     &                eccoiter, ecco_prevcall
      INTEGER nyears
      INTEGER nmonths
      INTEGER ndays
      INTEGER numsteps
      INTEGER eccoiter
      INTEGER ecco_prevcall

C     Averaging counters:
C     ===================
C
C     sum1day :: counter for the daily averaging
C     sum1mon :: counter for the monthly averaging
C     dayrec  :: number of averaged surface pressure records.
C     monrec  :: number of averaged theta and salinity records.

      COMMON /AVERAGE_I/
     &                   sum1day,sum1mon,sum1year,
     &                   dayrec,monrec,yearrec
      INTEGER sum1day
      INTEGER sum1mon
      INTEGER sum1year
      INTEGER dayrec
      INTEGER monrec
      INTEGER yearrec

C     Flags used in the model-data comparison:
C     ========================================
C
C     using_ers :: flag that indicates the use of ERS data

      COMMON /ECCO_COST_DATA_FLAGS/
     &                         using_mdt,
     &                         using_tpj,
     &                         using_topex,
     &                         using_ers,
     &                         using_gfo,
     &                         using_cost_altim,
     &                         using_cost_bp,
     &                         using_cost_sst,
     &                         using_cost_scat,
     &                         using_cost_seaice
     &                        ,using_cost_transp
      LOGICAL using_mdt
      LOGICAL using_tpj
      LOGICAL using_topex
      LOGICAL using_ers
      LOGICAL using_gfo
      LOGICAL using_cost_altim
      LOGICAL using_cost_bp
      LOGICAL using_cost_sst
      LOGICAL using_cost_scat
      LOGICAL using_cost_seaice
      LOGICAL using_cost_transp

C     Record counters relevant for the cost function evaluation.
C     ==========================================================
C
C     nyearsrec:: number of yearly records that will be generated by
C                 the current model integration.
C     nmonsrec :: number of monthly records that will be generated by
C                 the current model integration.
C     ndaysrec :: number of  daily  records that will be generated by
C                 the current model integration.

      COMMON /ECCO_I/
     &                nyearsrec,
     &                nmonsrec,
     &                ndaysrec
      INTEGER nyearsrec
      INTEGER nmonsrec
      INTEGER ndaysrec

      COMMON /ECCO_R/
     &                    m_eta, m_UE, m_VN,
     &                    m_bp,
     &                    trVol, trHeat, trSalt,
     &                    VOLsumGlob_0, VOLsumGlob,
     &                    RHOsumGlob_0, RHOsumGlob,
     &                    frame, eccoVol_0
      Real*8 VOLsumGlob_0, VOLsumGlob, RHOsumGlob_0, RHOsumGlob
      Real*8 frame   (1-OLx:sNx+OLx,1-OLy:sNy+OLy           )
      Real*8 m_eta(1-OLx:sNx+OLx,1-OLy:sNy+OLy,   nSx,nSy)
      Real*8 m_bp(1-OLx:sNx+OLx,1-OLy:sNy+OLy,   nSx,nSy)
      Real*8 m_UE (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 m_VN (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 trVol(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 trHeat(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 trSalt(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 eccoVol_0(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)

C     Two runtime parameters related to outputting sterGloH
C     ecco_output_sterGloH :: output sterGloH at each time step if true
C     ecco_keepTSeriesOutp_open :: keep the sterGloH file open if true
      COMMON /ECCO_L/
     &                ecco_output_sterGloH, ecco_keepTSeriesOutp_open
      LOGICAL ecco_output_sterGloH, ecco_keepTSeriesOutp_open

C     file precision
      COMMON /PREC_TYPE_COST/
     &                        cost_iprec
      INTEGER cost_iprec

C     empty pre/post-processing :
C     =========================
      COMMON /ECCO_NOGENCOST_C/
     &       no_preproc,
     &       no_preproc_c,
     &       no_posproc,
     &       no_posproc_c,
     &       clim_preproc,
     &       anom_preproc
      CHARACTER*(MAX_LEN_FNAM) no_preproc(NGENPPROC)
      CHARACTER*(MAX_LEN_FNAM) no_preproc_c(NGENPPROC)
      CHARACTER*(MAX_LEN_FNAM) no_posproc(NGENPPROC)
      CHARACTER*(MAX_LEN_FNAM) no_posproc_c(NGENPPROC)
      CHARACTER*(MAX_LEN_FNAM) clim_preproc(NGENPPROC)
      CHARACTER*(MAX_LEN_FNAM) anom_preproc(NGENPPROC)

      COMMON /ECCO_NOGENCOST_R/
     &       no_preproc_r, no_posproc_r
      Real*8 no_preproc_r(NGENPPROC)
      Real*8 no_posproc_r(NGENPPROC)

      COMMON /ECCO_NOGENCOST_I/
     &       no_preproc_i, no_posproc_i, clim_preproc_i
      INTEGER no_preproc_i(NGENPPROC)
      INTEGER no_posproc_i(NGENPPROC)
      INTEGER clim_preproc_i(NGENPPROC)

C     gencost common blocs:
C     =====================

C     objf_gencost :: gencost user defined contribution
      COMMON /ECCO_GENCOST_CTRL/
     &       gencost_dummy
      Real*8  gencost_dummy(NGENCOST)

      COMMON /ECCO_GENCOST_R_1/
     &       objf_gencost, num_gencost, mult_gencost, gencost_storefld,
     &       gencost_barfld, gencost_modfld, gencost_weight,
     &       gencost_mskCsurf, gencost_mskWsurf, gencost_mskSsurf,
     &       gencost_mskVertical,
     &       gencost_bar3d, gencost_mod3d, gencost_wei3d,
     &       gencost_mskC, gencost_mskW, gencost_mskS,
     &       gencost_refPressure, gencost_sigmaLow, gencost_sigmaHigh,
     &       gencost_tanhScale,
     &       gencost_spmin, gencost_spmax, gencost_spzero,
     &       gencost_period, gencost_preproc_r, gencost_posproc_r,
     &       gencost_wei1d, gencost_1ddata

      Real*8  objf_gencost(nSx,nSy,NGENCOST)
      Real*8  num_gencost(nSx,nSy,NGENCOST)
      Real*8  mult_gencost(NGENCOST)
      Real*8  gencost_spmin(NGENCOST)
      Real*8  gencost_spmax(NGENCOST)
      Real*8  gencost_spzero(NGENCOST)
      Real*8  gencost_period(NGENCOST)
      Real*8  gencost_storefld(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       nSx,nSy,NGENCOST)
      Real*8  gencost_barfld(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       nSx,nSy,NGENCOST)
      Real*8  gencost_modfld(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       nSx,nSy,NGENCOST)
      Real*8  gencost_weight(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       nSx,nSy,NGENCOST)
      Real*8  gencost_mskCsurf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       nSx,nSy,NGENCOST)
      Real*8  gencost_mskWsurf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       nSx,nSy,NGENCOST)
      Real*8  gencost_mskSsurf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       nSx,nSy,NGENCOST)
      Real*8  gencost_mskVertical(Nr,NGENCOST)
      Real*8  gencost_sigmaLow(NGENCOST)
      Real*8  gencost_sigmaHigh(NGENCOST)
      Real*8  gencost_refPressure(NGENCOST)
      Real*8  gencost_tanhScale(NGENCOST)
      Real*8  gencost_bar3d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       Nr,nSx,nSy,NGENCOST3D)
      Real*8  gencost_mod3d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       Nr,nSx,nSy,NGENCOST3D)
      Real*8  gencost_wei3d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       Nr,nSx,nSy,NGENCOST3D)
      Real*8  gencost_mskC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       Nr,nSx,nSy,NGENCOST3D)
      Real*8  gencost_mskW(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       Nr,nSx,nSy,NGENCOST3D)
      Real*8  gencost_mskS(1-OLx:sNx+OLx,1-OLy:sNy+OLy,
     &       Nr,nSx,nSy,NGENCOST3D)
      Real*8 gencost_preproc_r(NGENPPROC,NGENCOST)
      Real*8 gencost_posproc_r(NGENPPROC,NGENCOST)
      Real*8 gencost_wei1d(NGENCOST)
      Real*8 gencost_1ddata(N1DDATA, NGENCOST)

C     gencost_kLev_select :: selected vertical level of a 3D model field to use
C                            to compute a cost term contribution (default = 1).
C                            Note: currently only used in drifter velocity cost

      COMMON /ECCO_GENCOST_I_1/
     &       gencost_nrec, gencost_nrecperiod,
     &       gencost_flag, gencost_outputlevel,
     &       gencost_startdate1, gencost_startdate2,
     &       gencost_enddate1, gencost_enddate2,
     &       gencost_startdate, gencost_enddate,
     &       gencost_pointer3d, gencost_smooth2Ddiffnbt,
     &       gencost_preproc_i, gencost_posproc_i,
     &       gencost_msk_pointer3d, gencost_itracer,
     &       gencost_kLev_select

      INTEGER gencost_nrec(NGENCOST)
      INTEGER gencost_nrecperiod(NGENCOST)
      INTEGER gencost_flag(NGENCOST)
      INTEGER gencost_outputlevel(NGENCOST)
      INTEGER gencost_startdate1(NGENCOST)
      INTEGER gencost_startdate2(NGENCOST)
      INTEGER gencost_startdate(4,NGENCOST)
      INTEGER gencost_enddate1(NGENCOST)
      INTEGER gencost_enddate2(NGENCOST)
      INTEGER gencost_enddate(4,NGENCOST)
      INTEGER gencost_pointer3d(NGENCOST)
      INTEGER  gencost_smooth2Ddiffnbt(NGENCOST)
      INTEGER gencost_preproc_i(NGENPPROC,NGENCOST)
      INTEGER gencost_posproc_i(NGENPPROC,NGENCOST)
      INTEGER gencost_msk_pointer3d(NGENCOST)
      INTEGER gencost_itracer(NGENCOST)
      INTEGER gencost_kLev_select(NGENCOST)

      COMMON /ECCO_GENCOST_L_1/
     &       gencost_timevaryweight, gencost_barskip,
     &       using_gencost, gencost_is3d, gencost_msk_is3d,
     &       gencost_is1d, gencost_useDensityMask
      LOGICAL using_gencost(NGENCOST)
      LOGICAL gencost_is3d(NGENCOST)
      LOGICAL gencost_is1d(NGENCOST)
      LOGICAL gencost_msk_is3d(NGENCOST)
      LOGICAL gencost_useDensityMask(NGENCOST)
      LOGICAL gencost_timevaryweight(NGENCOST)
      LOGICAL gencost_barskip(NGENCOST)

      COMMON /ECCO_GENCOST_C/
     &       gencost_name,
     &       gencost_scalefile,
     &       gencost_errfile,
     &       gencost_datafile,
     &       gencost_barfile,
     &       gencost_avgperiod,
     &       gencost_preproc,
     &       gencost_preproc_c,
     &       gencost_posproc,
     &       gencost_posproc_c,
     &       gencost_mask
      CHARACTER*(MAX_LEN_FNAM) gencost_name(NGENCOST)
      CHARACTER*(MAX_LEN_FNAM) gencost_scalefile(NGENCOST)
      CHARACTER*(MAX_LEN_FNAM) gencost_errfile(NGENCOST)
      CHARACTER*(MAX_LEN_FNAM) gencost_datafile(NGENCOST)
      CHARACTER*(MAX_LEN_FNAM) gencost_barfile(NGENCOST)
      CHARACTER*(5)            gencost_avgperiod(NGENCOST)
      CHARACTER*(MAX_LEN_FNAM) gencost_preproc(NGENPPROC,NGENCOST)
      CHARACTER*(MAX_LEN_FNAM) gencost_posproc_c(NGENPPROC,NGENCOST)
      CHARACTER*(MAX_LEN_FNAM) gencost_posproc(NGENPPROC,NGENCOST)
      CHARACTER*(MAX_LEN_FNAM) gencost_preproc_c(NGENPPROC,NGENCOST)
      CHARACTER*(MAX_LEN_FNAM) gencost_mask(NGENCOST)


C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

c     == routine arguments ==
c     integer mythid - thread number for this instance of the routine.
      integer mythid

c     == local variables ==
      character*(max_len_mbuf) msgbuf
      integer k, k2, il, msgunit

c     == external ==
      integer  ilnblnk
      external ilnblnk

c     == end of interface ==

      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ECCO configuration >>> START <<<'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)

      msgunit=standardmessageunit
c--
      write(msgbuf,'(a)') ' '
      call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
c--
      do k = 1, NGENCOST
       if (using_gencost(k)) then
c
        il = ilnblnk(gencost_name(k))
        write(msgbuf,'(a,i2,a,a)') 'gencost(',k,
     &        ') = ',gencost_name(k)(1:il)
        call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a)') '-------------'
        call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
c
        if ( gencost_datafile(k) .ne. ' ' ) then
         il = ilnblnk(gencost_datafile(k))
         write(msgbuf,'(a,a)') ' data file = ',gencost_datafile(k)(1:il)
         call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
        endif
c
         if (gencost_nrec(k).GT.1) then
          write(msgbuf,'(a)') '  starts and ends at : '
          call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
          CALL CAL_PRINTDATE(gencost_startdate(1,k),mythid)
          CALL CAL_PRINTDATE(gencost_enddate(1,k),mythid)
          write(msgbuf,'(a,i5)') '  number of records = ',
     &                            gencost_nrec(k)
          call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
         endif
c
         il = ilnblnk(gencost_barfile(k))
         write(msgbuf,'(a,a)') ' model file = ',gencost_barfile(k)(1:il)
         call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
         if ((gencost_barfile(k)(1:9).EQ.'m_ptracer').OR.
     &       (gencost_barfile(k)(1:17).EQ.'m_boxmean_ptracer')) then
           write(msgbuf,'(a,i2)') ' gencost_itracer = ',
     &           gencost_itracer(k)
           call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
         endif
         il = ilnblnk(gencost_errfile(k))
         write(msgbuf,'(a,a)') ' error file = ',gencost_errfile(k)(1:il)
         call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
         if (gencost_scalefile(k).NE.' ') then
         il = ilnblnk(gencost_scalefile(k))
         write(msgbuf,'(a,a)') ' scale file = ',
     &        gencost_scalefile(k)(1:il)
         call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
         endif
         do k2 = 1, NGENPPROC
          if (gencost_preproc(k2,k).NE.' ') then
            il = ilnblnk(gencost_preproc(k2,k))
            write(msgbuf,'(a,a)') ' preprocess = ',
     &                            gencost_preproc(k2,k)(1:il)
            call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
          endif
          if (gencost_posproc(k2,k).NE.' ') then
            il = ilnblnk(gencost_posproc(k2,k))
            write(msgbuf,'(a,a)') ' posprocess = ',
     &                            gencost_posproc(k2,k)(1:il)
            call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
          endif
         enddo
c
         write(msgbuf,'(a,i2)') ' gencost_flag = ',gencost_flag(k)
         call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
         write(msgbuf,'(a,i2)') ' gencost_outputlevel = ',
     &         gencost_outputlevel(k)
         call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
         write(msgbuf,'(a,i2)') ' gencost_kLev_select = ',
     &         gencost_kLev_select(k)
         call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
c
         if (gencost_is3d(k)) then
         write(msgbuf,'(a,i2)') ' gencost_pointer3d = ',
     &         gencost_pointer3d(k)
         call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
         endif
         if (gencost_timevaryweight(k)) then
         write(msgbuf,'(a,L2)') ' time varia. weight = ',
     &         gencost_timevaryweight(k)
         call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
         endif
         if (gencost_barskip(k)) then
         write(msgbuf,'(a,L2)') ' skip barfile write = ',
     &         gencost_barskip(k)
         call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
         endif

        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)
c
       endif
      enddo
c--
      write(msgbuf,'(a)') ' '
      call print_message( msgbuf, msgunit, SQUEEZE_RIGHT , mythid)

      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ECCO configuration  >>> END <<<'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)

      RETURN
      END
