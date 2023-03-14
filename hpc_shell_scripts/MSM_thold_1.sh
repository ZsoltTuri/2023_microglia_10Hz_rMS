#!/bin/bash 
########## Begin Slurm header ########## 
# Job name 
#SBATCH --job-name=MSM_thold_1
# Requested number of nodes 
#SBATCH --nodes=1
# Requested number of tasks 
#SBATCH --ntasks=1
# Requested number of task per node 
#SBATCH --ntasks-per-node=1
# Requested memory 
#SBATCH --mem=24gb 
# Estimated wallclock time for job 
#SBATCH --time=00:45:00
# Specify queue class 
#SBATCH --partition=single 
# Send mail when job begins, aborts and ends 
#SBATCH --mail-type=ALL 
# Define arrayjobs 
#SBATCH --array=1-35
########### End Slurm header ########## 
echo "Submit Directory: $SLURM_SUBMIT_DIR" 
echo "Working Directory: $PWD" 
echo "Running on host: $HOSTNAME" 
echo "Job id: $SLURM_JOB_ID" 
echo "Job name: $SLURM_JOB_NAME" 
echo "Number of nodes dedicated to the job: $SLURM_JOB_NUM_NODES" 
echo "Memory per node dedicated to the job: $SLURM_MEM_PER_NODE" 
echo "Total number of processes dedicated to the job: $SLURM_NPROCS" 
echo "The total number of tasks available for the job: $SLURM_NTASKS" 
echo "Number of requested tasks per node: $SLURM_NTASKS_PER_NODE" 
echo "Number of processes per node dedicated to the job: $SLURM_JOB_CPUS_PER_NODE" 
cd 2021_microglia_rMS/src 
ml math/matlab/R2020b 
matlab –nodesktop -nodisplay -nojvm -batch "hpc_MSM_syn_weight_1_input(${SLURM_ARRAY_TASK_ID})"
