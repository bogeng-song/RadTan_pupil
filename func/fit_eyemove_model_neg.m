function sj = fit_eyemove_model(eyemovement,event,sample,win,event_label,rt)

options = pret_preprocess();
options.normflag = false;
options.blinkflag = false;

% put the condition data matrices into a cell array
data = {eyemovement};

% labels for each condition
condlabels = {'one_trial'};

% other epoch info
samplerate = sample;
window = win;

sj = pret_preprocess(data,samplerate,window,condlabels,[],options);

%% create model for the data
% Pretending that we are naive to the model that we used to create our
% data, let's create a model to actually fit the data to.
model = pret_model();

% While the trial window of our task is from -500 to 3500 ms, here we are
% not interested in what's happening before 0. So
% let's set the model window to fit only to the region betweeen 0 and 3500
% ms (the cost function will only be evaluated along this interval).
model.window = [0 win(2)];

% We already know the sampling frequency.
model.samplerate = sample;

% We also know the event times of our task. Let's also say that we think 
% there will be a sustained internal signal from precue onset to response 
% time (0 to 2750 ms).
model.eventtimes = event;
model.eventlabels = event_label; %optional
model.boxtimes = {[0 rt]};
model.boxlabels = {'task'}; %optional

% Let's say we want to fit a model with the following parameters: 
% event-related, amplitude, latency, task-related (box) amplitude, 
% and the tmax of the pupil response function. We turn the other parameters
% off.
model.yintflag = false;
model.slopeflag = false;

% Now let's define the bounds for the parameters we decided to fit. We do
% not have to give values for the y-intercept and slope because we are not
% fitting them.
model.ampbounds = repmat([-100;100],1,length(model.eventtimes));
model.latbounds = repmat([-500;500],1,length(model.eventtimes));
model.boxampbounds = [0;100];
model.tmaxbounds = [500;1500];

% We need to fill in the values for the y-intercept and slope since we will
% not be fitting them as parameters.
model.yintval = 0;
model.slopeval = 0;

%% estimate model parameters via pret_estimate_sj
% Now let's perform the parameter estimation procedure on our subject data.
% The mean of each condition will be fit independently. For illustration, 
% let's run only 3 optimizations using one cpu worker (for more 
% information, see the help files of pret_estimate and pret_estimate_sj).
options = pret_estimate_sj();
options.pret_estimate.optimnum = 3;
% if you want to try fiting the parameters using single trials instead of the mean,
% use these lines (you'll want to turn off the optimization plots for this):
%options.trialmode = 'single';

options.pret_estimate.pret_optim.optimplotflag = false;

wnum = 1;

sj = pret_estimate_sj(sj,model,wnum,options);

end
