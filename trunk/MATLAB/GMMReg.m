%function [param, tt] = GMMReg(model, scene, scale, display, motion, init_param);
%   'model' and 'scene'  are two point sets
%   'display': display the intermediate steps or not. default is not display
%   'motion':  the transformation model, can be
%         ['rigid2d', 'rigid3d', 'affine2d', 'affine3d']
%         The default motion model is 'rigid2d' or 'rigid3d' depending on
%         the input dimension
%   'rho':  the fraction of points to be discarded, default is 0 

function [param, Transformed_M, tt] = GMMReg(model, scene, scale, display, motion,init_param)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: GMMReg.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2008/01/08 15:27:23 $
%% Version:   $Revision: 1.8 $
%%=====================================================================
%model_file = ml_GetPrivateProfileString('Files','model', config_file);
%scene_file = ml_GetPrivateProfileString('Files','scene', config_file);
%M = load(model_file);
%S = load(scene_file);

global iter_no
iter_no = 0;
if nargin<3;
    error('Usage: GMMReg(M,S, scale, display, motion)');
end

[n,dim] = size(model); % number of points in model set
if (dim~=2)&&(dim~=3)
    error('The current program only deals with 2D or 3D point sets.');
end

if nargin<4
    display = 0;
end;

global display_it;
display_it = display;

if nargin<5
    if (dim==2)
        motion = 'rigid2d';
    end
    if (dim==3)
        motion = 'rigid3d';
    end
end;


options=optimset('MaxFunEvals', 150, 'TolFun',1e-012, 'TolX',1e-015);
options_final = optimset('display','Off', 'LargeScale','off','GradObj','off','MaxFunEvals', 1000, 'TolFun',1e-012, 'TolX',1e-012, 'TolCon', 1e-500,'OutputFcn',@func1,x);
%options=optimset('display','Iter', 'MaxFunEvals', 4000, 'TolFun',1e-0200, 'TolX',1e-015);


t = cputime;
if (nargin>=6)
    x0 = init_param;
end
[x0, Lb, Ub, dim] = prepare_bounds(motion);


[param, value,flag, output] = fmincon(@ComputeL2, x0, [],[],[],[], Lb, Ub, [], options_final, model, scene, scale, motion);
tt = cputime-t;
sprintf('time: %d s', cputime - t)
%param = [-25, 25, 10*pi/180];

Transformed_M = TransformPointSet(model, motion, param);
energy = GaussTransform(Transformed_M,Transformed_M,scale) + GaussTransform(scene,scene,scale) - 2*GaussTransform(Transformed_M,scene,scale);

