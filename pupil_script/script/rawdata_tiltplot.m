%% plot the raw data figure
clc; clear all;
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; condition = {'Full_distance_non_radialtangential', 'Full_distance_radialtangential'}; 
con = {'Location Oblique','Location Cardinal'};
direction = {'VU','VL','HL','HR','LL','LR','UL','UR'};
direction_s3 = {'VL','HL','HR','LL','LR','UL','UR'};
le_direction = {'VU','VL','HL','HR','LL','LR','UL','UR','mean-car','mean-obl'};
le_direction_s3 = {'VL','HL','HR','LL','LR','UL','UR','mean-car','mean-obl'};

loc_direction ={'Cardinal Direction','Oblique Direction'};

tilt_direction = {'0.5°','1°','2°','4°','8°'};



num = [];
diff=[];
% color = {'-r','-b','-g','-y','--r','--b','--g','--y'};
color = {'-r','-b'};
x=1:2001;
figpath='C:\Users\86186\Desktop\fig';
%extract pupil size data
for kk = 7:8
   num_trial = zeros(8,2);
   pupil_data1 = []; %0.5
   pupil_data2 = []; %1
   pupil_data3 = []; %2
   pupil_data4 = []; %4
   pupil_data5 = []; %8
%     if kk == 3
%          continue
%     end
    
    pupil_data = [];

    for i = 2 :2
%         figure
%         if i ==2           
%             meanfile1 = [figpath,'/',subject{kk},'-CL-CD.mat'];
%             meanfile2 = [figpath,'/',subject{kk},'-CL-OD.mat'];
%             load(meanfile1)
%             load(meanfile2)
%             
%             baseline  = mean(pupil_data_1(:,1100:1300),2);
%             pupil_data_1 = (pupil_data_1-baseline)./baseline*100;
%             baseline  = mean(pupil_data_2(:,1100:1300),2);
%             pupil_data_2 = (pupil_data_2-baseline)./baseline*100; 
%             
%             shadedErrorBar(x(501:2001), mean(pupil_data_1(:,501:2001),1),std(pupil_data_1(:,501:2001),0,1)/sqrt(size(pupil_data_1(:,501:2001),1)), 'lineprops', '-b','transparent',1,'patchSaturation',0.4)
%             hold on 
%             shadedErrorBar(x(501:2001), mean(pupil_data_2(:,501:2001),1),std(pupil_data_2(:,501:2001),0,1)/sqrt(size(pupil_data_2(:,501:2001),1)), 'lineprops', '-r','transparent',1,'patchSaturation',0.4)
%             hold on
%             plot(x(501:2001), mean(pupil_data_1(:,501:2001),1),'-b','LineWidth',3)
%             hold on
%             plot(x(501:2001), mean(pupil_data_2(:,501:2001),1),'-r','LineWidth',3)
% 
%         else
%             meanfile3 = [figpath,'/',subject{kk},'-OL-CD.mat'];
%             meanfile4 = [figpath,'/',subject{kk},'-OL-OD.mat'];
%             load(meanfile3)
%             load(meanfile4)
%             
%             baseline  = mean(pupil_data_3(:,1100:1300),2);
%             pupil_data_3 = (pupil_data_3-baseline)./baseline*100;
%             baseline  = mean(pupil_data_4(:,1100:1300),2);
%             pupil_data_4 = (pupil_data_4-baseline)./baseline*100; 
%             
%             shadedErrorBar(x(501:2001), mean(pupil_data_3(:,501:2001),1),std(pupil_data_3(:,501:2001),0,1)/sqrt(size(pupil_data_3(:,501:2001),1)), 'lineprops', '-b','transparent',1,'patchSaturation',0.4)
%             hold on 
%             shadedErrorBar(x(501:2001), mean(pupil_data_4(:,501:2001),1),std(pupil_data_4(:,501:2001),0,1)/sqrt(size(pupil_data_4(:,501:2001),1)), 'lineprops', '-r','transparent',1,'patchSaturation',0.4)
%             
%             plot(x(501:2001), mean(pupil_data_3(:,501:2001),1),'-b','LineWidth',3)
%             hold on
%             plot(x(501:2001), mean(pupil_data_4(:,501:2001),1),'-r','LineWidth',3)         
%         end
        
                
                
        for j = 1 : 8
            if i == 2 & j ==2 & kk ==7 
                continue
            end
            pupil_data = [];
            main_folder = fullfile('F:\pupildata\Data_DI_wEYE\Data_DI_wEYE', subject{kk}, ...
                 'RawData', condition{i}, 'Block1');
            cd(fullfile(main_folder, 'eyedata'));
            edf_name = dir(sprintf('*%s*.edf', direction{j})).name;
            edf_path = fullfile(main_folder,'eyedata',edf_name);
            msg_filepath=replace(edf_path,'edf','msg');
            samplingRateData=findSamplingRate(msg_filepath);
    %        sample=[sample,samplingRateData];
            MATpath = fullfile(main_folder, 'eyedata','MATs');
            tab_path = fullfile(MATpath, replace(edf_name, '.edf', '_tab_new_outside_blink.mat'));
            load(tab_path)
            cd('MATs')
            cdt=dir([direction{j},'*_Dat_all.mat']);
            load(cdt.name)
            
            for kkk = 1 : 800
                nondata = 0 ;
                trial_st = tab(kkk,2) ;
                aa=Dat_all(trial_st<=Dat_all(:,1) & Dat_all(:,1)<=trial_st+2000,:);
                if isempty(aa) ==1 
                    nondata = nondata +1 ;
                    continue
                end
                num = [num,size(aa,1)];
