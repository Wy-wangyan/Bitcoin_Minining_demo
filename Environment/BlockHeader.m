classdef BlockHeader
    properties
        Version uint32 % Block version number
        hashPrevBlock  (1,256) logical % 256-bit hash of the previous block header
        hashMerkleRoot (1,256) logical  % 256-bit hash based on all of the transactions in the block
        Time uint32 = uint32(posixtime(datetime)) % Current timestamp as seconds since 1970-01-01T00:00 UTC
        Bits uint32 % Current target in compact format
        Nonce uint32 
    end
    methods
        function blockHeader = init_BlockHeader(varargin)
            if nargin == 2
                blockHeader.Version = varargin{2}.Version;
                blockHeader.hashPrevBlock = varargin{2}.hashPrevBlock;
                blockHeader.hashMerkleRoot = varargin{2}.hashMerkleRoot;
                blockHeader.Time = varargin{2}.Time;
                blockHeader.Bits = varargin{2}.Bits;
                blockHeader.Nonce = uint32(varargin{2}.Nonce);
                assert(isa(blockHeader.Nonce, 'uint32'));
            elseif nargin == 7
                blockHeader.Version = varargin{2};
                blockHeader.hashPrevBlock = varargin{3};
                blockHeader.hashMerkleRoot = varargin{4};
                blockHeader.Time = varargin{5};
                blockHeader.Bits = varargin{6};
                blockHeader.Nonce = uint32(varargin{7});
                assert(isa(blockHeader.Nonce, 'uint32'));
            else
                error('BlockHeader creation requires either struct input or six input argument.');
            end
        end
        
        function strOut = toBinString(obj, blockHeader)
            block = Block;
            strOut = [];
            strOut = strcat(strOut,dec2bin(blockHeader.Version,32));
            strOut = strcat(strOut,block.hex256BinString(blockHeader.hashPrevBlock));
            strOut = strcat(strOut,block.hex256BinString(blockHeader.hashMerkleRoot));
            strOut = strcat(strOut,dec2bin(blockHeader.Time,32));
            strOut = strcat(strOut,dec2bin(blockHeader.Bits,32));
            strOut = strcat(strOut,dec2bin(blockHeader.Nonce,32));
        end
end
end