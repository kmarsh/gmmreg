     
function [transformed_pointset] = TransformByAffine2D(original_pointset, param)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: TransformByAffine2D.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/09/20 03:23:39 $
%% Version:   $Revision: 1.5 $
%%=====================================================================

if nargin~=2;
    error('Usage: [tranformed_pointset] = TransformByAffine2D (original_pointset, affine2d_param).');
end

if length(param) ~= 6
    error('At least 6 parameters required for 2D affine transform');
end

[n,dim] = size(original_pointset);

if (dim<2)
    error('Input point sets should have dimensionality >=2');
end

A = reshape(param,2,3);  
%  [ a11 a12  | tx ]
%  [ a21 a22  | ty ]
%   note: order of reshape is column first
%   param = [a11 a21 a12 a22 tx ty]

transformed_pointset = (A * [original_pointset(:,1:2)'; ones(1,n)])';

% let's disable this feature at this time
% if the input has more than 2 cols, the 3rd col will be treated as orientation
% information in degree 
% if dim>2
%      after(:,3) = before(:,3) + d_theta*180/pi;
% end        