#!/bin/bash 
cd  
rm *.out 
git stash 
git pull origin main 
dos2unix MSM_mod_gen.sh 
chmod +x MSM_mod_gen.sh 
dos2unix MSM_thold_1.sh 
chmod +x MSM_thold_1.sh 
dos2unix MSM_thold_10.sh 
chmod +x MSM_thold_10.sh 
dos2unix MSM_thold_10_rTMS.sh 
chmod +x MSM_thold_10_rTMS.sh 
dos2unix MSM_thold_merge.sh 
chmod +x MSM_thold_merge.sh 
dos2unix MSM_rMS.sh 
chmod +x MSM_rMS.sh 
dos2unix MSM_rMS_analysis.sh 
chmod +x MSM_rMS_analysis.sh 
cd sim_msm/Model_Generation/Jarsky_files/lib_mech 
nrnivmodl 
