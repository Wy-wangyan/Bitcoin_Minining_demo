blockMng = Block;
blockChainMng = BlockChain;
numTrans = 100;
prevBlock = blockMng.genesisBlock();
memPool = blockMng.genMemPool(numTrans); % Make mempool for gen


blockMng.mining(thisBlock,prevBlock,memPool);