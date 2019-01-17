function output = SIG1(x)
%myFun - Description Sigma1 function
%
% Syntax: output = SIG1(x)
%
% Long description
    output = bitxor(bitxor(ROTRIGHT(x,17),ROTRIGHT(x,19)),SHR(x,10));
end