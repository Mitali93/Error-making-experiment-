function DrawSquare (screen, color)
    original = [0 0 screen.cueSize screen.cueSize]; %top left corner of the screen
    
    rect_centre = OffsetRect(original, screen.ctrx-25, screen.ctry-25); %centre of the screen
    
    Screen('FillRect', screen.w, color, rect_centre); %draw square at the centre of the screen
end
