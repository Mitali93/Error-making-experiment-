function [ME,workspaceStruct] = ErrorExp()

params = struct; % declare a parameter struct
MultiCompatibility = 1;
Screen('Preference', 'SkipSyncTests', 1);


try
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        keyboardToUse = 'Apple Keyboard';
        [keyboardIndices, productNames, ~] = GetKeyboardIndices;
        device = keyboardIndices(ismember(productNames,keyboardToUse));
    end
    
    % add autoquit lines for debugging
    start = GetSecs();
    
    
    addpath('functions'); %import functions
    addpath('Psychtoolbox');
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
        case 'TP1B'
            trials=xlsread('Block1_Part2.xls');
        case 'TP2A'
            trials=xlsread('Block2_Part1.xls');
        case 'TP2B'
            trials=xlsread('Block2_Part2.xls');
        case 'TP3A'
            trials=xlsread('Block3_Part1.xls');
        case 'TP3B'
            trials=xlsread('Block3_Part2.xls');
        otherwise
            error('You have not entered a valid condition!');
    end
    
    buttonTrue=inputdlg('correct button','Enter either S or L as the correct button');
    
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
    order=randperm(r);
    AllResults=NaN(r,8);%initialise the results matrix
    
    
    
    AllResults=trials(order,:);
    %all rows (i.e.each problem) from the sheet put in a random order
    %here and in this order problems are displayed.
    %column 1,2,3 are Op1 Op2 and Result
    %columns 4,5,6 contain info about characteristics of the problem.
    % The RT and button pressed will be added to each row in columns 7 and 8.
    
    header = {'Op1','Op2','Result','Carry','Odd_Even','Distance'};
    
    % Carry: 1 = Carry; 0 = No Carry
    % Odd_Even: 1 = Odd; 2 = Even
    % Distance: Distance between presented result and actual answer
    
    
    results.startTime = clock;
    if ~exist([pwd, '/data'], 'dir') %creates folder named data if such folder doesnt exits
        mkdir (pwd, '/data');
    end
    outf = sprintf('%s/%s/%s-%4d%02d%02d-%02d%02d.mat', pwd, 'data', subject, results.startTime(1:5));
    % example file: 006-20171106-1542 . subject code followed by date and time
    
    
    %%
    %run experiment
    s = MAinitGraphics();
    
    commandwindow(); % give command window focus.
    
    %instruction displayed in the start
    Screen('TextSize', s.w ,30);
    tstring = sprintf(' In this task, you will be shown addition sums and your job is to indicate whether the answer is correct or wrong. \n Eg. 24 + 57 = 71 \n\n If you agree that this answer is CORRECT, press the ''%s'' key. \n If you think that this answer is WRONG, press the ''%s'' key.\n Please respond as quickly as possible. \n\nIn between each sum, you will see a picture of an eye. This indicates that you can blink if you wish. Kindly refrain from blinking at other times as this would affect our measurements. \n\n We will do a short practice series first after which you will be shown 180 sums in a ''block'' which will be divided into two parts by a short break. We will need you to complete 3 such blocks, each preeceded by a practice . If you are in any discomfort, please do not hesitate to let us know. \n\n Press any key when you are ready to begin. \n\nThank you for participating!',BT,BF);
    
    StartDrawing(s);
    DrawFormattedText(s.w,tstring,'center','center',[255 255 255], 74)
    EndDrawing(s);
    if MultiCompatibility
        WaitKey(device);
        KbQueueStart(device);
        KbQueueFlush(device);
    else
        KeyWait(2);
    end
    
    WaitSecs(0.5)
    
    k='='; % display the equal sign from this variable
    
    Screen('TextSize', s.w ,70); %font size for the numbers
    
    for i=1:r % for each row of randomised problems, will display the
        %1st column (op1) 2nd colummn(op2) and third column(result)
        %sequentially
        
        KbQueueStart(device);
        
        %eye blink prompt 1.5 seconds
        StartDrawing(s);
        DrawImg(s,fix);
        EndDrawing(s);
        WaitSecs(params.eye);
        
        %first operant 800ms
        StartDrawing(s);
        CenterText(s,num2str(AllResults((i),1)),-30);
        EndDrawing(s);
        WaitSecs(params.op1);
        
        
        
        %second operant 800ms
        StartDrawing(s);
        CenterText(s,num2str(AllResults((i),2)),-30);
        EndDrawing(s);
        WaitSecs(params.op2);
        
        
        
        % display '=' sign TIME VARIABLE PER CONDITION, but same for A and B of
        % a condition
        if condition{1,1}=='TP1A' | condition{1,1}=='TP1B'
            
            StartDrawing(s);
            CenterText(s,k,-30);
            EndDrawing(s);
            WaitSecs(params.tp1);
            
        elseif condition{1,1}=='TP2A' | condition{1,1}=='TP2B'
            
            StartDrawing(s);
            CenterText(s,k,-30);
            EndDrawing(s);
            WaitSecs(params.tp2);
            
        elseif condition{1,1}=='TP3A' | condition{1,1}=='TP3B'
            
            StartDrawing(s);
            CenterText(s,k,-30);
            EndDrawing(s);
            WaitSecs(params.tp3);
        end
        
        %result should be displayed maximum for 1 sec. have to respond as soon as they can when
        %they see this.
        StartDrawing(s);
        onset = GetSecs(); %starts timing this one second window that they have
        CenterText(s,num2str(AllResults((i),3)),-30);
        EndDrawing(s)
        
        if MultiCompatibility
            KbQueueFlush(device,4);
        else
            PsychHID('KbQueueFlush'); %Flushes Buffer so only response after stimonset are recorded
        end
        
        
        
        %Key press responses
        while (GetSecs()- onset) < params.timeout %Result displayed for no more than 1 sec so responses within 1 sec taken
            
            if MultiCompatibility
                [ pressed, firstPress]=KbQueueCheck(device); %  check if any key was pressed.
            else
                [ pressed, firstPress]=PsychHID('KbQueueCheck') %  check if any key was pressed.
            end
            
            if pressed == 1
                firstPress(find(firstPress==0))=NaN; % get rid of 0s
                [endtime, Index]= min(firstPress); % gets the RT of the first key-press and its ID
                
                AllResults(i,7)=endtime-onset; % RTs added for the correspoding row i.e corresponding to displayed problem
                AllResults(i,8)=Index; %key pressed for each problem
                
                
                break;
            elseif pressed == 0
                AllResults(i,7) = NaN;%% RT will be NaN
                AllResults(i,8) = 0;%% key ID is 0
                
            end
            
            
            
        end
        
        
        
        KbQueueFlush(device);
        save(outf, 'AllResults','buttonCorr','buttonWrong','condition','params','header');
        
        %pushed save command up to before the end of the loop so that it saves after every trial. This prevents loss of data
        %if block is stopped in between. Is this okay?because it replaces the
        %file every trial
        
        WaitSecs(0.2) %the eye appears too fast otherwise. tiny gap between pressing and going to next trial.
    end
    
    mess = sprintf('End of Block. You will continue onto the next block');
    StartDrawing(s);
    CenterText(s, mess, -15)
    
    EndDrawing(s);
    WaitSecs(1);
    
    Exit();
    
    
catch ME
    Exit();
    workspacevars = whos;
    workspacevars = arrayfun(@(x) workspacevars(x).name, 1:length(workspacevars),'UniformOutput',false);
    workspaceStruct = struct;
    for i = 1 : length(workspacevars)
        workspaceStruct.(workspacevars{i}) = eval(workspacevars{i},';');
    end
    warning('There was some sort of error!')
end
end







