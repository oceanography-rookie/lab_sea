










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

      subroutine cost_gencost_sshv4(
     I                        myThid )

c     ==================================================================
c     SUBROUTINE cost_gencost_sshv4
c     ==================================================================
c
c     o Evaluate cost function contributions of sea surface height.
c
c        started: Gael Forget, Oct-2009
c
c        working assumption for the time mean dynamic topography (MDT)
c        constraint: the various SLA data sets (tp, ers, gfo) have been
c        consistenty cross-referenced, as done in the RADS data sets. We
c        do not need to know the reference dynamic topography (or
c        SSH/Geoid). Simply it is assumed that the biases between
c        instruments have been taken care of. This is only a matter for
c        the MDT constraint, not for SLA constraints (see below).
c
cgf 1) there are a few hardcoded numbers that will eventually be put in common
cgf     blocks/namelists
cgf 2) there are a several refinements that should be considered, such as
cgf     modulating weights with respect to numbers of samples
c
c     ==================================================================
c     SUBROUTINE cost_gencost_sshv4
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

C

CBOP
C     !ROUTINE: PARAMS.h
C     !INTERFACE:
C     #include PARAMS.h

C     !DESCRIPTION:
C     Header file defining model "parameters".  The values from the
C     model standard input file are stored into the variables held
C     here. Notes describing the parameters can also be found here.

CEOP

C--   Contants
C     Useful physical values
      Real*8 PI
      PARAMETER ( PI    = 3.14159265358979323844d0   )
      Real*8 deg2rad
      PARAMETER ( deg2rad = 2.d0*PI/360.d0           )

C--   COMMON /PARM_C/ Character valued parameters used by the model.
C     buoyancyRelation :: Flag used to indicate which relation to use to
C                         get buoyancy.
C     eosType         :: choose the equation of state:
C                        LINEAR, POLY3, UNESCO, JMD95Z, JMD95P, MDJWF, IDEALGAS
C     pickupSuff      :: force to start from pickup files (even if nIter0=0)
C                        and read pickup files with this suffix (max 10 Char.)
C     mdsioLocalDir   :: read-write tiled file from/to this directory name
C                        (+ 4 digits Processor-Rank) instead of current dir.
C     adTapeDir       :: read-write checkpointing tape files from/to this
C                        directory name instead of current dir. Conflicts
C                        mdsioLocalDir, so only one of the two can be set.
C     tRefFile      :: File containing reference Potential Temperat.  tRef (1.D)
C     sRefFile      :: File containing reference salinity/spec.humid. sRef (1.D)
C     rhoRefFile    :: File containing reference density profile rhoRef (1.D)
C     gravityFile   :: File containing gravity vertical profile (1.D)
C     delRFile      :: File containing vertical grid spacing delR  (1.D array)
C     delRcFile     :: File containing vertical grid spacing delRc (1.D array)
C     hybSigmFile   :: File containing hybrid-sigma vertical coord. coeff. (2x 1.D)
C     delXFile      :: File containing X-spacing grid definition (1.D array)
C     delYFile      :: File containing Y-spacing grid definition (1.D array)
C     horizGridFile :: File containing horizontal-grid definition
C                        (only when using curvilinear_grid)
C     bathyFile       :: File containing bathymetry. If not defined bathymetry
C                        is taken from inline function.
C     topoFile        :: File containing the topography of the surface (unit=m)
C                        (mainly used for the atmosphere = ground height).
C     addWwallFile    :: File containing 2-D additional Western  cell-edge wall
C     addSwallFile    :: File containing 2-D additional Southern cell-edge wall
C                        (e.g., to add "thin-wall" where it is =1)
C     hydrogThetaFile :: File containing initial hydrographic data (3-D)
C                        for potential temperature.
C     hydrogSaltFile  :: File containing initial hydrographic data (3-D)
C                        for salinity.
C     diffKrFile      :: File containing 3D specification of vertical diffusivity
C     viscAhDfile     :: File containing 3D specification of horizontal viscosity
C     viscAhZfile     :: File containing 3D specification of horizontal viscosity
C     viscA4Dfile     :: File containing 3D specification of horizontal viscosity
C     viscA4Zfile     :: File containing 3D specification of horizontal viscosity
C     zonalWindFile   :: File containing zonal wind data
C     meridWindFile   :: File containing meridional wind data
C     thetaClimFile   :: File containing surface theta climataology used
C                        in relaxation term -lambda(theta-theta*)
C     saltClimFile    :: File containing surface salt climataology used
C                        in relaxation term -lambda(salt-salt*)
C     surfQfile       :: File containing surface heat flux, excluding SW
C                        (old version, kept for backward compatibility)
C     surfQnetFile    :: File containing surface net heat flux
C     surfQswFile     :: File containing surface shortwave radiation
C     EmPmRfile       :: File containing surface fresh water flux
C           NOTE: for backward compatibility EmPmRfile is specified in
C                 m/s when using external_fields_load.F.  It is converted
C                 to kg/m2/s by multiplying by rhoConstFresh.
C     saltFluxFile    :: File containing surface salt flux
C     pLoadFile       :: File containing pressure loading
C     geoPotAnomFile  :: File containing constant geopotential anomaly due to
C                        density structure
C     addMassFile     :: File containing source/sink of fluid in the interior
C     eddyPsiXFile    :: File containing zonal Eddy streamfunction data
C     eddyPsiYFile    :: File containing meridional Eddy streamfunction data
C     geothermalFile  :: File containing geothermal heat flux
C     lambdaThetaFile :: File containing SST relaxation coefficient
C     lambdaSaltFile  :: File containing SSS relaxation coefficient
C     wghtBalanceFile :: File containing weight used in balancing net EmPmR
C     the_run_name    :: string identifying the name of the model "run"
      COMMON /PARM_C/
     &                buoyancyRelation, eosType,
     &                pickupSuff, mdsioLocalDir, adTapeDir,
     &                tRefFile, sRefFile, rhoRefFile, gravityFile,
     &                delRFile, delRcFile, hybSigmFile,
     &                delXFile, delYFile, horizGridFile,
     &                bathyFile, topoFile, addWwallFile, addSwallFile,
     &                viscAhDfile, viscAhZfile,
     &                viscA4Dfile, viscA4Zfile,
     &                hydrogThetaFile, hydrogSaltFile, diffKrFile,
     &                zonalWindFile, meridWindFile, thetaClimFile,
     &                saltClimFile,
     &                EmPmRfile, saltFluxFile,
     &                surfQfile, surfQnetFile, surfQswFile,
     &                uVelInitFile, vVelInitFile, pSurfInitFile,
     &                pLoadFile, geoPotAnomFile, addMassFile,
     &                eddyPsiXFile, eddyPsiYFile, geothermalFile,
     &                lambdaThetaFile, lambdaSaltFile, wghtBalanceFile,
     &                the_run_name
      CHARACTER*(MAX_LEN_FNAM) buoyancyRelation
      CHARACTER*(6)  eosType
      CHARACTER*(10) pickupSuff
      CHARACTER*(MAX_LEN_FNAM) mdsioLocalDir
      CHARACTER*(MAX_LEN_FNAM) adTapeDir
      CHARACTER*(MAX_LEN_FNAM) tRefFile
      CHARACTER*(MAX_LEN_FNAM) sRefFile
      CHARACTER*(MAX_LEN_FNAM) rhoRefFile
      CHARACTER*(MAX_LEN_FNAM) gravityFile
      CHARACTER*(MAX_LEN_FNAM) delRFile
      CHARACTER*(MAX_LEN_FNAM) delRcFile
      CHARACTER*(MAX_LEN_FNAM) hybSigmFile
      CHARACTER*(MAX_LEN_FNAM) delXFile
      CHARACTER*(MAX_LEN_FNAM) delYFile
      CHARACTER*(MAX_LEN_FNAM) horizGridFile
      CHARACTER*(MAX_LEN_FNAM) bathyFile, topoFile
      CHARACTER*(MAX_LEN_FNAM) addWwallFile, addSwallFile
      CHARACTER*(MAX_LEN_FNAM) hydrogThetaFile, hydrogSaltFile
      CHARACTER*(MAX_LEN_FNAM) diffKrFile
      CHARACTER*(MAX_LEN_FNAM) viscAhDfile
      CHARACTER*(MAX_LEN_FNAM) viscAhZfile
      CHARACTER*(MAX_LEN_FNAM) viscA4Dfile
      CHARACTER*(MAX_LEN_FNAM) viscA4Zfile
      CHARACTER*(MAX_LEN_FNAM) zonalWindFile
      CHARACTER*(MAX_LEN_FNAM) meridWindFile
      CHARACTER*(MAX_LEN_FNAM) thetaClimFile
      CHARACTER*(MAX_LEN_FNAM) saltClimFile
      CHARACTER*(MAX_LEN_FNAM) surfQfile
      CHARACTER*(MAX_LEN_FNAM) surfQnetFile
      CHARACTER*(MAX_LEN_FNAM) surfQswFile
      CHARACTER*(MAX_LEN_FNAM) EmPmRfile
      CHARACTER*(MAX_LEN_FNAM) saltFluxFile
      CHARACTER*(MAX_LEN_FNAM) uVelInitFile
      CHARACTER*(MAX_LEN_FNAM) vVelInitFile
      CHARACTER*(MAX_LEN_FNAM) pSurfInitFile
      CHARACTER*(MAX_LEN_FNAM) pLoadFile
      CHARACTER*(MAX_LEN_FNAM) geoPotAnomFile
      CHARACTER*(MAX_LEN_FNAM) addMassFile
      CHARACTER*(MAX_LEN_FNAM) eddyPsiXFile
      CHARACTER*(MAX_LEN_FNAM) eddyPsiYFile
      CHARACTER*(MAX_LEN_FNAM) geothermalFile
      CHARACTER*(MAX_LEN_FNAM) lambdaThetaFile
      CHARACTER*(MAX_LEN_FNAM) lambdaSaltFile
      CHARACTER*(MAX_LEN_FNAM) wghtBalanceFile
      CHARACTER*(MAX_LEN_PREC/2) the_run_name

C--   COMMON /PARM_I/ Integer valued parameters used by the model.
C     cg2dMaxIters        :: Maximum number of iterations in the
C                            two-dimensional con. grad solver.
C     cg2dMinItersNSA     :: Minimum number of iterations in the
C                            not-self-adjoint version (cg2d_nsa.F) of the
C                            two-dimensional con. grad solver (default = 0).
C     cg2dPreCondFreq     :: Frequency for updating cg2d preconditioner
C                            (non-linear free-surf.)
C     cg2dUseMinResSol    :: =0 : use last-iteration/converged solution
C                            =1 : use solver minimum-residual solution
C     cg3dMaxIters        :: Maximum number of iterations in the
C                            three-dimensional con. grad solver.
C     printResidualFreq   :: Frequency for printing residual in CG iterations
C     nIter0              :: Start time-step number of for this run
C     nTimeSteps          :: Number of timesteps to execute
C     nTimeSteps_l2       :: Number of inner timesteps to execute per timestep
C     selectCoriMap       :: select setting of Coriolis parameter map:
C                           =0 f-Plane (Constant Coriolis, = f0)
C                           =1 Beta-Plane Coriolis (= f0 + beta.y)
C                           =2 Spherical Coriolis (= 2.omega.sin(phi))
C                           =3 Read Coriolis 2-d fields from files.
C     selectSigmaCoord    :: option related to sigma vertical coordinate
C     nonlinFreeSurf      :: option related to non-linear free surface
C                           =0 Linear free surface ; >0 Non-linear
C     select_rStar        :: option related to r* vertical coordinate
C                           =0 (default) use r coord. ; > 0 use r*
C     selectNHfreeSurf    :: option for Non-Hydrostatic (free-)Surface formulation:
C                           =0 (default) hydrostatic surf. ; > 0 add NH effects.
C     selectP_inEOS_Zc    :: select which pressure to use in EOS (for z-coords)
C                           =0: simply: -g*rhoConst*z
C                           =1: use pRef = integral{-g*rho(Tref,Sref,pRef)*dz}
C                           =2: use hydrostatic dynamical pressure
C                           =3: use full (Hyd+NH) dynamical pressure
C     selectAddFluid      :: option to add mass source/sink of fluid in the interior
C                            (3-D generalisation of oceanic real-fresh water flux)
C                           =0 off ; =1 add fluid ; =-1 virtual flux (no mass added)
C     selectBalanceEmPmR  :: option to balance net surface fresh-water flux:
C                           =0 off ; =1 uniform correction ; = 2 weighted correction
C     selectImplicitDrag  :: select Implicit treatment of bottom/top drag
C                           = 0: fully explicit
C                           = 1: implicit on provisional velocity
C                                (i.e., before grad.Eta increment)
C                           = 2: fully implicit (combined with Impl Surf.Press)
C     momForcingOutAB     :: =1: take momentum forcing contribution
C                            out of (=0: in) Adams-Bashforth time stepping.
C     tracForcingOutAB    :: =1: take tracer (Temp,Salt,pTracers) forcing contribution
C                            out of (=0: in) Adams-Bashforth time stepping.
C     tempAdvScheme       :: Temp. Horiz.Advection scheme selector
C     tempVertAdvScheme   :: Temp. Vert. Advection scheme selector
C     saltAdvScheme       :: Salt. Horiz.advection scheme selector
C     saltVertAdvScheme   :: Salt. Vert. Advection scheme selector
C     selectKEscheme      :: Kinetic Energy scheme selector (Vector Inv.)
C     selectVortScheme    :: Scheme selector for Vorticity term (Vector Inv.)
C     selectCoriScheme    :: Scheme selector for Coriolis term
C     selectBotDragQuadr  :: quadratic bottom drag discretisation option:
C                           =0: average KE from grid center to U & V location
C                           =1: use local velocity norm @ U & V location
C                           =2: same with wet-point averaging of other component
C     pCellMix_select     :: select option to enhance mixing near surface & bottom
C                            unit digit: near bottom ; tens digit: near surface
C                            with digit =0 : disable ;
C                           = 1 : increases mixing linearly with recip_hFac
C                           = 2,3,4 : increases mixing by recip_hFac^(2,3,4)
C     readBinaryPrec      :: Precision used for reading binary files
C     writeStatePrec      :: Precision used for writing model state.
C     writeBinaryPrec     :: Precision used for writing binary files
C     rwSuffixType        :: controls the format of the mds file suffix.
C                          =0 (default): use iteration number (myIter, I10.10);
C                          =1: 100*myTime (100th sec); =2: myTime (seconds);
C                          =3: myTime/360 (10th of hr); =4: myTime/3600 (hours).
C     monitorSelect       :: select group of variables to monitor
C                            =1 : dynvars ; =2 : + vort ; =3 : + surface
C-    debugLevel          :: controls printing of algorithm intermediate results
C                            and statistics ; higher -> more writing
C-    plotLevel           :: controls printing of field maps ; higher -> more flds

      COMMON /PARM_I/
     &        cg2dMaxIters, cg2dMinItersNSA,
     &        cg2dPreCondFreq, cg2dUseMinResSol,
     &        cg3dMaxIters, printResidualFreq,
     &        nIter0, nTimeSteps, nTimeSteps_l2, nEndIter,
     &        selectCoriMap,
     &        selectSigmaCoord,
     &        nonlinFreeSurf, select_rStar,
     &        selectNHfreeSurf, selectP_inEOS_Zc,
     &        selectAddFluid, selectBalanceEmPmR, selectImplicitDrag,
     &        momForcingOutAB, tracForcingOutAB,
     &        tempAdvScheme, tempVertAdvScheme,
     &        saltAdvScheme, saltVertAdvScheme,
     &        selectKEscheme, selectVortScheme, selectCoriScheme,
     &        selectBotDragQuadr, pCellMix_select,
     &        readBinaryPrec, writeBinaryPrec, writeStatePrec,
     &        rwSuffixType, monitorSelect, debugLevel, plotLevel
      INTEGER cg2dMaxIters
      INTEGER cg2dMinItersNSA
      INTEGER cg2dPreCondFreq
      INTEGER cg2dUseMinResSol
      INTEGER cg3dMaxIters
      INTEGER printResidualFreq
      INTEGER nIter0
      INTEGER nTimeSteps
      INTEGER nTimeSteps_l2
      INTEGER nEndIter
      INTEGER selectCoriMap
      INTEGER selectSigmaCoord
      INTEGER nonlinFreeSurf
      INTEGER select_rStar
      INTEGER selectNHfreeSurf
      INTEGER selectP_inEOS_Zc
      INTEGER selectAddFluid
      INTEGER selectBalanceEmPmR
      INTEGER selectImplicitDrag
      INTEGER momForcingOutAB, tracForcingOutAB
      INTEGER tempAdvScheme, tempVertAdvScheme
      INTEGER saltAdvScheme, saltVertAdvScheme
      INTEGER selectKEscheme
      INTEGER selectVortScheme
      INTEGER selectCoriScheme
      INTEGER selectBotDragQuadr
      INTEGER pCellMix_select
      INTEGER readBinaryPrec
      INTEGER writeStatePrec
      INTEGER writeBinaryPrec
      INTEGER rwSuffixType
      INTEGER monitorSelect
      INTEGER debugLevel
      INTEGER plotLevel

