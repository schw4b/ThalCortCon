%SA, Ox, 2018
%srafyouni@gmail.com

clear

load('/Users/sorooshafyouni/Home/7T/ThalCortCon/SubList7T.mat')
Tab = readtable('/Users/sorooshafyouni/Home/7T/ThalCortCon/RESTRICTED_sorafy_5_17_2018_4_32_26.csv');

Tab7T = Tab(find(ismember(Tab.Subject,SubList7T)),:);

%find non-twins

DZSubID = []; MZSubID = []; NTSubID = [];
DZpairs_M = []; DZpairs_F = [];
MZpairs_M = []; MZpairs_F = [];

for s = 1:numel(SubList7T) 
    
    sidx = find(ismember(Tab7T.Subject,SubList7T(s)));
    
    if strcmp(Tab7T.ZygositySR{s},'NotTwin')
        NTSubID = [SubList7T(s) ; NTSubID];
        
    elseif strcmp(Tab7T.ZygositySR{s},'NotMZ')
        DZSubID = [SubList7T(s) ; DZSubID];
        
        DZpairs_M_tmp = find(Tab7T.Mother_ID==Tab7T.Mother_ID(s));
        
        if numel(DZpairs_M_tmp)>2
            warning('shit!')
        elseif numel(DZpairs_M_tmp) == 1
            NTSubID = [SubList7T(s) ; NTSubID];
            continue;
            %DZpairs_M_tmp = [DZpairs_M_tmp;0];
        end
        
        DZpairs_M = [DZpairs_M_tmp(1:2) , DZpairs_M];

        clear *_tmp
    elseif strcmp(Tab7T.ZygositySR{s},'MZ')
        MZSubID = [SubList7T(s) ; MZSubID];
        
        MZpairs_M_tmp = find(Tab7T.Mother_ID==Tab7T.Mother_ID(s));
        
        if numel(MZpairs_M_tmp)>2
            warning('shit!')
        elseif numel(MZpairs_M_tmp) == 1
            NTSubID = [SubList7T(s) ; NTSubID];
            continue;
            %MZpairs_M_tmp = [MZpairs_M_tmp;0];
        end
        
        MZpairs_M = [MZpairs_M_tmp(1:2) , MZpairs_M];

        clear *_tmp
    else
        disp(['SubID ' num2str(s) ' ' num2str(SubList7T(s)) ' is not nottwin nor MZ nor DZ!!'])
    end
    
end

Tpairs = [MZpairs_M,DZpairs_M];
Tpairs_tmp = Tpairs;

AVOIDME = [];
f_cnt = 1;
for tp = 1:size(Tpairs,2)
  
    Idx_tmp = find(sum(ismember(Tpairs,Tpairs(:,tp))));
    
    if ismember(Idx_tmp,AVOIDME); continue; end;
    
    PAIRS(:,f_cnt) = SubList7T(Tpairs(:,Idx_tmp(1)));
    
    f_cnt = f_cnt + 1;
    AVOIDME = [Idx_tmp AVOIDME];
end

%PAIRS(:,~sum(PAIRS))=[];
dlmwrite('UnrelatedSubs7T_1stLeg.txt',PAIRS(1,:)','precision','%d')
%Do not share this!
%dlmwrite('UnrelatedSubs7T_2ndLeg.txt',PAIRS(2,:)','precision','%d')

PAIRS_L1 = PAIRS(1,:);


HCPFilt = []; 
for i = 1:length(PAIRS_L1)
    HCPFilt = [num2str(PAIRS_L1(i)) '|' HCPFilt];
end
dlmwrite('HCPFilt_UnrelatedSubs7T_1stLeg.txt',HCPFilt,'precision','%d','delimiter','')




