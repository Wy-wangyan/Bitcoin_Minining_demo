function SHA_256_transform(ctx,data)
    % WORD a, b, c, d, e, f, g, h, i, j, t1, t2, m[64];
    j=1;
    m=zeros(1,64);
    for i = 1:16
        m(i)= bitor(bitor(bitshift(data(j),24),bitshift(data(j+1),16)),bitor(bitshift(data(j+2),8),data(j+3)));
        j = j+4;
    end
    for i=16:64
        m(i)=SIG1(m(i-1))+m(i-7)+SIG0(m(i-15))+m(i-16);
    end
    a=ctx.state(1);
    b=ctx.state(2);
    c=ctx.state(3);
    d=ctx.state(4);
    e=ctx.state(5);
    f=ctx.state(6);
    g=ctx.state(7);
    h=ctx.state(8);
    for i=1:64
        t1 = h + EP1(e) + CH(e,f,g) + k(i)+ m(i);
		t2 = EP0(a) + MAJ(a,b,c);
		h = g;
		g = f;
		f = e;
		e = d + t1;
		d = c;
		c = b;
		b = a;
		a = t1 + t2;
    end
    ctx.state(1)=ctx.state(1)+a;
    ctx.state(2)=ctx.state(2)+b;
    ctx.state(3)=ctx.state(3)+c;
    ctx.state(4)=ctx.state(4)+d;
    ctx.state(5)=ctx.state(5)+e;
    ctx.state(6)=ctx.state(6)+f;
    ctx.state(7)=ctx.state(7)+g;
    ctx.state(8)=ctx.state(8)+h;
end