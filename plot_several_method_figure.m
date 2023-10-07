%% plot several method figure (normal method)
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; 
subject_name = {'Sub01','Sub02','Sub03','Sub04','Sub05','Sub06','Sub07','Sub08'}; 
condition = {'Full_distance_non_radialtangential','Full_distance_radialtangential'};
con = {'non_r','r'};
direction = {'HL','HR','LL','LR','UL','UR','VL','VU'};
%edf2asc = 'F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Analysis\edf2asc';
%max_length = 5000;
trial_start = 500; % when the data segment begin after trial start
trail_end = 500;   % when the data segment end after next trial start
base_line = [1100,1300]; %the time after trial start
max_num_missing_value = 0.4; % missing rate for whole data length
%data_point_num = 10; %the number of data point patch, when meet blink data

%model parameters (total 8 parameters)
model_data_path= 'E:\RadialBias_project\multi_methd_result\normal_result\';
for ii = 2:2

    for jj = 1 : 1
        
          
        for kk = 1 : 1

            max_length = 5000;

            % max_num_missing_value = 0.4; % missing rate for whole data length

        
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

            original_data_05 = struct();
            original_data_1 = struct();
            original_data_2 = struct();
            original_data_4 = struct();
            original_data_8 = struct();
            osds_05 = 0 ; 
            osds_1 = 0 ; 
            osds_2 = 0 ; 
            osds_4 = 0 ; 
            osds_8 = 0 ; 
            for tt = 1: trial_num-1
                base_line_seg = dat((tab(tt,2)+base_line(1) < dat(:,1) & tab(tt,2)+base_line(2) > dat(:,1)),4);
                if isempty(base_line_seg)
                    continue
                end
                base_line_value = mean(base_line_seg(base_line_seg ~=0));
                if isnan(base_line_value)
                    continue
                end
    
                segment_data = dat((tab(tt,2)+trial_start < dat(:,1) & tab(tt+1,2)+trail_end > dat(:,1)),[1,4]);
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
    
                eyemove_trend = segment_data1(:,2);
                nor_eyemove_trend = (eyemove_trend - base_line_value)/base_line_value;
                window = [trial_start - 1300 , segment_data(size(segment_data,1)) - segment_data(1,1) - 1300 + trial_start ];
%                event_label = {'sti on', 'sti off', 'next trial start'};
                event = [0,500,window(2) - trail_end];
    
    
                rt = tab(tt,14) * 1000 + 500;
                rt = ceil(rt);
                if samplingRateData == 500 && rem(rt,2) ~= 0 
                    rt = rt -1; 
                end
                
                window_length = window(1): (1000/samplingRateData):window(2);
                if (length(nor_eyemove_trend) - length(window_length)) > 0
                    nor_eyemove_trend = nor_eyemove_trend(1:length(window_length));
                end

                if isnan(nor_eyemove_trend(1))
                    continue
                end
     
                if tab(tt,11) ==0.5
                    osds_05 = osds_05 + 1;
                    t_name = ['trial',num2str(osds_05)];
                    original_data_05.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==1
                    osds_1 = osds_1 + 1;
                    t_name = ['trial',num2str(osds_1)];
                    original_data_1.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==2
                    osds_2 = osds_2 + 1;
                    t_name = ['trial',num2str(osds_2)];
                    original_data_2.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==4
                    osds_4 = osds_4 + 1;
                    t_name = ['trial',num2str(osds_4)];
                    original_data_4.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==8
                    osds_8 = osds_8 + 1;
                    t_name = ['trial',num2str(osds_8)];
                    original_data_8.(t_name) = nor_eyemove_trend;
                end
            end


            model_sub_path = [model_data_path,subject_name{ii}];
            cd (model_sub_path)
            filename_para = [con{jj},'-',direction{kk},'*'];
            parameter_list = dir (filename_para);

            for model_ite = 1 : 5 
                load(parameter_list(model_ite).name)
                switch model_ite
                    case 1
                        [model_fit_data_05,x1_05,x2_05] = plot_model_data_ele(tt_05_value,samplingRateData);
                    case 2 
                        [model_fit_data_1,x1_1,x2_1] = plot_model_data_ele(tt_1_value,samplingRateData);
                    case 3 
                        [model_fit_data_2,x1_2,x2_2] = plot_model_data_ele(tt_2_value,samplingRateData);
                    case 4 
                        [model_fit_data_4,x1_4,x2_4] = plot_model_data_ele(tt_4_value,samplingRateData);
                    case 5 
                        [model_fit_data_8,x1_8,x2_8] = plot_model_data_ele(tt_8_value,samplingRateData);
                end


            end
        end
    end
