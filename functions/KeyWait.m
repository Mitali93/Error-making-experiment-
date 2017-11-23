
function key = KeyWait (waitFor)
  % Wait for a key press and return the name
  if exist('waitFor')
    % wait for all keys to be released before accepting keypress
    [secs, keyCode, keyDelta] = KbWait([], waitFor);
  else
    [secs, keyCode, keyDelta] = KbWait ();
  end
  key = KbName(keyCode);
end
