%% this script is changed by plot_figure_diffcon2.m and this is for plot MS count figure
clc; clear all;
subject = {'S01','S02','S03','S04','S05','S06'}; condition = {'Full_distance_non_radialtangential', 'Full_distance_radialtangential'}; 
direction = {'VU','VL','HL','HR','LL','LR','UL','UR'};
y_cond1=zeros(5,6);
y_cond2=zeros(5,6);
y_cond3=zeros(5,6);
y_cond4=zeros(5,6);
Y_con1 = 0 ; 
Y_con2 = 0 ; 
Y_con3 = 0 ; 
Y_con4 = 0 ; 
for kk = 1 : 6
%     Y_con1 = 0 ; 
%     Y_con2 = 0 ; 
%     Y_con3 = 0 ; 
%     Y_con4 = 0 ; 
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
    
%     Y_con1 = 0 ; 
%     Y_con2 = 0 ; 
%     Y_con3 = 0 ; 
%     Y_con4 = 0 ; 
        
    padding_time=[0,50];
    for i = 1 : 2
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
            ms_path= fullfile(MATpath,sprintf('%s.mat', direction{j}) );
            load(ms_path);
    %         MS_TEMP(:,10)=MS_TEMP(:,10)+ ((i-1)*8 + (j-1))*800;   
    %         MS_total=[MS_total;MS_TEMP];
    %         MATpath = fullfile(main_folder, 'eyedata','MATs');
            tab_path = fullfile(MATpath, replace(edf_name, '.edf', '_tab_new_outside_blink.mat'));
            load(tab_path)
    %         tab(:,1)=tab(:,1)+ ((i-1)*8 + (j-1))*800;  
    %         tab_total=[tab_total;tab]

            [acc_w,acc_nw,rec_w,rec_nw,y,tab_w_cl,tab_nw_cl,tab_w_ncl,tab_nw_ncl]=acc_rec_count(tab,MS_TEMP,samplingRateData,padding_time);
            if i == 2 
                if j < 5
                    %acc
                    ACC_W(1,j)=mean(acc_w);
                    ACC_NW(1,j)=mean(acc_nw);
                    w_num_con1 = w_num_con1+size(acc_w,1);
                    nw_num_con1= nw_num_con1+size(acc_nw,1);
                    %rec
                    REC_W(1,j)=mean(rec_w(rec_w<4));
                    REC_NW(1,j)=mean(rec_nw(rec_nw<4));
                    %d_prime
                    p_w_hit=sum(tab_w_cl(:,15))/size(tab_w_cl,1);
                    p_nw_hit=sum(tab_nw_cl(:,15))/size(tab_nw_cl,1);
                    p_w_fl=(size(tab_w_ncl,1)-sum(tab_w_ncl(:,14)))/size(tab_w_ncl,1);
                    p_nw_fl=(size(tab_nw_ncl,1)-sum(tab_nw_ncl(:,14)))/size(tab_nw_ncl,1);
                    d_w=norminv(p_w_hit)-norminv(p_w_fl);
                    d_nw=norminv(p_nw_hit)-norminv(p_nw_fl);
                    D_w(1,j)=d_w;
                    D_nw(1,j)=d_nw;
                    Y_con1 = Y_con1+y;
                else
                    ACC_W(2,j-4)=mean(acc_w);
                    ACC_NW(2,j-4)=mean(acc_nw);
                    w_num_con2 = w_num_con2+size(acc_w,1);
                    nw_num_con2= nw_num_con2+size(acc_nw,1);
                    %rec
                    REC_W(2,j-4)=mean(rec_w(rec_w<4));
                    REC_NW(2,j-4)=mean(rec_nw(rec_nw<4));
                    %d_prime
                    p_w_hit=sum(tab_w_cl(:,15))/size(tab_w_cl,1);
                    p_nw_hit=sum(tab_nw_cl(:,15))/size(tab_nw_cl,1);
                    p_w_fl=(size(tab_w_ncl,1)-sum(tab_w_ncl(:,14)))/size(tab_w_ncl,1);
                    p_nw_fl=(size(tab_nw_ncl,1)-sum(tab_nw_ncl(:,14)))/size(tab_nw_ncl,1);
                    d_w=norminv(p_w_hit)-norminv(p_w_fl);
                    d_nw=norminv(p_nw_hit)-norminv(p_nw_fl);
                    D_w(2,j-4)=d_w;
                    D_nw(2,j-4)=d_nw;
                    Y_con2 = Y_con2+y;
                end
            else
                if j < 5
                    ACC_W(3,j)=mean(acc_w);
                    ACC_NW(3,j)=mean(acc_nw);
                    w_num_con3 = w_num_con3+size(acc_w,1);
                    nw_num_con3= nw_num_con3+size(acc_nw,1);
                    %rec
                    REC_W(3,j)=mean(rec_w(rec_w<4));
                    REC_NW(3,j)=mean(rec_nw(rec_nw<4));
                    %d_prime
                    p_w_hit=sum(tab_w_cl(:,15))/size(tab_w_cl,1);
                    p_nw_hit=sum(tab_nw_cl(:,15))/size(tab_nw_cl,1);
                    p_w_fl=(size(tab_w_ncl,1)-sum(tab_w_ncl(:,14)))/size(tab_w_ncl,1);
                    p_nw_fl=(size(tab_nw_ncl,1)-sum(tab_nw_ncl(:,14)))/size(tab_nw_ncl,1);
                    d_w=norminv(p_w_hit)-norminv(p_w_fl);
                    d_nw=norminv(p_nw_hit)-norminv(p_nw_fl);
                    D_w(3,j)=d_w;
                    D_nw(3,j)=d_nw;
                    Y_con3 = Y_con3+y;
                else
                    ACC_W(4,j-4)=mean(acc_w);
                    ACC_NW(4,j-4)=mean(acc_nw);
                    w_num_con4 = w_num_con4+size(acc_w,1);
                    nw_num_con4= nw_num_con4+size(acc_nw,1);
                    %rec
                    REC_W(4,j-4)=mean(rec_w(rec_w<4));
                    REC_NW(4,j-4)=mean(rec_nw(rec_nw<4));
                    %d_prime
                    p_w_hit=sum(tab_w_cl(:,15))/size(tab_w_cl,1);
                    p_nw_hit=sum(tab_nw_cl(:,15))/size(tab_nw_cl,1);
                    p_w_fl=(size(tab_w_ncl,1)-sum(tab_w_ncl(:,14)))/size(tab_w_ncl,1);
                    p_nw_fl=(size(tab_nw_ncl,1)-sum(tab_nw_ncl(:,14)))/size(tab_nw_ncl,1);
                    d_w=norminv(p_w_hit)-norminv(p_w_fl);
                    d_nw=norminv(p_nw_hit)-norminv(p_nw_fl);
                    D_w(4,j-4)=d_w;
                    D_nw(4,j-4)=d_nw;
                    Y_con4 = Y_con4+y;
                end
            end
          
