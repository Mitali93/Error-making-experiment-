function DrawPoly1 (screen, color)
    
    points = [screen.ctrx+30 screen.ctry+30;
        screen.ctrx+30 screen.ctry-30;
        screen.ctrx-30 screen.ctry+30
        screen.ctrx-30 screen.ctry-30];
    Screen('FillPoly', screen.w, color, points);
end
       