%                 diff = [diff,max(aa(:,1))-min(aa(:,1))];
                [~,I]= sort(aa(:,1));
                timepoint = aa(I,4)';
                
                
                if tab(kkk,11) == 0.5                    
                    if samplingRateData == 500
                        timepoint = upsample_raw(timepoint);
                        if size(timepoint,2) == 1999
                            timepoint = [timepoint(1),timepoint,timepoint(length(timepoint))];                
                        end
                    end
                    if samplingRateData == 2000
                        timepoint = downsample(timepoint,2);
                    end
                    if size(timepoint,2) == 2001  
                        pupil_data1 = [pupil_data1;timepoint];
                    end 
                elseif tab(kkk,11) == 1
                    if samplingRateData == 500
                        timepoint = upsample_raw(timepoint);
                        if size(timepoint,2) == 1999
                            timepoint = [timepoint(1),timepoint,timepoint(length(timepoint))];                
                        end
                    end
                    if samplingRateData == 2000
                        timepoint = downsample(timepoint,2);
                    end
                    if size(timepoint,2) == 2001  
                        pupil_data2 = [pupil_data2;timepoint];
                    end
                elseif tab(kkk,11) == 2
                    if samplingRateData == 500
                        timepoint = upsample_raw(timepoint);
                        if size(timepoint,2) == 1999
                            timepoint = [timepoint(1),timepoint,timepoint(length(timepoint))];                
                        end
                    end
                    if samplingRateData == 2000
                        timepoint = downsample(timepoint,2);
                    end
                    if size(timepoint,2) == 2001  
                        pupil_data3 = [pupil_data3;timepoint];
                    end
                elseif tab(kkk,11) == 4
                    if samplingRateData == 500
                        timepoint = upsample_raw(timepoint);
                        if size(timepoint,2) == 1999
                            timepoint = [timepoint(1),timepoint,timepoint(length(timepoint))];                
                        end
                    end
                    if samplingRateData == 2000
                        timepoint = downsample(timepoint,2);
                    end
                    if size(timepoint,2) == 2001  
                        pupil_data4 = [pupil_data4;timepoint];
                    end
                else 
                    if samplingRateData == 500
                        timepoint = upsample_raw(timepoint);
                        if size(timepoint,2) == 1999
                            timepoint = [timepoint(1),timepoint,timepoint(length(timepoint))];                
                        end
                    end
                    if samplingRateData == 2000
                        timepoint = downsample(timepoint,2);
                    end
                    if size(timepoint,2) == 2001  
                        pupil_data5 = [pupil_data5;timepoint];
                    end
                    
                    
                end
             end
            
