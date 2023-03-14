#!/bin/bash 
cd  
rm *.out 
git stash 
git pull origin main 
dos2unix EFM.sh 
chmod +x EFM.sh 
sbatch  ./EFM.sh 
