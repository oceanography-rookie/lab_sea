










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



CBOP 0
C !ROUTINE: EXCH2_GET_SCAL_BOUNDS

C !INTERFACE:
      SUBROUTINE EXCH2_GET_SCAL_BOUNDS(
     I                 fCode, eWdth, updateCorners,
     I                 tgTile, tgNb,
     O                 tIlo, tIhi, tJlo, tJhi,
     O                 tiStride, tjStride,
     I                 myThid )

C !DESCRIPTION:
C     Return the index range & step of the part of the array (overlap-region)
C     which is going to be updated by the exchange with 1 neighbour.
C     Scalar field version (as opposed to 2-components vector field).
C     Note: presently only coded for grid-centered (mass point) scalar.
C           needs to extend it to grid-corner (vorticity point) scalar.

C !USES:
      IMPLICIT NONE

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

C $Header: /u/gcmpack/MITgcm/pkg/exch2/W2_EXCH2_SIZE.h,v 1.2 2010/10/13 20:56:00 jahn Exp $
C $Name: checkpoint64u $

CBOP
C    !ROUTINE: W2_EXCH2_SIZE.h
C    !INTERFACE:
C    include W2_EXCH2_SIZE.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | W2_EXCH2_SIZE.h
C     | Declare size of Wrapper2-Exch2 arrays
C     *==========================================================*
C     | Expected to be modified for unconventional configuration
C     | (e.g., many blank-tiles) or specific topology.
C     *==========================================================*
CEOP

C---   Size of Tiling topology structures
C  W2_maxNbFacets   :: Maximum number of Facets (also and formerly called
C                   :: "domains" or "sub-domains") of this topology.
C  W2_maxNeighbours :: Maximum number of neighbours any tile has.
C  W2_maxNbTiles    :: Maximum number of tiles (active+blank) in this topology
C  W2_ioBufferSize  :: Maximum size of Single-CPU IO buffer.
       INTEGER W2_maxNbFacets
       INTEGER W2_maxNeighbours
       INTEGER W2_maxNbTiles
       INTEGER W2_ioBufferSize
       INTEGER W2_maxXStackNx
       INTEGER W2_maxXStackNy
       INTEGER W2_maxYStackNx
       INTEGER W2_maxYStackNy

C---   Default values :
C      (suitable for 6-face Cube-Sphere topology, compact global I/O format)
C      W2_maxNbTiles = Nb of active tiles (=nSx*nSy*nPx*nPy) + Max_Nb_BlankTiles
C      default assume a large Max_Nb_BlankTiles equal to Nb of active tiles
C      resulting in doubling the tile number.
       PARAMETER ( W2_maxNbFacets = 10 )
       PARAMETER ( W2_maxNeighbours = 8 )
       PARAMETER ( W2_maxNbTiles = nSx*nSy*nPx*nPy*7 )
       PARAMETER ( W2_ioBufferSize = W2_maxNbTiles*sNx*sNy )
       PARAMETER ( W2_maxXStackNx = W2_maxNbTiles*sNx )
       PARAMETER ( W2_maxXStackNy = W2_maxNbTiles*sNy )
       PARAMETER ( W2_maxYStackNx = W2_maxNbTiles*sNx )
       PARAMETER ( W2_maxYStackNy = W2_maxNbTiles*sNy )

C- Note: Overestimating W2_maxNbFacets and, to less extent, W2_maxNeighbours
C        have no or very little effects on memory footprint.
C        overestimated W2_maxNbTiles does not have large effect, except
C        through ioBufferSize (if related to, as here).
C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: W2_EXCH2_TOPOLOGY.h
C     !INTERFACE:
C     #include W2_EXCH2_TOPOLOGY.h

C     !DESCRIPTION:
C     *==========================================================*
C     | W2_EXCH2_TOPOLOGY.h
C     | o Header defining tile exchange and mapping for W2_EXCH2
C     *==========================================================*
C     | 1rst part holds the full topology structure (same for all
C     |  process) and is independent of tile-processor repartition
C     |  (needs W2_EXCH2_SIZE.h to be included before)
C     | 2nd part (put in this header for convenience) holds
C     |   Tile Ids and is function of tile-process repartition
C     |  (needs SIZE.h to be included before)
C     *==========================================================*
CEOP

C---   Parameters for enumerating directions
       INTEGER W2_NORTH, W2_SOUTH, W2_EAST, W2_WEST
       PARAMETER ( W2_NORTH = 1 )
       PARAMETER ( W2_SOUTH = 2 )
       PARAMETER ( W2_EAST  = 3 )
       PARAMETER ( W2_WEST  = 4 )