C--   COMMON /PARM_L/ Logical valued parameters used by the model.
C- Coordinate + Grid params:
C     fluidIsAir       :: Set to indicate that the fluid major constituent
C                         is air
C     fluidIsWater     :: Set to indicate that the fluid major constituent
C                         is water
C     usingPCoords     :: Set to indicate that we are working in a pressure
C                         type coordinate (p or p*).
C     usingZCoords     :: Set to indicate that we are working in a height
C                         type coordinate (z or z*)
C     usingCartesianGrid :: If TRUE grid generation will be in a cartesian
C                           coordinate frame.
C     usingSphericalPolarGrid :: If TRUE grid generation will be in a
C                                spherical polar frame.
C     rotateGrid      :: rotate grid coordinates to geographical coordinates
C                        according to Euler angles phiEuler, thetaEuler, psiEuler
C     usingCylindricalGrid :: If TRUE grid generation will be Cylindrical
C     usingCurvilinearGrid :: If TRUE, use a curvilinear grid (to be provided)
C     hasWetCSCorners :: domain contains CS-type corners where dynamics is solved
C     deepAtmosphere :: deep model (drop the shallow-atmosphere approximation)
C     setInterFDr    :: set Interface depth (put cell-Center at the middle)
C     setCenterDr    :: set cell-Center depth (put Interface at the middle)
C     useMin4hFacEdges :: set hFacW,hFacS as minimum of adjacent hFacC factor
C     interViscAr_pCell :: account for partial-cell in interior vert. viscosity
C     interDiffKr_pCell :: account for partial-cell in interior vert. diffusion
C- Momentum params:
C     no_slip_sides  :: Impose "no-slip" at lateral boundaries.
C     no_slip_bottom :: Impose "no-slip" at bottom boundary.
C     bottomVisc_pCell :: account for partial-cell in bottom visc. (no-slip BC)
C     useSmag3D      :: Use isotropic 3-D Smagorinsky
C     useFullLeith   :: Set to true to use full Leith viscosity(may be unstable
C                       on irregular grids)
C     useStrainTensionVisc:: Set to true to use Strain-Tension viscous terms
C     useAreaViscLength :: Set to true to use old scaling for viscous lengths,
C                          e.g., L2=Raz.  May be preferable for cube sphere.
C     momViscosity  :: Flag which turns momentum friction terms on and off.
C     momAdvection  :: Flag which turns advection of momentum on and off.
C     momForcing    :: Flag which turns external forcing of momentum on and off.
C     momTidalForcing    :: Flag which turns tidal forcing on and off.
C     momPressureForcing :: Flag which turns pressure term in momentum equation
C                          on and off.
C     metricTerms   :: Flag which turns metric terms on or off.
C     useNHMTerms   :: If TRUE use non-hydrostatic metric terms.
C     useCoriolis   :: Flag which turns the coriolis terms on and off.
C     use3dCoriolis :: Turns the 3-D coriolis terms (in Omega.cos Phi) on - off
C     useCDscheme   :: use CD-scheme to calculate Coriolis terms.
C     vectorInvariantMomentum :: use Vector-Invariant form (mom_vecinv package)
C                                (default = F = use mom_fluxform package)
C     useJamartMomAdv :: Use wet-point method for V.I. non-linear term
C     upwindVorticity :: bias interpolation of vorticity in the Coriolis term
C     highOrderVorticity :: use 3rd/4th order interp. of vorticity (V.I., advection)
C     useAbsVorticity :: work with f+zeta in Coriolis terms
C     upwindShear     :: use 1rst order upwind interp. (V.I., vertical advection)
C     momStepping    :: Turns momentum equation time-stepping off
C     calc_wVelocity :: Turns vertical velocity calculation off
C- Temp. & Salt params:
C     tempStepping   :: Turns temperature equation time-stepping on/off
C     saltStepping   :: Turns salinity equation time-stepping on/off
C     addFrictionHeating :: account for frictional heating
C     temp_stayPositive :: use Smolarkiewicz Hack to ensure Temp stays positive
C     salt_stayPositive :: use Smolarkiewicz Hack to ensure Salt stays positive
C     tempAdvection  :: Flag which turns advection of temperature on and off.
C     tempVertDiff4  :: use vertical bi-harmonic diffusion for temperature
C     tempIsActiveTr :: Pot.Temp. is a dynamically active tracer
C     tempForcing    :: Flag which turns external forcing of temperature on/off
C     saltAdvection  :: Flag which turns advection of salinity on and off.
C     saltVertDiff4  :: use vertical bi-harmonic diffusion for salinity
C     saltIsActiveTr :: Salinity  is a dynamically active tracer
C     saltForcing    :: Flag which turns external forcing of salinity on/off
C     maskIniTemp    :: apply mask to initial Pot.Temp.
C     maskIniSalt    :: apply mask to initial salinity
C     checkIniTemp   :: check for points with identically zero initial Pot.Temp.
C     checkIniSalt   :: check for points with identically zero initial salinity
C- Pressure solver related parameters (PARM02)
C     useNSACGSolver :: Set to true to use "not self-adjoint" conjugate
C                       gradient solver that stores the iteration history
C                       for an iterative adjoint as accuate as possible
C     useSRCGSolver  :: Set to true to use conjugate gradient
C                       solver with single reduction (only one call of
C                       s/r mpi_allreduce), default is false
C- Time-stepping & free-surface params:
C     rigidLid            :: Set to true to use rigid lid
C     implicitFreeSurface :: Set to true to use implicit free surface
C     uniformLin_PhiSurf  :: Set to true to use a uniform Bo_surf in the
C                            linear relation Phi_surf = Bo_surf*eta
C     uniformFreeSurfLev  :: TRUE if free-surface level-index is uniform (=1)
C     exactConserv        :: Set to true to conserve exactly the total Volume
C     linFSConserveTr     :: Set to true to correct source/sink of tracer
C                            at the surface due to Linear Free Surface
C     useRealFreshWaterFlux :: if True (=Natural BCS), treats P+R-E flux
C                         as a real Fresh Water (=> changes the Sea Level)
C                         if F, converts P+R-E to salt flux (no SL effect)
C     storePhiHyd4Phys :: store hydrostatic potential for use in Physics/EOS
C                         this requires specific code for restart & exchange
C     quasiHydrostatic :: Using non-hydrostatic terms in hydrostatic algorithm
C     nonHydrostatic   :: Using non-hydrostatic algorithm
C     use3Dsolver      :: set to true to use 3-D pressure solver
C     implicitIntGravWave :: treat Internal Gravity Wave implicitly
C     staggerTimeStep   :: enable a Stagger time stepping U,V (& W) then T,S
C     applyExchUV_early :: Apply EXCH to U,V earlier, just before integr_continuity
C     doResetHFactors   :: Do reset thickness factors @ beginning of each time-step
C     implicitDiffusion :: Turns implicit vertical diffusion on
C     implicitViscosity :: Turns implicit vertical viscosity on
C     tempImplVertAdv   :: Turns on implicit vertical advection for Temperature
C     saltImplVertAdv   :: Turns on implicit vertical advection for Salinity
C     momImplVertAdv    :: Turns on implicit vertical advection for Momentum
C     multiDimAdvection :: Flag that enable multi-dimension advection
C     useMultiDimAdvec  :: True if multi-dim advection is used at least once
C     momDissip_In_AB   :: if False, put Dissipation tendency contribution
C                          out off Adams-Bashforth time stepping.
C     doAB_onGtGs       :: if the Adams-Bashforth time stepping is used, always
C                          apply AB on tracer tendencies (rather than on Tracer)
C- Other forcing params -
C     balanceQnet     :: substract global mean of Qnet at every time step
C     balancePrintMean:: print substracted global means to STDOUT
C     doThetaClimRelax :: Set true if relaxation to temperature
C                        climatology is required.
C     doSaltClimRelax  :: Set true if relaxation to salinity
C                        climatology is required.
C     balanceThetaClimRelax :: substract global mean effect at every time step
C     balanceSaltClimRelax :: substract global mean effect at every time step
C     allowFreezing  :: Allows surface water to freeze and form ice
C     periodicExternalForcing :: Set true if forcing is time-dependant
C- I/O parameters -
C     globalFiles    :: Selects between "global" and "tiled" files.
C                       On some platforms with MPI, option globalFiles is either
C                       slow or does not work. Use useSingleCpuIO instead.
C     useSingleCpuIO :: moved to EEPARAMS.h
C     pickupStrictlyMatch :: check and stop if pickup-file do not stricly match
C     startFromPickupAB2 :: with AB-3 code, start from an AB-2 pickup
C     usePickupBeforeC54 :: start from old-pickup files, generated with code from
C                           before checkpoint-54a, Jul 06, 2004.
C     pickup_write_mdsio :: use mdsio to write pickups
C     pickup_read_mdsio  :: use mdsio to read  pickups
C     pickup_write_immed :: echo the pickup immediately (for conversion)
C     writePickupAtEnd   :: write pickup at the last timestep
C     timeave_mdsio      :: use mdsio for timeave output
C     snapshot_mdsio     :: use mdsio for "snapshot" (dumpfreq/diagfreq) output
C     monitor_stdio      :: use stdio for monitor output
C     dumpInitAndLast :: dumps model state to files at Initial (nIter0)
C                        & Last iteration, in addition multiple of dumpFreq iter.

      COMMON /PARM_L/
     & fluidIsAir, fluidIsWater,
     & usingPCoords, usingZCoords,
     & usingCartesianGrid, usingSphericalPolarGrid, rotateGrid,
     & usingCylindricalGrid, usingCurvilinearGrid, hasWetCSCorners,
     & deepAtmosphere, setInterFDr, setCenterDr, useMin4hFacEdges,
     & interViscAr_pCell, interDiffKr_pCell,
     & no_slip_sides, no_slip_bottom, bottomVisc_pCell, useSmag3D,
     & useFullLeith, useStrainTensionVisc, useAreaViscLength,
     & momViscosity, momAdvection, momForcing, momTidalForcing,
     & momPressureForcing, metricTerms, useNHMTerms,
     & useCoriolis, use3dCoriolis,
     & useCDscheme, vectorInvariantMomentum,
     & useJamartMomAdv, upwindVorticity, highOrderVorticity,
     & useAbsVorticity, upwindShear,
     & momStepping, calc_wVelocity, tempStepping, saltStepping,
     & addFrictionHeating, temp_stayPositive, salt_stayPositive,
     & tempAdvection, tempVertDiff4, tempIsActiveTr, tempForcing,
     & saltAdvection, saltVertDiff4, saltIsActiveTr, saltForcing,
     & maskIniTemp, maskIniSalt, checkIniTemp, checkIniSalt,
     & useNSACGSolver, useSRCGSolver,
     & rigidLid, implicitFreeSurface,
     & uniformLin_PhiSurf, uniformFreeSurfLev,
     & exactConserv, linFSConserveTr, useRealFreshWaterFlux,
     & storePhiHyd4Phys, quasiHydrostatic, nonHydrostatic,
     & use3Dsolver, implicitIntGravWave, staggerTimeStep,
     & applyExchUV_early, doResetHFactors,
     & implicitDiffusion, implicitViscosity,
     & tempImplVertAdv, saltImplVertAdv, momImplVertAdv,
     & multiDimAdvection, useMultiDimAdvec,
     & momDissip_In_AB, doAB_onGtGs,
     & balanceQnet, balancePrintMean,
     & balanceThetaClimRelax, balanceSaltClimRelax,
     & doThetaClimRelax, doSaltClimRelax,
     & allowFreezing,
     & periodicExternalForcing,
     & globalFiles,
     & pickupStrictlyMatch, usePickupBeforeC54, startFromPickupAB2,
     & pickup_read_mdsio, pickup_write_mdsio, pickup_write_immed,
     & writePickupAtEnd,
     & timeave_mdsio, snapshot_mdsio, monitor_stdio,
     & outputTypesInclusive, dumpInitAndLast

      LOGICAL fluidIsAir
      LOGICAL fluidIsWater
      LOGICAL usingPCoords
      LOGICAL usingZCoords
      LOGICAL usingCartesianGrid
      LOGICAL usingSphericalPolarGrid, rotateGrid
      LOGICAL usingCylindricalGrid
      LOGICAL usingCurvilinearGrid, hasWetCSCorners
      LOGICAL deepAtmosphere
      LOGICAL setInterFDr
      LOGICAL setCenterDr
      LOGICAL useMin4hFacEdges
      LOGICAL interViscAr_pCell
      LOGICAL interDiffKr_pCell

      LOGICAL no_slip_sides
      LOGICAL no_slip_bottom
      LOGICAL bottomVisc_pCell
      LOGICAL useSmag3D
      LOGICAL useFullLeith
      LOGICAL useStrainTensionVisc
      LOGICAL useAreaViscLength
      LOGICAL momViscosity
      LOGICAL momAdvection
      LOGICAL momForcing
      LOGICAL momTidalForcing
      LOGICAL momPressureForcing
      LOGICAL metricTerms
      LOGICAL useNHMTerms

      LOGICAL useCoriolis
      LOGICAL use3dCoriolis
      LOGICAL useCDscheme
      LOGICAL vectorInvariantMomentum
      LOGICAL useJamartMomAdv
      LOGICAL upwindVorticity
      LOGICAL highOrderVorticity
      LOGICAL useAbsVorticity
      LOGICAL upwindShear
      LOGICAL momStepping
      LOGICAL calc_wVelocity
      LOGICAL tempStepping
      LOGICAL saltStepping
      LOGICAL addFrictionHeating
      LOGICAL temp_stayPositive
      LOGICAL salt_stayPositive
      LOGICAL tempAdvection
      LOGICAL tempVertDiff4
      LOGICAL tempIsActiveTr
      LOGICAL tempForcing
      LOGICAL saltAdvection
      LOGICAL saltVertDiff4
      LOGICAL saltIsActiveTr
      LOGICAL saltForcing
      LOGICAL maskIniTemp
      LOGICAL maskIniSalt
      LOGICAL checkIniTemp
      LOGICAL checkIniSalt
      LOGICAL useNSACGSolver
      LOGICAL useSRCGSolver
      LOGICAL rigidLid
      LOGICAL implicitFreeSurface
      LOGICAL uniformLin_PhiSurf
      LOGICAL uniformFreeSurfLev
      LOGICAL exactConserv
      LOGICAL linFSConserveTr
      LOGICAL useRealFreshWaterFlux
      LOGICAL storePhiHyd4Phys
      LOGICAL quasiHydrostatic
      LOGICAL nonHydrostatic
      LOGICAL use3Dsolver
      LOGICAL implicitIntGravWave
      LOGICAL staggerTimeStep
      LOGICAL applyExchUV_early
      LOGICAL doResetHFactors
      LOGICAL implicitDiffusion
      LOGICAL implicitViscosity
      LOGICAL tempImplVertAdv
      LOGICAL saltImplVertAdv
      LOGICAL momImplVertAdv
      LOGICAL multiDimAdvection
      LOGICAL useMultiDimAdvec
      LOGICAL momDissip_In_AB
      LOGICAL doAB_onGtGs
      LOGICAL balanceQnet
      LOGICAL balancePrintMean
      LOGICAL doThetaClimRelax
      LOGICAL doSaltClimRelax
      LOGICAL balanceThetaClimRelax
      LOGICAL balanceSaltClimRelax
      LOGICAL allowFreezing
      LOGICAL periodicExternalForcing
      LOGICAL globalFiles
      LOGICAL pickupStrictlyMatch
      LOGICAL usePickupBeforeC54
      LOGICAL startFromPickupAB2
      LOGICAL pickup_read_mdsio, pickup_write_mdsio
      LOGICAL pickup_write_immed, writePickupAtEnd
      LOGICAL timeave_mdsio, snapshot_mdsio, monitor_stdio
      LOGICAL outputTypesInclusive
      LOGICAL dumpInitAndLast

