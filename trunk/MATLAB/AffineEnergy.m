function [energy, grad] = AffineEnergy(A, B, scale)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: AffineEnergy.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2008/04/07 04:17:54 $
%% Version:   $Revision: 1.12 $
%%=====================================================================

% if nargin<3;
%     error('Usage: A, B, scale, [dimension]');
%     return;
% end;
% 
% if nargin<4
%     dim = 2;  %  2D is the default case
% end;
[energy1, grad1] = GaussTransform(A,A,scale);
[energy2, grad2] = GaussTransform(A,B,scale);
energy =  energy1 - 2* energy2;
grad = 2*grad1 - 2*grad2;

