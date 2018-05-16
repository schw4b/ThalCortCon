
#source /home/wmrnaq/.bashrc

AWS_ACCESS_KEY="BlahBlahBlah"
AWS_SECRET_KEY="BlahBlahBlah+BlahBlahBlah/BlahBlahBlah"

#_________________________________________________________________________________________________
#___________________________________Download form S3 Bucket_______________________________________
#_________________________________________________________________________________________________
function s3get {
        #helper functions_________________________________________________
        function fail { echo "$1" > /dev/stderr; exit 1; }

        if ! hash openssl 2>/dev/null; then fail "openssl not installed"; fi
        if ! hash curl 2>/dev/null; then fail "curl not installed"; fi

        #params_________________________________________________
        path="${1}"
        bucket=$(cut -d '/' -f 1 <<< "$path")
        key=$(cut -d '/' -f 2- <<< "$path")
        region="${2:-us-west-1}"

        #echo "Bucket: ${bucket}, Path: ${path}, Key: ${key}"

        #load creds_________________________________________________
        access="$AWS_ACCESS_KEY"
        secret="$AWS_SECRET_KEY"

        #validate_________________________________________________
        if [[ "$bucket" = "" ]]; then fail "missing bucket (arg 1)"; fi;
        if [[ "$key" = ""    ]]; then fail "missing key (arg 1)"; fi;
        if [[ "$region" = "" ]]; then fail "missing region (arg 2)"; fi;
        if [[ "$access" = "" ]]; then fail "missing AWS_ACCESS_KEY (env var)"; fi;
        if [[ "$secret" = "" ]]; then fail "missing AWS_SECRET_KEY (env var)"; fi;

        #compute signature_________________________________________________
        contentType="text/html; charset=UTF-8"
        date="`date -u +'%a, %d %b %Y %H:%M:%S GMT'`"
        resource="/${bucket}/${key}"
        string="GET\n\n${contentType}\n\nx-amz-date:${date}\n${resource}"
        signature=`echo -en $string | openssl sha1 -hmac "${secret}" -binary | base64`

        #get!_________________________________________________
        curl -H "x-amz-date: ${date}" \
		         -H "Content-Type: ${contentType}" \
             -H "Authorization: AWS ${access}:${signature}" \
		            "https://s3.amazonaws.com${resource}" \
	           -o "$2"

        #curl -H "x-amz-date: ${date}" \
        #-H "Content-Type: ${contentType}" \
        #-H "Authorization: AWS ${access}:${signature}" \
        #"https://s3-${region}.amazonaws.com${resource}"
        #-o "$2"
}
#_________________________________________________________________________________________________________________________

cd /storage/essicd/data/HCP/Soroosh/HCP_100Unrelated

SubID=$(sed "${SGE_TASK_ID}q;d" /home/wmrnaq/HCPMassDL/HCP_100UR.txt) #The text file is your sub list
echo "Sub: ${SubID}"

KSpaceDir=(LR RL) #later can be RL
RunS=1

for Dir in ${KSpaceDir[@]}; do #Loop around k-space LR RL directions
	mkdir -p "${SubID}_${Dir}/PHYSIO"
    	mkdir -p "${SubID}_${Dir}/rfMRI_REST${RunS}_${Dir}_hp2000.ica/filtered_func_data.ica"
    	mkdir -p "${SubID}_${Dir}/RestingStateStats"
    for filename in \ #Loop around what file you need to extract
      rfMRI_REST${RunS}_${Dir}.nii.gz \
      rfMRI_REST${RunS}_${Dir}_hp2000_clean.nii.gz \
      Movement_Regressors.txt \
      Movement_Regressors_dt.txt \
      brainmask_fs.2.nii.gz \
      RestingStateStats/rfMRI_REST${RunS}_${Dir}_Atlas_CleanedCSFtc.txt \
      RestingStateStats/rfMRI_REST${RunS}_${Dir}_Atlas_CleanedWMtc.txt \
      rfMRI_REST${RunS}_${Dir}_hp2000.ica/filtered_func_data.ica/melodic_IC.nii \
      rfMRI_REST${RunS}_${Dir}_hp2000.ica/filtered_func_data.ica/Noise.txt \
      rfMRI_REST${RunS}_${Dir}_hp2000.ica/filtered_func_data.ica/Signal.txt \
      ; do
         echo "------------------------------${filename}"
		  s3get hcp-openaccess/HCP_1200/${SubID}/MNINonLinear/Results/rfMRI_REST${RunS}_${Dir}/${filename} ${SubID}_${Dir}/${filename}
        done
    s3get hcp-openaccess/HCP_1200/${SubID}/unprocessed/3T/rfMRI_REST${RunS}_${Dir}/${SubID}_3T_rfMRI_REST${RunS}_${Dir}.nii.gz ${SubID}_${Dir}/${SubID}_3T_rfMRI_REST${RunS}_${Dir}.nii.gz
    s3get hcp-openaccess/HCP_1200/${SubID}/unprocessed/3T/rfMRI_REST${RunS}_${Dir}/LINKED_DATA/PHYSIO/${SubID}_3T_rfMRI_REST1_LR_Physio_log.txt ${SubID}_${Dir}/PHYSIO/${SubID}_3T_rfMRI_REST1_LR_Physio_log.txt
done
