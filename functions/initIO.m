function io = initIO() 
%% Initialize digital IO object
  
  % initialize access to the inpoutx64 low-level I/O driver
config_io;
% optional step: verify that the inpoutx64 driver was successfully initialized
global cogent;
if( cogent.io.status ~= 0 )
   error('inp/outp installation failed');
end

io.address = hex2dec('B010'); %address of parallel port
io.basebyte = 0; %make sure pins are all set to baseline 0
outp(address,basebyte);
io.datum=inp(address);
end