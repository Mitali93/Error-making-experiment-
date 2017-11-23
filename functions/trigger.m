function trigger(io, byte)
    
outp(io.address,byte);
    % read back the value written to the printer port above
    datum=inp(address);
    
    %reset to 0
    WaitSecs(0.02);
    byte = 0;
    outp(address,byte);
    datum=inp(address);
end