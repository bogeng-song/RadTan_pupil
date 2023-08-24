%to find point 
function [t1,t2,t3,y_fil] = infl(rate,time,pa_pass,temporalthresh,onset,stepsize)
y_fil = lowpass(rate,pa_pass);
time1 = time./(2500/length(rate));
temporalthresh=temporalthresh/(2500/length(rate));
m = min(rate);

d = nan(1, length(y_fil)/stepsize); % derivative
for i=1:(length(y_fil)/stepsize)
    try
        temp = mean(diff(y_fil(onset:onset+temporalthresh)));
        d(i) = temp;
        onset = onset + stepsize;
    catch
        d(i) = d(i);
    end
end

[~, idx] = min(d(time1(1):time1(1)+800));
tt=sqrt(var(rate(time1(1):time1(2))));
t1 = idx + time1(1);
% find where slope is 0 after this
temp = d(t1:time1(2))>0 & rate(t1:time1(2)) - m <tt/2;
t2 = find(temp, 1, 'first') + t1;

temp2 = d(t2:time1(2))<0 & rate(t2:time1(2)) - m <tt/2;
t3 = find(temp2, 1, 'last') + t2;


end