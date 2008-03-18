function [axis_limits] = determine_border(Model, Scene)
%%=====================================================================
%% Module:    $RCSfile: determine_border.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/12/26 16:40:13 $
%% Version:   $Revision: 1.1 $
%%=====================================================================

dim = size(Scene,2);
axis_limits = [];
for i=1:dim
    min_i = min([Scene(:,i);Model(:,i)]);
    max_i = max([Scene(:,i);Model(:,i)]);
    margin_i = (max_i-min_i)*0.05;
    axis_limits = [axis_limits; [min_i - margin_i max_i+margin_i]];
end

