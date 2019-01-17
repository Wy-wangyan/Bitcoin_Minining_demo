function SHA_256_final(ctx, hash)
%myFun - Description: Find output function
%
% Syntax: output = SHA_256_final(ctx, )
%
% Long description
    i=ctx.datalen;
    if(ctx.datalen<56)
        ctx.data(i+1)=hex2dec('80');
        i=i+1;
        while i<57
            ctx.data(i)=0;
            i=i+1;
        end
    end
    else
        ctx.data(i+1)=hex2dec('80');
        i=i+1;
        while i<65
            ctx.data(i+1)=0;
            i=i+1;
        end
        SHA_256_transform(ctx,ctx.data);
        ctx.data=zeros(1,56);
    end

    ctx.bitlen=ctx.bitlen+(ctx.datalen*8);
    ctx.data(64)=bitget(ctx.bitlen,8:-1:1);
    ctx.data(63)=bitget(bitsra(ctx.bitlen,8),8:-1:1);
    ctx.data(62)=bitget(bitsra(ctx.bitlen,16),8:-1:1);
    ctx.data(61)=bitget(bitsra(ctx.bitlen,24),8:-1:1);
    ctx.data(60)=bitget(bitsra(ctx.bitlen,32),8:-1:1);
    ctx.data(59)=bitget(bitsra(ctx.bitlen,40),8:-1:1);
    ctx.data(58)=bitget(bitsra(ctx.bitlen,48),8:-1:1);
    ctx.data(57)=bitget(bitsra(ctx.bitlen,56),8:-1:1);
    SHA_256_transform(ctx,ctx.data);

    for i = 1:4
        hash(i)      = bitsra(ctx.state(1),(24 - i * 8)) & 0x000000ff;
		hash(i + 4)  = bitsra(ctx.state(2),(24 - i * 8)) & 0x000000ff;
		hash(i + 8)  = bitsra(ctx.state(3),(24 - i * 8)) & 0x000000ff;
		hash(i + 12) = bitsra(ctx.state(4),(24 - i * 8)) & 0x000000ff;
		hash(i + 16) = bitsra(ctx.state(5),(24 - i * 8)) & 0x000000ff;
		hash(i + 20) = bitsra(ctx.state(6),(24 - i * 8)) & 0x000000ff;
		hash(i + 24) = bitsra(ctx.state(7),(24 - i * 8)) & 0x000000ff;
		hash(i + 28) = bitsra(ctx.state(8),(24 - i * 8)) & 0x000000ff;
    end
end