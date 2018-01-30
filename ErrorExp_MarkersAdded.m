function [ME,workspaceStruct] = ErrorExp_MarkersAdded(iseeg)

workspaceStruct = struct;
ME = [];

params = struct; % declare a parameter struct
MultiCompatibility = 0;
Screen('Preference', 'SkipSyncTests', 0);

% try
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % GENERAL EXPERIMENT PARAMETERS
    % Time pressure values
    params.tp1 = 2; % Time pressure 1
    params.tp2 = 1; % Time pressure 2
    params.tp3 = 0.5; % Time pressure 3
    % Operant timing values
    params.op1 = .8; % Duration of operant 1
    params.op2 = .8; % Duration of operant 2
    
    % Other timing values
    params.eye = 1.5; % eyeblink prompt duration
    params.timeout = 1; % time out for making a response
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if MultiCompatibility
        keyboardToUse = 'Keyboard';
        [keyboardIndices, productNames, ~] = GetKeyboardIndices
        device = keyboardIndices(ismember(productNames,keyboardToUse))
    end
    
    % add autoquit lines for debugging
    start = GetSecs();
    
    addpath('functions'); %import functions
    %addpath('Psychtoolbox');
    PsychDefaultSetup(2);
    
    if MultiCompatibility
        KbQueueCreate(device);
    else
        LoadPsychHID()
        PsychHID('KbQueueCreate'); %For responses collection
    end
    
    if MultiCompatibility
        KbQueueStart(device);
    else
        PsychHID('KbQueueStart');
    end
    
    
    fix=imread('szem.jpg');  %blink prompt picture
    
    rng('shuffle');%changes the seed of randperm
    
    subject = SubjectPrompt();%takes in participant number
    
    condition=inputdlg('enter condition: TP1A, TP1B, TP2A, TP2B, TP3A or TP3B');
    % three blocks of different time pressure condition(TP1 TP2 TP3), each divided into two halves(A and B)
    switch condition{1,1}%file from where trials are taken depending on condittion inputted
        case 'TP1A'
            trials=xlsread('Block1_Part1.xls');
            block=1
        case 'TP1B'
            trials=xlsread('Block1_Part2.xls');
            block=2
        case 'TP2A'
            trials=xlsread('Block2_Part1.xls');
            block=3
        case 'TP2B'
            trials=xlsread('Block2_Part2.xls');
            block=4
        case 'TP3A'
            trials=xlsread('Block3_Part1.xls');
            block=5
        case 'TP3B'
            trials=xlsread('Block3_Part2.xls');
            block=6
        otherwise
            error('You have not entered a valid condition!');
    end
    
    buttonTrue=inputdlg('correct button: s or l');
    
    %depending on key chosen to represent correct through dialogue box, save the name
    %and ID of key designated for corr and wrong.
    if buttonTrue{1,1} == 's'
        BT='S';
        BF='L'; % variable used in instruction text saying which key is true
        buttonCorr={KbName('s'), 's'};  %save corr and incorr key and ID
        buttonWrong={KbName('l'), 'l'};
    elseif buttonTrue{1,1}== 'l'
        BT='L';
        BF='S';
        buttonCorr={KbName('l'), 'l'};
        buttonWrong={KbName('s'); 's'};
    else
        error('You have not entered a valid button!');
    end
    

    %%
    %Initialize user results
    
    [r,~]=size(trials); % number of trials in the sheet(i.e in a block)
    
    shuffled = false;
    while shuffled == false
        [AllResults, order, shuffled] = ShuffleWithRestrictions(trials);
    end
    
    params.order = order; % save the trial order
    
    AllResults=trials(order,:);
  %all rows (i.e.each problem) from the sheet put in a random order
  %here and in this order problems are displayed.
    
    header = {'S.no.','Op1','Op2','Displayed Result','Carry(1)No carry(0)','Odd(1)Even(2)','Distance from correct answer','Unique Code','RT','KeyPressed','Response Type'};
    
    % Carry: 1 = Carry; 0 = No Carry
    % Odd_Even: 1 = Odd; 2 = Even
    % Distance: Distance between presented result and actual answer
    %Unique code for each problem: sent as a marker. 6 digits made as follows:
    
    %     digit 1:Time pressure condition(1/2/3)
    %     digit 2: Part 1  or Part 2 of that condition(1/2)
    %     digit 5 and 6: serial number(01-90)
    
    %Response type: 0 No response, 1 hitt, 2 miss, 3 corr rej, 4 false
    %alarm, 5 another key pressed
    
    
    results.startTime = clock;
    if ~exist([pwd, '/data'], 'dir') %creates folder named data if such folder doesnt exits
        mkdir (pwd, '/data');
    end
    outf = [pwd filesep 'data' filesep subject '-' sprintf('%4d%2d-%2d%2d%2',results.startTime(1:5)),'.mat'];
   
    % example file: 006_1_2-20171106-1542 . subject code(006), time pressure condition 1/2/3 (1)  part 1 or 2 (2) followed by date and time
    
    %% Connect to Net Station
    if iseeg
    ip = '172.29.27.157';
    port = '55513';
    Init_netStation(ip,port);
    % --------------------------
    end %iseeg
    
    %run experiment
    s = MAinitGraphics();
    params.s = s; % save the screen parameters
    
    %commandwindow(); % give command window focus. if this runs
    %then i see the toolbar while on full screen downstaris, i dont want that.
 
    tstring=sprintf(' If you think the displayed answer is CORRECT, then you have to press the ''%s'' key \n\n If you think the displayed answer is WRONG, press the ''%s'' key. \n\n Please answer as quickly and as carefully as possible while the proposed answer is displayed.\n\n Press any key to begin.',BT,BF);
   
    StartDrawing(s);
    DrawFormattedText(s.w,tstring,'center','center',[255 255 255], 74);
      KeyWait(2);
    EndDrawing(s);
   
    if MultiCompatibility
        WaitKey(device);
        KbQueueStart(device);
        KbQueueFlush(device);
    else
        KeyWait(2);
    end
    if iseeg
    NetStation('Event','BEGN', GetSecs, 0.001,'block', block);
    end %iseeg
    WaitSecs(1)
    
    
    k='='; % display the equal sign from this variable
    
    Screen('TextSize', s.w ,70); %font size for the numbers
    
    %eye blink prompt 1.5 seconds. Put at the end within the loop, and so for the first trial it is outside loop
        StartDrawing(s);
        DrawImg(s,fix);
        EndDrawing(s);
        if iseeg
        NetStation('Event','BLNK', GetSecs, 0.001,'blank', 1000, 'tral', 1);
        end %iseeg
        WaitSecs(params.eye);
    
    for n=1:r % for each row of randomised problems, will display the
        %2nd column (op1) 3rd colummn(op2) and 4th column(result)


        %first operant 800ms
        StartDrawing(s);
        CenterText(s,num2str(AllResults((n),2)),-30);
        EndDrawing(s);
            if iseeg
                
            NetStation('Event','OPR1', GetSecs, 0.001,'cary',AllResults(n,5),'code',  AllResults(n,8), 'tral', n);%AllResults(n,5) is carry=1, nocarry=0, (n,8) is unique code
            end %iseeg
        WaitSecs(params.op1);
       
        %second operant 800ms
        StartDrawing(s);
        CenterText(s,num2str(AllResults((n),3)),-30);
        EndDrawing(s);
            if iseeg
            NetStation('Event','OPR2', GetSecs, 0.001,'cary',AllResults(n,5),'code',  AllResults(n,8), 'tral', n);
            end %iseeg 
        WaitSecs(params.op2);

        % display '=' sign TIME VARIABLE PER CONDITION, but same for A and B of
        % a condition
        if condition{1,1}=='TP1A' | condition{1,1}=='TP1B'
            
            StartDrawing(s);
            CenterText(s,k,-30);
            EndDrawing(s);
                if iseeg
                NetStation('Event','EQUL', GetSecs, 0.001,'sign',555,'code',  AllResults(n,8), 'tral', n);
                end %iseeg
            WaitSecs(params.tp1);
            
        elseif condition{1,1}=='TP2A' | condition{1,1}=='TP2B'
            
            StartDrawing(s);
            CenterText(s,k,-30);
            EndDrawing(s);
                if iseeg
                NetStation('Event','EQUL', GetSecs, 0.001,'sign', 555,'code', AllResults(n,8), 'tral', n);
                end %iseeg
            WaitSecs(params.tp2);
            
        elseif condition{1,1}=='TP3A' | condition{1,1}=='TP3B'
            
            StartDrawing(s);
            CenterText(s,k,-30);
            EndDrawing(s);
                if iseeg
                NetStation('Event','EQUL', GetSecs, 0.001,'sign', 555,'code', AllResults(n,8), 'tral', n);
                end %iseeg
            WaitSecs(params.tp3);
        end
        
        %Flushes Buffer so only response after displayed answer and even
        %during eye prompt are collected
         if MultiCompatibility
            KbQueueFlush(device,4);
        else
            PsychHID('KbQueueFlush'); 
        end
        
        %Display answer 1 sec
        StartDrawing(s);
        onset = GetSecs(); %starts timing this one second window that they have
        CenterText(s,num2str(AllResults((n),4)),-30);
        EndDrawing(s)
            if iseeg
            NetStation('Event','ANSW', GetSecs, 0.001,'dist', AllResults(n,7),'code',  AllResults(n,8), 'tral', n);%(n,7) is distance from answer. 
            end %iseeg
        WaitSecs(params.timeout);
        
        %eye blink prompt 1.5 seconds. response collection allowed here
        %too, will filter out too late responses later 
        StartDrawing(s);
        DrawImg(s,fix);
        EndDrawing(s);
            if iseeg
            NetStation('Event','BLNK', GetSecs, 0.001,'blank', 1000,'blank',1000, 'tral', n+1);
            end %iseeg
        WaitSecs(params.eye);
        
   
            %Key press responses
            if MultiCompatibility
                [ pressed, firstPress]=KbQueueCheck(device); %  check if any key was pressed.
                KbQueueFlush(device);
            else
                [ pressed, firstPress]=PsychHID('KbQueueCheck');%  check if any key was pressed.
                PsychHID('KbQueueFlush')
            end
            
            if pressed == 1
                firstPress(find(firstPress==0))=NaN; % get rid of 0s
                [endtime, Index]= min(firstPress); % gets the RT of the first key-press and its ID
                
                AllResults(n,9)=endtime-onset; % RTs added for the correspoding row i.e corresponding to displayed problem
                AllResults(n,10)=Index; %key pressed for each problem
                
                %puts a marker for the response, depending on the type of
                %response. also in the .mat file new column for response
                %type
                if AllResults(n,7)==0 && AllResults(n,10)==buttonCorr{1,1};
                    if iseeg
                    NetStation('Event','HITT', endtime, 0.001,'respded', pressed, 'key', Index,'tral', n);%hit
                    end %iseeg
                  AllResults(n,11)=1;
                elseif AllResults(n,7)==0 && AllResults(n,10)==buttonWrong{1,1};
                    if iseeg
                    NetStation('Event','MISS', endtime, 0.001,'respded', pressed, 'key', Index, 'tral', n);%Miss
                    end %iseeg
                  AllResults(n,11)=2;
                elseif AllResults(n,7)~=0 && AllResults(n,10)==buttonWrong{1,1};
                    if iseeg
                    NetStation('Event','CREJ', endtime, 0.001,'respded', pressed, 'key', Index, 'tral', n);%Correct Reject
                    end %iseeg
                  AllResults(n,11)=3;
                elseif AllResults(n,7)~=0 && AllResults(n,10)==buttonCorr{1,1};
                    %if iseeg
                    NetStation('Event','FALS', endtime, 0.001,'respded', pressed, 'key', Index, 'tral', n);%False Alarm
                    %end %iseeg
                  AllResults(n,11)=4;
                else
                    if iseeg
                    NetStation('Event','RESP', endtime, 0.001,'respded', pressed, 'key', Index, 'tral', n);%in case they press some other key by mistake, still consider it as response. could sort it later.
                    end %iseeg
                  AllResults(n,11)=5;
                end
 
            elseif pressed == 0
                AllResults(n,9) = NaN;%% RT will be NaN
                AllResults(n,10) = 0;%% key ID is 0
                AllResults(n,11)=0 % no response type

        end
        
        save(outf, 'AllResults','buttonCorr','buttonWrong','condition','params','header','iseeg');
        
        WaitSecs(0.2) %the eye appears too fast otherwise. tiny gap between pressing and going to next trial.
    end
    %% Close NetStation
    pause(5); %wait for a bit
    if iseeg
    NetStation('Event','STRT', GetSecs, 0.001,'end', 9999);
    end %iseeg
    Screen('TextSize', s.w ,40);
    mess = sprintf('End of Block. You will continue onto the next block');
    StartDrawing(s);
    CenterText(s, mess, -15)
    EndDrawing(s);
    WaitSecs(3);
    Exit();
    
    
% catch ME
%     Exit();
%     workspacevars = whos;
%     workspacevars = arrayfun(@(x) workspacevars(x).name, 1:length(workspacevars),'UniformOutput',false);
%     
%     for n = 1 : length(workspacevars)
%         workspaceStruct.(workspacevars{n}) = eval([workspacevars{n},';']);
%     end
%     warning('There was some sort of error!')
% end
end