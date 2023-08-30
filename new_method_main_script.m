%% main script, another way to get our data
subject = {'S01','S02','S03','S04','S05','S06','S07','S08'}; 
condition = {'Full_distance_non_radialtangential','Full_distance_radialtangential'};
direction = {'HL','HR','LL','LR','UL','UR','VL','VU'};
%edf2asc = 'F:\RadialBias_pilot1-main\RadialBias_pilot1-main\Analysis\edf2asc';
%max_length = 5000;
trial_start = 500; % when the data segment begin after trial start
trail_end = 500;   % when the data segment end after next trial start
base_line = [1100,1300]; %the time after trial start
max_num_missing_value = 0.4; % missing rate for whole data length
%data_point_num = 20; %the number of data point patch, when meet blink data

%model parameters (total 8 parameters)
amp_value = [];
lat_value = [];
box_amp_value = [];
t_max_value =[];

for ii = 1:1
%     if ii == 3 
%         continue
%     end
    trial_type_summary = cell([1,8]);
    trial_value_summary = cell([1,8]);

    for jj = 1: 1
        
        for kk = 1:1

            amp_value_05 = [];
            lat_value_05 = [];
            box_amp_value_05 = [];
            t_max_value_05 =[];
            bic_05 = [];
            cost_05 = [];
            r2_05 = [];
            window_05 = [];
            eventtimes_05 = [];
            boxtimes_05 = [];


            amp_value_1 = [];
            lat_value_1 = [];
            box_amp_value_1 = [];
            t_max_value_1 =[];
            bic_1 = [];
            cost_1 = [];
            r2_1 = [];
            window_1 = [];
            eventtimes_1 = [];
            boxtimes_1 = [];
            
            amp_value_2 = [];
            lat_value_2 = [];
            box_amp_value_2 = [];
            t_max_value_2 =[];
            bic_2 = [];
            cost_2 = [];
            r2_2 = [];
            window_2 = [];
            eventtimes_2 = [];
            boxtimes_2 = [];
            
            amp_value_4 = [];
            lat_value_4 = [];
            box_amp_value_4 = [];
            t_max_value_4 =[];
            bic_4 = [];
            cost_4 = [];
            r2_4 = [];
            window_4 = [];
            eventtimes_4 = [];
            boxtimes_4 = [];
            
            amp_value_8 = [];
            lat_value_8 = [];
            box_amp_value_8 = [];
            t_max_value_8 =[];
            bic_8 = [];
            cost_8 = [];
            r2_8= [];
            window_8 = [];
            eventtimes_8 = [];
            boxtimes_8 = [];
                        
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
            tab_filelist = dir('MATs/*tab_new_outside_blink.mat');
            dat = importdata(filelist(kk).name);
            cd MATs/
            load (tab_filelist(kk).name)

            %extract data segment



             trial_num = size(tab,1);
