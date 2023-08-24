%Cardinal vs. Oblique from diff_con2.m script
%% this script is changed by plot_figure_diffcon2.m and this is for plot MS count figure
clc; clear all;
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; condition = {'Full_distance_non_radialtangential', 'Full_distance_radialtangential'}; 
direction = {'VU','VL','HL','HR','LL','LR','UL','UR'};
location = {'UR','LL','UL','LR','VU','VL','HR','HL'};
direction_name = {'VU_new','VL_new','HL_new','HR_new','LL_new','LR_new','UL_new','UR_new'};
y_cond1=zeros(5,6);
y_cond2=zeros(5,6);
y_cond3=zeros(5,6);
y_cond4=zeros(5,6);
Y_con1 = 0 ; 
Y_con2 = 0 ; 
Y_con3 = 0 ; 
Y_con4 = 0 ; 
oblique_cum = zeros(5,8);
cardinal_cum = zeros(5,8);
for kk = 1 : 8 
%     Y_con1 = 0 ; 
%     Y_con2 = 0 ; 
%     Y_con3 = 0 ; 
%     Y_con4 = 0 ; 
%     Orig = zeros(10,2);
%     Swit = zeros(10,2);
    Card = zeros(10,2);
    Obli = zeros(10,2);
    tab_total = [] ;
    MS_total = [] ; 
    sample=[];
%     ACC_W=[];
%     ACC_NW=[];
%     REC_W=[];
%     REC_NW=[];
    ACC_W=zeros(4,4);
    ACC_NW=zeros(4,4);
    REC_W=zeros(4,4);
    REC_NW=zeros(4,4);
    Y=zeros(10,2);
    % Tab_w_cl=[];
    % Tab_nw_cl=[];
    % Tab_w_ncl=[];
    % Tab_nw_ncl=[];
    D_w=zeros(4,4);
    D_nw=zeros(4,4);
   %calculate numbers of different condition
    w_num_con1 = 0;
    nw_num_con1= 0;
    w_num_con2 = 0;
    nw_num_con2= 0;
    w_num_con3 = 0;
    nw_num_con3= 0;
    w_num_con4 = 0;
    nw_num_con4= 0;
    
        
    padding_time=[0,100];
    for i = 1 : 2
        if kk > 6 & i == 1 
            continue
        end
        for j = 1 : 8

            main_folder = fullfile('F:\RadialBias_pilot1-main\Data_DI_wEYE\Data_DI_wEYE', subject{kk}, ...
                 'RawData', condition{i}, 'Block1');
            cd(fullfile(main_folder, 'eyedata'));
            edf_name = dir(sprintf('*%s*.edf', direction{j})).name;
            edf_path = fullfile(main_folder,'eyedata',edf_name);
            msg_filepath=replace(edf_path,'edf','msg');
            samplingRateData=findSamplingRate(msg_filepath);
            sample=[sample,samplingRateData];
            MATpath = fullfile(main_folder, 'eyedata','MATs');
    %         cd(fullfile(main_folder, 'eyedata','MATs'));
    %         ms_name = dir(sprintf('%s.mat', direction{j})).name;
            ms_path= fullfile(MATpath,sprintf('%s.mat', direction_name{j}) );
            load(ms_path);
    %         MS_TEMP(:,10)=MS_TEMP(:,10)+ ((i-1)*8 + (j-1))*800;   
    %         MS_total=[MS_total;MS_TEMP];
    %         MATpath = fullfile(main_folder, 'eyedata','MATs');
            tab_path = fullfile(MATpath, replace(edf_name, '.edf', '_tab_new_outside_blink.mat'));
            load(tab_path)
    %         tab(:,1)=tab(:,1)+ ((i-1)*8 + (j-1))*800;  
    %         tab_total=[tab_total;tab]

            [acc_w,acc_nw,rec_w,rec_nw,y,tab_w_cl,tab_nw_cl,tab_w_ncl,tab_nw_ncl]=acc_rec_count(tab,MS_TEMP,samplingRateData,padding_time);
            if j < 5
               Card = Card + y; 
            else
               Obli = Obli + y;
                
            end
          
        end

    
    end
    Orignial=zeros(5,2);
    Switch=zeros(5,2);
    for k = 1 : 5
        Orignial(k,:) = Card(k,:)+Card(11-k,:);
        Switch(k,:)= Obli(k,:)+Obli(11-k,:);
    end
    cardinal_cum(:,kk) = Orignial(:,1);
    oblique_cum(:,kk) = Switch(:,1);
end




x=[0.7,0.85,1,1.15,1.3,1.7,1.85,2,2.15,2.3];
xt=[1,2];

Y_total=[cardinal_cum;oblique_cum];

% Oringinal_con = Y_total(1,:) + Y_total(2,:)+ Y_total(3,:)+ Y_total(4,:)+ Y_total(5,:);
% Switch_con = Y_total(6,:) + Y_total(7,:)+ Y_total(8,:)+ Y_total(9,:)+ Y_total(10,:);
% [h,p] = ttest(Oringinal_con,Switch_con);
% output = [Oringinal_con',Switch_con'];
% writematrix(output,'nu_CvO.csv'); 




figure
b=bar(x,Y_total,'stacked');
set(gca,'xaxislocation','top');
set(gca,'XTick',xt); 
set(gca,'XTicklabels',{'Cardinal','Oblique'}); 
axes;
c=bar(x,Y_total,'stacked');
set(gca,'XTick',x); 
set(gca,'XTicklabels',{'8°','4°','2°','1°','0.5°','8°','4°','2°','1°','0.5°'}); 
color = {[51, 34, 136],[17, 119, 51],[68, 170, 153],[136, 204, 238],[221, 204, 119],[204, 102, 119],[170, 68, 153],[136, 34 85]};
for sdf = 1 : 8 
    b(sdf).FaceColor = 'flat';
    b(sdf).CData = color{sdf}/255;
    c(sdf).FaceColor = 'flat';
    c(sdf).CData = color{sdf}/255;
end

ylabel('# of MS')
title('All Subject')
%figpath='C:\Users\86186\Desktop\fig';
name = 'C:\Users\86186\Desktop\fig\new\se.png';
saveas(gca,name) 





% 
% Y_t=Y_con1+Y_con2+Y_con3+Y_con4;
% 
% Y_t_plus = zeros(5,2);
% for ll = 1 : 5 
%     Y_t_plus(ll,:) = Y_t(ll,:)+ Y_t(11-ll,:);
% end

%% plot figure for 10
% figure
% X = categorical({'-8','-4','-2','-1','-0.5','0.5','1','2','4','8'});
% X = reordercats(X,{'-8','-4','-2','-1','-0.5','0.5','1','2','4','8'});
% %y_ax= round(Y(:,1)/(Y(1,1)+Y(1,2)) * 10000)/100 ;
% bar(X,Y)
% 
% title('% of trials with MS during stimulus interval')
% xlabel('tilt angle')
% ylabel('# of trials')

% figure
% X = categorical({'8','4','2','1','0.5'});
% X = reordercats(X,{'8','4','2','1','0.5'});
% %y_ax= round(Y(:,1)/(Y(1,1)+Y(1,2)) * 10000)/100 ;
% bar(X,Y_t_plus(:,1))
% 
% title('% of trials with MS during stimulus interval ([0,50])')
% xlabel('tilt angle')
% ylabel('# of trials')