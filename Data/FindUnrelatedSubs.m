
clear

load('SubList7T.mat')
Tab = readtable('RESTRICTED_sorafy_5_17_2018_4_32_26.csv');

%find non-twins

DZSubID = []; MZSubID = []; NTSubID = [];
DZpairs_M = []; DZpairs_F = [];
MZpairs_M = []; MZpairs_F = [];

for s = 1:numel(SubList7T) 
    
    sidx = find(ismember(Tab.Subject,SubList7T(s)));
    
    if strcmp(Tab.ZygositySR{sidx},'NotTwin')
        NTSubID = [SubList7T(s) ; NTSubID];
    elseif strcmp(Tab.ZygositySR{sidx},'NotMZ')
        DZSubID = [SubList7T(s) ; DZSubID];
        
        DZpairs_M_tmp = find(Tab.Mother_ID==Tab.Mother_ID(sidx));
        DZpairs_M = [DZpairs_M_tmp(1:2) , DZpairs_M];
        
        DZpairs_F_tmp = find(Tab.Father_ID==Tab.Father_ID(sidx));
        DZpairs_F = [DZpairs_F_tmp(1:2) , DZpairs_F];
        
        clear *_tmp
    elseif strcmp(Tab.ZygositySR{sidx},'MZ')
        MZSubID = [SubList7T(s) ; MZSubID];
        
        MZpairs_M_tmp = find(Tab.Mother_ID==Tab.Mother_ID(sidx));
        
        if numel(MZpairs_M_tmp)>2
            warning('shit!')
        elseif numel(MZpairs_M_tmp) == 1
            MZpairs_M_tmp = [MZpairs_M_tmp;0];
        end
        
        MZpairs_M = [MZpairs_M_tmp(1:2) , MZpairs_M];
        
        MZpairs_F_tmp = find(Tab.Father_ID==Tab.Father_ID(sidx));
        
        if numel(MZpairs_F_tmp)>2
            disp([num2str(s) ' shit!'])
        elseif numel(MZpairs_F_tmp) == 1
            MZpairs_F_tmp = [MZpairs_F_tmp;0];
        end
        
        
        MZpairs_F = [MZpairs_F_tmp(1:2) , MZpairs_F];
        
        clear *_tmp
    else
        disp(['SubID ' num2str(sidx) ' ' num2str(SubList7T(s)) ' is not nottwin nor MZ nor DZ!!'])
        %Tab(s,:)
    end
    
end

Tpairs = [MZpairs_M,DZpairs_M];
Tpairs_tmp = Tpairs;

for tp = 1:size(Tpairs,2)
    
    if sum(isnan(Tpairs_tmp(:,tp)))>0 
       disp('oops!'); 
       continue; 
    end 
    
    PAIRS_tmp = find(sum(ismember(Tpairs_tmp,Tpairs_tmp(:,tp))));
    
    if numel(PAIRS_tmp)<2
        TwinWithMissingPair(tp) = PAIRS_tmp; continue; 
    end
    
    PAIRS(:,tp) = SubList7T(PAIRS_tmp);
    
    Tpairs_tmp(:,PAIRS_tmp) = [NaN,NaN;NaN,NaN];
end

PAIRS(:,~sum(PAIRS))=[];

dlmwrite('UnrelatedSubs7T_1stLeg.txt',PAIRS(1,:)','precision','%d')
dlmwrite('UnrelatedSubs7T_2ndLeg.txt',PAIRS(2,:)','precision','%d')


