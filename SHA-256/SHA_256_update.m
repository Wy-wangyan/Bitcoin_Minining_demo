function SHA_256_update(ctx, data, len)
%myFun - Description: update with every block 64byte
%
% Syntax: output = SHA256_update(ctx, data, len)
%
% Long description
    for i=1:len
        ctx.data(ctx.datalen)=data(i);
        ctx.datalen=ctx.datalen+1;
        if ctx.datalen==64
            SHA_256_transform(ctx,ctx.data);
            ctx.bitlen=ctx.bitlen+512;
            ctx.datalen=0;
        end
    end
end