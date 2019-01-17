function output = EP1(x)
    %myFun - Description: EP1 function
    %
    % Syntax: output = EP1(x)
    %
    % Long description
        output=bitxor(bitxor(ROTRIGHT(x,6),ROTRIGHT(x,11)), ROTRIGHT(x,25));
end