%             pupil_data_red = pupil_data;
%             
%             pupil_data=pupil_data(pupil_data(:,2001)~=0,:);
%             
%             baseline  = mean(pupil_data(:,1100:1300),2);
%             pupil_data = (pupil_data-baseline)./baseline*100; 
%             if j<5
%                 shadedErrorBar(x(501:2001), mean(pupil_data(:,501:2001),1),std(pupil_data(:,501:2001),0,1)/sqrt(size(pupil_data(:,501:2001),1)),'lineprops','-b','transparent',1,'patchSaturation',0.05)
%                 hold on
%             else
%                 shadedErrorBar(x(501:2001), mean(pupil_data(:,501:2001),1),std(pupil_data(:,501:2001),0,1)/sqrt(size(pupil_data(:,501:2001),1)),'lineprops','-r','transparent',1,'patchSaturation',0.05)
%                 hold on
%             end
%             num_trial(j,3-i) = size(pupil_data,1);
            

        end
%         if i ==2           
%   
%             a1=xline(1200,'-','Baseline','alpha',0.065);
%             a=xline(1100:1300,'-y','alpha',0.065);
%             a2 = xline(1300,'-','Stimuli on');
%             a3 = xline(1800,'-','Stimuli off');
%             legend(loc_direction{:},'Location','northeastoutside')
%             xlabel('time(ms)')
%             ylabel('Pupil area (% change from baseline)')
%             
%             title_name = [subject{kk},'- ',con{i},];
%     %         figpath='C:\Users\86186\Desktop\fig';
%             name = [figpath,'/',subject{kk},'_',con{i},'_ps_baseline.png'];
%             title(title_name)
%             if kk == 1
%                 ylim([-5 5])
%             elseif kk ==2 
%                 ylim([-12 12])
%             elseif kk ==3 
%                 ylim([-5 20])
%             elseif kk ==4 
%                 ylim([-4 10])
%             elseif kk ==5 
%                 ylim([-10 30])
%             elseif kk ==6 
%                 ylim([-4 12])
%             end
%                 
%                 
%             	
%             saveas(gca,name)
%         else
%  
%             a1=xline(1200,'-','Baseline','alpha',0.065);
%             a=xline(1100:1300,'-y','alpha',0.065);
%             a2 = xline(1300,'-','Stimuli on');
%             a3 = xline(1800,'-','Stimuli off');
%             legend(loc_direction{:},'Location','northeastoutside')
%             xlabel('time(ms)')
%             ylabel('Pupil area (% change from baseline)')
%             title_name = [subject{kk},'- ',con{i},];
%     %         figpath='C:\Users\86186\Desktop\fig';
%             name = [figpath,'/',subject{kk},'_',con{i},'_ps_baseline.png'];
%             title(title_name)
%             if kk == 1
%                 ylim([-5 5])
%             elseif kk ==2 
%                 ylim([-12 12])
%             elseif kk ==3 
%                 ylim([-5 20])
%             elseif kk ==4 
%                 ylim([-4 10])
%             elseif kk ==5 
%                 ylim([-10 30])
%             elseif kk ==6 
%                 ylim([-4 12])
%             end
%             saveas(gca,name) 
%         end
    end
    pupil_data1=pupil_data1(pupil_data1(:,2001)~=0,:);
    pupil_data2=pupil_data2(pupil_data2(:,2001)~=0,:);
    pupil_data3=pupil_data3(pupil_data3(:,2001)~=0,:);
    pupil_data4=pupil_data4(pupil_data4(:,2001)~=0,:);
    pupil_data5=pupil_data5(pupil_data5(:,2001)~=0,:);
    baseline1  = mean(pupil_data1(:,1100:1300),2);
    baseline2  = mean(pupil_data2(:,1100:1300),2);
    baseline3  = mean(pupil_data3(:,1100:1300),2);
    baseline4  = mean(pupil_data4(:,1100:1300),2);
    baseline5  = mean(pupil_data5(:,1100:1300),2);
    
    pupil_data1 = (pupil_data1-baseline1)./baseline1*100; 
    pupil_data2 = (pupil_data2-baseline2)./baseline2*100; 
    pupil_data3 = (pupil_data3-baseline3)./baseline3*100; 
    pupil_data4 = (pupil_data4-baseline4)./baseline4*100; 
    pupil_data5 = (pupil_data5-baseline5)./baseline5*100; 
    

    figure
    hold on 
    shadedErrorBar(x(1001:2001), mean(pupil_data1(:,1001:2001),1),std(pupil_data1(:,1001:2001),0,1)/sqrt(size(pupil_data1(:,1001:2001),1)),'lineprops','-b','transparent',1,'patchSaturation',0.05);
    hold on 
    shadedErrorBar(x(1001:2001), mean(pupil_data2(:,1001:2001),1),std(pupil_data2(:,1001:2001),0,1)/sqrt(size(pupil_data2(:,1001:2001),1)),'lineprops','-r','transparent',1,'patchSaturation',0.05);
    hold on 
    shadedErrorBar(x(1001:2001), mean(pupil_data3(:,1001:2001),1),std(pupil_data3(:,1001:2001),0,1)/sqrt(size(pupil_data3(:,1001:2001),1)),'lineprops','-g','transparent',1,'patchSaturation',0.05);
    hold on 
    shadedErrorBar(x(1001:2001), mean(pupil_data4(:,1001:2001),1),std(pupil_data4(:,1001:2001),0,1)/sqrt(size(pupil_data4(:,1001:2001),1)),'lineprops','-k','transparent',1,'patchSaturation',0.05);
    hold on 
    shadedErrorBar(x(1001:2001), mean(pupil_data5(:,1001:2001),1),std(pupil_data5(:,1001:2001),0,1)/sqrt(size(pupil_data5(:,1001:2001),1)),'lineprops','-y','transparent',1,'patchSaturation',0.05);
    hold on 
    plot(x(1001:2001), mean(pupil_data1(:,1001:2001),1),'-b','LineWidth',2);
    hold on
    plot(x(1001:2001), mean(pupil_data2(:,1001:2001),1),'-r','LineWidth',2);
    hold on 
    plot(x(1001:2001), mean(pupil_data3(:,1001:2001),1),'-g','LineWidth',2);
    hold on
    plot(x(1001:2001), mean(pupil_data4(:,1001:2001),1),'-k','LineWidth',2);
    hold on
    plot(x(1001:2001), mean(pupil_data5(:,1001:2001),1),'-y','LineWidth',2);
    
    
    a1=xline(1200,'-','Baseline','alpha',0.065);
    a=xline(1100:1300,'-y','alpha',0.065);
    a2 = xline(1300,'-','Stimuli on');
    a3 = xline(1800,'-','Stimuli off');
    legend(tilt_direction{:},'Location','northeastoutside')
    xlabel('time(ms)')
    ylabel('Pupil area (% change from baseline)') 
    title_name = [subject{kk}];
    %         figpath='C:\Users\86186\Desktop\fig';
    name = [figpath,'/',subject{kk},'_tilt.png'];
    title(title_name)
    saveas(gca,name)


