% Transform of point set
% motion:  the transformation model represented by string, can be
%         rigid2d,    rigid3d,    similarity3d;
%         affine2d,   affine3d;
%         homography (projective transformation)
% param: parameters in row vector
function [PS_transformed] = TransformPointSet(PS_original, motion, param)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: TransformPointSet.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/12/14 02:59:54 $
%% Version:   $Revision: 1.11 $
%%=====================================================================

if nargin<3;
    error('Not enough input parameters');
end;
P = PS_original;
switch lower(motion)
    case 'rigid2d'
        Q = TransformByRigid2D(P,param);
    case 'rigid3d'
        Q = TransformByRigid3D(P,param);
    case 'similarity3d'
        Q = TransformBySimilarity3D(P,param);             
    case 'affine2d'
        Q = TransformByAffine2D(P,param);
    case 'affine3d'
        Q = TransformByAffine3D(P,param);
    otherwise
        error('Unknown motion type');
end;
PS_transformed = Q;

