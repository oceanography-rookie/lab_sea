
















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
CBOP
C !ROUTINE: GAD_OPTIONS.h

C !INTERFACE:
C #include "GAD_OPTIONS.h"

C !DESCRIPTION:
C Contains CPP macros/flags for controlling optional features of package.
CEOP

C CPP options file for GAD (Generic Advection Diffusion) package
C Use this file for selecting options within the GAD package

C $Header: /u/gcmpack/MITgcm_contrib/SOSE/BoxAdj/code_ad/CPP_OPTIONS.h,v 1.1 2011/01/18 19:33:08 mmazloff Exp $
C $Name:  $



C     Package-specific Options & Macros go here

C This flag selects the form of COSINE(lat) scaling of bi-harmonic term.
C *only for use on a lat-lon grid*
C Setting this flag here only affects the bi-harmonic tracer terms; to
C use COSINEMETH_III in the momentum equations set it CPP_OPTIONS.h

C This selects isotropic scaling of harmonic and bi-harmonic term when
C using the COSINE(lat) scaling.
C Setting this flag here only affects the tracer diffusion terms; to
C use ISOTROPIC_COS_SCALING of the horizontal viscosity terms in the
C momentum equations set it CPP_OPTIONS.h; the following line
C even overrides setting the flag in CPP_OPTIONS.h

C As of checkpoint41, the inclusion of multi-dimensional advection
C introduces excessive recomputation/storage for the adjoint.
C We can disable it here using CPP because run-time flags are insufficient.

C Use compressible flow method for multi-dim advection instead of old, less
C accurate jmc method. Note: option has no effect on SOM advection which
C always use compressible flow method.

C This enable the use of 2nd-Order Moment advection scheme (Prather, 1986) for
C Temperature and Salinity ; due to large memory space (10 times more / tracer)
C requirement, by default, this part of the code is not compiled.

C Hack to get rid of negatives caused by Redi.  Works by restricting the
C outgoing flux (only contributions computed in gad_calc_rhs) for each cell
C to be no more than the amount of tracer in the cell (see Smolarkiewicz
C MWR 1989 and Bott MWR 1989).
C The flux contributions computed in gad_calc_rhs which are affected by
C this hack are:
C - explicit diffusion, Redi and the non-local part of KPP
C - advection is affected only if multiDimAdvection=.FALSE.
C - vertical diffusion (including the diagonal contribution from GMRedi)
C   only if implicitDiffusion=.FALSE.
C - GM is affected only if GMREDI_AdvForm=.FALSE.
C
C The parameter SmolarkiewiczMaxFrac (defined in gad_init_fixed.F)
C specifies the maximal fraction of tracer that can leave a cell.
C By default it is 1.  This will prevent the tracer from going negative
C due to contributions from gad_calc_rhs alone.  In the presence of other
C contributions (or roundoff errors), it may be necessary to reduce this
C value to achieve strict positivity.
C
C This hack applies to all tracers except temperature and salinity!
C Do not use with Adams-Bashforth (for ptracers)!
C Do not use with OBCS!

C $Header: /u/gcmpack/MITgcm/pkg/obcs/OBCS_OPTIONS.h,v 1.15 2012/09/20 19:04:46 dimitri Exp $
C $Name:  $

C CPP options file for OBCS package
C
C Use this file for selecting options within the OBCS package
C

C $Header: /u/gcmpack/MITgcm_contrib/SOSE/BoxAdj/code_ad/CPP_OPTIONS.h,v 1.1 2011/01/18 19:33:08 mmazloff Exp $
C $Name:  $



C Package-specific Options & Macros go here

C Enable individual open boundaries


C This include hooks to the Orlanski Open Boundary Radiation code
C#define ALLOW_ORLANSKI

C Enable OB values to be prescribed via external fields that are read
C from a file

C Enable OB conditions following Stevens (1990)

C This includes hooks to sponge layer treatment of uvel, vvel

C Include hooks to sponge layer treatment of pkg/seaice variables

C balance barotropic velocity

C Use older implementation of obcs in seaice-dynamics
C note: most of the "experimental" options listed below have not yet
C       been implementated in new version.


C     Smooth the tracer sea-ice variables near the edges.

C $Header: /u/gcmpack/MITgcm/pkg/exf/EXF_OPTIONS.h,v 1.14 2009/02/16 09:10:18 mlosch Exp $
C $Name: checkpoint61l $







C $Header: /u/gcmpack/MITgcm_contrib/SOSE/BoxAdj/code_ad/CPP_OPTIONS.h,v 1.1 2011/01/18 19:33:08 mmazloff Exp $
C $Name:  $




C CPP flags controlling which code is included in the files that
C will be compiled.
C

c   pkg/exf CPP options:
c   --------------------
c
c   >>> EXF_VERBOSE <<<
c       Do a bit more printout for the log file than usual.
c
c   >>> ALLOW_ATM_WIND <<<
c       If defined, 10-m wind fields can be read-in from files.
c                                        
c   >>> ALLOW_ATM_TEMP <<<
c       If defined, atmospheric temperature and specific
c       humidity fields can be read-in from files.
c                                        
c   >>> ALLOW_DOWNWARD_RADIATION <<<
c       If defined, downward long-wave and short-wave radiation
c       can be read-in form files or computed from lwflux and swflux.
c
c   >>> ALLOW_BULKFORMULAE <<<
c       Allows the use of bulk formulae in order to estimate
c       turbulent and radiative fluxes at the ocean's surface.
c
c   >>> EXF_READ_EVAP <<<
c       If defined, evaporation fields are read-in, rather than
c       computed from atmospheric state.
c                                        
c   >>> ALLOW_RUNOFF <<<
c       If defined, river and glacier runoff can be read-in from files.
c
c   >>>  <<<
c       If defined, atmospheric pressure can be read-in from files.
c   WARNING: this flag is set (define/undef) in CPP_OPTIONS.h 
c            and cannot be changed here (in EXF_OPTIONS)
c
c   >>> ICE_AREAMASK <<<
c       If defined, fractional ice-covered area MASK can be read-in from files.
c
c   >>> ALLOW_CLIMSST_RELAXATION <<<
c       Allow the relaxation to a monthly climatology of sea surface
c       temperature, e.g. the Reynolds climatology.
c
c   >>> ALLOW_CLIMSSS_RELAXATION <<<
c       Allow the relaxation to a monthly climatology of sea surface
c       salinity, e.g. the Levitus climatology.
c
c   >>> USE_EXF_INTERPOLATION <<<
c       Allows specification of arbitrary Cartesian input grids.
c
c   ====================================================================
c
c       The following CPP options:
c
c          ALLOW_ATM_WIND              (WIND)
c          ALLOW_ATM_TEMP              (TEMP)
c          ALLOW_DOWNWARD_RADIATION    (DOWN)
c          ALLOW_BULKFORMULAE          (BULK)
c          EXF_READ_EVAP               (EVAP)
c
c       permit the ocean-model forcing configurations listed in the
c       table below.  The first configuration is the default,
c       flux-forced, ocean model.  The next four are stand-alone
c       configurations that use pkg/exf, open-water bulk formulae to
c       compute the missing surface fluxes from atmospheric variables.
c       The last four configurations can be used in conjunction with
c       pkg/seaice to model ice-covered regions.  The forcing fields
c       in the rightmost column are defined in exf_fields.
c
c
c    WIND |TEMP |DOWN |BULK |EVAP |            actions
c    -----|-----|-----|-----|-----|-------------------------------------
c         |     |     |     |     |
c      -  |  -  |  -  |  -  |  -  | Read-in ustress, vstress, hflux,
c         |     |     |     |     | swflux, and sflux.
c         |     |     |     |     |
c     def | def | def | def |  -  | Read-in uwind, vwind, atemp, aqh,
c         |     |     |     |     | swdown, lwdown, precip, and runoff.
c         |     |     |     |     | Compute ustress, vstress, hflux,
c         |     |     |     |     | swflux, and sflux.
c         |     |     |     |     |
c     def | def |  -  | def |  -  | Read-in uwind, vwind, atemp, aqh,
c         |     |     |     |     | swflux, lwflux, precip, and runoff.
c         |     |     |     |     | Compute ustress, vstress, hflux,
c         |     |     |     |     | and sflux.
c         |     |     |     |     |
c     def |  -  |  -  | def |  -  | Read-in uwind, vwind, hflux,
c         |     |     |     |     | swflux, and sflux.
c         |     |     |     |     | Compute ustress and vstress.
c         |     |     |     |     |
c      -  | def |  -  | def |  -  | Read-in ustress, vstress, atemp,
c         |     |     |     |     | aqh, swflux, lwflux, precip, and
c         |     |     |     |     | runoff.  Compute hflux and sflux.
c         |     |     |     |     |
c     def | def |  -  |  -  | def | Read-in uwind, vwind, atemp, aqh,
c         |     |     |     |     | swflux, lwflux, precip, runoff,
c         |     |     |     |     | and evap.
c         |     |     |     |     |
c     def | def |  -  | def |  -  | Read-in uwind, vwind, atemp, aqh,
c         |     |     |     |     | swflux, lwflux, precip, and runoff.
c         |     |     |     |     | Compute open-water ustress, vstress,
c         |     |     |     |     | hflux, swflux, and evap.
c         |     |     |     |     |
c     def | def | def |  -  | def | Read-in uwind, vwind, atemp, aqh,
c         |     |     |     |     | swdown, lwdown, precip, runoff,
c         |     |     |     |     | and evap.
c         |     |     |     |     |
c     def | def | def | def |  -  | Read-in uwind, vwind, atemp, aqh,
c         |     |     |     |     | swdown, lwdown, precip, and runoff.
c         |     |     |     |     | Compute open-water ustress, vstress,
c         |     |     |     |     | hflux, swflux, and evap.
c
c   ====================================================================

C   Do more printout for the protocol file than usual.

C   Bulk formulae related flags.

C   Relaxation to monthly climatologies.
CC#define ALLOW_CLIMSSS_RELAXATION

C   Use spatial interpolation to interpolate
C   forcing files from input grid to model grid.
C   runoff is a special case for which one might want to bypass
C   interpolation from an input grid


C $Header: /u/gcmpack/MITgcm_contrib/SOSE/BoxAdj/code_ad/CPP_OPTIONS.h,v 1.1 2011/01/18 19:33:08 mmazloff Exp $
C $Name:  $



CBOP
C !ROUTINE: COST_OPTIONS.h
C !INTERFACE:
C #include "COST_OPTIONS.h"

C !DESCRIPTION:
C *==================================================================*
C | CPP options file for Cost-Function (cost) package:
C | Control which optional features to compile in this package code.
C *==================================================================*
CEOP

C   ==================================================================
C-- Package-specific Options & Macros go here


C       >>> Cost function contributions


C   List these options here:

C   ==================================================================
CBOP
C !ROUTINE: CTRL_OPTIONS.h
C !INTERFACE:
C #include "CTRL_OPTIONS.h"

C !DESCRIPTION:
C *==================================================================*
C | CPP options file for Control (ctrl) package:
C | Control which optional features to compile in this package code.
C *==================================================================*
CEOP

C $Header: /u/gcmpack/MITgcm_contrib/SOSE/BoxAdj/code_ad/CPP_OPTIONS.h,v 1.1 2011/01/18 19:33:08 mmazloff Exp $
C $Name:  $



C   ==================================================================
C-- Package-specific Options & Macros go here

C  o  Re-activate deprecated codes in pkg/ecco & pkg/ctrl (but not recommended)
C     and since pkg/ctrl can be used without pkg/ecco, better to have it here


C       >>> Initial values.
C#define ALLOW_THETA0_CONTROL
C#define ALLOW_SALT0_CONTROL
C#undef ALLOW_UVEL0_CONTROL
C#undef ALLOW_VVEL0_CONTROL
C#undef ALLOW_TR10_CONTROL

C       >>> Surface fluxes.

C       >>> Atmospheric state.


c       >>> Make sure that  is defined





C       >>> Radiation

C       >>> seaice init. conditions
CML#define  ALLOW_SIAREA_CONTROL
CML#define  ALLOW_SIHEFF_CONTROL

C       >>> Other Control.

C       >>> Backward compatibility option (before checkpoint 65p)

C       >>> Generic Control.
C#define ALLOW_GENARR2D_CONTROL
C#define ALLOW_GENARR3D_CONTROL

C  o Rotation of wind/stress controls adjustments
C    from Eastward/Northward to model grid directions

C  o Originally the first two time-reccords of control
C    variable tau u and tau v were skipped.
C    The CTRL_SKIP_FIRST_TWO_ATM_REC_ALL option extends this
C    to the other the time variable atmospheric controls.

C  o use pkg/smooth correlation operator (incl. smoother) for 2D controls (Weaver, Courtier 01)
C    This CPP option just sets the default for ctrlSmoothCorrel2D to .TRUE.
C  o use pkg/smooth correlation operator (incl. smoother) for 3D controls (Weaver, Courtier 01)
C    This CPP option just sets the default for ctrlSmoothCorrel3D to .TRUE.

C  o apply pkg/ctrl/ctrl_smooth.F to 2D controls (outside of ctrlSmoothCorrel2D)
C  o apply pkg/smooth/smooth_diff2d.F to 2D controls (outside of ctrlSmoothCorrel2D)
C  o apply pkg/smooth/smooth_diff3d.F to 3D controls (outside of ctrlSmoothCorrel3D)

C   ==================================================================
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


CBOP
C     !ROUTINE: FORWARD_STEP
C     !INTERFACE:
      SUBROUTINE FORWARD_STEP( iloop, myTime, myIter, myThid )

C     !DESCRIPTION: \bv
C     *=================================================================
C     | SUBROUTINE forward_step
C     | o Step forward in time the model variables for one time-step
C     *=================================================================
C     | The algorithm...
C     |
C     | "Calculation of Gs"
C     | ===================
C     | This is where all the accelerations and tendencies (ie.
C     | physics, parameterizations etc...) are calculated
C     |   rho = rho ( theta[n], salt[n] )
C     |   b   = b(rho, theta)
C     |   K31 = K31 ( rho )
C     |   Gu[n] = Gu( u[n], v[n], wVel, b, ... )
C     |   Gv[n] = Gv( u[n], v[n], wVel, b, ... )
C     |   Gt[n] = Gt( theta[n], u[n], v[n], wVel, K31, ... )
C     |   Gs[n] = Gs( salt[n], u[n], v[n], wVel, K31, ... )
C     |
C     | "Time-stepping" or "Prediction"
C     | ================================
C     | The models variables are stepped forward with the appropriate
C     | time-stepping scheme (currently we use Adams-Bashforth II)
C     | - For momentum, the result is always *only* a "prediction"
C     | in that the flow may be divergent and will be "corrected"
C     | later with a surface pressure gradient.
C     | - Normally for tracers the result is the new field at time
C     | level [n+1} *BUT* in the case of implicit diffusion the result
C     | is also *only* a prediction.
C     | - We denote "predictors" with an asterisk (*).
C     |   U* = U[n] + dt x ( 3/2 Gu[n] - 1/2 Gu[n-1] )
C     |   V* = V[n] + dt x ( 3/2 Gv[n] - 1/2 Gv[n-1] )
C     |   theta[n+1] = theta[n] + dt x ( 3/2 Gt[n] - 1/2 atG[n-1] )
C     |   salt[n+1]  = salt[n] + dt x ( 3/2 Gt[n] - 1/2 atG[n-1] )
C     | With implicit diffusion:
C     |   theta* = theta[n] + dt x ( 3/2 Gt[n] - 1/2 atG[n-1] )
C     |   salt*  = salt[n] + dt x ( 3/2 Gt[n] - 1/2 atG[n-1] )
C     |   (1 + dt * K * d_zz) theta[n+1] = theta*
C     |   (1 + dt * K * d_zz) salt[n+1]  = salt*
C     |
C     | "Correction Step"
C     | =================
C     | Here we update the horizontal velocities with the surface
C     | pressure such that the resulting flow is either consistent
C     | with the free-surface evolution or the rigid-lid:
C     |   U[n] = U* + dt x d/dx P
C     |   V[n] = V* + dt x d/dy P
C     |   W[n] = W* + dt x d/dz P  (NH mode)
C     *=================================================================
C     \ev

