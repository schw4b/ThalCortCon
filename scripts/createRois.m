% by simon schwab, 2018

PATH = '~/Data/ThalCortCon/';

%% Split thalamus load mask into single binary 3D images
mask = load_nii([PATH 'atlas/thalamus/rCoreg_NN_Thalamus-maxprob-thr25-1mm.nii.gz']);

fid= fopen([PATH 'rois/labels_thalamus.txt']);
labels = textscan(fid, '%d %s');
fclose(fid);

dims = size(mask.img);
Nn = max(mask.img(:));
tmp=mask;
for n=1:Nn
    tmp.img = mask.img==n;
    save_nii(tmp, [PATH 'rois/thalamus/' labels{2}{n} '.nii'])
end


%% Prepare Yeo atlas
PATH_YEO = '~/Drive/yeo/Yeo_JNeurophysiol11_SplitLabels/MNI152/';
file = 'Yeo2011_17Networks_N1000.split_components.FSL_MNI152_FreeSurferConformed_1mm.nii';

yeo = load_nii([PATH_YEO file]);

load ([PATH 'atlas/yeo/scripts/17NetworksNodeAssigments.mat'])
Nn = length(NodeAss2Nets_Idx);
new = yeo.img;

for i=1:Nn
    new(yeo.img == i) = NodeAss2Nets_Idx(i);
end
yeo.img=new;

max(yeo.img(:))
save_nii(yeo, [PATH 'atlas/yeo/ass_' file])

% labels
load ([PATH 'atlas/yeo/scripts/17NetworksNetworkNames.mat'])
UniqueNetName


%% Prepare thalcort atlas
PATH_ATLAS = '~/Data/ThalCortCon/atlas/';

% Load atlas
nii_thal = load_nii([PATH_ATLAS 'thalamus/rCoreg_NN_Thalamus-maxprob-thr25-1mm.nii.gz']);
%nii_cort = load_nii([PATH_ATLAS 'yeo/r16mmCoregResliceNearestN_ass_Yeo2011_7Networks_N1000.split_components.FSL_MNI152_FreeSurferConformed_1mm.nii.gz']);
nii_cort = load_nii([PATH_ATLAS 'yeo/rCoregNNYeo2011_17Networks_N1000.split_components.FSL_MNI152_FreeSurferConformed_1mm.nii.gz']);
% increase labels
nr=max(nii_thal.img(:));
nii_cort.img(nii_cort.img==0) = NaN;
nii_cort.img = nii_cort.img + single(nr);
nii_cort.img(isnan(nii_cort.img)) = 0;

%min(nii_cort.img(:))
%max(nii_cort.img(:))

% merge the two atlases
new=nii_cort;
new.img = uint8(nii_cort.img) + nii_thal.img;

min(new.img(:))
max(new.img(:))

save_nii(new, [PATH_ATLAS 'thalcort/r16mm_Thal07_Cort114.nii'])

%% sanity check
nii = load_nii([PATH_ATLAS 'thalcort/r16mm_Thal07_Cort114.nii']);
length(unique(nii.img(:)))-1
