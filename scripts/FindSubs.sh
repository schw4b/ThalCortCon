#SA, Ox, 2018
#srafyouni@gmail.com

while read filename
do
	echo ${filename}

	aws s3 ls s3://hcp-openaccess/HCP_1200/${filename}/MNINonLinear/Results/rfMRI_REST1_7T_PA/rfMRI_REST1_7T_PA_hp2000_clean.nii.gz

	if [ $? == 0 ] 
	then
		echo "${filename} exists..."
		echo ${filename} >> WithClean7TData.txt
	fi
		 
done < SubList_7T.sh
