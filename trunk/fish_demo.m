%clear all;
close all;
tic
%gmmreg_tps_mex('./fish_half.ini')
 if ispc
   !gmmreg_tps ./fish_half.ini
 else
   !./linux-x86_64/gmmreg_tps ./fish_half.ini
 end
toc
M  = load('./fish_data/fish_X_nohead.txt');
S  = load('./fish_data/fish_Y_notail.txt');
Transformed_M = load('./output/transformed_model.txt');
subplot(1,2,1); 
axis_limits = DisplayPoints2D(M,S); axis off;
subplot(1,2,2); 
DisplayPoints2D(Transformed_M,S,axis_limits);
axis off