C---   Topology data structures
C      exch2_global_Nx   :: Global-file domain length.
C      exch2_global_Ny   :: Global-file domain height.
C      exch2_xStack_Nx   :: Length of domain used for north/south OBCS.
C      exch2_xStack_Ny   :: Height of domain used for north/south OBCS.
C      exch2_yStack_Nx   :: Length of domain used for east/west OBCS.
C      exch2_yStack_Ny   :: Height of domain used for east/west OBCS.
C---   Tiling and Exch data structures
C      exch2_nTiles      :: Number of tiles in this topology
C      exch2_myFace      :: Face number for each tile (used for I/O).
C      exch2_mydNx       :: Face size in X for each tile (for I/O).
C      exch2_mydNy       :: Face size in Y for each tile (for I/O).
C      exch2_tNx         :: Size in X for each tile.
C      exch2_tNy         :: Size in Y for each tile.
C      exch2_tBasex      :: Tile offset in X within its sub-domain (cube face)
C      exch2_tBasey      :: Tile offset in Y within its sub-domain (cube face)
C      exch2_txGlobalo   :: Tile base X index within global index space.
C      exch2_tyGlobalo   :: Tile base Y index within global index space.
C      exch2_txXStackLo  :: Tile base X index within N/S OBCS index space.
C      exch2_tyXStackLo  :: Tile base Y index within N/S OBCS index space.
C      exch2_txYStackLo  :: Tile base X index within E/W OBCS index space.
C      exch2_tyYStackLo  :: Tile base Y index within E/W OBCS index space.
C      exch2_isWedge     :: 1 if West  is at domain edge, 0 if not.
C      exch2_isNedge     :: 1 if North is at domain edge, 0 if not.
C      exch2_isEedge     :: 1 if East  is at domain edge, 0 if not.
C      exch2_isSedge     :: 1 if South is at domain edge, 0 if not.
C      exch2_nNeighbours :: Tile neighbour entries count.
C      exch2_neighbourId :: Tile number for each neighbour entry.
C      exch2_opposingSend:: Neighbour entry in target tile send
C                        :: which has this tile and neighbour as its target.
C      exch2_pij(:,n,t)  :: Matrix which applies to target-tile indices to get
C                        :: source-tile "t" indices, for neighbour entry "n".
C      exch2_oi(n,t)     :: Source-tile "t" X index offset in target
C                        :: to source connection (neighbour entry "n").
C      exch2_oj(n,t)     :: Source-tile "t" Y index offset in target
C                        :: to source connection (neighbour entry "n").
       INTEGER exch2_global_Nx
       INTEGER exch2_global_Ny
       INTEGER exch2_xStack_Nx
       INTEGER exch2_xStack_Ny
       INTEGER exch2_yStack_Nx
       INTEGER exch2_yStack_Ny
       INTEGER exch2_nTiles
       INTEGER exch2_myFace( W2_maxNbTiles )
       INTEGER exch2_mydNx( W2_maxNbTiles )
       INTEGER exch2_mydNy( W2_maxNbTiles )
       INTEGER exch2_tNx( W2_maxNbTiles )
       INTEGER exch2_tNy( W2_maxNbTiles )
       INTEGER exch2_tBasex( W2_maxNbTiles )
       INTEGER exch2_tBasey( W2_maxNbTiles )
       INTEGER exch2_txGlobalo(W2_maxNbTiles )
       INTEGER exch2_tyGlobalo(W2_maxNbTiles )
       INTEGER exch2_txXStackLo(W2_maxNbTiles )
       INTEGER exch2_tyXStackLo(W2_maxNbTiles )
       INTEGER exch2_txYStackLo(W2_maxNbTiles )
       INTEGER exch2_tyYStackLo(W2_maxNbTiles )
       INTEGER exch2_isWedge( W2_maxNbTiles )
       INTEGER exch2_isNedge( W2_maxNbTiles )
       INTEGER exch2_isEedge( W2_maxNbTiles )
       INTEGER exch2_isSedge( W2_maxNbTiles )
       INTEGER exch2_nNeighbours( W2_maxNbTiles )
       INTEGER exch2_neighbourId(  W2_maxNeighbours, W2_maxNbTiles )
       INTEGER exch2_opposingSend( W2_maxNeighbours, W2_maxNbTiles )
       INTEGER exch2_neighbourDir( W2_maxNeighbours, W2_maxNbTiles )
       INTEGER exch2_pij(4,W2_maxNeighbours, W2_maxNbTiles )
       INTEGER exch2_oi (  W2_maxNeighbours, W2_maxNbTiles )
       INTEGER exch2_oj (  W2_maxNeighbours, W2_maxNbTiles )

       COMMON /W2_EXCH2_TOPO_I/
     &        exch2_global_Nx, exch2_global_Ny,
     &        exch2_xStack_Nx, exch2_xStack_Ny,
     &        exch2_yStack_Nx, exch2_yStack_Ny,
     &        exch2_nTiles,
     &        exch2_myFace, exch2_mydNx, exch2_mydNy,
     &        exch2_tNx, exch2_tNy,
     &        exch2_tBasex, exch2_tBasey,
     &        exch2_txGlobalo,exch2_tyGlobalo,
     &        exch2_txXStackLo,exch2_tyXStackLo,
     &        exch2_txYStackLo,exch2_tyYStackLo,
     &        exch2_isWedge, exch2_isNedge,
     &        exch2_isEedge, exch2_isSedge,
     &        exch2_nNeighbours, exch2_neighbourId,
     &        exch2_opposingSend, exch2_neighbourDir,
     &        exch2_pij,
     &        exch2_oi, exch2_oj

