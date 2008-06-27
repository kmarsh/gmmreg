function [transformed_pointset] = TransformByRigid2D(original_pointset, param)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: TransformByRigid2D.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/12/14 02:59:54 $
%% Version:   $Revision: 1.7 $
%%=====================================================================

if nargin~=2;
    error('Usage: [tranformed_pointset] = TransformByRigid2D (original_pointset, [tx,ty,theta]).');
end

if length(param) ~= 3
    error('2D rigid transform is parametrized by triple [translation_x, translation_y, rotation_angle].');
end

[n,dim] = size(original_pointset);

if dim<2
    error('Input point sets should have dimensionality >=2');
end

% parameters of 2D-rigid transform
delta_x = param(1);   % translation in x-dimension
delta_y = param(2);   % translation in y-dimension
d_theta = param(3);   % rotation in radius

% form rotation matrix
r = [cos(d_theta) -sin(d_theta);
     sin(d_theta)  cos(d_theta)];
% first rotate
transformed_pointset(:,1:2) = original_pointset(:,1:2) * r' ;
% than translate
transformed_pointset(:,1:2) = transformed_pointset(:,1:2) + ones(n,1)*[delta_x delta_y];

% Let's disable this feature at this time
% % if the input has more than 2 cols, the 3rd col will be treated as orientation
% % information in degree 
% if dim>2
%       after(:,3) = before(:,3) + d_theta*180/pi;
% end
        
        
