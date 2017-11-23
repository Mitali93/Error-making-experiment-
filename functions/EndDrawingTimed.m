
function time = EndDrawingTimed (screen)
  Screen('DrawingFinished', screen.w);
  time = Screen('Flip', screen.w);
end