C---   Exchange execution loop data structures
C      exch2_iLo,iHi(n,t) :: X-index range of this tile "t" halo-region
C                         :: to be updated with neighbour entry "n".
C      exch2_jLo,jHi(n,t) :: Y-index range of this tile "t" halo-region
C                         :: to be updated with neighbour entry "n".
       INTEGER exch2_iLo( W2_maxNeighbours, W2_maxNbTiles )
       INTEGER exch2_iHi( W2_maxNeighbours, W2_maxNbTiles )
       INTEGER exch2_jLo( W2_maxNeighbours, W2_maxNbTiles )
       INTEGER exch2_jHi( W2_maxNeighbours, W2_maxNbTiles )
       COMMON /W2_EXCH2_HALO_SPEC/
     &        exch2_iLo, exch2_iHi,
     &        exch2_jLo, exch2_jHi

C---   Cumulated Sum operator
C      W2_tMC1, W2_tMC2 :: tile that holds Missing Corners (=f1.NW,f2.SE)
C      W2_cumSum_facet(1,f1,f2) :: cum-sum at facet f2 origin function of
C                                  facet f1 X-increment
C      W2_cumSum_facet(2,f1,f2) :: cum-sum at tile f2 origin function of
C                                  facet f1 Y-increment
C      W2_cumSum_tiles(1,t1,t2) :: cum-sum at tile t2 origin function of
C                                  tile t1 X-increment
C      W2_cumSum_tiles(2,t1,t2) :: cum-sum at tile t2 origin function of
C                                  tile t1 Y-increment
       INTEGER W2_tMC1, W2_tMC2
       INTEGER W2_cumSum_facet( 2, W2_maxNbFacets,W2_maxNbFacets)
       COMMON /W2_CUMSUM_TOPO_I/
     &        W2_tMC1, W2_tMC2,
     &        W2_cumSum_facet

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

C--   COMMON /W2_MAP_TILE2PROC/ mapping of tiles to process:
C     get W2 tile Id from process Id + subgrid indices (bi,bj) or the reverse
C     (tile ids are no longer a simple function of process and subgrid indices).
C
C     W2_tileProc(tN) :: Rank of process owning tile tN (filled at run time).
C     W2_tileIndex(tN):: local subgrid index of tile tN
C     W2_tileRank(tN) :: rank of tile tN in full-tile list (without blank)
C     W2_myTileList   :: list of tiles owned by this process
C     W2_procTileList :: same as W2_myTileList, but contains
C                        information for all processes
      INTEGER W2_tileProc ( W2_maxNbTiles )
      INTEGER W2_tileIndex( W2_maxNbTiles )
c     INTEGER W2_tileRank ( W2_maxNbTiles )
      INTEGER W2_myTileList ( nSx,nSy )
      INTEGER W2_procTileList(nSx,nSy,nPx*nPy )
      COMMON /W2_MAP_TILE2PROC/
     &        W2_tileProc,
     &        W2_tileIndex,
c    &        W2_tileRank,
     &        W2_myTileList, W2_procTileList

C--   COMMON /W2_EXCH2_COMMFLAG/ EXCH2 character Flag for type of communication
      CHARACTER W2_myCommFlag( W2_maxNeighbours, nSx, nSy )
      COMMON /W2_EXCH2_COMMFLAG/ W2_myCommFlag