C--   COMMON /PARM_R/ "Real" valued parameters used by the model.
C     cg2dTargetResidual
C          :: Target residual for cg2d solver; no unit (RHS normalisation)
C     cg2dTargetResWunit
C          :: Target residual for cg2d solver; W unit (No RHS normalisation)
C     cg3dTargetResidual
C               :: Target residual for cg3d solver.
C     cg2dpcOffDFac :: Averaging weight for preconditioner off-diagonal.
C     Note. 20th May 1998
C           I made a weird discovery! In the model paper we argue
C           for the form of the preconditioner used here ( see
C           A Finite-volume, Incompressible Navier-Stokes Model
C           ...., Marshall et. al ). The algebra gives a simple
C           0.5 factor for the averaging of ac and aCw to get a
C           symmettric pre-conditioner. By using a factor of 0.51
C           i.e. scaling the off-diagonal terms in the
C           preconditioner down slightly I managed to get the
C           number of iterations for convergence in a test case to
C           drop form 192 -> 134! Need to investigate this further!
C           For now I have introduced a parameter cg2dpcOffDFac which
C           defaults to 0.51 but can be set at runtime.
C     delR      :: Vertical grid spacing ( units of r ).
C     delRc     :: Vertical grid spacing between cell centers (r unit).
C     delX      :: Separation between cell faces (m) or (deg), depending
C     delY         on input flags. Note: moved to header file SET_GRID.h
C     xgOrigin   :: Origin of the X-axis (Cartesian Grid) / Longitude of Western
C                :: most cell face (Lat-Lon grid) (Note: this is an "inert"
C                :: parameter but it makes geographical references simple.)
C     ygOrigin   :: Origin of the Y-axis (Cartesian Grid) / Latitude of Southern
C                :: most face (Lat-Lon grid).
C     rSphere    :: Radius of sphere for a spherical polar grid ( m ).
C     recip_rSphere :: Reciprocal radius of sphere ( m^-1 ).
C     radius_fromHorizGrid :: sphere Radius of input horiz. grid (Curvilinear Grid)
C     seaLev_Z   :: the reference height of sea-level (usually zero)
C     top_Pres   :: pressure (P-Coords) or reference pressure (Z-Coords) at the top
C     rSigmaBnd  :: vertical position (in r-unit) of r/sigma transition (Hybrid-Sigma)
C     gravity    :: Acceleration due to constant gravity ( m/s^2 )
C     recip_gravity :: Reciprocal gravity acceleration ( s^2/m )
C     gBaro      :: Accel. due to gravity used in barotropic equation ( m/s^2 )
C     gravFacC   :: gravity factor (vs surf. gravity) vert. profile at cell-Center
C     gravFacF   :: gravity factor (vs surf. gravity) vert. profile at cell-interF
C     rhoNil     :: Reference density for the linear equation of state
C     rhoConst   :: Vertically constant reference density (Boussinesq)
C     rho1Ref    :: reference vertical profile for density (anelastic)
C     rhoFacC    :: normalized (by rhoConst) reference density at cell-Center
C     rhoFacF    :: normalized (by rhoConst) reference density at cell-interFace
C     rhoConstFresh :: Constant reference density for fresh water (rain)
C     thetaConst :: Constant reference for potential temperature
C     tRef       :: reference vertical profile for potential temperature
C     sRef       :: reference vertical profile for salinity/specific humidity
C     rhoRef     :: density vertical profile from (tRef,sRef) [kg/m^3]
C     dBdrRef    :: vertical gradient of reference buoyancy  [(m/s/r)^2]:
C                :: z-coord: = N^2_ref = Brunt-Vaissala frequency [s^-2]
C                :: p-coord: = -(d.alpha/dp)_ref          [(m^2.s/kg)^2]
C     surf_pRef  :: surface reference pressure ( Pa )
C     pRef4EOS   :: reference pressure used in EOS (case selectP_inEOS_Zc=1)
C     phiRef     :: reference potential (press/rho, geopot) profile (m^2/s^2)
C     rVel2wUnit :: units conversion factor (Non-Hydrostatic code),
C                :: from r-coordinate vertical velocity to vertical velocity [m/s].
C                :: z-coord: = 1 ; p-coord: wSpeed [m/s] = rVel [Pa/s] * rVel2wUnit
C     wUnit2rVel :: units conversion factor (Non-Hydrostatic code),
C                :: from vertical velocity [m/s] to r-coordinate vertical velocity.
C                :: z-coord: = 1 ; p-coord: rVel [Pa/s] = wSpeed [m/s] * wUnit2rVel
C     rUnit2z    :: units conversion factor (for ocean in P-coord, only fct of k),
C                :: from r-coordinate to z [m] (at level center):
C                :: z-coord: = 1 ; p-coord: dz [m] = dr [Pa] * rUnit2z
C     z2rUnit    :: units conversion factor (for ocean in P-coord, only fct of k),
C                :: from z [m] to r-coordinate (at level center):
C                :: z-coord: = 1 ; p-coord: dr [Pa] = dz [m] * z2rUnit
C     mass2rUnit :: units conversion factor (surface forcing),
C                :: from mass per unit area [kg/m2] to vertical r-coordinate unit.
C                :: z-coord: = 1/rhoConst ( [kg/m2] / rho = [m] ) ;
C                :: p-coord: = gravity    ( [kg/m2] *  g = [Pa] ) ;
C     rUnit2mass :: units conversion factor (surface forcing),
C                :: from vertical r-coordinate unit to mass per unit area [kg/m2].
C                :: z-coord: = rhoConst  ( [m] * rho = [kg/m2] ) ;
C                :: p-coord: = 1/gravity ( [Pa] /  g = [kg/m2] ) ;
C     sIceLoadFac:: factor to scale (and turn off) sIceLoad (sea-ice loading)
C                   default = 1
C     f0         :: Reference coriolis parameter ( 1/s )
C                   ( Southern edge f for beta plane )
C     beta       :: df/dy ( s^-1.m^-1 )
C     fPrime     :: Second Coriolis parameter ( 1/s ), related to Y-component
C                   of rotation (reference value = 2.Omega.Cos(Phi))
C     omega      :: Angular velocity ( rad/s )
C     rotationPeriod :: Rotation period (s) (= 2.pi/omega)
C     viscArNr   :: vertical profile of Eddy viscosity coeff.
C                   for vertical mixing of momentum ( units of r^2/s )
C     viscAh     :: Eddy viscosity coeff. for mixing of
C                   momentum laterally ( m^2/s )
C     viscAhW    :: Eddy viscosity coeff. for mixing of vertical
C                   momentum laterally, no effect for hydrostatic
C                   model, defaults to viscAhD if unset ( m^2/s )
C                   Not used if variable horiz. viscosity is used.
C     viscA4     :: Biharmonic viscosity coeff. for mixing of
C                   momentum laterally ( m^4/s )
C     viscA4W    :: Biharmonic viscosity coeff. for mixing of vertical
C                   momentum laterally, no effect for hydrostatic
C                   model, defaults to viscA4D if unset ( m^2/s )
C                   Not used if variable horiz. viscosity is used.
C     viscAhD    :: Eddy viscosity coeff. for mixing of momentum laterally
C                   (act on Divergence part) ( m^2/s )
C     viscAhZ    :: Eddy viscosity coeff. for mixing of momentum laterally
C                   (act on Vorticity  part) ( m^2/s )
C     viscA4D    :: Biharmonic viscosity coeff. for mixing of momentum laterally
C                   (act on Divergence part) ( m^4/s )
C     viscA4Z    :: Biharmonic viscosity coeff. for mixing of momentum laterally
C                   (act on Vorticity  part) ( m^4/s )
C     smag3D_coeff     :: Isotropic 3-D Smagorinsky viscosity coefficient (-)
C     smag3D_diffCoeff :: Isotropic 3-D Smagorinsky diffusivity coefficient (-)
C     viscC2leith  :: Leith non-dimensional viscosity factor (grad(vort))
C     viscC2leithD :: Modified Leith non-dimensional visc. factor (grad(div))
C     viscC2LeithQG:: QG Leith non-dimensional viscosity factor
C     viscC4leith  :: Leith non-dimensional viscosity factor (grad(vort))
C     viscC4leithD :: Modified Leith non-dimensional viscosity factor (grad(div))
C     viscC2smag   :: Smagorinsky non-dimensional viscosity factor (harmonic)
C     viscC4smag   :: Smagorinsky non-dimensional viscosity factor (biharmonic)
C     viscAhMax    :: Maximum eddy viscosity coeff. for mixing of
C                    momentum laterally ( m^2/s )
C     viscAhReMax  :: Maximum gridscale Reynolds number for eddy viscosity
C                     coeff. for mixing of momentum laterally (non-dim)
C     viscAhGrid   :: non-dimensional grid-size dependent viscosity
C     viscAhGridMax:: maximum and minimum harmonic viscosity coefficients ...
C     viscAhGridMin::  in terms of non-dimensional grid-size dependent visc.
C     viscA4Max    :: Maximum biharmonic viscosity coeff. for mixing of
C                     momentum laterally ( m^4/s )
C     viscA4ReMax  :: Maximum Gridscale Reynolds number for
C                     biharmonic viscosity coeff. momentum laterally (non-dim)
C     viscA4Grid   :: non-dimensional grid-size dependent bi-harmonic viscosity
C     viscA4GridMax:: maximum and minimum biharmonic viscosity coefficients ...
C     viscA4GridMin::  in terms of non-dimensional grid-size dependent viscosity
C     diffKhT   :: Laplacian diffusion coeff. for mixing of
C                 heat laterally ( m^2/s )
C     diffK4T   :: Biharmonic diffusion coeff. for mixing of
C                 heat laterally ( m^4/s )
C     diffKrNrT :: vertical profile of Laplacian diffusion coeff.
C                 for mixing of heat vertically ( units of r^2/s )
C     diffKr4T  :: vertical profile of Biharmonic diffusion coeff.
C                 for mixing of heat vertically ( units of r^4/s )
C     diffKhS  ::  Laplacian diffusion coeff. for mixing of
C                 salt laterally ( m^2/s )
C     diffK4S   :: Biharmonic diffusion coeff. for mixing of
C                 salt laterally ( m^4/s )
C     diffKrNrS :: vertical profile of Laplacian diffusion coeff.
C                 for mixing of salt vertically ( units of r^2/s ),
C     diffKr4S  :: vertical profile of Biharmonic diffusion coeff.
C                 for mixing of salt vertically ( units of r^4/s )
C     diffKrBL79surf :: T/S surface diffusivity (m^2/s) Bryan and Lewis, 1979
C     diffKrBL79deep :: T/S deep diffusivity (m^2/s) Bryan and Lewis, 1979
C     diffKrBL79scl  :: depth scale for arctan fn (m) Bryan and Lewis, 1979
C     diffKrBL79Ho   :: depth offset for arctan fn (m) Bryan and Lewis, 1979
C     BL79LatVary    :: polarwise of this latitude diffKrBL79 is applied with
C                       gradual transition to diffKrBLEQ towards Equator
C     diffKrBLEQsurf :: same as diffKrBL79surf but at Equator
C     diffKrBLEQdeep :: same as diffKrBL79deep but at Equator
C     diffKrBLEQscl  :: same as diffKrBL79scl but at Equator
C     diffKrBLEQHo   :: same as diffKrBL79Ho but at Equator
C     pCellMix_maxFac :: maximum enhanced mixing factor for thin partial-cell
C     pCellMix_delR   :: thickness criteria   for too thin partial-cell
C     pCellMix_viscAr :: vertical viscosity   for too thin partial-cell
C     pCellMix_diffKr :: vertical diffusivity for too thin partial-cell
C     deltaT    :: Default timestep ( s )
C     deltaTClock  :: Timestep used as model "clock". This determines the
C                    IO frequencies and is used in tagging output. It can
C                    be totally different to the dynamical time. Typically
C                    it will be the deep-water timestep for accelerated runs.
C                    Frequency of checkpointing and dumping of the model state
C                    are referenced to this clock. ( s )
C     deltaTMom    :: Timestep for momemtum equations ( s )
C     dTtracerLev  :: Timestep for tracer equations ( s ), function of level k
C     deltaTFreeSurf :: Timestep for free-surface equation ( s )
C     freeSurfFac  :: Parameter to turn implicit free surface term on or off
C                     freeSurFac = 1. uses implicit free surface
C                     freeSurFac = 0. uses rigid lid
C     abEps        :: Adams-Bashforth-2 stabilizing weight
C     alph_AB      :: Adams-Bashforth-3 primary factor
C     beta_AB      :: Adams-Bashforth-3 secondary factor
C     implicSurfPress :: parameter of the Crank-Nickelson time stepping :
C                     Implicit part of Surface Pressure Gradient ( 0-1 )
C     implicDiv2DFlow :: parameter of the Crank-Nickelson time stepping :
C                     Implicit part of barotropic flow Divergence ( 0-1 )
C     implicitNHPress :: parameter of the Crank-Nickelson time stepping :
C                     Implicit part of Non-Hydrostatic Pressure Gradient ( 0-1 )
C     hFacMin      :: Minimum fraction size of a cell (affects hFacC etc...)
C     hFacMinDz    :: Minimum dimensional size of a cell (affects hFacC etc..., m)
C     hFacMinDp    :: Minimum dimensional size of a cell (affects hFacC etc..., Pa)
C     hFacMinDr    :: Minimum dimensional size of a cell (-> hFacC etc..., r units)
C     hFacInf      :: Threshold (inf and sup) for fraction size of surface cell
C     hFacSup          that control vanishing and creating levels
C     tauCD         :: CD scheme coupling timescale ( s )
C     rCD           :: CD scheme normalised coupling parameter (= 1 - deltaT/tauCD)
C     epsAB_CD      :: Adams-Bashforth-2 stabilizing weight used in CD scheme
C     baseTime      :: model base time (time origin) = time @ iteration zero
C     startTime     :: Starting time for this integration ( s ).
C     endTime       :: Ending time for this integration ( s ).
C     chkPtFreq     :: Frequency of rolling check pointing ( s ).
C     pChkPtFreq    :: Frequency of permanent check pointing ( s ).
C     dumpFreq      :: Frequency with which model state is written to
C                      post-processing files ( s ).
C     diagFreq      :: Frequency with which model writes diagnostic output
C                      of intermediate quantities.
C     afFacMom      :: Advection of momentum term tracer parameter
C     vfFacMom      :: Momentum viscosity tracer parameter
C     pfFacMom      :: Momentum pressure forcing tracer parameter
C     cfFacMom      :: Coriolis term tracer parameter
C     foFacMom      :: Momentum forcing tracer parameter
C     mtFacMom      :: Metric terms tracer parameter
C     cosPower      :: Power of cosine of latitude to multiply viscosity
C     cAdjFreq      :: Frequency of convective adjustment
C
C     taveFreq      :: Frequency with which time-averaged model state
C                      is written to post-processing files ( s ).
C     tave_lastIter :: (for state variable only) fraction of the last time
C                      step (of each taveFreq period) put in the time average.
C                      (fraction for 1rst iter = 1 - tave_lastIter)
C     tauThetaClimRelax :: Relaxation to climatology time scale ( s ).
C     tauSaltClimRelax :: Relaxation to climatology time scale ( s ).
C     latBandClimRelax :: latitude band where Relaxation to Clim. is applied,
C                         i.e. where |yC| <= latBandClimRelax
C     externForcingPeriod :: Is the period of which forcing varies (eg. 1 month)
C     externForcingCycle :: Is the repeat time of the forcing (eg. 1 year)
C                          (note: externForcingCycle must be an integer
C                           number times externForcingPeriod)
C     convertFW2Salt :: salinity, used to convert Fresh-Water Flux to Salt Flux
C                       (use model surface (local) value if set to -1)
C     temp_EvPrRn :: temperature of Rain & Evap.
C     salt_EvPrRn :: salinity of Rain & Evap.
C     temp_addMass :: temperature of addMass array
C     salt_addMass :: salinity of addMass array
C        (notes: a) tracer content of Rain/Evap only used if both
C                     NonLin_FrSurf & useRealFreshWater are set.
C                b) use model surface (local) value if set to UNSET_RL)
C     hMixCriteria:: criteria for mixed-layer diagnostic
C     dRhoSmall   :: parameter for mixed-layer diagnostic
C     hMixSmooth  :: Smoothing parameter for mixed-layer diag (default=0=no smoothing)
C     ivdc_kappa  :: implicit vertical diffusivity for convection [m^2/s]
C     sideDragFactor     :: side-drag scaling factor (used only if no_slip_sides)
C                           (default=2: full drag ; =1: gives half-slip BC)
C     bottomDragLinear    :: Linear    bottom-drag coefficient (units of [r]/s)
C     bottomDragQuadratic :: Quadratic bottom-drag coefficient (units of [r]/m)
C               (if using zcoordinate, units becomes linear: m/s, quadratic: [-])
C     smoothAbsFuncRange :: 1/2 of interval around zero, for which FORTRAN ABS
C                           is to be replace by a smoother function
C                           (affects myabs, mymin, mymax)
C     nh_Am2        :: scales the non-hydrostatic terms and changes internal scales
C                      (i.e. allows convection at different Rayleigh numbers)
C     tCylIn        :: Temperature of the cylinder inner boundary
C     tCylOut       :: Temperature of the cylinder outer boundary
C     phiEuler      :: Euler angle, rotation about original z-axis
C     thetaEuler    :: Euler angle, rotation about new x-axis
C     psiEuler      :: Euler angle, rotation about new z-axis
      COMMON /PARM_R/ cg2dTargetResidual, cg2dTargetResWunit,
     & cg2dpcOffDFac, cg3dTargetResidual,
     & delR, delRc, xgOrigin, ygOrigin, rSphere, recip_rSphere,
     & radius_fromHorizGrid, seaLev_Z, top_Pres, rSigmaBnd,
     & deltaT, deltaTMom, dTtracerLev, deltaTFreeSurf, deltaTClock,
     & abEps, alph_AB, beta_AB,
     & f0, beta, fPrime, omega, rotationPeriod,
     & viscFacAdj, viscAh, viscAhW, smag3D_coeff, smag3D_diffCoeff,
     & viscAhMax, viscAhGrid, viscAhGridMax, viscAhGridMin,
     & viscC2leith, viscC2leithD, viscC2LeithQG,
     & viscC2smag, viscC4smag,
     & viscAhD, viscAhZ, viscA4D, viscA4Z,
     & viscA4, viscA4W, viscA4Max,
     & viscA4Grid, viscA4GridMax, viscA4GridMin,
     & viscAhReMax, viscA4ReMax,
     & viscC4leith, viscC4leithD, viscArNr,
     & diffKhT, diffK4T, diffKrNrT, diffKr4T,
     & diffKhS, diffK4S, diffKrNrS, diffKr4S,
     & diffKrBL79surf, diffKrBL79deep, diffKrBL79scl, diffKrBL79Ho,
     & BL79LatVary,
     & diffKrBLEQsurf, diffKrBLEQdeep, diffKrBLEQscl, diffKrBLEQHo,
     & pCellMix_maxFac, pCellMix_delR, pCellMix_viscAr, pCellMix_diffKr,
     & tauCD, rCD, epsAB_CD,
     & freeSurfFac, implicSurfPress, implicDiv2DFlow, implicitNHPress,
     & hFacMin, hFacMinDz, hFacInf, hFacSup,
     & gravity, recip_gravity, gBaro,
     & gravFacC, recip_gravFacC, gravFacF, recip_gravFacF,
     & rhoNil, rhoConst, recip_rhoConst, rho1Ref,
     & rhoFacC, recip_rhoFacC, rhoFacF, recip_rhoFacF, rhoConstFresh,
     & thetaConst, tRef, sRef, rhoRef, dBdrRef,
     & surf_pRef, pRef4EOS, phiRef,
     & rVel2wUnit, wUnit2rVel, rUnit2z, z2rUnit, mass2rUnit, rUnit2mass,
     & baseTime, startTime, endTime,
     & chkPtFreq, pChkPtFreq, dumpFreq, adjDumpFreq,
     & diagFreq, taveFreq, tave_lastIter, monitorFreq, adjMonitorFreq,
     & afFacMom, vfFacMom, pfFacMom, cfFacMom, foFacMom, mtFacMom,
     & cosPower, cAdjFreq,
     & tauThetaClimRelax, tauSaltClimRelax, latBandClimRelax,
     & externForcingCycle, externForcingPeriod,
     & convertFW2Salt, temp_EvPrRn, salt_EvPrRn,
     & temp_addMass, salt_addMass, hFacMinDr, hFacMinDp,
     & ivdc_kappa, hMixCriteria, dRhoSmall, hMixSmooth,
     & sideDragFactor, bottomDragLinear, bottomDragQuadratic, nh_Am2,
     & smoothAbsFuncRange, sIceLoadFac,
     & tCylIn, tCylOut,
     & phiEuler, thetaEuler, psiEuler

      Real*8 cg2dTargetResidual
      Real*8 cg2dTargetResWunit
      Real*8 cg3dTargetResidual
      Real*8 cg2dpcOffDFac
      Real*8 delR(Nr)
      Real*8 delRc(Nr+1)
      Real*8 xgOrigin
      Real*8 ygOrigin
      Real*8 rSphere
      Real*8 recip_rSphere
      Real*8 radius_fromHorizGrid
      Real*8 seaLev_Z
      Real*8 top_Pres
      Real*8 rSigmaBnd
      Real*8 deltaT
      Real*8 deltaTClock
      Real*8 deltaTMom
      Real*8 dTtracerLev(Nr)
      Real*8 deltaTFreeSurf
      Real*8 abEps, alph_AB, beta_AB
      Real*8 f0
      Real*8 beta
      Real*8 fPrime
      Real*8 omega
      Real*8 rotationPeriod
      Real*8 freeSurfFac
      Real*8 implicSurfPress
      Real*8 implicDiv2DFlow
      Real*8 implicitNHPress
      Real*8 hFacMin
      Real*8 hFacMinDz
      Real*8 hFacMinDp
      Real*8 hFacMinDr
      Real*8 hFacInf
      Real*8 hFacSup
      Real*8 viscArNr(Nr)
      Real*8 viscFacAdj
      Real*8 viscAh
      Real*8 viscAhW
      Real*8 viscAhD
      Real*8 viscAhZ
      Real*8 smag3D_coeff, smag3D_diffCoeff
      Real*8 viscAhMax
      Real*8 viscAhReMax
      Real*8 viscAhGrid, viscAhGridMax, viscAhGridMin
      Real*8 viscC2leith
      Real*8 viscC2leithD
      Real*8 viscC2LeithQG
      Real*8 viscC2smag
      Real*8 viscA4
      Real*8 viscA4W
      Real*8 viscA4D
      Real*8 viscA4Z
      Real*8 viscA4Max
      Real*8 viscA4ReMax
      Real*8 viscA4Grid, viscA4GridMax, viscA4GridMin
      Real*8 viscC4leith
      Real*8 viscC4leithD
      Real*8 viscC4smag
      Real*8 diffKhT
      Real*8 diffK4T
      Real*8 diffKrNrT(Nr)
      Real*8 diffKr4T(Nr)
      Real*8 diffKhS
      Real*8 diffK4S
      Real*8 diffKrNrS(Nr)
      Real*8 diffKr4S(Nr)
      Real*8 diffKrBL79surf
      Real*8 diffKrBL79deep
      Real*8 diffKrBL79scl
      Real*8 diffKrBL79Ho
      Real*8 BL79LatVary
      Real*8 diffKrBLEQsurf
      Real*8 diffKrBLEQdeep
      Real*8 diffKrBLEQscl
      Real*8 diffKrBLEQHo
      Real*8 pCellMix_maxFac
      Real*8 pCellMix_delR
      Real*8 pCellMix_viscAr(Nr)
      Real*8 pCellMix_diffKr(Nr)
      Real*8 tauCD, rCD, epsAB_CD
      Real*8 gravity,       recip_gravity
      Real*8 gBaro
      Real*8 gravFacC(Nr),   recip_gravFacC(Nr)
      Real*8 gravFacF(Nr+1), recip_gravFacF(Nr+1)
      Real*8 rhoNil
      Real*8 rhoConst,      recip_rhoConst
      Real*8 rho1Ref(Nr)
      Real*8 rhoFacC(Nr),   recip_rhoFacC(Nr)
      Real*8 rhoFacF(Nr+1), recip_rhoFacF(Nr+1)
      Real*8 rhoConstFresh
      Real*8 thetaConst
      Real*8 tRef(Nr)
      Real*8 sRef(Nr)
      Real*8 rhoRef(Nr)
      Real*8 dBdrRef(Nr)
      Real*8 surf_pRef, pRef4EOS(Nr)
      Real*8 phiRef(2*Nr+1)
      Real*8 rVel2wUnit(Nr+1), wUnit2rVel(Nr+1)
      Real*8 rUnit2z(Nr), z2rUnit(Nr)
      Real*8 mass2rUnit, rUnit2mass
      Real*8 baseTime
      Real*8 startTime
      Real*8 endTime
      Real*8 chkPtFreq
      Real*8 pChkPtFreq
      Real*8 dumpFreq
      Real*8 adjDumpFreq
      Real*8 diagFreq
      Real*8 taveFreq
      Real*8 tave_lastIter
      Real*8 monitorFreq
      Real*8 adjMonitorFreq
      Real*8 afFacMom
      Real*8 vfFacMom
      Real*8 pfFacMom
      Real*8 cfFacMom
      Real*8 foFacMom
      Real*8 mtFacMom
      Real*8 cosPower
      Real*8 cAdjFreq
      Real*8 tauThetaClimRelax
      Real*8 tauSaltClimRelax
      Real*8 latBandClimRelax
      Real*8 externForcingCycle
      Real*8 externForcingPeriod
      Real*8 convertFW2Salt
      Real*8 temp_EvPrRn
      Real*8 salt_EvPrRn
      Real*8 temp_addMass
      Real*8 salt_addMass
      Real*8 ivdc_kappa
      Real*8 hMixCriteria
      Real*8 dRhoSmall
      Real*8 hMixSmooth
      Real*8 sideDragFactor
      Real*8 bottomDragLinear
      Real*8 bottomDragQuadratic
      Real*8 smoothAbsFuncRange
      Real*8 sIceLoadFac
      Real*8 nh_Am2
      Real*8 tCylIn, tCylOut
      Real*8 phiEuler, thetaEuler, psiEuler

