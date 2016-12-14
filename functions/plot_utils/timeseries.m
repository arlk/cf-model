function [ output_args ] = plot_time( vals1, vals2, val3, vals2 )
%PLOT_TRAJ Summary of this function goes here
%   Detailed explanation goes here
switch nargin
    case 3
        h1=plot(vals1(:,1),vals1(:,2),'LineWidth',1.0);
        grid on
        hold on
        h2=plot(vals2(:,1),vals2(:,2),'LineWidth',1.0);
        grid on
        hold on
        h3=plot(state2(:,2),state2(:,3),'LineWidth',2.0);
        xlabel('Y (m)');
        ylabel('Z (m)');
        xlim([-5.5 5.5]);
        ylim([-5.5 5.5]);
        set(gca,'Xtick',-5:1:5);
        legend([h1 h2 h3],'Reference', 'Geometric', 'PID', 'Location', 'SE');
        axis square
    case 2
        a = 1
        h1=plot(vals1(:,1),vals1(:,2),'LineWidth',1.0);
        grid on
        hold on
        h2=plot(vals2(:,1),vals2(:,2),'LineWidth',1.0);
        xlabel('t (s)');
        ylabel('|e_x| (m)');
        % xlim([-5.5 5.5]);
        % ylim([-5.5 5.5]);
        % set(gca,'Xtick',-5:1:5);
        legend([h1 h2],'Geometric', 'PID');
        axis square
    case 1
        h1=plot3(state(:,1),state(:,2),state(:,3),'LineWidth',1.3);
        grid on
        xlabel('X (m)');
        ylabel('Y (m)');
        zlabel('Z (m)');
        axis square
    otherwise
end

end

