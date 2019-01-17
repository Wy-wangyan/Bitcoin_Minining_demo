function out = fix2mod( x )
    % Function fix2mod : Converts the input logical word to binary.
    out = num2str( x );
    out(isspace(out)) = '';
    out = bin2dec(out);
end