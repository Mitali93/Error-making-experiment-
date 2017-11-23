function screen = MAinitGraphics()

 KbName('UnifyKeyNames'); %unify key names across platforms
 
 % grab a monitor to put stuff on
  screen.s = max(Screen('Screens'));
  screen.rate = round(FrameRate(screen.s));
  screen.bg = [0 0 0]; %background color
  [screen.w, screen.rect] = Screen('OpenWindow', screen.s, screen.bg);
  screen.ctrx = RectWidth(screen.rect) / 2;
  screen.ctry = RectHeight(screen.rect) / 2;
  
  screen.cueSize = 50; %pixels
  
  % some other settings
  Screen('BlendFunction', screen.w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  Screen('Preference', 'SkipSyncTests', 0); %delete when testing
  HideCursor;
  Priority(MaxPriority(screen.w));

  disp('Graphics initialised.');
end