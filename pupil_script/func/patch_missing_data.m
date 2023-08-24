function yl = patch_missing_data(segment_data,num)

if segment_data(1,2) == 0 
    sdddd = segment_data(segment_data(:,2)~=0,2);
    segment_data(1,2) = mean(sdddd(1:200));
end
if segment_data(size(segment_data,1),2) == 0 
    sdddd = segment_data(segment_data(:,2)~=0,2);
    segment_data(size(segment_data,1),2) = mean(sdddd((length(sdddd)-200):length(sdddd)));
end

asd=find(segment_data(:,2)==0);
diff = asd(2:size(asd)) - asd(1:(size(asd)-1));
seg_l = find(diff ~= 1);

ser_diff2 =  max(asd)+ num;
if ser_diff2 > (size(segment_data,1)-1)
    ser_diff2 = size(segment_data,1)-1;
end

ser_diff = min(asd)-num ; 
if ser_diff < 2
    ser_diff = 2;
end
if isempty(seg_l)
    segment_data((ser_diff) : (ser_diff2),2) = 0 ;
else
    for kk = 1 : (length(seg_l) + 1)

%         ser_diff2 =  max(asd)+ num;
%         if ser_diff2 > size(segment_data,1)
% 
%             ser_diff2 = size(segment_data,1);
%         end

        if kk == 1 

%             ser_diff = min(asd)-num ; 
%             if ser_diff < 1
%                 ser_diff = 1;
%             end

            segment_data((ser_diff) : (asd(seg_l(1))+ num),2) = 0 ; 

            if length(seg_l) > 1 
                poidl2 = asd(seg_l(kk)+1)-num;
                if poidl2 < 1 
                    poidl2 = 1;
                end
                segment_data(poidl2 : (asd(seg_l(kk+1))+ num),2) = 0 ; 
            end

        elseif kk == (length(seg_l) + 1)
            poidl = asd(seg_l(kk-1)+1)-num;
            if poidl < 1 
                poidl = 1;
            end
            segment_data(poidl : (ser_diff2),2) = 0 ; 
        else
            poidl3 = asd(seg_l(kk-1)+1)-num;
            if poidl3 < 1 
                poidl3 = 1;
            end

            segment_data(poidl3: (asd(seg_l(kk))+ num),2) = 0 ; 
        end
    end
end

yl = segment_data;

    
end