C--   COMMON /PARM_A/ Thermodynamics constants ?
      COMMON /PARM_A/ HeatCapacity_Cp
      Real*8 HeatCapacity_Cp

C--   COMMON /PARM_ATM/ Atmospheric physical parameters (Ideal Gas EOS, ...)
C     celsius2K :: convert centigrade (Celsius) degree to Kelvin
C     atm_Po    :: standard reference pressure
C     atm_Cp    :: specific heat (Cp) of the (dry) air at constant pressure
C     atm_Rd    :: gas constant for dry air
C     atm_kappa :: kappa = R/Cp (R: constant of Ideal Gas EOS)
C     atm_Rq    :: water vapour specific volume anomaly relative to dry air
C                  (e.g. typical value = (29/18 -1) 10^-3 with q [g/kg])
C     integr_GeoPot :: option to select the way we integrate the geopotential
C                     (still a subject of discussions ...)
C     selectFindRoSurf :: select the way surf. ref. pressure (=Ro_surf) is
C             derived from the orography. Implemented: 0,1 (see INI_P_GROUND)
      COMMON /PARM_ATM/
     &            celsius2K,
     &            atm_Cp, atm_Rd, atm_kappa, atm_Rq, atm_Po,
     &            integr_GeoPot, selectFindRoSurf
      Real*8 celsius2K
      Real*8 atm_Po, atm_Cp, atm_Rd, atm_kappa, atm_Rq
      INTEGER integr_GeoPot, selectFindRoSurf

C----------------------------------------
C-- Logical flags for selecting packages
      LOGICAL useGAD
      LOGICAL useOBCS
      LOGICAL useSHAP_FILT
      LOGICAL useZONAL_FILT
      LOGICAL useOPPS
      LOGICAL usePP81
      LOGICAL useKL10
      LOGICAL useMY82
      LOGICAL useGGL90
      LOGICAL useKPP
      LOGICAL useGMRedi
      LOGICAL useDOWN_SLOPE
      LOGICAL useBBL
      LOGICAL useCAL
      LOGICAL useEXF
      LOGICAL useBulkForce
      LOGICAL useEBM
      LOGICAL useCheapAML
      LOGICAL useAUTODIFF
      LOGICAL useGrdchk
      LOGICAL useSMOOTH
      LOGICAL usePROFILES
      LOGICAL useECCO
      LOGICAL useCTRL
      LOGICAL useSBO
      LOGICAL useFLT
      LOGICAL usePTRACERS
      LOGICAL useGCHEM
      LOGICAL useRBCS
      LOGICAL useOffLine
      LOGICAL useMATRIX
      LOGICAL useFRAZIL
      LOGICAL useSEAICE
      LOGICAL useSALT_PLUME
      LOGICAL useShelfIce
      LOGICAL useStreamIce
      LOGICAL useICEFRONT
      LOGICAL useThSIce
      LOGICAL useLand
      LOGICAL useATM2d
      LOGICAL useAIM
      LOGICAL useAtm_Phys
      LOGICAL useFizhi
      LOGICAL useGridAlt
      LOGICAL useDiagnostics
      LOGICAL useREGRID
      LOGICAL useLayers
      LOGICAL useMNC
      LOGICAL useRunClock
      LOGICAL useEMBED_FILES
      LOGICAL useMYPACKAGE
      COMMON /PARM_PACKAGES/
     &        useGAD, useOBCS, useSHAP_FILT, useZONAL_FILT,
     &        useOPPS, usePP81, useKL10, useMY82, useGGL90, useKPP,
     &        useGMRedi, useBBL, useDOWN_SLOPE,
     &        useCAL, useEXF, useBulkForce, useEBM, useCheapAML,
     &        useGrdchk, useSMOOTH, usePROFILES, useECCO, useCTRL,
     &        useSBO, useFLT, useAUTODIFF,
     &        usePTRACERS, useGCHEM, useRBCS, useOffLine, useMATRIX,
     &        useFRAZIL, useSEAICE, useSALT_PLUME, useShelfIce,
     &        useStreamIce, useICEFRONT, useThSIce, useLand,
     &        useATM2D, useAIM, useAtm_Phys, useFizhi, useGridAlt,
     &        useDiagnostics, useREGRID, useLayers, useMNC,
     &        useRunClock, useEMBED_FILES,
     &        useMYPACKAGE

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
C
CBOP
C    !ROUTINE: GRID.h
C    !INTERFACE:
C    include GRID.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | GRID.h
C     | o Header file defining model grid.
C     *==========================================================*
C     | Model grid is defined for each process by reference to
C     | the arrays set here.
C     | Notes
C     | =====
C     | The standard MITgcm convention of westmost, southern most
C     | and upper most having the (1,1,1) index is used here.
C     | i.e.
C     |----------------------------------------------------------
C     | (1)  Plan view schematic of model grid (top layer i.e. )
C     |      ================================= ( ocean surface )
C     |                                        ( or top of     )
C     |                                        ( atmosphere    )
C     |      This diagram shows the location of the model
C     |      prognostic variables on the model grid. The "T"
C     |      location is used for all tracers. The figure also
C     |      shows the southern most, western most indexing
C     |      convention that is used for all model variables.
C     |
C     |
C     |             V(i=1,                     V(i=Nx,
C     |               j=Ny+1,                    j=Ny+1,
C     |               k=1)                       k=1)
C     |                /|\                       /|\  "PWX"
C     |       |---------|------------------etc..  |---- *---
C     |       |                     |                   *  |
C     |"PWY"*******************************etc..  **********"PWY"
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x           |             x     *==>U
C     |  j=Ny,|      T(i=1,         |          T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=Ny,        |            j=Ny,  *  |j=Ny,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |
C     |       .                     .                      .
C     |       .                     .                      .
C     |       .                     .                      .
C     |       e                     e                   *  e
C     |       t                     t                   *  t
C     |       c                     c                   *  c
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x           |             x     *  |
C     |  j=2, |      T(i=1,         |          T(i=Nx,  *  |
C     |  k=1) |        j=2,         |            j=2,   *  |
C     |       |        k=1)         |            k=1)   *  |
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |      -----------|------------------etc..  |-----*---
C     |       |       V(i=1,        |           V(i=Nx, *  |
C     |       |         j=2,        |             j=2,  *  |
C     |       |         k=1)        |             k=1)  *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=1,         |  k=1)      j=1,   *  |j=1,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |"SB"++>|---------|------------------etc..  |-----*---
C     |      /+\      V(i=1,                    V(i=Nx, *
C     |       +         j=1,                      j=1,  *
C     |       +         k=1)                      k=1)  *
C     |     "WB"                                      "PWX"
C     |
C     |   N, y increasing northwards
C     |  /|\ j increasing northwards
C     |   |
C     |   |
C     |   ======>E, x increasing eastwards
C     |             i increasing eastwards
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    U: x-velocity (m/s)
C     |    V: y-velocity (m/s)
C     |    T: potential temperature (oC)
C     | "SB": Southern boundary
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |"PWY": Periodic wrap around in Y.
C     |----------------------------------------------------------
C     | (2) South elevation schematic of model grid
C     |     =======================================
C     |     This diagram shows the location of the model
C     |     prognostic variables on the model grid. The "T"
C     |     location is used for all tracers. The figure also
C     |     shows the upper most, western most indexing
C     |     convention that is used for all model variables.
C     |
C     |      "WB"
C     |       +
C     |       +
C     |      \+/       /|\                       /|\       .
C     |"UB"++>|-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=1)        |             k=1)  *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=1,         |  k=1)      j=1,   *  |j=1,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |       |-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=2)        |             k=2)  *  |
C     |
C     |       .                     .                      .
C     |       .                     .                      .
C     |       .                     .                      .
C     |       e                     e                   *  e
C     |       t                     t                   *  t
C     |       c                     c                   *  c
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |       |-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=Nr)       |             k=Nr) *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=Nr)|        j=1,         |  k=Nr)     j=1,   *  |j=1,
C     |       |        k=Nr)        |            k=Nr)  *  |k=Nr)
C     |       |                     |                   *  |
C     |"LB"++>==============================================
C     |                                               "PWX"
C     |
C     | Up   increasing upwards.
C     |/|\                                                       .
C     | |
C     | |
C     | =====> E  i increasing eastwards
C     | |         x increasing eastwards
C     | |
C     |\|/
C     | Down,k increasing downwards.
C     |
C     | Note: r => height (m) => r increases upwards
C     |       r => pressure (Pa) => r increases downwards
C     |
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    U: x-velocity (m/s)
C     | rVel: z-velocity ( units of r )
C     |       The vertical velocity variable rVel is in units of
C     |       "r" the vertical coordinate. r in m will give
C     |       rVel m/s. r in Pa will give rVel Pa/s.
C     |    T: potential temperature (oC)
C     | "UB": Upper boundary.
C     | "LB": Lower boundary (always solid - therefore om|w == 0)
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |----------------------------------------------------------
C     | (3) Views showing nomenclature and indexing
C     |     for grid descriptor variables.
C     |
C     |      Fig 3a. shows the orientation, indexing and
C     |      notation for the grid spacing terms used internally
C     |      for the evaluation of gradient and averaging terms.
C     |      These varaibles are set based on the model input
C     |      parameters which define the model grid in terms of
C     |      spacing in X, Y and Z.
C     |
C     |      Fig 3b. shows the orientation, indexing and
C     |      notation for the variables that are used to define
C     |      the model grid. These varaibles are set directly
C     |      from the model input.
C     |
C     | Figure 3a
C     | =========
C     |       |------------------------------------
C     |       |                       |
C     |"PWY"********************************* etc...
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |
C     |       .                       .
C     |       .                       .
C     |       .                       .
C     |       e                       e
C     |       t                       t
C     |       c                       c
C     |       |-----------v-----------|-----------v----------|-
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       u<--dxF(i=1,j=2,k=1)--->u           t          |
C     |       |/|\       /|\          |                      |
C     |       | |         |           |                      |
C     |       | |         |           |                      |
C     |       | |         |           |                      |
C     |       |dyU(i=1,  dyC(i=1,     |                      |
C     | ---  ---|--j=2,---|--j=2,-----------------v----------|-
C     | /|\   | |  k=1)   |  k=1)     |          /|\         |
C     |  |    | |         |           |          dyF(i=2,    |
C     |  |    | |         |           |           |  j=1,    |
C     |dyG(   |\|/       \|/          |           |  k=1)    |
C     |   i=1,u---        t<---dxC(i=2,j=1,k=1)-->t          |
C     |   j=1,|                       |           |          |
C     |   k=1)|                       |           |          |
C     |  |    |                       |           |          |
C     |  |    |                       |           |          |
C     | \|/   |           |<---dxV(i=2,j=1,k=1)--\|/         |
C     |"SB"++>|___________v___________|___________v__________|_
C     |       <--dxG(i=1,j=1,k=1)----->
C     |      /+\                                              .
C     |       +
C     |       +
C     |     "WB"
C     |
C     |   N, y increasing northwards
C     |  /|\ j increasing northwards
C     |   |
C     |   |
C     |   ======>E, x increasing eastwards
C     |             i increasing eastwards
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    u: x-velocity point
C     |    V: y-velocity point
C     |    t: tracer point
C     | "SB": Southern boundary
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |"PWY": Periodic wrap around in Y.
C     |
C     | Figure 3b
C     | =========
C     |
C     |       .                       .
C     |       .                       .
C     |       .                       .
C     |       e                       e
C     |       t                       t
C     |       c                       c
C     |       |-----------v-----------|-----------v--etc...
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       u<--delX(i=1)---------->u           t
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |-----------v-----------------------v--etc...
C     |       |          /|\          |
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       u        delY(j=1)      |           t
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       |          \|/          |
C     |"SB"++>|___________v___________|___________v__etc...
C     |      /+\                                                 .
C     |       +
C     |       +
C     |     "WB"
C     |
C     *==========================================================*
C     \ev
CEOP

C     Macros that override/modify standard definitions
C
CBOP
C    !ROUTINE: GRID_MACROS.h
C    !INTERFACE:
C    include GRID_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | GRID_MACROS.h
C     *==========================================================*
C     | These macros are used to substitute definitions for
C     | GRID.h variables for particular configurations.
C     | In setting these variables the following convention
C     | applies.
C     | undef  phi_CONST   - Indicates the variable phi is fixed
C     |                      in X, Y and Z.
C     | undef  phi_FX      - Indicates the variable phi only
C     |                      varies in X (i.e.not in X or Z).
C     | undef  phi_FY      - Indicates the variable phi only
C     |                      varies in Y (i.e.not in X or Z).
C     | undef  phi_FXY     - Indicates the variable phi only
C     |                      varies in X and Y ( i.e. not Z).
C     *==========================================================*
C     \ev
CEOP

