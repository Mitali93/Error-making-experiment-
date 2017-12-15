function [AllResults, order, shuffled] = ShuffleWithRestrictions(trials)
try
    tnum = trials(:,1);
    tcor = (trials(:,7) == 0);
    twrong=(trials(:,7)~=0);
    
    
    ntrials = length(tnum);
    maxcorrect = 4;
    maxwrong=4;
    order = nan(ntrials,1);
    
    consecutiveCorrect = 0;
    consecutiveWrong=0;
    
    for i = 1 : ntrials
        
        % draw a sample from tnum
        if consecutiveCorrect == maxcorrect  
            tries = 0;
            while iscorrect == true  
                [Y,index] = Sample(tnum);
                iscorrect = tcor(index);   
                tries = tries + 1;
                if tries > 50 % time out at some point and try again
                    error('Trying again')
                end
            end
        elseif consecutiveWrong == maxwrong
            tries = 0;
            while iswrong == true
                [Y,index] = Sample(tnum);
                iswrong=twrong(index);
                tries = tries + 1;
                if tries > 50 % time out at some point and try again
                    error('Trying again')
                end
            end
                
        elseif consecutiveCorrect < maxcorrect && consecutiveWrong<maxwrong
            [Y,index] = Sample(tnum);
            iscorrect = tcor(index);
            iswrong= twrong(index);
            
        end
        
        if iscorrect == true
            consecutiveCorrect =  consecutiveCorrect + 1;
        else
            consecutiveCorrect = 0;
        end
        
        if iswrong == true
            consecutiveWrong= consecutiveWrong + 1;
        else
            consecutiveWrong = 0;
        end
        
        order(i,1) = Y;
        tnum(index,:) = [];
        tcor(index,:) = [];
        twrong(index,:)= [];
    end
    
    
    AllResults=trials(order,:);
    AllResults(:,9:10) = NaN;
    disp(AllResults)
    % now just check that everything is ok
    
    x = AllResults(:,7)';
    
    i = find(diff(x));
    n = [i numel(x)] - [0 i];
    c = arrayfun(@(X) X-1:-1:0, n , 'UniformOutput',false);
    y = cat(2,c{:});
    
    if((max(y) + 1) > maxcorrect)
        warning('oops, something is wrong with Lincoln''s code! I''l try again')
        shuffled = false;
    else
        shuffled = true;
    end
catch
    shuffled = false;
    AllResults = [];
    order = [];
end