C--   COMMON /EXCH2_FILLVAL_RX/ real type filling value used by EXCH2
C     e2FillValue_RX :: filling value for null regions (facet-corner
C                    :: halo regions)
      Real*8 e2FillValue_RL
      Real*8 e2FillValue_RS
      Real*4 e2FillValue_R4
      Real*8 e2FillValue_R8
      COMMON /EXCH2_FILLVAL_RL/ e2FillValue_RL
      COMMON /EXCH2_FILLVAL_RS/ e2FillValue_RS
      COMMON /EXCH2_FILLVAL_R4/ e2FillValue_R4
      COMMON /EXCH2_FILLVAL_R8/ e2FillValue_R8

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

C !INPUT/OUTPUT PARAMETERS:
C     fCode         :: field code (position on staggered grid)
C     eWdth         :: width of data region to exchange
C     updateCorners :: flag, do update corner halo region if true
C     tgTile        :: target tile
C     tgNb          :: target Neighbour entry
C     tIlo, tIhi    :: index range in I that will be filled in target array
C     tJlo, tJhi    :: index range in J that will be filled in target array
C     tiStride      :: index step  in I that will be filled in target array
C     tjStride      :: index step  in J that will be filled in target array
C     myThid        :: my Thread Id. number

      CHARACTER*2 fCode
      INTEGER     eWdth
      LOGICAL     updateCorners
      INTEGER     tgTile, tgNb
      INTEGER     tIlo, tIhi, tJlo, tJhi
      INTEGER     tiStride, tjStride
      INTEGER     myThid

C !LOCAL VARIABLES:
CEOP

C---  Initialise index range from Topology values:
      tIlo = exch2_iLo(tgNb,tgTile)
      tIhi = exch2_iHi(tgNb,tgTile)
      tJlo = exch2_jLo(tgNb,tgTile)
      tJhi = exch2_jHi(tgNb,tgTile)

C---  Expand index range according to exchange-Width "eWdth"
      IF ( tIlo .EQ. tIhi .AND. tIlo .EQ. 0 ) THEN
C      Filling a west edge overlap
       tIlo = 1-eWdth
       tiStride = 1
       IF ( tJlo .LE. tJhi ) THEN
        tjStride = 1
       ELSE
        tjStride =-1
       ENDIF
       IF ( updateCorners ) THEN
        tJlo = tJlo-tjStride*(eWdth-1)
        tJhi = tJhi+tjStride*(eWdth-1)
       ELSE
        tJlo = tJlo+tjStride
        tJhi = tJhi-tjStride
       ENDIF
      ENDIF
      IF ( tIlo .EQ. tIhi .AND. tIlo .GT. 1 ) THEN
C      Filling an east edge overlap
       tIhi = tIhi+eWdth-1
       tiStride = 1
       IF ( tJlo .LE. tJhi ) THEN
        tjStride = 1
       ELSE
        tjStride =-1
       ENDIF
       IF ( updateCorners ) THEN
        tJlo = tJlo-tjStride*(eWdth-1)
        tJhi = tJhi+tjStride*(eWdth-1)
       ELSE
        tJlo = tJlo+tjStride
        tJhi = tJhi-tjStride
       ENDIF
      ENDIF
      IF ( tJlo .EQ. tJhi .AND. tJlo .EQ. 0 ) THEN
C      Filling a south edge overlap
       tJlo = 1-eWdth
       tjStride = 1
       IF ( tIlo .LE. tIhi ) THEN
        tiStride = 1
       ELSE
        tiStride =-1
       ENDIF
       IF ( updateCorners ) THEN
        tIlo = tIlo-tiStride*(eWdth-1)
        tIhi = tIhi+tiStride*(eWdth-1)
       ELSE
        tIlo = tIlo+tiStride
        tIhi = tIhi-tiStride
       ENDIF
      ENDIF
      IF ( tJlo .EQ. tJhi .AND. tJlo .GT. 1 ) THEN
C      Filling a north edge overlap
       tJhi = tJhi+eWdth-1
       tjStride = 1
       IF ( tIlo .LE. tIhi ) THEN
        tiStride = 1
       ELSE
        tiStride =-1
       ENDIF
       IF ( updateCorners ) THEN
        tIlo = tIlo-tiStride*(eWdth-1)
        tIhi = tIhi+tiStride*(eWdth-1)
       ELSE
        tIlo = tIlo+tiStride
        tIhi = tIhi-tiStride
       ENDIF
      ENDIF

      RETURN
      END
