function [ output_args ] = plot2d( ref, state, state2)
%PLOT_TRAJ Summary of this function goes here
%   Detailed explanation goes here
switch nargin
    case 3
        blue = [0 0.4470 0.7410];
        orange = [0.8500 0.3250 0.0980];
        h3=plot(state2(:,2),state2(:,3),'LineWidth',2.0, 'Color', orange);
        grid on
        hold on
        h2=plot(state(:,2),state(:,3),'LineWidth',2.0, 'Color', blue);
        grid on
        hold on
        h1=plot(ref(:,2),ref(:,3),'k--','LineWidth',1.0);
        grid on
        hold on
        plot(state2(1,2),state2(1,3),'o','Color',orange, ...
        'MarkerFaceColor',orange, 'MarkerSize', 8);
        grid on
        hold on
        plot(state(1,2),state(1,3),'o','Color',blue, ...
        'MarkerFaceColor',blue, 'MarkerSize', 8);
        grid on
        hold on
        plot(ref(1,2),ref(1,3),'ko', ...
        'MarkerFaceColor','k');
        grid on
        hold on
        plot(state2(end,2),state2(end,3),'>','Color',orange, ...
        'MarkerFaceColor',orange, 'MarkerSize', 14);
        grid on
        hold on
        plot(state(end,2),state(end,3),'>','Color',blue, ...
        'MarkerFaceColor',blue,'MarkerSize', 14);
        grid on
        hold on
        plot(ref(end,2),ref(end,3),'k>', ...
        'MarkerFaceColor','k');
        % h3=plot(state2(:,1),state2(:,2),'LineWidth',2.0, 'Color', orange);
        % grid on
        % hold on
        % h2=plot(state(:,1),state(:,2),'LineWidth',2.0, 'Color', blue);
        % grid on
        % hold on
        % h1=plot(ref(:,1),ref(:,2),'k--','LineWidth',1.0);
        % grid on
        % hold on
        % plot(state2(1,1),state2(1,2),'o','Color',orange, ...
        % 'MarkerFaceColor',orange, 'MarkerSize', 8);
        % grid on
        % hold on
        % plot(state(1,1),state(1,2),'o','Color',blue, ...
        % 'MarkerFaceColor',blue, 'MarkerSize', 8);
        % grid on
        % hold on
        % plot(ref(1,1),ref(1,2),'ko', ...
        % 'MarkerFaceColor','k');
        % grid on
        % hold on
        % plot(state2(end,1),state2(end,2),'>','Color',orange, ...
        % 'MarkerFaceColor',orange, 'MarkerSize', 14);
        % grid on
        % hold on
        % plot(state(end,1),state(end,2),'>','Color',blue, ...
        % 'MarkerFaceColor',blue,'MarkerSize', 14);
        % grid on
        % hold on
        % plot(ref(end,1),ref(end,2),'k>', ...
        % 'MarkerFaceColor','k');
        xlabel('X (m)');
        ylabel('Y (m)');
        xlim([-5.5 5.5]);
        ylim([-5.5 5.5]);
        set(gca,'Xtick',-5:1:5);
        set(gca,'Ytick',-5:1:5);
        legend([h1 h2 h3],'Reference', 'Geometric', 'PID');
        axis square
    case 2
        h3=plot3(ref(:,1),ref(:,2),ref(:,3),'k--','LineWidth',1.0);
        grid on
        hold on
        h1=plot3(state(:,1),state(:,2),state(:,3),'LineWidth',2.5);
        xlabel('X (m)');
        ylabel('Y (m)');
        zlabel('Z (m)');
        xlim([-2 30]);
        ylim([-6 6]);
        zlim([-6 6]);
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

