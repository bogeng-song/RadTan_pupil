%% plot the raw data figure
clc; clear all;
subject = {'S01','S02','S03','S04','S05','S06'}; condition = {'Full_distance_non_radialtangential', 'Full_distance_radialtangential'}; 
direction = {'VU','VL','HL','HR','LL','LR','UL','UR'};
num = [];
diff=[];

%extract pupil size data
for kk = [2,5]
    pupil_data_1 = [];
    pupil_data_2 = [];
    pupil_data_3 = [];
    pupil_data_4 = [];
    for i = 1 :2
        for j = 1 : 8
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
            % we extract the time from trail_strat - 500 to trail_start +
            % 2000
            if i == 2
                if j < 5 
                    for kkk = 1 : 800
                        trial_st = tab(kkk,2) ;
                        aa=Dat_all(trial_st<=Dat_all(:,1) & Dat_all(:,1)<=trial_st+2000,:);
    %                     order = tab(i,2) < Dat_all(:,1) & tab(i,8) > Dat_all(:,1);
    %                     trial= Dat_all(order,:);
                        if isempty(aa) ==1 
                            continue
                        end
                        num = [num,size(aa,1)];
                        diff = [diff,max(aa(:,1))-min(aa(:,1))];
                        [~,I]= sort(aa(:,1));
                        timepoint = aa(I,4)';

                        if samplingRateData == 500
                            timepoint = upsample_raw(timepoint);
                            timepoint = [timepoint(1),timepoint,timepoint(length(timepoint))];
                        end
                        if samplingRateData == 2000
                            timepoint = downsample(timepoint,2);
                        end

                        if size(timepoint,2) == 2001
                            pupil_data_1 = [pupil_data_1;timepoint];
                        end                	
                    end
                else
                    for kkk = 1 : 800
                        trial_st = tab(kkk,2) ;
                        aa=Dat_all(trial_st<=Dat_all(:,1) & Dat_all(:,1)<=trial_st+2000,:);
    %                     order = tab(i,2) < Dat_all(:,1) & tab(i,8) > Dat_all(:,1);
    %                     trial= Dat_all(order,:);
                        if isempty(aa) ==1 
                            continue
                        end
                        num = [num,size(aa,1)];
                        diff = [diff,max(aa(:,1))-min(aa(:,1))];
                        [~,I]= sort(aa(:,1));
                        timepoint = aa(I,4)';

                        if samplingRateData == 500
                            timepoint = upsample_raw(timepoint);
                            timepoint = [timepoint(1),timepoint,timepoint(length(timepoint))];
                        end
                        if samplingRateData == 2000
                            timepoint = downsample(timepoint,2);
                        end

                        if size(timepoint,2) == 2001 
                            pupil_data_2 = [pupil_data_2;timepoint];
                        end                	
                    end
                end
            else
                if j < 5 
                    for kkk = 1 : 800
                        trial_st = tab(kkk,2) ;
                        aa=Dat_all(trial_st<=Dat_all(:,1) & Dat_all(:,1)<=trial_st+2000,:);
                        if isempty(aa) ==1 
                            continue
                        end
    %                     order = tab(i,2) < Dat_all(:,1) & tab(i,8) > Dat_all(:,1);
    %                     trial= Dat_all(order,:);

                        num = [num,size(aa,1)];
                        diff = [diff,max(aa(:,1))-min(aa(:,1))];
                        [~,I]= sort(aa(:,1));
                        timepoint = aa(I,4)';

                        if samplingRateData == 500
                            timepoint = upsample_raw(timepoint);
                            timepoint = [timepoint(1),timepoint,timepoint(length(timepoint))];
                        end
                        if samplingRateData == 2000
                            timepoint = downsample(timepoint,2);
                        end

                        if size(timepoint,2) == 2001
                            pupil_data_3 = [pupil_data_3;timepoint];
                        end                	
                    end
                else
                    for kkk = 1 : 800
                        trial_st = tab(kkk,2) ;
                        aa=Dat_all(trial_st<=Dat_all(:,1) & Dat_all(:,1)<=trial_st+2000,:);
    %                     order = tab(i,2) < Dat_all(:,1) & tab(i,8) > Dat_all(:,1);
    %                     trial= Dat_all(order,:);
                        if isempty(aa) ==1 
                            continue
                        end
                        num = [num,size(aa,1)];
                        diff = [diff,max(aa(:,1))-min(aa(:,1))];
                        [~,I]= sort(aa(:,1));
                        timepoint = aa(I,4)';

                        if samplingRateData == 500
                            timepoint = upsample_raw(timepoint);
                            timepoint = [timepoint(1),timepoint,timepoint(length(timepoint))];

                        end
                        if samplingRateData == 2000
                            timepoint = downsample(timepoint,2);
                        end

                        if size(timepoint,2) == 2001 
                            pupil_data_4 = [pupil_data_4;timepoint];
                        end                	
                    end
                end
                
            end 
%             sser1=sum(pupil_data_1 == 0 ,2);
%             pupil_data_1=pupil_data_1(sser1==0,:);    
%             sser2=sum(pupil_data_2 == 0 ,2);
%             pupil_data_2=pupil_data_2(sser2==0,:);  
%             
%             sser3=sum(pupil_data_3 == 0 ,2);
%             pupil_data_3=pupil_data_3(sser1==0,:);    
%             sser4=sum(pupil_data_4 == 0 ,2);
%             pupil_data_4=pupil_data_4(sser2==0,:);  
        end
        
    end
    pupil_data_1=pupil_data_1(pupil_data_1(:,2001)~=0,:);
    pupil_data_2=pupil_data_2(pupil_data_2(:,2001)~=0,:);
    pupil_data_3=pupil_data_3(pupil_data_3(:,2001)~=0,:);
    pupil_data_4=pupil_data_4(pupil_data_4(:,2001)~=0,:);
    
    
    
    figpath='C:\Users\86186\Desktop\fig';
    savefile_name1 = [figpath,'/',subject{kk},'-CL-CD.mat'];
    savefile_name2 = [figpath,'/',subject{kk},'-CL-OD.mat'];
    savefile_name3 = [figpath,'/',subject{kk},'-OL-CD.mat'];
    savefile_name4 = [figpath,'/',subject{kk},'-OL-OD.mat'];
    save(savefile_name1,'pupil_data_1')
    save(savefile_name2,'pupil_data_2')
    save(savefile_name3,'pupil_data_3')
    save(savefile_name4,'pupil_data_4')
    
    
    
    
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