function DrawPoly2 (screen, color)
    
    points = [screen.ctrx-30 screen.ctry+30; 
        screen.ctrx+30 screen.ctry+30; 
        screen.ctrx+30 screen.ctry-30;
        screen.ctrx+20 screen.ctry-30;
        screen.ctrx+20 screen.ctry-1;
        screen.ctrx+10 screen.ctry-1;
        screen.ctrx+10 screen.ctry-30;
        screen.ctrx-10 screen.ctry-30;
        screen.ctrx-10 screen.ctry-1;
        screen.ctrx-20 screen.ctry-1;
        screen.ctrx-20 screen.ctry-30;
        screen.ctrx-30 screen.ctry-30];
    
    Screen('FillPoly', screen.w, color, points);
end
       