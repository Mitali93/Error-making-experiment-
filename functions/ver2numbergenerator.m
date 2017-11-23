%%generate all possible two digit numbers and all possible sums(all pairs possible), given the
%%constraits. 

% number with 1-8 in tens place and 1-9 in units place. excluding ties,


All_numbers=[];

for i=1:8; %tens place number range
       for m=1:9; %units place number range
         if m~=i; %exclusing tie numbers
             All_numbers(end+1)=i*10+m;%generating two digit number from units and tens digit
         else
         end
       end
end
All_numbers(All_numbers==89)=[]; %exclusing 89 from the dataset as max can only be 87
%disp(All_numbers);


%%
%picking two of the two digit numbers. Sum less than 99, sum not a multiple
%of 10 and the two operants not equal.


All_problems=[];
others=[];

for i=1:length(All_numbers)
    Operant_1=All_numbers(i); %chosing all possible operator 1 
    
        for l=1:length(All_numbers)
            Operant_2=All_numbers(l); %chosing all possible operator 2
            Sum=Operant_1+Operant_2;
            Div=mod(Sum,10); %check if multiple of 10
            
                 if (Sum<99) && (Operant_1~=Operant_2) && (Div~=0) 
                     %excluding if sum>99, if the two operators are equal and if sum is a multiple of 10 
                    All_problems(end+1,:)=[Operant_1, Operant_2, Sum];%appened these numbers that passed the criteria to a new row
                 
                 else
                     others(end+1,:)=[Operant_1, Operant_2, Sum];% dumping the problems that do not match out criteria here
                 end
        end
end
%%
%removing flipped sums.
%disp(All_problems);

NoFlip=[];

totalProblems=length(All_problems);
for i=1:totalProblems
 
    for x=i+1:totalProblems
         if All_problems(i,1)==All_problems(x,2) && All_problems(i,2)==All_problems(x,1);
               NoFlip(end+1,:)=All_problems(x,:); 
        
            
         end
            
        
     
 end
end
  xlswrite('NoFlipped.xls',NoFlip)

%%
%randomised if the larger operand is first or second
% Randomised=[]
% B=randi([0 1], 868,1);
% NoRep(:,end+1)=B;
% 
% for i=1:868
%     if NoRep(i,4)==0
%         Randomised(i,:)=[NoRep(i,2) NoRep(i,1) NoRep(i,3)]
%     else 
%         Randomised(i,:)=[NoRep(i,1) NoRep(i,2) NoRep(i,3)]
%     end
% end

%%i dont think i should randomise, i think it should be exactly 50% of the
%%times greater operant first, right??

%xlswrite('randomised stimulus all constraints.xls',Randomised)

%%
%separating the numbers with same digit in units or tens
    
% NoPaired=[];
% 
% for i=1:868
% 
% Op1Split=sprintf('%d',Randomised(i,1))-'0';
% Op2Split=sprintf('%d',Randomised(i,2))-'0';
% 
% end
% 
% 
% For i=1:868
%     if Op1Split(i,2)~=Op2Split(i,2) && Op1Split(i,1)~=Op2Split(i,1)
%         NoPaired(end,:)=Randomised(i,:);
%     



