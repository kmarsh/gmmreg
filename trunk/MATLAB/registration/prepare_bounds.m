% prepare the parameters for optimization 
function [x0, Lb, Ub] = prepare_bounds(motion)
%%=====================================================================
%% $RCSfile: GMMReg_TPS.m,v $
%% $Author: bjian $
%% $Date: 2008/01/03 20:24:58 $
%% $Revision: 1.9 $
%%=====================================================================
switch lower(motion)
    case 'rigid2d'
        x0 = [0,0,0];    %[ translation_x, translation_y,  rotation_theta]
        MAX_DX = 80;  MAX_DY = 80;   MAX_DTHETA = pi;
        MIN_DX = -80;  MIN_DY = -80;   MIN_DTHETA = -pi;
        Lb = [MIN_DX; MIN_DY; MIN_DTHETA];
        Ub = [MAX_DX; MAX_DY; MAX_DTHETA];
    case 'rigid3d'     %[unit quaternion,  translation_xyz]
       x0 = [0,0,0, 1, 0, 0, 0];
       MAX_DX = 40;
       MAX_DY = 40;
       MAX_DZ = 40;
       MIN_DX = -40;
       MIN_DY = -40;
       MIN_DZ = -40;
       Lb = [-1 ; -1; -1; -1; MIN_DX; MIN_DY; MIN_DZ;];
       Ub = [1 ; 1; 1; 1; MAX_DX; MAX_DY; MAX_DZ;];
    case 'similarity3d'   %[unit quaternion,  translation_xyz,  scaling_factor]
       x0 = [0,0,0, 1, 0, 0, 0, 1];
       MAX_DX = 40;
       MAX_DY = 40;
       MAX_DZ = 40;
       MIN_DX = -40;
       MIN_DY = -40;
       MIN_DZ = -40;
       MIN_SCALE = 0.6;
       MAX_SCALE = 1.5;
       Lb = [-1 ; -1; -1; -1; MIN_DX; MIN_DY; MIN_DZ; MIN_SCALE];
       Ub = [1 ; 1; 1; 1; MAX_DX; MAX_DY; MAX_DZ; MAX_SCALE];
    case 'affine2d'
        x0 = [1,0,0,1,0,0];   %[reshape(eye(2),1,4),  translation_xy]
        MAX_DX = 40;
        MAX_DY = 40;
        MIN_DX = -40;
        MIN_DY = -40;
        Lb = [-inf; -inf; -inf; -inf; MIN_DX; MIN_DY];
        Ub = [inf; inf; inf; inf; MAX_DX; MAX_DY];
    case 'affine3d'      
        x0 = [1,0,0, 0,1,0, 0,0,1, 0, 0,0];    %[reshape(eye(3),1,9),  translation_xyz]
        MAX_DX = 100;
        MAX_DY = 100;
        MAX_DZ = 100;
        MIN_DX = -100;
        MIN_DY = -100;
        MIN_DZ = -100;
        Lb = [0; -inf; -inf; -inf; 0; -inf; -inf; -inf; 0; MIN_DX; MIN_DY; MIN_DZ];
        Ub = [inf; inf; inf; inf; inf; inf; inf; inf; inf; MAX_DX; MAX_DY; MAX_DZ];
    otherwise
        error('Unknown motion type');
end;


       