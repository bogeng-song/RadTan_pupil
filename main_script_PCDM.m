%% main script
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; 
condition = {'Full_distance_non_radialtangential','Full_distance_radialtangential'};
direction = {'HL','HR','LL','LR','UL','UR','VL','VU'};
%edf2asc = 'F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Analysis\edf2asc';
%max_length = 5000;
trial_start_time = 0; % when the data segment begin after trial start
trail_end_time = 4000;   % when the data segment end after next trial start
base_line = [1100,1300]; %the time after trial start
max_num_missing_value = 0.4; % missing rate for whole data length
%data_point_num = 20; %the number of data point patch, when meet blink data

%model parameters (total 8 parameters)
amp_value = [];
lat_value = [];
box_amp_value = [];
t_max_value =[];

for ii = 1:1
    for jj = 2 : 2
        for kk = 1 : 1
            
            max_length = 5000;

            % max_num_missing_value = 0.4; % missing rate for whole data length

        
            main_folder = fullfile('E:\6.23\RadialBias_pilot1-main\Data_DI_wEYE\Data_DI_wEYE', subject{ii}, ...
                'RawData', condition{jj}, 'Block1','eyedata');

            main_folder2 = fullfile('E:\6.23\RadialBias_pilot1-main\Data_DI_wEYE\Data_DI_wEYE', subject{ii}, ...
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

            data_point_num = 70;

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
            tab_filelist = dir('MATs\*tab_new_outside_blink.mat');
            dat = importdata(filelist(kk).name);
            cd MATs\
            load (tab_filelist(kk).name)

            %extract data segment

            trial_num = size(tab,1);

            trial_pupil = [];
            trial_x = [];
            trial_y = [];
            trial_num = size(tab,1);
            trial_start = ones([trial_num,1]);
            trial_end = ones([trial_num,1]);
            trial_type = zeros([trial_num,1]);
            for tt = 1: trial_num

                if tab(tt,11) == 0.5 
                    trial_type(tt) = 1;
                elseif tab(tt,11) == 1
                    trial_type(tt) = 2;
                elseif tab(tt,11) == 2
                    trial_type(tt) = 3;
                elseif tab(tt,11) == 4
                    trial_type(tt) = 4;
                elseif tab(tt,11) == 8
                    trial_type(tt) = 5;
                end


                

                %segment_data = dat((tab(tt,2)+trial_start_time < dat(:,1) & tab(tt,8)+trail_end_time > dat(:,1)),:);
                segment_data = dat((tab(tt,2)+trial_start_time < dat(:,1) & tab(tt,2)+trail_end_time > dat(:,1)),:);
                segment_data = sortrows(segment_data,1);
                

%                segment_data_x = dvaPerPx*(segment_data(:,2)-screenCenter(1));
%                segment_data_y = dvaPerPx*(segment_data(:,3)-screenCenter(2));

                segment_data(segment_data(:,4)==0,[2,3]) = 0;

                segment_data_x = segment_data(:,[1,2]);
                segment_data_y = segment_data(:,[1,3]);
                segment_data = segment_data(:,[1,4]);
                


                if size(segment_data,1) > max_length
                    continue
                end

                if sum(segment_data(:,2)==0) > max_num_missing_value*size(segment_data,1)
                    continue
                else
                    segment_data2 = patch_missing_data(segment_data,data_point_num);
                    segment_data2_x = patch_missing_data(segment_data_x,data_point_num);
                    segment_data2_y = patch_missing_data(segment_data_y,data_point_num);

                    segment_data1 = add_miss_value(segment_data2);
                    segment_data1_x = add_miss_value(segment_data2_x);
                    segment_data1_y = add_miss_value(segment_data2_y);

                    data_x = dvaPerPx*(segment_data1_x(:,2)-screenCenter(1));
                    data_y = dvaPerPx*(segment_data1_y(:,2)-screenCenter(2));
                    if tt < trial_num
                        trial_start(tt+1) = size(segment_data,1);
                    end
                    trial_end(tt) = size(segment_data,1);

                    trial_pupil = [trial_pupil;segment_data1(:,2)];
                    trial_x = [trial_x;data_x];
                    trial_y = [trial_y;data_y];    
                end 
            end
            trial_start_c = cumsum(trial_start);
            trial_end_c = cumsum(trial_end);
            in_e.pupilArea{1} = trial_pupil;
            in_e.sampleRate{1} = samplingRateData;
            in_e.xPos{1} = trial_x;
            in_e.yPos{1} = trial_y;
            in_e.trialTypes{1} = trial_type';
            in_e.startInds{1} = [trial_start_c,trial_end_c];


        end
    end
end


%% main script, another way to get our data
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; 
condition = {'Full_distance_non_radialtangential','Full_distance_radialtangential'};
direction = {'HL','HR','LL','LR','UL','UR','VL','VU'};
%edf2asc = 'F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Analysis\edf2asc';
%max_length = 5000;
trial_start_time = 500; % when the data segment begin after trial start
trail_end_time = 4000;   % when the data segment end after next trial start
base_line = [1100,1300]; %the time after trial start
max_num_missing_value = 0.4; % missing rate for whole data length
%data_point_num = 20; %the number of data point patch, when meet blink data

%model parameters (total 8 parameters)
amp_value = [];
lat_value = [];
box_amp_value = [];
t_max_value =[];

for ii = 2:2
    for jj = 2 : 2
        for kk = 1 : 1
            
            max_length = 5000;

            % max_num_missing_value = 0.4; % missing rate for whole data length

        
            main_folder = fullfile('E:\6.23\RadialBias_pilot1-main\Data_DI_wEYE\Data_DI_wEYE', subject{ii}, ...
                'RawData', condition{jj}, 'Block1','eyedata');

            main_folder2 = fullfile('E:\6.23\RadialBias_pilot1-main\Data_DI_wEYE\Data_DI_wEYE', subject{ii}, ...
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
            tab_filelist = dir('MATs\*tab_new_outside_blink.mat');
            dat = importdata(filelist(kk).name);
            cd MATs\
            load (tab_filelist(kk).name)

            %extract data segment


%             trial_pupil = [];
%             trial_x = [];
%             trial_y = [];
            trial_num = size(tab,1);
            trial_start = ones([trial_num,1]);
            trial_end = ones([trial_num,1]);
            trial_type = zeros([trial_num,1]);

            segment_data = dat((tab(1,2)-20 < dat(:,1) & tab(trial_num,8)+20> dat(:,1)),:);
            segment_data = sortrows(segment_data,1);

            segment_data(segment_data(:,4)==0,[2,3]) = 0;

            segment_data_x = segment_data(:,[1,2]);
            segment_data_y = segment_data(:,[1,3]);
            segment_data = segment_data(:,[1,4]);

            segment_data2 = patch_missing_data(segment_data,data_point_num);
            segment_data2_x = patch_missing_data(segment_data_x,data_point_num);
            segment_data2_y = patch_missing_data(segment_data_y,data_point_num);

            segment_data1 = add_miss_value(segment_data2);
            segment_data1_x = add_miss_value(segment_data2_x);
            segment_data1_y = add_miss_value(segment_data2_y);

            data_x = dvaPerPx*(segment_data1_x(:,2)-screenCenter(1));
            data_y = dvaPerPx*(segment_data1_y(:,2)-screenCenter(2));
                


            for tt = 1: trial_num

                if tab(tt,11) == 0.5 
                    trial_type(tt) = 1;
                elseif tab(tt,11) == 1
                    trial_type(tt) = 2;
                elseif tab(tt,11) == 2
                    trial_type(tt) = 3;
                elseif tab(tt,11) == 4
                    trial_type(tt) = 4;
                elseif tab(tt,11) == 8
                    trial_type(tt) = 5;
                end
                if samplingRateData == 500
                    trial_ssst = find(tab(tt,2)==segment_data(:,1) | tab(tt,2)+1 ==segment_data(:,1));
                    trial_eeed = find(tab(tt,8)==segment_data(:,1) | tab(tt,8)+1 ==segment_data(:,1));
                end

                trial_start(tt) = trial_ssst;
                trial_end(tt) = trial_eeed;

                


                
            end
            startInds = [trial_start,trial_end];
            if samplingRateData == 500 
                startInds = startInds((trial_end-trial_start)<2000,:);
                trial_type = trial_type((trial_end-trial_start)<2000,:);
            end

            %trial_start_c = cumsum(trial_start);
            %trial_end_c = cumsum(trial_end);
            in_e.pupilArea{1} = segment_data1(:,2);
            in_e.sampleRate{1} = samplingRateData;
            in_e.xPos{1} = data_x;
            in_e.yPos{1} = data_y;
            in_e.trialTypes{1} = trial_type';
            in_e.startInds{1} = startInds;


        end
    end
end

%% main script, another way to get our data + delete outside point
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; 
condition = {'Full_distance_non_radialtangential','Full_distance_radialtangential'};
direction = {'HL','HR','LL','LR','UL','UR','VL','VU'};
%edf2asc = 'F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Analysis\edf2asc';
%max_length = 5000;
trial_start_time = 800; % when the data segment begin after trial start
trail_end_time = 4000;   % when the data segment end after next trial start
max_num_missing_value = 0.4; % missing rate for whole data length
%data_point_num = 20; %the number of data point patch, when meet blink data

%model parameters (total 8 parameters)
amp_value = [];
lat_value = [];
box_amp_value = [];
t_max_value =[];

for ii = 1:1
    for jj = 2 : 2
        for kk = 1 : 1
            
            max_length = 5000;

            % max_num_missing_value = 0.4; % missing rate for whole data length

        
            main_folder = fullfile('E:\6.23\RadialBias_pilot1-main\Data_DI_wEYE\Data_DI_wEYE', subject{ii}, ...
                'RawData', condition{jj}, 'Block1','eyedata');

            main_folder2 = fullfile('E:\6.23\RadialBias_pilot1-main\Data_DI_wEYE\Data_DI_wEYE', subject{ii}, ...
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
            tab_filelist = dir('MATs\*tab_new_outside_blink.mat');
            dat = importdata(filelist(kk).name);
            cd MATs\
            load (tab_filelist(kk).name)

            %extract data segment


%             trial_pupil = [];
%             trial_x = [];
%             trial_y = [];
            trial_num = size(tab,1);
            trial_start = ones([trial_num,1]);
            trial_end = ones([trial_num,1]);
            trial_type = zeros([trial_num,1]);

            segment_data = dat((tab(1,2)-20 < dat(:,1) & tab(trial_num,8)+20> dat(:,1)),:);
            segment_data = sortrows(segment_data,1);

            segment_data(segment_data(:,4)==0,[2,3]) = 0;

            segment_data_x = segment_data(:,[1,2]);
            segment_data_y = segment_data(:,[1,3]);
            segment_data = segment_data(:,[1,4]);

            segment_data2 = patch_missing_data(segment_data,data_point_num);
            segment_data2_x = patch_missing_data(segment_data_x,data_point_num);
            segment_data2_y = patch_missing_data(segment_data_y,data_point_num);

            segment_data1 = add_miss_value(segment_data2);
            segment_data1_x = add_miss_value(segment_data2_x);
            segment_data1_y = add_miss_value(segment_data2_y);

            data_x = dvaPerPx*(segment_data1_x(:,2)-screenCenter(1));
            data_y = dvaPerPx*(segment_data1_y(:,2)-screenCenter(2));

            %find outside point > 1.5^2

            order = find((data_y.^2 + data_x.^2) > 1.5^2);
            segment_data1(order,2) = 0;
            segment_data1_x(order,2) = 0;
            segment_data1_y(order,2) = 0;

            sd1  =  add_miss_value(segment_data1);
            sd1_x=  add_miss_value(segment_data1_x);
            sd1_y=  add_miss_value(segment_data1_y);

            data_x = dvaPerPx*(sd1_x(:,2)-screenCenter(1));
            data_y = dvaPerPx*(sd1_y(:,2)-screenCenter(1));
                


            for tt = 1: trial_num

                if tab(tt,11) == 0.5 
                    trial_type(tt) = 1;
                elseif tab(tt,11) == 1
                    trial_type(tt) = 2;
                elseif tab(tt,11) == 2
                    trial_type(tt) = 3;
                elseif tab(tt,11) == 4
                    trial_type(tt) = 4;
                elseif tab(tt,11) == 8
                    trial_type(tt) = 5;
                end
                if samplingRateData == 500
                    trial_ssst = find(tab(tt,2) + trial_start_time ==segment_data(:,1) | tab(tt,2)+1 + trial_start_time ==segment_data(:,1));
                    trial_eeed = find(tab(tt,8) ==segment_data(:,1) | tab(tt,8)+1 ==segment_data(:,1));
                end

                trial_start(tt) = trial_ssst;
                trial_end(tt) = trial_eeed;

                


                
            end
            startInds = [trial_start,trial_end];
            if samplingRateData == 500 
                startInds = startInds((trial_end-trial_start)<2000,:);
                trial_type = trial_type((trial_end-trial_start)<2000,:);
            end

            %trial_start_c = cumsum(trial_start);
            %trial_end_c = cumsum(trial_end);
            in_e.pupilArea{1} = sd1(:,2);
            in_e.sampleRate{1} = samplingRateData;
            in_e.xPos{1} = data_x;
            in_e.yPos{1} = data_y;
            in_e.trialTypes{1} = trial_type';
            in_e.startInds{1} = startInds;


        end
    end
end




%% example sub2 for PCDM model fit
example_data.xPos = [];
example_data.yPos = [];
tab_filelist = dir('MATs\*tab_new_outside_blink.mat');
filelist = dir('*.dat');
dat = importdata(filelist(1).name);
cd MATs\
load (tab_filelist(1).name)





distanceFromScreen = scr.dist;      % dist of monitor from eye (in cm)
screenWidthCm = scr.disp_sizeX/10;  % width of monitor (in cm from mm)
screenWidthPx = scr.scr_sizeX;      % number of pixels (horizontally)
screenHeightPx = scr.scr_sizeY;     % number of pixels (vertically)
screenCenter = [screenWidthPx/2 screenHeightPx/2];

x=dvaPerPx*(dat(:,2)-screenCenter(1));
y=dvaPerPx*(dat(:,3)-screenCenter(2));

example_data.xPos = {x};
example_data.yPos = {y};

trialtype = ones([800,1]);

example_data.trialTypes = {trialtype};
trial_start = tab(:,2) - dat(1,1);
trial_end = tab(:,8) - dat(1,1);

example_data.startInds = {[trial_start,trial_end]};
example_data.trialTypes = {trialtype};
example_data.sampleRate = {[500]};
example_data.pupilArea = {dat(:,4)};

[d, op] = dataAnalysis(example_data);
[d_ex,f_ex] = fitModel(example_data);

[d_ex,f_ex] = fitModel(in_e);


[d,f] = fitModel(in);

in.pupilArea{1}