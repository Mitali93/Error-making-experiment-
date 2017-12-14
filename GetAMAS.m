function aMAS=GetAMAS
PsychDefaultSetup(2);
LoadPsychHID();
addpath('functions'); %import functions
addpath('Psychtoolbox');
devMode=1;
 subject = SubjectPrompt();
  results.startTime = clock;
 if ~exist([pwd, '/aMAS'], 'dir') %creates folder named data if such folder doesnt exits
    mkdir (pwd, '/aMAS');
 end
outf = sprintf('%s/%s/%s-%4d%02d%02d-%02d%02d.mat', pwd, 'aMAS', subject, results.startTime(1:5)); 

  
   PsychDefaultSetup(2);
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
    
 ifi = Screen('GetFlipInterval', window); 
 
 

        questions ={'Having to use the tables in the back of a math book.';...
            'Thinking about an upcoming math test 1 day before.';...
            'Watching a teacher work an algebraic equation on the blackboard.';...
            'Taking an examination in a math course.';...
            'Being given a homework assignment of many difficult problems that is due the next class meeting.';...
            'Listening to a lecture in math class.';...
            'Listening to another student explain a math formula.';...
            'Being given a "pop" quiz in math class.';...
            'Starting a new chapter in a math book.'};
        

        Screen('TextSize',window,24);
        DrawFormattedText(window, ['Please rate each item below in terms of how anxious you would feel during the event specified. Press [SPACE] to start.'], 'center', 'center', [1 1 1], 65,[],[],2);
        Screen('Flip', window);
        KeyWait(2);
        WaitSecs(1);
        

        
        % Make a base Rect of 200 by 200 pixels
        baseRect = [0 0 100 100];
        
        % Screen X positions of our three rectangles
        squareXpos = [screenXpixels * 0.30 screenXpixels * 0.40 screenXpixels * 0.50 screenXpixels * 0.60 screenXpixels * 0.70];
        numSqaures = length(squareXpos);
        
        % Set the colors to Red, Green and Blue
        
        % Make our rectangle coordinates
        allRects = nan(4, numSqaures);
        for i = 1:numSqaures
            allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
            if i == 1 || i == 5
                allRects(:, i) = CenterRectOnPointd(baseRect .* [0 0 2.2 1], squareXpos(i), yCenter);
            end
            disp(allRects);
        end
        
        allColors = [1 0 0; 0 1 0; 0 0 1];
        
        % Define red and blue
        offSquare = [1 1 1]/10;
        onSquare = [1 1 1]/2;
        
        % Here we set the initial position of the mouse to be in the centre of the
        % screen
        SetMouse(xCenter, yCenter, window);
        
        % Sync us and get a time stamp
        vbl = Screen('Flip', window);
        waitframes = 1;
        
        % Maximum priority level
        topPriorityLevel = MaxPriority(window);
        Priority(topPriorityLevel);
        
        % Loop the animation until a key is pressed
        buttons = 0;
        Screen('TextFont', window, 'Ariel');
        Screen('TextSize', window, 30);
        [~, ~, textbound1] = DrawFormattedText(window, '1 (low anxiety)', sum(allRects([1 3],1))/2, sum(allRects([2 4],1))/2 , white);
        [~, ~, textbound2] = DrawFormattedText(window, '2', sum(allRects([1 3],1))/2, sum(allRects([2 4],1))/2 , white);
        [~, ~, textbound3] = DrawFormattedText(window, '3', sum(allRects([1 3],1))/2, sum(allRects([2 4],1))/2 , white);
        [~, ~, textbound4] = DrawFormattedText(window, '4', sum(allRects([1 3],1))/2, sum(allRects([2 4],1))/2 , white);
        [~, ~, textbound5] = DrawFormattedText(window, '5 (high anxiety)', sum(allRects([1 3],1))/2, sum(allRects([2 4],1))/2 , white);
        
        q = 1;
        buttons = 0;
        left = 0;
        centre = 0;
        right = 0;
        selected = 0;
        while q<=length(questions)
            
            clear buttons
            % Get the current position of the mouse
            [x, y, buttons] = GetMouse(window);
            
            % Center the rectangle on the centre of the screen
            
            % See if the mouse cursor is inside the square
            one = IsInRect(x, y, allRects(:,1));
            two = IsInRect(x, y, allRects(:,2));
            three = IsInRect(x, y, allRects(:,3));
            four = IsInRect(x, y, allRects(:,4));
            five = IsInRect(x, y, allRects(:,5));
            
            if one == 1
                allColors(:,1) = onSquare;
            else
                allColors(:,1) = offSquare;
            end
            
            if two == 1
                allColors(:,2) = onSquare;
            else
                allColors(:,2) = offSquare;
            end
            
            if three == 1
                allColors(:,3) = onSquare;
            else
                allColors(:,3) = offSquare;
            end
            
            if four == 1
                allColors(:,4) = onSquare;
            else
                allColors(:,4) = offSquare;
            end
            
            
            if five == 1
                allColors(:,5) = onSquare;
            else
                allColors(:,5) = offSquare;
            end

            Screen('FillRect', window, allColors, allRects)
   
            DrawFormattedText(window, questions{q}, 'center', yCenter-300, [1 1 1], 70, [], [], 2);

            DrawFormattedText(window, '1 (low anxiety)', (sum(allRects([1 3],1))/2) - diff(textbound1([1,3]))/2, (sum(allRects([2 4],1))/2) + (diff(textbound1([2,4]))/4) , white);
            DrawFormattedText(window, '2', (sum(allRects([1 3],2))/2) - diff(textbound2([1,3]))/2, (sum(allRects([2 4],2))/2) + (diff(textbound2([2,4]))/4) , white);
            DrawFormattedText(window, '3', (sum(allRects([1 3],3))/2) - diff(textbound3([1,3]))/2, (sum(allRects([2 4],3))/2) + (diff(textbound3([2,4]))/4) , white);
            DrawFormattedText(window, '4', (sum(allRects([1 3],4))/2) - diff(textbound4([1,3]))/2, (sum(allRects([2 4],4))/2) + (diff(textbound4([2,4]))/4) , white);
            DrawFormattedText(window, '5 (high anxiety)', (sum(allRects([1 3],5))/2) - diff(textbound5([1,3]))/2, (sum(allRects([2 4],5))/2) + (diff(textbound5([2,4]))/4) , white);

            % Draw a white dot where the mouse is
            Screen('DrawDots', window, [x y], 10, white, [], 2);
            
            % Flip to the screen
            vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            
            if any(buttons) == 1 && (one ==1||two==1||three==1||four==1||five==1)
                aMAS(q,:) = [(one * 1) + (two * 2) + (three * 3) +  (four * 4) + (five * 5)];
                q = q + 1;
                left = 0;
                right = 0;
                centre= 0;
                clear buttons 
                WaitSecs(.2);
            end
         
        end
        Exit();
        
     save(outf,'aMAS')

 
     end

    