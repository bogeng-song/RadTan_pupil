# RadTan_pupil
This is RadTan project for pupil size analysis.
The analysis method based on Pupil Response Estimation Toolbox (PRET) by Jacob Parker and Rachel Denison.  

## Overall description
This repo contains the functions, scripts and one sub example result.  
How to run: Add three folder into path and run the scripts

func, script, scripts: three folder contains function, just add them into path. 

The main script to fit model:
**main_for_run.m**  : the original script.  
**main_fix_tmax.m** : fit model with a fixed tmax value  
**main_for_filter_data.m** : fit model with filter data  
**main_fixt_filter** : fit model with both filter data and fixed tmax value  
**new_method_main_script.m**: another method to extract the data segment  
**new_method_filterdata.m** : another method + using filter data.   
**main_scirpt_PCDM.m**: using Burlingham CS*, Mirbagheri S*, Heeger DJ method to fit the data.   



*if you want to change the fixed t max value, you need to change it at line 60 in func/fit_eyemove_model_fixtmax.m script. 

plot_multi_figure.m : 1. plot the parameter figures, plot the original data and model fit data. 


Result folder contains the result figures for six methods to fit sub04 result. 
multi_method folder use all trials parameter value. 
multi_r2_result folder use the trials, which r^2 > 0.1

You can get these result figures by running plot_multi_figure.m script. 
