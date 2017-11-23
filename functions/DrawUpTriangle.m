function DrawUpTriangle (screen, color)
    
    upTriangle =[screen.ctrx+30 screen.ctry+30; screen.ctrx-30 screen.ctry+30; screen.ctrx screen.ctry-30];
    
    Screen('FillPoly', screen.w, color, upTriangle); %draw triangle pointing up appearing in same position of +
end

