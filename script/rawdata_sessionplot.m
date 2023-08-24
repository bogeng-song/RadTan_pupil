%% plot the raw data figure
clc; clear all;
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; condition = {'Full_distance_non_radialtangential', 'Full_distance_radialtangential'}; 
con = {'Location Oblique','Location Cardinal'};
direction = {'VU','VL','HL','HR','LL','LR','UL','UR'};
direction_s3 = {'VL','HL','HR','LL','LR','UL','UR'};
le_direction = {'VU','VL','HL','HR','LL','LR','UL','UR','mean-car','mean-obl'};
le_direction_s3 = {'VL','HL','HR','LL','LR','UL','UR','mean-car','mean-obl'};

loc_direction ={'Cardinal Direction','Oblique Direction'};



num = [];
diff=[];
% color = {'-r','-b','-g','-y','--r','--b','--g','--y'};
color = {'-r','-b'};
x=1:2001;
figpath='C:\Users\86186\Desktop\fig';
%extract pupil size data
for kk = 1:6
   num_trial = zeros(8,2);
%     if kk == 3
%          continue
%     end
    
    pupil_data = [];

    for i = 1 :2
        figure
        if i ==2           
            meanfile1 = [figpath,'/',subject{kk},'-CL-CD-new22.mat'];
            meanfile2 = [figpath,'/',subject{kk},'-CL-OD-new22.mat'];
            load(meanfile1)
            load(meanfile2)
            
            baseline  = mean(pupil_data_1(:,600:800),2);
            pupil_data_1 = (pupil_data_1-baseline)./baseline*100;
            baseline  = mean(pupil_data_2(:,600:800),2);
            pupil_data_2 = (pupil_data_2-baseline)./baseline*100; 
            
            shadedErrorBar(x(1001:2001), mean(pupil_data_1(:,501:1501),1),std(pupil_data_1(:,501:1501),0,1)/sqrt(size(pupil_data_1(:,501:1501),1)), 'lineprops', '-b','transparent',1,'patchSaturation',0.4)
            hold on 
            shadedErrorBar(x(1001:2001), mean(pupil_data_2(:,501:1501),1),std(pupil_data_2(:,501:1501),0,1)/sqrt(size(pupil_data_2(:,501:1501),1)), 'lineprops', '-r','transparent',1,'patchSaturation',0.4)
            hold on
%             plot(x(501:2001), mean(pupil_data_1(:,1001:2001),1),'-b','LineWidth',3)
%             hold on
%             plot(x(501:2001), mean(pupil_data_2(:,1001:2001),1),'-r','LineWidth',3)

        else
            meanfile3 = [figpath,'/',subject{kk},'-OL-CD-new22.mat'];
            meanfile4 = [figpath,'/',subject{kk},'-OL-OD-new22.mat'];
            load(meanfile3)
            load(meanfile4)
            
            baseline  = mean(pupil_data_3(:,600:800),2);
            pupil_data_3 = (pupil_data_3-baseline)./baseline*100;
            baseline  = mean(pupil_data_4(:,600:800),2);
            pupil_data_4 = (pupil_data_4-baseline)./baseline*100; 
            
            shadedErrorBar(x(1001:2001), mean(pupil_data_3(:,501:1501),1),std(pupil_data_3(:,501:1501),0,1)/sqrt(size(pupil_data_3(:,501:1501),1)), 'lineprops', '-b','transparent',1,'patchSaturation',0.4)
            hold on 
            shadedErrorBar(x(1001:2001), mean(pupil_data_4(:,501:1501),1),std(pupil_data_4(:,501:1501),0,1)/sqrt(size(pupil_data_4(:,501:1501),1)), 'lineprops', '-r','transparent',1,'patchSaturation',0.4)
            
%             plot(x(1001:2001), mean(pupil_data_3(:,1001:2001),1),'-b','LineWidth',3)
%             hold on
%             plot(x(1001:2001), mean(pupil_data_4(:,1001:2001),1),'-r','LineWidth',3)         
        end
        
                
                
        for j = 1 : 8
            if i == 1 & j ==1 & kk ==3 
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
            cdt=dir([direction{j},'*_Dat_all_new_22.mat']);
            load(cdt.name)
            for kkk = 1 : 800
                trial_st = tab(kkk,2) ;
                aa=Dat_all_new(trial_st + 500  <=Dat_all_new(:,1) & Dat_all_new(:,1)<=trial_st+2000,:);
                if isempty(aa) ==1                  
                    continue
                end
                num = [num,size(aa,1)];