%             if j<5
%                 shadedErrorBar(x(501:2001), mean(pupil_data(:,501:2001),1),std(pupil_data(:,501:2001),0,1)/sqrt(size(pupil_data(:,501:2001),1)),'lineprops','-b','transparent',1,'patchSaturation',0.05)
%                 hold on
%             else
%                 shadedErrorBar(x(501:2001), mean(pupil_data(:,501:2001),1),std(pupil_data(:,501:2001),0,1)/sqrt(size(pupil_data(:,501:2001),1)),'lineprops','-r','transparent',1,'patchSaturation',0.05)
%                 hold on
%             end
%             num_trial(j,3-i) = size(pupil_data,1);    
%     data_name = [figpath,'/',subject{kk},'-num.mat'];
%     save(data_name,'num_trial')
%     figpath='C:\Users\86186\Desktop\fig';
%     name = [figpath,'/',subject{kk}];
%     x=1:2001;
%     figure
%     s1 = shadedErrorBar(x, mean(pupil_data_1,1),std(pupil_data_1,0,1)/sqrt(2001), 'lineprops', '-r');
%     hold on 
%     s2 = shadedErrorBar(x, mean(pupil_data_2,1),std(pupil_data_2,0,1)/sqrt(2001), 'lineprops', '-b');
%     hold on 
%     s3 = shadedErrorBar(x, mean(pupil_data_3,1),std(pupil_data_3,0,1)/sqrt(2001), 'lineprops', '-g');
%     hold on 
%     s4 = shadedErrorBar(x, mean(pupil_data_4,1),std(pupil_data_4,0,1)/sqrt(2001), 'lineprops', '-k');
%     legend( 'CL-CD','CL-OD','OL-CD','OL-OD')
%     title(subject{kk})
%     saveas(gca,name)
end
