  function [score, responseStruct] = math_test
PsychDefaultSetup(2);
LoadPsychHID();
addpath('functions'); %import functions
addpath('Psychtoolbox');
devMode=1;
subject = SubjectPrompt();
  results.startTime = clock;
 if ~exist([pwd, '/MathTest'], 'dir') %creates folder named data if such folder doesnt exits
    mkdir (pwd, '/MathTest');
 end
outf = sprintf('%s/%s/%s-%4d%02d%02d-%02d%02d.mat', pwd, 'MathTest', subject, results.startTime(1:5)); 

        
        %try
        questions =...
            {'6 + 1';...
            '2 + 4';...
            '3 - 2';...
            '5 - 2';...
            '3 - 1';...
            '5 - 1';...
            '9 + 7';...
            '17 - 9';...
            '89 - 18';...
            '5 x 3';...
            '8 ÷ 2';...
            '8 x 5';...
            '13 x 7';...
            '48 - 19';...
            '14 x 6';...
            '2/3 - 1/3';...
            '126 ÷ 42';...
            '288 ÷ 48';...
            '7/8 - 2/8';...
            '3250 / 25';...
            '2 3/4 + 4 1/8';...
            '1.05 x 0.2';...
            '-18 + 12';...
            '-6 x 7';...
            '4/7 ÷ 1/2'};
        
        level = reshape(ones(5,5) .* repmat([1 2 3 4 5],5,1),1,25);
        incorrectByLevel = zeros(5,1);
        orders = cell2mat(arrayfun(@(x) randperm(4,4),1:length(questions),'UniformOutput',false)');
        correct = zeros(length(questions),1);
        responses = zeros(length(questions),4);
        
        %first column is the correct answer
answers = {...
            '7','1','5','2';...
            '6','2','7','8';...
            '1','3','2','4';...
            '3','1','4','8';...
            '2','0','3','6';...
            '4','2','5','7';...
            '16','12','15','23';...
            '8','26','5','11';...
            '71','56','107','75';...
            '15','45','18','25';...
            '4','6','16','2';...
            '40','45','85','30';...
            '91','37','81','107';...
            '29','23','30','22';...
            '84','64','72','52';...
            '1/3','1/6','1/2','2/9';...
            '3','4','4 1/2','5';...
            '6','7','7 1/2','9';...
            '5/8','3/5','1 3/5','1/8';...
            '130','50','80','110';...
            '6 7/8','6 1/2','8 1/2','7 1/4';...
            '0.21','2.1','0.3','2.2';...
            '-6','6','-30','30';...
            '-42','45','-67','1';...
            '8/7','1 1/4','2/7','1/7'};
        
         
        % Get the screen numbers
    screens = Screen('Screens');
    
    % Draw to the external screen if avaliable
    screenNumber = min(screens);
    % Define black and white
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber); 
    
    % Open an on screen window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
          
    [xCenter, yCenter] = RectCenter(windowRect);

    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    

    topPriorityLevel = MaxPriority(window);
      ListenChar(2);
  
        %     Get the size of the on screen window
        [screenXpixels, screenYpixels] = Screen('WindowSize', window);
        
        [maxValue, ~, ~] = Screen('ColorRange', window);
        
        %    Query the frame duration
        ifi = Screen('GetFlipInterval', window);
        
        
        Screen('TextSize',window,24);
        DrawFormattedText(window, ['You will be presented with a few maths problems. Use the mouse to click on the correct answer. You have 30 seconds to answer each problem, so keep an eye on the timer in the corner. Only give your answer when you are sure.\nPress [SPACE] to start.'], 'center', 'center', white, 70,[],[],2);
        Screen('Flip', window);
        KeyWait(2);
        %WaitSecs(1);
        
        % Make a base Rect of 200 by 200 pixels
        baseRect = [0 0 200 200];
        
        % Screen X positions of our three rectangles
        squareXpos = [screenXpixels * 0.20 screenXpixels * 0.40  screenXpixels * 0.60 screenXpixels * 0.80];
        numSqaures = length(squareXpos);
        
        % Set the colors to Red, Green and Blue
        
        % Make our rectangle coordinates
        allRects = nan(4, 4);
        for i = 1:numSqaures
            allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
        end
        
        allColors = [0 0 0 0; 0 0 0 0; 0 0 0 0];
        
        
        % Define red and blue
        offSquare = white;%[1 0 0];
        onSquare = [0 maxValue 0];
        
        % Here we set the initial position of the mouse to be in the centre of the
        % screen
        SetMouse(xCenter, yCenter, window);
        
        % Flip to the screen
                vbl = Screen('Flip', window);
                  waitframes = 1;
                  
        % Loop the animation until a key is pressed
        buttons = 0;
        Screen('TextFont', window, 'Ariel');
        Screen('TextSize', window, 50);
        %[~, ~, textboundsleft] = DrawFormattedText(window, 'LEFT', sum(allRects([1 3],1))/2, sum(allRects([2 4],1))/2 , white);
        %[~, ~, textboundscentre] = DrawFormattedText(window, 'EITHER', sum(allRects([1 3],2))/2, sum(allRects([2 4],2))/2 , white);
        %[~, ~, textboundsright] = DrawFormattedText(window, 'RIGHT', sum(allRects([1 3],3))/2, sum(allRects([2 4],3))/2 , white);
        
        q = 1;
        buttons = 0;
        opts1 = 0;
        opts2 = 0;
        opts3 = 0;
        opts4 = 0;
        selected = 0;
        
        questionStart = GetSecs;
        timeLimit = 30;
        
       
        
        doQuestions = 1;
        
        
        while q <= length(questions)
            
            responded = 0;
            thisQuestion = questions{q};
            thisOrder = orders(q,:)
            thisAnswers = answers(q,:);
            thisCorrect = find(thisOrder==1) % the index which has the correct answer, and correct answer is represented by 1 in the matrix called 'order'. since in the answer matrix the first column always has the correct answer. and the 'order' matrix shuffles the order the answers. so which ever index has '1', that index holds the correct answer.
            
            while responded == 0
                timeRemaining = timeLimit - round(GetSecs  - questionStart);
                
                clear buttons
                % Get the current position of the mouse
                [x, y, buttons] = GetMouse(window);
                
                % Center the rectangle on the centre of the screen
                
                % See if the mouse cursor is inside the square
                opts1 = IsInRect(x, y, allRects(:,1));
                opts2 = IsInRect(x, y, allRects(:,2));
                opts3 = IsInRect(x, y, allRects(:,3));
                opts4 = IsInRect(x, y, allRects(:,4));
                
                if opts1 == 1
                    
                    opts1_colour = onSquare;
                else
                    
                    opts1_colour = offSquare;
                end
                
                if opts2 == 1
                    
                    opts2_colour = onSquare;
                else
                    
                    opts2_colour = offSquare;
                end
                
                if opts3 == 1
                    
                    opts3_colour = onSquare;
                else
                    
                    opts3_colour = offSquare;
                end
                
                if opts4 == 1
                    
                    opts4_colour = onSquare;
                else
                    
                    opts4_colour = offSquare;
                end
                
                
                
                Screen('FillRect', window, allColors, allRects)
                
                
                DrawFormattedText(window, questions{q}, 'center', yCenter-200, white, 80, [], [], 2);
                DrawFormattedText(window, num2str(timeRemaining),screenXpixels - 100, 100,white,80,[],[],2);
                
                
                
               
             
                DrawFormattedText(window, thisAnswers{thisOrder(1)}, screenXpixels * 0.20, yCenter , opts1_colour);
                DrawFormattedText(window, thisAnswers{thisOrder(2)}, screenXpixels * 0.40, yCenter , opts2_colour);
                DrawFormattedText(window, thisAnswers{thisOrder(3)}, screenXpixels * 0.60, yCenter , opts3_colour);
                DrawFormattedText(window, thisAnswers{thisOrder(4)}, screenXpixels * 0.80, yCenter , opts4_colour);
                % Draw a white dot where the mouse is
                Screen('DrawDots', window, [x y], 10, white, [], 2);
                
               
                vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                
                
                if timeRemaining <= 0
                    correct(q,1) = 0;
                    incorrectByLevel(level(q),1) = incorrectByLevel(level(q),1) + 1
                    thisResponse = [opts1 opts2 opts3 opts4];
                    responded = 1;
                    opts1 = 0;
                    opts3 = 0;
                    opts2= 0;
                    opts4 = 0;
                    buttons = 0;
                    
                   Exit(); 
                end
                
                
                if any(buttons) == 1 && (opts1 ==1||opts3==1||opts2==1||opts4==1)
                    
                    thisResponse = [opts1 opts2 opts3 opts4];
                    responses(q,:) = thisResponse
                    
                    if find(responses(q,:))== thisCorrect 
                        correct(q,1) = 1;
                    else
                        correct(q,1) = 0;
                        incorrectByLevel(level(q),1) = incorrectByLevel(level(q),1) + 1
                    end
                    responded = 1;
                    opts1 = 0;
                    opts3 = 0;
                    opts2= 0;
                    opts4 = 0;
                    clear buttons
                    
                end
                
                
                if incorrectByLevel(level(q),1) >=2
                    q = length(questions); %q = length(questions) + 1; %ends the loop if you make 2 or more wrong at one level.
                end
                
                if q >= 2                           %why? level(q) will never be greater than 2 until q= 5!
                    if level(q) >= 2
                        if (incorrectByLevel(level(q),:) + incorrectByLevel(level(q)-1,:)) >= 2
                            
                            q = length(questions);
                                                                    % so i think the point is that for levels 2 and
                                                                    % higher, if you made a mistake in the previous
                                                                    % level that counts as one of your two chances.
                                                                    % but what if you made one mistake in the firs
                                                                    % and then one mistake in the third? then it is
                                                                    % only comparing the third to second and thinks
                                                                    % you've made only one mistake in total when
                                                                    % you have made two . 
                       
                        end
                        
                    end
                end
                
            end
            
            responseStruct(q).question = thisQuestion;
            responseStruct(q).response = thisResponse;
            responseStruct(q).correctResponse = thisCorrect;
            responseStruct(q).answers = thisAnswers;
            responseStruct(q).order = thisOrder;
            responseStruct(q).correct = correct(q);
            
            responded = 0;
            WaitSecs(.5)
            questionStart = GetSecs;
            q = q + 1;
        end

        score = sum(correct);
        
     Exit();   
        save(outf,'responseStruct', 'score')
        
    end
