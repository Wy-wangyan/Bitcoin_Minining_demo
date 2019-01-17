% function strOut = TestFunc(strIn)
% 
%         reshape(strIn, ceil(numel(strIn)/8), 8);
% 
%     decimalValues = bin2dec(strIn);
%     strOut = char(decimalValues');
% end
function strOut = TestFunc(strIn)
    assert(isa(strIn,'char'));
    uint8_Str = uint8(strIn);
    binValueArr = dec2bin(uint8_Str,8);
    strOut = '';
    for i = 1:size(binValueArr,1)
        strOut = strcat(strOut,binValueArr(i,:));
    end
end