C     !CALLING SEQUENCE:
C     FORWARD_STEP
C       |
C       |-- AUTODIFF_INADMODE_UNSET
C       |
C       |-- SHELFICE_REMESHING
C       |
C       |-- RESET_NLFS_VARS
C       |-- UPDATE_R_STAR
C       |-- UPDATE_SURF_DR
C       |
C       |-- PTRACERS_SWITCH_ONOFF
C       |
C       |-- DIAGNOSTICS_SWITCH_ONOFF
C       |-- DO_STATEVARS_DIAGS
C       |
C       |-- NEST_CHILD_SETMEMO
C       |-- NEST_PARENT_IO_1
C       |
C       |-- LOAD_FIELDS_DRIVER
C       |
C       |-- BULKF_FORCING
C       |
C       |-- CHEAPAML
C       |
C       |-- CTRL_MAP_FORCING
C       |-- DUMMY_IN_STEPPING
C       |
C       |-- CPL_EXPORT_IMPORT_DATA
C       |
C       |-- OASIS_PUT
C       |-- OASIS_GET
C       |
C       |-- EBM_DRIVER
C       |
C       |-- DO_ATMOSPHERIC_PHYS
C       |
C       |-- DO_OCEANIC_PHYS
C       |
C       |-- STREAMICE_TIMESTEP
C       |
C       |-- GCHEM_CALC_TENDENCY
C       |
C       |-- LONGSTEP_AVERAGE
C       |-- LONGSTEP_THERMODYNAMICS
C       |
C       |-- THERMODYNAMICS
C       |
C       |-- LONGSTEP_AVERAGE
C       |-- LONGSTEP_THERMODYNAMICS
C       |
C       |-- DO_STAGGER_FIELDS_EXCHANGES
C       |
C       |-- DYNAMICS
C       |
C       |-- MNC_UPDATE_TIME
C       |
C       |-- OFFLINE_FIELDS_LOAD
C       |
C       |-- UPDATE_R_STAR
C       |-- UPDATE_SIGMA
C       |-- UPDATE_SURF_DR
C       |-- UPDATE_CG2D
C       |
C       |-- SHAP_FILT_APPLY_UV
C       |-- ZONAL_FILT_APPLY_UV
C       |
C       |-- SOLVE_FOR_PRESSURE
C       |
C       |-- MOMENTUM_CORRECTION_STEP
C       |
C       |-- INTEGR_CONTINUITY
C       |
C       |-- CALC_R_STAR
C       |-- CALC_SURF_DR
C       |
C       |-- DO_STAGGER_FIELDS_EXCHANGES
C       |
C       |-- DO_STATEVARS_DIAGS
C       |
C       |-- THERMODYNAMICS
C       |
C       |-- TRACERS_CORRECTION_STEP
C       |
C       |-- LONGSTEP_AVERAGE
C       |-- LONGSTEP_THERMODYNAMICS
C       |
C       |-- GCHEM_FORCING_SEP
C       |
C       |-- DO_FIELDS_BLOCKING_EXCHANGES
C       |
C       |-- DO_STATEVARS_DIAGS
C       |
C       |-- GRIDALT_UPDATE
C       |-- STEP_FIZHI_CORR
C       |
C       |-- FLT_MAIN
C       |
C       |-- DO_STATEVARS_TAVE
C       |
C       |-- NEST_PARENT_IO_2
C       |-- NEST_CHILD_TRANSP
C       |
C       |-- MONITOR
C       |
C       |-- COST_TILE
C       |
C       |-- DO_THE_MODEL_IO
C       |
C       |-- PTRACERS_RESET
C       |
C       |-- DO_WRITE_PICKUP
C       |
C       |-- AUTODIFF_INADMODE_SET
C       |
C       |-- SHOWFLOPS_INLOOP

C     !USES:
      IMPLICIT NONE
C     == Global variables ==
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
CBOP
C     !ROUTINE: DYNVARS.h
C     !INTERFACE:
C     include "DYNVARS.h"
C     !DESCRIPTION:
C     \bv
C     *==========================================================*
C     | DYNVARS.h
C     | o Dynamical model variables (common block DYNVARS_R)
C     *==========================================================*
C     | The value and two levels of time tendency are held for
C     | each prognostic variable.
C     *==========================================================*
C     \ev
CEOP

