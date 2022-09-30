#!/bin/bash -l
#PBS -S /bin/bash
#PBS -N inf_coDB
#PBS -l walltime=00:30:00
#PBS -l select=2:ncpus=64:ngpus=4
#PBS -l filesystems=eagle:home
#PBS -k doe
#PBS -j oe
#PBS -A datascience
#PBS -q debug-scaling
#PBS -V

DRIVER=src/driver.py
MODULE=conda/2022-09-08
CONDA_ENV=/lus/eagle/projects/datascience/balin/test_build_SSIM_220908_clean_2/ssim

nodes=2
ppn=64 # CPU cores per node
simprocs=32
sim_ppn=16 # CPU cores per node assigned to sim
db_ppn=16 # CPU cores per node assigned to DB
device=gpu
logging="no"

echo number of nodes $nodes
echo number of sim processes $simprocs
echo number of sim processes per node $sim_ppn
echo number of db processes per node $db_ppn
echo CPU cores per node $ppn
echo conda environment $CONDA_ENV

# Set env
cd $PBS_O_WORKDIR
module load $MODULE
conda activate $CONDA_ENV
HOST_FILE=$(echo $PBS_NODEFILE)

# Run
echo python $DRIVER $nodes $ppn $simprocs $sim_ppn $db_ppn $device $logging $HOST_FILE
python $DRIVER $nodes $ppn $simprocs $sim_ppn $db_ppn $device $logging $HOST_FILE

# Handle output
if [ "$logging" = "verbose" ]; then
    mkdir $PBS_JOBID
    mv *.log $PBS_JOBID
fi
