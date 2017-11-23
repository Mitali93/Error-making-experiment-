diary
unitsplace=[1:9];
tensplace=[1:8];


for i=1:64
    
    pos=randi(length(tensplace));  
    pos_2=randi(length(unitsplace));
    
    X=tensplace(pos);
    Y=unitsplace(pos_2);

    if X~=Y
        A(i)=X*10+Y;
    else
        i=i-1
    
    
    end
    
end
disp(A)

