function [energy, grad] = obj_TPS(param, init_affine, basis,  kernel, scene, scale, alpha, beta, d)
%%=====================================================================
%% $RCSfile: obj_TPS.m,v $
%% $Author: bjian $
%% $Date: 2008/01/02 05:59:10 $
%% $Revision: 1.13 $
%%=====================================================================

%%
% basis (nLandMarks x nCtrlPts ) , params = 3*nCtrlPts x 1
% #control-pts
n = size(basis,2);
% #landmarks
nL = size(basis,1);
% n = size(basis,1);
%%
%parameters = zeros(3,1);
%[transformed_model, bending] = TransformPointSet(model, motion, parameters);
if isempty(init_affine)
    affine_param = reshape(param(1:d*(d+1)),d,d+1);
    affine_param = affine_param';
    tps_param = reshape(param(d*(d+1)+1:d*n),d,n-d-1);
    tps_param = tps_param';
else
    tps_param = reshape(param(1:d*n-d*(d+1)),d,n-d-1);
    tps_param = tps_param';
    affine_param = reshape(init_affine,d,d+1);
    affine_param = affine_param';
end
after_tps = basis*[affine_param;tps_param];
bending = trace(tps_param'*kernel*tps_param);
[energy,grad] = AffineEnergy(after_tps, scene, scale);
energy = alpha*energy + beta * bending;
grad = alpha*basis'*grad;
grad(d+2:n,:) = grad(d+2:n,:) + 2*beta*kernel*tps_param;
if isempty(init_affine)
    grad = grad';
    grad = reshape(grad,1,d*n);
else
    grad(1:d+1,:) = [ ];
    grad = grad';
    grad = reshape(grad,1,d*(n-d-1));
end

