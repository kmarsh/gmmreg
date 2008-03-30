%clear all;
close all;
tic
%gmmreg_tps_mex('./fish_half.ini')
 if ispc
   !d:/bjian/programs/gmmreg/c++/build_vs8/release/test_gmmreg_tps ./fish_full.ini
 else
   !./linux-x86_64/gmmreg_tps ./fish_half.ini
 end
toc
M  = load('./fish_data/fish_X_nohead.txt');
S  = load('./fish_data/fish_Y_notail.txt');
M  = load('./fish_data/fish_X.txt');
S  = load('./fish_data/fish_Y.txt');

%M  = load('./M_n.txt');
%S  = load('./S_n.txt');

Transformed_M = load('./output/transformed_model.txt');
subplot(1,2,1); 
axis_limits = DisplayPoints2D(M,S); axis off;
subplot(1,2,2); 
%S = load('./output/scene.txt');
DisplayPoints2D(Transformed_M,S,axis_limits);
axis off
