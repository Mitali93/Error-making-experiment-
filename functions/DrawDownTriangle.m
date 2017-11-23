function DrawDownTriangle (screen, color)
  downTriangle = [screen.ctrx+30 screen.ctry-30; screen.ctrx-30 screen.ctry-30; screen.ctrx screen.ctry+30];
  Screen('FillPoly', screen.w, color, downTriangle); %draw triangle pointing down at centre of the screen
end

  
