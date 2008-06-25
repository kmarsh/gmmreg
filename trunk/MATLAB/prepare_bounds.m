% prepare the parameters for optimization 
function [x0, Lb, Ub, dim] = prepare_bounds(motion)

switch lower(motion)
    case 'rigid2d'
        dim = 2;  
        x0 = [0,0,0];
        MAX_DX = 80;  MAX_DY = 80;   MAX_DTHETA = pi;
        MIN_DX = -80;  MIN_DY = -80;   MIN_DTHETA = -pi;
        Lb = [MIN_DX; MIN_DY; MIN_DTHETA];
        Ub = [MAX_DX; MAX_DY; MAX_DTHETA];
    case 'rigid3d'
       dim = 3;  
       x0 = [0,0,0, 1, 0, 0, 0];
       MAX_DX = 40;
       MAX_DY = 40;
       MAX_DZ = 40;
       MIN_DX = -40;
       MIN_DY = -40;
       MIN_DZ = -40;
       MAX_DTHETA = pi/6;
       MIN_DTHETA = -pi/6;
       %  Lb = [MIN_DX; MIN_DY; MIN_DZ; MIN_DTHETA; MIN_DTHETA; MIN_DTHETA];
       %  Ub = [MAX_DX; MAX_DY; MAX_DZ; MAX_DTHETA; MAX_DTHETA; MAX_DTHETA];
       Lb = [-1 ; -1; -1; -1; MIN_DX; MIN_DY; MIN_DZ;];
       Ub = [1 ; 1; 1; 1; MAX_DX; MAX_DY; MAX_DZ;];
    case 'similarity3d'
       dim = 3;  
       x0 = [0,0,0, 1, 0, 0, 0, 1];
       MAX_DX = 40;
       MAX_DY = 40;
       MAX_DZ = 40;
       MIN_DX = -40;
       MIN_DY = -40;
       MIN_DZ = -40;
       MIN_SCALE = 0.6;
       MAX_SCALE = 1.5;
       %          MAX_DTHETA = pi/6;
       %         MIN_DTHETA = -pi/6;     
       %  Lb = [MIN_DX; MIN_DY; MIN_DZ; MIN_DTHETA; MIN_DTHETA; MIN_DTHETA];
       %  Ub = [MAX_DX; MAX_DY; MAX_DZ; MAX_DTHETA; MAX_DTHETA; MAX_DTHETA];
       Lb = [-1 ; -1; -1; -1; MIN_DX; MIN_DY; MIN_DZ; MIN_SCALE];
       Ub = [1 ; 1; 1; 1; MAX_DX; MAX_DY; MAX_DZ; MAX_SCALE];
    case 'affine2d'
        dim = 2;  
        x0 = [1,0,0,1,0,0];
        MAX_DX = 40;
        MAX_DY = 40;
        MIN_DX = -40;
        MIN_DY = -40;
        Lb = [-inf; -inf; -inf; -inf; MIN_DX; MIN_DY];
        Ub = [inf; inf; inf; inf; MAX_DX; MAX_DY];
    case 'affine3d'
        dim = 3;  
        x0 = [1,0,0, 0,1,0, 0,0,1, 0, 0,0];
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


% %     case 'camera_rotation'
% %        dim = 2; param_length = 5;
% %        x0 = [0,0,0,200];
% %        lb = -inf*ones(param_length,1); lb(1:3) = -pi*ones(3,1)/4;
% %        ub = inf*ones(param_length,1); ub(1:3) = pi*ones(3,1)/4;
% %     case 'homography'    
% %        dim = 2; param_length = 8;
% %        x0 = [0,0,0,600,600,0,200,200];
% %        Lb = -inf*ones(param_length,1); Lb(1:3) = -pi*ones(3,1)/4;
% %        Ub = inf*ones(param_length,1);  Ub(1:3) = pi*ones(3,1)/4;
% % 
% %     case 'projection'
% %         dim =2; param_length = 11;
% %         %x0 = [0,0,0.2261 ,   1.2965 ,0,   -0.0161,    8.7939,691.28,690.71,300,248];
% %         %x0 = [0,0,0.2261 ,   1.2965 ,0,   0,   0, 691.28,690.71,300,248];
% %         %x0 = camera_calib2(M,S)
% %         x0 = [0,0,0,0,0,0,700,700,0,300,250];
% %         Lb = -inf*ones(param_length,1);
% %         Ub = inf*ones(param_length,1);
% %         Lb(1:3) = -pi*ones(3,1)/4;
% %         Ub(1:3) = pi*ones(3,1)/4;
% %         %Lb(8:11) = [691.28,690.71,300,248];
% %         %Ub(8:11) = [692.28,691.71,301,250];
       