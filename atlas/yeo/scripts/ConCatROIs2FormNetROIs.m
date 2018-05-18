clear

WhichNet = '7Networks';

load(['/Users/sorooshafyouni/Home/GitClone/ThalCortCon/atlas/yeo/scripts/' WhichNet 'NodeAssigments.mat'],'NodeAss2Nets_Idx')
load(['/Users/sorooshafyouni/Home/GitClone/ThalCortCon/atlas/yeo/scripts/' WhichNet 'NetworkNames.mat'],'UniqueNetName')


ImgObj = load_untouch_nii(['/Users/sorooshafyouni/Home/GitClone/ThalCortCon/atlas/yeo/rCoregNNYeo2011_' WhichNet '_N1000.split_components.FSL_MNI152_FreeSurferConformed_1mm.nii.gz']);

ROIimg = ImgObj.img;

size_simg=size(ROIimg); 
size_simg=size_simg(1:3);
nROIs=max(ROIimg(:));

Netimg = zeros(size_simg);

for rx=1:length(UniqueNetName)
    
    disp(['Doing: ' UniqueNetName{rx}])
    
    Idx_tmp = find(NodeAss2Nets_Idx == rx);
    
    [xx,yy,zz]=ind2sub(size(ROIimg),find(ismember(ROIimg,Idx_tmp)));
    nvox_r=size([xx,yy,zz],1);
    
    cnt_v=1; corr_num=0; roi_ts=[];
    for vx=1:length(xx)
        Netimg(xx(vx),yy(vx),zz(vx)) = rx;
    end
end

%just a sanity check!
max(Netimg(:))

ImgObj.img = Netimg;
ImgObj

save_untouch_nii(ImgObj,['NetworkBasedAtlases/rCoregNNYeo2011_' WhichNet '_RSNs_N1000.split_components.FSL_MNI152_FreeSurferConformed_1mm.nii.gz'])