C
CBOP
C    !ROUTINE: DXC_MACROS.h
C    !INTERFACE:
C    include DXC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXC_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DXF_MACROS.h
C    !INTERFACE:
C    include DXF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXF_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DXG_MACROS.h
C    !INTERFACE:
C    include DXG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXG_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DXV_MACROS.h
C    !INTERFACE:
C    include DXV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXV_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DYC_MACROS.h
C    !INTERFACE:
C    include DYC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYC_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DYF_MACROS.h
C    !INTERFACE:
C    include DYF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYF_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DYG_MACROS.h
C    !INTERFACE:
C    include DYG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYG_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DYU_MACROS.h
C    !INTERFACE:
C    include DYU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYU_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: HFACC_MACROS.h
C    !INTERFACE:
C    include HFACC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACC_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: HFACS_MACROS.h
C    !INTERFACE:
C    include HFACS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACS_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: HFACW_MACROS.h
C    !INTERFACE:
C    include HFACW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACW_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: RECIP_DXC_MACROS.h
C    !INTERFACE:
C    include RECIP_DXC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXC_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DXF_MACROS.h
C    !INTERFACE:
C    include RECIP_DXF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXF_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DXG_MACROS.h
C    !INTERFACE:
C    include RECIP_DXG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXG_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DXV_MACROS.h
C    !INTERFACE:
C    include RECIP_DXV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXV_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DYC_MACROS.h
C    !INTERFACE:
C    include RECIP_DYC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYC_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DYF_MACROS.h
C    !INTERFACE:
C    include RECIP_DYF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYF_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DYG_MACROS.h
C    !INTERFACE:
C    include RECIP_DYG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYG_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DYU_MACROS.h
C    !INTERFACE:
C    include RECIP_DYU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYU_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_HFACC_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACC_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: RECIP_HFACS_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACS_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: RECIP_HFACW_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACW_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: XC_MACROS.h
C    !INTERFACE:
C    include XC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | XC_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: YC_MACROS.h
C    !INTERFACE:
C    include YC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | YC_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RA_MACROS.h
C    !INTERFACE:
C    include RA_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RA_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP




C
CBOP
C    !ROUTINE: RAW_MACROS.h
C    !INTERFACE:
C    include RAW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RAW_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP




C
CBOP
C    !ROUTINE: RAS_MACROS.h
C    !INTERFACE:
C    include RAS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RAS_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: MASKW_MACROS.h
C    !INTERFACE:
C    include MASKW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | MASKW_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP






C
CBOP
C    !ROUTINE: MASKS_MACROS.h
C    !INTERFACE:
C    include MASKS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | MASKS_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP






