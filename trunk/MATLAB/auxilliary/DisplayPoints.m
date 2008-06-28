function [axis_limits] = DisplayPoints(Model, Scene, dim, sampling, axis_limits)
%%=====================================================================
%% $RCSfile: DisplayPoints.m,v $
%% $Author: bjian $
%% $Date: 2008/06/28 23:32:16 $
%% $Revision: 1.2 $
%%=====================================================================

%if (nargin<4)
%    axis_limits = determine_border(Model,Scene);
%end

if (nargin<4)
    sampling = 0;
end

if (nargin<5)
    axis_limits = determine_border(Model, Scene);
end

if dim==2
    DisplayPoints2D(Model(:,1:2), Scene(:,1:2), sampling, axis_limits);
end

if dim==3
   DisplayPoints3D(Model(:,1:3), Scene(:,1:3), sampling, axis_limits);
end