%             ACC_W=[ACC_W;mean(acc_w)];
%             w_num = w_num+size(acc_w,1);
%             ACC_NW=[ACC_NW;mean(acc_nw)];
%             nw_num = nw_num+size(acc_nw,1);

%             REC_W=[REC_W;mean(rec_w(rec_w<4))];
%             REC_NW=[REC_NW;mean(rec_nw(rec_nw<4))];
%              Y=Y+y;
%             p_w_hit=sum(tab_w_cl(:,15))/size(tab_w_cl,1);
%             p_nw_hit=sum(tab_nw_cl(:,15))/size(tab_nw_cl,1);
%             p_w_fl=(size(tab_w_ncl,1)-sum(tab_w_ncl(:,14)))/size(tab_w_ncl,1);
%             p_nw_fl=(size(tab_nw_ncl,1)-sum(tab_nw_ncl(:,14)))/size(tab_nw_ncl,1);
% 
%             d_w=norminv(p_w_hit)-norminv(p_w_fl);
%             d_nw=norminv(p_nw_hit)-norminv(p_nw_fl);
% 
%             D_w=[D_w;d_w];
%             D_nw=[D_nw;d_nw];
    %         Tab_w_cl=[Tab_w_cl;tab_w_cl];
    %         Tab_nw_cl=[Tab_nw_cl;tab_nw_cl];
    %         Tab_w_ncl=[Tab_w_ncl;tab_w_ncl];
    %         Tab_nw_ncl=[Tab_nw_ncl;tab_nw_ncl];
        end

    
    end
    %% for all subject