C
CBOP
C    !ROUTINE: TANPHIATU_MACROS.h
C    !INTERFACE:
C    include TANPHIATU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | TANPHIATU_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: TANPHIATV_MACROS.h
C    !INTERFACE:
C    include TANPHIATV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | TANPHIATV_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: FCORI_MACROS.h
C    !INTERFACE:
C    include FCORI_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | FCORI_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C--   COMMON /GRID_RL/ RL valued grid defining variables.
C     deepFacC  :: deep-model grid factor (fct of vertical only) for dx,dy
C     deepFacF     at level-center (deepFacC)  and level interface (deepFacF)
C     deepFac2C :: deep-model grid factor (fct of vertical only) for area dx*dy
C     deepFac2F    at level-center (deepFac2C) and level interface (deepFac2F)
C     gravitySign :: indicates the direction of gravity relative to R direction
C                   (= -1 for R=Z (Z increases upward, -gravity direction  )
C                   (= +1 for R=P (P increases downward, +gravity direction)
C     rkSign     :: Vertical coordinate to vertical index orientation.
C                   ( +1 same orientation, -1 opposite orientation )
C     globalArea :: Domain Integrated horizontal Area [m2]
      COMMON /GRID_RL/
     &  cosFacU, cosFacV, sqCosFacU, sqCosFacV,
     &  deepFacC, deepFac2C, recip_deepFacC, recip_deepFac2C,
     &  deepFacF, deepFac2F, recip_deepFacF, recip_deepFac2F,
     &  gravitySign, rkSign, globalArea
      Real*8 cosFacU        (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 cosFacV        (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sqCosFacU      (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sqCosFacV      (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 deepFacC       (Nr)
      Real*8 deepFac2C      (Nr)
      Real*8 deepFacF       (Nr+1)
      Real*8 deepFac2F      (Nr+1)
      Real*8 recip_deepFacC (Nr)
      Real*8 recip_deepFac2C(Nr)
      Real*8 recip_deepFacF (Nr+1)
      Real*8 recip_deepFac2F(Nr+1)
      Real*8 gravitySign
      Real*8 rkSign
      Real*8 globalArea

C--   COMMON /GRID_RS/ RS valued grid defining variables.
C     dxC     :: Cell center separation in X across western cell wall (m)
C     dxG     :: Cell face separation in X along southern cell wall (m)
C     dxF     :: Cell face separation in X thru cell center (m)
C     dxV     :: V-point separation in X across south-west corner of cell (m)
C     dyC     :: Cell center separation in Y across southern cell wall (m)
C     dyG     :: Cell face separation in Y along western cell wall (m)
C     dyF     :: Cell face separation in Y thru cell center (m)
C     dyU     :: U-point separation in Y across south-west corner of cell (m)
C     drC     :: Cell center separation along Z axis ( units of r ).
C     drF     :: Cell face separation along Z axis ( units of r ).
C     R_low   :: base of fluid in r_unit (Depth(m) / Pressure(Pa) at top Atmos.)
C     rLowW   :: base of fluid column in r_unit at Western  edge location.
C     rLowS   :: base of fluid column in r_unit at Southern edge location.
C     Ro_surf :: surface reference (at rest) position, r_unit.
C     rSurfW  :: surface reference position at Western  edge location [r_unit].
C     rSurfS  :: surface reference position at Southern edge location [r_unit].
C     hFac    :: Fraction of cell in vertical which is open i.e how
C              "lopped" a cell is (dimensionless scale factor).
C              Note: The code needs terms like MIN(hFac,hFac(I-1))
C                    On some platforms it may be better to precompute
C                    hFacW, hFacS, ... here than do MIN on the fly.
C     maskInC :: Cell Center 2-D Interior mask (i.e., zero beyond OB)
C     maskInW :: West  face 2-D Interior mask (i.e., zero on and beyond OB)
C     maskInS :: South face 2-D Interior mask (i.e., zero on and beyond OB)
C     maskC   :: cell Center land mask
C     maskW   :: West face land mask
C     maskS   :: South face land mask
C     recip_dxC   :: Reciprocal of dxC
C     recip_dxG   :: Reciprocal of dxG
C     recip_dxF   :: Reciprocal of dxF
C     recip_dxV   :: Reciprocal of dxV
C     recip_dyC   :: Reciprocal of dxC
C     recip_dyG   :: Reciprocal of dyG
C     recip_dyF   :: Reciprocal of dyF
C     recip_dyU   :: Reciprocal of dyU
C     recip_drC   :: Reciprocal of drC
C     recip_drF   :: Reciprocal of drF
C     recip_Rcol  :: Inverse of cell center column thickness (1/r_unit)
C     recip_hFacC :: Inverse of cell open-depth f[X,Y,Z] ( dimensionless ).
C     recip_hFacW    rhFacC center, rhFacW west, rhFacS south.
C     recip_hFacS   Note: This is precomputed here because it involves division.
C     xC     :: X-coordinate of cell center f[X,Y]. The units of xc, yc
C               depend on the grid. They are not used in differencing or
C               averaging but are just a convient quantity for I/O,
C               diagnostics etc.. As such xc is in m for cartesian
C               coordinates but degrees for spherical polar.
C     yC     :: Y-coordinate of center of cell f[X,Y].
C     yG     :: Y-coordinate of corner of cell (c-grid vorticity point) f[X,Y].
C     rA     :: R-face are f[X,Y] ( m^2 ).
C               Note: In a cartesian framework rA is simply dx*dy,
C                   however we use rA to allow for non-globally
C                   orthogonal coordinate frames (with appropriate
C                   metric terms).
C     rC     :: R-coordinate of center of cell f[Z] (units of r).
C     rF     :: R-coordinate of face of cell f[Z] (units of r).
C - *HybSigm* - :: Hybrid-Sigma vert. Coord coefficients
C     aHybSigmF    at level-interface (*HybSigmF) and level-center (*HybSigmC)
C     aHybSigmC    aHybSigm* = constant r part, bHybSigm* = sigma part, such as
C     bHybSigmF    r(ij,k,t) = rLow(ij) + aHybSigm(k)*[rF(1)-rF(Nr+1)]
C     bHybSigmC              + bHybSigm(k)*[eta(ij,t)+Ro_surf(ij) - rLow(ij)]
C     dAHybSigF :: vertical increment of Hybrid-Sigma coeff.: constant r part,
C     dAHybSigC    between interface (dAHybSigF) and between center (dAHybSigC)
C     dBHybSigF :: vertical increment of Hybrid-Sigma coefficient: sigma part,
C     dBHybSigC    between interface (dBHybSigF) and between center (dBHybSigC)
C     tanPhiAtU :: tan of the latitude at U point. Used for spherical polar
C                  metric term in U equation.
C     tanPhiAtV :: tan of the latitude at V point. Used for spherical polar
C                  metric term in V equation.
C     angleCosC :: cosine of grid orientation angle relative to Geographic
C direction at cell center: alpha=(Eastward_dir,grid_uVel_dir)=(North_d,vVel_d)
C     angleSinC :: sine   of grid orientation angle relative to Geographic
C direction at cell center: alpha=(Eastward_dir,grid_uVel_dir)=(North_d,vVel_d)
C     u2zonDir  :: cosine of grid orientation angle at U point location
C     v2zonDir  :: minus sine of  orientation angle at V point location
C     fCori     :: Coriolis parameter at grid Center point
C     fCoriG    :: Coriolis parameter at grid Corner point
C     fCoriCos  :: Coriolis Cos(phi) parameter at grid Center point (for NH)

      COMMON /GRID_RS/
     &  dxC,dxF,dxG,dxV,dyC,dyF,dyG,dyU,
     &  rLowW, rLowS,
     &  Ro_surf, rSurfW, rSurfS,
     &  recip_dxC,recip_dxF,recip_dxG,recip_dxV,
     &  recip_dyC,recip_dyF,recip_dyG,recip_dyU,
     &  xC,yC,rA,rAw,rAs,rAz,xG,yG,
     &  maskInC, maskInW, maskInS,
     &  maskC, maskW, maskS,
     &  recip_rA,recip_rAw,recip_rAs,recip_rAz,
     &  drC, drF, recip_drC, recip_drF, rC, rF,
     &  aHybSigmF, bHybSigmF, aHybSigmC, bHybSigmC,
     &  dAHybSigF, dBHybSigF, dBHybSigC, dAHybSigC,
     &  tanPhiAtU, tanPhiAtV,
     &  angleCosC, angleSinC, u2zonDir, v2zonDir,
     &  fCori, fCoriG, fCoriCos
      Real*8 dxC            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxF            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxG            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxV            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyC            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyF            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyG            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyU            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rLowW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rLowS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Ro_surf        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rSurfW         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rSurfS         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxF      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxG      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxV      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyF      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyG      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyU      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 xC             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 xG             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 yC             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 yG             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rA             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAw            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAs            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAz            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rA       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAw      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAs      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAz      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInC        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInW        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInS        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskC          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 maskW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 maskS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 drC            (Nr+1)
      Real*8 drF            (Nr)
      Real*8 recip_drC      (Nr+1)
      Real*8 recip_drF      (Nr)
      Real*8 rC             (Nr)
      Real*8 rF             (Nr+1)
      Real*8 aHybSigmF      (Nr+1)
      Real*8 bHybSigmF      (Nr+1)
      Real*8 aHybSigmC      (Nr)
      Real*8 bHybSigmC      (Nr)
      Real*8 dAHybSigF      (Nr)
      Real*8 dBHybSigF      (Nr)
      Real*8 dBHybSigC      (Nr+1)
      Real*8 dAHybSigC      (Nr+1)
      Real*8 tanPhiAtU      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 tanPhiAtV      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 angleCosC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 angleSinC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 u2zonDir       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 v2zonDir       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCori          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCoriG         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCoriCos       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C--   COMMON /GRID_VAR_RS/ potentially time-dependent or active RS
C     valued grid defining variables. These grid defining variables are
C     time-dependent when using a non-linear free surface, or they are
C     active in an AD sense when using depth as a control parameter, or
C     both.
      COMMON /GRID_VAR_RS/
     &  hFacC, hFacW, hFacS,
     &  recip_hFacC,recip_hFacW,recip_hFacS,
     &  R_low, recip_Rcol
      Real*8 hFacC          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 hFacW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 hFacS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_hFacC    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_hFacW    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_hFacS    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 R_low          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_Rcol     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)


C--   COMMON /GRID_I/ INTEGER valued grid defining variables.
C     kSurfC  :: vertical index of the surface tracer cell
C     kSurfW  :: vertical index of the surface U point
C     kSurfS  :: vertical index of the surface V point
C     kLowC   :: index of the r-lowest "wet cell" (2D)
C IMPORTANT: kLowC = 0 and kSurfC,W,S = Nr+1 (or =Nr+2 on a thin-wall)
C            where the fluid column is empty (continent)
      COMMON /GRID_I/
     &  kSurfC, kSurfW, kSurfS,
     &  kLowC
      INTEGER kSurfC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kSurfW(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kSurfS(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kLowC (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
C     ==================================================================
C     HEADER calendar
C     ==================================================================
C
C     o This header file contains variables that are used by the
C       calendar tool. The calendar tool can be used in the ECCO
C       SEALION release of the MITgcmUV.
C
C     started: Christian Eckert eckert@mit.edu  30-Jun-1999
C     changed: Christian Eckert eckert@mit.edu  17-Dec-1999
C              - restructured the original version in order to have a
C                better interface to the MITgcmUV.
C
C     ==================================================================
C     HEADER calendar
C     ==================================================================

C   - Parameters of the numerical model:
C
C     modelStart       :: start time of the numerical model.
C     modelStartDate   :: start date of the numerical model.
C     modelEnd         :: end   time of the numerical model.
C     modelEndDate     :: end   date of the numerical model.
C     modelStep        :: timestep of the numerical model.
C     modelIntSteps    :: number of timestep that are to be performed.
C     modelIter0       :: the numerical models initial timestep number.
C     modelIterEnd     :: the models last timestep number.
C     modelStepsperday :: number of model time steps per day (<- removed).

C   - Parameters used by the calendar:
C
C     refDate          :: first day of the Gregorian Calendar.
C     nMonthYear       :: number months in a year.
C     nDayMonth        :: days per month depending on the year being a leap
C                         year or not. If the Model calendar is used a 360
C                         days year with 30 days months is used instead.
C     nDaysNoLeap      :: number of days in a usual year.
C     nDaysLeap        :: number of days in a leap year.
C     nMaxDayMonth     :: maximum number of days in a years month.
C     hoursPerDay      :: number of hours   in a calendars day.
C     minutesPerDay    :: number of minutes in a calendars day.
C     minutesPerHour   :: number of minutes in a calendars hour.
C     secondsPerDay    :: number of seconds in a calendars day.
C     secondsPerHour   :: number of seconds in a calendars hour.
C     secondsPerMinute :: number of seconds in a calendars minute.
C     cal_setStatus    :: status of calendar parms setting (0=none, 3=fully set)

      INTEGER nMonthYear
      PARAMETER ( nMonthYear = 12 )

      COMMON /CALENDAR_RL/
     &                modelStart,
     &                modelEnd,
     &                modelStep
      Real*8 modelStart
      Real*8 modelEnd
      Real*8 modelStep

      COMMON /CALENDAR_I/
     &               refDate,
     &               nDayMonth,
     &               nDaysNoLeap,
     &               nDaysLeap,
     &               nMaxDayMonth,
     &               hoursPerDay,
     &               minutesPerDay,
     &               minutesPerHour,
     &               secondsPerDay,
     &               secondsPerHour,
     &               secondsPerMinute,
     &               modelStartDate,
     &               modelEndDate,
     &               modelIter0,
     &               modelIterEnd,
     &               modelIntSteps,
     &               cal_setStatus,
     &               startdate_1,
     &               startdate_2

      INTEGER refDate(4)
      INTEGER nDayMonth(nMonthYear,2)
      INTEGER nDaysNoLeap
      INTEGER nDaysLeap
      INTEGER nMaxDayMonth
      INTEGER hoursPerDay
      INTEGER minutesPerDay
      INTEGER minutesPerHour
      INTEGER secondsPerDay
      INTEGER secondsPerHour
      INTEGER secondsPerMinute

      INTEGER modelStartDate(4)
      INTEGER modelEndDate(4)
      INTEGER modelIter0
      INTEGER modelIterEnd
      INTEGER modelIntSteps

      INTEGER cal_setStatus
      INTEGER startdate_1
      INTEGER startdate_2

C   calendarDumps :: When set, approximate months (30-31 days) and years (360-372 days)
C                    for parameters chkPtFreq, pChkPtFreq, taveFreq, SEAICE_taveFreq,
C                    KPP_taveFreq, and freq in pkg/diagnostics are converted to exact
C                    calendar months and years.  Requires pkg/cal.
      COMMON /CALENDAR_L/
     &               calendarDumps,
     &               usingModelCalendar,
     &               usingNoLeapYearCal,
     &               usingJulianCalendar,
     &               usingGregorianCalendar
      LOGICAL calendarDumps
      LOGICAL usingModelCalendar
      LOGICAL usingNoLeapYearCal
      LOGICAL usingJulianCalendar
      LOGICAL usingGregorianCalendar

C     theCalendar :: type of calendar to use; available:
C                    'model', 'gregorian' or 'noLeapYear'.
C     dayOfWeek   :: Week day number one is the week day of refDate.
C                    For the Gregorian calendar this is Friday, 15-Oct-1582.
C     monthOfYear :: Both available calendars are assumed to have twelve
C                    months.
      COMMON /CALENDAR_C/
     &                     theCalendar,
     &                     dayOfWeek,
     &                     monthOfYear
      CHARACTER*(20) theCalendar
      CHARACTER*(3) dayOfWeek(7)
      CHARACTER*(3) monthOfYear(nMonthYear)

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
      integer myThid


c     == functions ==
      LOGICAL  MASTER_CPU_THREAD
      EXTERNAL MASTER_CPU_THREAD
      INTEGER  ILNBLNK
      EXTERNAL ILNBLNK

c     == local variables ==

      integer bi,bj
      integer i,j,k
      integer itlo,ithi
      integer jtlo,jthi
      integer jmin,jmax
      integer imin,imax
      integer irec,jrec,krec
      integer ilps

      logical doglobalread
      logical ladinit

c mapping to gencost
      integer igen_mdt, igen_lsc, igen_gmsl
      integer igen_tp, igen_ers, igen_gfo
      integer igen_etaday

      Real*8 spval, factor
      Real*8 offset
      Real*8 offset_sum
      Real*8 slaoffset
      Real*8 slaoffset_sum
      Real*8 slaoffset_weight

c local arrays
      Real*8 num0array ( 1-OLx:sNx+OLx, 1-OLy:sNy+OLy, nSx, nSy )
      Real*8 num0total
      integer tempinteger

      Real*8 diagnosfld ( 1-OLx:sNx+OLx, 1-OLy:sNy+OLy, nSx, nSy )

      Real*8 mdtob(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 tpob(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 ersob(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 gfoob(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 mdtma(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 tpma(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 ersma(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 gfoma(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 etaday(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      character*(MAX_LEN_FNAM) mdtfi, tpfi, ersfi, gfofi
      integer tpsta(4), erssta(4), gfosta(4)
      integer mdtsta(4), mdtend(4)
      Real*8 tpper, ersper, gfoper

c for PART 1: re-reference MDT (mdt) to the inferred SLA reference field
      Real*8 psmean    ( 1-OLx:sNx+OLx, 1-OLy:sNy+OLy, nSx, nSy )
      Real*8 mean_slaobs_mdt(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 mean_slaobs_NUM(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

c for PART 2: compute time mean differences over the model period
      Real*8 mean_slaobs_model(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 mean_psMssh_all(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 mean_psMssh_all_NUM(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 mean_psMssh_all_MSK(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      Real*8 mean_psMslaobs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 mean_psMslaobs_MSK(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      Real*8 mean_psMtpobs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 mean_psMtpobs_NUM(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      Real*8 mean_psMersobs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 mean_psMersobs_NUM(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      Real*8 mean_psMgfoobs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 mean_psMgfoobs_NUM(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

c for PART 4/5: compute smooth/raw anomalies
      Real*8 anom_psMslaobs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 anom_psMslaobs_NUM (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 anom_psMslaobs_MSK (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 anom_psMslaobs_SUB (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 anom_slaobs (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 anom_slaobs_SUB  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      Real*8 anom_psMtpobs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 anom_tpobs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      Real*8 anom_psMersobs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 anom_ersobs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      Real*8 anom_psMgfoobs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 anom_gfoobs(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      integer mdt_y0,mdt_y1,year,day
      integer num0

      Real*8 junk,junkweight

      integer ndaysave
      Real*8 ndaysaveRL

      integer k2, k2_mdt, k2_lsc
      logical dosumsq

      character*(80) fname
      character*(80) fname4test
      character*(MAX_LEN_MBUF) msgbuf

      LOGICAL doReference
      LOGICAL useEtaMean

c     == end of interface ==

C-    Initialise (again) gencost_weight
      DO k = 1, NGENCOST
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         DO j=1-OLy,sNy+OLy
          DO i=1-OLx,sNx+OLx
           gencost_weight(i,j,bi,bj,k) = 0.D0
          ENDDO
         ENDDO
        ENDDO
       ENDDO
      ENDDO

      jtlo = myByLo(myThid)
      jthi = myByHi(myThid)
      itlo = myBxLo(myThid)
      ithi = myBxHi(myThid)
      jmin = 1
      jmax = sNy
      imin = 1
      imax = sNx

c-- detect the relevant gencost indices
      igen_mdt=0
      igen_tp =0
      igen_ers=0
      igen_gfo=0
      igen_lsc=0
      igen_gmsl=0
      igen_etaday=0
      do k=1,NGENCOST
        if (gencost_name(k).EQ.'sshv4-mdt') igen_mdt=k
        if (gencost_name(k).EQ.'sshv4-tp') igen_tp=k
        if (gencost_name(k).EQ.'sshv4-ers') igen_ers=k
        if (gencost_name(k).EQ.'sshv4-gfo') igen_gfo=k
        if (gencost_name(k).EQ.'sshv4-lsc') igen_lsc=k
        if (gencost_name(k).EQ.'sshv4-gmsl') igen_gmsl=k
      enddo

      k2_mdt=0
      k2_lsc=0
      if (igen_mdt.GT.0) then
       do k2 = 1, NGENPPROC
        if (gencost_posproc(k2,igen_mdt).EQ.'smooth') k2_mdt=k2
       enddo
      endif
      if (igen_lsc.GT.0) then
       do k2 = 1, NGENPPROC
        if (gencost_posproc(k2,igen_lsc).EQ.'smooth') k2_lsc=k2
       enddo
      endif

      dosumsq = .TRUE.
      if (igen_mdt.GT.0) then
       call ecco_zero( gencost_weight(1-OLx,1-OLy,1,1,igen_mdt),
     &                 1, zeroRL, myThid )
       if ( gencost_errfile(igen_mdt) .NE. ' ' )
     &   call ecco_readwei( gencost_errfile(igen_mdt),
     &     gencost_weight(1-OLx,1-OLy,1,1,igen_mdt),
     &     1, 1, 1, dosumsq, myThid )
      endif
      if (igen_lsc.GT.0) then
       call ecco_zero( gencost_weight(1-OLx,1-OLy,1,1,igen_lsc),
     &                 1, zeroRL, myThid )
       if ( gencost_errfile(igen_lsc) .NE. ' ' )
     &   call ecco_readwei( gencost_errfile(igen_lsc),
     &     gencost_weight(1-OLx,1-OLy,1,1,igen_lsc),
     &     1, 1, 1, dosumsq, myThid )
      endif
      if (igen_tp.GT.0) then
       call ecco_zero( gencost_weight(1-OLx,1-OLy,1,1,igen_tp),
     &                 1, zeroRL, myThid )
       if ( gencost_errfile(igen_tp) .NE. ' ' )
     &   call ecco_readwei( gencost_errfile(igen_tp),
     &     gencost_weight(1-OLx,1-OLy,1,1,igen_tp),
     &     1, 1, 1, dosumsq, myThid )
      endif
      if (igen_ers.GT.0) then
       call ecco_zero( gencost_weight(1-OLx,1-OLy,1,1,igen_ers),
     &                 1, zeroRL, myThid )
       if ( gencost_errfile(igen_ers) .NE. ' ' )
     &   call ecco_readwei( gencost_errfile(igen_ers),
     &     gencost_weight(1-OLx,1-OLy,1,1,igen_ers),
     &     1, 1, 1, dosumsq, myThid )
      endif
      if (igen_gfo.GT.0) then
       call ecco_zero( gencost_weight(1-OLx,1-OLy,1,1,igen_gfo),
     &                 1, zeroRL, myThid )
       if ( gencost_errfile(igen_gfo) .NE. ' ' )
     &   call ecco_readwei( gencost_errfile(igen_gfo),
     &     gencost_weight(1-OLx,1-OLy,1,1,igen_gfo),
     &     1, 1, 1, dosumsq, myThid )
      endif

c switch for excluding global mean
      useEtaMean=.TRUE.

      write(msgbuf,'(a,l)')
     & ' sshv4: use global mean of eta useEtaMean=',useEtaMean
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , myThid)

c minimum number of observations to consider re-referenced MDT
      num0=100
c determine whether or not to re-reference
c-- not only model period has to fall within the mdt period
c-- but that there has to be at least 365 days of model run
c-- so for short model run, this will always get set to FALSE
      doReference=.FALSE.
      if ((modelstartdate(1).GT.1992*10000).AND.
     &    (modelstartdate(1).LT.2011*10000).AND.
     &    (ndaysrec.GE.365))  doReference=.TRUE.

      write(msgbuf,'(a,l)') ' sshv4:re-reference MDT=',doReference
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , myThid)

c-- initialize local arrays
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
              mdtma(i,j,bi,bj) = 0.D0
              mdtob(i,j,bi,bj) = 0.D0
              tpma(i,j,bi,bj) = 0.D0
              tpob(i,j,bi,bj) = 0.D0
              ersma(i,j,bi,bj) = 0.D0
              ersob(i,j,bi,bj) = 0.D0
              gfoma(i,j,bi,bj) = 0.D0
              gfoob(i,j,bi,bj) = 0.D0
            enddo
          enddo
        enddo
      enddo

c mdtfi, mdtsta, mdtend
      if (igen_mdt.GT.0) then
       ilps=ilnblnk( gencost_datafile(igen_mdt) )
       mdtfi=gencost_datafile(igen_mdt)(1:ilps)
       call cal_CopyDate(gencost_startdate(1,igen_mdt),mdtsta,myThid)
       call cal_CopyDate(gencost_enddate(1,igen_mdt), mdtend, myThid)
       if (gencost_barfile(igen_mdt)(1:5).EQ.'m_eta')
     &    igen_etaday=igen_mdt
      endif
c tpfi, tpsta, tpper
      if (igen_tp.GT.0) then
       ilps=ilnblnk( gencost_datafile(igen_tp) )
       tpfi=gencost_datafile(igen_tp)(1:ilps)
       call cal_CopyDate(gencost_startdate(1,igen_tp),tpsta,myThid)
       tpper=gencost_period(igen_tp)
       if (gencost_barfile(igen_tp)(1:5).EQ.'m_eta')
     &    igen_etaday=igen_tp
      endif
c ersfi, erssta, ersper
      if (igen_ers.GT.0) then
       ilps=ilnblnk( gencost_datafile(igen_ers) )
       ersfi=gencost_datafile(igen_ers)(1:ilps)
       call cal_CopyDate(gencost_startdate(1,igen_ers),erssta,myThid)
       ersper=gencost_period(igen_ers)
       if (gencost_barfile(igen_ers)(1:5).EQ.'m_eta')
     &    igen_etaday=igen_ers
      endif
c gfofi, gfosta, gfoper
      if (igen_gfo.GT.0) then
       ilps=ilnblnk( gencost_datafile(igen_gfo) )
       gfofi=gencost_datafile(igen_gfo)(1:ilps)
       call cal_CopyDate(gencost_startdate(1,igen_gfo),gfosta,myThid)
       gfoper=gencost_period(igen_gfo)
       if (gencost_barfile(igen_gfo)(1:5).EQ.'m_eta')
     &    igen_etaday=igen_gfo
      endif

c mdt_y0, mdt_y1
       mdt_y0=mdtsta(1)/10000
       mdt_y1=mdtend(1)/10000

       write(msgbuf,'(a,i8,a,i8)')
     &  'mdt[start,end]date(1): ', mdtsta(1), ',', mdtend(1)
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , myThid)
        write(msgbuf,'(a,i4,a,i4)')
     &  '  TP MDT yrrange:          ', mdt_y0, ',', mdt_y1
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , myThid)

c--   First, read tiled data.
      doglobalread = .false.
      ladinit      = .false.

      write(fname(1:80),'(80a)') ' '
      ilps=ilnblnk( gencost_barfile(igen_etaday) )
      write(fname(1:80),'(2a,i10.10)')
     &     gencost_barfile(igen_etaday)(1:ilps),'.',eccoiter

cgf =======================================================
cgf PART 1:
cgf        x Get the MDT (mdt) ... compute the sample mean
cgf        (mean_slaobs_mdt) of the SLA data (i.e. RADS for tp, ers, and gfo
cgf        together) over the time interval of the MDT ... subtract
cgf        mean_slaobs_mdt from mdt.
cgf        x At this point, mdt is the inferred SLA reference field.
cgf        x From there on, mdt+sla will be directly comparable to
cgf        the model SSH (etaday).
cgf =======================================================

c--   Read mean field and mask

      if (using_mdt)
     &  CALL READ_REC_3D_RL( mdtfi, cost_iprec, 1,
     &                       mdtob, 1, 1, myThid )

      factor =  0.01D0
      spval  = -9990.D0

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
              if ( (maskInC(i,j,bi,bj) .EQ. 0.).OR.
     &             (R_low(i,j,bi,bj).GT.-200.).OR.
     &             (mdtob(i,j,bi,bj) .LT. spval ).OR.
     &             (mdtob(i,j,bi,bj) .EQ. 0.D0) ) then
                mdtma(i,j,bi,bj) = 0.D0
                mdtob(i,j,bi,bj) = 0.D0
              else
                mdtma(i,j,bi,bj) = 1.D0
                mdtob(i,j,bi,bj) = mdtob(i,j,bi,bj)*factor
              endif
            enddo
          enddo
        enddo
      enddo

c--   Compute mean_slaobs_mdt: sample mean SLA over the time period of mdt.

       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
              mean_slaobs_mdt(i,j,bi,bj)  = 0.D0
              mean_slaobs_NUM(i,j,bi,bj)  = 0.D0
          enddo
         enddo
        enddo
       enddo

      do year=mdt_y0,mdt_y1
       do day=1,366

       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
              tpma(i,j,bi,bj) = 0.D0
              tpob(i,j,bi,bj) = 0.D0
              ersma(i,j,bi,bj) = 0.D0
              ersob(i,j,bi,bj) = 0.D0
              gfoma(i,j,bi,bj) = 0.D0
              gfoob(i,j,bi,bj) = 0.D0
          enddo
         enddo
        enddo
       enddo

       if (using_tpj)
     & call cost_sla_read_yd( tpfi, tpsta,
     &                tpob, tpma,
     &                year, day, myThid )
       if (using_ers)
     & call cost_sla_read_yd( ersfi, erssta,
     &                ersob, ersma,
     &                year, day, myThid )
       if (using_gfo)
     & call cost_sla_read_yd( gfofi, gfosta,
     &                gfoob, gfoma,
     &                year, day, myThid )

       if (igen_tp .GT. 0) then
        do bj = jtlo,jthi
         do bi = itlo,ithi
          do j = jmin,jmax
           do i = imin,imax
      if ( tpma(i,j,bi,bj)*mdtma(i,j,bi,bj)*
     &    gencost_weight(i,j,bi,bj,igen_tp) .NE. 0. ) then
          mean_slaobs_mdt(i,j,bi,bj)= mean_slaobs_mdt(i,j,bi,bj)+
     &  tpob(i,j,bi,bj)
          mean_slaobs_NUM(i,j,bi,bj)= mean_slaobs_NUM(i,j,bi,bj)+1.D0
      endif
           enddo
          enddo
         enddo
        enddo
       endif
       if (igen_ers .GT. 0) then
        do bj = jtlo,jthi
         do bi = itlo,ithi
          do j = jmin,jmax
           do i = imin,imax
      if ( ersma(i,j,bi,bj)*mdtma(i,j,bi,bj)*
     &    gencost_weight(i,j,bi,bj,igen_ers) .NE. 0. ) then
          mean_slaobs_mdt(i,j,bi,bj)= mean_slaobs_mdt(i,j,bi,bj)+
     &  ersob(i,j,bi,bj)
          mean_slaobs_NUM(i,j,bi,bj)= mean_slaobs_NUM(i,j,bi,bj)+1.D0
      endif
           enddo
          enddo
         enddo
        enddo
       endif
       if (igen_gfo .GT. 0) then
        do bj = jtlo,jthi
         do bi = itlo,ithi
          do j = jmin,jmax
           do i = imin,imax
      if ( gfoma(i,j,bi,bj)*mdtma(i,j,bi,bj)*
     &    gencost_weight(i,j,bi,bj,igen_gfo) .NE. 0. ) then
          mean_slaobs_mdt(i,j,bi,bj)= mean_slaobs_mdt(i,j,bi,bj)+
     &  gfoob(i,j,bi,bj)
          mean_slaobs_NUM(i,j,bi,bj)= mean_slaobs_NUM(i,j,bi,bj)+1.D0
      endif
           enddo
          enddo
         enddo
        enddo
       endif

       enddo !do day=1,366
      enddo !do year=mdt_y0,mdt_y1

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
               if ( ( mean_slaobs_NUM(i,j,bi,bj) .NE. 0. ).AND.
     &              ( maskc(i,j,1,bi,bj) .NE. 0. ).AND.
     &              ( mdtma(i,j,bi,bj) .NE. 0. ) ) then
                  mean_slaobs_mdt(i,j,bi,bj) =
     &                 mean_slaobs_mdt(i,j,bi,bj) /
     &                 mean_slaobs_NUM(i,j,bi,bj)
               else
                  mean_slaobs_mdt(i,j,bi,bj) = 0.D0
               endif
            enddo
          enddo
        enddo
      enddo

c--   smooth mean_slaobs_mdt:

      if (igen_mdt.GT.0) then
       if (gencost_outputlevel(igen_mdt).GT.0) then
        write(fname4test(1:80),'(1a)') 'sla2mdt_raw'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        mean_slaobs_mdt, 1, 1, myThid )
       endif

c     endif igen_mdt .gt. 0
      endif

c--   re-reference mdt:
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax
               if ( ( mdtma(i,j,bi,bj) .NE. 0. ).AND.
     &              ( maskc(i,j,1,bi,bj) .NE. 0. ).AND.
     &              ( doReference ) ) then
                  mdtob(i,j,bi,bj) = mdtob(i,j,bi,bj)
     &                 -mean_slaobs_mdt(i,j,bi,bj)
               endif
            enddo
          enddo
        enddo
      enddo

cgf =======================================================
cgf PART 2: compute sample means of etaday-slaobs over the
cgf         period that is covered by the model (i.e. etaday).
cgf       x for all SLA data sets together: mean_psMssh_all, mean_psMssh_all_MSK,
cgf         and offset will be used in PART 3 (MDT cost term).
cgf       x for each SLA data individually. mean_psMtpobs, mean_psMtpobs_MS, etc.
cgf         will be used in PART 4&5 (SLA cost terms).
cgf =======================================================

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax

              psmean(i,j,bi,bj)    = 0.D0
              mean_psMslaobs(i,j,bi,bj)  = 0.D0
              mean_psMtpobs(i,j,bi,bj)  = 0.D0
              mean_psMersobs(i,j,bi,bj) = 0.D0
              mean_psMgfoobs(i,j,bi,bj) = 0.D0
              mean_psMssh_all(i,j,bi,bj) = 0.D0
              mean_slaobs_model(i,j,bi,bj)  = 0.D0

              mean_psMtpobs_NUM(i,j,bi,bj)  = 0.D0
              mean_psMersobs_NUM(i,j,bi,bj) = 0.D0
              mean_psMgfoobs_NUM(i,j,bi,bj) = 0.D0
              mean_psMssh_all_NUM(i,j,bi,bj) = 0.D0
              mean_psMslaobs_MSK(i,j,bi,bj)  = 0.D0

            enddo
          enddo
        enddo
      enddo
      offset     = 0.D0
      offset_sum = 0.D0

      do irec = 1, ndaysrec

        call active_read_xy( fname, etaday, irec, doglobalread,
     &                       ladinit, eccoiter, myThid,
     &                       gencost_dummy(igen_etaday) )

        if (.NOT.useEtaMean)
     &  CALL REMOVE_MEAN_RL( 1, etaday, maskInC, maskInC, rA, drF,
     &                       'etaday', zeroRL, 1, myThid )

       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
              tpma(i,j,bi,bj) = 0.D0
              tpob(i,j,bi,bj) = 0.D0
              ersma(i,j,bi,bj) = 0.D0
              ersob(i,j,bi,bj) = 0.D0
              gfoma(i,j,bi,bj) = 0.D0
              gfoob(i,j,bi,bj) = 0.D0
          enddo
         enddo
        enddo
       enddo

        if (using_tpj)
     &  call cost_sla_read( tpfi, tpsta, tpper,
     &                zeroRL, zeroRL,
     &                tpob, tpma,
     &                irec, myThid )
        if (using_ers)
     &  call cost_sla_read( ersfi, erssta, ersper,
     &                zeroRL, zeroRL,
     &                ersob, ersma,
     &                irec, myThid )
        if (using_gfo)
     &  call cost_sla_read( gfofi, gfosta, gfoper,
     &                zeroRL, zeroRL,
     &                gfoob, gfoma,
     &                irec, myThid )

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                psmean(i,j,bi,bj) = psmean(i,j,bi,bj) +
     &                etaday(i,j,bi,bj) / float(ndaysrec)
                if ( igen_tp .GT. 0 ) then
                  if ( tpma(i,j,bi,bj)*
     &             gencost_weight(i,j,bi,bj,igen_tp) .NE. 0. ) then
                   mean_slaobs_model(i,j,bi,bj)=
     &              mean_slaobs_model(i,j,bi,bj)+tpob(i,j,bi,bj)
                   mean_psMtpobs(i,j,bi,bj) =
     &                 mean_psMtpobs(i,j,bi,bj) +
     &                 etaday(i,j,bi,bj)-tpob(i,j,bi,bj)
                   mean_psMtpobs_NUM(i,j,bi,bj) =
     &                 mean_psMtpobs_NUM(i,j,bi,bj) + 1.D0
                  endif
                endif
                if ( igen_ers .GT. 0 ) then
                  if ( ersma(i,j,bi,bj)*
     &             gencost_weight(i,j,bi,bj,igen_ers) .NE. 0. ) then
                   mean_slaobs_model(i,j,bi,bj)=
     &              mean_slaobs_model(i,j,bi,bj)+ersob(i,j,bi,bj)
                   mean_psMersobs(i,j,bi,bj) =
     &                 mean_psMersobs(i,j,bi,bj) +
     &                 etaday(i,j,bi,bj)-ersob(i,j,bi,bj)
                   mean_psMersobs_NUM(i,j,bi,bj) =
     &                 mean_psMersobs_NUM(i,j,bi,bj) + 1.D0
                  endif
                endif
                if ( igen_gfo .GT. 0 ) then
                  if ( gfoma(i,j,bi,bj)*
     &             gencost_weight(i,j,bi,bj,igen_gfo) .NE. 0. ) then
                   mean_slaobs_model(i,j,bi,bj)=
     &              mean_slaobs_model(i,j,bi,bj)+gfoob(i,j,bi,bj)
                   mean_psMgfoobs(i,j,bi,bj) =
     &                 mean_psMgfoobs(i,j,bi,bj) +
     &                 etaday(i,j,bi,bj)-gfoob(i,j,bi,bj)
                   mean_psMgfoobs_NUM(i,j,bi,bj) =
     &                 mean_psMgfoobs_NUM(i,j,bi,bj) + 1.D0
                  endif
                endif
              enddo
            enddo
          enddo
        enddo

c--   END loop over records for the first time.
      enddo

      call ecco_zero(num0array,1,oneRL,myThid)

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
               if ( ( mean_psMtpobs_NUM(i,j,bi,bj) .NE. 0. )
     &              ) then
                  mean_psMssh_all(i,j,bi,bj) =
     &                 mean_psMssh_all(i,j,bi,bj) +
     &                 mean_psMtpobs(i,j,bi,bj)
                  mean_psMssh_all_NUM(i,j,bi,bj) =
     &                 mean_psMssh_all_NUM(i,j,bi,bj) +
     &                 mean_psMtpobs_NUM(i,j,bi,bj)
                  mean_psMtpobs(i,j,bi,bj) =
     &                 mean_psMtpobs(i,j,bi,bj) /
     &                 mean_psMtpobs_NUM(i,j,bi,bj)
               endif
               if ( ( mean_psMersobs_NUM(i,j,bi,bj) .NE. 0. )
     &              ) then
                  mean_psMssh_all(i,j,bi,bj) =
     &                 mean_psMssh_all(i,j,bi,bj) +
     &                 mean_psMersobs(i,j,bi,bj)
                  mean_psMssh_all_NUM(i,j,bi,bj) =
     &                 mean_psMssh_all_NUM(i,j,bi,bj) +
     &                 mean_psMersobs_NUM(i,j,bi,bj)
                  mean_psMersobs(i,j,bi,bj) =
     &                 mean_psMersobs(i,j,bi,bj) /
     &                 mean_psMersobs_NUM(i,j,bi,bj)
               endif
               if ( ( mean_psMgfoobs_NUM(i,j,bi,bj) .NE. 0. )
     &              ) then
                  mean_psMssh_all(i,j,bi,bj) =
     &                 mean_psMssh_all(i,j,bi,bj) +
     &                 mean_psMgfoobs(i,j,bi,bj)
                  mean_psMssh_all_NUM(i,j,bi,bj) =
     &                 mean_psMssh_all_NUM(i,j,bi,bj) +
     &                 mean_psMgfoobs_NUM(i,j,bi,bj)
                  mean_psMgfoobs(i,j,bi,bj) =
     &                 mean_psMgfoobs(i,j,bi,bj) /
     &                 mean_psMgfoobs_NUM(i,j,bi,bj)
               endif

               if ( ( mean_psMssh_all_NUM(i,j,bi,bj) .GT. 0 ).AND.
     &              ( maskc(i,j,1,bi,bj) .NE. 0. )
     &              ) then
                  mean_psMslaobs(i,j,bi,bj) =
     &                 mean_psMssh_all(i,j,bi,bj) /
     &                 mean_psMssh_all_NUM(i,j,bi,bj)
                  mean_psMslaobs_MSK(i,j,bi,bj) = 1.D0
               else
                  mean_psMslaobs(i,j,bi,bj) = 0.D0
                  mean_psMslaobs_MSK(i,j,bi,bj) = 0.D0
               endif

               if ( ( mean_psMssh_all_NUM(i,j,bi,bj) .GT. num0 ).AND.
     &              ( maskc(i,j,1,bi,bj) .NE. 0. ) .AND.
     &              ( mdtma(i,j,bi,bj) .NE. 0. ).AND.
     &              ( doReference ) ) then
                  mean_slaobs_model(i,j,bi,bj) =
     &                 mean_slaobs_model(i,j,bi,bj) /
     &                 mean_psMssh_all_NUM(i,j,bi,bj)
                  mean_psMssh_all(i,j,bi,bj) =
     &                 mean_psMssh_all(i,j,bi,bj) /
     &                 mean_psMssh_all_NUM(i,j,bi,bj)-mdtob(i,j,bi,bj)
                  mean_psMssh_all_MSK(i,j,bi,bj) = 1.D0
                  offset=offset+RA(i,j,bi,bj)*mean_psMssh_all(i,j,bi,bj)
                  offset_sum=offset_sum+RA(i,j,bi,bj)
               elseif ( ( mdtma(i,j,bi,bj) .NE. 0. ) .AND.
     &              ( maskc(i,j,1,bi,bj) .NE. 0. ).AND.
     &              ( .NOT.doReference ) ) then
                  mean_slaobs_model(i,j,bi,bj) = 0.d0
                  mean_psMssh_all(i,j,bi,bj) = 0.D0
                  mean_psMssh_all_MSK(i,j,bi,bj) = 1.D0
                  offset=offset+RA(i,j,bi,bj)
     &                  *( psmean(i,j,bi,bj) -mdtob(i,j,bi,bj) )
                  offset_sum=offset_sum+RA(i,j,bi,bj)
                  num0array(i,j,bi,bj)=0.D0
               else
                  mean_slaobs_model(i,j,bi,bj) = 0.d0
                  mean_psMssh_all(i,j,bi,bj) = 0.D0
                  mean_psMssh_all_MSK(i,j,bi,bj) = 0.D0
                  num0array(i,j,bi,bj)=0.D0
               endif
              enddo
            enddo
          enddo
        enddo

c--   Do a global summation.
      CALL GLOBAL_SUM_R8 (  offset     ,  myThid  )
      CALL GLOBAL_SUM_R8 (  offset_sum ,  myThid  )

catn--- add warning that written mean_slaobs_model is all zero
c       due to having less data points that hardcoded num0
        num0total=0.D0
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
                num0total=num0total+num0array(i,j,bi,bj)
              enddo
            enddo
          enddo
        enddo
      if(num0total.LT.1.D0) then
        write(msgbuf,'(A,i5,A)')
     &  '** WARNING ** S/R COST_GENCOST_SSHV4: There are <',num0,' pts'
      call print_message( msgbuf, errormessageunit,
     &                    SQUEEZE_RIGHT , myThid)
        write(msgbuf,'(A)')
     &  '                  at all grid points for combined tp+ers+gfo.'
      call print_message( msgbuf, errormessageunit,
     &                    SQUEEZE_RIGHT , myThid)
        write(msgbuf,'(A)')
     &  'So, all model slaob minus model sla2model_raw are set to 0.'
      call print_message( msgbuf, errormessageunit,
     &                    SQUEEZE_RIGHT , myThid)
      endif
catn-------

      if (igen_gmsl.GT.0) then
       if (offset_sum .EQ. 0.0) then
        if (gencost_outputlevel(igen_gmsl).GT.0) then
        IF (  myThid  .EQ. 1 ) THEN
        write(msgbuf,'(a)') ' sshv4: offset_sum = zero!'
        call print_message( msgbuf, standardmessageunit,
     &                          SQUEEZE_RIGHT , myThid)
        ENDIF
        endif
c       stop   '  ... stopped in cost_ssh.'
       else
        if (gencost_outputlevel(igen_gmsl).GT.0) then
        IF (  myThid  .EQ. 1 ) THEN
        write(msgbuf,'(a,2d22.15)') ' sshv4:offset,sum=',
     &      offset,offset_sum
        call print_message( msgbuf, standardmessageunit,
     &                          SQUEEZE_RIGHT , myThid)
        ENDIF
        endif
       endif
c     endif igen_gmsl .gt. 0
      endif

c--   Compute (average) offset
      if ( offset_sum.NE.0.D0 ) then
        offset = offset / offset_sum
      else
        offset = 0.D0
      endif

c--   subtract offset from mean_psMssh_all and psmean
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = jmin,jmax
            do i = imin,imax

               if ( (mean_psMssh_all_NUM(i,j,bi,bj) .GT. num0) .AND.
     &              ( mdtma(i,j,bi,bj) .NE. 0. ) .AND.
     &              ( maskc(i,j,1,bi,bj) .NE. 0. ) .AND.
     &              ( doReference ) ) then
c use the re-referencing approach
                   mean_psMssh_all(i,j,bi,bj) =
     &                 mean_psMssh_all(i,j,bi,bj) - offset
                   mean_psMssh_all_MSK(i,j,bi,bj) = 1.D0

               elseif ( ( mdtma(i,j,bi,bj) .NE. 0. ) .AND.
     &              ( maskc(i,j,1,bi,bj) .NE. 0. ) .AND.
     &              ( .NOT.doReference ) ) then
c use the simpler approach
                   mean_psMssh_all(i,j,bi,bj) =
     &             psmean(i,j,bi,bj) -mdtob(i,j,bi,bj) - offset
                   mean_psMssh_all_MSK(i,j,bi,bj) = 1.D0

               else
                   mean_psMssh_all(i,j,bi,bj) = 0.D0
                   mean_psMssh_all_MSK(i,j,bi,bj) = 0.D0
               endif

               if ( maskc(i,j,1,bi,bj) .NE. 0. )
     &            psmean(i,j,bi,bj)=psmean(i,j,bi,bj)-offset

            enddo
          enddo
        enddo
      enddo

c--    smooth mean_psMssh_all
      if (igen_mdt.GT.0) then
       if (gencost_outputlevel(igen_mdt).GT.0) then
        write(fname4test(1:80),'(1a)') 'mdtdiff_raw'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        mean_psMssh_all, 1, 1, myThid )
        write(fname4test(1:80),'(1a)') 'sla2model_raw'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        mean_slaobs_model, 1, 1, myThid )
       endif


cgf at this point:
cgf     1) mean_psMssh_all is the sample mean <etaday-slaobs-mdt-offset>,
cgf             to which a smoothing filter has been applied.
cgf     2) mean_psMtpobs is the (unsmoothed) sample mean <etaday-tpobs>.
cgf             And similarly for ers and gfo, each treated separately.

cgf =======================================================
cgf PART 3: compute MDT cost term
cgf =======================================================

       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
       if (mean_psMssh_all_MSK(i,j,bi,bj).NE.0.D0) then
         junk = mean_psMssh_all(i,j,bi,bj)
         junkweight = gencost_weight(i,j,bi,bj,igen_mdt)
     &              * mdtma(i,j,bi,bj)
       else
         junk = 0.D0
         junkweight = 0.D0
       endif
       objf_gencost(bi,bj,igen_mdt) = objf_gencost(bi,bj,igen_mdt)
     &      + junk*junk*junkweight
       if ( junkweight .NE. 0. ) num_gencost(bi,bj,igen_mdt) =
     &      num_gencost(bi,bj,igen_mdt) + 1.D0
       diagnosfld(i,j,bi,bj) = junk*junk*junkweight
          enddo
         enddo
        enddo
       enddo

       if (gencost_outputlevel(igen_mdt).GT.0) then
        write(fname4test(1:80),'(1a)') 'misfits_mdt'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        diagnosfld, 1, 1, myThid )
       endif
c     endif igen_mdt .gt. 0
      endif

cgf =======================================================
cgf PART 4: compute smooth SLA cost term
cgf =======================================================

      ndaysave=35
      ndaysaveRL=ndaysave

catn add a warning if have less nrecday than the hardcoded 35days
      tempinteger=ndaysrec-ndaysave+1
      if(tempinteger.LT.1) then
        write(msgbuf,'(A,i5)')
     &  '** WARNING ** S/R COST_GENCOST_SSHV4: There are < ',ndaysave
      call print_message( msgbuf, errormessageunit,
     &                    SQUEEZE_RIGHT , myThid)
        write(msgbuf,'(A)')
     &   '        days required to calculate running mean tp+ers+gfo.'
      call print_message( msgbuf, errormessageunit,
     &                    SQUEEZE_RIGHT , myThid)
        write(msgbuf,'(A)')
     &  'PART 4 in cost_gencost_sshv4 is skipped entirely, and there'
      call print_message( msgbuf, errormessageunit,
     &                    SQUEEZE_RIGHT , myThid)
        write(msgbuf,'(A)')
     &  'will be NO report of [tp,ers,gfo,lsc,gmsl] in costfunction.'
      call print_message( msgbuf, errormessageunit,
     &                    SQUEEZE_RIGHT , myThid)
      endif
catn -----------

      do irec = 1, ndaysrec-ndaysave+1

       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
              anom_psMslaobs(i,j,bi,bj)  = 0.D0
              anom_psMslaobs_MSK(i,j,bi,bj)  = 0.D0
              anom_psMslaobs_SUB(i,j,bi,bj)  = 0.D0
              anom_slaobs(i,j,bi,bj)  = 0.D0
              anom_slaobs_SUB(i,j,bi,bj)  = 0.D0
              anom_psMslaobs_NUM(i,j,bi,bj)  = 0.D0
          enddo
         enddo
        enddo
       enddo

c PART 4.1: compute running sample average over ndaysave
c ------------------------------------------------------

      do jrec=1,ndaysave

        krec=irec+jrec-1

        call active_read_xy( fname, etaday, krec, doglobalread,
     &                       ladinit, eccoiter, myThid,
     &                       gencost_dummy(igen_etaday) )

        if (.NOT.useEtaMean)
     &  CALL REMOVE_MEAN_RL( 1, etaday, maskInC, maskInC, rA, drF,
     &                       'etaday', zeroRL, 1, myThid )

       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
              tpma(i,j,bi,bj) = 0.D0
              tpob(i,j,bi,bj) = 0.D0
              ersma(i,j,bi,bj) = 0.D0
              ersob(i,j,bi,bj) = 0.D0
              gfoma(i,j,bi,bj) = 0.D0
              gfoob(i,j,bi,bj) = 0.D0
          enddo
         enddo
        enddo
       enddo

        if (using_tpj)
     &  call cost_sla_read( tpfi, tpsta, tpper,
     &                zeroRL, zeroRL,
     &                tpob, tpma,
     &                krec, myThid )
        if (using_ers)
     &  call cost_sla_read( ersfi, erssta, ersper,
     &                zeroRL, zeroRL,
     &                ersob, ersma,
     &                krec, myThid )
        if (using_gfo)
     &  call cost_sla_read( gfofi, gfosta, gfoper,
     &                zeroRL, zeroRL,
     &                gfoob, gfoma,
     &                krec, myThid )

       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
      if ( tpma(i,j,bi,bj)*mean_psMslaobs_MSK(i,j,bi,bj)
     &  .NE.0. ) then
           anom_psMslaobs(i,j,bi,bj)= anom_psMslaobs(i,j,bi,bj)+
     &        etaday(i,j,bi,bj)-tpob(i,j,bi,bj)
     &        -mean_psMslaobs(i,j,bi,bj)
           anom_slaobs(i,j,bi,bj)= anom_slaobs(i,j,bi,bj)+
     &        tpob(i,j,bi,bj)
           anom_psMslaobs_NUM(i,j,bi,bj)=
     &        anom_psMslaobs_NUM(i,j,bi,bj)+1.D0
           if ( (2*jrec.EQ.ndaysave).OR.(2*jrec-1.EQ.ndaysave) )
     &        anom_psMslaobs_MSK(i,j,bi,bj)  = 1.D0
      endif
      if ( ersma(i,j,bi,bj)*mean_psMslaobs_MSK(i,j,bi,bj)
     &  .NE.0. ) then
           anom_psMslaobs(i,j,bi,bj)= anom_psMslaobs(i,j,bi,bj)+
     &        etaday(i,j,bi,bj)-ersob(i,j,bi,bj)
     &        -mean_psMslaobs(i,j,bi,bj)
           anom_slaobs(i,j,bi,bj)= anom_slaobs(i,j,bi,bj)+
     &        ersob(i,j,bi,bj)
           anom_psMslaobs_NUM(i,j,bi,bj)=
     &        anom_psMslaobs_NUM(i,j,bi,bj)+1.D0
           if ( (2*jrec.EQ.ndaysave).OR.(2*jrec-1.EQ.ndaysave) )
     &        anom_psMslaobs_MSK(i,j,bi,bj)  = 1.D0
      endif
      if ( gfoma(i,j,bi,bj)*mean_psMslaobs_MSK(i,j,bi,bj)
     &  .NE.0. ) then
           anom_psMslaobs(i,j,bi,bj)= anom_psMslaobs(i,j,bi,bj)+
     &        etaday(i,j,bi,bj)-gfoob(i,j,bi,bj)
     &        -mean_psMslaobs(i,j,bi,bj)
           anom_slaobs(i,j,bi,bj)= anom_slaobs(i,j,bi,bj)+
     &        gfoob(i,j,bi,bj)
           anom_psMslaobs_NUM(i,j,bi,bj)=
     &        anom_psMslaobs_NUM(i,j,bi,bj)+1.D0
           if ( (2*jrec.EQ.ndaysave).OR.(2*jrec-1.EQ.ndaysave) )
     &        anom_psMslaobs_MSK(i,j,bi,bj)  = 1.D0
      endif
          enddo
         enddo
        enddo
       enddo

      enddo !do jrec=1,ndaysave

        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
               if ( ( anom_psMslaobs_NUM(i,j,bi,bj) .NE. 0. ).AND.
     &              ( maskc(i,j,1,bi,bj) .NE. 0. )
     &            ) then
                  anom_psMslaobs(i,j,bi,bj) =
     &                 anom_psMslaobs(i,j,bi,bj) /
     &                 anom_psMslaobs_NUM(i,j,bi,bj)
                  anom_slaobs(i,j,bi,bj) =
     &                 anom_slaobs(i,j,bi,bj) /
     &                 anom_psMslaobs_NUM(i,j,bi,bj)
               else
                  anom_psMslaobs(i,j,bi,bj) = 0.D0
                  anom_slaobs(i,j,bi,bj) = 0.D0
               endif
              enddo
            enddo
          enddo
        enddo

c PART 4.11: separate time variable offset
c ----------------------------------------

      slaoffset     = 0.D0
      slaoffset_sum = 0.D0
      slaoffset_weight = 0.D0

      if (igen_lsc.GT.0) then
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
               if ( ( anom_psMslaobs_NUM(i,j,bi,bj) .NE. 0. ).AND.
     &              ( maskc(i,j,1,bi,bj) .NE. 0. )
     &            ) then
                  slaoffset=slaoffset+RA(i,j,bi,bj)*
     &                      anom_psMslaobs(i,j,bi,bj)
                  slaoffset_sum=slaoffset_sum+RA(i,j,bi,bj)
c Of interest is the total weight for an average of N indep sample (not the area weighted average of weight)
c Since slaoffset is itself area weighted, however, the total weight is only approx the simple weight sum :
                  slaoffset_weight=slaoffset_weight+
     &                      gencost_weight(i,j,bi,bj,igen_lsc)
               endif
              enddo
            enddo
          enddo
        enddo

      CALL GLOBAL_SUM_R8 (  slaoffset     ,  myThid  )
      CALL GLOBAL_SUM_R8 (  slaoffset_weight ,  myThid  )
      CALL GLOBAL_SUM_R8 (  slaoffset_sum ,  myThid  )

       if (igen_gmsl.GT.0) then
        if (slaoffset_sum .EQ. 0.0) then
         if (gencost_outputlevel(igen_gmsl).GT.0) then
         IF (  myThid  .EQ. 1 ) THEN
         write(msgbuf,'(a)') ' sshv4: slaoffset_sum = zero!'
         call print_message( msgbuf, standardmessageunit,
     &                           SQUEEZE_RIGHT , myThid)
         ENDIF
         endif
c        stop   '  ... stopped in cost_ssh.'
        else
         if (gencost_outputlevel(igen_gmsl).GT.0) then
         IF (  myThid  .EQ. 1 ) THEN
         write(msgbuf,'(a,3d22.15)') ' sshv4:slaoffset,sum,weight=',
     &          slaoffset,slaoffset_sum,slaoffset_weight
         call print_message( msgbuf, standardmessageunit,
     &                           SQUEEZE_RIGHT , myThid)
         ENDIF
         endif
        endif
c      endif igen_gmsl .gt. 0
       endif

c--   Compute (average) slaoffset
       if (slaoffset_sum.NE.0.D0) then
        slaoffset = slaoffset / slaoffset_sum
       else
        slaoffset = 0.D0
       endif

c--   Subtract slaoffset from anom_psMslaobs
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do j = jmin,jmax
              do i = imin,imax
               if ( ( anom_psMslaobs_NUM(i,j,bi,bj) .NE. 0. ).AND.
     &              ( maskc(i,j,1,bi,bj) .NE. 0. )
     &            ) then
                  anom_psMslaobs(i,j,bi,bj) =
     &                 anom_psMslaobs(i,j,bi,bj) - slaoffset
                  anom_slaobs(i,j,bi,bj) =
     &                 anom_slaobs(i,j,bi,bj) - slaoffset
               else
                  anom_psMslaobs(i,j,bi,bj) = 0.D0
                  anom_slaobs(i,j,bi,bj) = 0.D0
               endif
              enddo
            enddo
          enddo
        enddo

c PART 4.2: smooth anom_psMslaobs in space
c ----------------------------------------

      if (gencost_outputlevel(igen_lsc).GT.0) then
        write(fname4test(1:80),'(1a)') 'sladiff_raw'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        anom_psMslaobs, irec, 1, myThid )
        write(fname4test(1:80),'(1a)') 'slaobs_raw'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        anom_slaobs, irec, 1, myThid )
      endif


c PART 4.3: compute cost function term
c ------------------------------------

       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
          if ( (gencost_weight(i,j,bi,bj,igen_lsc).GT.0.).AND.
     &         (anom_psMslaobs_MSK(i,j,bi,bj).GT.0.) ) then
            junk = anom_psMslaobs(i,j,bi,bj)
            anom_slaobs_SUB(i,j,bi,bj) = anom_slaobs(i,j,bi,bj)
            anom_psMslaobs_SUB(i,j,bi,bj) = anom_psMslaobs(i,j,bi,bj)
          else
            junk = 0.D0
            anom_slaobs_SUB(i,j,bi,bj)= 0.D0
            anom_psMslaobs_SUB(i,j,bi,bj)= 0.D0
          endif
          objf_gencost(bi,bj,igen_lsc) = objf_gencost(bi,bj,igen_lsc)
     &        + junk*junk*gencost_weight(i,j,bi,bj,igen_lsc)
          if ( (gencost_weight(i,j,bi,bj,igen_lsc).GT.0.).AND.
     &         (anom_psMslaobs_MSK(i,j,bi,bj).GT.0.) )
     &         num_gencost(bi,bj,igen_lsc) =
     &         num_gencost(bi,bj,igen_lsc) + 1.D0
           enddo
         enddo
        enddo
       enddo

       if (gencost_outputlevel(igen_lsc).GT.0) then
        write(fname4test(1:80),'(1a)') 'sladiff_subsample'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        anom_psMslaobs_SUB, irec, 1, myThid )
        write(fname4test(1:80),'(1a)') 'slaobs_subsample'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        anom_slaobs_SUB, irec, 1, myThid )
       endif

c     endif igen_lsc .gt. 0
      endif

c PART 4.4: compute cost function term for global mean sea level
c --------------------------------------------------------------

      IF ( MASTER_CPU_THREAD(myThid) .AND. ( igen_gmsl.GT.0 )
     &     .AND. ( slaoffset_sum.GT.0.25D0 * globalArea ) ) THEN
          junk=slaoffset
          junkweight=1.D0
          objf_gencost(1,1,igen_gmsl) = objf_gencost(1,1,igen_gmsl)
     &        + junk*junk*junkweight
          num_gencost(1,1,igen_gmsl) = num_gencost(1,1,igen_gmsl)
     &        + 1.D0
c      print*,'igen_gmsl',igen_gmsl,
      ENDIF

cgf =======================================================
cgf PART 5: compute raw SLA cost term
cgf =======================================================

c time associated with this ndaysrec mean
        krec = irec + (ndaysave/2)

        call active_read_xy( fname, etaday, krec, doglobalread,
     &                       ladinit, eccoiter, myThid,
     &                       gencost_dummy(igen_etaday) )

        if (.NOT.useEtaMean)
     &  CALL REMOVE_MEAN_RL( 1, etaday, maskInC, maskInC, rA, drF,
     &                       'etaday', zeroRL, 1, myThid )

       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
              tpma(i,j,bi,bj) = 0.D0
              tpob(i,j,bi,bj) = 0.D0
              ersma(i,j,bi,bj) = 0.D0
              ersob(i,j,bi,bj) = 0.D0
              gfoma(i,j,bi,bj) = 0.D0
              gfoob(i,j,bi,bj) = 0.D0
          enddo
         enddo
        enddo
       enddo

        if (using_tpj)
     &  call cost_sla_read( tpfi, tpsta, tpper,
     &                zeroRL, zeroRL,
     &                tpob, tpma,
     &                krec, myThid )
        if (using_ers)
     &  call cost_sla_read( ersfi, erssta, ersper,
     &                zeroRL, zeroRL,
     &                ersob, ersma,
     &                krec, myThid )
        if (using_gfo)
     &  call cost_sla_read( gfofi, gfosta, gfoper,
     &                zeroRL, zeroRL,
     &                gfoob, gfoma,
     &                krec, myThid )

       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
              anom_psMtpobs(i,j,bi,bj)  = 0.D0
              anom_psMersobs(i,j,bi,bj) = 0.D0
              anom_psMgfoobs(i,j,bi,bj) = 0.D0
              anom_tpobs(i,j,bi,bj)  = 0.D0
              anom_ersobs(i,j,bi,bj) = 0.D0
              anom_gfoobs(i,j,bi,bj) = 0.D0
          enddo
         enddo
        enddo
       enddo

       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
      if ( tpma(i,j,bi,bj)*mean_psMslaobs_MSK(i,j,bi,bj).NE.0. )
     & then
         anom_psMtpobs(i,j,bi,bj)=
     &       etaday(i,j,bi,bj) - tpob(i,j,bi,bj)
     &       - mean_psMslaobs(i,j,bi,bj) - slaoffset
     &       - anom_psMslaobs(i,j,bi,bj)
         anom_tpobs(i,j,bi,bj)=tpob(i,j,bi,bj) - slaoffset
     &       - anom_slaobs(i,j,bi,bj)
      endif
      if ( ersma(i,j,bi,bj)*mean_psMslaobs_MSK(i,j,bi,bj).NE.0. )
     & then
         anom_psMersobs(i,j,bi,bj)=
     &       etaday(i,j,bi,bj) - ersob(i,j,bi,bj)
     &       - mean_psMslaobs(i,j,bi,bj) - slaoffset
     &       - anom_psMslaobs(i,j,bi,bj)
         anom_ersobs(i,j,bi,bj)=ersob(i,j,bi,bj) - slaoffset
     &       - anom_slaobs(i,j,bi,bj)
      endif
      if ( gfoma(i,j,bi,bj)*mean_psMslaobs_MSK(i,j,bi,bj).NE.0. )
     & then
         anom_psMgfoobs(i,j,bi,bj)=
     &       etaday(i,j,bi,bj) - gfoob(i,j,bi,bj)
     &       - mean_psMslaobs(i,j,bi,bj) - slaoffset
     &       - anom_psMslaobs(i,j,bi,bj)
         anom_gfoobs(i,j,bi,bj)=gfoob(i,j,bi,bj) - slaoffset
     &       - anom_slaobs(i,j,bi,bj)
      endif
          enddo
         enddo
        enddo
       enddo

      if ( igen_tp .GT. 0 ) then
       if (gencost_outputlevel(igen_tp).GT.0) then
        write(fname4test(1:80),'(1a)') 'sladiff_tp_raw'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        anom_psMtpobs, irec, 1, myThid )
        write(fname4test(1:80),'(1a)') 'slaobs_tp_raw'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        anom_tpobs, irec, 1, myThid )
       endif
      endif

      if ( igen_ers .GT. 0 ) then
       if (gencost_outputlevel(igen_ers).GT.0) then
        write(fname4test(1:80),'(1a)') 'sladiff_ers_raw'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        anom_psMersobs, irec, 1, myThid )
        write(fname4test(1:80),'(1a)') 'slaobs_ers_raw'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        anom_ersobs, irec, 1, myThid )
       endif
      endif

      if ( igen_gfo .GT. 0 ) then
       if (gencost_outputlevel(igen_gfo).GT.0) then
        write(fname4test(1:80),'(1a)') 'sladiff_gfo_raw'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        anom_psMgfoobs, irec, 1, myThid )
        write(fname4test(1:80),'(1a)') 'slaobs_gfo_raw'
        CALL WRITE_REC_3D_RL( fname4test, precFloat32, 1,
     &                        anom_gfoobs, irec, 1, myThid )
       endif
      endif
      if ( igen_tp .GT. 0 ) then
       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
c--             The array psobs contains SSH anomalies.
                junkweight = mean_psMslaobs_MSK(i,j,bi,bj)
     &                      *gencost_weight(i,j,bi,bj,igen_tp)
     &                      *tpma(i,j,bi,bj)
                junk = anom_psMtpobs(i,j,bi,bj)
                objf_gencost(bi,bj,igen_tp) =
     &              objf_gencost(bi,bj,igen_tp)+junk*junk*junkweight
                if ( junkweight .NE. 0. )
     &              num_gencost(bi,bj,igen_tp) =
     &              num_gencost(bi,bj,igen_tp) + 1.D0
          enddo
         enddo
        enddo
       enddo
      endif
      if ( igen_ers .GT. 0 ) then
       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
c--             The array ersobs contains SSH anomalies.
                junkweight = mean_psMslaobs_MSK(i,j,bi,bj)
     &                      *gencost_weight(i,j,bi,bj,igen_ers)
     &                      *ersma(i,j,bi,bj)
                junk = anom_psMersobs(i,j,bi,bj)
                objf_gencost(bi,bj,igen_ers) =
     &               objf_gencost(bi,bj,igen_ers)+junk*junk*junkweight
                if ( junkweight .NE. 0. )
     &              num_gencost(bi,bj,igen_ers) =
     &              num_gencost(bi,bj,igen_ers) + 1.D0
          enddo
         enddo
        enddo
       enddo
      endif
      if ( igen_gfo .GT. 0 ) then
       do bj = jtlo,jthi
        do bi = itlo,ithi
         do j = jmin,jmax
          do i = imin,imax
c--             The array gfoobs contains SSH anomalies.
                junkweight = mean_psMslaobs_MSK(i,j,bi,bj)
     &                      *gencost_weight(i,j,bi,bj,igen_gfo)
     &                      *gfoma(i,j,bi,bj)
                junk = anom_psMgfoobs(i,j,bi,bj)
                objf_gencost(bi,bj,igen_gfo) =
     &              objf_gencost(bi,bj,igen_gfo)+junk*junk*junkweight
                if ( junkweight .NE. 0. )
     &              num_gencost(bi,bj,igen_gfo) =
     &              num_gencost(bi,bj,igen_gfo) + 1.D0
          enddo
         enddo
        enddo
       enddo
      endif

      enddo !do irec = 1, ndaysrec-ndaysave+1


      RETURN
      END
