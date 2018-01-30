function [ME,workspaceStruct] = practice

params = struct; % declare a parameter struct
MultiCompatibility = 0;% make 0 for windows. and also if keyboard doesnt work in windows make it 1 and check the product name and insert that.
Screen('Preference', 'SkipSyncTests', 0);


%try
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
        keyboardToUse = 'Keyboard';
        [keyboardIndices, productNames, ~] = GetKeyboardIndices;
        device = keyboardIndices(ismember(productNames,keyboardToUse));
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
    
    condition=inputdlg('enter condition: P1, P2 or P3');
    % three blocks of different time pressure condition(TP1 TP2 TP3), each divided into two halves(A and B)
    switch condition{1,1}%file from where trials are taken depending on condittion inputted
        case 'P1'
            trials=xlsread('Practice_Block1.xls');
        case 'P2'
            trials=xlsread('Practice_Block2.xls');
        case 'P3'
            trials=xlsread('Practice_Block3.xls');
        
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
    
    % The RT and button pressed will be added to each row in columns 9 and 10.
    
    header = {'S.No.','Op1','Op2','Result','Carry','Odd_Even','Distance','Unique code','RT','KeyPressed','Response Type'};
    
    % Carry: 1 = Carry; 0 = No Carry
    % Odd_Even: 1 = Odd; 2 = Even
    % Distance: Distance between presented result and actual answer
    
    %     digit 1:Time pressure condition(1/2/3)
    %     digit 2: Part 1  or Part 2 of that condition(1/2)
    %     digit 3:carry no carry (1/0)
    %     digit 4:corr/incorrect(0/1/4/6/9/5)
    %     digit 5 and 6: serial number(01-90)
    
    %Response type: 0 No response, 1 hitt, 2 miss, 3 corr rej, 4 false
    %alarm, 5 another key pressed
    
    results.startTime = clock;
    if ~exist([pwd, '/data'], 'dir') %creates folder named data if such folder doesnt exits
        mkdir (pwd, '/data');
    end
     outf = [pwd filesep 'data' filesep subject '-' sprintf('%4d%2d-%2d%2d%2',results.startTime(1:5)),'.mat'];
   
    % example file: 006_1_3-20171106-1542 . subject code followed by time pressure condition 1/2/3 (1), practice round (3) date and time