%     y_con1 = (Y_con1([1,2,3,4,5],1)+Y_con1([10,9,8,7,6],1))/640;
%     y_con2 = (Y_con2([1,2,3,4,5],1)+Y_con2([10,9,8,7,6],1))/640;
%     y_con3 = (Y_con3([1,2,3,4,5],1)+Y_con3([10,9,8,7,6],1))/640;
%     y_con4 = (Y_con4([1,2,3,4,5],1)+Y_con4([10,9,8,7,6],1))/640;
%     y_cond1(:,kk) = (Y_con1([1,2,3,4,5],1)+Y_con1([10,9,8,7,6],1))/640;
%     y_cond2(:,kk) = (Y_con2([1,2,3,4,5],1)+Y_con2([10,9,8,7,6],1))/640;
%     y_cond3(:,kk) = (Y_con3([1,2,3,4,5],1)+Y_con3([10,9,8,7,6],1))/640;
%     y_cond4(:,kk) = (Y_con4([1,2,3,4,5],1)+Y_con4([10,9,8,7,6],1))/640;
    %% true code for figure
%     y_con1 = (Y_con1([1,2,3,4,5],1)+Y_con1([10,9,8,7,6],1))/640;
%     y_con2 = (Y_con2([1,2,3,4,5],1)+Y_con2([10,9,8,7,6],1))/640;
%     y_con3 = (Y_con3([1,2,3,4,5],1)+Y_con3([10,9,8,7,6],1))/640;
%     y_con4 = (Y_con4([1,2,3,4,5],1)+Y_con4([10,9,8,7,6],1))/640;
%     Y_total = [y_con1,y_con2,y_con3,y_con4];
%     x=[1 2 3 4]; 
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
%     saveas(gca, sprintf('%s/MS_rate_diffcon.png',MATpath))


