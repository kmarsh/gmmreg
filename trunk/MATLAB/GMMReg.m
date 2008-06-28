%function [param, tt] = GMMReg(model, scene, scale, motion, display, init_param);
%   'model' and 'scene'  are two point sets
%   'scale' is a free scalar parameter
%   'motion':  the transformation model, can be
%         ['rigid2d', 'rigid3d', 'affine2d', 'affine3d']
%         The default motion model is 'rigid2d' or 'rigid3d' depending on
%         the input dimension
%   'display': display the intermediate steps or not. 
%   'init_param':  initial parameter

function [param, transformed_model, history] = GMMReg(model, scene, scale, motion,display,init_param )
%%=====================================================================
%% $RCSfile: GMMReg_TPS.m,v $
%% $Author: bjian $
%% $Date: 2008/01/03 20:24:58 $
%% $Revision: 1.9 $
%%=====================================================================

%todo: use the statgetargs() in statistics toolbox to process parameter
%name/value pairs

% Set up shared variables with OUTFUN
history.x = [];
history.fval = [];

if nargin<2
    error('Usage: GMMReg(model, scene, [scale, motion, display,  init_param] )');
end

M = model;
S = scene;
[n,dim] = size(M); % number of points in model set
if (dim~=2)&&(dim~=3)
    error('The current program only deals with 2D or 3D point sets.');
end

if nargin<3    % estimate the scale from the covariance matrix
    scale = det(M'*M/n);
    for i=1:dim
        scale = sqrt(scale);
    end
end

if nargin<4  % by default, the motion is assumed to be rigid
    if (dim==2)
        motion = 'rigid2d';
    end
    if (dim==3)
        motion = 'rigid3d';
    end
end

if nargin<5 
    display = 0;
end
options = optimset( 'outputfcn',@outfun,'display','off', 'LargeScale','off','GradObj','on','MaxFunEvals', 200, 'TolFun',1e-010, 'TolX',1e-010, 'TolCon', 1e-10);

[x0, Lb, Ub] = prepare_bounds(motion);
if (nargin>=6)
    x0 = init_param;
end

tic
[param, value, flag, output] = fmincon(@ComputeL2, x0, [ ],[ ],[ ],[ ], Lb, Ub, [ ], options, model, scene, scale, motion);
toc
transformed_model = TransformPointSet(model, motion, param);
%final_dist = L2_distance(transformed_model,scene,scale);


    function stop = outfun(x,optimValues,state,varargin)
     stop = false;

     switch state
         case 'init'
             if display>0
               set(gca,'FontSize',16);
             end
         case 'iter'
               history.fval = [history.fval; optimValues.fval];
               history.x = [history.x; reshape(x,1,length(x))];
               if display>0
                   hold off
                   transformed = TransformPointSet(model, motion, x);
                   dist = L2_distance(transformed,scene,scale);
                   DisplayPoints(transformed,scene,dim);
                  title(sprintf('L2distance: %f',dist));
                   drawnow;
               end
         case 'done'
              %hold off
         otherwise
     end
    end

end

function [dist]=L2_distance(model, scene, scale)
    dist = GaussTransform(model,model,scale) + GaussTransform(scene,scene,scale) - 2*GaussTransform(model,scene,scale);
end

    

 
