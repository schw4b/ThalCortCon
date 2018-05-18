clear

startRow = 2;
formatSpec      = '%*3s%41s%[^\n\r]';
fileID          = fopen('17Networks_ColorLUT_freeview.txt','r');
dataArray       = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines' ,2-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray{1}    = strtrim(dataArray{1});
fclose(fileID);
NetNamesList = [dataArray{1:end-1}];
clearvars filename startRow formatSpec fileID dataArray ans


for i = 1:114
    C = strsplit(NetNamesList{i},'_');
    NodeAss2Nets_LHRH{i} = [C{2} '_' C{3}]; 
    NodeAss2Nets{i} = [C{3}]; 
end

UniqueNetName = unique(NodeAss2Nets);

NodeAss2Nets_Idx = zeros(1,114);
for n = 1:numel(UniqueNetName)
     IDX_tmp = find(~cellfun(@isempty,strfind(NetNamesList,UniqueNetName{n})));
     NodeAss2Nets_Idx(IDX_tmp) = n;
end

% dlmwrite('NodeAssigments.txt',NodeAss2Nets_Idx,'delimiter','\n')
% dlmwrite('NetworkNames.txt',UniqueNetName,'delimiter','\n')

save('NodeAssigments.mat','NodeAss2Nets_Idx')
save('NetworkNames.mat','UniqueNetName')