function [energy,g] = ComputeL2(parameters, model, scene, scale, motion)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: ComputeL2.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2008/01/08 15:27:23 $
%% Version:   $Revision: 1.23 $
%%=====================================================================


[transformed_model] = TransformPointSet(model, motion, parameters);
switch lower(motion)
    case 'rigid2d'
        [energy, grad] = RigidEnergy(transformed_model, scene, scale);
        grad = grad';
        g(1) = sum(grad(1,:));
        g(2) = sum(grad(2,:));
        grad = grad*model;
        theta = parameters(3);
        r = [-sin(theta) -cos(theta);
             cos(theta)  -sin(theta)];
        g(3) = sum(sum(grad.*r));
    case 'rigid3d'
       [energy,grad] = RigidEnergy(transformed_model, scene, scale);
        [r,gq] = quaternion2rotation(parameters(1:4));
        grad = grad';
        gm = grad*model; 
        g(1) = sum(sum(gm.*gq{1}));
        g(2) = sum(sum(gm.*gq{2}));
        g(3) = sum(sum(gm.*gq{3}));
        g(4) = sum(sum(gm.*gq{4}));        
        g(5) = sum(grad(1,:));
        g(6) = sum(grad(2,:));
        g(7) = sum(grad(3,:));
    case 'affine2d'
       	[energy,grad] = AffineEnergy(transformed_model, scene, scale);
        grad = grad';
        g(1:4) = reshape(grad*model,1,4);
        g(5) = sum(grad(1,:));
        g(6) = sum(grad(2,:));
    case 'affine3d'
    	[energy, grad] = AffineEnergy(transformed_model, scene, scale);
        grad = grad';
        g(1:9) = reshape(grad*model,1,9);
        g(10) = sum(grad(1,:));
        g(11) = sum(grad(2,:));
        g(12) = sum(grad(2,:));
    otherwise
        error('Unknown motion type');
end;
