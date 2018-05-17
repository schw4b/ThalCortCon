% by simon schwab, 2018

PATH = '~/Data/ThalCortCon/';

%% Split thalamus load mask into single binary 3D images
mask = load_nii([PATH 'thalamus/rCoreg_NN_Thalamus-maxprob-thr25-1mm.nii.gz']);

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


