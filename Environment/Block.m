classdef Block
    properties
        magic_no 
        blocksize 
        blockheader
        transaction_counter
        transactions
        hash
    end
    methods

        function block = initBlock(varargin)
            if nargin == 2
                block = Block;
                block.magic_no = varargin{2}.magic_no;
                block.blocksize = varargin{2}.blocksize;
                block.blockheader = varargin{2}.blockheader;
                block.transaction_counter = varargin{2}. transaction_counter;
                block.transactions = varargin{2}.transactions;
            elseif nargin == 6
                block = Block;
                block.magic_no = varargin{2};
                block.blocksize = varargin{3};
                block.blockheader = varargin{4};
                block.transaction_counter = varargin{5};
                block.transactions = varargin{6};
            else
                error('Block creation requires either struct input or five input argument.');
            end
        end
        
        function block = genesisBlock(obj)
            block = Block;
            
            blockMng = Block;
            blockHeaderMng = BlockHeader;
            
            magic_no = uint32(bi2de(hexToBinaryVector('D9B4BEF9')));
            blocksize = uint32(8388608);
            blockheader = BlockHeader;
            
            bh_Version = uint32(131072); % Ver2.0
            bh_hashPrevBlock = '0000000000000000000000000000000000000000000000000000000000000000';
            bh_hashMerkleRoot = '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b';
            bh_Time = posixtime(datetime);
            bh_Bits = 2;
            bh_Nonce = 2083236893;
            
            
            blockheader = blockHeaderMng.init_BlockHeader(bh_Version,bh_hashPrevBlock,bh_hashMerkleRoot,bh_Time,bh_Bits,bh_Nonce);
            
            transaction_counter = 1;
            transactions = '736B6E616220726F662074756F6C69616220646E6F63657320666F206B6E697262206E6F20726F6C6C65636E61684320393030322F6E614A2F33302073656D695420656854';
            transactions = lower(transactions);
            block = blockMng.initBlock(magic_no,blocksize,blockheader,transaction_counter, transactions);
            hash = blockMng.calculateBlockHash(block);
            block.hash = hash;
        end
        
        function thisBlock = mining(obj, memPool, blockChain, nBits)
            
            assert(isa(blockChain,'Blockchain'));
            thisBlock = Block;
            prevBlock = blockChain.blockchain(1,end);
            blockMng = Block;
            blockHeaderMng = BlockHeader;
          
            thisBlock.magic_no = uint32(bi2de(hexToBinaryVector('D9B4BEF9')));
            thisBlock.blocksize = uint32(8388608);            
            numtrans = ((size(memPool,1)-mod(size(memPool,1),2))/2);
            thisBlock.transactions=blockMng.makeCandidate_Block(memPool, numtrans);
            
            %Some information for BlockHeader
            bh_Version = uint32(131072); % Ver2.0
            bh_hashPrevBlock = prevBlock.hash;
            bh_hashMerkleRoot = blockMng.merkle_root_calculate(thisBlock.transactions);
            bh_Time = posixtime(datetime);
            bh_Bits = nBits;
            bh_Nonce = 0;
            % init information for BlockHeader
            blockheader = blockHeaderMng.init_BlockHeader(bh_Version,bh_hashPrevBlock,bh_hashMerkleRoot,bh_Time,bh_Bits,bh_Nonce);
            
            thisBlock.blockheader = blockheader;
            thisBlock.transaction_counter = numtrans;
       
