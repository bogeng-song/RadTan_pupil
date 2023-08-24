function m3 = upsample_raw_2(m)
    N=length(m);
    j=1;
    a=zeros(1,N);
    for i=1:N-1
        a(j)=(m(i)+m(i+1))/2;
        j=j+1;
    end
    m2=[m';a];
    m3=reshape(m2,N+length(a),1);
    m3 = m3(1:length(m3)-1);

end