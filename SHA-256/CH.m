function output = CH(x,y,z)
%myFun - Description: CH function
%
% Syntax: output = CH(input)
%
% Long description
    output = bitxor(x&y, ~x&z);
end