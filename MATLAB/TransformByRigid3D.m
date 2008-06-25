function [transformed_pointset] = TransformByRigid3D(original_pointset, param)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: TransformByRigid3D.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2008/01/08 15:27:23 $
%% Version:   $Revision: 1.6 $
%%=====================================================================

if nargin~=2;
    error('Usage: [tranformed_pointset] = TransformByRigid3D (original_pointset[nx3], rigid3d_param[quaternion+translation]).');
end

if length(param) ~= 7
    error('3D rigid transform is parametrized by 7 numbers [quaternion+translation].');
end

[n,dim] = size(original_pointset);

if dim<3
    error('Input point sets should have dimensionality >=3');
end

% r = rot(param(1:3,'xzx');
r = quaternion2rotation(param(1:4));
t = ones(n,1)*param(5:7);
transformed_pointset = original_pointset*r' + t;
        
        
