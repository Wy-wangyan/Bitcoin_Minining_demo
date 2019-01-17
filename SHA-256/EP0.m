function output = EP0(x)
%myFun - Description: EP0 function
%
% Syntax: output = EP0(x)
%
% Long description
    output=bitxor(bitxor(ROTRIGHT(x,2),ROTRIGHT(x,13)), ROTRIGHT(x,22));
end