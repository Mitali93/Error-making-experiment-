%%plotting types of errors made

for i=1:length(AllResults)
     
        %column 6 values: 0 means correct answer was displayed. any other
        %number here means that the wrong answer was displayed by adding this number to the correct answer.  
     if AllResults(i,6)==0 && AllResults(i,8)==buttonCorr{1,1};
         AllResults(i,9)=1; %hit
     elseif AllResults(i,6)==0 && AllResults(i,8)==buttonWrong{1,1};
          AllResults(i,9)=2;%Miss
     elseif AllResults(i,6)~=0 && AllResults(i,8)==buttonWrong{1,1};
         AllResults(i,9)=3;%Correct Reject
     elseif AllResults(i,6)~=0 && AllResults(i,8)==buttonCorr{1,1};
          AllResults(i,9)=4;%False Alarm
     elseif AllResults(i,8)==0
         AllResults(i,9)=5%No Response
       
     end
end
         y = accumarray(AllResults(:,9),1) %count occurances of each number
                                            %implies counting how many of
                                            %hits(=1),miss(=2) etc..
         
         figure(1)
         subplot(2,1,1)
         
         X=[1 2 3 4 5];
         Y=y';
         plot(X,Y,'o')
         xticks([1 2 3 4 5]);
         xticklabels({'Hit','Miss','Correcr Reject','False Alarm','No Response'});
         subplot(2,1,2)
         pie(y) % pie chart of types of responses
         
           title('Classification of Responses')
         labels={'Hit','Miss','Correcr Reject','False Alarm','No Response'};
     legend(labels,'Location','southoutside','Orientation','horizontal');
%% box plot of RTs
RTplot=nan(length(AllResults),4);

for i=1:length(AllResults)
    if AllResults(i,9)==1; 
        RTplot(i,1)=AllResults(i,7); %hit RTs
        
    elseif AllResults(i,9)==2
        RTplot(i,2)=AllResults(i,7); %miss Rts
        
    elseif AllResults(i,9)==3
        RTplot(i,3)=AllResults(i,7); %Correct reject Rts
    
    elseif AllResults(i,9)==4
        RTplot(i,4)=AllResults(i,7); %False Alarm Rts
    end
end
figure(2)
boxplot(RTplot,'Labels',{'Hit','Miss','Correcr Reject','False Alarm'});
title('Reaction Times (ms)');

%% 
%looking at responses specifically for proposed wrong answers that are
%+/-10. As this indicates if they were adding the tens place number or not.
m=0; 
n=0;
percent=0
for i=1:length(AllResults)
    if AllResults(i,6)==10 || AllResults(i,6)==-10
        if  AllResults(i,9)==4  %checks if they got a false positve for +/-10 answers
           m=m+1;%counts this number of false positives
           
        else
            n=n+1; %counts any other response to the +/-10 answer( i.e.,a correct reject or a no response)
        end
    end
end
falsePositives=m
total_tens=n+m
percent=falsePositives/total_tens %perect of +/-10 answers that were marked as false positives. 
             