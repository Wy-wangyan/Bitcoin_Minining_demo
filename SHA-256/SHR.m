function output = SHR(word, pos)
%myFun - Description
%
% Syntax: output = SHR(word, pos)
%
% Long description
    output = zeros(1, length(word));
    output(pos+1: end) = word(1:end-pos);
end