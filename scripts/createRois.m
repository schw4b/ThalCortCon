% by simon schwab

PATH = '~/Data/ThalCortCon/';

%% load mask and fMRI
mask = load_nii([PATH 'atlas/rCoreg_NN_Thalamus-maxprob-thr25-1mm.nii.gz']);
nii = load_nii([PATH 'nii/vol001_rfMRI_REST1_7T_PA_hp2000_clean.nii.gz']);

assert(sum(size(mask.img) == size(nii.img)) == 3, 'dimension mismatch')

%% Plot single slice
figure;

x=50;

subplot(1,2,1)
imagesc(nii.img(:,:,x))
subplot(1,2,2)
imagesc(mask.img(:,:,x))

