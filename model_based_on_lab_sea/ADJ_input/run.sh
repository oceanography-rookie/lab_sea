#!/bin/tcsh

#SBATCH --job-name=run   # Specify job name
#SBATCH --partition=compute  # Specify partition name for job execution
#SBATCH --nodes=36
#SBATCH --ntasks-per-node=46
#SBATCH --time=08:00:00      # Set a limit on the total run time
#SBATCH --mail-type=FAIL       # Notify user by email in case of job failure
#SBATCH --account=uo0122     # Charge resources on this project account
#SBATCH --output=test.o%j    # Fitie name for standard output
#SBATCH --error=test.e%j     # File name for standard error output

limit stacksize unlimit
setenv OMPI_MCA_pml_ucx_opal_mem_hooks 1
setenv OMPI_MCA_osc "ucx"
setenv OMPI_MCA_pml "ucx"
setenv OMPI_MCA_btl "self"
setenv UCX_HANDLE_ERRORS "bt"


setenv I_MPI_PMI pmi
setenv I_MPI_PMI_LIBRARY /usr/lib64/libpmi.so

module load netcdf-c/4.8.1-openmpi-4.1.2-gcc-11.2.0
module load intel-oneapi-mpi/2021.5.0-intel-2021.5.0
module load netcdf-fortran/4.5.3-intel-oneapi-mpi-2021.5.0-intel-2021.5.0


set rundir=../ADJ_run_diva
set source=../ADJ_build
set ctrl=../ADJ_input

mkdir -p $rundir
rm -rf $rundir
mkdir -p $rundir
#mkdir -p $uo_rs
chmod -R 777 $rundir
cd $rundir
#ln -s $input/* .
cp $source/mitgcmuv_ad .
cp $ctrl/data* .
cp $ctrl/eedata .
cp $ctrl/my* .



############forward######
srun -n 1656 --hint=nomultithread ./mitgcmuv_ad
echo "fwd"
cp STDOUT.0000 STDOUT.0000.fwd
############diva adjoint####
srun -n 1656 --hint=nomultithread ./mitgcmuv_ad
echo " additional DIVA run # 1 : done"
echo "done1"
cp STDOUT.0000 STDOUT.0000.diva_1

srun -n 1656 --hint=nomultithread ./mitgcmuv_ad
echo " additional DIVA run # 2 : done"
echo "done2"
mv STDOUT.0000 STDOUT.0000.diva_2
cp divided.ctrl divided.ctrl_1_copy

srun -n 1656 --hint=nomultithread ./mitgcmuv_ad
echo " additional DIVA run # 3 : done"
echo "done3"
cp STDOUT.0000 STDOUT.0000.diva_3
cp divided.ctrl divided.ctrl_2_copy



