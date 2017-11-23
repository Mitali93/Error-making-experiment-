function DrawDiam (screen, color)
    
    points = [screen.ctrx-30, screen.ctry; 
        screen.ctrx, screen.ctry+50; 
        screen.ctrx+30, screen.ctry;
        screen.ctrx, screen.ctry-50];
    Screen('FillPoly', screen.w, color, points); %draw square at the centre of the screen
end
