#include "MNC_OPTIONS.h"

C--  File mnc_cw_readwrite.template: template for routines to Read/Write
C                               "RL" type variables from/to NetCDF file.
C--   Contents
C--   o MNC_CW_RL_W_S
C--   o MNC_CW_RL_W
C--   o MNC_CW_RL_W_OFFSET
C--   o MNC_CW_RL_R_S
C--   o MNC_CW_RL_R
C--   o MNC_CW_RL_R_TF

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C !ROUTINE: MNC_CW_RL_W_S

C !INTERFACE:
      SUBROUTINE MNC_CW_RL_W_S(
     I     stype,
     I     fbname, bi,bj,
     I     vtype,
     I     var,
     I     myThid )

C     !DESCRIPTION:
C     A scalar version of MNC_CW_RL_W() for compilers that cannot
C     gracefully handle the conversion on their own.

C     !USES:
      implicit none

C     !INPUT PARAMETERS:
      integer myThid, bi,bj
      character*(*) stype, fbname, vtype
      _RL var
      _RL var_arr(1)
CEOP

      var_arr(1) = var
      CALL MNC_CW_RL_W(stype,fbname,bi,bj,vtype, var_arr, myThid)

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C !ROUTINE: MNC_CW_RL_W

C !INTERFACE:
      SUBROUTINE MNC_CW_RL_W(
     I     stype,
     I     fbname, bi,bj,
     I     vtype,
     I     var,
     I     myThid )

C     !DESCRIPTION:
C     A scalar version of MNC_CW_RL_W() for compilers that cannot
C     gracefully handle the conversion on their own.

C     !USES:
      implicit none

C     !INPUT PARAMETERS:
      integer myThid, bi,bj
      character*(*) stype, fbname, vtype
      _RL var(*)
      INTEGER offsets(9)
CEOP
      INTEGER i

      DO i = 1,9
        offsets(i) = 0
      ENDDO
      CALL MNC_CW_RL_W_OFFSET(stype,fbname,bi,bj,vtype, var,
     &     offsets, myThid)

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C !ROUTINE: MNC_CW_RL_W_OFFSET

C !INTERFACE:
      SUBROUTINE MNC_CW_RL_W_OFFSET(
     I     stype,
     I     fbname, bi,bj,
     I     vtype,
     I     var,
     I     offsets,
     I     myThid )

C     !DESCRIPTION:
C     This subroutine writes one variable to a file or a file group,
C     depending upon the tile indicies.

C     !USES:
      implicit none
#include "netcdf.inc"
#include "MNC_COMMON.h"
#include "SIZE.h"
#include "MNC_BUFF.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "MNC_PARAMS.h"

C     !INPUT PARAMETERS:
      integer myThid, bi,bj
      character*(*) stype, fbname, vtype
      _RL var(*)
      INTEGER offsets(*)
CEOP

C     !LOCAL VARIABLES:
      integer i,j,k, indv,nvf,nvl, n1,n2, igrid, indu
      integer bis,bie, bjs,bje, uniq_tnum, nfname, iseq
      integer fid, idv, indvids, ndim, indf, err, nf
      integer lbi,lbj, bidim,bjdim, unlim_sz, kr
      integer p(9),s(9),e(9), dimnc(9)
      integer vstart(9),vcount(9), udo(9)
      integer j1,j2,j3,j4,j5,j6,j7, k1,k2,k3,k4,k5,k6,k7
      integer indfg, fg1,fg2, npath
      character*(MAX_LEN_MBUF) msgbuf
      character*(MNC_MAX_PATH) fname
      character*(MNC_MAX_PATH) path_fname
      character*(MNC_MAX_PATH) tmpnm
      character*(MNC_MAX_PATH) bpath
      REAL*8  dval, dvm(2)
      REAL*4  rval, rvm(2)
      INTEGER ival, ivm(2), irv
      REAL*8  resh_d( MNC_MAX_BUFF )
      REAL*4  resh_r( MNC_MAX_BUFF )
      INTEGER resh_i( MNC_MAX_BUFF )
      LOGICAL write_attributes, use_missing
#ifdef MNC_WRITE_OLDNAMES
      integer ntot
#endif
#ifdef HAVE_STAT
      integer ntotenc, ncenc, nbytes, fs_isdone
      character*(200) cenc
      integer ienc(200)
      REAL*8  fsnu
#endif

C     Functions
      integer IFNBLNK, ILNBLNK

C     Only do I/O if I am the master thread
      _BEGIN_MASTER( myThid )

      DO i = 1,MNC_MAX_PATH
        bpath(i:i) = ' '
      ENDDO

