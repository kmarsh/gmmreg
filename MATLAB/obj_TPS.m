function [energy, grad] = obj_TPS(param, init_affine, basis,  kernel, scene, scale, alpha, beta, d)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: obj_TPS.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2008/01/02 05:59:10 $
%% Version:   $Revision: 1.13 $
%%=====================================================================

global display_it;
%global iter_no;
%global costs;
global avi_obj;
global axis_limits;

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
    grad(1:d+1,:) = [];
    grad = grad';
    grad = reshape(grad,1,d*(n-d-1));
end

dim = d;
transformed_model = after_tps;
%The following for display purpose only.
if(display_it>0)
    subplot(1,2,2); hold off;
    DisplayPoints(transformed_model,scene,dim); %,axis_limits);
    set(gca,'FontSize',16);
    if (display_it>1)
        set(gca,'xlim',axis_limits(1,1:2),'ylim',axis_limits(2,1:2),...
            'nextplot','replace','Visible','off')
    end
    %title(sprintf('energy: %f',energy));
    drawnow;
    if(display_it>1)
        %avi_obj = addframe(avi_obj,getframe);%(gca,[0 0 192 220]));                    
        avi_obj = addframe(avi_obj,getframe(gca, [-20 0  192 320]));                    
    end
%    subplot(1,3,3);
%    hold on
%    plot(iter_no, energy);
end;