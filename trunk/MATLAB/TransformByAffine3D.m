function [transformed_pointset] = TransformByAffine3D(original_pointset, param)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: TransformByAffine3D.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/09/20 03:23:39 $
%% Version:   $Revision: 1.4 $
%%=====================================================================


if nargin~=2;
    error('Usage: [tranformed_pointset] = TransformByAffine3D (original_pointset, affine3d_param).');
end

if length(param) ~= 12
    error('At least 12 parameters required for 2D affine transform');
end

[n,dim] = size(original_pointset);

if (dim<3)
    error('Input point sets should have dimensionality >=3');
end

A = reshape(param,3,4);  
%  [ a11 a12 a13 | tx ]
%  [ a21 a22 a23 | ty ]
%  [ a31 a32 a33 | tz ]
%   note: order of reshape is column first
%   param = [a11 a21 a32 a12 a22 a32 a13 a23 a33 tx ty tz]
transformed_pointset = (A * [original_pointset(:,1:3)'; ones(1,n)])';        
        