C     Get the current index for the unlimited dimension from the file
C     group (or base) name
      fg1 = IFNBLNK(fbname)
      fg2 = ILNBLNK(fbname)
      CALL MNC_GET_IND(MNC_MAX_ID, fbname, mnc_cw_fgnm, indfg, myThid)
      IF (indfg .LT. 1) THEN
        write(msgbuf,'(3a)')
     &       'MNC_CW_RL_W ERROR: file group name ''',
     &       fbname(fg1:fg2), ''' is not defined'
        CALL print_error(msgbuf, mythid)
        STOP 'ABNORMAL END: S/R MNC_CW_RL_W'
      ENDIF
      indu = mnc_cw_fgud(indfg)
      iseq = mnc_cw_fgis(indfg)
C     write(*,*) 'indu,iseq = ', indu, iseq

C     Check that the Variable Type exists
      nvf = IFNBLNK(vtype)
      nvl = ILNBLNK(vtype)
      CALL MNC_GET_IND(MNC_MAX_ID, vtype, mnc_cw_vname, indv, myThid)
      IF (indv .LT. 1) THEN
        write(msgbuf,'(3a)') 'MNC_CW_RL_W ERROR: vtype ''',
     &       vtype(nvf:nvl), ''' is not defined'
        CALL print_error(msgbuf, mythid)
        STOP 'ABNORMAL END: S/R MNC_CW_RL_W'
      ENDIF
      igrid = mnc_cw_vgind(indv)

C     Set the bi,bj indicies
      bis = bi
      bie = bi
      IF (bi .LT. 1) THEN
        bis = 1
        bie = nSx
      ENDIF
      bjs = bj
      bje = bj
      IF (bj .LT. 1) THEN
        bjs = 1
        bje = nSy
      ENDIF

      DO lbj = bjs,bje
        DO lbi = bis,bie

#ifdef HAVE_STAT
          fs_isdone = 0
#endif
 10       CONTINUE

C         Create the file name
          CALL MNC_CW_GET_TILE_NUM(lbi,lbj, uniq_tnum, myThid)
          fname(1:MNC_MAX_PATH) = bpath(1:MNC_MAX_PATH)
          n1 = IFNBLNK(fbname)
          n2 = ILNBLNK(fbname)

#ifdef MNC_WRITE_OLDNAMES

          ntot = n2 - n1 + 1
          fname(1:ntot) = fbname(n1:n2)
          ntot = ntot + 1
          fname(ntot:ntot) = '.'
          IF ( mnc_use_name_ni0 ) THEN
            write(fname((ntot+1):(ntot+17)),'(i10.10,a1,i6.6)')
     &           nIter0,'.',uniq_tnum
            write(fname((ntot+18):(ntot+25)),'(a1,i4.4,a3)')
     &           '.', iseq, '.nc'
            nfname = ntot + 25
          ELSE
            write(fname((ntot+1):(ntot+14)),'(i4.4,a1,i6.6,a3)')
     &           iseq,'.',uniq_tnum, '.nc'
            nfname = ntot + 14
          ENDIF

#else

          CALL MNC_PSNCM(tmpnm, uniq_tnum, MNC_DEF_TMNC)
          k = ILNBLNK(tmpnm)
          IF ( mnc_cw_cit(1,mnc_cw_fgci(indfg)) .GT. -1 ) THEN
            j = mnc_cw_cit(2,mnc_cw_fgci(indfg))
            IF ( mnc_cw_fgis(indfg) .GT. j )
     &           j = mnc_cw_fgis(indfg)
            write(fname,'(a,a1,i10.10,a2,a,a3)') fbname(n1:n2),
     &           '.', j, '.t', tmpnm(1:k), '.nc'
          ELSEIF ( mnc_cw_cit(1,mnc_cw_fgci(indfg)) .EQ. -1 ) THEN
C           Leave off the myIter value entirely
            write(fname,'(a,a2,a,a3)') fbname(n1:n2), '.t',
     &           tmpnm(1:k),'.nc'
          ELSE
C           We have an error--bad flag value
            write(msgbuf,'(4a)')
     &           'MNC_CW_RL_W ERROR: bad mnc_cw_cit(1,...) ',
     &           'flag value for base name ''', fbname(fg1:fg2),
     &           ''''
            CALL print_error(msgbuf, mythid)
            STOP 'ABNORMAL END: S/R MNC_CW_RL_W'
          ENDIF
          nfname = ILNBLNK(fname)

#endif

C         Add the path to the file name
          IF (mnc_use_outdir) THEN
            path_fname(1:MNC_MAX_PATH) = bpath(1:MNC_MAX_PATH)
            npath = ILNBLNK(mnc_out_path)
            path_fname(1:npath) = mnc_out_path(1:npath)
            path_fname((npath+1):(npath+nfname)) = fname(1:nfname)
            fname(1:MNC_MAX_PATH) = path_fname(1:MNC_MAX_PATH)
            nfname = npath + nfname
          ENDIF

C         Append to an existing or create a new file
          CALL MNC_CW_FILE_AORC(fname,indf, lbi,lbj,uniq_tnum, myThid)
          fid = mnc_f_info(indf,2)

#ifdef HAVE_STAT
          IF ((mnc_cw_fgig(indfg) .EQ. 1)
     &         .AND. (fs_isdone .EQ. 0)) THEN
C           Decide whether to append to the existing or create a new
C           file based on the byte count per unlimited dimension
            ncenc = 70
            cenc(1:26)  = 'abcdefghijklmnopqrstuvwxyz'
            cenc(27:52) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
            cenc(53:70) = '0123456789_.,+-=/~'
            k = nfname
            IF (k .GT. 200)  k = 200
            ntotenc = 0
            DO i = 1,k
              DO j = 1,ncenc
                IF (fname(i:i) .EQ. cenc(j:j)) THEN
                  ntotenc = ntotenc + 1
                  ienc(ntotenc) = j
                  GOTO 20
                ENDIF
              ENDDO
 20           CONTINUE
            ENDDO
            CALL mncfsize(ntotenc, ienc, nbytes)
            IF (nbytes .GT. 0) THEN
              CALL MNC_DIM_UNLIM_SIZE(fname, unlim_sz, myThid)
              fsnu = (1.0 _d 0 + 1.0 _d 0 / DBLE(unlim_sz))
     &             * DBLE(nbytes)
              IF (fsnu .GT. mnc_max_fsize) THEN
C               Delete the now-full fname from the lookup tables since
C               we are all done writing to it.
                CALL MNC_FILE_CLOSE(fname, myThid)
                indu = 1
                mnc_cw_fgud(indfg) = 1

#ifdef MNC_WRITE_OLDNAMES
                iseq = iseq + 1
                mnc_cw_fgis(indfg) = iseq
#else
                IF (mnc_cw_cit(1,mnc_cw_fgci(indfg)) .LT. 0) THEN
                  write(msgbuf,'(5a)')
     &            'MNC_CW_RL_W ERROR: output file for base name ''',
     &            fbname(fg1:fg2), ''' is about to exceed the max ',
     &            'file size and is NOT ALLOWED an iteration value ',
     &            'within its file name'
                  CALL print_error(msgbuf, mythid)
                  STOP 'ABNORMAL END: S/R MNC_CW_RL_W'
                ELSEIF (mnc_cw_cit(3,mnc_cw_fgci(indfg)) .LT. 0) THEN
                  write(msgbuf,'(5a)')
     &            'MNC_CW_RL_W ERROR: output file for base name ''',
     &            fbname(fg1:fg2), ''' is about to exceed the max ',
     &            'file size and no next-iter has been specified--',
     &            'please see the MNC CITER functions'
                  CALL print_error(msgbuf, mythid)
                  STOP 'ABNORMAL END: S/R MNC_CW_RL_W'
                ENDIF
                mnc_cw_fgis(indfg) = mnc_cw_cit(3,mnc_cw_fgci(indfg))
C               DO NOT BUMP THE CURRENT ITER FOR ALL FILES IN THIS CITER
C               GROUP SINCE THIS IS ONLY GROWTH TO AVOID FILE SIZE
C               LIMITS FOR THIS ONE BASENAME GROUP, NOT GROWTH OF THE
C               ENTIRE CITER GROUP !!!
C               mnc_cw_cit(2,mnc_cw_fgci(indfg))
C               &   = mnc_cw_cit(3,mnc_cw_fgci(indfg))
C               mnc_cw_cit(3,mnc_cw_fgci(indfg)) = -1
#endif
                fs_isdone = 1
                GOTO 10

              ENDIF
            ENDIF
          ENDIF
#endif  /*  HAVE_STAT  */

C         Ensure that all the NetCDF dimensions are defined and create a
C         local copy of them
          DO i = 1,9
            dimnc(i) = 1
          ENDDO
          DO i = 1,mnc_cw_ndim(igrid)
            IF (mnc_cw_dims(i,igrid) .EQ. -1) THEN
              dimnc(i) = -1
            ELSE
              dimnc(i) = mnc_cw_ie(i,igrid) - mnc_cw_is(i,igrid) + 1
            ENDIF

C           Add the coordinate variables
            CALL MNC_DIM_INIT_ALL_CV(fname,
     &           mnc_cw_dn(i,igrid), dimnc(i), 'Y', lbi,lbj, myThid)

          ENDDO

C         Ensure that the "grid" is defined
          CALL MNC_GRID_INIT(fname, mnc_cw_gname(igrid),
     &        mnc_cw_ndim(igrid), mnc_cw_dn(1,igrid), myThid)

C         Ensure that the variable is defined
          irv = 0
          IF (stype(1:1) .EQ. 'D')
     &         CALL MNC_VAR_INIT_DBL(
     &         fname, mnc_cw_gname(igrid), vtype, irv, myThid)
          IF (stype(1:1) .EQ. 'R')
     &         CALL MNC_VAR_INIT_REAL(
     &         fname, mnc_cw_gname(igrid), vtype, irv, myThid)
          IF (stype(1:1) .EQ. 'I')
     &         CALL MNC_VAR_INIT_INT(
     &         fname, mnc_cw_gname(igrid), vtype, irv, myThid)

          IF (irv .GT. 0) THEN
C           Return value indicates that the variable did not previously
C           exist in this file, so we need to write all the attributes
            write_attributes = .TRUE.
          ELSE
            write_attributes = .FALSE.
          ENDIF

          DO i = 1,mnc_fv_ids(indf,1)
            j = 2 + 3*(i - 1)
            IF (mnc_v_names(mnc_fv_ids(indf,j)) .EQ. vtype) THEN
              idv = mnc_fv_ids(indf,j+1)
              indvids = mnc_fd_ind(indf, mnc_f_info(indf,
     &             (mnc_fv_ids(indf,j+2) + 1)) )
              GOTO 30
            ENDIF
          ENDDO
          write(msgbuf,'(4a)') 'MNC_MNC_CW_RL_W ERROR: ',
     &         'cannot reference variable ''', vtype, ''''
          CALL print_error(msgbuf, mythid)
          STOP 'ABNORMAL END: package MNC'
 30       CONTINUE

C         Check for bi,bj indicies
          bidim = mnc_cw_vbij(1,indv)
          bjdim = mnc_cw_vbij(2,indv)
CEH3      write(*,*) 'bidim,bjdim = ', bidim,bjdim

C         Set the dimensions for the in-memory array
          ndim = mnc_cw_ndim(igrid)
          k = mnc_cw_dims(1,igrid)
          IF (k .GT. 0) THEN
            p(1) = k
          ELSE
            p(1) = 1
          ENDIF
          DO i = 2,9
            k = mnc_cw_dims(i,igrid)
            IF (k .LT. 1) THEN
              k = 1
            ENDIF
            IF ((bidim .GT. 0) .AND. (i .EQ. bidim)) THEN
              p(i) = nSx * p(i-1)
            ELSEIF ((bjdim .GT. 0) .AND. (i .EQ. bjdim)) THEN
              p(i) = nSy * p(i-1)
            ELSE
              p(i) = k * p(i-1)
            ENDIF
            IF (offsets(i) .GT. 0) THEN
              k = 1
              p(i) = k * p(i-1)
            ENDIF
          ENDDO

C         Set starting and ending indicies for the in-memory array and
C         the unlimited dimension offset for the NetCDF array
          DO i = 1,9
            udo(i) = 0
            s(i) = 1
            e(i) = 1
            IF (i .LE. ndim) THEN
              s(i) = mnc_cw_is(i,igrid)
              e(i) = mnc_cw_ie(i,igrid)
            ENDIF
C           Check for the unlimited dimension
            IF ((i .EQ. ndim)
     &           .AND. (mnc_cw_dims(i,igrid) .EQ. -1)) THEN
              IF (indu .GT. 0) THEN
C               Use the indu value
                udo(i) = indu - 1
              ELSEIF (indu .EQ. -1) THEN
C               Append one to the current unlimited dim size
                CALL MNC_DIM_UNLIM_SIZE( fname, unlim_sz, myThid)
                udo(i) = unlim_sz
              ELSE
C               Use the current unlimited dim size
                CALL MNC_DIM_UNLIM_SIZE( fname, unlim_sz, myThid)
                udo(i) = unlim_sz - 1
              ENDIF
            ENDIF
          ENDDO
          IF (bidim .GT. 0) THEN
            s(bidim) = lbi
            e(bidim) = lbi
          ENDIF
          IF (bjdim .GT. 0) THEN
            s(bjdim) = lbj
            e(bjdim) = lbj
          ENDIF

C         Check the offsets
          DO i = 1,9
            IF (offsets(i) .GT. 0) THEN
              udo(i) = udo(i) + offsets(i) - 1
              s(i) = 1
              e(i) = 1
            ENDIF
          ENDDO

          IF (write_attributes) THEN
C           Add the per-variable attributes
            DO i = 1,mnc_cw_vnat(1,indv)
              CALL MNC_VAR_ADD_ATTR_STR( fname, vtype,
     &             mnc_cw_vtnm(i,indv), mnc_cw_vtat(i,indv), myThid)
            ENDDO
            DO i = 1,mnc_cw_vnat(2,indv)
              CALL MNC_VAR_ADD_ATTR_INT( fname, vtype,
     &             mnc_cw_vinm(i,indv), 1, mnc_cw_viat(i,indv), myThid)
            ENDDO
            DO i = 1,mnc_cw_vnat(3,indv)
              CALL MNC_VAR_ADD_ATTR_DBL( fname, vtype,
     &             mnc_cw_vdnm(i,indv), 1, mnc_cw_vdat(i,indv), myThid)
            ENDDO
          ENDIF

C         Handle missing values
          use_missing = .FALSE.
          IF (mnc_cw_vfmv(indv) .EQ. 0) THEN
            use_missing = .FALSE.
          ELSE
            IF (mnc_cw_vfmv(indv) .EQ. 1) THEN
              use_missing = .TRUE.
              dvm(1)  = mnc_def_dmv(1)
              dvm(2)  = mnc_def_dmv(2)
              rvm(1)  = mnc_def_rmv(1)
              rvm(2)  = mnc_def_rmv(2)
              ivm(1)  = mnc_def_imv(1)
              ivm(2)  = mnc_def_imv(2)
            ELSEIF (mnc_cw_vfmv(indv) .EQ. 2) THEN
              use_missing = .TRUE.
              dvm(1)  = mnc_cw_vmvd(1,indv)
              dvm(2)  = mnc_cw_vmvd(2,indv)
              rvm(1)  = mnc_cw_vmvr(1,indv)
              rvm(2)  = mnc_cw_vmvr(2,indv)
              ivm(1)  = mnc_cw_vmvi(1,indv)
              ivm(2)  = mnc_cw_vmvi(2,indv)
            ENDIF
          ENDIF
          IF (write_attributes .AND. use_missing) THEN
            write(msgbuf,'(4a)') 'writing attribute ''missing_value''',
     &           ' within file ''', fname(1:nfname), ''''
            IF (stype(1:1) .EQ. 'D') THEN
              err = NF_PUT_ATT_DOUBLE(fid, idv, 'missing_value',
     &             NF_DOUBLE, 1, dvm(2))
            ELSEIF (stype(1:1) .EQ. 'R') THEN
              err = NF_PUT_ATT_REAL(fid, idv, 'missing_value',
     &             NF_FLOAT, 1, rvm(2))
            ELSEIF (stype(1:1) .EQ. 'I') THEN
              err = NF_PUT_ATT_INT(fid, idv, 'missing_value',
     &             NF_INT, 1, ivm(2))
            ENDIF
            CALL MNC_HANDLE_ERR(err, msgbuf, myThid)
CMLC     it may be better to use the attribute _FillValue, or both
CML            write(msgbuf,'(4a)') 'writing attribute ''_FillValue''',
CML     &           ' within file ''', fname(1:nfname), ''''
CML            IF (stype(1:1) .EQ. 'D') THEN
CML              err = NF_PUT_ATT_DOUBLE(fid, idv, '_FillValue',
CML     &             NF_DOUBLE, 1, dvm(2))
CML            ELSEIF (stype(1:1) .EQ. 'R') THEN
CML              err = NF_PUT_ATT_REAL(fid, idv, '_FillValue',
CML     &             NF_FLOAT, 1, rvm(2))
CML            ELSEIF (stype(1:1) .EQ. 'I') THEN
CML              err = NF_PUT_ATT_INT(fid, idv, '_FillValue',
CML     &             NF_INT, 1, ivm(2))
CML            ENDIF
CML            CALL MNC_HANDLE_ERR(err, msgbuf, myThid)
          ENDIF

          CALL MNC_FILE_ENDDEF(fname, myThid)

          write(msgbuf,'(5a)') 'writing variable type ''',
     &         vtype(nvf:nvl), ''' within file ''',
     &         fname(1:nfname), ''''

C         DO i = 1,9
C         write(*,*) 'i,p(i),s(i),e(i),udo(i),offsets(i) = ',
C         &        i,p(i),s(i),e(i),udo(i),offsets(i)
C         ENDDO

C         Write the variable one vector at a time
          DO j7 = s(7),e(7)
            k7 = (j7 - 1)*p(6)
            vstart(7) = udo(7) + j7 - s(7) + 1
            vcount(7) = 1
            DO j6 = s(6),e(6)
              k6 = (j6 - 1)*p(5) + k7
              vstart(6) = udo(6) + j6 - s(6) + 1
              vcount(6) = 1
              DO j5 = s(5),e(5)
                k5 = (j5 - 1)*p(4) + k6
                vstart(5) = udo(5) + j5 - s(5) + 1
                vcount(5) = 1
                DO j4 = s(4),e(4)
                  k4 = (j4 - 1)*p(3) + k5
                  vstart(4) = udo(4) + j4 - s(4) + 1
                  vcount(4) = 1
                  DO j3 = s(3),e(3)
                    k3 = (j3 - 1)*p(2) + k4
                    vstart(3) = udo(3) + j3 - s(3) + 1
                    vcount(3) = 1
                    DO j2 = s(2),e(2)
                      k2 = (j2 - 1)*p(1) + k3
                      vstart(2) = udo(2) + j2 - s(2) + 1
                      vcount(2) = 1

      kr = 0
      vstart(1) = udo(1) + 1
      vcount(1) = e(1) - s(1) + 1

      IF (vcount(1) .GT. MNC_MAX_BUFF) THEN
        write(msgbuf,'(2a,I7,a)') 'MNC_MAX_BUFF is too small',
     &       '--please increase to at least ',
     &       vcount(1), ' in ''MNC_BUFF.h'''
        CALL PRINT_ERROR(msgBuf , 1)
        STOP 'ABNORMAL END: S/R MNC_CW_RL_W_OFFSET'
      ENDIF

      IF (use_missing) THEN

        IF (stype(1:1) .EQ. 'D') THEN
          DO j1 = s(1),e(1)
            k1 = k2 + j1
            kr = kr + 1
            dval = var(k1)
            IF (dval .EQ. dvm(1)) THEN
              resh_d(kr) = dvm(2)
            ELSE
              resh_d(kr) = dval
            ENDIF
          ENDDO
          err = NF_PUT_VARA_DOUBLE(fid, idv, vstart, vcount, resh_d)
        ELSEIF (stype(1:1) .EQ. 'R') THEN
          DO j1 = s(1),e(1)
            k1 = k2 + j1
            kr = kr + 1
            rval = var(k1)
            IF (rval .EQ. rvm(1)) THEN
              resh_r(kr) = rvm(2)
            ELSE
              resh_r(kr) = rval
            ENDIF
          ENDDO
          err = NF_PUT_VARA_REAL(fid, idv, vstart, vcount, resh_r)
        ELSEIF (stype(1:1) .EQ. 'I') THEN
          DO j1 = s(1),e(1)
            k1 = k2 + j1
            kr = kr + 1
            ival = NINT( var(k1) )
            IF (ival .EQ. ivm(1)) THEN
              resh_i(kr) = ivm(2)
            ELSE
              resh_i(kr) = ival
            ENDIF
          ENDDO
          err = NF_PUT_VARA_INT(fid, idv, vstart, vcount, resh_i)
        ENDIF

      ELSE

        IF (stype(1:1) .EQ. 'D') THEN
          DO j1 = s(1),e(1)
            k1 = k2 + j1
            kr = kr + 1
            resh_d(kr) = var(k1)
          ENDDO
          err = NF_PUT_VARA_DOUBLE(fid, idv, vstart, vcount, resh_d)
        ELSEIF (stype(1:1) .EQ. 'R') THEN
          DO j1 = s(1),e(1)
            k1 = k2 + j1
            kr = kr + 1
            resh_r(kr) = var(k1)
          ENDDO
          err = NF_PUT_VARA_REAL(fid, idv, vstart, vcount, resh_r)
        ELSEIF (stype(1:1) .EQ. 'I') THEN
          DO j1 = s(1),e(1)
            k1 = k2 + j1
            kr = kr + 1
            resh_i(kr) = NINT( var(k1) )
          ENDDO
          err = NF_PUT_VARA_INT(fid, idv, vstart, vcount, resh_i)
        ENDIF

      ENDIF
      CALL MNC_HANDLE_ERR(err, msgbuf, myThid)

                    ENDDO
                  ENDDO
                ENDDO
              ENDDO
            ENDDO
          ENDDO