%     figure
%     acc_w1=mean(ACC_W,2);
%     acc_nw1=mean(ACC_NW,2);
%     ACC_TOTAL=[acc_w1,acc_nw1];
%     x=[1 2 3 4]; 
%     t1=ACC_TOTAL(:,1); 
%     t2=ACC_TOTAL(:,2); 
%     t=[t1;t2];
%     c=bar(x,ACC_TOTAL);
%     set(c(1,1),'FaceColor','m','BarWidth',0.9);% c(1,1) 就是设置第一组的第一个数据柱
%     set(c(1,2),'FaceColor','Y','BarWidth',0.9);% c(1,2) 设置第二个
%     num_w = [w_num_con1,w_num_con2,w_num_con3,w_num_con4];
%     num_nw=[nw_num_con1,nw_num_con2,nw_num_con3,nw_num_con4];
%     for i = 1:4    
%         text(x(i)-0.15,t1(i),num2str(num_w(i)),...   
%             'HorizontalAlignment','center',...    
%             'VerticalAlignment','bottom','FontSize',10)  %0.3可以调整相邻柱之间的间隔，手动调节 
%         text(x(i)+0.15,t2(i),num2str(num_nw(i)),...    
%             'HorizontalAlignment','center',...    
%             'VerticalAlignment','bottom','FontSize',10)   %‘FontSize’设置文字大小
%     end
%     set(gca,'XTickLabel',{'Cardinal directions ON meridians','Oblique directions OFF meridians','Cardinal directions OFF meridians','Oblique directions ON meridians'},'FontSize',7);
%     set(gca,'YTicklabel',{'0','0.2','0.4','0.6','0.8','1'});
%     set(gca,'YTick',0:0.2:1);
%     ylabel('% correct','FontSize',10);
%     title('accuracy','FontSize',12);
%     saveas(gca, sprintf('%s/accuracy_diffcon.png',MATpath)) 
%     
%     figure
%     rec_w1=mean(REC_W,2);
%     rec_nw1=mean(REC_NW,2);
%     REC_TOTAL=[rec_w1,rec_nw1];
%     x=[1 2 3 4]; 
%     t1=REC_TOTAL(:,1); 
%     t2=REC_TOTAL(:,2); 
%     t=[t1;t2];
%     c=bar(x,REC_TOTAL);
%     set(c(1,1),'FaceColor','m','BarWidth',0.9);% c(1,1) 就是设置第一组的第一个数据柱
%     set(c(1,2),'FaceColor','Y','BarWidth',0.9);% c(1,2) 设置第二个
%     num_w = [w_num_con1,w_num_con2,w_num_con3,w_num_con4];
%     num_nw=[nw_num_con1,nw_num_con2,nw_num_con3,nw_num_con4];
%     for i = 1:4    
%         text(x(i)-0.15,t1(i),num2str(num_w(i)),...   
%             'HorizontalAlignment','center',...    
%             'VerticalAlignment','bottom','FontSize',10)  %0.3可以调整相邻柱之间的间隔，手动调节 
%         text(x(i)+0.15,t2(i),num2str(num_nw(i)),...    
%             'HorizontalAlignment','center',...    
%             'VerticalAlignment','bottom','FontSize',10)   %‘FontSize’设置文字大小
%     end
%     set(gca,'XTickLabel',{'Cardinal directions ON meridians','Oblique directions OFF meridians','Cardinal directions OFF meridians','Oblique directions ON meridians'},'FontSize',7);
% %     set(gca,'YTicklabel',{'0','0.2','0.4','0.6','0.8','1'});
% %     set(gca,'YTick',0:0.2:1);
%     ylabel('% reaction time','FontSize',10);
%     title('reaction time','FontSize',12)
%     saveas(gca, sprintf('%s/reaction_diffcon.png',MATpath)) 
%     
%     figure
%     d_w1=zeros(4,1);
%     d_nw1=zeros(4,1);
%     for jj = 1 : 4 
%         a=D_w(jj,:);
%         d_w1(jj)=mean(a(a<5));
%         b=D_nw(jj,:);
%         d_nw1(jj)=mean(b(b<5));
%     end
%     D_TOTAL=[d_w1,d_nw1];
%     x=[1 2 3 4]; 
%     t1=D_TOTAL(:,1); 
%     t2=D_TOTAL(:,2); 
%     t=[t1;t2];
%     c=bar(x,D_TOTAL);
%     set(c(1,1),'FaceColor','m','BarWidth',0.9);% c(1,1) 就是设置第一组的第一个数据柱
%     set(c(1,2),'FaceColor','Y','BarWidth',0.9);% c(1,2) 设置第二个
%     num_w = [w_num_con1,w_num_con2,w_num_con3,w_num_con4];
%     num_nw=[nw_num_con1,nw_num_con2,nw_num_con3,nw_num_con4];
%     for i = 1:4    
%         text(x(i)-0.15,t1(i),num2str(num_w(i)),...   
%             'HorizontalAlignment','center',...    
%             'VerticalAlignment','bottom','FontSize',10)  %0.3可以调整相邻柱之间的间隔，手动调节 
%         text(x(i)+0.15,t2(i),num2str(num_nw(i)),...    
%             'HorizontalAlignment','center',...    
%             'VerticalAlignment','bottom','FontSize',10)   %‘FontSize’设置文字大小
%     end
%     set(gca,'XTickLabel',{'Cardinal directions ON meridians','Oblique directions OFF meridians','Cardinal directions OFF meridians','Oblique directions ON meridians'},'FontSize',7);
% %     set(gca,'YTicklabel',{'0','0.2','0.4','0.6','0.8','1'});
% %     set(gca,'YTick',0:0.2:1);
% %     ylabel('% reaction time','FontSize',10);
%     title('dprime','FontSize',12)
%     saveas(gca, sprintf('%s/d_prime_diffcon.png',MATpath)) 
    
    %% 
    % total_num = [w_num,nw_num];
    % p_w_hit=sum(Tab_w_cl(:,15))/size(Tab_w_cl,1);
    % p_nw_hit=sum(Tab_nw_cl(:,15))/size(Tab_nw_cl,1);
    % p_w_fl=(size(Tab_w_ncl,1)-sum(Tab_w_ncl(:,14)))/size(Tab_w_ncl,1);
    % p_nw_fl=(size(Tab_nw_ncl,1)-sum(Tab_nw_ncl(:,14)))/size(Tab_nw_ncl,1);
    % 
    % d_w=norminv(p_w_hit)-norminv(p_w_fl);
    % d_nw=norminv(p_nw_hit)-norminv(p_nw_fl);