%             disp(blockMng.toBinString(thisBlock));
            thisBlock.hash = blockMng.calculateBlockHash(thisBlock);
            
            while(bin2dec(blockMng.hex256BinString(thisBlock.hash(1:bh_Bits))) ~= 0)
                if(thisBlock.blockheader.Nonce < 4294967295)
                    thisBlock.blockheader.Nonce = thisBlock.blockheader.Nonce + 1;
                elseif thisBlock.blockHeader.Time ~= uint32(posixtime(datetime)) 
                    thisBlock.blockheader.Time = uint32(posixtime(datetime));
                    thisBlock.blockheader.Nonce = 0;
                else
                    numtrans = numtrans + 1;
                    thisBlock.transactions=blockMng.makeCandidate_Block(memPool, numtrans);
                    thisBlock.blockheader.hashMerkleRoot = blockMng.merkle_root_calculate(thisBlock.transactions);
                    thisBlock.transaction_counter = numtrans;
                    thisBlock.blockheader.Nonce = 0;
                end
                thisBlock.hash = blockMng.calculateBlockHash(thisBlock);
                thisBlock
            end

            memPool = memPool(numtrans+1:end,:);
            memPool(end+1:end+numtrans,:)= blockMng.genMemPool(numtrans);
        end
        
        function strOut = toBinString(obj, block)
            assert(isa(block,'Block'));
            bhManager = BlockHeader;
            blockMng = Block;
            strOut = [];
            strOut = strcat(strOut,dec2bin(block.magic_no,32));
%             disp(dec2bin(block.magic_no,32));
%             disp(length(dec2bin(block.magic_no,32)));
            strOut = strcat(strOut,dec2bin(block.blocksize,32));
%             disp(dec2bin(block.blocksize,32));
%             disp(length(dec2bin(block.blocksize,32)));
            strOut = strcat(strOut,bhManager.toBinString(block.blockheader));
%             disp(bhManager.toBinString(block.blockheader));
%             disp(length(bhManager.toBinString(block.blockheader)));
            strOut = strcat(strOut,dec2bin(block.transaction_counter,32));
%             disp(dec2bin(block.transaction_counter,32));
%             disp(length(dec2bin(block.transaction_counter,32)));
            strOut = strcat(strOut,blockMng.transListToBinString(block.transactions));
%             disp(blockMng.transListToBinString(block.transactions));
%             disp(length(blockMng.transListToBinString(block.transactions)));
        end
        
        function hash = calculateBlockHash(obj, block)
            assert(isa(block,'Block'));
            blockMng = Block;
            hash = blockMng.calculateHash(blockMng.binStringToHexString(block.toBinString(block)));          
        end  
        
        function strOut = transListToBinString(obj,transList)
            strOut = [];
            blockMng = Block;
            for i = 1:size(transList,1)
                strOut = strcat(strOut, blockMng.hex256BinString(transList(i)));
            end
        end
        
        function memPool = genMemPool(obj, num_trans)
            memPool = [];
            for i = 1:num_trans
                memPool(end+1,:) = sha_256(char(ceil(rand(1,10).*255)));
            end
            memPool = char(memPool);
        end
        
        function candidateBlock = makeCandidate_Block(obj, memPool, numTrans)
            if(numTrans <= size(memPool,1))
                candidateBlock = [];
                candidateHashBlock = [];
                block = Block;
                for i = 1:numTrans
                    candidateBlock(end+1,:) = memPool(i,:);
%                     candidateHashBlock(end+1,:) = block.calculateHash(memPool(i,:));
                end
                candidateBlock = char(candidateBlock);
%                 candidateHashBlock = char(candidateHashBlock);
            else
                error("numTrans must lower than number transaction in mempool");
            end
        end
        
        function buff_hash = merkle_root_calculate(varargin)
            block = Block;
            buff_hash = [];
            merkle_root = 0;
            for i = 1:size(varargin{2},1)
                buff_hash(end+1,:) = block.calculateHash(char(varargin{2}(i,:)));
            end
        
            while size(buff_hash, 1)>1
                if(mod(size(buff_hash, 1),2)~=0)
                    buff_hash(end+1,:) = buff_hash(end,:);
                end
                sub_buff = [];
                for i = 1:2:size(buff_hash, 1)-1
                    sub_buff(end+1,:)=block.calculateHash(strcat(buff_hash(i,:),buff_hash(i+1,:)));
                end
                buff_hash = char(sub_buff);
            end
         
        end
        
        function binStr = hex256BinString(obj,hexStr)
           binStr = hexToBinaryVector(hexStr);
           binStr = [zeros(1,256-length(binStr)), binStr];
           binStr = num2str(binStr);
           binStr(isspace(binStr)) = '';
        end