C     State Variables:
C     etaN  :: free-surface r-anomaly (r unit) at current time level
C     uVel  :: zonal velocity (m/s, i=1 held at western face)
C     vVel  :: meridional velocity (m/s, j=1 held at southern face)
C     theta :: potential temperature (oC, held at pressure/tracer point)
C     salt  :: salinity (g/kg, held at pressure/tracer point; note that
C              salinity is either a conductivity ratio or, if using TEOS10,
C              a mass ratio;here we assume it is a mass ratio even though
C              it is only correct for TEOS10)
C     gX, gxNm1 :: Time tendencies at current and previous time levels.
C     etaH  :: surface r-anomaly, advanced in time consistently
C              with 2.D flow divergence (Exact-Conservation):
C                etaH^n+1 = etaH^n - delta_t*Div.(H^n U^n+1)
C  note: a) used with "exactConserv", necessary for Non-Lin free-surf and mixed
C           forward/backward free-surf time stepping (e.g., Crank-Nickelson)
C        b) same as etaN but not necessarily at the same time, e.g.:
C           implicDiv2DFlow=1 => etaH=etaN ; =0 => etaH=etaN^(n-1);

      COMMON /DYNVARS_R/
     &                   etaN,
     &                   uVel,vVel,wVel,theta,salt,
     &                   gU,   gV,
     &                   guNm1,gvNm1,gtNm1,gsNm1
      Real*8  etaN  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  uVel (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  vVel (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  wVel (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  theta(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  salt (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  gU(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  gV(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  guNm1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  gvNm1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  gtNm1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  gsNm1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)


      COMMON /DYNVARS_R_2/
     &                   etaH
      Real*8  etaH  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)



C   The following blocks containing requires anomaly fields of control vars
C   and related to Options:
C   ALLOW_KAPGM_CONTROL , ALLOW_KAPREDI_CONTROL and ALLOW_BOTTOMDRAG_CONTROL
C   have been moved to header file "CTRL_FIELDS.h"


C     Diagnostic Variables:
C     rhoInSitu    :: In-Situ density anomaly [kg/m^3] at cell center level.
C     totPhiHyd    :: total hydrostatic Potential (anomaly, for now),
C                     at cell center level ; includes surface contribution.
C                     (for diagnostic + used in Z-coord with EOS_funct_P)
C     phiHydLow    :: Phi-Hydrostatic at r-lower boundary
C                     (bottom in z-coordinates, top in p-coordinates)
C     hMixLayer    :: Mixed layer depth [m]
C                     (for diagnostic + used GMRedi "fm07")
C     IVDConvCount :: Impl.Vert.Diffusion convection counter:
C                     = 0 (not convecting) or 1 (convecting)
      COMMON /DYNVARS_DIAG/
     &                rhoInSitu,
     &                totPhiHyd, phiHydLow,
     &                hMixLayer, IVDConvCount
      Real*8  rhoInSitu(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  totPhiHyd(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  phiHydLow(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  hMixLayer(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  IVDConvCount(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)





      integer i_got_signal
      common / sig_i / i_got_signal

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***




CBOP
C     !ROUTINE: FFIELDS.h
C     !INTERFACE:
C     include "FFIELDS.h"
C     !DESCRIPTION:
C     \bv
C     *==========================================================*
C     | FFIELDS.h
C     | o Model forcing fields
C     *==========================================================*
C     | More flexible surface forcing configurations are
C     | available via, e.g., pkg/exf
C     *==========================================================*
C     \ev
CEOP
C
C     fu    :: Zonal surface wind stress in N/m^2
C              > 0 for increase in uVel, which is west to
C                  east for cartesian and spherical polar grids
C              Typical range: -0.5 < fu < 0.5
C              Southwest C-grid U point
C
C     fv    :: Meridional surface wind stress in N/m^2
C              > 0 for increase in vVel, which is south to
C                  north for cartesian and spherical polar grids
C              Typical range: -0.5 < fv < 0.5
C              Southwest C-grid V point
C
C     EmPmR :: Net upward freshwater flux in kg/m2/s
C              EmPmR = Evaporation - precipitation - runoff
C              > 0 for increase in salt (ocean salinity)
C              Typical range: -1e-4 < EmPmR < 1e-4
C              Southwest C-grid tracer point
C           NOTE: for backward compatibility EmPmRfile is specified in
C                 m/s when using external_fields_load.F.  It is converted
C                 to kg/m2/s by multiplying by rhoConstFresh.
C
C  saltFlux :: Net upward salt flux in g/kg.kg/m^2/s = g/m^2/s
C              flux of Salt taken out of the ocean per time unit (second).
C              Note: only used when salty sea-ice forms or melts.
C              > 0 for decrease in SSS.
C              Southwest C-grid tracer point
C
C     Qnet  :: Net upward surface heat flux (including shortwave) in W/m^2
C              Qnet = latent + sensible + net longwave + net shortwave
C              > 0 for decrease in theta (ocean cooling)
C              Typical range: -250 < Qnet < 600
C              Southwest C-grid tracer point
C
C     Qsw   :: Net upward shortwave radiation in W/m^2
C              Qsw = - ( downward - ice and snow absorption - reflected )
C              > 0 for decrease in theta (ocean cooling)
C              Typical range: -350 < Qsw < 0
C              Southwest C-grid tracer point
C
C     SST   :: Sea surface temperature in degrees C for relaxation
C              Southwest C-grid tracer point
C
C     SSS   :: Sea surface salinity in g/kg for relaxation
C              Southwest C-grid tracer point
C
C     lambdaThetaClimRelax :: Inverse time scale for SST relaxation ( 1/s ).
C
C     lambdaSaltClimRelax  :: Inverse time scale for SSS relaxation ( 1/s ).

C     phiTide2d :: vertically uniform (2d-map), time-dependent geopotential
C                  anomaly (e.g., tidal forcing); Units are m^2/s^2
C     pLoad :: for the ocean:      atmospheric pressure anomaly (relative to
C                                   "surf_pRef") at z=eta
C                Units are           Pa=N/m^2
C              for the atmosphere (hack): geopotential anomaly of the orography
C                Units are           m^2/s^2
C     sIceLoad :: sea-ice loading, expressed in Mass of ice+snow / area unit
C                Units are           kg/m^2
C              Note: only used with Sea-Ice & RealFreshWater formulation
C     addMass  :: source (<0: sink) of fluid in the domain interior
C                 (generalisation of oceanic real fresh-water flux)
C                Units are           kg/s  (mass per unit of time)
C     frictionHeating :: heating caused by friction and momentum dissipation
C                Units are           in W/m^2 (thickness integrated)
C     eddyPsiX -Zonal Eddy Streamfunction in m^2/s used in taueddy_external_forcing.F
C     eddyPsiY -Meridional Streamfunction in m^2/s used in taueddy_external_forcing.F
C     EfluxY - y-component of Eliassen-Palm flux vector
C     EfluxP - p-component of Eliassen-Palm flux vector

      COMMON /FFIELDS_fu/ fu
      COMMON /FFIELDS_fv/ fv
      COMMON /FFIELDS_Qnet/ Qnet
      COMMON /FFIELDS_Qsw/ Qsw
      COMMON /FFIELDS_EmPmR/ EmPmR
      COMMON /FFIELDS_saltFlux/ saltFlux
      COMMON /FFIELDS_SST/ SST
      COMMON /FFIELDS_SSS/ SSS
      COMMON /FFIELDS_lambdaThetaClimRelax/ lambdaThetaClimRelax
      COMMON /FFIELDS_lambdaSaltClimRelax/ lambdaSaltClimRelax
      COMMON /FFIELDS_phiTide/ phiTide2d
      COMMON /FFIELDS_pLoad/ pLoad
      COMMON /FFIELDS_sIceLoad/ sIceLoad

      Real*8  fu       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  fv       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Qnet     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Qsw      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  EmPmR    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  saltFlux (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  SST      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  SSS      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  lambdaThetaClimRelax(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  lambdaSaltClimRelax(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  phiTide2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  pLoad    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  sIceLoad (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C  weight2BalanceFlx :: weight used for applying weighted correction
C                       to global-mean surf. flux imbalance ; no-units
      COMMON /FFIELDS_W2BALANCE/ weight2BalanceFlx
      Real*8 weight2BalanceFlx(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C- jmc: commented out until corresponding (ghost-like) code apparition
C     dQdT  :: Thermal relaxation coefficient in W/m^2/degrees
C              Southwest C-grid tracer point
c     COMMON /FFIELDS_dQdT/ dQdT
c     Real*8  dQdT   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
c#ifdef ALLOW_EP_FLUX
c     COMMON /FFIELDS_eflux/ EfluxY,EfluxP
c     Real*8  EfluxY (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
c     Real*8  EfluxP (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
c#endif


C     loadedRec     :: time-record currently loaded (in temp arrays *[1])
C     taux[0,1]     :: Temp. for zonal wind stress
C     tauy[0,1]     :: Temp. for merid. wind stress
C     Qnet[0,1]     :: Temp. for heat flux
C     EmPmR[0,1]    :: Temp. for fresh water flux
C     saltFlux[0,1] :: Temp. for isurface salt flux
C     SST[0,1]      :: Temp. for theta climatalogy
C     SSS[0,1]      :: Temp. for theta climatalogy
C     Qsw[0,1]      :: Temp. for short wave component of heat flux
C     pLoad[0,1]    :: Temp. for atmospheric pressure at z=eta
C     [0,1]         :: End points for interpolation

      COMMON /FFIELDS_I/ loadedRec
      INTEGER loadedRec(nSx,nSy)

      COMMON /TDFIELDS/
     &                 taux0, tauy0, Qnet0, EmPmR0, SST0, SSS0,
     &                 taux1, tauy1, Qnet1, EmPmR1, SST1, SSS1,
     &                 saltFlux0, saltFlux1
     &               , Qsw0, Qsw1
     &               , pLoad0, pLoad1

      Real*8  taux0    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  tauy0    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Qnet0    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  EmPmR0   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  saltFlux0(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  SST0     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  SSS0     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  taux1    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  tauy1    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Qnet1    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  EmPmR1   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  saltFlux1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  SST1     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  SSS1     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Qsw0     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Qsw1     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  pLoad0   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  pLoad1   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C     surfaceForcingU     units are  r_unit.m/s^2 (=m^2/s^2 if r=z)
C                -> usage in gU:     gU = gU + surfaceForcingU/drF [m/s^2]
C     surfaceForcingV     units are  r_unit.m/s^2 (=m^2/s^-2 if r=z)
C                -> usage in gU:     gV = gV + surfaceForcingV/drF [m/s^2]
C
C     surfaceForcingS     units are  r_unit.g/kg/s (=g/kg.m/s if r=z)
C            - EmPmR * S_surf plus salinity relaxation*drF(1)
C                -> usage in gS:     gS = gS + surfaceForcingS/drF [g/kg/s]
C
C     surfaceForcingT     units are  r_unit.Kelvin/s (=Kelvin.m/s if r=z)
C            - Qnet (+Qsw) plus temp. relaxation*drF(1)
C                -> calculate        -lambda*(T(model)-T(clim))
C            Qnet assumed to be net heat flux including ShortWave rad.
C                -> usage in gT:     gT = gT + surfaceforcingT/drF [K/s]
C     adjustColdSST_diag :: diagnostic field for how much too cold (below
C              Tfreezing) SST has been adjusted (with allowFreezing=T).
C              > 0 for increase of SST (up to Tfreezing).
C              Units are r_unit.K/s (=Kelvin.m/s if r=z).
C        Note: 1) allowFreezing option is a crude hack to fix too cold SST that
C              results from missing seaice component. It should never be used
C              with any seaice component, neither current seaice pkg (pkg/seaice
C              or pkg/thsice) nor a seaice component from atmos model when
C              coupled to it.
C              2) this diagnostic is currently used by KPP package (kpp_calc.F
C              and kpp_transport_t.F) although it is not very clear it should.

      COMMON /SURFACE_FORCING/
     &                         surfaceForcingU,
     &                         surfaceForcingV,
     &                         surfaceForcingT,
     &                         surfaceForcingS,
     &                         adjustColdSST_diag
      Real*8  surfaceForcingU   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  surfaceForcingV   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  surfaceForcingT   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  surfaceForcingS   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  adjustColdSST_diag(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C     botDragU :: bottom stress (for diagnostics), Zonal component
C                Units are N/m^2 ;   > 0 increase uVel @ bottom
C     botDragV :: bottom stress (for diagnostics), Merid. component
C                Units are N/m^2 ;   > 0 increase vVel @ bottom
      COMMON /FFIELDS_bottomStress/ botDragU, botDragV
      Real*8  botDragU (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  botDragV (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
C
CBOP
C    !ROUTINE: SURFACE.h
C    !INTERFACE:
C    include SURFACE.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | SURFACE.h
C     | o Header file defining surface-related model variables
C     *==========================================================*
C     | Contains variables relative to the surface position
C     | that are held fixed in linear free-surface formulation
C     | but can vary with time with a non-linear free-surface.
C     *==========================================================*
C     \ev
CEOP

C--   COMMON /SURF_FIXED/  fixed surface arrays (Real)
C     Bo_surf  :: Buoyancy|1/rho [ocean|atmos] at surface level [=g|alpha(p_o)]
C     recip_Bo :: 1/Bo_surf
C     topoZ    :: topographic height [m] (used mainly for atmosphere)
C     phi0surf :: starting point for integrating phi_Hyd
      COMMON /SURF_FIXED/ Bo_surf, recip_Bo, topoZ, phi0surf
      Real*8  Bo_surf (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  recip_Bo(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  topoZ   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  phi0surf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C--   COMMON /SURF_CORREC/ Common block for correction of source/sink of
C--                        Tracer due to W at the surface with Linear
C--                        Free Surface
C     TsurfCor :: Pot.Temp Linear-Free-Surface correction term [K.r_Unit/s]
C     SsurfCor :: Salinity Linear-Free-Surface correction term [g/kg.r_Unit/s]
      COMMON /SURF_CORREC/ TsurfCor, SsurfCor
      Real*8 TsurfCor
      Real*8 SsurfCor

C     etaHnm1 :: surface r-anomaly, etaH, at previous time level
C     dEtaHdt :: time derivative of total column height [r_unit/s = w unit]
C     PmEpR   :: keep the fresh water input (=-EmPmR) of the previous time step
      COMMON /EXACT_ETA_LOCAL/ etaHnm1, dEtaHdt, PmEpR
      Real*8 etaHnm1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dEtaHdt(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  PmEpR (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)



c     ==================================================================
c     HEADER TAMC
c     ==================================================================
c
c     o Header for the use of the Tangent Linear and Adjoint Model
c       Compiler (TAMC).
c
c     started: Christian Eckert eckert@mit.edu  04-Feb-1999
c
c     changed: Patrick Heimbach heimbach@mit.edu 06-Jun-2000
c              - New parameter nlevchk_0 for dimensionalising
c                common blocks in the undef  case
c              - nhreads_chkpt was declared at the wrong place
c
c
c     ==================================================================
c     HEADER TAMC
c     ==================================================================


c     TAMC checkpointing parameters:
c     ==============================
c
c     The checkpointing parameters have to be consistent with other model
c     parameters and variables. This has to be checked before the model is
c     run.
c
c     nyears_chkpt   - Number of calendar years affected by the assimilation
c                      experiment; nyears_chkpt has to be at least equal to
c                      the result of cal_IntYears(mythid).
c     nmonths_chkpt  - Number of months per year; nmonth_chkpt has to be at
c                      least equal to nmonthyear.
c     ndays_chkpt    - Number of days per month; nday_chkpt has to be at least
c                      equal to nmaxdaymonth.
c     nsteps_chkpt   - Number of steps per day; nsteps_chkpt has to be at
c                      least equal to cal_nStepDay(mythid)
c     ncheck_chkpt   - Number of innermost checkpoints.
c
c     ngeom_chkpt    - Geometry factor.
c     nthreads_chkpt - Number of threads to be used; nth_chkpt .eq. nTx*nTy

      integer nyears_chkpt
      integer nmonths_chkpt
      integer ndays_chkpt
      integer ngeom_chkpt
      integer ncheck_chkpt
      integer nthreads_chkpt

      parameter (nyears_chkpt   =          1 )
      parameter (nmonths_chkpt  =         12 )
      parameter (ndays_chkpt    =         31 )
      parameter (ngeom_chkpt    = nr*nsx*nsy )
      parameter (ncheck_chkpt   =          6 )
      parameter ( nthreads_chkpt = 1 )


      integer    nchklev_1
      integer    nchklev_2
      integer    nchklev_3
      integer    nchklev_4
      parameter( nchklev_1      =  50 )
      parameter( nchklev_2      = 3)
      parameter( nchklev_3      =   3 )
      parameter( nchklev_4      =   1 )

c--   Note always check for the correct sizes of the common blocks!


c     TAMC keys:
c     ==========
c
c     The keys are used for storing and reading data of the reference
c     trajectory.
c
c     The convention used here is:
c                                    ikey_<name>
c
c     which means that this key is used in routine <name> for reading
c     and writing data.

      common /tamc_keys_i/
     &                     ikey_dynamics,
     &                     ikey_yearly,
     &                     ikey_daily_1,
     &                     ikey_daily_2,
     &                     iloop_daily

      integer ikey_dynamics
      integer ikey_yearly
      integer ikey_daily_1
      integer ikey_daily_2
      integer iloop_daily

      INTEGER    isbyte
      PARAMETER( isbyte      = 4 )
      INTEGER    maximpl
      PARAMETER( maximpl     = 6 )
      INTEGER    maxpass
      PARAMETER( maxpass     = 3 )
      INTEGER    maxcube
      PARAMETER( maxcube     = 3 )

      INTEGER act0, act1, act2, act3, act4
      INTEGER max0, max1, max2, max3
      INTEGER iikey, kkey, passkey, igadkey,
     &        itdkey, idynkey, igmkey, ikppkey

c     ==================================================================
c     END OF HEADER TAMC
c     ==================================================================

c     ==================================================================
c     CTRL_SIZE.h
c     ==================================================================


C     Generic control variable array dimension
C     ----------------------------------------
C
C     maxCtrlArr2D :: number of 2-d generic init. ctrl variables
C     maxCtrlArr3D :: number of 3-d generic init. ctrl variables
C     maxCtrlTim2D :: number of 2-d generic tim-varying ctrl variables
C     maxCtrlProc  :: number of pre-processing options per ctrl variable

      integer     maxCtrlArr2D
      parameter ( maxCtrlArr2D = 2 )

      integer     maxCtrlArr3D
      parameter ( maxCtrlArr3D = 2 )

      integer     maxCtrlTim2D
      parameter ( maxCtrlTim2D = 7 )

      integer     maxCtrlProc
      parameter ( maxCtrlProc = 1 )


CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
c     ==================================================================
c     HEADER CONTROLVARS
c     ==================================================================
c
c     o Control variables of the ECCO state estimation tool.
c
c     Depending on the specific problem to be studied users will have to
c     modify this header file.
c
c     started: Christian Eckert eckert@mit.edu  30-Jun-1999
c
c     ==================================================================
c     HEADER CONTROLVARS ctrl.h
c     ==================================================================

      integer     maxcvars
      parameter ( maxcvars = 400 )

cph ctrlprec will be set to 32 for ECCO to reduce I/O
cph but jeopardizes some gradient checks, so should be
cph set to 64 by default.
      integer     ctrlprec
      common /controlparams_i/ ctrlprec


      common /controlparams_r/
     &                       delZexp,
     &                       forcingPrecond

      Real*8 delZexp
      Real*8 forcingPrecond

      common /controlparams_c/
     &                       ctrlDir

      CHARACTER*(MAX_LEN_FNAM) ctrlDir

C     doInitXX            :: at iter 0 only, set ctrls to 0 and write
C                            to xx*000.data
C     doMainPack          :: pack adxx*data files into ecco_cost_* file
C                            (usually for optim.x)
C     doMainUnpack        :: unpack ecco_ctrl_* file (usually from optim.x)
C                            into xx_*data files
C     doPackDiag          :: output diag_pack*/diag_unpack* files during
C                            ctrl_pack/ctrl_unpack
C     doSinglePrecTapelev :: reduce precision of ad tape files to float32
C                            (only used in pkg/autodiff ...)

      common /controlvars_l /
     &                       doInitXX,
     &                       doAdmTlm,
     &                       doPackDiag,
     &                       doZscaleUnpack,
     &                       doZscalePack,
     &                       doMainUnpack,
     &                       doMainPack,
     &                       doSinglePrecTapelev,
     &                       doAdmtlmBypassAD

      logical doInitXX
      logical doAdmTlm
      logical doPackDiag
      logical doZscaleUnpack
      logical doZscalePack
      logical doMainUnpack
      logical doMainPack
      logical doSinglePrecTapelev
      logical doAdmtlmBypassAD

      common /controlvars_i/
     &                       nvartype,
     &                       nvarlength,
     &                       ncvarindex,
     &                       ncvarrecs,
     &                       ncvarrecstart,
     &                       ncvarrecsend,
     &                       ncvarxmax,
     &                       ncvarymax,
     &                       ncvarnrmax,
     &                       nwetctile,
     &                       nwetstile,
     &                       nwetwtile,
     &                       nwetvtile,
     &                       nwetcglobal,
     &                       nwetsglobal,
     &                       nwetwglobal,
     &                       nwetvglobal,
     &                       nbuffglobal
      integer nvartype
      integer nvarlength
      integer ncvarindex    ( maxcvars )
      integer ncvarrecs     ( maxcvars )
      integer ncvarrecstart ( maxcvars )
      integer ncvarrecsend  ( maxcvars )
      integer ncvarxmax     ( maxcvars )
      integer ncvarymax     ( maxcvars )
      integer ncvarnrmax    ( maxcvars )
      integer nwetctile     ( nSx,nSy,Nr )
      integer nwetstile     ( nSx,nSy,Nr )
      integer nwetwtile     ( nSx,nSy,Nr )
      integer nwetvtile     ( nSx,nSy,Nr )
      integer nwetcglobal     ( Nr )
      integer nwetsglobal     ( Nr )
      integer nwetwglobal     ( Nr )
      integer nwetvglobal     ( Nr )
      integer nbuffglobal


      common /controlvars_c/
     &                       ncvargrd
     &                     , yadprefix
      character*(1) ncvargrd(maxcvars)
      character*(2) yadprefix

      common /controlvec_header_i/
     &        filenvartype,
     &        filenvarlength,
     &        fileOptimCycle,
     &        filencbuffindex,
     &        fileIg,
     &        fileJg,
     &        fileI,
     &        fileJ,
     &        filensx,
     &        filensy,
     &        filek,
     &        filenWetcGlobal,
     &        filenWetsGlobal,
     &        filenWetwGlobal,
     &        filenWetvGlobal,
     &        filencvarindex,
     &        filencvarrecs,
     &        filencvarxmax,
     &        filencvarymax,
     &        filencvarnrmax
      integer        filenvartype
      integer        filenvarlength
      integer        fileOptimCycle
      integer        filencbuffindex
      integer        fileIg
      integer        fileJg
      integer        fileI
      integer        fileJ
      integer        filensx
      integer        filensy
      integer        filek
      integer        filenWetcGlobal(Nr)
      integer        filenWetsGlobal(Nr)
      integer        filenWetwGlobal(Nr)
      integer        filenWetvGlobal(Nr)
      integer        filencvarindex(maxcvars)
      integer        filencvarrecs(maxcvars)
      integer        filencvarxmax(maxcvars)
      integer        filencvarymax(maxcvars)
      integer        filencvarnrmax(maxcvars)

      common /controlvec_header_r/
     &               filefc
      Real*8            filefc

      common /controlvec_header_c/
     &        fileYctrlid,
     &        filencvargrd
      character*(10) fileYctrlid
      character*( 1) filencvargrd(maxcvars)

c     Define unit weight as a placeholder
      common /ctrl_weights_unit_r/
     &                        wunit
      Real*8 wunit     (Nr,nSx,nSy)

      common /packnames_c/
     &                      yadmark,
     &                      ctrlname,
     &                      costname,
     &                      scalname,
     &                      maskname,
     &                      metaname,
     &                      yctrlid,
     &                      yctrlposunpack,
     &                      yctrlpospack
      character*2 yadmark
      character*9 ctrlname
      character*9 costname
      character*9 scalname
      character*9 maskname
      character*9 metaname
      character*10 yctrlid
      character*4 yctrlposunpack
      character*4 yctrlpospack


c     Control variables:
c     ==================
c
c     ==================================================================
c     END OF HEADER CONTROLVARS ctrl.h
c     ==================================================================
c     ==================================================================
c     HEADER CONTROL DUMMIES
c     ==================================================================
c
c     o Control dummy variables of the ECCO state estimation tool.
c
c     ==================================================================
c     HEADER CONTROL DUMMIES
c     ==================================================================
      common /ctrl_dummy/
     &                    xx_theta_dummy
     &                  , xx_salt_dummy
     &                  , xx_hflux_dummy
     &                  , xx_sflux_dummy
     &                  , xx_tauu_dummy
     &                  , xx_tauv_dummy
     &                  , xx_atemp_dummy
     &                  , xx_aqh_dummy
     &                  , xx_precip_dummy
     &                  , xx_swflux_dummy
     &                  , xx_swdown_dummy
     &                  , xx_snowprecip_dummy
     &                  , xx_lwflux_dummy
     &                  , xx_lwdown_dummy
     &                  , xx_evap_dummy
     &                  , xx_apressure_dummy
     &                  , xx_runoff_dummy
     &                  , xx_uwind_dummy
     &                  , xx_vwind_dummy
     &                  , xx_diffkr_dummy
     &                  , xx_kapgm_dummy
     &                  , xx_kapredi_dummy
     &                  , xx_tr1_dummy
     &                  , xx_sst_dummy
     &                  , xx_sss_dummy
     &                  , xx_depth_dummy
     &                  , xx_efluxy_dummy
     &                  , xx_efluxp_dummy
     &                  , xx_bottomdrag_dummy
     &                  , xx_edtaux_dummy
     &                  , xx_edtauy_dummy
     &                  , xx_uvel_dummy
     &                  , xx_vvel_dummy
     &                  , xx_etan_dummy
     &                  , xx_siarea_dummy
     &                  , xx_siheff_dummy
     &                  , xx_sihsnow_dummy
     &                  , xx_relaxsst_dummy
     &                  , xx_relaxsss_dummy
     &                  , xx_tbar_mean_dummy
     &                  , xx_tbar_daily_mean_dummy
     &                  , xx_sbar_mean_dummy
     &                  , xx_sbar_daily_mean_dummy
     &                  , xx_ubar_mean_dummy
     &                  , xx_vbar_mean_dummy
     &                  , xx_wbar_mean_dummy
     &                  , xx_psbar_mean_dummy
     &                  , xx_bpbar_mean_dummy
     &                  , xx_taux_mean_dummy
     &                  , xx_tauy_mean_dummy
     &                  , xx_hflux_mean_dummy
     &                  , xx_sflux_mean_dummy
     &                  , xx_sstbar_mean_dummy
     &                  , xx_sssbar_mean_dummy
     &                  , xx_atmfwbar_mean_dummy
     &                  , xx_atemp_mean_dummy
     &                  , xx_aqh_mean_dummy
     &                  , xx_precip_mean_dummy
     &                  , xx_swflux_mean_dummy
     &                  , xx_swdown_mean_dummy
     &                  , xx_snowprecip_mean_dummy
     &                  , xx_lwflux_mean_dummy
     &                  , xx_lwdown_mean_dummy
     &                  , xx_evap_mean_dummy
     &                  , xx_apressure_mean_dummy
     &                  , xx_runoff_mean_dummy
     &                  , xx_uwind_mean_dummy
     &                  , xx_vwind_mean_dummy
     &                  , xx_theta_ini_fin_dummy
     &                  , xx_salt_ini_fin_dummy
     &                  , xx_smrareabar_mean_dummy
     &                  , xx_smrsstbar_mean_dummy
     &                  , xx_smrsssbar_mean_dummy
     &                  , xx_iestaubar_mean_dummy
     &                  , xx_gen2d_dummy
     &                  , xx_gen3d_dummy
cHFLUXM_CONTROL
     &                  , xx_hfluxm_dummy
cHFLUXM_CONTROL
     &                  , xx_shifwflx_dummy

      Real*8 xx_theta_dummy
      Real*8 xx_salt_dummy
      Real*8 xx_hflux_dummy
      Real*8 xx_sflux_dummy
      Real*8 xx_tauu_dummy
      Real*8 xx_tauv_dummy
      Real*8 xx_atemp_dummy
      Real*8 xx_aqh_dummy
      Real*8 xx_precip_dummy
      Real*8 xx_swflux_dummy
      Real*8 xx_swdown_dummy
      Real*8 xx_snowprecip_dummy
      Real*8 xx_lwflux_dummy
      Real*8 xx_lwdown_dummy
      Real*8 xx_evap_dummy
      Real*8 xx_apressure_dummy
      Real*8 xx_runoff_dummy
      Real*8 xx_uwind_dummy
      Real*8 xx_vwind_dummy
      Real*8 xx_diffkr_dummy
      Real*8 xx_kapgm_dummy
      Real*8 xx_kapredi_dummy
      Real*8 xx_tr1_dummy
      Real*8 xx_sst_dummy
      Real*8 xx_sss_dummy
      Real*8 xx_depth_dummy
      Real*8 xx_efluxy_dummy
      Real*8 xx_efluxp_dummy
      Real*8 xx_bottomdrag_dummy
      Real*8 xx_edtaux_dummy
      Real*8 xx_edtauy_dummy
      Real*8 xx_uvel_dummy
      Real*8 xx_vvel_dummy
      Real*8 xx_etan_dummy
      Real*8 xx_siarea_dummy
      Real*8 xx_siheff_dummy
      Real*8 xx_sihsnow_dummy
      Real*8 xx_relaxsst_dummy
      Real*8 xx_relaxsss_dummy
      Real*8 xx_gen2d_dummy
      Real*8 xx_gen3d_dummy
c
      Real*8 xx_tbar_mean_dummy
      Real*8 xx_tbar_daily_mean_dummy
      Real*8 xx_sbar_mean_dummy
      Real*8 xx_sbar_daily_mean_dummy
      Real*8 xx_ubar_mean_dummy
      Real*8 xx_vbar_mean_dummy
      Real*8 xx_wbar_mean_dummy
      Real*8 xx_psbar_mean_dummy
      Real*8 xx_bpbar_mean_dummy
      Real*8 xx_hflux_mean_dummy
      Real*8 xx_sflux_mean_dummy
      Real*8 xx_sstbar_mean_dummy
      Real*8 xx_sssbar_mean_dummy
      Real*8 xx_atmfwbar_mean_dummy
      Real*8 xx_taux_mean_dummy
      Real*8 xx_tauy_mean_dummy
      Real*8 xx_atemp_mean_dummy
      Real*8 xx_aqh_mean_dummy
      Real*8 xx_precip_mean_dummy
      Real*8 xx_swflux_mean_dummy
      Real*8 xx_swdown_mean_dummy
      Real*8 xx_snowprecip_mean_dummy
      Real*8 xx_lwflux_mean_dummy
      Real*8 xx_lwdown_mean_dummy
      Real*8 xx_evap_mean_dummy
      Real*8 xx_apressure_mean_dummy
      Real*8 xx_runoff_mean_dummy
      Real*8 xx_uwind_mean_dummy
      Real*8 xx_vwind_mean_dummy
      Real*8 xx_theta_ini_fin_dummy
      Real*8 xx_salt_ini_fin_dummy
      Real*8 xx_smrareabar_mean_dummy
      Real*8 xx_smrsstbar_mean_dummy
      Real*8 xx_smrsssbar_mean_dummy
      Real*8 xx_iestaubar_mean_dummy
cHFLUXM_CONTROL
      Real*8 xx_hfluxm_dummy
cHFLUXM_CONTROL
      Real*8 xx_shifwflx_dummy

C--   Parameters maxCtrlArr2D, maxCtrlArr3D, maxCtrlTim2D are set in CTRL_SIZE.h
      common /ctrl_dummy_arr/
     &    xx_genarr2d_dummy
     &  , xx_genarr3d_dummy
     &  , xx_gentim2d_dummy
      Real*8 xx_genarr2d_dummy(maxCtrlArr2D)
      Real*8 xx_genarr3d_dummy(maxCtrlArr3D)
      Real*8 xx_gentim2d_dummy(maxCtrlTim2D)

c     ==================================================================
c     END OF HEADER CONTROL DUMMIES
c     ==================================================================


C     ==================================================================
C     CTRL_GENARR.h
C     ==================================================================


      COMMON /CONTROLFILES_CARR/
     &     xx_genarr2d_file,
     &     xx_genarr3d_file,
     &     xx_genarr2d_weight,
     &     xx_genarr3d_weight,
     &     xx_genarr2d_preproc, xx_genarr2d_preproc_c,
     &     xx_genarr3d_preproc, xx_genarr3d_preproc_c
      CHARACTER*(MAX_LEN_FNAM) xx_genarr2d_file(maxCtrlArr2D)
      CHARACTER*(MAX_LEN_FNAM) xx_genarr3d_file(maxCtrlArr3D)
      CHARACTER*(MAX_LEN_FNAM) xx_genarr2d_weight(maxCtrlArr2D)
      CHARACTER*(MAX_LEN_FNAM) xx_genarr3d_weight(maxCtrlArr3D)
      CHARACTER*(MAX_LEN_FNAM)
     &         xx_genarr2d_preproc(maxCtrlProc,maxCtrlArr2D)
      CHARACTER*(MAX_LEN_FNAM)
     &         xx_genarr3d_preproc(maxCtrlProc,maxCtrlArr3D)
      CHARACTER*(MAX_LEN_FNAM)
     &         xx_genarr2d_preproc_c(maxCtrlProc,maxCtrlArr2D)
      CHARACTER*(MAX_LEN_FNAM)
     &         xx_genarr3d_preproc_c(maxCtrlProc,maxCtrlArr3D)

      COMMON /CONTROLFILES_RARR/
     &     genarr2dPrecond, genarr3dPrecond,
     &     xx_genarr2d_bounds,xx_genarr3d_bounds,
     &     xx_genarr2d_preproc_r,xx_genarr3d_preproc_r
      Real*8 genarr2dPrecond(maxCtrlArr2D)
      Real*8 genarr3dPrecond(maxCtrlArr3D)
      Real*8 xx_genarr2d_bounds(5,maxCtrlArr2D)
      Real*8 xx_genarr3d_bounds(5,maxCtrlArr3D)
      Real*8 xx_genarr2d_preproc_r(maxCtrlProc,maxCtrlArr2D)
      Real*8 xx_genarr3d_preproc_r(maxCtrlProc,maxCtrlArr3D)

      COMMON /CONTROLFILES_IARR/
     &     xx_genarr2d_preproc_i,xx_genarr3d_preproc_i
      integer xx_genarr2d_preproc_i(maxCtrlProc,maxCtrlArr2D)
      integer xx_genarr3d_preproc_i(maxCtrlProc,maxCtrlArr3D)

      COMMON /CONTROLFILES_CTIM/
     &     xx_gentim2d_file, xx_gentim2d_weight,
     &     xx_gentim2d_preproc, xx_gentim2d_preproc_c
      CHARACTER*(MAX_LEN_FNAM) xx_gentim2d_file(maxCtrlTim2D)
      CHARACTER*(MAX_LEN_FNAM) xx_gentim2d_weight(maxCtrlTim2D)
      CHARACTER*(MAX_LEN_FNAM)
     &         xx_gentim2d_preproc(maxCtrlProc,maxCtrlTim2D)
      CHARACTER*(MAX_LEN_FNAM)
     &         xx_gentim2d_preproc_c(maxCtrlProc,maxCtrlTim2D)

      COMMON /CONTROLFILES_ITIM/
     &     xx_gentim2d_startdate1,
     &     xx_gentim2d_startdate2,
     &     xx_gentim2d_startdate,
     &     xx_gentim2d_preproc_i
      INTEGER xx_gentim2d_startdate1(maxCtrlTim2D)
      INTEGER xx_gentim2d_startdate2(maxCtrlTim2D)
      INTEGER xx_gentim2d_startdate(4,maxCtrlTim2D)
      INTEGER xx_gentim2d_preproc_i(maxCtrlProc,maxCtrlTim2D)

      COMMON /CONTROLFILES_RTIM/
     &     xx_gentim2d_period, gentim2dPrecond,
     &     xx_gentim2d_preproc_r, xx_gentim2d_bounds
      Real*8 xx_gentim2d_period(maxCtrlTim2D)
      Real*8 gentim2dPrecond(maxCtrlTim2D)
      Real*8 xx_gentim2d_preproc_r(maxCtrlProc,maxCtrlTim2D)
      Real*8 xx_gentim2d_bounds(5,maxCtrlTim2D)

      COMMON /CONTROLFILES_LTIM/
     &     xx_gentim2d_cumsum, xx_gentim2d_glosum
      LOGICAL xx_gentim2d_cumsum(maxCtrlTim2D)
      LOGICAL xx_gentim2d_glosum(maxCtrlTim2D)

      common /controlaux_gencost_r/
     &     objf_gentim2d,  num_gentim2d, mult_gentim2d,
     &     objf_genarr2d,  num_genarr2d, mult_genarr2d,
     &     objf_genarr3d,  num_genarr3d, mult_genarr3d

      Real*8  objf_gentim2d(nsx,nsy,maxCtrlTim2D)
      Real*8  num_gentim2d(nsx,nsy,maxCtrlTim2D)
      Real*8  mult_gentim2d(maxCtrlTim2D)
      Real*8  objf_genarr2d(nsx,nsy,maxCtrlArr2D)
      Real*8  num_genarr2d(nsx,nsy,maxCtrlArr2D)
      Real*8  mult_genarr2d(maxCtrlArr2D)
      Real*8  objf_genarr3d(nsx,nsy,maxCtrlArr3D)
      Real*8  num_genarr3d(nsx,nsy,maxCtrlArr3D)
      Real*8  mult_genarr3d(maxCtrlArr3D)




      common /controlaux_gentim2d_r/
     &                      xx_gentim2d0,
     &                      xx_gentim2d1,
     &                      xx_gentim2d,
     &                      wgentim2d
      Real*8
     & xx_gentim2d0(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy,maxCtrlTim2D)
      Real*8
     & xx_gentim2d1(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy,maxCtrlTim2D)
      Real*8
     & xx_gentim2d(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy,maxCtrlTim2D)
      Real*8
     & wgentim2d(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy,maxCtrlTim2D)

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
c     ==================================================================
c     HEADER AVERAGES
c     ==================================================================
c
c     o Header for obcs ctrl weights
c
c     ==================================================================
c     HEADER AVERAGES
c     ==================================================================

      Real*8  objf_obcsn(nsx,nsy), objf_obcss(nsx,nsy)
      Real*8  objf_obcsw(nsx,nsy), objf_obcse(nsx,nsy)
      Real*8  objf_obcsvol, objf_ageos(nsx,nsy)
      Real*8  mult_obcsn, mult_obcss
      Real*8  mult_obcsw, mult_obcse
      Real*8  mult_obcsvol, mult_ageos
      Real*8  num_obcsn(nsx,nsy), num_obcss(nsx,nsy)
      Real*8  num_obcsw(nsx,nsy), num_obcse(nsx,nsy)
      Real*8  num_obcsvol, num_ageos(nsx,nsy)
      common /ecco_cost_weights_obcs/
     &     objf_obcsn, objf_obcss, objf_obcsw, objf_obcse,
     &     objf_obcsvol, objf_ageos,
     &     mult_obcsn, mult_obcss, mult_obcsw, mult_obcse,
     &     mult_obcsvol, mult_ageos,
     &     num_obcsn, num_obcss, num_obcsw, num_obcse,
     &     num_obcsvol, num_ageos

      common /ih_modes/ modesv
      Real*8 modesv (nr,nr,nr)
      common /ctrl_dummy_obcs/
     &                    xx_obcsn_dummy
     &                  , xx_obcss_dummy
     &                  , xx_obcsw_dummy
     &                  , xx_obcse_dummy
      Real*8 xx_obcsn_dummy
      Real*8 xx_obcss_dummy
      Real*8 xx_obcsw_dummy
      Real*8 xx_obcse_dummy
      common /controlfiles_c_obcs/
     &                      xx_obcsn_file
     &                    , xx_obcss_file
     &                    , xx_obcsw_file
     &                    , xx_obcse_file
      character*(MAX_LEN_FNAM) xx_obcsn_file
      character*(MAX_LEN_FNAM) xx_obcss_file
      character*(MAX_LEN_FNAM) xx_obcsw_file
      character*(MAX_LEN_FNAM) xx_obcse_file
      common /controltimes_r_obcs/
     &                        xx_obcsnperiod
     &                      , xx_obcssperiod
     &                      , xx_obcswperiod
     &                      , xx_obcseperiod
      Real*8     xx_obcsnperiod
      Real*8     xx_obcssperiod
      Real*8     xx_obcswperiod
      Real*8     xx_obcseperiod
      common /controltimes_i_obcs/
     &                        xx_obcsnstartdate1
     &                      , xx_obcsnstartdate2
     &                      , xx_obcssstartdate1
     &                      , xx_obcssstartdate2
     &                      , xx_obcswstartdate1
     &                      , xx_obcswstartdate2
     &                      , xx_obcsestartdate1
     &                      , xx_obcsestartdate2
     &                      , xx_obcsnstartdate
     &                      , xx_obcssstartdate
     &                      , xx_obcswstartdate
     &                      , xx_obcsestartdate
      integer xx_obcsnstartdate1
      integer xx_obcsnstartdate2
      integer xx_obcssstartdate1
      integer xx_obcssstartdate2
      integer xx_obcswstartdate1
      integer xx_obcswstartdate2
      integer xx_obcsestartdate1
      integer xx_obcsestartdate2
      integer xx_obcsnstartdate(4)
      integer xx_obcssstartdate(4)
      integer xx_obcswstartdate(4)
      integer xx_obcsestartdate(4)
      common /controlvars_i_obcsn/
     &                       nwetobcsn,
     &                       nwetobcsnglo
      integer nwetobcsn     ( nsx,nsy,nr,nobcs )
      integer nwetobcsnglo  ( nr,nobcs )
      common /controlvars_i_obcss/
     &                       nwetobcss,
     &                       nwetobcssglo
      integer nwetobcss     ( nsx,nsy,nr,nobcs )
      integer nwetobcssglo  ( nr,nobcs )
      common /controlvars_i_obcsw/
     &                       nwetobcsw,
     &                       nwetobcswglo
      integer nwetobcsw     ( nsx,nsy,nr,nobcs )
      integer nwetobcswglo  ( nr,nobcs )
      common /controlvars_i_obcse/
     &                       nwetobcse,
     &                       nwetobcseglo
      integer nwetobcse     ( nsx,nsy,nr,nobcs )
      integer nwetobcseglo  ( nr,nobcs )

C     This is moved from ecco_local_params.h, because it is the only
C     parameter used (by obcs ctrl parameters)
      common /ecco_data_errfile/
     &     data_errfile
      character*(max_len_fnam) data_errfile



      common /ecco_cost_weights_obcse/
     &                      wobcse, wobcseLev
      Real*8 wobcse     (                      nr,nobcs)
      Real*8 wobcseLev  (1-oly:sny+oly,nr,nsx,nsy,nobcs)
      common /controlaux_obcse_r/
     &                      xx_obcse0,
     &                      xx_obcse1
      Real*8 xx_obcse0 (1-Oly:sNy+Oly,Nr,nSx,nSy,nobcs)
      Real*8 xx_obcse1 (1-Oly:sNy+Oly,Nr,nSx,nSy,nobcs)

c     ==================================================================
c     HEADER COST
c     ==================================================================
c
c     o Header for model-data comparison.
c
c     The individual cost function contributions are multiplied by
c     factors mult_"var" which allow to switch off these contributions
c     without removing them in the adjoint code. This is useful for
c     doing tests with the adjoint and perhaps useful in assimilation
c     experiments where individual contributions are successively
c     switched on. For future applications it would be better to place
c     the initialisation of the multipliers somewhere else, for example
c     in a namelist, which is read in at the start of the model.
c
c     started: Christian Eckert eckert@mit.edu  24-Feb-1999
c     changed: Christian Eckert eckert@mit.edu
c     heimbach@mit.edu 05-Nov-2003 Modularize cost package
c
c     ==================================================================
c     HEADER COST
c     ==================================================================

c     The cost function, its contributions, and multipliers:
c     ======================================================
c
c     fc         - Final cost function.
c     glofc      - contributions from global mean constraints
c     mult_"var" - multipliers for the individual cost
c                  function contributions.

      common /cost_r/
     &                fc, glofc
      Real*8  fc
      Real*8  glofc

C     tile_fc   :: Final cost function contribution from this tile
      COMMON /COST_FINAL_R/ tile_fc
      Real*8  tile_fc (nSx,nSy)

      common /cost_objf/
     &                objf_atl,
     &                objf_test,
     &                objf_tracer,
     &                objf_entropy,
     &                objf_t_misfit,
     &                objf_eflux

      Real*8  objf_atl  (nsx,nsy)
      Real*8  objf_test (nsx,nsy)
      Real*8  objf_tracer (nsx,nsy)
      Real*8  objf_entropy (nsx,nsy)
      Real*8  objf_t_misfit (nsx,nsy)
      Real*8  objf_eflux (nsx,nsy)

      common /cost_param_r/
     &                lastinterval
      Real*8 lastinterval



      common /cost_aux_r/
     &                    mult_atl,
     &                    mult_test,
     &                    mult_tracer,
     &                    mult_entropy,
     &                    mult_t_misfit,
     &                    mult_eflux,
     &                    multTheta,
     &                    multSalt,
     &                    multUvel,
     &                    multVvel,
     &                    multEtan

      Real*8  mult_atl
      Real*8  mult_test
      Real*8  mult_tracer
      Real*8  mult_entropy
      Real*8  mult_t_misfit
      Real*8  mult_eflux
      Real*8  multTheta
      Real*8  multSalt
      Real*8  multUvel
      Real*8  multVvel
      Real*8  multEtan


      COMMON /COST_MEAN_R/
     &                     cMeanTheta, cMeanUVel, cMeanVVel,
     &                     cMeanThetaUVel, cMeanThetaVVel
      Real*8 cMeanTheta(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 cMeanUVel(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 cMeanVVel(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 cMeanThetaUVel(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 cMeanThetaVVel(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)

c     ==================================================================
c     END OF HEADER COST
c     ==================================================================
c     ==================================================================
c     HEADER AVERAGES
c     ==================================================================
c
c     o Header for averaged temperature, salinity, and surface pressure
c       fields and counters associated with the averaging.
c
c     started: Christian Eckert eckert@mit.edu  30-Jun-1999
c
c     ==================================================================
c     HEADER AVERAGES
c     ==================================================================

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

c     ==================================================================
c     END OF HEADER COST
c     ==================================================================
CBOP
C    !ROUTINE: EOS.h
C    !INTERFACE:
C    include EOS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | EOS.h
C     | o Header file defining coefficients for equation of state.
C     *==========================================================*
C     | The values from the model standard input file are
C     | stored into the variables held here.
C     *==========================================================*
C     \ev
CEOP

C     SItoBar  :: conversion factor for pressure, from Pa (SI Unit) to Bar
C     SItodBar :: conversion factor for pressure, from Pa (SI Unit) to deci Bar
      Real*8 SItoBar, SItodBar
      PARAMETER ( SItoBar  = 1.D-05 )
      PARAMETER ( SItodBar = 1.D-04 )

C Shared EOS Parameter
C     eosRefP0  :: reference atmospheric pressure used in EOS formulation
      COMMON /PARM_EOS_SHARED/ eosRefP0, equationOfState
      Real*8 eosRefP0
      CHARACTER*(6) equationOfState

C Linear equation of state
C     tAlpha    :: Linear EOS thermal expansion coefficient ( 1/degree ).
C     sBeta     :: Linear EOS haline contraction coefficient.
      COMMON /PARM_EOS_LIN/ tAlpha, sBeta
      Real*8 tAlpha
      Real*8 sBeta

C Equation of State (polynomial coeffients)
      COMMON /PARM_EOS_POLY3/ eosC,eosSig0,eosRefT,eosRefS
      Real*8 eosC(9,Nr+1),eosSig0(Nr+1),eosRefT(Nr+1),eosRefS(Nr+1)

C Full Equation of State
C     eosType = 'JMD95' (Jackett and McDougall 1995, JAOT)
C     eosType = 'UNESCO' (Millero et al. 1980, DSR)
C     COMMON /PARM_EOS_JMD95/
C     eosJMDCFw  :: of fresh water at pressure 0
C     eosJMDCSw  :: of sea water at pressure 0
C     eosJMDCKFw :: of secant bulk modulus K of fresh water at pressure 0
C     eosJMDCKSw :: of secant bulk modulus K of sea water at pressure 0
C     eosJMDCKP  :: of secant bulk modulus K at pressure p
C     eosType = 'MDJWF' (McDougall et al. 2003, JAOT)
C     COMMON /PARM_EOS_MDJWF/
C     eosMDJWFnum :: coefficients of numerator
C     eosMDJWFden :: coefficients of denominator
C     eosType = 'TEOS10' (McDougall et al. 2011, http://www.teos-10.org)
C     Note: this eos implies that variables THETA and SALT are interpreted
C     as conservative temperature and absolute salinity
C     COMMON /PARM_TEOS10/
C     teos        :: 48 coeffiencts of numerator and denominator
C     end nonlinear equation of state
      Real*8 eosJMDCFw(6), eosJMDCSw(9)
      Real*8 eosJMDCKFw(5), eosJMDCKSw(7), eosJMDCKP(14)
      COMMON /PARM_EOS_JMD95/
     &     eosJMDCFw, eosJMDCSw, eosJMDCKFw, eosJMDCKSw, eosJMDCKP
      Real*8 eosMDJWFnum(0:11), eosMDJWFden(0:12)
      COMMON /PARM_EOS_MDJWF/
     &     eosMDJWFnum, eosMDJWFden
      Real*8 teos(48)
      COMMON /PARM_TEOS10/
     &     teos
c
c
c     ==================================================================
c     HEADER exf_constants
c     ==================================================================
c
c     o Header file for constants.
c       These include  - numbers (e.g. 1, 2, 1/2, ...)
c                      - physical constants (e.g. gravitational const.)
c                      - empirical parameters
c                      - control parameters (e.g. max. no of iteration)
c
c     started: Patrick Heimbach heimbach@mit.edu  06-May-2000
c     mods for pkg/seaice: menemenlis@jpl.nasa.gov 20-Dec-2002
c
c     ==================================================================
c     HEADER exf_constants
c     ==================================================================

c     1. numbers

c     exf_half   0.5
c     exf_one    1.0
c     exf_two    2.0

      Real*8 exf_half
      Real*8 exf_one
      Real*8 exf_two

      PARAMETER(
     &              exf_half =  0.5D0 ,
     &              exf_one  =  1.0D0 ,
     &              exf_two  =  2.0D0
     &         )

c     real       exf_undef
c     PARAMETER( exf_undef = -9000. )

c     2. physical constants

c     stefanBoltzmann :: Stefan-Boltzmann constant [J*K^-4*m^-2*s^-1]
c                        sigma = (2*pi^5*k^4)/(15*h^3*c^2)
c     karman          :: von Karman constant
      Real*8    stefanBoltzmann
      Real*8    karman
      PARAMETER ( stefanBoltzmann = 5.670D-8 )
      PARAMETER ( karman = 0.4D0 )

c     3. empirical parameters

c     To invert the relationship ustar = ustar(umagn) the following
c     parameterization is used:
c
c      ustar**2 = umagn**2 * CDN(umagn)
c
c                  / cquadrag_1 * umagn**2 + cquadrag_2; 0 < u < 11 m/s
c      CDN(umagn) =
c                  \ clindrag_1 * umagn + clindrag_2   ; u > 11 m/s
c
c      clindrag_[n] - n = 1, 2 coefficients used to evaluate
c                     LINEAR relationship of Large and Pond 1981
c      cquadrag_[n] - n = 1, 2 coefficients used to evaluate
c                     quadratic relationship
c      u11          - u = 11 m/s wind speed
c      ustofu11     - ustar = 0.3818 m/s, corresponding to u = 11 m/s

      Real*8 clindrag_1, clindrag_2
      Real*8 cquadrag_1, cquadrag_2
      Real*8 u11
      Real*8 ustofu11

      PARAMETER (
     &            ustofu11    =         0.381800D0 ,
     &            u11         =        11.D0 ,
     &            clindrag_1  =         0.000065D0 ,
     &            clindrag_2  =         0.000490D0 ,
     &            cquadrag_1  = clindrag_1/u11/2 ,
     &            cquadrag_2  = clindrag_1*u11/2 + clindrag_2
     &          )

c     4. control parameters

c     niter_bulk   - Number of iterations to be performed for the
c                    evaluation of the bulk surface fluxes. The ncom
c                    model uses 2 hardwired interation steps (loop
c                    unrolled).
c
      INTEGER     niter_bulk
      PARAMETER ( niter_bulk = 2 )

C     5. other constants or parameters

C     COMMON /EXF_PARAM_R_2/
C     cen2kel      :: conversion of deg. Centigrade to Kelvin
C     gravity_mks  :: gravitational acceleration [m/s^2]
C     atmrho       :: mean atmospheric density [kg/m^3]
C     atmcp        :: mean atmospheric specific heat [J/kg/K]
C     flamb        :: latent heat of evaporation [J/kg]
C     flami        :: latent heat of melting of pure ice [J/kg]
C     cvapor_[]    :: Coeff to calculate Saturation Specific Humidity
C                     see e.g. Gill (1982) p.41 Eq. (3.1.15)
C     humid_fac    :: constant entering the evaluation of the virtual
C                     temperature
C     gamma_blk    :: adiabatic lapse rate
C     saltsat      :: reduction of saturation vapor pressure over salt water
C     sstExtrapol  :: extrapolation coeff from 1rst 2 levels up to surface
C  snow_emissivity :: longwave  snow  emissivity [-] (with pkg thsice/seaice)
C-- to evaluate turbulent transfert coefficients:
C     cdrag_[n]    :: n = 1,2,3 coefficients used to evaluate
C                     drag coefficient,
C     For Large and Yeager (2009): extra coefficient n = 8 and
C     cdragMax     :: maximum drag coefficient ...
C     umax         :: ... at maximum wind
C     cstanton_[n] :: n = 1,2   coefficients used to evaluate
C                     the Stanton number (stable/unstable cond.)
C     cdalton      :: coefficient used to evaluate the Dalton number
C     zolmin       :: minimum stability parameter
C     psim_fac     :: coef used in turbulent fluxes calculation [-]
C     zref         :: reference height
C     hu           :: height of mean wind
C     ht           :: height of mean temperature
C     hq           :: height of mean rel. humidity
C     umin         :: minimum absolute wind speed used to evaluate
C                     drag coefficient [m/s]
C     exf_iceCd    :: drag coefficient over sea-ice (fixed)
C     exf_iceCe    :: transfert coeff. over sea-ice, for Evaporation (fixed)
C     exf_iceCh    :: transfert coeff. over sea-ice, for Sens.Heating (fixed)
C-- radiation:
C     exf_albedo   :: Sea-water albedo
C ocean_emissivity :: longwave ocean-surface emissivity [-]
C   ice_emissivity :: longwave seaice emissivity [-] (with pkg thsice/seaice)
C  snow_emissivity :: longwave  snow  emissivity [-] (with pkg thsice/seaice)

      Real*8    cen2kel
      Real*8    gravity_mks
      Real*8    atmrho
      Real*8    atmcp
      Real*8    flamb, flami
      Real*8    cvapor_fac,     cvapor_exp
      Real*8    cvapor_fac_ice, cvapor_exp_ice
      Real*8    humid_fac
      Real*8    gamma_blk
      Real*8    saltsat
      Real*8    sstExtrapol
      Real*8    cdrag_1, cdrag_2, cdrag_3, cdrag_8, cdragMax, umax
      Real*8    cstanton_1, cstanton_2
      Real*8    cdalton
      Real*8    zolmin
      Real*8    psim_fac
      Real*8    zref
      Real*8    hu
      Real*8    ht
      Real*8    hq
      Real*8    umin
      Real*8    exf_iceCd
      Real*8    exf_iceCe
      Real*8    exf_iceCh
      Real*8    exf_albedo
      Real*8    ocean_emissivity
      Real*8    ice_emissivity
      Real*8    snow_emissivity

      COMMON /EXF_PARAM_R_2/
     &       cen2kel,
     &       gravity_mks,
     &       atmrho,
     &       atmcp,
     &       flamb,
     &       flami,
     &       cvapor_fac,     cvapor_exp,
     &       cvapor_fac_ice, cvapor_exp_ice,
     &       humid_fac,
     &       gamma_blk,
     &       saltsat,
     &       sstExtrapol,
     &       cdrag_1, cdrag_2, cdrag_3, cdrag_8, cdragMax, umax,
     &       cstanton_1, cstanton_2,
     &       cdalton,
     &       zolmin,
     &       psim_fac,
     &       zref,
     &       hu,
     &       ht,
     &       hq,
     &       umin,
     &       exf_iceCd,  exf_iceCe,  exf_iceCh,
     &       exf_albedo,
     &       ocean_emissivity,
     &       ice_emissivity,
     &       snow_emissivity
CBOP
C    !ROUTINE: EXF_INTERP_SIZE.h
C    !INTERFACE:
C #include EXF_INTERP_SIZE.h

C     ==================================================================
C     HEADER EXF_INTERP_SIZE.h
C     ==================================================================

C    !DESCRIPTION:
C   Contains maximum size of original input grid from which interpolation
C    to model grid is done.
C-  Note: This header file needs to be included before EXF_INTERP_PARAM.h
C    since it uses MAX_LAT_INC which is defined here.
CEOP


C     INTEGER MAX_LAT_INC :: maximum length of latitude grid-spacing vector
C                            used for exf-interpolation input-grid
      INTEGER MAX_LAT_INC
      PARAMETER( MAX_LAT_INC = 1279 )


C     ==================================================================
C     HEADER exf_fields
C     ==================================================================
C
C     o Header file for the surface flux data.
C
C     started: Ralf.Giering@FastOpt.de 25-Mai-2000
C     changed: field swap in adj. mode; heimbach@mit.edu 10-Jan-2002
C     included runoff D. Stammer, Nov. 25, 2001
C     mods for pkg/seaice: menemenlis@jpl.nasa.gov 20-Dec-2002
C
C     ==================================================================
C     HEADER exf_fields
C     ==================================================================

C     Field definitions, units, and sign conventions:
C     ===============================================
C
C     ustress   :: Zonal surface wind stress in N/m^2
C                  > 0 for increase in uVel, which is west to
C                      east for cartesian and spherical polar grids
C                  Typical range: -0.5 < ustress < 0.5
C                  Input field
C
C     vstress   :: Meridional surface wind stress in N/m^2
C                  > 0 for increase in vVel, which is south to
C                      north for cartesian and spherical polar grids
C                  Typical range: -0.5 < vstress < 0.5
C                  Input field
C
C     hflux     :: Net upward surface heat flux including shortwave in W/m^2
C                  hflux = latent + sensible + lwflux + swflux
C                  > 0 for decrease in theta (ocean cooling)
C                  Typical range: -250 < hflux < 600
C                  Input field
C
C     sflux     :: Net upward freshwater flux in m/s
C                  sflux = evap - precip - runoff
C                  > 0 for increase in salt (ocean salinity)
C                  Typical range: -1e-7 < sflux < 1e-7
C                  Input field
C
C     swflux    :: Net upward shortwave radiation in W/m^2
C                  swflux = - ( swdown - ice and snow absorption - reflected )
C                  > 0 for decrease in theta (ocean cooling)
C                  Typical range: -350 < swflux < 0
C                  Input field
C
C     uwind     :: Surface (10-m) zonal wind velocity in m/s
C                  > 0 for increase in uVel, which is west to
C                      east for cartesian and spherical polar grids
C                  Typical range: -10 < uwind < 10
C                  Input or input/output field
C
C     vwind     :: Surface (10-m) meridional wind velocity in m/s
C                  > 0 for increase in vVel, which is south to
C                      north for cartesian and spherical polar grids
C                  Typical range: -10 < vwind < 10
C                  Input or input/output field
C
C     wspeed    :: Surface (10-m) wind speed in m/s
C                  >= 0 sqrt(u^2+v^2)
C                  Typical range: 0 < wspeed < 10
C                  Input or input/output field
C
C     atemp     :: Surface (2-m) air temperature in deg K
C                  Typical range: 200 < atemp < 300
C                  Input or input/output field
C
C     aqh       :: Surface (2m) specific humidity in kg/kg
C                  Typical range: 0 < aqh < 0.02
C                  Input or input/output field
C
C     hs        :: sensible heat flux into ocean in W/m^2
C                  > 0 for increase in theta (ocean warming)
C
C     hl        :: latent   heat flux into ocean in W/m^2
C                  > 0 for increase in theta (ocean warming)
C
C     lwflux    :: Net upward longwave radiation in W/m^2
C                  lwflux = - ( lwdown - ice and snow absorption - emitted )
C                  > 0 for decrease in theta (ocean cooling)
C                  Typical range: -20 < lwflux < 170
C                  Input field
C
C     evap      :: Evaporation in m/s
C                  > 0 for increase in salt (ocean salinity)
C                  Typical range: 0 < evap < 2.5e-7
C                  Input, input/output, or output field
C
C     precip    :: Total Precipitation (rain+snow) in m/s of liquid water
C                  > 0 for decrease in salt (ocean salinity)
C                  Typical range: 0 < precip < 5e-7
C                  Input or input/output field
C
C     snowprecip :: snow precipitation in m/s of equivalent liquid water
C                  > 0 for decrease in salt (ocean salinity)
C                  Typical range: 0 < precip < 5e-7
C                  Input or input/output field
C
C     runoff    :: River and glacier runoff in m/s
C                  > 0 for decrease in salt (ocean salinity)
C                  Typical range: 0 < runoff < ????
C                  Input or input/output field
C
C     runoftemp :: Temperature of runoff in deg C
C
C     saltflx   :: Net upward salt flux in (g/kg).kg/m^2/s = g/m^2/s
C                  > 0 for decrease in SSS.
C                  Typical origin: salty sea-ice formation / melting.
C
C     swdown    :: Downward shortwave radiation in W/m^2
C                  > 0 for increase in theta (ocean warming)
C                  Typical range: 0 < swdown < 450
C                  Input/output field
C
C     lwdown    :: Downward longwave radiation in W/m^2
C                  > 0 for increase in theta (ocean warming)
C                  Typical range: 50 < lwdown < 450
C                  Input/output field
C
C     apressure :: Atmospheric surface pressure field in Pa
C                  Typical range: 88000 < apressure < 108000
C                  Input field
C
C     tidePot   :: Tidal geopotential forcing in m^2/s^2
C                  Typical range: -10 < tidePot < +10
C                  Input field

C     NOTES:
C     ======
C
C     By default all surface forcing fields are defined at the center
C     of each grid (the rVel location in model/inc/GRID.h) unless
C     flags readStressOnAgrid or readStressOnCgrid are set.
C
C     Input and output units and sign conventions can be customized
C     using variables exf_inscal_* and exf_outscal_*, which are set
C     by exf_readparms.F
C
C     Output fields fu, fv, Qnet, Qsw, and EmPmR are
C     defined in FFIELDS.h
C
C     Arrays *0 and *1 below are used for temporal interpolation.
C

      COMMON /exf_stress_r/ ustress, vstress
      Real*8 ustress   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 vstress   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_ustress_r/ ustress0, ustress1
      Real*8 ustress0  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 ustress1  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_vstress_r/ vstress0, vstress1
      Real*8 vstress0  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 vstress1  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      COMMON /exf_wspeed_r/ wspeed
      Real*8 wspeed   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_wspeed_r/ wspeed0, wspeed1
      Real*8 wspeed0  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 wspeed1  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      COMMON /exf_atm_wind_r/ uwind, vwind
      Real*8 uwind     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 vwind     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_uwind_r/ uwind0, uwind1
      Real*8 uwind0    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 uwind1    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_vwind_r/ vwind0, vwind1
      Real*8 vwind0    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 vwind1    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      COMMON /exf_netflux_r/ hflux, sflux
      Real*8 hflux     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sflux     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_hflux_r/ hflux0, hflux1
      Real*8 hflux0    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 hflux1    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_sflux_r/ sflux0, sflux1
      Real*8 sflux0    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sflux1    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      COMMON /exf_atm_temp_r/ atemp, aqh, hs, hl, lwflux,
     &                        evap, precip, snowprecip
      Real*8 atemp     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 aqh       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 hs        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 hl        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 lwflux    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 evap      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 precip    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 snowprecip (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_atemp_r/ atemp0, atemp1
      Real*8 atemp0    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 atemp1    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_aqh_r/ aqh0, aqh1
      Real*8 aqh0      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 aqh1      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_lwflux_r/ lwflux0, lwflux1
      Real*8 lwflux0   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 lwflux1   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_precip_r/ precip0, precip1
      Real*8 precip0   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 precip1   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_snowprecip_r/ snowprecip0, snowprecip1
      Real*8 snowprecip0(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 snowprecip1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C     wStress   :: wind-stress magnitude [Pa=N/m^2], @ grid-cell center
C     sh        :: wind-speed [m/s] (always larger than uMin)
      COMMON /exfl_wind_r/ wStress, cw, sw, sh
      Real*8 wStress   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 cw        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sw        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sh        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      COMMON /exf_swflux_r/ swflux
      Real*8 swflux    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_swflux_r/ swflux0, swflux1
      Real*8 swflux0   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 swflux1   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      COMMON /exf_rad_down_r/ swdown, lwdown
      Real*8 swdown    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 lwdown    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      COMMON /exfl_rad_down_r/ swdown0, swdown1, lwdown0, lwdown1
      Real*8 swdown0   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 swdown1   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 lwdown0   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 lwdown1   (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

      COMMON /exf_apressure_r/ apressure, apressure0, apressure1
      Real*8 apressure (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 apressure0(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 apressure1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)








CBOP
C !ROUTINE: GAD.h

C !INTERFACE:
C #include "GAD.h"

C !DESCRIPTION:
C Contains enumerated constants for distinguishing between different
C advection schemes and tracers.
C
C Unfortunately, there is no easy way to make use of the
C tokens in namelist input so for now we have to enter the
C tokens value into "data" (ie. 2 for 2nd order etc.)

C !USES:

C !DEFINED PARAMETERS:

C ENUM_UPWIND_1RST :: 1rst Order Upwind
      INTEGER ENUM_UPWIND_1RST
      PARAMETER(ENUM_UPWIND_1RST=1)

C ENUM_CENTERED_2ND :: Centered 2nd order
      INTEGER ENUM_CENTERED_2ND
      PARAMETER(ENUM_CENTERED_2ND=2)

C ENUM_UPWIND_3RD :: 3rd order upwind
      INTEGER ENUM_UPWIND_3RD
      PARAMETER(ENUM_UPWIND_3RD=3)

C ENUM_CENTERED_4TH :: Centered 4th order
      INTEGER ENUM_CENTERED_4TH
      PARAMETER(ENUM_CENTERED_4TH=4)

C ENUM_DST2 :: 2nd Order Direct Space and Time (= Lax-Wendroff)
      INTEGER ENUM_DST2
      PARAMETER(ENUM_DST2=20)

C ENUM_FLUX_LIMIT :: Non-linear flux limiter
      INTEGER ENUM_FLUX_LIMIT
      PARAMETER(ENUM_FLUX_LIMIT=77)

C ENUM_DST3 :: 3rd Order Direst Space and Time
      INTEGER ENUM_DST3
      PARAMETER(ENUM_DST3=30)

C ENUM_DST3_FLUX_LIMIT :: 3-DST flux limited
      INTEGER ENUM_DST3_FLUX_LIMIT
      PARAMETER(ENUM_DST3_FLUX_LIMIT=33)

C ENUM_OS7MP :: 7th Order One Step method with Monotonicity Preserving Limiter
      INTEGER ENUM_OS7MP
      PARAMETER(ENUM_OS7MP=7)

C ENUM_SOM_PRATHER :: 2nd Order-Moment Advection Scheme, Prather, 1986
      INTEGER ENUM_SOM_PRATHER
      PARAMETER(ENUM_SOM_PRATHER=80)

C ENUM_SOM_LIMITER :: 2nd Order-Moment Advection Scheme, Prather Limiter
      INTEGER ENUM_SOM_LIMITER
      PARAMETER(ENUM_SOM_LIMITER=81)

C ENUM_PPM_NULL :: piecewise parabolic method with "null" limiter
      INTEGER ENUM_PPM_NULL_LIMIT
      PARAMETER(ENUM_PPM_NULL_LIMIT=40)

C ENUM_PPM_MONO :: piecewise parabolic method with "mono" limiter
      INTEGER ENUM_PPM_MONO_LIMIT
      PARAMETER(ENUM_PPM_MONO_LIMIT=41)

C ENUM_PPM_WENO :: piecewise parabolic method with "weno" limiter
      INTEGER ENUM_PPM_WENO_LIMIT
      PARAMETER(ENUM_PPM_WENO_LIMIT=42)

C ENUM_PQM_NULL :: piecewise quartic method with "null" limiter
      INTEGER ENUM_PQM_NULL_LIMIT
      PARAMETER(ENUM_PQM_NULL_LIMIT=50)

C ENUM_PQM_MONO :: piecewise quartic method with "mono" limiter
      INTEGER ENUM_PQM_MONO_LIMIT
      PARAMETER(ENUM_PQM_MONO_LIMIT=51)

C ENUM_PQM_WENO :: piecewise quartic method with "weno" limiter
      INTEGER ENUM_PQM_WENO_LIMIT
      PARAMETER(ENUM_PQM_WENO_LIMIT=52)

C GAD_Scheme_MaxNum :: maximum possible number for an advection scheme
      INTEGER GAD_Scheme_MaxNum
      PARAMETER( GAD_Scheme_MaxNum = 100 )

C nSOM :: number of 1rst & 2nd Order-Moments: 1+1 (1D), 2+3 (2D), 3+6 (3D)
      INTEGER nSOM
      PARAMETER( nSOM = 3+6 )

C oneSixth :: Third/fourth order interpolation factor
      Real*8 oneSixth
      PARAMETER(oneSixth=1.d0/6.d0)

C loop range for computing vertical advection tendency
C  iMinAdvR,iMaxAdvR  :: 1rst index (X-dir) loop range for vertical advection
C  jMinAdvR,jMaxAdvR  :: 2nd  index (Y-dir) loop range for vertical advection
      INTEGER iMinAdvR, iMaxAdvR, jMinAdvR, jMaxAdvR
c     PARAMETER ( iMinAdvR = 1-OLx , iMaxAdvR = sNx+OLx )
c     PARAMETER ( jMinAdvR = 1-OLy , jMaxAdvR = sNy+OLy )
C- note: we use to compute vertical advection tracer tendency everywhere
C        (overlap included) as above, but really needs valid tracer tendency
C        in interior only (as below):
      PARAMETER ( iMinAdvR = 1 , iMaxAdvR = sNx )
      PARAMETER ( jMinAdvR = 1 , jMaxAdvR = sNy )

C Differentiate between tracers (needed for KPP - arrgh!!!)
cph                              and GMRedi arrgh*arrgh!!!)
cph  indices are used for TAF key computations, so need to
cph  running from 1, 2, ...
c
C GAD_TEMPERATURE :: temperature
      INTEGER GAD_TEMPERATURE
      PARAMETER(GAD_TEMPERATURE=1)
C GAD_SALINITY :: salinity
      INTEGER GAD_SALINITY
      PARAMETER(GAD_SALINITY=2)
C GAD_TR1 :: passive tracer 1
      INTEGER GAD_TR1
      PARAMETER(GAD_TR1=3)
CEOP

C--   COMMON /GAD_PARM_C/ Character parameters for GAD pkg routines
C      somSfx       :: 1rst & 2nd Order moment suffix
      CHARACTER*2 somSfx(nSOM)
      COMMON /GAD_PARM_C/
     & somSfx

C--   COMMON /GAD_PARM_I/ Integer parameters for GAD pkg routines
C GAD_OlMinSize     :: overlap minimum size for GAD routines
C           1: min required; 2: to add to current min; 3: factor to apply
      INTEGER GAD_OlMinSize(3)
      COMMON /GAD_PARM_I/
     &        GAD_OlMinSize

C--   COMMON /GAD_PARM_L/ Logical parameters for GAD pkg routines
C tempSOM_Advection :: set to T if using 2nd-Order Moment advection for Temp
C saltSOM_Advection :: set to T if using 2nd-Order Moment advection for Salt
C tempMultiDimAdvec :: set to T if using multi-dim advection for Temp
C saltMultiDimAdvec :: set to T if using multi-dim advection for Salt
C AdamsBashforthGt  :: apply Adams-Bashforth extrapolation on T tendency (=Gt)
C AdamsBashforthGs  :: apply Adams-Bashforth extrapolation on S tendency (=Gs)
C AdamsBashforth_T  :: apply Adams-Bashforth extrapolation on Pot.Temp.
C AdamsBashforth_S  :: apply Adams-Bashforth extrapolation on Salinity
      LOGICAL tempSOM_Advection
      LOGICAL saltSOM_Advection
      LOGICAL tempMultiDimAdvec
      LOGICAL saltMultiDimAdvec
      LOGICAL AdamsBashforthGt
      LOGICAL AdamsBashforthGs
      LOGICAL AdamsBashforth_T
      LOGICAL AdamsBashforth_S
      COMMON /GAD_PARM_L/
     & tempSOM_Advection, saltSOM_Advection,
     & tempMultiDimAdvec, saltMultiDimAdvec,
     & AdamsBashforthGt, AdamsBashforthGs,
     & AdamsBashforth_T, AdamsBashforth_S

      Real*8 SmolarkiewiczMaxFrac
      COMMON /GAD_SMOL/ SmolarkiewiczMaxFrac

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
CBOP
C     !ROUTINE: GAD_SOM_VARS.h
C     !INTERFACE:
C     include "GAD_SOM_VARS.h"
C     !DESCRIPTION:
C     \bv
C     *==========================================================*
C     | GAD_SOM_VARS.h
C     | o state variables for 2nd Order-Moment Advection
C     *==========================================================*
C     | Storage needed for Temperature and Salinity when using
C     | 2nd Order-Moment (SOM) Advection
C     *==========================================================*
C     \ev
CEOP


CBOP
C     !ROUTINE: OBCS_PARAMS.h
C     !INTERFACE:
C     #include "OBCS_PARAMS.h"

C     !DESCRIPTION:
C     *==========================================================*
C     | OBCS_PARAMS.h
C     | o Header file containing OBCS parameters
C     *==========================================================*
C     | o Note: does not (and should not) contain any conditional
C     |   statement that depends on OBCS options ; therefore
C     |   can be safely included without OBCS_OPTIONS.h
C     *==========================================================*
CEOP

C tidalComponents  :: number of tidal components to be applied
C OBCS_maxConnect  :: maximum number of connected parts
      INTEGER tidalComponents
      INTEGER OBCS_maxConnect
      PARAMETER ( tidalComponents = 10 )
      PARAMETER ( OBCS_maxConnect = sNx+sNy )

C--   COMMON /OBC_PARM_I/ OBCS integer-type parameter
C OBCS_u1_adv_T    :: >0: use 1rst O. upwind adv-scheme @ OB (=1: only if outflow)
C OBCS_u1_adv_S    :: >0: use 1rst O. upwind adv-scheme @ OB (=1: only if outflow)
C OBCS_monSelect   :: select group of variables to monitor
C spongeThickness  :: number grid points that make up the sponge layer (def=0)
      COMMON /OBC_PARM_I/
     & OBCS_u1_adv_T, OBCS_u1_adv_S,
     & OBCS_monSelect,
     & spongeThickness
      INTEGER OBCS_u1_adv_T, OBCS_u1_adv_S
      INTEGER OBCS_monSelect
      INTEGER spongeThickness

C--   COMMON /OBC_PARM_L/ OBCS logical-type parameter
C useOrlanskiNorth/South/East/West
C                  :: specify Orlanski boundary conditions for northern/
C                     southern/eastern/Western
C useStevensNorth/South/East/West
C                  :: use open boundary computations following Stevens (1990)
C useStevensPhaseVel
C                  :: use phase velocity contribution for open boundary
C                     computations following Stevens (1990), default = true
C useStevensAdvection
C                  :: use advective contribution for open boundary
C                     computations following Stevens (1990), default = true
C
C useOBCSsponge    :: turns on sponge layer along boundaries (def=false)
C OBCSsponge_N     :: turns on sponge layer along North boundary (def=true)
C OBCSsponge_S     :: turns on sponge layer along South boundary (def=true)
C OBCSsponge_E     :: turns on sponge layer along East boundary (def=true)
C OBCSsponge_W     :: turns on sponge layer along West boundary (def=true)
C OBCSsponge_UatNS :: turns on uVel sponge at North/South boundaries (def=true)
C OBCSsponge_UatEW :: turns on uVel sponge at East/West boundaries (def=true)
C OBCSsponge_VatNS :: turns on vVel sponge at North/South boundaries (def=true)
C OBCSsponge_VatEW :: turns on vVel sponge at East/West boundaries (def=true)
C OBCSsponge_Theta :: turns on Theta sponge along boundaries (def=true)
C OBCSsponge_Salt  :: turns on Salt sponge along boundaries (def=true)
C useLinearSponge  :: use linear instead of exponential sponge (def=false)
C
C useOBCSbalance   :: balance the volume flux through boundary
C                     at every time step
C OBCSbalanceSurf  :: also include surface flux of mass into balance
C useOBCStides     :: modify OB normal flow to add tidal forcing
C                     NOTE that at the moment tidal forcing is applied
C                     only to "normal" flow.                                                     
C useOBCSprescribe :: read boundary conditions from a file
C                      (overrides Orlanski and other boundary values)
C OBCSprintDiags   :: print boundary values to STDOUT (def=true)
C OBCSfixTopo      :: check and adjust topography for problematic gradients
C                     across boundaries (def=true)

      COMMON /OBC_PARM_L/
     & useOrlanskiNorth,useOrlanskiSouth,
     & useOrlanskiEast,useOrlanskiWest,
     & useStevensNorth,useStevensSouth,
     & useStevensEast,useStevensWest,
     & useStevensPhaseVel, useStevensAdvection,
     & useOBCSsponge,
     & OBCSsponge_N, OBCSsponge_S,
     & OBCSsponge_E, OBCSsponge_W,
     & OBCSsponge_UatNS, OBCSsponge_UatEW,
     & OBCSsponge_VatNS, OBCSsponge_VatEW,
     & OBCSsponge_Theta, OBCSsponge_Salt, useLinearSponge,
     & useOBCSbalance, OBCSbalanceSurf, useOBCStides, useOBCSprescribe,
     & OBCSprintDiags,
     & OBCSfixTopo
      LOGICAL useOrlanskiNorth
      LOGICAL useOrlanskiSouth
      LOGICAL useOrlanskiEast
      LOGICAL useOrlanskiWest
      LOGICAL useStevensNorth
      LOGICAL useStevensSouth
      LOGICAL useStevensEast
      LOGICAL useStevensWest
      LOGICAL useStevensPhaseVel
      LOGICAL useStevensAdvection
      LOGICAL useOBCSsponge
      LOGICAL OBCSsponge_N
      LOGICAL OBCSsponge_S
      LOGICAL OBCSsponge_E
      LOGICAL OBCSsponge_W
      LOGICAL OBCSsponge_UatNS
      LOGICAL OBCSsponge_UatEW
      LOGICAL OBCSsponge_VatNS
      LOGICAL OBCSsponge_VatEW
      LOGICAL OBCSsponge_Theta
      LOGICAL OBCSsponge_Salt
      LOGICAL useLinearSponge
      LOGICAL useOBCSbalance
      LOGICAL OBCSbalanceSurf
      LOGICAL useOBCStides
      LOGICAL useOBCSprescribe
      LOGICAL OBCSprintDiags
      LOGICAL OBCSfixTopo

C--   COMMON /OBC_PARM_R/ OBCS real-type parameter
C OBCS_balanceFacN/S/E/W  :: weighting factor for balancing OB normal flow
C OBCS_uvApplyFac         :: multiplying factor to U,V normal comp. when applying
C                            OBC to 2nd column/row (for backward compatibility).
C OBCS_monitorFreq        :: monitor output frequency (s) for OB statistics
C U/Vrelaxobcsinner/bound :: relaxation time scale (in seconds) on the boundary
C                            (bound) and at the innermost grid point of the sponge
C                            layer (inner); relaxation time scales in-between
C                            are linearly interpolated from these values
C T/SrelaxStevens         :: relaxation time scale (in seconds) for T/S-points
C                            for Stevens boundary conditions
C tidalPeriod             :: tidal period (s)
      COMMON /OBC_PARM_R/
     &     OBCS_balanceFacN, OBCS_balanceFacS,
     &     OBCS_balanceFacE, OBCS_balanceFacW,
     &     OBCS_uvApplyFac,
     &     OBCS_monitorFreq,
     &     tidalPeriod,
     & Urelaxobcsinner,Urelaxobcsbound,
     & Vrelaxobcsinner,Vrelaxobcsbound,
     & TrelaxStevens, SrelaxStevens
      Real*8 OBCS_balanceFacN, OBCS_balanceFacS
      Real*8 OBCS_balanceFacE, OBCS_balanceFacW
      Real*8 OBCS_uvApplyFac
      Real*8 OBCS_monitorFreq
      Real*8 tidalPeriod(tidalComponents)
      Real*8 Urelaxobcsinner
      Real*8 Urelaxobcsbound
      Real*8 Vrelaxobcsinner
      Real*8 Vrelaxobcsbound
      Real*8 TrelaxStevens
      Real*8 SrelaxStevens

C--   COMMON /OBC_FILES/ OBCS character-type parameter
C OB[N,S,E,W][u,v,w,t,s,eta,am,ph]File :: Files with boundary conditions,
C                                         the letter combinations mean:
C                     N/S/E/W   :: northern/southern/eastern/western boundary
C                     u/v/w/t/s :: ocean u/v/w velocities, temperature/salinity
C                     eta       :: sea surface height
C                     am/ph     :: tidal amplitude (m/s) / phase (s)
C OB[N,S,E,W]connectFile :: Files with connected piece Id for N/S/E/W OB grid pt
C insideOBmaskFile   :: File to specify Inside OB region mask (zero beyond OB)
      COMMON /OBC_FILES/
     &      OBNuFile,  OBSuFile,  OBEuFile,  OBWuFile,
     &      OBNvFile,  OBSvFile,  OBEvFile,  OBWvFile,
     &      OBNwFile,  OBSwFile,  OBEwFile,  OBWwFile,
     &      OBNtFile,  OBStFile,  OBEtFile,  OBWtFile,
     &      OBNsFile,  OBSsFile,  OBEsFile,  OBWsFile,
     &      OBNetaFile,OBSetaFile,OBEetaFile,OBWetaFile,
     &      OBNamFile, OBSamFile, OBEamFile, OBWamFile,
     &      OBNphFile, OBSphFile, OBEphFile, OBWphFile,
     &      OBNconnectFile, OBSconnectFile,
     &      OBEconnectFile, OBWconnectFile,
     &      insideOBmaskFile
      CHARACTER*(MAX_LEN_FNAM)
     &      OBNuFile,  OBSuFile,  OBEuFile,  OBWuFile,
     &      OBNvFile,  OBSvFile,  OBEvFile,  OBWvFile,
     &      OBNwFile,  OBSwFile,  OBEwFile,  OBWwFile,
     &      OBNtFile,  OBStFile,  OBEtFile,  OBWtFile,
     &      OBNsFile,  OBSsFile,  OBEsFile,  OBWsFile,
     &      OBNetaFile,OBSetaFile,OBEetaFile,OBWetaFile,
     &      OBNamFile, OBSamFile, OBEamFile, OBWamFile,
     &      OBNphFile, OBSphFile, OBEphFile, OBWphFile,
     &      OBNconnectFile, OBSconnectFile,
     &      OBEconnectFile, OBWconnectFile,
     &      insideOBmaskFile


CBOP
C     !ROUTINE: OBCS_FIELDS.h
C     !INTERFACE:
C     #include "OBCS_FIELDS.h"

C     !DESCRIPTION:
C     *==========================================================*
C     | OBCS_FIELDS.h
C     | o Header file containing OB values of model fields
C     *==========================================================*
CEOP

C     OBCS_ldRec     :: time-record currently loaded (in temp arrays *[1])
      COMMON /OBCS_LOAD_I/ OBCS_ldRec
      INTEGER OBCS_ldRec(nSx,nSy)

C--   COMMON /OBCS_FIELDS/ Open boundary related stuff
C OB[N,S,E,W][u,v,w,t,s,eta,am,ph] :: Fields with boundary conditions,
C                                     the letter combinations mean:
C                     N/S/E/W   :: northern/southern/eastern/western boundary
C                     u/v/w/t/s :: ocean u/v/w velocities, temperature/salinity
C                     eta       :: sea surface height
C                     am/ph     :: tidal amplitude (m/s) / phase (s)
C     OBNu is the U value imposed at the Northern OB
C     OBNv is the V value imposed at the Northern OB
C     OBNt is the T value imposed at the Northern OB
C     OBNs is the S value imposed at the Northern OB
C     etc



      COMMON /OBCS_FIELDS_E/
     &      OBEu,OBEv,OBEt,OBEs
      Real*8 OBEu (1-Oly:sNy+Oly,Nr,nSx,nSy)
      Real*8 OBEv (1-Oly:sNy+Oly,Nr,nSx,nSy)
      Real*8 OBEt (1-Oly:sNy+Oly,Nr,nSx,nSy)
      Real*8 OBEs (1-Oly:sNy+Oly,Nr,nSx,nSy)
      COMMON /OBCS_FIELDS_AUX_E/
     &      OBEu0,OBEv0,OBEt0,OBEs0,
     &      OBEu1,OBEv1,OBEt1,OBEs1
      Real*8 OBEu0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      Real*8 OBEv0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      Real*8 OBEt0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      Real*8 OBEs0 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      Real*8 OBEu1 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      Real*8 OBEv1 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      Real*8 OBEt1 (1-Oly:sNy+Oly,Nr,nSx,nSy)
      Real*8 OBEs1 (1-Oly:sNy+Oly,Nr,nSx,nSy)





CBOP
C     !ROUTINE: OBCS_SEAICE.h
C     !INTERFACE:
C     #include "OBCS_SEAICE.h"

C     !DESCRIPTION:
C     *==========================================================*
C     | OBCS_SEAICE.h
C     | o Header file containing
C     |   OBCS seaice parameters and OB values of seaice fields.
C     *==========================================================*
CEOP

C seaiceSpongeThickness  :: number grid points that make up the sponge layer (def=0)
      COMMON /OBC_SEAICE_PARM_I/
     & seaiceSpongeThickness
      INTEGER seaiceSpongeThickness

C useSeaiceSponge :: turns on seaice sponge layer along boundary (def=false)
      COMMON /OBC_SEAICE_PARM_L/
     & useSeaiceSponge
      LOGICAL useSeaiceSponge

C [A,H,SL,SN]relaxobcs[inner,bound] :: relaxation time scale (in seconds) on the
C                            boundary (bound) and at the innermost grid point of the
C                            sponge layer (inner); relaxation time scales in-between
C                            are linearly interpolated from these values
      COMMON /OBC_SEAICE_PARM_R/
     &     Arelaxobcsinner,  Arelaxobcsbound,
     &     Hrelaxobcsinner,  Hrelaxobcsbound,
     &    SLrelaxobcsinner, SLrelaxobcsbound,
     &    SNrelaxobcsinner, SNrelaxobcsbound
      Real*8  Arelaxobcsinner,  Arelaxobcsbound
      Real*8  Hrelaxobcsinner,  Hrelaxobcsbound
      Real*8 SLrelaxobcsinner, SLrelaxobcsbound
      Real*8 SNrelaxobcsinner, SNrelaxobcsbound

C OB[N,S,E,W][a,h,sn,sl,uice,vice]File :: Files with boundary conditions,
C                                         the letter combinations mean:
C                     N/S/E/W   :: northern/southern/eastern/western boundary
C                     a/h       :: sea ice concentration/effective thickness
C                     sn/sl     :: effective snow thickness/sea ice salinity
C                     uice/vice :: sea ice u/v drift velocities

      COMMON /OBC_SEAICE_FILES/
     &      OBNaFile,   OBSaFile,   OBEaFile,   OBWaFile,
     &      OBNhFile,   OBShFile,   OBEhFile,   OBWhFile,
     &      OBNslFile,  OBSslFile,  OBEslFile,  OBWslFile,
     &      OBNsnFile,  OBSsnFile,  OBEsnFile,  OBWsnFile,
     &      OBNuiceFile,OBSuiceFile,OBEuiceFile,OBWuiceFile,
     &      OBNviceFile,OBSviceFile,OBEviceFile,OBWviceFile
      CHARACTER*(MAX_LEN_FNAM)
     &      OBNaFile,   OBSaFile,   OBEaFile,   OBWaFile,
     &      OBNhFile,   OBShFile,   OBEhFile,   OBWhFile,
     &      OBNslFile,  OBSslFile,  OBEslFile,  OBWslFile,
     &      OBNsnFile,  OBSsnFile,  OBEsnFile,  OBWsnFile,
     &      OBNuiceFile,OBSuiceFile,OBEuiceFile,OBWuiceFile,
     &      OBNviceFile,OBSviceFile,OBEviceFile,OBWviceFile

c#ifdef 

C-    dimension parameters :
C     xSize  :: X-dimension for 1 tile array (overlap included)
C     xySize :: product of X-dim x Y-dim for 1 tile array
      INTEGER xSize, xySize
      PARAMETER (  xSize = Olx+sNx+Olx )
      PARAMETER ( xySize = xSize*(Oly+sNy+Oly) )

C     DWNSLP_size :: size of downsloping-flow arrays ; for each tile,
C            must be > number of bathymetric steps
C            The default value (=tile domain size) can increased (if needed)
C             or reduced (to save memory space).
      INTEGER DWNSLP_size
      PARAMETER ( DWNSLP_size = xSize * (Oly+sNy+Oly) )

c#endif 

C store the location of potential site where Down-Sloping Flow is applied
C  DWNSLP_NbSite :: Number of bathymetry steps within each tile
C  DWNSLP_ijDeep :: horiz. index of deep water-column next to DWNSLP site
C  DWNSLP_shVsD  :: horiz. index of shallow water-column relative to ijDeep
C  DWNSLP_deepK  :: level index (in deep water column) where dense water
C                   (from the bottom of shallow column) is flowing into.
      INTEGER DWNSLP_NbSite( nSx, nSy )
      INTEGER DWNSLP_ijDeep( DWNSLP_size, nSx, nSy )
      INTEGER DWNSLP_shVsD ( DWNSLP_size, nSx, nSy )
      INTEGER DWNSLP_deepK ( DWNSLP_size, nSx, nSy )
      COMMON /DWNSLP_SITE/
     &  DWNSLP_NbSite, DWNSLP_ijDeep, DWNSLP_shVsD, DWNSLP_deepK

C store variables used to compute the Down-Sloping transport of each tracer.
C     DWNSLP_Gamma  :: geometric factor = slope * cross section area [m^2]
C     DWNSLP_Transp :: down-sloping flow: volume transport [m^3/s]
C        if using P-Coord., Gamma & Transp units become [m.Pa] & [m^2.Pa/s]
      Real*8 DWNSLP_Gamma ( DWNSLP_size, nSx, nSy )
      Real*8 DWNSLP_Transp( DWNSLP_size, nSx, nSy )
      COMMON /DWNSLP_FLOW/ DWNSLP_Gamma, DWNSLP_Transp


CBOP
C !ROUTINE: KPP.h

C !DESCRIPTION: \bv
C     /==========================================================C     | KPP.h                                                    |
C     | o Basic header for KPP vertical mixing parameterization. |
C     |   Contains all KPP field declarations.                   |
C     \==========================================================/

C-----------------------------------------------------------------------
C
C Time varying parameters computed by subroutine kpp_calc
C     KPPviscAz  - Vertical eddy viscosity coefficient                (m^2/s)
C     KPPdiffKzS - Vertical diffusion coefficient for salt and tracers(m^2/s)
C     KPPdiffKzT - Vertical diffusion coefficient for heat            (m^2/s)
C     KPPghat    - Nonlocal transport coefficient                     (s/m^2)
C     KPPhbl     - Mixing layer depth                                     (m)
C     KPPfrac    - Fraction of short-wave flux penetrating mixing layer
C     KPPplumefrac - Fraction of saltplume penetrating mixing layer
C
C-----------------------------------------------------------------------
C \ev
CEOP

      Real*8 KPPviscAz  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 KPPdiffKzS (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 KPPdiffKzT (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 KPPghat    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 KPPhbl     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,   nSx,nSy)
      Real*8 KPPfrac    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,   nSx,nSy)
      COMMON /kpp/ KPPviscAz, KPPdiffKzT, KPPdiffKzS
     &              , KPPghat, KPPhbl
      COMMON /kpp_short/ KPPfrac


CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     note: under the multi-threaded model myIter and
C           myTime are local variables passed around as routine
C           arguments. Although this is fiddly it saves the need to
C           impose additional synchronisation points when they are
C           updated.
C     myTime :: time counter for this thread
C     myIter :: iteration counter for this thread
C     myThid :: thread number for this instance of the routine.
      INTEGER iloop
      Real*8     myTime
      INTEGER myIter
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     modelEnd  :: true if reaching the end of the run
C     myTimeBeg :: time at beginning of time step (needed by longstep)
C     myIterBeg :: iteration number at beginning of time step
      LOGICAL modelEnd
CEOP

      IF (debugMode) CALL DEBUG_ENTER('FORWARD_STEP',myThid)

C--   Reset the model iteration counter and the model time.
      myIter = nIter0 + (iloop-1)
      myTime = startTime + deltaTClock*(iLoop-1)

      CALL AUTODIFF_INADMODE_UNSET( myTime, myIter, myThid )


c**************************************
C
C     store directives for checkpoint level 1
C
C     created: heimbach@mit.edu 10-Jan-2002
C

CADJ STORE totPhiHyd = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE phi0surf  = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE saltFlux  = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE sIceLoad  = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE PmEpR     = comlev1, key = ikey_dynamics,  kind = isbyte
CADJ STORE dEtaHdt   = comlev1, key = ikey_dynamics,  kind = isbyte
CADJ STORE wVel      = comlev1, key = ikey_dynamics, kind = isbyte

CADJ STORE gtNm1, gsNm1 = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE guNm1, gvNm1 = comlev1, key = ikey_dynamics, kind = isbyte



CADJ STORE etaH = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE theta, salt = comlev1, key = ikey_dynamics,kind = isbyte




c
c     store directives for checkpoint level 1
c



c
c     store directives for checkpoint level 1
c
c     created: heimbach@mit.edu 10-Jan-2002
c
C     most of these fields are here for safety only, because it should
C     always be possible to save the field hflux instead of hflux0 and
C     hflux1 in the innermost checkpoint level

CADJ STORE hflux0    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE hflux1    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE sflux0    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE sflux1    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE ustress0  = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE ustress1  = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE vstress0  = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE vstress1  = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE wspeed0   = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE wspeed1   = comlev1, key=ikey_dynamics, kind=isbyte


CADJ STORE aqh0      = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE aqh1      = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE atemp0    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE atemp1    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE precip0   = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE precip1   = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE lwflux0   = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE lwflux1   = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE swflux0   = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE swflux1   = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE snowprecip0 = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE snowprecip1 = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE evap      = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE swdown0   = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE swdown1   = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE lwdown0   = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE lwdown1   = comlev1, key=ikey_dynamics, kind=isbyte


CADJ STORE uwind0    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE uwind1    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE vwind0    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE vwind1    = comlev1, key=ikey_dynamics, kind=isbyte

CADJ STORE theta     = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE apressure0    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE apressure1    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE siceload      = comlev1, key=ikey_dynamics, kind=isbyte


CADJ STORE xx_gentim2d     = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE xx_gentim2d0    = comlev1, key=ikey_dynamics, kind=isbyte
CADJ STORE xx_gentim2d1    = comlev1, key=ikey_dynamics, kind=isbyte

CADJ STORE taux0     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE taux1     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE tauy0     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE tauy1     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE Qnet0     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE Qnet1     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE EmPmR0    = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE EmPmR1    = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE SST0      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE SST1      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE SSS0      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE SSS1      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE saltFlux0 = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE saltFlux1 = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE Qsw0      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE Qsw1      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE pLoad0    = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE pLoad1    = comlev1, key = ikey_dynamics, kind = isbyte




CADJ STORE OBEu    = comlev1, key = ikey_dynamics
CADJ STORE OBEv    = comlev1, key = ikey_dynamics
CADJ STORE OBEt    = comlev1, key = ikey_dynamics
CADJ STORE OBEs    = comlev1, key = ikey_dynamics
CADJ STORE obeu0,obeu1  = comlev1, key = ikey_dynamics
CADJ STORE obev0,obev1  = comlev1, key = ikey_dynamics
CADJ STORE obet0,obet1  = comlev1, key = ikey_dynamics
CADJ STORE obes0,obes1  = comlev1, key = ikey_dynamics
CADJ STORE xx_obcse0,xx_obcse1 = comlev1, key = ikey_dynamics

















CADJ STORE cMeanThetaUVel = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE cMeanThetaVVel = comlev1, key = ikey_dynamics, kind = isbyte


c
c     store directives for checkpoint level 1
c
c     created: heimbach@mit.edu 10-Jan-2002
c
c add temporary lev1 store here for testing

c**************************************


C--   Reset geometric factors (hFacC,W,S & recip_hFac) to their current values:
C     added to simplify adjoint derivation - no effect in forward run


C--   Switch on/off diagnostics for snap-shot output:
      IF ( useDiagnostics ) THEN
        CALL DIAGNOSTICS_SWITCH_ONOFF( myTime, myIter, myThid )
C--   State-variables diagnostics
        CALL TIMER_START('DO_STATEVARS_DIAGS  [FORWARD_STEP]',myThid)
        CALL DO_STATEVARS_DIAGS( myTime, 0, myIter, myThid )
        CALL TIMER_STOP ('DO_STATEVARS_DIAGS  [FORWARD_STEP]',myThid)
      ENDIF



C--   Call driver to load external forcing fields from file
      IF (debugMode) CALL DEBUG_CALL('LOAD_FIELDS_DRIVER',myThid)
cph Important STORE that avoids hidden recomp. of load_fields_driver
CADJ STORE theta      = comlev1, key = ikey_dynamics,
CADJ &     kind = isbyte
CADJ STORE uVel, vVel = comlev1, key = ikey_dynamics,
CADJ &     kind = isbyte
      CALL TIMER_START('LOAD_FIELDS_DRIVER  [FORWARD_STEP]',myThid)
      CALL LOAD_FIELDS_DRIVER( myTime, myIter, myThid )
      CALL TIMER_STOP ('LOAD_FIELDS_DRIVER  [FORWARD_STEP]',myThid)

C--   Call Bulk-Formulae forcing package

C--   Call external chepaml forcing package

C--   Add control vector for forcing and parameter fields
      IF ( useCTRL ) THEN
       CALL TIMER_START('CTRL_MAP_FORCING  [FORWARD_STEP]',myThid)
       CALL CTRL_MAP_FORCING( myTime, myIter, myThid )
       CALL TIMER_STOP ('CTRL_MAP_FORCING  [FORWARD_STEP]',myThid)
      ENDIF

      CALL DUMMY_IN_STEPPING( myTime, myIter, myThid )



C******************************************************
C     Store surface forcing fields if required to avoid
C     calling load_fields_driver in forward_step_ad
C
C     store directives for checkpoint level 1 AFTER surface forcing
C     has been read
C
C     We store surface forcing fields --- if required --- to avoid
C     calling load_fields_driver in forward_step_ad.  Many of these
C     directives are only necessary in specific cases, for example with
C     pkg/seaice of pkg/shelfice, but since there are many potential
C     cases where these stores may become necessary, we just add them
C     here for all forcing fields under the sun. TAF will pick the
C     correct directives as they become necessary.
C
CADJ STORE sst        = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE sss        = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE qnet       = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE empmr      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE saltflux   = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE fu, fv     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE qsw        = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE pload      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE uwind      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE vwind      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE wspeed     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE sh         = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE hflux      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE sflux      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE ustress    = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE vstress    = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE atemp      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE aqh        = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE hs         = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE hl         = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE lwflux     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE evap       = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE precip     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE snowprecip = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE swflux     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE swdown     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE lwdown     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE apressure  = comlev1, key = ikey_dynamics, kind = isbyte
C     in some cases this also requires storing the surface control
C     variables because they are used by packages, e.g. shelfice
CADJ STORE xx_gentim2d = comlev1, key = ikey_dynamics, kind = isbyte
C******************************************************

C--     Step forward fields and calculate time tendency terms.

      IF (debugMode) CALL DEBUG_CALL('DO_ATMOSPHERIC_PHYS',myThid)
      CALL TIMER_START('DO_ATMOSPHERIC_PHYS [FORWARD_STEP]',myThid)
      CALL DO_ATMOSPHERIC_PHYS( myTime, myIter, myThid )
      CALL TIMER_STOP ('DO_ATMOSPHERIC_PHYS [FORWARD_STEP]',myThid)

CADJ STORE uVel, vVel = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE EmPmR      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE PmEpR      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE salt       = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE totphihyd  = comlev1, key = ikey_dynamics, kind = isbyte

       IF (debugMode) CALL DEBUG_CALL('DO_OCEANIC_PHYS',myThid)
       CALL TIMER_START('DO_OCEANIC_PHYS     [FORWARD_STEP]',myThid)
       CALL DO_OCEANIC_PHYS( myTime, myIter, myThid )
       CALL TIMER_STOP ('DO_OCEANIC_PHYS     [FORWARD_STEP]',myThid)


C***********************************************************************
C     This block of store directives is for variables that have been
C     computed in do_oceanics_phys. Storing them here avoids calling
C     do_oceanic_phys again in forward_step_ad, which should improve
C     performance because expensive parts of the model are not
C     recomputed (e.g. seaice).
C
C     Store directives for checkpoint level 1 AFTER do_oceanic_phys
C     has been called
C
C     This block of store directives is for variables that have been
C     computed in do_oceanics_phys. Storing them here avoids calling
C     do_oceanic_phys again in forward_step_ad, which should improve
C     performance because expensive parts of the model are not
C     recomputed (e.g. seaice).
C
CADJ STORE EmPmR          = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE PmEpR          = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE qsw            = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE surfaceForcingU= comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE surfaceForcingV= comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE phi0surf       = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE sIceLoad       = comlev1, key = ikey_dynamics, kind = isbyte

CADJ STORE salt, theta = comlev1, key = ikey_dynamics, kind = isbyte


CADJ STORE OBEt        = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE OBEs        = comlev1, key = ikey_dynamics, kind = isbyte





cph the following needed to be moved here from do_oceanic_physics
cph to be visible down the road

CADJ STORE rhoInSitu      = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE surfaceForcingS= comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE surfaceForcingT= comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE IVDConvCount   = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE adjustColdSST_diag = comlev1, key = ikey_dynamics,
CADJ &     kind = isbyte


CADJ STORE KPPghat        = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE KPPfrac        = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE KPPdiffKzS     = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE KPPdiffKzT     = comlev1, key = ikey_dynamics, kind = isbyte



CADJ STORE DWNSLP_deepK   = comlev1, key = ikey_dynamics
CADJ STORE DWNSLP_Transp  = comlev1, key = ikey_dynamics, kind = isbyte


C***********************************************************************



      IF ( .NOT.staggerTimeStep ) THEN
CADJ STORE wVel = comlev1, key = ikey_dynamics, kind = isbyte
        IF (debugMode) CALL DEBUG_CALL('THERMODYNAMICS',myThid)
        CALL TIMER_START('THERMODYNAMICS      [FORWARD_STEP]',myThid)
        CALL THERMODYNAMICS( myTime, myIter, myThid )
        CALL TIMER_STOP ('THERMODYNAMICS      [FORWARD_STEP]',myThid)
C--     if not staggerTimeStep: end
      ENDIF
CADJ STORE salt, theta = comlev1, key = ikey_dynamics, kind = isbyte


c #ifdef ALLOW_NONHYDROSTATIC
      IF ( implicitIntGravWave ) THEN
        CALL TIMER_START('BLOCKING_EXCHANGES  [FORWARD_STEP]',myThid)
        CALL DO_STAGGER_FIELDS_EXCHANGES( myTime, myIter, myThid )
        CALL TIMER_STOP ('BLOCKING_EXCHANGES  [FORWARD_STEP]',myThid)
      ENDIF
c #endif

CADJ STORE etaN = comlev1, key = ikey_dynamics, kind = isbyte

C--   Step forward fields and calculate time tendency terms.
        IF (debugMode) CALL DEBUG_CALL('DYNAMICS',myThid)
        CALL TIMER_START('DYNAMICS            [FORWARD_STEP]',myThid)
        CALL DYNAMICS( myTime, myIter, myThid )
        CALL TIMER_STOP ('DYNAMICS            [FORWARD_STEP]',myThid)


C--   Update time-counter
      myIter = nIter0 + iLoop
      myTime = startTime + deltaTClock*iLoop

C     Update MNC time information
      IF ( useMNC ) THEN
         CALL MNC_UPDATE_TIME( myTime, myIter, myThid )
      ENDIF


C--   Update geometric factors:


C--   Apply Filters to u*,v* before SOLVE_FOR_PRESSURE

C--   Solve elliptic equation(s).
C     Two-dimensional only for conventional hydrostatic or
C     three-dimensional for non-hydrostatic and/or IGW scheme.
      IF ( momStepping ) THEN
        CALL TIMER_START('SOLVE_FOR_PRESSURE  [FORWARD_STEP]',myThid)
        CALL SOLVE_FOR_PRESSURE(myTime, myIter, myThid)
        CALL TIMER_STOP ('SOLVE_FOR_PRESSURE  [FORWARD_STEP]',myThid)
      ENDIF

C--   Correct divergence in flow field and cycle time-stepping momentum
        CALL TIMER_START('MOM_CORRECTION_STEP [FORWARD_STEP]',myThid)
        CALL MOMENTUM_CORRECTION_STEP(myTime, myIter, myThid)
        CALL TIMER_STOP ('MOM_CORRECTION_STEP [FORWARD_STEP]',myThid)
CADJ STORE uVel, vVel = comlev1, key = ikey_dynamics, kind = isbyte

      IF ( calc_wVelocity ) THEN
C--     Integrate continuity vertically for vertical velocity
C       (+ update "etaN" & "etaH", exact volume conservation):
        CALL TIMER_START('INTEGR_CONTINUITY   [FORWARD_STEP]',myThid)
        CALL INTEGR_CONTINUITY( uVel, vVel, myTime, myIter, myThid)
        CALL TIMER_STOP ('INTEGR_CONTINUITY   [FORWARD_STEP]',myThid)
      ENDIF
C--   These store directives avoid an (expensive) extra
C     "call solve_for_pressure" in forward_step_ad
CADJ STORE wVel = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE etaN = comlev1, key = ikey_dynamics, kind = isbyte


C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
      IF ( staggerTimeStep ) THEN
C--   do exchanges of U,V (needed for multiDim) when using stagger time-step :
        IF (debugMode)
     &   CALL DEBUG_CALL('DO_STAGGER_FIELDS_EXCH.',myThid)
        CALL TIMER_START('BLOCKING_EXCHANGES  [FORWARD_STEP]',myThid)
        CALL DO_STAGGER_FIELDS_EXCHANGES( myTime, myIter, myThid )
        CALL TIMER_STOP ('BLOCKING_EXCHANGES  [FORWARD_STEP]',myThid)

C--   State-variables diagnostics
        IF ( useDiagnostics ) THEN
          CALL TIMER_START('DO_STATEVARS_DIAGS  [FORWARD_STEP]',myThid)
          CALL DO_STATEVARS_DIAGS( myTime, 1, myIter, myThid )
          CALL TIMER_STOP ('DO_STATEVARS_DIAGS  [FORWARD_STEP]',myThid)
        ENDIF

C     these store directives prevent calling do_stagger_fields_exchanges
C     again in the AD-part of forward_step_ad
CADJ STORE salt, theta = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE wVel        = comlev1, key = ikey_dynamics, kind = isbyte
        IF (debugMode) CALL DEBUG_CALL('THERMODYNAMICS',myThid)
        CALL TIMER_START('THERMODYNAMICS      [FORWARD_STEP]',myThid)
        CALL THERMODYNAMICS( myTime, myIter, myThid )
        CALL TIMER_STOP ('THERMODYNAMICS      [FORWARD_STEP]',myThid)

C--    if staggerTimeStep: end
      ENDIF
C     this may not be necessary, but it does not do any harm (i.e. it is
C     ignored by TAF if not needed)
CADJ STORE salt, theta = comlev1, key = ikey_dynamics, kind = isbyte
C---+--------+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

cph This is needed because convective_adjustment calls
cph find_rho which may use pressure()
CADJ STORE totPhiHyd  = comlev1, key = ikey_dynamics,
CADJ &     kind = isbyte
C--   Apply adjustments to Tracers arrays (T,S,+pTracers)
      CALL TIMER_START('TRC_CORRECTION_STEP [FORWARD_STEP]',myThid)
      CALL TRACERS_CORRECTION_STEP(myTime, myIter, myThid)
      CALL TIMER_STOP ('TRC_CORRECTION_STEP [FORWARD_STEP]',myThid)



C--   Do "blocking" sends and receives for tendency "overlap" terms
c     CALL TIMER_START('BLOCKING_EXCHANGES  [FORWARD_STEP]',myThid)
c     CALL DO_GTERM_BLOCKING_EXCHANGES( myThid )
c     CALL TIMER_STOP ('BLOCKING_EXCHANGES  [FORWARD_STEP]',myThid)

C--   Do "blocking" sends and receives for field "overlap" terms
      CALL TIMER_START('BLOCKING_EXCHANGES  [FORWARD_STEP]',myThid)
      CALL DO_FIELDS_BLOCKING_EXCHANGES( myThid )
      CALL TIMER_STOP ('BLOCKING_EXCHANGES  [FORWARD_STEP]',myThid)
C     These store directives avoid extra subroutine calls, for example,
C     thermodynamics, tracers_correction_step, gchem_forcing_sep, and
C     do_fields_blocking_exchages
CADJ STORE theta, salt = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE uvel,  vvel = comlev1, key = ikey_dynamics, kind = isbyte
CADJ STORE totPhiHyd   = comlev1, key = ikey_dynamics, kind = isbyte

      IF ( useDiagnostics ) THEN
       CALL TIMER_START('DO_STATEVARS_DIAGS  [FORWARD_STEP]',myThid)
       CALL DO_STATEVARS_DIAGS( myTime, 2, myIter, myThid )
       CALL TIMER_STOP ('DO_STATEVARS_DIAGS  [FORWARD_STEP]',myThid)
      ENDIF




C--   State-variables time-averaging
      CALL TIMER_START('DO_STATEVARS_TAVE   [FORWARD_STEP]',myThid)
      CALL DO_STATEVARS_TAVE( myTime, myIter, myThid )
      CALL TIMER_STOP ('DO_STATEVARS_TAVE   [FORWARD_STEP]',myThid)



      IF ( monitorFreq.GT.0. .OR. adjMonitorFreq.GT.0. ) THEN
C--   Check status of solution (statistics, cfl, etc...)
        CALL TIMER_START('MONITOR             [FORWARD_STEP]',myThid)
        CALL MONITOR( myTime, myIter, myThid )
        CALL TIMER_STOP ('MONITOR             [FORWARD_STEP]',myThid)
      ENDIF

C--     compare model with data and compute cost function
C--     this is done after exchanges to allow interpolation
      CALL TIMER_START('COST_TILE           [FORWARD_STEP]',myThid)
      CALL COST_TILE  ( myTime, myIter, myThid )
      CALL TIMER_STOP ('COST_TILE           [FORWARD_STEP]',myThid)

C--   Diagnose variables for pkg/ecco averaging and cost function purposes
      IF ( useECCO ) CALL ECCO_PHYS( myTime, myIter, myThid )

C--   Check if it has reached the end of simulation
      modelEnd = myTime.EQ.endTime .OR. myIter.EQ.nEndIter
      IF ( useSIGREG ) THEN
        modelEnd = modelEnd .OR. ( i_got_signal.GT.0 )
      ENDIF

C--   Do IO if needed.
      CALL TIMER_START('DO_THE_MODEL_IO     [FORWARD_STEP]',myThid)
      CALL DO_THE_MODEL_IO( modelEnd, myTime, myIter, myThid )
      CALL TIMER_STOP ('DO_THE_MODEL_IO     [FORWARD_STEP]',myThid)


C--   Save state for restarts
      CALL TIMER_START('DO_WRITE_PICKUP     [FORWARD_STEP]',myThid)
      CALL DO_WRITE_PICKUP( modelEnd, myTime, myIter, myThid )
      CALL TIMER_STOP ('DO_WRITE_PICKUP     [FORWARD_STEP]',myThid)

      IF ( useSIGREG ) THEN
        IF ( modelEnd .AND. i_got_signal.GT.0 ) THEN
          STOP 'Checkpoint completed -- killed by signal handler'
        ENDIF
      ENDIF

      CALL AUTODIFF_INADMODE_SET( myTime, myIter, myThid )


      IF (debugMode) CALL DEBUG_LEAVE('FORWARD_STEP',myThid)

      RETURN
      END
