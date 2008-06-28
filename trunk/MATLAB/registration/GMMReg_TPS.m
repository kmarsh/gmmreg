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
function [p, Transformed_M] = GMMReg_TPS(M,S, ctrl_pts, scale, alpha, beta, display, init_p, opt_affine, init_affine)
%%=====================================================================
%% $RCSfile: GMMReg_TPS.m,v $
%% $Author: bjian $
%% $Date: 2008/01/03 20:24:58 $
%% $Revision: 1.9 $
%%=====================================================================

%% remove duplicates
%M = unique( M, 'rows' );
%S = unique( S, 'rows' );

% Set up shared variables with OUTFUN
history.x = [];
history.fval = [];


if nargin<6;
    error('Usage: GMMReg_TPS(M,S, ctrl_pts, scale, alpha, beta, [display, init_p, opt_affine, init_affine ])');
end;
[n,d] = size(ctrl_pts); % number of points in model set

if (nargin < 7)
    display = 1;
end;

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
landmarks = M;
[m,d] = size(landmarks);
[n,d] = size(ctrl_pts);
[K,U] = compute_K(ctrl_pts,landmarks);
Pm = [ones(m,1) landmarks];
Pn = [ones(n,1) ctrl_pts];
PP = null(Pn'); 
TPS_basis = [Pm U*PP]; 
TPS_kernel = PP'*K*PP;
options = optimset( 'outputfcn',@outfun,'GradObj','on','Display', 'off','LargeScale','off', 'MaxIter', 20000,  'TolFun',1e-010, 'TolX',1e-010);

if (nargin >= 8)
    x0 = init_p; 
end
tic
[param, fval, exit_flag, output] = fminunc(@(x)obj_TPS(x, affine, TPS_basis, TPS_kernel, S, scale, alpha, beta, dim), x0,  options);
toc
p = reshape(param,d,n); p = p'; 
if (nargout > 1)
    [Transformed_M] = TPS_warp(p, M, ctrl_pts);
end

    function stop = outfun(x,optimValues,state,varargin)
     stop = false;

     switch state
         case 'init'
             if display>0
               set(gca,'FontSize',16);
             end
         case 'iter'
               history.fval = [history.fval; optimValues.fval];
               history.x = [history.x; x];
               if display>0
                   hold off
                   p = reshape(x,d,n); p = p'; 
                   transformed = TPS_warp(p, M, ctrl_pts);
                   dist = L2_distance(transformed,S,S);
                   DisplayPoints(transformed,S,dim);
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



