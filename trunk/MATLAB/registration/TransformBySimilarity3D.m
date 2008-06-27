function [transformed_pointset] = TransformBySimilarity3D(original_pointset, param)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: TransformBySimilarity3D.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/09/20 03:23:39 $
%% Version:   $Revision: 1.2 $
%%=====================================================================

if nargin~=2;
    error('Usage: [tranformed_pointset] = TransformBySimilarity3D (original_pointset, param).');
end

if length(param) ~= 8
    error('3D Similarity transform is parametrized by 8 numbers [unit quaternion, translation, scale].');
end

[n,dim] = size(original_pointset);

if dim<3
    error('Input point sets should have dimensionality >=3');
end

% r = rot(param(1:3,'xzx');
r = quaternion2rotation(param(1:4));
t = ones(n,1)*param(5:7);
s = param(8);
  
transformed_pointset = s*original_pointset*r + t;
        
        
