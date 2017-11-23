function DrawTrap (screen, color)
    
    points = [screen.ctrx+40 screen.ctry+30; 
        screen.ctrx-40 screen.ctry+30; 
        screen.ctrx-20 screen.ctry-30;
        screen.ctrx+20 screen.ctry-30];
    Screen('FillPoly', screen.w, color, points);
end
