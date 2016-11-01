function [ output_args ] = plot_traj( state,ref )
%PLOT_TRAJ Summary of this function goes here
%   Detailed explanation goes here
switch nargin
    case 2
        h1=plot3(state(:,1),state(:,2),state(:,3),'LineWidth',1.3);
        grid on
        hold on
        h3=plot3(ref(:,1),ref(:,2),ref(:,3),'k--','LineWidth',1.0);
        title('3D Trajectory');
        xlabel('X (m)');
        ylabel('Y (m)');
        zlabel('Z (m)');
        xlim([-2 4]);
        ylim([-2 4]);
        zlim([0 15]);
        axis square
    case 1
        h1=plot3(state(:,1),state(:,2),state(:,3),'LineWidth',1.3);
        grid on
        title('3D Trajectory');
        xlabel('X (m)');
        ylabel('Y (m)');
        zlabel('Z (m)');
        axis square
    otherwise
end

end

