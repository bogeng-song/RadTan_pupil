%% plot the multi-result figure
folder_list = dir('E:\6.23\multi_methd_result');
subject = {'sub01','sub02','sub03','sub04','sub05','sub06','sub07','sub08'}; 
foldpath = 'E:\6.23\multi_methd_result\';
figpath_o = 'C:\Users\18611\Desktop\figure\multi_method\';

%total 17 cols, 
%amp_value(3),lat_value(3),box_amp_value(1),t_max_value(1),bic(1),r2(1),cost(1),window(2),eventtimes(3),boxtimes(1)
for kk = 3 : 8
    for sub = 4 : 4 
    result_path = [foldpath,folder_list(kk).name,'\',subject{sub},'\'];
    filename = dir (result_path);
    figpath = [figpath_o,folder_list(kk).name];


    fileline = 3 : 82 ;

%    car = [1:10,31:40] + 2;
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

    %figure plot

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
    %legend(c(1,1:3),{'event1','event2','event3'})
    title('amplitude')
    name_f = [figpath,'\',subject{sub},'-amp.png'];
    saveas(gca,name_f)


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
    name_f = [figpath,'\',subject{sub},'-lat.png'];
    saveas(gca,name_f)
    
    %box_amp
    y = [car_05_mean(7),car_1_mean(7),car_2_mean(7),car_4_mean(7),car_8_mean(7), ...,
        obl_05_mean(7),obl_1_mean(7),obl_2_mean(7),obl_4_mean(7),obl_8_mean(7)];
    
    figure
    c=bar(x,y);
    title('box amp')
    name_f = [figpath,'\',subject{sub},'-box_amp.png'];
    saveas(gca,name_f)
    
    
    %t_max
    y = [car_05_mean(8),car_1_mean(8),car_2_mean(8),car_4_mean(8),car_8_mean(8), ...,
        obl_05_mean(8),obl_1_mean(8),obl_2_mean(8),obl_4_mean(8),obl_8_mean(8)];
    
    figure
    c=bar(x,y);
    title('t max value')
    name_f = [figpath,'\',subject{sub},'-tmax.png'];
    saveas(gca,name_f)


    end
end

%% plot the multi-result figure with R^2 limation
folder_list = dir('E:\6.23\multi_methd_result');
subject = {'sub01','sub02','sub03','sub04','sub05','sub06','sub07','sub08'}; 
foldpath = 'E:\6.23\multi_methd_result\';
figpath_o = 'C:\Users\18611\Desktop\figure\multi_r2_result\';
R2_lim = 0.1;


%total 17 cols, 
%amp_value(3),lat_value(3),box_amp_value(1),t_max_value(1),bic(1),r2(1),cost(1),window(2),eventtimes(3),boxtimes(1)
for kk = 3 : 8
    for sub = 4 : 4 
    result_path = [foldpath,folder_list(kk).name,'\',subject{sub},'\'];
    filename = dir (result_path);
    figpath = [figpath_o,folder_list(kk).name];


    fileline = 3 : 82 ;

%    car = [1:10,31:40] + 2;
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
        tt_05_value = tt_05_value(tt_05_value(:,10)>R2_lim,:);
        car_05_value = [car_05_value;tt_05_value];
    end
    
    for ii = car_1
        name = [result_path,filename(ii).name];
        load (name)
        tt_1_value = tt_1_value(tt_1_value(:,10)>R2_lim,:);
        car_1_value = [car_1_value;tt_1_value];
    end
    
    for ii = car_2
        name = [result_path,filename(ii).name];
        load (name)
        tt_2_value = tt_2_value(tt_2_value(:,10)>R2_lim,:);
        car_2_value = [car_2_value;tt_2_value];
    end
    
    for ii = car_4
        name = [result_path,filename(ii).name];
        load (name)
        tt_4_value = tt_4_value(tt_4_value(:,10)>R2_lim,:);
        car_4_value = [car_4_value;tt_4_value];
    end
    
    for ii = car_8
        name = [result_path,filename(ii).name];
        load (name)
        tt_8_value = tt_8_value(tt_8_value(:,10)>R2_lim,:);
        car_8_value = [car_8_value;tt_8_value];
    end
    
    for ii = obl_05
        name = [result_path,filename(ii).name];
        load (name)
        tt_05_value = tt_05_value(tt_05_value(:,10)>R2_lim,:);
        obl_05_value = [obl_05_value;tt_05_value];
    end
    
    for ii = obl_1
        name = [result_path,filename(ii).name];
        load (name)
        tt_1_value = tt_1_value(tt_1_value(:,10)>R2_lim,:);
        obl_1_value = [obl_1_value;tt_1_value];
    end
    
    for ii = obl_2
        name = [result_path,filename(ii).name];
        load (name)
        tt_2_value = tt_2_value(tt_2_value(:,10)>R2_lim,:);
        obl_2_value = [obl_2_value;tt_2_value];
    end
    
    for ii = obl_4
        name = [result_path,filename(ii).name];
        load (name)
        tt_4_value = tt_4_value(tt_4_value(:,10)>R2_lim,:);
        obl_4_value = [obl_4_value;tt_4_value];
    end
    
    for ii = obl_8
        name = [result_path,filename(ii).name];
        load (name)
        tt_8_value = tt_8_value(tt_8_value(:,10)>R2_lim,:);
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

    %figure plot

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
    %legend(c(1,1:3),{'event1','event2','event3'})
    title('amplitude')
    name_f = [figpath,'\',subject{sub},'-amp.png'];
    saveas(gca,name_f)


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
    name_f = [figpath,'\',subject{sub},'-lat.png'];
    saveas(gca,name_f)
    
    %box_amp
    y = [car_05_mean(7),car_1_mean(7),car_2_mean(7),car_4_mean(7),car_8_mean(7), ...,
        obl_05_mean(7),obl_1_mean(7),obl_2_mean(7),obl_4_mean(7),obl_8_mean(7)];
    
    figure
    c=bar(x,y);
    title('box amp')
    name_f = [figpath,'\',subject{sub},'-box_amp.png'];
    saveas(gca,name_f)
    
    
    %t_max
    y = [car_05_mean(8),car_1_mean(8),car_2_mean(8),car_4_mean(8),car_8_mean(8), ...,
        obl_05_mean(8),obl_1_mean(8),obl_2_mean(8),obl_4_mean(8),obl_8_mean(8)];
    
    figure
    c=bar(x,y);
    title('t max value')
    name_f = [figpath,'\',subject{sub},'-tmax.png'];
    saveas(gca,name_f)


    end
end

%% generate model data
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
model_data_path= 'E:\6.23\multi_methd_result\normal_result\';
for ii = 4:4

    for jj = 1 : 1
        
          
        for kk = 1 : 1

            max_length = 5000;

            % max_num_missing_value = 0.4; % missing rate for whole data length

        
            main_folder = fullfile('E:\6.23\RadialBias_pilot1-main\Data_DI_wEYE\Data_DI_wEYE', subject{ii}, ...
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

            original_data_05 = nan(trial_num-1,max_length);
            original_data_1 = nan(trial_num-1,max_length);
            original_data_2 = nan(trial_num-1,max_length);
            original_data_4 = nan(trial_num-1,max_length);
            original_data_8 = nan(trial_num-1,max_length);
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

                if tab(tt,11) ==0.5
                    original_data_05(tt,1:length(nor_eyemove_trend)) = nor_eyemove_trend;
                elseif tab(tt,11) ==1
                    original_data_1(tt,1:length(nor_eyemove_trend)) = nor_eyemove_trend;
                elseif tab(tt,11) ==2
                    original_data_2(tt,1:length(nor_eyemove_trend)) = nor_eyemove_trend;
                elseif tab(tt,11) ==4
                    original_data_4(tt,1:length(nor_eyemove_trend)) = nor_eyemove_trend;
                elseif tab(tt,11) ==8
                    original_data_8(tt,1:length(nor_eyemove_trend)) = nor_eyemove_trend;
                end
            end

            original_data_05 = original_data_05(~isnan(original_data_05(:,1)),:);
            original_data_1 = original_data_1(~isnan(original_data_1(:,1)),:);
            original_data_2 = original_data_2(~isnan(original_data_2(:,1)),:);
            original_data_4 = original_data_4(~isnan(original_data_4(:,1)),:);
            original_data_8 = original_data_8(~isnan(original_data_8(:,1)),:);

            model_sub_path = [model_data_path,subject_name{ii}];
            cd (model_sub_path)
            filename_para = [con{jj},'-',direction{kk},'*'];
            parameter_list = dir (filename_para);

            for model_ite = 1 : 5 
                load(parameter_list(model_ite).name)
                switch model_ite
                    case 1
                        model_fit_data_05 = plot_model_data(tt_05_value,samplingRateData);
                    case 2 
                        model_fit_data_1 = plot_model_data(tt_1_value,samplingRateData);
                    case 3 
                        model_fit_data_2 = plot_model_data(tt_2_value,samplingRateData);
                    case 4 
                        model_fit_data_4 = plot_model_data(tt_4_value,samplingRateData);
                    case 5 
                        model_fit_data_8 = plot_model_data(tt_8_value,samplingRateData);
                end


            end
        end
    end
end

%% one example
m1 = model_fit_data_05(1,:);
od1 = original_data_05(1,:);
x= 1 : 4717;
figure
hold on 
plot(x,m1(x))
hold on
plot(x,od1(x))

%% run if we add a limitation for R^2 or BIC 
R2_lim = 0.1;

model_fit_data_05 = model_fit_data_05(tt_05_value(:,10)>R2_lim,:);
original_data_05 = original_data_05(tt_05_value(:,10)>R2_lim,:);
model_fit_data_1 = model_fit_data_1(tt_1_value(:,10)>R2_lim,:);
original_data_1 = original_data_1(tt_1_value(:,10)>R2_lim,:);
model_fit_data_2 = model_fit_data_2(tt_2_value(:,10)>R2_lim,:);
original_data_2 = original_data_2(tt_2_value(:,10)>R2_lim,:);
model_fit_data_4 = model_fit_data_4(tt_4_value(:,10)>R2_lim,:);
original_data_4 = original_data_4(tt_4_value(:,10)>R2_lim,:);
model_fit_data_8 = model_fit_data_8(tt_8_value(:,10)>R2_lim,:);
original_data_8 = original_data_8(tt_8_value(:,10)>R2_lim,:);