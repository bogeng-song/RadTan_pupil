%% plot the predict data
function [Ycal_total,X1,X2] = plot_model_data(para,samplerate)
y_length = 5000 * samplerate/1000;
Ycal_total = nan(size(para,1),y_length);
for ro = 1 : size(para,1)
    pp = para(ro,:);
    window =  pp([12,13]);
    eventtimes = pp([14,15,16]);
    boxtimes = {[0,pp(17)]};
    tmaxval = pp(8);
    latvals = pp([4,5,6]);
    ampvals = pp([1,2,3]);
    boxampvals = pp(7);



    sfact = samplerate/1000;
    time = window(1):1/sfact:window(2);
    
    n = 10.1;
    
    X1 = nan(length(eventtimes),length(time));
    X2 = nan(length(boxtimes),length(time));
    for xx = 1:size(X1,1)
        
        h = pupilrf(time,n,tmaxval,eventtimes(xx)+latvals(xx));
        temp = conv(h,ampvals(xx));
        X1(xx,:) = temp;
        
    end
    
    for bx = 1:size(X2,1)
        
        h = pupilrf(time,n,tmaxval,boxtimes{bx}(1));
        temp = conv(h,(ones(1,(boxtimes{bx}(2)-boxtimes{bx}(1))*sfact+1)));
        temp = (temp/max(temp)) .* boxampvals(bx);
        X2(bx,:) = temp(1:length(time));
        
    end
    
    X = [X1 ; X2];
    Ycalc = sum(X,1); 
    Ycal_total(ro,1 : size(Ycalc,2)) = Ycalc;
end


end