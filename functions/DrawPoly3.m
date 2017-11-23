function DrawPoly3 (screen, color)
    
    points = [screen.ctrx screen.ctry+30; 
        screen.ctrx+30 screen.ctry-30; 
        screen.ctrx+20 screen.ctry-30;
        screen.ctrx screen.ctry+20;
        screen.ctrx-20 screen.ctry-30;
        screen.ctrx-30 screen.ctry-30];
    Screen('FillPoly', screen.w, color, points);
end
       