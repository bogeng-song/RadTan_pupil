
result_path = 'C:\Users\18611\Desktop\Rad_Tan_script\sub02\';
filename = dir (result_path);

%% prepare data
fileline = 3 : 82 ;
car = [1:10,31:40,41:50,71:80] + 2;
obl = setdiff(fileline,car);

ss = 1 : 5 : 40;
% amp_value(3),lat_value(3),box_amp_value,t_max_value
car_05 = car(ss);
car_1 = car(ss+1);
car_2 = car(ss+2);
car_4 = car(ss+3);
car_8 = car(ss+4);

obl_05 = obl(ss);
obl_1 = obl(ss+1);
obl_2 = obl(ss+2);
obl_4 = obl(ss+3);
obl_8 = obl(ss+4);

car_05_value = [];
obl_05_value = [];
car_1_value = [];
obl_1_value = [];
car_2_value = [];
obl_2_value = [];
car_4_value = [];
obl_4_value = [];
car_8_value = [];
obl_8_value = [];


for ii = car_05
    name = [result_path,filename(ii).name];
    load (name)
    car_05_value = [car_05_value;tt_05_value];
end

for ii = car_1
    name = [result_path,filename(ii).name];
    load (name)
    car_1_value = [car_1_value;tt_1_value];
end

for ii = car_2
    name = [result_path,filename(ii).name];
    load (name)
    car_2_value = [car_2_value;tt_2_value];
end

for ii = car_4
    name = [result_path,filename(ii).name];
    load (name)
    car_4_value = [car_4_value;tt_4_value];
end

for ii = car_8
    name = [result_path,filename(ii).name];
    load (name)
    car_8_value = [car_8_value;tt_8_value];
end

for ii = obl_05
    name = [result_path,filename(ii).name];
    load (name)
    obl_05_value = [obl_05_value;tt_05_value];
end

for ii = obl_1
    name = [result_path,filename(ii).name];
    load (name)
    obl_1_value = [obl_1_value;tt_1_value];
end

for ii = obl_2
    name = [result_path,filename(ii).name];
    load (name)
    obl_2_value = [obl_2_value;tt_2_value];
end

for ii = obl_4
    name = [result_path,filename(ii).name];
    load (name)
    obl_4_value = [obl_4_value;tt_4_value];
end

for ii = obl_8
    name = [result_path,filename(ii).name];
    load (name)
    obl_8_value = [obl_8_value;tt_8_value];
end

car_05_mean = mean(car_05_value,1);
obl_05_mean = mean(obl_05_value,1);
car_1_mean = mean(car_1_value,1);
obl_1_mean = mean(obl_1_value,1);
car_2_mean = mean(car_2_value,1);
obl_2_mean = mean(obl_2_value,1);
car_4_mean = mean(car_4_value,1);
obl_4_mean = mean(obl_4_value,1);
car_8_mean = mean(car_8_value,1);
obl_8_mean = mean(obl_8_value,1);
%% figure plot

x = categorical({'car-05','car-1','car-2','car-4','car-8','obl-05','obl-1','obl-2','obl-4','obl-8'});
%amp_value
%x = 1 : 10;
y = [car_05_mean(1:3)',car_1_mean(1:3)',car_2_mean(1:3)',car_4_mean(1:3)',car_8_mean(1:3)', ...,
    obl_05_mean(1:3)',obl_1_mean(1:3)',obl_2_mean(1:3)',obl_4_mean(1:3)',obl_8_mean(1:3)'];

figure
c=bar(x,y);
set(c(1,1),'FaceColor','m','BarWidth',0.9,'DisplayName','event1');
set(c(1,2),'FaceColor','Y','BarWidth',0.9,'DisplayName','event2');
set(c(1,3),'FaceColor','b','BarWidth',0.9,'DisplayName','event3');
legend(c(1,1:3),{'event1','event2','event3'})
title('amplitude')

%latency 
y = [car_05_mean(4:6)',car_1_mean(4:6)',car_2_mean(4:6)',car_4_mean(4:6)',car_8_mean(4:6)', ...,
    obl_05_mean(4:6)',obl_1_mean(4:6)',obl_2_mean(4:6)',obl_4_mean(4:6)',obl_8_mean(4:6)'];

figure
c=bar(x,y);
set(c(1,1),'FaceColor','m','BarWidth',0.9,'DisplayName','event1');
set(c(1,2),'FaceColor','Y','BarWidth',0.9,'DisplayName','event2');
set(c(1,3),'FaceColor','b','BarWidth',0.9,'DisplayName','event3');
legend(c(1,1:3),{'event1','event2','event3'})
title('Latency')

%box_amp
y = [car_05_mean(7),car_1_mean(7),car_2_mean(7),car_4_mean(7),car_8_mean(7), ...,
    obl_05_mean(7),obl_1_mean(7),obl_2_mean(7),obl_4_mean(7),obl_8_mean(7)];

figure
c=bar(x,y);
title('box amp')


%t_max
y = [car_05_mean(8),car_1_mean(8),car_2_mean(8),car_4_mean(8),car_8_mean(8), ...,
    obl_05_mean(8),obl_1_mean(8),obl_2_mean(8),obl_4_mean(8),obl_8_mean(8)];

figure
c=bar(x,y);
title('t max value')


%     figure
%     c=bar(x,Y_total);
%     set(c(1,1),'FaceColor','m','BarWidth',0.9,'DisplayName','8');
%     set(c(1,2),'FaceColor','Y','BarWidth',0.9,'DisplayName','4');
%     set(c(1,3),'FaceColor','b','BarWidth',0.9,'DisplayName','2');
%     set(c(1,4),'FaceColor','r','BarWidth',0.9,'DisplayName','1');
%     set(c(1,5),'FaceColor','g','BarWidth',0.9,'DisplayName','0.5');
%     set(gca,'XTickLabel',{'Cardinal directions ON meridians','Oblique directions OFF meridians','Cardinal directions OFF meridians','Oblique directions ON meridians'},'FontSize',7);
%     set(gca,'YTicklabel',{'0','0.2','0.4','0.6','0.8','1'});
%     set(gca,'YTick',0:0.2:1);
%     legend(c(1,1:5),'8°','4°','2°','1°','0.5°')
%   %  legend(c(1,1),{'8','4','2','1','0.5'})
% %     legend('8')
%     for i = 1:4    
%         text(x(i)-0.3,Y_total(1,i),num2str(round(Y_total(1,i),2)),...   
%             'HorizontalAlignment','center',...    
%             'VerticalAlignment','bottom','FontSize',6)
%         text(x(i)-0.15,Y_total(2,i),num2str(round(Y_total(2,i),2)),...   
%             'HorizontalAlignment','center',...    
%             'VerticalAlignment','bottom','FontSize',6) 
%         text(x(i),Y_total(3,i),num2str(round(Y_total(3,i),2)),...   
%             'HorizontalAlignment','center',...    
%             'VerticalAlignment','bottom','FontSize',6)  
%         text(x(i)+0.15,Y_total(4,i),num2str(round(Y_total(4,i),2)),...    
%             'HorizontalAlignment','center',...    
%             'VerticalAlignment','bottom','FontSize',6)  
%         text(x(i)+0.3,Y_total(5,i),num2str(round(Y_total(5,i),2)),...    
%             'HorizontalAlignment','center',...    
%             'VerticalAlignment','bottom','FontSize',6) 
%     end
%     ylabel('% MS','FontSize',10);
%     title('MS rate','FontSize',12);