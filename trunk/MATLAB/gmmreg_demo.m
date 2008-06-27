function [ ] = gmmreg_demo(f_config)
%%=====================================================================
%% Project:   Pointset Registration using Gaussian Mixture Model
%% Module:    $RCSfile: DisplayPoints2D.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2008/01/06 07:00:57 $
%% Version:   $Revision: 1.3 $
%%=====================================================================
%clear all;
close all;
 if ispc
     gmmreg_prog  = 'gmmreg_tps';
 else
     gmmreg_prog  = './gmmreg_tps';
 end
cmd = sprintf('!%s %s',gmmreg_prog, f_config);
tic
eval(cmd);
%gmmreg_tps_mex(f_config)
toc
model_file = ml_GetPrivateProfileString('Files','model', f_config);
scene_file = ml_GetPrivateProfileString('Files','scene', f_config);
transformed_file = ml_GetPrivateProfileString('Files','transformed_model', f_config);

M = load(model_file);
S = load(scene_file);
Transformed_M = load(transformed_file);

subplot(1,2,1); 
DisplayPoints(M,S,size(M,2)); axis off;
subplot(1,2,2); 
DisplayPoints(Transformed_M,S,size(S,2)); axis off
