function [numblock, blocks] = padder(msg)
%myFun - Description: This function padds the input message and splits it into array of block (512-bit)
%
% Syntax: [numblock, blocks] = padder(msg)
%
% Long description
    l = length(msg)*8;
    padded = [];
    numblock = 1;
    count = 0;
    
    % Append padded array from input message
    for i = 1:length(msg)
        count = count + 1;
        padded = strcat(padded, dec2bin(msg(i),8));
        if(count == 64)
            count = 0;
            numblock = numblock+1;
        end
    end
    % Assign to next bit is 1
    padded(end+1) = '1'; 
    % Padded is a string with only char '0' and '1' now.
    num0 = mod(447-l,512); % number of '0' character will be add to padded
    for i = 1:num0
        padded(end+1)='0';
    end
    % With last 64 bits we will express length
    lenlast = reshape(dec2bin(l, 64),1,[]);
    % Append decimal length
    padded(end+1:end+64) = lenlast;
    out = logical(padded(:)'-'0');
    len = length(padded);
    countfull = 0; % To check ? added full one block.
    countblocks = 0; % Number of current added blocks.
    for i = 1:len
        blocks(countblocks+1,countfull+1) = out(i);
        countfull = countfull+1;
        if countfull == 512 
            countfull = 0;
            countblocks = countblocks + 1;
        end
    end
end