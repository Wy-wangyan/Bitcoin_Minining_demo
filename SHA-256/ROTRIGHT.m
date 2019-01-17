function output = ROTRIGHT(word, pos)
%myFun - Description
%
% Syntax: output = ROTRIGHT(word, pos)
%
% Long description
    output=zeros(1,length(word));
    output(pos+1:end)=word(1:end-pos);
    output(1:pos) = word(end-pos+1:end);