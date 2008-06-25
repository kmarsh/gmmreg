% function [param, Transformed_M, tt, S] = GMMReg_TPS(M,S, ctrl_pts,
% scale, alpha, beta, display, init_p, opt_affine, init_affine);
%M is a N by d array containing model points
%S is a M by d array containing scene points
%h is the "bandwith"
%display: display the intermediate steps or not. default is not display
%motion:  the transformation model, can be
%         euclidean
%         affine
%         projective;
%         Default motion model is euclidean;
% alpha : NRR energy
% beta  : bending energy (regularizer)
function [param, Transformed_M, tt] = GMMReg_TPS(M,S, ctrl_pts, scale, alpha, beta, display, init_p, opt_affine, init_affine)
%%=====================================================================
%% Project:   Pointset Registration using Gaussian Mixture Model
%% Module:    $RCSfile: GMMReg_TPS.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2008/01/03 20:24:58 $
%% Version:   $Revision: 1.9 $
%%=====================================================================

global iter_no;
%global costs;
global avi_obj
global axis_limits;

%% remove duplicates
%M = unique( M, 'rows' );
%S = unique( S, 'rows' );
%global TPS_basis;
%global TPS_lambda;
iter_no = 0;
if nargin<6;
    error('Usage: GMMReg_TPS(M,S, ctrl_pts, scale, alpha, beta, [display, init_p, opt_affine, init_affine ])');
end;
[n,d] = size(ctrl_pts); % number of points in model set

if (nargin < 7)
    display = 1;
end;
global display_it;
display_it = display;

if (nargin < 10)
    if (d==2)
        init_affine = [0, 0, 1, 0, 0, 1]';  %[tx,ty,a11,a12,a21,a22];    
    elseif(d==3)
        init_affine = [0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1]';  %[tx,ty,tz,a11,a12,a13,a21,a22,a23,a31,a32,a33];
    end
end

if (nargin < 9 )
    opt_affine = 1; 
end

if (opt_affine)
    x0 = [init_affine; zeros(d*n-d*(d+1),1)];
    affine = [ ];
else
    x0 = zeros(d*n-d*(d+1),1);
    affine = init_affine;
end

dim = d;
if(display_it>0)
    axis_limits = determine_border(M,S);
    subplot(1,2,1); hold off;
    DisplayPoints(M(:,1:dim),S(:,1:dim),dim);
    set(gca,'FontSize',16);
    if (display_it>1)
        fig = figure;
        movie_filename = [sprintf('%f',rand()),'.avi'];
        avi_obj  = avifile(movie_filename); %,'COMPRESSION','None','QUALITY',100);
        set(fig,'DoubleBuffer','on');    
        set(gca,'xlim',axis_limits(1,1:2),'ylim',axis_limits(2,1:2),...
            'nextplot','replace','Visible','off')
    end
    title('Initial configuration');
    drawnow;
end;

landmarks = M;
[m,d] = size(landmarks);
[n,d] = size(ctrl_pts);
[K,U] = compute_K(ctrl_pts,landmarks);
Pm = [ones(m,1) landmarks];
Pn = [ones(n,1) ctrl_pts];
PP = null(Pn'); 
TPS_basis = [Pm U*PP]; 
TPS_kernel = PP'*K*PP;
%disp('TPS:basis,kernel computed'); 
options = optimset('GradObj','on','Display', 'off','LargeScale','off', 'MaxIter', 20000,  'TolFun',1e-010, 'TolX',1e-010);

% x0
% affine
% scale 
% alpha
% beta
% 
t = cputime;
% 
% obj_TPS2d(x0, affine, TPS_basis, TPS_lambda, S, scale, alpha, beta)
% %t = cputime - t
% %t = cputime;
% obj_TPS2d_old(x0, affine, TPS_basis, TPS_lambda, S, scale, alpha, beta)

if (nargin >= 8)
    x0 = init_p; 
end

[param, fval, exit_flag, output] = fminunc(@(x)obj_TPS(x, affine, TPS_basis, TPS_kernel, S, scale, alpha, beta, dim), x0,  options);
%[param, fval, exit_flag, output] = fminunc(@(x)obj_TPS_mex(x, affine, TPS_basis, kronBasis, TPS_kernel, S, scale, alpha, beta, dim), x0,  options);
%output
tt = cputime - t;
%sprintf('time: %d s', cputime - t)
%exit_flag
%output
if (display_it>0 || nargout > 1)
    p = reshape(param,d,n); p = p'; 
    [Transformed_M] = TPS_warp(p, M, ctrl_pts);
end

%The following for display purpose only.
if(display_it>0)
    subplot(1,2,2); hold off;
    DisplayPoints(Transformed_M(:,1:dim),S(:,1:dim), dim); %, axis_limits);
    if (display_it>1)
        set(gca,'xlim',axis_limits(1,1:2),'ylim',axis_limits(1,1:2),...
            'nextplot','replace','Visible','off')
    end
    set(gca,'FontSize',16);
    L2distance = GaussTransform(Transformed_M',Transformed_M',scale) + GaussTransform(S',S',scale) - 2*GaussTransform(Transformed_M',S',scale);
    title(sprintf('L2distance: %f',L2distance));
    drawnow;
end;

if (display_it>1)
    avi_obj = close(avi_obj);    
    %movie_filename;
end

%figure
%plot(1:iter_no, costs(1:iter_no));
%fval

%figure;
%DisplayPoints2D(Transformed_M, S);