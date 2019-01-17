function out = mod32add( varargin )
    % Function mod32add : Performs addition modulo 32.(§3.2.1)
    out = 0; % initialise return arguments
    for i = 1:length( varargin ) % Calculate addition
        out = out + fix2mod(varargin{i});
    end
    % Perform modulo 32 operation.
    out = dec2bin( mod( ( out ), 2^32 ),32 ) ;
    out = logical( out(:)'-'0' ); % Cast output to logical array.
end