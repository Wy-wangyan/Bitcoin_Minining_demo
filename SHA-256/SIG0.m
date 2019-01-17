function output = SIG0(x)
%myFun - Description - Sigma0 function
%
% Syntax: output = myFun(x)
%
% Long description
    output = bitxor(bitxor(ROTRIGHT(x,7),ROTRIGHT(x,18)),SHR(x,3));
end