C         Sync the file
          err = NF_SYNC(fid)
          nf = ILNBLNK( fname )
          write(msgbuf,'(3a)') 'sync for file ''', fname(1:nf),
     &         ''' in S/R MNC_CW_RL_W'
          CALL MNC_HANDLE_ERR(err, msgbuf, myThid)

        ENDDO
      ENDDO

      _END_MASTER( myThid )

      RETURN
      END


C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C !ROUTINE: MNC_CW_RL_R_S

C !INTERFACE:
      SUBROUTINE MNC_CW_RL_R_S(
     I     stype,
     I     fbname, bi,bj,
     I     vtype,
     I     var,
     I     myThid )

C     !DESCRIPTION:
C     A scalar version of MNC_CW_RL_R() for compilers that cannot
C     gracefully handle the conversion on their own.

C     !USES:
      implicit none

C     !INPUT PARAMETERS:
      integer myThid, bi,bj
      character*(*) stype, fbname, vtype
      _RL var
      _RL var_arr(1)
CEOP
      var_arr(1) = var

      CALL MNC_CW_RL_R(stype,fbname,bi,bj,vtype, var_arr, myThid)

      RETURN
      END


C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C !ROUTINE: MNC_CW_RL_R

C !INTERFACE:
      SUBROUTINE MNC_CW_RL_R(
     I     stype,
     I     fbname, bi,bj,
     I     vtype,
     I     var,
     I     myThid )

C     !DESCRIPTION:
C     A simple wrapper for the old version of this routine.  The new
C     version includes the isvar argument which, for backwards
C     compatibility, is set to false here.

C     !USES:
      implicit none

C     !INPUT PARAMETERS:
      integer myThid, bi,bj
      character*(*) stype, fbname, vtype
      _RL var(*)
CEOP

C     !LOCAL VARIABLES:
      LOGICAL isvar

      isvar = .FALSE.

      CALL MNC_CW_RL_R_TF(stype,fbname,bi,bj,vtype,var,isvar,myThid)

      RETURN
      END


C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C !ROUTINE: MNC_CW_RL_R

C !INTERFACE:
      SUBROUTINE MNC_CW_RL_R_TF(
     I     stype,
     I     fbname, bi,bj,
     I     vtype,
     I     var,
     B     isvar,
     I     myThid )

C     !DESCRIPTION:
C     This subroutine reads one variable from a file or a file group,
C     depending upon the tile indicies.  If isvar is true and the
C     variable does not exist, then isvar is set to false and the
C     program continues normally.  This allows one to gracefully handle
C     the case of reading variables that might or might not exist.

C     !USES:
      implicit none
#include "netcdf.inc"
#include "MNC_COMMON.h"
#include "SIZE.h"
#include "MNC_BUFF.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "MNC_PARAMS.h"

C     !INPUT PARAMETERS:
      integer myThid, bi,bj
      character*(*) stype, fbname, vtype
      _RL var(*)
      LOGICAL isvar
CEOP

C     !LOCAL VARIABLES:
      integer i,k, nvf,nvl, n1,n2, igrid, ntot, indu
      integer bis,bie, bjs,bje, uniq_tnum,uniq_fnum, nfname, fid, idv
      integer ndim, err, lbi,lbj, bidim,bjdim, unlim_sz, kr
      integer ind_vt, npath, unlid, f_or_t, ixoff,iyoff
C     integer f_sNx,f_sNy, alen, atype, ind_fv_ids, ierr, indf
      integer p(9),s(9),e(9), vstart(9),vcount(9), udo(9)
      integer j1,j2,j3,j4,j5,j6,j7, k1,k2,k3,k4,k5,k6,k7
      character*(MAX_LEN_MBUF) msgbuf
      character*(MNC_MAX_PATH) fname
      character*(MNC_MAX_PATH) tmpnm
      character*(MNC_MAX_PATH) path_fname
      character*(MNC_MAX_PATH) bpath
      integer indfg, fg1,fg2
      REAL*8  resh_d( MNC_MAX_BUFF )
      REAL*4  resh_r( MNC_MAX_BUFF )
      INTEGER resh_i( MNC_MAX_BUFF )
#ifdef MNC_READ_OLDNAMES
      character*(MNC_MAX_PATH) fname_zs
#endif

C     Functions
      integer IFNBLNK, ILNBLNK

C     Only do I/O if I am the master thread
      _BEGIN_MASTER( myThid )

      DO i = 1,MNC_MAX_PATH
        bpath(i:i) = ' '
      ENDDO

C     Get the current index for the unlimited dimension from the file
C     group (or base) name
      fg1 = IFNBLNK(fbname)
      fg2 = ILNBLNK(fbname)
      CALL MNC_GET_IND(MNC_MAX_ID, fbname, mnc_cw_fgnm, indfg, myThid)
      IF (indfg .LT. 1) THEN
        write(msgbuf,'(3a)')
     &       'MNC_CW_RL_W ERROR: file group name ''',
     &       fbname(fg1:fg2), ''' is not defined'
        CALL print_error(msgbuf, mythid)
        STOP 'ABNORMAL END: S/R MNC_CW_RL_W'
      ENDIF
      indu = mnc_cw_fgud(indfg)

C     Check that the Variable Type exists
      nvf = IFNBLNK(vtype)
      nvl = ILNBLNK(vtype)
      CALL MNC_GET_IND( MNC_MAX_ID, vtype, mnc_cw_vname, ind_vt, myThid)
      IF (ind_vt .LT. 1) THEN
        write(msgbuf,'(3a)') 'MNC_CW_RL_R ERROR: vtype ''',
     &       vtype(nvf:nvl), ''' is not defined'
        CALL print_error(msgbuf, mythid)
        STOP 'ABNORMAL END: S/R MNC_CW_RL_R'
      ENDIF
      igrid = mnc_cw_vgind(ind_vt)

C     Check for bi,bj indicies
      bidim = mnc_cw_vbij(1,ind_vt)
      bjdim = mnc_cw_vbij(2,ind_vt)

C     Set the bi,bj indicies
      bis = bi
      bie = bi
      IF (bi .LT. 1) THEN
        bis = 1
        bie = nSx
      ENDIF
      bjs = bj
      bje = bj
      IF (bj .LT. 1) THEN
        bjs = 1
        bje = nSy
      ENDIF

      DO lbj = bjs,bje
        DO lbi = bis,bie

C         Create the file name
          CALL MNC_CW_GET_TILE_NUM( lbi,lbj, uniq_tnum, myThid)
          fname(1:MNC_MAX_PATH) = bpath(1:MNC_MAX_PATH)

#ifdef MNC_READ_OLDNAMES

          n1 = IFNBLNK(fbname)
          n2 = ILNBLNK(fbname)
          ntot = n2 - n1 + 1
          fname(1:ntot) = fbname(n1:n2)
          ntot = ntot + 1
          fname(ntot:ntot) = '.'
          write(fname((ntot+1):(ntot+9)),'(i6.6,a3)') uniq_tnum, '.nc'
          nfname = ntot+9

C         Add the path to the file name
          IF (mnc_use_indir) THEN
            path_fname(1:MNC_MAX_PATH) = bpath(1:MNC_MAX_PATH)
            npath = ILNBLNK(mnc_indir_str)
            path_fname(1:npath) = mnc_indir_str(1:npath)
            path_fname((npath+1):(npath+nfname)) = fname(1:nfname)
            fname(1:MNC_MAX_PATH) = path_fname(1:MNC_MAX_PATH)
            nfname = npath + nfname
          ENDIF

          WRITE(fname_zs,'(2a,i4.4,a1,i6.6,a3)')
     &         mnc_indir_str(1:npath), fbname(n1:n2),
     &         0, '.', uniq_tnum, '.nc'

C         The steps are:
C         (1) open the file in a READ-ONLY mode,
C         (2) get the var id for the current variable,
C         (3) read the data, and then
C         (4) close the file--theres no need to keep it open!

          write(msgbuf,'(4a)') 'MNC_CW_RL_R: cannot open',
     &         ' file ''', fname(1:nfname), ''' in read-only mode'
          err = NF_OPEN(fname, NF_NOWRITE, fid)
          IF ( err .NE. NF_NOERR ) THEN
C           If the initial open fails, try again using a name with a
C           zero sequence number inserted
            err = NF_OPEN(fname_zs, NF_NOWRITE, fid)
          ENDIF
          CALL MNC_HANDLE_ERR(err, msgbuf, myThid)

          write(msgbuf,'(5a)')
     &         'MNC_CW_RL_R: cannot get id for variable ''',
     &         vtype(nvf:nvl), '''in file ''', fname(1:nfname), ''''
          err = NF_INQ_VARID(fid, vtype, idv)
          IF ( isvar .AND. ( err .NE. NF_NOERR ) ) THEN
            isvar = .FALSE.
            RETURN
          ENDIF
          isvar = .TRUE.
          CALL MNC_HANDLE_ERR(err, msgbuf, myThid)
          f_or_t = 0

#else

C         The sequence for PER-FACE and PER-TILE is:
C         (1) check whether a PER-FACE file exists
C         .   (a) if only one face is used for the entire domain,
C         .       then omit the face index from the file name
C         .   (b) if the PER-FACE file exists and is somehow faulty,
C         .       then we die with an error message
C         (2) if no PER-FACE file exists, then use a PER-TILE file

C         Create the PER-FACE file name
          n1 = IFNBLNK(fbname)
          n2 = ILNBLNK(fbname)
C         Add an iteraton count to the file name if its requested
          IF (mnc_cw_cit(1,mnc_cw_fgci(indfg)) .LT. 0) THEN
            WRITE(fname,'(a,a1)') fbname(n1:n2), '.'
          ELSE
            WRITE(fname,'(a,a1,i10.10,a1)') fbname(n1:n2), '.',
     &            mnc_cw_cit(2,mnc_cw_fgci(indfg)), '.'
          ENDIF
          ntot = ILNBLNK(fname)
          path_fname(1:MNC_MAX_PATH) = bpath(1:MNC_MAX_PATH)
          npath = ILNBLNK(mnc_indir_str)
C         Add the face index
          CALL MNC_CW_GET_FACE_NUM( lbi,lbj, uniq_fnum, myThid)
          IF ( uniq_fnum .EQ. -1 ) THEN
C           There is only one face
            WRITE(path_fname,'(2a,a2)')
     &           mnc_indir_str(1:npath), fname(1:ntot), 'nc'
          ELSE
            CALL MNC_PSNCM(tmpnm, uniq_fnum, MNC_DEF_FMNC)
            k = ILNBLNK(tmpnm)
            WRITE(path_fname,'(2a,a1,a,a3)')
     &           mnc_indir_str(1:npath), fname(1:ntot), 'f',
     &           tmpnm(1:k), '.nc'
          ENDIF

C         Try to open the PER-FACE file
C         WRITE(*,*) 'trying: "', path_fname, '"'
          err = NF_OPEN(path_fname, NF_NOWRITE, fid)
          IF ( err .EQ. NF_NOERR ) THEN
            f_or_t = 1
          ELSE

C           Create the PER-TILE file name
            CALL MNC_PSNCM(tmpnm, uniq_tnum, MNC_DEF_TMNC)
            k = ILNBLNK(tmpnm)
            path_fname(1:MNC_MAX_PATH) = bpath(1:MNC_MAX_PATH)
            WRITE(path_fname,'(2a,a1,a,a3)')
     &           mnc_indir_str(1:npath), fname(1:ntot), 't',
     &           tmpnm(1:k), '.nc'
C           WRITE(*,*) 'trying: "', path_fname, '"'
            err = NF_OPEN(path_fname, NF_NOWRITE, fid)
            IF ( err .EQ. NF_NOERR ) THEN
              f_or_t = 0
            ELSE
              k = ILNBLNK(path_fname)
              write(msgbuf,'(4a)')
     &             'MNC_CW_RL_R: cannot open either a per-face or a ',
     &             'per-tile file: last try was ''', path_fname(1:k),
     &             ''''
              CALL print_error(msgbuf, mythid)
              STOP 'ABNORMAL END: S/R MNC_CW_RL_W'
            ENDIF

          ENDIF

          ntot = ILNBLNK(path_fname)
          write(msgbuf,'(5a)')
     &         'MNC_CW_RL_R: cannot get netCDF id for variable ''',
     &         vtype(nvf:nvl), ''' in file ''', path_fname(1:ntot),
     &         ''''
          err = NF_INQ_VARID(fid, vtype, idv)
          IF ( isvar .AND. ( err .NE. NF_NOERR ) ) THEN
            isvar = .FALSE.
            RETURN
          ENDIF
          isvar = .TRUE.
          CALL MNC_HANDLE_ERR(err, msgbuf, myThid)

          k = ILNBLNK(path_fname)
          fname(1:k) = path_fname(1:k)
          nfname = k

#endif

          IF ( f_or_t .EQ. 1 ) THEN

C           write(msgbuf,'(2a)')
C           &           'MNC_CW_RL_R: per-face reads are not yet ',
C           &           'implemented -- so pester Ed to finish them'
C           CALL print_error(msgbuf, mythid)
C           STOP 'ABNORMAL END: S/R MNC_CW_RL_W'

C           Get the X,Y PER-FACE offsets
            CALL MNC_CW_GET_XYFO(lbi,lbj, ixoff,iyoff, myThid)

          ENDIF

C         WRITE(*,*) 'f_or_t = ',f_or_t

C         Check that the current sNy,sNy values and the in-file values
C         are compatible and WARN (only warn) if not
C           f_sNx = -1
C           f_sNy = -1
C           err = NF_INQ_ATT(fid,NF_GLOBAL, 'sNx',atype,alen)
C           IF ((err .EQ. NF_NOERR) .AND. (alen .EQ. 1)) THEN
C             err = NF_GET_ATT_INT(fid, NF_GLOBAL, 'sNx', f_sNx)
C             CALL MNC_HANDLE_ERR(err,
C      &           'reading attribute ''sNx'' in S/R MNC_CW_RL_R',
C      &           myThid)
C           ENDIF
C           err = NF_INQ_ATT(fid,NF_GLOBAL, 'sNy',atype,alen)
C           IF ((err .EQ. NF_NOERR) .AND. (alen .EQ. 1)) THEN
C             err = NF_GET_ATT_INT(fid, NF_GLOBAL, 'sNy', f_sNy)
C             CALL MNC_HANDLE_ERR(err,
C      &           'reading attribute ''sNy'' in S/R MNC_CW_RL_R',
C      &           myThid)
C           ENDIF
C           IF ((f_sNx .NE. sNx) .OR. (f_sNy .NE. sNy)) THEN
C             write(msgbuf,'(5a)') 'MNC_CW_RL_R WARNING: the ',
C      &           'attributes ''sNx'' and ''sNy'' within the file ''',
C      &           fname(1:nfname), ''' do not exist or do not match ',
C      &           'the current sizes within the model'
C             CALL print_error(msgbuf, mythid)
C           ENDIF

C         Check that the in-memory variable and the in-file variables
C         are of compatible sizes
C           ires = 1
C           CALL MNC_CHK_VTYP_R_NCVAR( ind_vt,
C      &         indf, ind_fv_ids, indu, ires)
C           IF (ires .LT. 0) THEN
C             write(msgbuf,'(7a)') 'MNC_CW_RL_R WARNING: the sizes ',
C      &           'of the in-program variable ''', vtype(nvf:nvl),
C      &           ''' and the corresponding variable within file ''',
C      &           fname(1:nfname), ''' are not compatible -- please ',
C      &           'check the sizes'
C             CALL print_error(msgbuf, mythid)
C             STOP 'ABNORMAL END: S/R MNC_CW_RL_R'
C           ENDIF

C         Check for bi,bj indicies
          bidim = mnc_cw_vbij(1,ind_vt)
          bjdim = mnc_cw_vbij(2,ind_vt)

C         Set the dimensions for the in-memory array
          ndim = mnc_cw_ndim(igrid)
          k = mnc_cw_dims(1,igrid)
          IF (k .GT. 0) THEN
            p(1) = k
          ELSE
            p(1) = 1
          ENDIF
          DO i = 2,9
            k = mnc_cw_dims(i,igrid)
            IF (k .LT. 1) THEN
              k = 1
            ENDIF
            IF ((bidim .GT. 0) .AND. (i .EQ. bidim)) THEN
              p(i) = nSx * p(i-1)
            ELSEIF ((bjdim .GT. 0) .AND. (i .EQ. bjdim)) THEN
              p(i) = nSy * p(i-1)
            ELSE
              p(i) = k * p(i-1)
            ENDIF
          ENDDO

C         Set starting and ending indicies for the in-memory array and
C         the unlimited dimension offset for the NetCDF array
          DO i = 1,9
            udo(i) = 0
            s(i) = 1
            e(i) = 1
            IF (i .LE. ndim) THEN
              s(i) = mnc_cw_is(i,igrid)
              e(i) = mnc_cw_ie(i,igrid)

              IF ( f_or_t .EQ. 1 ) THEN
C               Add the per-face X,Y offsets to the udo offset vector
C               since they accomplish the same thing
                IF ( mnc_cw_dn(i,igrid)(1:1) .EQ. 'X' ) THEN
                  udo(i) = ixoff - 1
                ELSEIF ( mnc_cw_dn(i,igrid)(1:1) .EQ. 'Y' ) THEN
                  udo(i) = iyoff - 1
                ENDIF
              ENDIF

            ENDIF
C           Check for the unlimited dimension
            IF ((i .EQ. ndim)
     &           .AND. (mnc_cw_dims(i,igrid) .EQ. -1)) THEN
              IF (indu .GT. 0) THEN
C               Use the indu value
                udo(i) = indu - 1
              ELSE
C               We need the current unlim dim size
                write(msgbuf,'(5a)') 'MNC_CW_RL_R: getting the ',
     &               'unlim dim id within file ''',
     &               fname(1:nfname), ''''
                err = NF_INQ_UNLIMDIM(fid, unlid)
                CALL MNC_HANDLE_ERR(err, msgbuf, myThid)
                write(msgbuf,'(5a)') 'MNC_CW_RL_R: getting the ',
     &               'unlim dim size within file ''',
     &               fname(1:nfname), ''''
                err = NF_INQ_DIMLEN(fid, unlid, unlim_sz)
                CALL MNC_HANDLE_ERR(err, msgbuf, myThid)
                udo(i) = unlim_sz
              ENDIF
            ENDIF
          ENDDO
          IF (bidim .GT. 0) THEN
            s(bidim) = lbi
            e(bidim) = lbi
          ENDIF
          IF (bjdim .GT. 0) THEN
            s(bjdim) = lbj
            e(bjdim) = lbj
          ENDIF

C     DO i = 9,1,-1
C     write(*,*) 'i,p(i),s(i),e(i) = ', i,': ',p(i),s(i),e(i)
C     ENDDO

          write(msgbuf,'(5a)') 'reading variable type ''',
     &         vtype(nvf:nvl), ''' within file ''',
     &         fname(1:nfname), ''''

C         Read the variable one vector at a time
          DO j7 = s(7),e(7)
            k7 = (j7 - 1)*p(6)
            vstart(7) = udo(7) + j7 - s(7) + 1
            vcount(7) = 1
            DO j6 = s(6),e(6)
              k6 = (j6 - 1)*p(5) + k7
              vstart(6) = udo(6) + j6 - s(6) + 1
              vcount(6) = 1
              DO j5 = s(5),e(5)
                k5 = (j5 - 1)*p(4) + k6
                vstart(5) = udo(5) + j5 - s(5) + 1
                vcount(5) = 1
                DO j4 = s(4),e(4)
                  k4 = (j4 - 1)*p(3) + k5
                  vstart(4) = udo(4) + j4 - s(4) + 1
                  vcount(4) = 1
                  DO j3 = s(3),e(3)
                    k3 = (j3 - 1)*p(2) + k4
                    vstart(3) = udo(3) + j3 - s(3) + 1
                    vcount(3) = 1
                    DO j2 = s(2),e(2)
                      k2 = (j2 - 1)*p(1) + k3
                      vstart(2) = udo(2) + j2 - s(2) + 1
                      vcount(2) = 1

      kr = 0
      vstart(1) = udo(1) + 1
      vcount(1) = e(1) - s(1) + 1

      IF (vcount(1) .GT. MNC_MAX_BUFF) THEN
        write(msgbuf,'(2a,I7,a)') 'MNC_MAX_BUFF is too small',
     &       '--please increase to at least ',
     &       vcount(1), ' in ''MNC_BUFF.h'''
        CALL PRINT_ERROR(msgBuf , 1)
        STOP 'ABNORMAL END: S/R MNC_CW_RL_R_OFFSET'
      ENDIF

      IF (stype(1:1) .EQ. 'D') THEN
        err = NF_GET_VARA_DOUBLE(fid, idv, vstart, vcount, resh_d)
        CALL MNC_HANDLE_ERR(err, msgbuf, myThid)
        DO j1 = s(1),e(1)
          k1 = k2 + j1
          kr = kr + 1
          var(k1) = ( resh_d(kr) )
        ENDDO
      ENDIF
      IF (stype(1:1) .EQ. 'R') THEN
        err = NF_GET_VARA_REAL(fid, idv, vstart, vcount, resh_r)
        CALL MNC_HANDLE_ERR(err, msgbuf, myThid)
        DO j1 = s(1),e(1)
          k1 = k2 + j1
          kr = kr + 1
          var(k1) = ( resh_r(kr) )
        ENDDO
      ENDIF
      IF (stype(1:1) .EQ. 'I') THEN
        err = NF_GET_VARA_INT(fid, idv, vstart, vcount, resh_i)
        CALL MNC_HANDLE_ERR(err, msgbuf, myThid)
        DO j1 = s(1),e(1)
          k1 = k2 + j1
          kr = kr + 1
          var(k1) = resh_i(kr)
        ENDDO
      ENDIF


                    ENDDO
                  ENDDO
                ENDDO
              ENDDO
            ENDDO
          ENDDO

C         Close the file
C         CALL MNC_FILE_CLOSE(fname, myThid)
          err = NF_CLOSE(fid)
          write(msgbuf,'(3a)') 'MNC_CW_RL_R:  cannot close file ''',
     &         fname(1:nfname), ''''
          CALL MNC_HANDLE_ERR(err, msgbuf, myThid)


C         End the lbj,lbi loops
        ENDDO
      ENDDO

      _END_MASTER( myThid )

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
