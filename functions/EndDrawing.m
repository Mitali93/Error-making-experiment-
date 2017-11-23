
function EndDrawing (screen)
  Screen('DrawingFinished', screen.w);
  Screen('Flip', screen.w);
end
