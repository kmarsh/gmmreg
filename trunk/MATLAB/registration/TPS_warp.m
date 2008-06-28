%% Perform thin-plate spline warping
%% Input:
%%       landmarks:   source pts stored in nxd matrix.  
%%       parameters:  parameters in nxd matrix where first (d+1) rows are
%%       affine parameters corresponding to <1,x,y>
%% Output:
%%       warped_pts:  target pts in nxd matrix
%%       energy:      bending energy

function [warped_pts, energy] = TPS_warp(parameters, landmarks, ctrl_pts)
%%=====================================================================
%% Project:   Pointset Registration using Gaussian Mixture Model
%% Module:    $RCSfile: TPS_warp.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2008/04/03 16:10:47 $
%% Version:   $Revision: 1.4 $
%%=====================================================================
if (nargin==2)
    [n,d] = size(landmarks);
    [B,lambda] = compute_basis(landmarks);
    warped_pts = B*parameters;
    energy = trace(parameters(d+2:n,:)'*diag(lambda)*parameters(d+2:n,:));
else
    [m,d] = size(landmarks);
    [n,d] = size(ctrl_pts);
    [K,U] = compute_K(ctrl_pts,landmarks);

    Pm = [ones(m,1) landmarks];
    Pn = [ones(n,1) ctrl_pts];

    PP = null(Pn'); B = [Pm U*PP]; 
    cond(B);
    size(B);
    warped_pts = B*parameters;
    eig(PP'*K*PP);
    energy = trace(parameters(d+2:n,:)'*PP'*K*PP*parameters(d+2:n,:));
    %% transformed = KKPP*rand(n,d);
    %% bending = trace(w'*PP'*K*PP*w)
end