%     x=1:10;
% 
%     figure
%     X = categorical({'with MS in sti','notwith MS in sti'});
%     X = reordercats(X,{'with MS in sti','notwith MS in sti'});
%     bar(X,[mean(ACC_W),mean(ACC_NW)])
%     hold on 
%     st_acc=std(ACC_W);
%     sem_acc=st_acc/sqrt(16);
%     st_nacc=std(ACC_NW);
%     sem_nacc=st_nacc/sqrt(16);
% 
%     y_axis=[mean(ACC_W),mean(ACC_NW)];
% 
% 
%     er=errorbar(X,[mean(ACC_W),mean(ACC_NW)],[sem_acc,sem_nacc]);
%     er.LineStyle= 'none';  
%     hold off 
%     title('Accuracy')
%     ylabel('% correct')
%     for i = 1 : 2
%         str = ['total number :',num2str(total_num(i))];
%         text(i,y_axis(i)/2,str,...   
%                 'HorizontalAlignment','center',...    
%                 'VerticalAlignment','bottom','FontSize',15)
%     end
%     saveas(gca, sprintf('%s/ACC2.png',MATpath))
% 
% 
%     figure
%     X = categorical({'with MS in sti','notwith MS in sti'});
%     X = reordercats(X,{'with MS in sti','notwith MS in sti'});
%     bar(X,[mean(REC_W),mean(REC_NW)])
%     hold on 
%     st_rec=std(REC_W);
%     sem_rec=st_rec/sqrt(16);
%     st_nrec=std(REC_NW);
%     sem_nrec=st_nrec/sqrt(16);
% 
%     er=errorbar(X,[mean(REC_W),mean(REC_NW)],[sem_rec,sem_nrec]);
%     er.LineStyle= 'none';  
%     hold off 
% 
%     title('reaction time')
%     ylabel('sec(s)')
% 
%     for i = 1 : 2
%         str = ['total number :',num2str(total_num(i))];
%         text(i,y_axis(i)/2,str,...   
%                 'HorizontalAlignment','center',...    
%                 'VerticalAlignment','bottom','FontSize',15)
%     end
% 
%     saveas(gca, sprintf('%s/REC2.png',MATpath))
% 
%     figure
%     X = categorical({'with MS in sti','notwith MS in sti'});
%     X = reordercats(X,{'with MS in sti','notwith MS in sti'});
%     bar(X,[mean(D_w(D_w<10)),mean(D_nw(D_nw<10))])
%     hold on 
%     st_dp=std(D_w(D_w<10));
%     sem_dp=st_dp/sqrt(16);
%     st_ndp=std(D_nw(D_nw<10));
%     sem_ndp=st_ndp/sqrt(16);
% 
%     er=errorbar(X,[mean(D_w(D_w<10)),mean(D_nw(D_nw<10))],[sem_dp,sem_ndp]);
%     er.LineStyle= 'none';  
%     hold off 
% 
%     title('d-prime')
%     saveas(gca, sprintf('%s/dprime2.png',MATpath))
% 
% 
%     figure
%     X = categorical({'-8','-4','-2','-1','-0.5','0.5','1','2','4','8'});
%     X = reordercats(X,{'-8','-4','-2','-1','-0.5','0.5','1','2','4','8'});
%     y_ax= round(Y(:,1)/(Y(1,1)+Y(1,2)) * 10000)/100 ;
%     bar(X,y_ax)
% 
%     title('With vs. Without MS')
%     xlabel('tilt angle')
%     ylabel('# of trials')
% 
%     for k = 1 : 10
%         str1 = [num2str(y_ax(k)),'%'];
%         text(k,y_ax(k),str1,...   
%                 'HorizontalAlignment','center',...    
%                 'VerticalAlignment','bottom')
%     end
% 
%     saveas(gca, sprintf('%s/deg_stacked.png',MATpath))
%     Y_t=Y_con1+Y_con2+Y_con3+Y_con4;
% 
%     Y_t_plus = zeros(5,2);
%     for ll = 1 : 5 
%         Y_t_plus(ll,:) = Y_t(ll,:)+ Y_t(11-ll,:);
%     end
%     figure
%     X = categorical({'8','4','2','1','0.5'});
%     X = reordercats(X,{'8','4','2','1','0.5'});
%     %y_ax= round(Y(:,1)/(Y(1,1)+Y(1,2)) * 10000)/100 ;
%     bar(X,Y_t_plus(:,1))
% 
%     title([subject{kk},', % of trials with MS during stimulus interval ([0,100])'])
%     xlabel('tilt angle')
%     ylabel('# of trials')
%     figpath='C:\Users\86186\Desktop\fig';
%     figname=[subject{kk},'_100.png'];
%     saveas(gca, sprintf('%s\%s',figpath,figname))
end