%         %% Connect to Net Station
% ip = '172.29.27.157';
% port = '55513'; 
% Init_netStation(ip,port);
%     
%     %%
    %run experiment
    s = MAinitGraphics();

   %commandwindow(); % give command window focus.
    
    %instruction displayed in the start
    Screen('TextSize', s.w ,30);
   
     tstring=sprintf('This is a practice round.\n\n If you think the displayed answer is CORRECT, then you have to press the ''%s'' key. \n if you think the displayed answer is WRONG, press the ''%s'' key. \n\n Please answer as quickly and as carefully as possible while the proposed answer is displayed.\n\n Press any key to begin.',BT,BF)
    
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
    
    WaitSecs(0.5)
     %NetStation('Event','BEGN', GetSecs, 0.001,'pract', condition{1,1})
    k='='; % display the equal sign from this variable
    
    Screen('TextSize', s.w ,70); %font size for the numbers
      %eye blink prompt 1.5 seconds. Put at the end within the loop, and so for the first trial it is outside loop
        StartDrawing(s);
        DrawImg(s,fix);
        EndDrawing(s);
        
        %NetStation('Event','BLNK', GetSecs, 0.001,'blank', 100000, 'tral', 1);
        
        WaitSecs(params.eye);
    
    
    for n=1:r % for each row of randomised problems, will display the
        %1st column (op1) 2nd colummn(op2) and third column(result)
        %sequentially
       
    
      
        %first operant 800ms
        StartDrawing(s);
        CenterText(s,num2str(AllResults((n),2)),-30);
        EndDrawing(s);
        %NetStation('Event','OPR1', GetSecs, 0.001,'op1',  AllResults(i,8), 'tral', i);
        WaitSecs(params.op1);
        
        %NetStation('EVENT','STIM',GetSecs,0.0001,'OPER1',AllResults(1,8))
        
        %second operant 800ms
        StartDrawing(s);
        CenterText(s,num2str(AllResults((n),3)),-30);
        EndDrawing(s);
        %NetStation('Event','OPR2', GetSecs, 0.001,'op2',  AllResults(i,8), 'tral', i);
        WaitSecs(params.op2);
        
        %NetStation('event','stim',GetSecs,0.0001,'OPER2',AllResults(1,8))
        
        
        % display '=' sign TIME VARIABLE PER CONDITION, but same for A and B of
        % a condition
        if condition{1,1}=='P1'
            
            StartDrawing(s);
            CenterText(s,k,-30);
            EndDrawing(s);
           % NetStation('Event','EQUL', GetSecs, 0.001,'sign',  AllResults(i,8), 'tral', i);
            WaitSecs(params.tp1);
            
        elseif  condition{1,1}=='P2'
            
            StartDrawing(s);
            CenterText(s,k,-30);
            EndDrawing(s);
            %NetStation('Event','EQUL', GetSecs, 0.001,'sign',  AllResults(i,8), 'tral', i);
            WaitSecs(params.tp2);
            
        elseif condition{1,1}=='P3'
            
            StartDrawing(s);
            CenterText(s,k,-30);
            EndDrawing(s);
           % NetStation('Event','EQUL', GetSecs, 0.001,'sign',  AllResults(i,8), 'tral', i);
            WaitSecs(params.tp3);
        end
        
        if MultiCompatibility
            KbQueueFlush(device,4);
        else
            PsychHID('KbQueueFlush'); %Flushes Buffer so only response after stimonset are recorded
        end
        
       
         %result should be displayed maximum for 1 sec. have to respond as soon as they can when
        %they see this.
        StartDrawing(s);
        onset = GetSecs(); %starts timing this one second window that they have
        CenterText(s,num2str(AllResults((n),4)),-30);
         % NetStation('Event','ANSW', GetSecs, 0.001,'answ',  AllResults(i,8), 'tral', i);
        EndDrawing(s)
        WaitSecs(params.timeout);
        
        
        %eye blink prompt 1.5 seconds
        StartDrawing(s);
        DrawImg(s,fix);
        EndDrawing(s);
        % NetStation('Event','BLNK', GetSecs, 0.001,'blank', 100000, 'trial', i);
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
                
               if AllResults(n,7)==0 && AllResults(n,10)==buttonCorr{1,1};
                    
                  AllResults(n,11)=1;
                elseif AllResults(n,7)==0 && AllResults(n,10)==buttonWrong{1,1};
                    
                  AllResults(n,11)=2;
                elseif AllResults(n,7)~=0 && AllResults(n,10)==buttonWrong{1,1};
                  
                  AllResults(n,11)=3;
                elseif AllResults(n,7)~=0 && AllResults(n,10)==buttonCorr{1,1};
                   
                  AllResults(n,11)=4;
                else
                   
                  AllResults(n,11)=5;
                end

            elseif pressed == 0
                AllResults(n,9) = NaN;%% RT will be NaN
                AllResults(n,10) = 0;%% key ID is 0
                AllResults(n,11)=0;% response type 0
                
                                        
        end
    
        save(outf, 'AllResults','buttonCorr','buttonWrong','condition','params','header');

        WaitSecs(0.2) %the eye appears too fast otherwise. tiny gap between pressing and going to next trial.
    end
        %% Close NetStation
% pause(5); %wait for a bit
% NetStation('Event','STRT', GetSecs, 0.001,'end', 9999);
Screen('TextSize', s.w ,40);
    mess = sprintf('End of Practice. You will continue onto the block');
    StartDrawing(s);
    CenterText(s, mess, -15)
    
    EndDrawing(s);
    WaitSecs(2);
    
    Exit();
    
    
% catch ME
%     Exit();
%     workspacevars = whos;
%     workspacevars = arrayfun(@(x) workspacevars(x).name, 1:length(workspacevars),'UniformOutput',false);
%     workspaceStruct = struct;
%     for n = 1 : length(workspacevars)
%         workspaceStruct.(workspacevars{n}) = eval(workspacevars{n},';');
%     end
%     warning('There was some sort of error!')
% end
end