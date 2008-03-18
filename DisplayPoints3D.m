function [axis_limits] = DisplayPoints3D(Model, Scene, axis_limits)

%%=====================================================================
%% Project:   Pointset Registration using Gaussian Mixture Model
%% Module:    $RCSfile: DisplayPoints3D.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2008/01/03 22:21:54 $
%% Version:   $Revision: 1.2 $
%%=====================================================================

set(gca,'FontSize',16,'FontName','Times','FontWeight','bold');

plot3(Model(:,1),Model(:,2),Model(:,3),'r+', 'MarkerSize', 8, 'LineWidth',1.5);
hold on;
plot3(Scene(:,1),Scene(:,2),Scene(:,3),'bo', 'MarkerSize', 8, 'LineWidth',1.5);
axis equal;

if (nargin<3)
    axis_limits = determine_border(Model, Scene);
end

xlim(axis_limits(1,:));
ylim(axis_limits(2,:));   
zlim(axis_limits(3,:));   

pbaspect([1,1,1]);