% Y_cond1=mean(y_cond1,2);
% Y_cond2=mean(y_cond2,2);
% Y_cond3=mean(y_cond3,2);
% Y_cond4=mean(y_cond4,2);
% Y_total = [Y_cond1,Y_cond2,Y_cond3,Y_cond4];
% x=[1 2 3 4]; 
% %add SEM
% SEM_total=zeros(5,4);
% for hh = 1 : 5
%     SEM_total(hh,1)=std(y_cond1(hh,:))/sqrt(6);
%     SEM_total(hh,2)=std(y_cond2(hh,:))/sqrt(6);
%     SEM_total(hh,3)=std(y_cond3(hh,:))/sqrt(6);
%     SEM_total(hh,4)=std(y_cond4(hh,:))/sqrt(6);
% end
% x_base=[0.3,0.15,0,-0.15,-0.3];
% figure
% c=bar(x,Y_total);
% hold on 
% for gg=1:5
%     er=errorbar(x-x_base(gg),Y_total(gg,:),SEM_total(gg,:));
%     er.LineStyle= 'none';
% end
% set(c(1,1),'FaceColor','m','BarWidth',0.9,'DisplayName','8');
% set(c(1,2),'FaceColor','Y','BarWidth',0.9,'DisplayName','4');
% set(c(1,3),'FaceColor','b','BarWidth',0.9,'DisplayName','2');
% set(c(1,4),'FaceColor','r','BarWidth',0.9,'DisplayName','1');
% set(c(1,5),'FaceColor','g','BarWidth',0.9,'DisplayName','0.5');
% set(gca,'XTickLabel',{'Cardinal directions ON meridians','Oblique directions OFF meridians','Cardinal directions OFF meridians','Oblique directions ON meridians'},'FontSize',7);
% set(gca,'YTicklabel',{'0','0.2','0.4','0.6','0.8','1'});
% set(gca,'YTick',0:0.2:1);
% legend(c(1,1:5),'8°','4°','2°','1°','0.5°')
% % for i = 1:4    
% %         text(x(i)-0.3,Y_total(1,i),num2str(round(Y_total(1,i),2)),...   
% %             'HorizontalAlignment','center',...    
% %             'VerticalAlignment','bottom','FontSize',6)
% %         text(x(i)-0.15,Y_total(2,i),num2str(round(Y_total(2,i),2)),...   
% %             'HorizontalAlignment','center',...    
% %             'VerticalAlignment','bottom','FontSize',6) 
% %         text(x(i),Y_total(3,i),num2str(round(Y_total(3,i),2)),...   
% %             'HorizontalAlignment','center',...    
% %             'VerticalAlignment','bottom','FontSize',6)  
% %         text(x(i)+0.15,Y_total(4,i),num2str(round(Y_total(4,i),2)),...    
% %             'HorizontalAlignment','center',...    
% %             'VerticalAlignment','bottom','FontSize',6)  
% %         text(x(i)+0.3,Y_total(5,i),num2str(round(Y_total(5,i),2)),...    
% %             'HorizontalAlignment','center',...    
% %             'VerticalAlignment','bottom','FontSize',6) 
% % end
% ylabel('% MS (out of X trials)','FontSize',10);
% title('% of trials with MS per condition/tilt angle','FontSize',12);
% saveas(gca, sprintf('%s/MS_rate_allsub.png',MATpath))


Y_t=Y_con1+Y_con2+Y_con3+Y_con4;

Y_t_plus = zeros(5,2);
for ll = 1 : 5 
    Y_t_plus(ll,:) = Y_t(ll,:)+ Y_t(11-ll,:);
end

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

% for k = 1 : 10
%     str1 = [num2str(y_ax(k)),'%'];
%     text(k,y_ax(k),str1,...   
%            'HorizontalAlignment','center',...    
%            'VerticalAlignment','bottom')
% end
%saveas(gca, sprintf('%s/deg_stacked_total.png',MATpath))