%RigidEnergy   Energy Function for Rigid Transformation between Two Point-sets
%
%
function [energy, grad] = RigidEnergy(A, B, scale)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: RigidEnergy.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2008/04/07 04:17:54 $
%% Version:   $Revision: 1.12 $
%%=====================================================================

%% ignore checking to save time
% if nargin<3;
%     error('Not enough input arguments.');
% end;
% 
% if nargin>4
%     error('Too many input arguments.');
% end;
[energy, grad] =  GaussTransform(A,B,scale);
energy = -energy;
grad = -grad;