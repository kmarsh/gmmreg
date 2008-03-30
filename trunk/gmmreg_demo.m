function [ ] = gmmreg_demo(f_config)
%clear all;
close all;
tic
%gmmreg_tps_mex('./fish_half.ini')
 if ispc
   cmd = sprintf('!gmmreg_tps %s',f_config);
   eval(cmd);
 else
   !./linux-x86_64/gmmreg_tps ./fish_half.ini
 end
toc
model_file = ml_GetPrivateProfileString('Files','ModelFile', f_config);
scene_file = ml_GetPrivateProfileString('Files','SceneFile', f_config);
transformed_file = ml_GetPrivateProfileString('Files','AfterRegPtsFile', f_config);

M = load(model_file);
S = load(scene_file);
Transformed_M = load(transformed_file);

subplot(1,2,1); 
axis_limits = DisplayPoints(M,S,size(M,2)); axis off;
subplot(1,2,2); 
%S = load('./output/scene.txt');
DisplayPoints(Transformed_M,S,size(S,2));
axis off
