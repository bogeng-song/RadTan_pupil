function m2 = upsample_raw(m)
    N=length(m);
    j=1;
    a=zeros(1,N);
    for i=1:N-1
        a(j)=(m(i)+m(i+1))/2;
        j=j+1;
    end
    m2=[m;a];
    m2=reshape(m2,1,N+length(a));
    m2=m2(1:length(m2)-1);
end