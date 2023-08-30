function yq = add_miss_value(segment_data)


if segment_data(1,2) == 0 
    segment_data(1,2) = mean(segment_data(segment_data(:,2)~=0,2));
end

if segment_data(size(segment_data,1),2) == 0 
    segment_data(size(segment_data,1),2) = mean(segment_data(segment_data(:,2)~=0,2));
end

yq = segment_data;
x = 1 : size(segment_data,1);





segment_data = [segment_data,x'];
segment_data_value_xq = segment_data(segment_data(:,2)==0,3);
segment_data_value_x = segment_data(segment_data(:,2)~=0,3);
segment_data_value_y = segment_data(segment_data(:,2)~=0,2);

s_yq = interp1(segment_data_value_x,segment_data_value_y,segment_data_value_xq,'linear');

sdf=~segment_data(:,2);
yq(sdf,2) = s_yq;
end