% 
%         function hash = calculateHash_1(obj, msg)
%             assert(isa(msg,'char'));
%             block = Block;
%             sha256hasher = System.Security.Cryptography.SHA256Managed
%             hash_first = sha_256(msg);
%             hash = sha_256(block.hexaToString(hash_first));
%         end
        
        function hash = calculateHash(obj, msg)
            assert(isa(msg,'char'));
            block = Block;
            hash = sha_256(sha_256(msg));
        end


        function strOut = hexaToString(obj,hexIn)
            if mod(numel(hexIn),2) == 0
                strOut = [];
                decOut = [];
                i = 1;
                while i<=numel(hexIn)
                    if uint8(hex2dec(hexIn(1,i:i+1)))>0
                        decOut(1,end+1) = uint8(hex2dec(hexIn(1,i:i+1)));
                    end
                    i = i+2;
                end
                strOut = char(decOut);
            else
                error('Hexa length must be even')
            end
        end
        
%         function strOut = hexaToString_1(obj,hexIn)
%             if mod(numel(hexIn),2) == 0
%                 strOut = [];
%                 decOut = [];
%                 i = 1;
%                 while i<=numel(hexIn)
%                     strOut = strcat(strOut,char(hex2dec(hexIn(1,i:i+1))));
%                     i = i+2;
%                 end
%                 strOut = char(strOut);
%             else
%                 error('Hexa length must be even')
%             end
%         end
        
        
        function strOut = binaryStringToString(obj,strIn) % Input is a binary string
            strOut = [];
            buf = [];
            if mod(numel(strIn),8) == 0
                i=1;
                while i <= numel(strIn)
                    for j = 0:7
                        buf(1,end+1) = strIn(1,i+j);
                    end
                    i = i+8;
                    val_cur = uint8(bin2dec(char(buf)));
                    if val_cur ~= 32
                        strOut = strcat(strOut,char(val_cur));
                    else
                        strOut = strcat(strOut,{' '});
                    end
                    buf = [];
                end
                strOut = char(strOut);
            else
                error('The length of BinaryString must be multiple of 8!!')
            end
        end
        
        function strOut = StringToBinaryString(obj,strIn)
            uint8_Str = uint8(strIn);
            binValueArr = dec2bin(uint8_Str,8);
            strOut = '';
            for i = 1:size(binValueArr,1)
                strOut = strcat(strOut,binValueArr(i,:));
            end
        end
        
        function strOut = binStringToHexString(obj,strIn)
            switch (mod(length(strIn),4))
                case 1
                    strIn = strcat('000',strIn);
                case 2
                    strIn = strcat('00',strIn);
                case 3
                    strIn = strcat('0',strIn);
                otherwise
            end
            strOut = [];
            for i = 1:4:length(strIn)
                switch strIn(i:i+3)
                    case '0000'
                        strOut = strcat(strOut,'0');
                    case '0001'
                        strOut = strcat(strOut,'1');
                    case '0010'
                        strOut = strcat(strOut,'2');
                    case '0011'
                        strOut = strcat(strOut,'3');
                    case '0100'
                        strOut = strcat(strOut,'4');
                    case '0101'
                        strOut = strcat(strOut,'5');
                    case '0110'
                        strOut = strcat(strOut,'6');
                    case '0111'
                        strOut = strcat(strOut,'7');
                    case '1000'
                        strOut = strcat(strOut,'8');
                    case '1001'
                        strOut = strcat(strOut,'9');
                    case '1010'
                        strOut = strcat(strOut,'a');
                    case '1011'
                        strOut = strcat(strOut,'b');
                    case '1100'
                        strOut = strcat(strOut,'c');
                    case '1101'
                        strOut = strcat(strOut,'d');
                    case '1110'
                        strOut = strcat(strOut,'e');
                    case '1111'
                        strOut = strcat(strOut,'f');
                end
            end
        end
    end
end