%                 diff = [diff,max(aa(:,1))-min(aa(:,1))];
                [~,I]= sort(aa(:,1));
                timepoint = aa(I,4)';

                if samplingRateData == 500
                    timepoint = upsample_raw(timepoint);
                    if size(timepoint,2) == 1499
                        timepoint = [timepoint(1),timepoint,timepoint(length(timepoint))];                
                    end
                end
                
                if samplingRateData == 2000
                    timepoint = downsample(timepoint,2);
                end
                if size(timepoint,2) == 1501  
                    pupil_data = [pupil_data;timepoint];
                end 
            end
            
            pupil_data_red = pupil_data;
            
            pupil_data=pupil_data(pupil_data(:,1501)~=0,:);
            
            baseline  = mean(pupil_data(:,600:800),2);
            pupil_data = (pupil_data-baseline)./baseline*100; 
            if j<5
                shadedErrorBar(x(1001:2001), mean(pupil_data(:,501:1501),1),std(pupil_data(:,501:1501),0,1)/sqrt(size(pupil_data(:,501:1501),1)),'lineprops','-b','transparent',1,'patchSaturation',0.05)
                hold on
            else
                shadedErrorBar(x(1001:2001), mean(pupil_data(:,501:1501),1),std(pupil_data(:,501:1501),0,1)/sqrt(size(pupil_data(:,501:1501),1)),'lineprops','-r','transparent',1,'patchSaturation',0.05)
                hold on
            end
            num_trial(j,3-i) = size(pupil_data,1);
            

        end
        if i ==2           
            hold on
            plot(x(1001:2001), mean(pupil_data_1(:,501:1501),1),'-b','LineWidth',3)
            hold on
            plot(x(1001:2001), mean(pupil_data_2(:,501:1501),1),'-r','LineWidth',3)
            
            a1=xline(1200,'-','Baseline','alpha',0.065);
            a=xline(1100:1300,'-y','alpha',0.065);
            a2 = xline(1300,'-','Stimuli on');
            a3 = xline(1800,'-','Stimuli off');
            legend(loc_direction{:},'Location','northeastoutside')
            xlabel('time(ms)')
            ylabel('Pupil area (% change from baseline)')
            
            title_name = [subject{kk},'- ',con{i},];
    %         figpath='C:\Users\86186\Desktop\fig';
            name = [figpath,'/',subject{kk},'_',con{i},'_ps_baseline_new.png'];
            title(title_name)
            if kk == 1
                ylim([-2 5])
            elseif kk ==2 
                ylim([-2 5])
            elseif kk ==3 
                ylim([-2 5])
            elseif kk ==4 
                ylim([-2 6])
            elseif kk ==5 
                ylim([-5 15])
            elseif kk ==6 
                ylim([-2 5])
            end
                
                
            	
            saveas(gca,name)
        else
            hold on
            plot(x(1001:2001), mean(pupil_data_3(:,501:1501),1),'-b','LineWidth',3)
            hold on
            plot(x(1001:2001), mean(pupil_data_4(:,501:1501),1),'-r','LineWidth',3)
            
            a1=xline(1200,'-','Baseline','alpha',0.065);
            a=xline(1100:1300,'-y','alpha',0.065);
            a2 = xline(1300,'-','Stimuli on');
            a3 = xline(1800,'-','Stimuli off');
            legend(loc_direction{:},'Location','northeastoutside')
            xlabel('time(ms)')
            ylabel('Pupil area (% change from baseline)')
            title_name = [subject{kk},'- ',con{i},];
    %         figpath='C:\Users\86186\Desktop\fig';
            name = [figpath,'/',subject{kk},'_',con{i},'_ps_baseline_new.png'];
            title(title_name)
            if kk == 1
                ylim([-2 5])
            elseif kk ==2 
                ylim([-2 5])
            elseif kk ==3 
                ylim([-2 5])
            elseif kk ==4 
                ylim([-2 6])
            elseif kk ==5 
                ylim([-5 15])
            elseif kk ==6 
                ylim([-2 5])
            end
            saveas(gca,name) 
        end
    end
    data_name = [figpath,'/',subject{kk},'-num_new.mat'];
    save(data_name,'num_trial')

end
