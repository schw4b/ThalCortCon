#!/usr/bin/sh
#$ -S /usr/bin/bash
#$ -V
#$ -q veryshort.q
#$ -l h_vmem=8G
#$ -l h_rt=01:00:00
#$ -t 1:88
#$ -cwd
#$ -o $HOME/log
#$ -e $HOME/log

# environment not needed when -V is used 
# FSLDIR="/opt/fmrib/fsl"
# source ${FSLDIR}/etc/fslconf/fsl.sh

INFO="thalCortCon"
SEQ="rfMRI_REST1_7T_PA"
SEQ_=$(echo ${SEQ}| awk -F "_" '{ print $2 "_" $4 }')

PATH_FMRI="${HOME}/HCP_88Unrelated_7T"
PATH_PROJ="${HOME}/Data/ThalCortCon"
PATH_OUT="/storage/essicd/data/HCP/Soroosh/HCP_88Unrelated_7T/ts"

FILE_ATLAS1="${PATH_PROJ}/atlas/thalcort/r16mm_Thal07_Cort007.nii.gz"
FILE_ATLAS2="${PATH_PROJ}/atlas/thalcort/r16mm_Thal07_Cort016.nii.gz"
FILE_ATLAS3="${PATH_PROJ}/atlas/thalcort/r16mm_Thal07_Cort051.nii.gz"
FILE_ATLAS4="${PATH_PROJ}/atlas/thalcort/r16mm_Thal07_Cort114.nii.gz"

ATLAS1="Thal07_YEOCort007"
ATLAS2="Thal07_YEOCort016"
ATLAS3="Thal07_YEOCort051"
ATLAS4="Thal07_YEOCort114"

LOG="${PATH_PROJ}/log/${INFO}.log"

MYID=$(echo $(sed "${SGE_TASK_ID}q;d" ${PATH_PROJ}/results/subjects.txt))


FILE="${PATH_FMRI}/${MYID}_${SEQ_}/${MYID}/MNINonLinear/Results/${SEQ}/${SEQ}_hp2000_clean.nii.gz"

if [[ -e "${FILE}" ]] ; then
    command="fslmeants -i ${FILE} --label=${FILE_ATLAS1} -o ${PATH_OUT}/${MYID}_${SEQ_}_${ATLAS1}.txt"
    ${command}; echo $(date) ${command} >> $LOG
    
    command="fslmeants -i ${FILE} --label=${FILE_ATLAS2} -o ${PATH_OUT}/${MYID}_${SEQ_}_${ATLAS2}.txt"
    ${command}; echo $(date) ${command} >> $LOG

    command="fslmeants -i ${FILE} --label=${FILE_ATLAS3} -o ${PATH_OUT}/${MYID}_${SEQ_}_${ATLAS3}.txt"
    ${command}; echo $(date) ${command} >> $LOG

    command="fslmeants -i ${FILE} --label=${FILE_ATLAS4} -o ${PATH_OUT}/${MYID}_${SEQ_}_${ATLAS4}.txt"
    ${command}; echo $(date) ${command} >> $LOG
     
elif [[ ! -e "${FILE}" ]] ; then
    echo $(date) ERROR ${FILE} not found >> $LOG
fi
