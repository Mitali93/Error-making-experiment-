function CenterText (screen, text, yoff)
  clr = [255 255 255];
  tw = RectWidth(Screen('TextBounds', screen.w, text));
  x = screen.ctrx - tw/2;
  y = screen.ctry + yoff;
  Screen('DrawText', screen.w, text, x, y, clr);
end
