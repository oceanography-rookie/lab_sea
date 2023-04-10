#include "AUTODIFF_OPTIONS.h"
#ifdef ALLOW_CTRL
# include "CTRL_OPTIONS.h"
#endif

CBOP
C     !ROUTINE: AUTODIFF_INIT_VARIA
C     !INTERFACE:
      SUBROUTINE AUTODIFF_INIT_VARIA( myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE AUTODIFF_INIT_VARIA
C     | o Initialise to zero some active arrays
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "FFIELDS.h"
#include "SURFACE.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     myThid :: My Thread Id number
      INTEGER myThid

#ifdef ALLOW_AUTODIFF
C     !LOCAL VARIABLES:
C     == Local variables ==
C     bi,bj  :: tile indices
C     i,j,k  :: Loop counters
      INTEGER bi, bj
#ifdef ALLOW_EP_FLUX
      INTEGER i, j, k
#endif
CEOP

C--   Scalar fields
      TsurfCor = 0. _d 0
      SsurfCor = 0. _d 0

C--   Over all tiles
      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)

C-      3D arrays
#ifdef ALLOW_EP_FLUX
        DO k=1,Nr
         DO j=1-OLy,sNy+OLy
          DO i=1-OLx,sNx+OLx
           EfluxY(i,j,k,bi,bj) = 0.
           EfluxP(i,j,k,bi,bj) = 0.
          ENDDO
         ENDDO
        ENDDO
#endif

       ENDDO
      ENDDO

#endif /* ALLOW_AUTODIFF */
      RETURN
      END
