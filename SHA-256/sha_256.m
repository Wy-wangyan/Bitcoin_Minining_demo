function out = sha_256(msg)
%myFun - Description
% Function that implement the sha256 algorithm with out is a string output
% Input is msg is any strings.
% Syntax: out = sha_256(msg)
%
% Long description



% Step 1: Create some default values like default_hash and K array
    % Initial Hash Values(8 constant 32-bit words).
    default_hash = [
                    '6a09e667';
                    'bb67ae85';
                    '3c6ef372';
                    'a54ff53a';
                    '510e527f';
                    '9b05688c';
                    '1f83d9ab';
                    '5be0cd19'
                    ];
    % Constant value array (64 constant 32-bit words) to be used for the iteration t of the hash computation.
    K = [
        '428a2f98'; '71374491'; 'b5c0fbcf'; 'e9b5dba5'; 
        '3956c25b'; '59f111f1'; '923f82a4'; 'ab1c5ed5';
        'd807aa98'; '12835b01'; '243185be'; '550c7dc3'; 
        '72be5d74'; '80deb1fe'; '9bdc06a7'; 'c19bf174';
        'e49b69c1'; 'efbe4786'; '0fc19dc6'; '240ca1cc';
        '2de92c6f'; '4a7484aa'; '5cb0a9dc'; '76f988da';
        '983e5152'; 'a831c66d'; 'b00327c8'; 'bf597fc7';
        'c6e00bf3'; 'd5a79147'; '06ca6351'; '14292967';
        '27b70a85'; '2e1b2138'; '4d2c6dfc'; '53380d13'; 
        '650a7354'; '766a0abb'; '81c2c92e'; '92722c85';
        'a2bfe8a1'; 'a81a664b'; 'c24b8b70'; 'c76c51a3'; 
        'd192e819'; 'd6990624'; 'f40e3585'; '106aa070';
        '19a4c116'; '1e376c08'; '2748774c'; '34b0bcb5'; 
        '391c0cb3'; '4ed8aa4a'; '5b9cca4f'; '682e6ff3';
        '748f82ee'; '78a5636f'; '84c87814'; '8cc70208'; 
        '90befffa'; 'a4506ceb'; 'bef9a3f7'; 'c67178f2'
    ];
    % Step 2: Padding and Split padded message to block of 512 bits.
    %   Call M is array of blocks after padding and spliting.
    %        numblocks is number of blocks in M.
    %   Call function padder function to execute them
    [numblocks,M] = padder(msg);
    % Step 3: This is transform hash process and is the main process of this algorithm.
    W = zeros(64,32);
    H = zeros(8,32);
    for j = 1:8
        H(j,:)=hexToBinaryVector(default_hash(j,:),32);
    end
    for k = 1:numblocks
        for j = 1:16
            W(j,1:32)=M(k,(32*(j-1)+1:32*j));
        end
        for j = 17:64
            W(j,1:32)=mod32add(SIG1(W(j-2,:)),W(j-7,:),SIG0(W(j-15,:)),W(j-16,:));
        end 
        % Load present hash to a,b,c,d,e,f,g,h
        a = H(1,:); 
        b = H(2,:);
        c = H(3,:);
        d = H(4,:);
        e = H(5,:);
        f = H(6,:);
        g = H(7,:);
        h = H(8,:);
        % Calculating next hash
        for i = 1:64
            T1 = mod32add(h,EP1(e),CH(e,f,g),hexToBinaryVector(K(i,:),32),W(i,1:32));
            T2 = mod32add(EP0(a),MAJ(a,b,c));
            h = g;
            g = f;
            f = e;
            e = mod32add(d,T1);
            d = c;
            c = b;
            b = a;
            a = mod32add(T1,T2);
        end
        % Updating new hash
        H(1,:) = mod32add(H(1,:),a);
        H(2,:) = mod32add(H(2,:),b);
        H(3,:) = mod32add(H(3,:),c);
        H(4,:) = mod32add(H(4,:),d);
        H(5,:) = mod32add(H(5,:),e);
        H(6,:) = mod32add(H(6,:),f);
        H(7,:) = mod32add(H(7,:),g);
        H(8,:) = mod32add(H(8,:),h);

    end
    % Step 4: Calculate last hash and append it to the final output hexadecimal.
    out = binaryVectorToHex(horzcat(H(1,:),H(2,:),H(3,:),H(4,:),H(5,:),H(6,:),H(7,:),H(8,:)));
    out = lower(out);
end