%             trial_start = ones([trial_num,1]);
%             trial_end = ones([trial_num,1]);
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
            segment_data2(ord,:) = 0 ; 
            segment_data3 = patch_missing_data(segment_data2,data_point_num);

            segment_data1 = add_miss_value(segment_data3);

            %for tt = 1 : trial_num - 1
            for tt = 1 : 1

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

                sj = fit_eyemove_model(nor_eyemove_trend',event,samplingRateData,window,event_label,rt);
                
                if tab(tt,11) ==0.5
                    amp_value_05 = [amp_value_05;sj.estim.one_trial.ampvals];
                    lat_value_05 = [lat_value_05;sj.estim.one_trial.latvals];
                    box_amp_value_05 = [box_amp_value_05;sj.estim.one_trial.boxampvals];
                    t_max_value_05 =[t_max_value_05;sj.estim.one_trial.tmaxval];
                    r2_05 = [r2_05;sj.estim.one_trial.R2];
                    bic_05 = [bic_05;sj.estim.one_trial.BICrel];
                    cost_05 = [cost_05;sj.estim.one_trial.cost];
                    window_05 = [window_05;window];
                    eventtimes_05 = [eventtimes_05;event];
                    boxtimes_05 = [boxtimes_05;rt];





                elseif tab(tt,11) == 1 
    
                    amp_value_1 = [amp_value_1;sj.estim.one_trial.ampvals];
                    lat_value_1 = [lat_value_1;sj.estim.one_trial.latvals];
                    box_amp_value_1 = [box_amp_value_1;sj.estim.one_trial.boxampvals];
                    t_max_value_1 =[t_max_value_1;sj.estim.one_trial.tmaxval];
                    r2_1 = [r2_1;sj.estim.one_trial.R2];
                    bic_1 = [bic_1;sj.estim.one_trial.BICrel];
                    cost_1 = [cost_1;sj.estim.one_trial.cost];
                    window_1 = [window_1;window];
                    eventtimes_1 = [eventtimes_1;event];
                    boxtimes_1 = [boxtimes_1;rt];
    
                elseif tab(tt,11) == 2
                    amp_value_2 = [amp_value_2;sj.estim.one_trial.ampvals];
                    lat_value_2 = [lat_value_2;sj.estim.one_trial.latvals];
                    box_amp_value_2 = [box_amp_value_2;sj.estim.one_trial.boxampvals];
                    t_max_value_2 =[t_max_value_2;sj.estim.one_trial.tmaxval];
                    r2_2 = [r2_2;sj.estim.one_trial.R2];
                    bic_2 = [bic_2;sj.estim.one_trial.BICrel];
                    cost_2 = [cost_2;sj.estim.one_trial.cost];
                    window_2 = [window_2;window];
                    eventtimes_2 = [eventtimes_2;event];
                    boxtimes_2 = [boxtimes_2;rt];
    
                elseif tab(tt,11) == 4
                    amp_value_4 = [amp_value_4;sj.estim.one_trial.ampvals];
                    lat_value_4 = [lat_value_4;sj.estim.one_trial.latvals];
                    box_amp_value_4 = [box_amp_value_4;sj.estim.one_trial.boxampvals];
                    t_max_value_4 =[t_max_value_4;sj.estim.one_trial.tmaxval];
                    r2_4 = [r2_4;sj.estim.one_trial.R2];
                    bic_4 = [bic_4;sj.estim.one_trial.BICrel];
                    cost_4 = [cost_4;sj.estim.one_trial.cost];
                    window_4 = [window_4;window];
                    eventtimes_4 = [eventtimes_4;event];
                    boxtimes_4 = [boxtimes_4;rt];
                else
                    amp_value_8 = [amp_value_8;sj.estim.one_trial.ampvals];
                    lat_value_8 = [lat_value_8;sj.estim.one_trial.latvals];
                    box_amp_value_8 = [box_amp_value_8;sj.estim.one_trial.boxampvals];
                    t_max_value_8 =[t_max_value_8;sj.estim.one_trial.tmaxval];
                    r2_8 = [r2_8;sj.estim.one_trial.R2];
                    bic_8 = [bic_8;sj.estim.one_trial.BICrel];
                    cost_8 = [cost_8;sj.estim.one_trial.cost];
                    window_8 = [window_8;window];
                    eventtimes_8 = [eventtimes_8;event];
                    boxtimes_8 = [boxtimes_8;rt];

                end
    

                    


            end

%             if ii == 1 
%                 figpath='/scratch/bs4283/rad_tan/Rad_Tan_script/sub01';
%             elseif ii == 2
%                 figpath='/scratch/bs4283/rad_tan/Rad_Tan_script/sub02';
%             elseif ii == 3
%                 figpath='/scratch/bs4283/rad_tan/Rad_Tan_script/sub03';
%             elseif ii == 4
%                 figpath='/scratch/bs4283/rad_tan/Rad_Tan_script/sub04';
%             elseif ii == 5
%                 figpath='/scratch/bs4283/rad_tan/Rad_Tan_script/sub05';
%             elseif ii == 6
%                 figpath='/scratch/bs4283/rad_tan/Rad_Tan_script/sub06';
%             elseif ii == 7
%                 figpath='/scratch/bs4283/rad_tan/Rad_Tan_script/sub07';
%             elseif ii == 8
%                 figpath='/scratch/bs4283/rad_tan/Rad_Tan_script/sub08';
%             end
% 
% 
            tt_8_value = [amp_value_8,lat_value_8,box_amp_value_8,t_max_value_8,bic_8,r2_8,cost_8,window_8,eventtimes_8,boxtimes_8];
            tt_4_value = [amp_value_4,lat_value_4,box_amp_value_4,t_max_value_4,bic_4,r2_4,cost_4,window_4,eventtimes_4,boxtimes_4];
            tt_2_value = [amp_value_2,lat_value_2,box_amp_value_2,t_max_value_2,bic_2,r2_2,cost_2,window_2,eventtimes_2,boxtimes_2];
            tt_1_value = [amp_value_1,lat_value_1,box_amp_value_1,t_max_value_1,bic_1,r2_1,cost_1,window_1,eventtimes_1,boxtimes_1];
            tt_05_value = [amp_value_05,lat_value_05,box_amp_value_05,t_max_value_05,bic_05,r2_05,cost_05,window_05,eventtimes_05,boxtimes_05];
% 
%             name_05 = [figpath,'/',con{jj},'-',direction{8},'_value_05.mat'];
%             name_8 = [figpath,'/',con{jj},'-',direction{8},'_value_8.mat'];
%             name_4 = [figpath,'/',con{jj},'-',direction{8},'_value_4.mat'];
%             name_2 = [figpath,'/',con{jj},'-',direction{8},'_value_2.mat'];
%             name_1 = [figpath,'/',con{jj},'-',direction{8},'_value_1.mat'];

%             save(name_05,'tt_05_value')
%             save(name_1,'tt_1_value')
%             save(name_2,'tt_2_value')
%             save(name_4,'tt_4_value')
%             save(name_8,'tt_8_value')




        end
    end

end


% window_m = tt_2_value([12,13]);
% event_m = tt_2_value([14,15,16]);
% box_m = {[0,tt_2_value(17)]};
% tmax_m = tt_2_value(8);
% lat_m = tt_2_value([4,5,6]);
% amp_m = tt_2_value([1,2,3]);
% box_am_m = tt_2_value(7);
% 
% Ycalc = plot_model_data(window_m,1000,event_m,box_m,tmax_m,lat_m,amp_m,box_am_m);
% x = 1 : 3767;
% figure
% plot(x,Ycalc')