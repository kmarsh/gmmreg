function scale = estimate_scale(M)

%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: estimate_scale.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2008/06/28 08:27:13 $
%% Version:   $Revision: 1.1 $
%%=====================================================================

[m,d] = size(M);
scale = det(M'*M/m);
for i=1:d
    scale = sqrt(scale);
end