end

%% R^2 distribution
[PDF, X] = ksdensity(tt_05_value(:,10)); % Estimate the probability density function (PDF)

figure;
plot(X, PDF, 'LineWidth', 2);
title('Distrubution about R^2');
xlabel('R^2 Value');
ylabel('Probability Density');


%% plot different trial
trial_num = 72;
trial_num_name = ['trial',num2str(trial_num)];

original_dat = original_data_05.(trial_num_name);
model_dat = model_fit_data_05.(trial_num_name);
x1_dat = x1_05.(trial_num_name);
x2_dat = x2_05.(trial_num_name);
x = (1/2-800) : 0.5 :  (size(original_dat,1)/2 - 800);
figure
plot(x,original_dat,'r')
hold on 
plot(x,model_dat,'b')
hold on
plot(x,x1_dat(1,:),'k')
hold on
xline(0,'-','sti on')
hold on 
xline(500,'-','sti off')
hold on 
xline(tt_05_value(trial_num,16),'-','next trial start')
hold on
xline(tt_05_value(trial_num,4),'-','event1 lantancy')
legend({'original data','model data','event1'},'Location','southwest')
legend('boxoff')

% event_label = {'sti on', 'sti off', 'next trial start'};
% sj = fit_eyemove_model_neg(original_dat',tt_05_value(trial_num,14:16),2000,tt_05_value(trial_num,[12,13]),event_label,tt_05_value(trial_num,17));
% tt_new_fit = [sj.estim.one_trial.ampvals,sj.estim.one_trial.latvals,sj.estim.one_trial.boxampvals,sj.estim.one_trial.tmaxval,sj.estim.one_trial.R2,sj.estim.one_trial.BICrel,sj.estim.one_trial.cost,tt_05_value(trial_num,12:17)];
% [fit_data_new,x1_new,x2_new] = plot_model_data_ele(tt_new_fit,samplingRateData);


%% filter data
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; 
subject_name = {'Sub01','Sub02','Sub03','Sub04','Sub05','Sub06','Sub07','Sub08'}; 
condition = {'Full_distance_non_radialtangential','Full_distance_radialtangential'};
con = {'non_r','r'};
direction = {'HL','HR','LL','LR','UL','UR','VL','VU'};
%edf2asc = 'F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Analysis\edf2asc';
%max_length = 5000;
trial_start = 500; % when the data segment begin after trial start
trail_end = 500;   % when the data segment end after next trial start
base_line = [1100,1300]; %the time after trial start
max_num_missing_value = 0.4; % missing rate for whole data length
%data_point_num = 10; %the number of data point patch, when meet blink data

%model parameters (total 8 parameters)
model_data_path= 'E:\RadialBias_project\multi_methd_result\filter_result\';

for ii = 2:2

    for jj = 1 : 1
        
          
        for kk = 8 : 8
        
            max_length = 5000;

            % max_num_missing_value = 0.4; % missing rate for whole data length

        
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
            original_data_05 = struct();
            original_data_1 = struct();
            original_data_2 = struct();
            original_data_4 = struct();
            original_data_8 = struct();
            osds_05 = 0 ; 
            osds_1 = 0 ; 
            osds_2 = 0 ; 
            osds_4 = 0 ; 
            osds_8 = 0 ; 
            for tt = 1: trial_num - 1 
                base_line_seg = dat((tab(tt,2)+base_line(1) < dat(:,1) & tab(tt,2)+base_line(2) > dat(:,1)),4);
                if isempty(base_line_seg)
                    continue
                end
                base_line_value = mean(base_line_seg(base_line_seg ~=0));
                if isnan(base_line_value)
                    continue
                end
    
                segment_data = dat((tab(tt,2)+trial_start < dat(:,1) & tab(tt+1,2)+trail_end > dat(:,1)),[1,4]);
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
    
                eyemove_trend = segment_data1(:,2);
                nor_eyemove_trend = (eyemove_trend - base_line_value)/base_line_value;
                window = [trial_start - 1300 , segment_data(size(segment_data,1)) - segment_data(1,1) - 1300 + trial_start ];
                event_label = {'sti on', 'sti off', 'next trial start'};
                event = [0,500,window(2) - trail_end];
    
    
                rt = tab(tt,14) * 1000 + 500;
                rt = ceil(rt);
                if samplingRateData == 500 && rem(rt,2) ~= 0 
                    rt = rt -1; 
                end
                
                window_length = window(1): (1000/samplingRateData):window(2);
                if (length(nor_eyemove_trend) - length(window_length)) > 0
                    nor_eyemove_trend = nor_eyemove_trend(1:length(window_length));
                end

                nor_eyemove_trend=filtfilt(fir1(35,0.05),1,nor_eyemove_trend);
                
                if isnan(nor_eyemove_trend(1))
                    continue
                end
     
                if tab(tt,11) ==0.5
                    osds_05 = osds_05 + 1;
                    t_name = ['trial',num2str(osds_05)];
                    original_data_05.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==1
                    osds_1 = osds_1 + 1;
                    t_name = ['trial',num2str(osds_1)];
                    original_data_1.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==2
                    osds_2 = osds_2 + 1;
                    t_name = ['trial',num2str(osds_2)];
                    original_data_2.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==4
                    osds_4 = osds_4 + 1;
                    t_name = ['trial',num2str(osds_4)];
                    original_data_4.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==8
                    osds_8 = osds_8 + 1;
                    t_name = ['trial',num2str(osds_8)];
                    original_data_8.(t_name) = nor_eyemove_trend;
                end
            end


            model_sub_path = [model_data_path,subject_name{ii}];
            cd (model_sub_path)
            filename_para = [con{jj},'-',direction{kk},'*'];
            parameter_list = dir (filename_para);

            for model_ite = 1 : 5 
                load(parameter_list(model_ite).name)
                switch model_ite
                    case 1
                        [model_fit_data_05,x1_05,x2_05] = plot_model_data_ele(tt_05_value,samplingRateData);
                    case 2 
                        [model_fit_data_1,x1_1,x2_1] = plot_model_data_ele(tt_1_value,samplingRateData);
                    case 3 
                        [model_fit_data_2,x1_2,x2_2] = plot_model_data_ele(tt_2_value,samplingRateData);
                    case 4 
                        [model_fit_data_4,x1_4,x2_4] = plot_model_data_ele(tt_4_value,samplingRateData);
                    case 5 
                        [model_fit_data_8,x1_8,x2_8] = plot_model_data_ele(tt_8_value,samplingRateData);
                end


            end
        end
    end
end


%% new method plot, another way to get our data
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; 
subject_name = {'Sub01','Sub02','Sub03','Sub04','Sub05','Sub06','Sub07','Sub08'}; 
condition = {'Full_distance_non_radialtangential','Full_distance_radialtangential'};
con = {'non_r','r'};
direction = {'HL','HR','LL','LR','UL','UR','VL','VU'};
%edf2asc = 'F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Analysis\edf2asc';
%max_length = 5000;
trial_start = 500; % when the data segment begin after trial start
trail_end = 500;   % when the data segment end after next trial start
base_line = [1100,1300]; %the time after trial start
max_num_missing_value = 0.4; % missing rate for whole data length
%data_point_num = 10; %the number of data point patch, when meet blink data

%model parameters (total 8 parameters)
model_data_path= 'E:\RadialBias_project\multi_methd_result\new_method_result\';

for ii = 2:2

    trial_type_summary = cell([1,8]);
    trial_value_summary = cell([1,8]);

    for jj = 1: 1
        
        for kk = 1:1

                        
            max_length = 5000;

            % max_num_missing_value = 0.4; % missing rate for whole data length

        
            main_folder = fullfile('E:\RadialBias_project\RadialBias_pilot1-main\Data_DI_wEYE\Data_DI_wEYE', subject{ii}, ...
                'RawData', condition{jj}, 'Block1','eyedata');

            main_folder2 = fullfile('E:\RadialBias_project\RadialBias_pilot1-main\Data_DI_wEYE\Data_DI_wEYE', subject{ii}, ...
                'RawData', condition{jj}, 'Block1');

            cd (main_folder)

            scr_filepath = fullfile(main_folder2,sprintf('scr_file%s_1dMotionAsym_Psychophysics_%s.mat', ...
                    subject{ii}, direction{kk}));

            load(scr_filepath)

            distanceFromScreen = scr.dist;      % dist of monitor from eye (in cm)
            screenWidthCm = scr.disp_sizeX/10;  % width of monitor (in cm from mm)
            screenWidthPx = scr.scr_sizeX;      % number of pixels (horizontally)
            screenHeightPx = scr.scr_sizeY;     % number of pixels (vertically)
            screenCenter = [screenWidthPx/2 screenHeightPx/2];
            dvaPerPx = rad2deg(atan2(.5*screenWidthCm, distanceFromScreen)) / (.5*screenWidthPx);

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

            trial_type = zeros([trial_num,1]);

            segment_data = dat((tab(1,2)-20 < dat(:,1) & tab(trial_num,8)+20> dat(:,1)),:);
            segment_data = sortrows(segment_data,1);

            segment_data(segment_data(:,4)==0,[2,3]) = 0;

            segment_data_x = segment_data(:,[1,2]);
            segment_data_y = segment_data(:,[1,3]);
            segment_data = segment_data(:,[1,4]);

            segment_data2 = patch_missing_data(segment_data,data_point_num);
            segment_data2(find(isnan(segment_data2)==1)) = 0;
            segment_data2_x = patch_missing_data(segment_data_x,data_point_num);
            segment_data2_y = patch_missing_data(segment_data_y,data_point_num);

            data_x = dvaPerPx*(segment_data2_x(:,2)-screenCenter(1));
            data_y = dvaPerPx*(segment_data2_y(:,2)-screenCenter(2));
            
            %calculate degree
            degrss = data_x.^2 + data_y.^2;
            ord = (data_x.^2 + data_y.^2) > 1.5^2 ; 
            segment_data2(ord,2) = 0 ; 
            segment_data3 = patch_missing_data(segment_data2,data_point_num);

            segment_data1 = add_miss_value(segment_data3);

            original_data_05 = struct();
            original_data_1 = struct();
            original_data_2 = struct();
            original_data_4 = struct();
            original_data_8 = struct();
            osds_05 = 0 ; 
            osds_1 = 0 ; 
            osds_2 = 0 ; 
            osds_4 = 0 ; 
            osds_8 = 0 ; 


            for tt = 1 : trial_num - 1

                base_line_seg = segment_data1((tab(tt,2)+base_line(1) < segment_data1(:,1) & tab(tt,2)+base_line(2) > segment_data1(:,1)),2);
                if isempty(base_line_seg)
                    continue
                end
                base_line_value = mean(base_line_seg(base_line_seg ~=0));
                if isnan(base_line_value)
                    continue
                end

    
                segment_data = segment_data1((tab(tt,2)+trial_start < segment_data1(:,1) & tab(tt+1,2)+trail_end > segment_data1(:,1)),:);
                segment_data = sortrows(segment_data,1);

                if size(segment_data,1) > max_length
                    continue
                end

                eyemove_trend = segment_data(:,2);   
                nor_eyemove_trend = (eyemove_trend - base_line_value)/base_line_value;
                window = [trial_start - 1300 , segment_data(size(segment_data,1)) - segment_data(1,1) - 1300 + trial_start ];
                event_label = {'sti on', 'sti off', 'next trial start'};
                event = [0,500,window(2) - trail_end];

                rt = tab(tt,14) * 1000 + 500;
                rt = ceil(rt);
                if samplingRateData == 500 && rem(rt,2) ~= 0 
                    rt = rt -1; 
                end
                
                window_length = window(1): (1000/samplingRateData):window(2);
                if (length(nor_eyemove_trend) - length(window_length)) > 0
                    nor_eyemove_trend = nor_eyemove_trend(1:length(window_length));
                end

                if isnan(nor_eyemove_trend(1))
                    continue
                end
     
                if tab(tt,11) ==0.5
                    osds_05 = osds_05 + 1;
                    t_name = ['trial',num2str(osds_05)];
                    original_data_05.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==1
                    osds_1 = osds_1 + 1;
                    t_name = ['trial',num2str(osds_1)];
                    original_data_1.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==2
                    osds_2 = osds_2 + 1;
                    t_name = ['trial',num2str(osds_2)];
                    original_data_2.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==4
                    osds_4 = osds_4 + 1;
                    t_name = ['trial',num2str(osds_4)];
                    original_data_4.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==8
                    osds_8 = osds_8 + 1;
                    t_name = ['trial',num2str(osds_8)];
                    original_data_8.(t_name) = nor_eyemove_trend;
                end
            end


            model_sub_path = [model_data_path,subject_name{ii}];
            cd (model_sub_path)
            filename_para = [con{jj},'-',direction{kk},'*'];
            parameter_list = dir (filename_para);

            for model_ite = 1 : 5 
                load(parameter_list(model_ite).name)
                switch model_ite
                    case 1
                        [model_fit_data_05,x1_05,x2_05] = plot_model_data_ele(tt_05_value,samplingRateData);
                    case 2 
                        [model_fit_data_1,x1_1,x2_1] = plot_model_data_ele(tt_1_value,samplingRateData);
                    case 3 
                        [model_fit_data_2,x1_2,x2_2] = plot_model_data_ele(tt_2_value,samplingRateData);
                    case 4 
                        [model_fit_data_4,x1_4,x2_4] = plot_model_data_ele(tt_4_value,samplingRateData);
                    case 5 
                        [model_fit_data_8,x1_8,x2_8] = plot_model_data_ele(tt_8_value,samplingRateData);
                end


            end
        end
    end
end

%% fix tmax filter
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; 
subject_name = {'Sub01','Sub02','Sub03','Sub04','Sub05','Sub06','Sub07','Sub08'}; 
condition = {'Full_distance_non_radialtangential','Full_distance_radialtangential'};
con = {'non_r','r'};
direction = {'HL','HR','LL','LR','UL','UR','VL','VU'};
%edf2asc = 'F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Analysis\edf2asc';
%max_length = 5000;
trial_start = 500; % when the data segment begin after trial start
trail_end = 500;   % when the data segment end after next trial start
base_line = [1100,1300]; %the time after trial start
max_num_missing_value = 0.4; % missing rate for whole data length
%data_point_num = 10; %the number of data point patch, when meet blink data

%model parameters (total 8 parameters)
model_data_path= 'E:\RadialBias_project\multi_methd_result\fix_tmax_fliter\';

for ii = 2:2

    for jj = 1 : 1
        
          
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

            original_data_05 = struct();
            original_data_1 = struct();
            original_data_2 = struct();
            original_data_4 = struct();
            original_data_8 = struct();
            osds_05 = 0 ; 
            osds_1 = 0 ; 
            osds_2 = 0 ; 
            osds_4 = 0 ; 
            osds_8 = 0 ; 

            for tt = 1: trial_num-1
                base_line_seg = dat((tab(tt,2)+base_line(1) < dat(:,1) & tab(tt,2)+base_line(2) > dat(:,1)),4);
                if isempty(base_line_seg)
                    continue
                end
                base_line_value = mean(base_line_seg(base_line_seg ~=0));
                if isnan(base_line_value)
                    continue
                end
    
                segment_data = dat((tab(tt,2)+trial_start < dat(:,1) & tab(tt+1,2)+trail_end > dat(:,1)),[1,4]);
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
    
                eyemove_trend = segment_data1(:,2);
                nor_eyemove_trend = (eyemove_trend - base_line_value)/base_line_value;
                window = [trial_start - 1300 , segment_data(size(segment_data,1)) - segment_data(1,1) - 1300 + trial_start ];
                event_label = {'sti on', 'sti off', 'next trial start'};
                event = [0,500,window(2) - trail_end];
    
    
                rt = tab(tt,14) * 1000 + 500;
                rt = ceil(rt);
                if samplingRateData == 500 && rem(rt,2) ~= 0 
                    rt = rt -1; 
                end
                
                window_length = window(1): (1000/samplingRateData):window(2);
                if (length(nor_eyemove_trend) - length(window_length)) > 0
                    nor_eyemove_trend = nor_eyemove_trend(1:length(window_length));
                end

                nor_eyemove_trend=filtfilt(fir1(35,0.05),1,nor_eyemove_trend); 
                
                if isnan(nor_eyemove_trend(1))
                    continue
                end
     
                if tab(tt,11) ==0.5
                    osds_05 = osds_05 + 1;
                    t_name = ['trial',num2str(osds_05)];
                    original_data_05.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==1
                    osds_1 = osds_1 + 1;
                    t_name = ['trial',num2str(osds_1)];
                    original_data_1.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==2
                    osds_2 = osds_2 + 1;
                    t_name = ['trial',num2str(osds_2)];
                    original_data_2.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==4
                    osds_4 = osds_4 + 1;
                    t_name = ['trial',num2str(osds_4)];
                    original_data_4.(t_name) = nor_eyemove_trend;
                elseif tab(tt,11) ==8
                    osds_8 = osds_8 + 1;
                    t_name = ['trial',num2str(osds_8)];
                    original_data_8.(t_name) = nor_eyemove_trend;
                end
            end


            model_sub_path = [model_data_path,subject_name{ii}];
            cd (model_sub_path)
            filename_para = [con{jj},'-',direction{kk},'*'];
            parameter_list = dir (filename_para);

            for model_ite = 1 : 5 
                load(parameter_list(model_ite).name)
                switch model_ite
                    case 1
                        [model_fit_data_05,x1_05,x2_05] = plot_model_data_ele(tt_05_value,samplingRateData);
                    case 2 
                        [model_fit_data_1,x1_1,x2_1] = plot_model_data_ele(tt_1_value,samplingRateData);
                    case 3 
                        [model_fit_data_2,x1_2,x2_2] = plot_model_data_ele(tt_2_value,samplingRateData);
                    case 4 
                        [model_fit_data_4,x1_4,x2_4] = plot_model_data_ele(tt_4_value,samplingRateData);
                    case 5 
                        [model_fit_data_8,x1_8,x2_8] = plot_model_data_ele(tt_8_value,samplingRateData);
                end


            end
        end
    end
end