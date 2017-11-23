% number with 1-8 in tens place and 1-9 in units place. excluding ties,


All_numbers=[];

for i=1:8 %tens place number range
       for m=1:9 %units place number range
         if m~=i %exclusing tie numbers
             All_numbers(end+1)=i*10+m %generating two digit number from units and tens digit
         else
         end
       end
end
All_numbers(All_numbers==89)=[]; %exclusing 89 from the dataset as max can only be 87
disp(All_numbers);


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
            
                 if (Sum<99) && (Operant_1~=Operant_2) && (Div~=0) %excluding if sum<99, if the two operators are equal nad if sum is a multiple of 10 
                    All_problems(end+1,:)=[Operant_1, Operant_2, Sum];%appened these numbers that passed the criteria to a new row
                 
                 else
                     others(end+1,:)=[Operant_1, Operant_2, Sum];% dumping the problems that do not match out criteria here
                 end
        end
end

display(All_problems)
length(All_problems)

%%

%randomising the matrix containing all the possible problems, given the
%contrains

%pos=randi(length(All_problems)





