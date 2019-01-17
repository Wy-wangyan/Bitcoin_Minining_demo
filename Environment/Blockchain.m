classdef Blockchain
    
    properties 
        blockchain
    end

    methods 
        

        function blockChain = addBlock(obj, newblock, blockChain)         
            blockChain.blockchain(1,end+1) = newblock;
        end
        
        function blockChain = runBlockchain(obj, numBlocks, blockChainMng)
            assert(isa(blockChainMng,"Blockchain"));
            blockChain = Blockchain;
            newBlock = Block;
            blockMng = Block;
            memPool = blockMng.genMemPool(100);
            blockChain.blockchain = blockMng.genesisBlock();
            if(numBlocks>1)
                for i = 1:numBlocks-1
                    newBlock = blockMng.mining(memPool, blockChain, 1);
                    while blockChainMng.validate_block(newBlock,blockChain.blockchain(1,end))~= true
                        newBlock = blockMng.mining(memPool, blockChain, 1);
                    end
                    blockChain = blockChainMng.addBlock(newBlock,blockChain)
                end
            end
            disp("Blockchain after mined:");
            for i = 1:size(blockChain.blockchain,2)
                blockChain.blockchain(1,i)
            end
        end
        % blockChain.blockchain(1,end)
        function valid = validate_block(obj,new_block, prev_block)
            assert(isa(new_block, 'Block'));
            assert(isa(prev_block, 'Block'));
            blockMng = Block;
            
            % FIXME check for correct hash (with 0s)
            if ~(bin2dec(blockMng.hex256BinString(new_block.hash(1:new_block.blockheader.Bits))) == 0)
                valid = false;
                return;
            end
            if ~strcmp(prev_block.hash, new_block.blockheader.hashPrevBlock)
                valid = false;
                return;
            end
            
            if ~strcmp(new_block.hash, blockMng.calculateBlockHash(new_block))
                valid = false;
                return;
            end
            valid = true;
        end    
    end
end