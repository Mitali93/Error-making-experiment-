function WaitKey(device)
KbQueueCreate(device)
KbQueueStart(device)
pressed = 0;
KbQueueFlush(device,4);
while pressed == 0
    [ pressed, ~] = KbQueueCheck(device); 
end
KbQueueFlush(device);

end