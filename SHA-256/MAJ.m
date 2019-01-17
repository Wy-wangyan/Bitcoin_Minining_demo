function output = MAJ(x, y, z)
%myFun - Description: Maj function
%
% Syntax: output = MAJ(x, y, z)
% 
% Long description
    output = bitxor(bitxor(x&y, x&z),y&z);  
end