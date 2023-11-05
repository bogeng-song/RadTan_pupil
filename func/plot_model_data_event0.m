%% plot the predict data
function [Ycal_total,x1_sum,x2_sum] = plot_model_data_event0(para,samplerate)
Ycal_total = struct();
x1_sum = struct();
x2_sum = struct();
for ro = 1 : size(para,1)
    pp = para(ro,:);
    window =  pp([14,15]);
    eventtimes = pp([16,17,18,19]);
    boxtimes = {[0,pp(20)]};
    tmaxval = pp(10);
    latvals = pp([5,6,7,8]);
    ampvals = pp([1,2,3,4]);
    boxampvals = pp(9);



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
    t_name = ['trial',num2str(ro)];
    x1_sum.(t_name) = X1;
    x2_sum.(t_name) = X2;

    X = [X1 ; X2];
    Ycalc = sum(X,1); 
    Ycal_total.(t_name) = Ycalc;
end


end