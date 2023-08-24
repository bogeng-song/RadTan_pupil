function timepoint = countfigure_new(MS,tab,samplerate)

ll = size(tab,1);
timepoint = nan(ll,2500);


for i = 1 : ll
    di = tab(i,8)-tab(i,2);
    if di > 2500 
        di = 2500;
    end
    timepoint(i,1:di) = 0;
end

or = 0;
for j = MS(:,10)'
    or = or + 1 ;
    m_start = floor(MS(or,8)*1000/samplerate);
    m_end = floor(MS(or,9)*1000/samplerate);
    timepoint(j,m_start:m_end) = 1 ;
end
    

 
end