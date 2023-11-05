%% create the subject/session based value
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; 
subject_name = {'Sub01','Sub02','Sub03','Sub04','Sub05','Sub06','Sub07','Sub08'}; 
condition = {'Full_distance_non_radialtangential','Full_distance_radialtangential'};
con = {'non_r','r'};
direction = {'HL','HR','LL','LR','UL','UR','VL','VU'};
%edf2asc = 'F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Analysis\edf2asc';
%max_length = 5000;
trial_start = 0; % when the data segment begin after trial start
trail_end = 2500;   % when the data segment end after next trial start
%base_line = [1100,1300]; %the time after trial start
max_num_missing_value = 0.4; % missing rate for whole data length
%data_point_num = 10; %the number of data point patch, when meet blink data

%model parameters (total 8 parameters)
model_data_path= 'E:\RadialBias_project\multi_methd_result\normal_result\';
for ii = 2:2

    cardinal_data_05 = struct();
    cardinal_data_1 = struct();
    cardinal_data_2 = struct();
    cardinal_data_4 = struct();
    cardinal_data_8 = struct();

    osds_05 = 0 ; 
    osds_1 = 0 ; 
    osds_2 = 0 ; 
    osds_4 = 0 ; 
    osds_8 = 0 ; 

    oblique_data_05 = struct();
    oblique_data_1 = struct();
    oblique_data_2 = struct();
    oblique_data_4 = struct();
    oblique_data_8 = struct();

    obsds_05 = 0 ; 
    obsds_1 = 0 ; 
    obsds_2 = 0 ; 
    obsds_4 = 0 ; 
    obsds_8 = 0 ; 

    for jj = 1 : 2
        
          
        for kk = 1 : 8

            max_length = 5000;
        
            main_folder = fullfile('E:\RadialBias_project\RadialBias_pilot1-main\Data_DI_wEYE\Data_DI_wEYE', subject{ii}, ...
                'RawData', condition{jj}, 'Block1','eyedata');

            cd (main_folder)

            edf_name = dir(sprintf('*%s*.edf', direction{kk})).name;
            edf_path = fullfile(main_folder,edf_name);
            msg_filepath=replace(edf_path,'edf','msg');
            samplingRateData=findSamplingRate(msg_filepath);

            data_point_num = 150;

            if samplingRateData == 500 
                data_point_num = data_point_num/2;
            elseif samplingRateData == 2000
                data_point_num = data_point_num*2;
            end

            if samplingRateData == 500
                max_length = max_length/2;
            elseif samplingRateData == 2000
                max_length = max_length*2;
            end

            filelist = dir('*.dat');
            tab_filelist = dir('MATs/*tab_new_outside_blink.mat');
            dat = importdata(filelist(kk).name);
            cd MATs/
            load (tab_filelist(kk).name)
            %extract data segment
            trial_num = size(tab,1);

            if kk == 1 || kk == 2 || kk == 7 || kk == 8 
                for tt = 1: trial_num-1
        
                    segment_data = dat((tab(tt,2)+trial_start < dat(:,1) & tab(tt,2)+trail_end > dat(:,1)),[1,4]);
                    segment_data = sortrows(segment_data,1);
        
                    if size(segment_data,1) > max_length
                        continue
                    end
        
                    if sum(segment_data(:,2)==0) > max_num_missing_value*size(segment_data,1)
                        continue
                    else
                        segment_data2 = patch_missing_data(segment_data,data_point_num);
                        segment_data1 = add_miss_value(segment_data2);
                    end
        
    
                    if tab(tt,11) ==0.5
                        osds_05 = osds_05 + 1;
                        t_name = ['trial',num2str(osds_05)];
                        cardinal_data_05.(t_name) = segment_data1;
                    elseif tab(tt,11) ==1
                        osds_1 = osds_1 + 1;
                        t_name = ['trial',num2str(osds_1)];
                        cardinal_data_1.(t_name) = segment_data1;
                    elseif tab(tt,11) ==2
                        osds_2 = osds_2 + 1;
                        t_name = ['trial',num2str(osds_2)];
                        cardinal_data_2.(t_name) = segment_data1;
                    elseif tab(tt,11) ==4
                        osds_4 = osds_4 + 1;
                        t_name = ['trial',num2str(osds_4)];
                        cardinal_data_4.(t_name) = segment_data1;
                    elseif tab(tt,11) ==8
                        osds_8 = osds_8 + 1;
                        t_name = ['trial',num2str(osds_8)];
                        cardinal_data_8.(t_name) = segment_data1;
                    end
                end

            else
                for tt = 1: trial_num-1
        
                    segment_data = dat((tab(tt,2)+trial_start < dat(:,1) & tab(tt,2)+trail_end > dat(:,1)),[1,4]);
                    segment_data = sortrows(segment_data,1);
        
                    if size(segment_data,1) > max_length
                        continue
                    end
        
                    if sum(segment_data(:,2)==0) > max_num_missing_value*size(segment_data,1)
                        continue
                    else
                        segment_data2 = patch_missing_data(segment_data,data_point_num);
                        segment_data1 = add_miss_value(segment_data2);
                    end
        
    
                    if tab(tt,11) ==0.5
                        obsds_05 = obsds_05 + 1;
                        t_name = ['trial',num2str(obsds_05)];
                        oblique_data_05.(t_name) = segment_data1;
                    elseif tab(tt,11) ==1
                        obsds_1 = obsds_1 + 1;
                        t_name = ['trial',num2str(obsds_1)];
                        oblique_data_1.(t_name) = segment_data1;
                    elseif tab(tt,11) ==2
                        obsds_2 = obsds_2 + 1;
                        t_name = ['trial',num2str(obsds_2)];
                        oblique_data_2.(t_name) = segment_data1;
                    elseif tab(tt,11) ==4
                        obsds_4 = obsds_4 + 1;
                        t_name = ['trial',num2str(obsds_4)];
                        oblique_data_4.(t_name) = segment_data1;
                    elseif tab(tt,11) ==8
                        obsds_8 = obsds_8 + 1;
                        t_name = ['trial',num2str(obsds_8)];
                        oblique_data_8.(t_name) = segment_data1;
                    end
                end
            end



        end
    end
end
