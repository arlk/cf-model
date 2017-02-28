function [ output_args ] = plot_time( vals1, vals2, val3, vals4 )
%PLOT_TRAJ Summary of this function goes here
%   Detailed explanation goes here
switch nargin
    case 3
        blue = [0 0.4470 0.7410];
        orange = [0.8500 0.3250 0.0980];
        dataarr = vals1.Data;

        subplot(4,1,1);
        h1=plot(vals1.Time,vals1.Data(:,1),'LineWidth',1.5,'Color',blue);
        grid on
        hold on
        xlim([0 vals1.TimeInfo.End]);
        ylim([-2 max(dataarr(:,1))+1]);
        line([0 vals1.TimeInfo.End], [0 0], 'Color', 'r', ...
        'LineWidth',0.8,'LineStyle', '--');
        ylabel('$u_f$','FontSize', 22,'interpreter','latex');
        set(gca,'Xtick',-150:5:150);
        set(gca,'Ytick',-16:2:16);

        subplot(4,1,2);
        h2=plot(vals1.Time,vals1.Data(:,2),'LineWidth',1.5,'Color',blue);
        grid on
        hold on
        xlim([0 vals1.TimeInfo.End]);
        ylim([min(dataarr(:,2))-1 max(dataarr(:,2))+1]);
        line([0 vals1.TimeInfo.End], [0 0], 'Color', 'r',...
        'LineWidth',0.8,'LineStyle', '--');
        ylabel('$u_{\phi}$','FontSize', 22,'interpreter','latex');
        set(gca,'Xtick',-150:5:150);
        set(gca,'Ytick',-16:2:16);

        subplot(4,1,3);
        h3=plot(vals1.Time,vals1.Data(:,3),'LineWidth',1.5,'Color',blue);
        grid on
        hold on
        xlim([0 vals1.TimeInfo.End]);
        ylim([min(dataarr(:,3))-1 max(dataarr(:,3))+1]);
        line([0 vals1.TimeInfo.End], [0 0], 'Color', 'r',...
        'LineWidth',0.8,'LineStyle', '--');
        ylabel('$u_{\theta}$','FontSize',22,'interpreter','latex');
        set(gca,'Xtick',-150:5:150);
        set(gca,'Ytick',-16:2:16);

        subplot(4,1,4);
        h3=plot(vals1.Time,vals1.Data(:,4),'LineWidth',1.5,'Color',blue);
        grid on
        hold on
        xlim([0 vals1.TimeInfo.End]);
        ylim([min(dataarr(:,4))-1 2]);
        line([0 vals1.TimeInfo.End], [0 0], 'Color', 'r',...
        'LineWidth',0.8,'LineStyle', '--');
        ylabel('$u_{\psi}$','FontSize', 22,'interpreter','latex');
        xlabel('Time(s)','FontSize', 12,'interpreter','latex');
        set(gca,'Xtick',-150:5:150);
        set(gca,'Ytick',-16:2:16);
    case 2
        blue = [0 0.4470 0.7410];
        orange = [0.8500 0.3250 0.0980];
        h2=plot(vals2,'LineWidth',2.0,'Color',orange);
        grid on
        hold on
        h1=plot(vals1,'LineWidth',2.0,'Color',blue);
        % xlabel('$t$ (s)','interpreter', 'latex');
        % ylabel('$\left\lVert e_x \right\rVert$ (m)', 'interpreter', 'latex');
        xlabel('Time (s)');
        ylabel('Position Error (m)');
        timearr = [vals1.TimeInfo.End vals2.TimeInfo.End];
        dataarr = [vals1.Data; vals2.Data];
        xlim([0 max(timearr)]);
        ylim([min(dataarr)-1 max(dataarr)+1]);
        line(xlim, [0 0], 'Color', 'r', 'LineStyle', '--');
        % ax = gca;
        % ax.XAxisLocation = 'origin';
        % ax.Box = 'off';
        set(gca,'Xtick',-15:1:15);
        set(gca,'Ytick',-15:1:15);
        legend([h1 h2],'Geometric', 'PID');
        axis square
    case 1
        blue = [0 0.4470 0.7410];
        orange = [0.8500 0.3250 0.0980];
        dataarr = vals1.Data;

        subplot(3,1,1);
        h1=plot(vals1.Time,vals1.Data(:,1),'LineWidth',1.5,'Color',blue);
        grid on
        hold on
        xlim([0 vals1.TimeInfo.End]);
        ylim([min(dataarr(:,1))-1 max(dataarr(:,1))+1]);
        line([0 vals1.TimeInfo.End], [0 0], 'Color', 'r', ...
        'LineWidth',0.8,'LineStyle', '--');
        % ylabel('$e_x \cdot x_W$','FontSize', 18,'interpreter','latex');
        % ylabel('$e_v \cdot x_W$','FontSize', 18,'interpreter','latex');
        % ylabel('$e_R \cdot x_W$','FontSize', 18,'interpreter','latex');
        ylabel('$e_\Omega \cdot x_W$','FontSize', 18,'interpreter','latex');
        set(gca,'Xtick',-150:5:150);
        set(gca,'Ytick',-16:2:16);

        subplot(3,1,2);
        h2=plot(vals1.Time,vals1.Data(:,2),'LineWidth',1.5,'Color',blue);
        grid on
        hold on
        xlim([0 vals1.TimeInfo.End]);
        ylim([min(dataarr(:,2))-1 max(dataarr(:,2))+1]);
        line([0 vals1.TimeInfo.End], [0 0], 'Color', 'r',...
        'LineWidth',0.8,'LineStyle', '--');
        % ylabel('$e_x \cdot y_W$','FontSize', 18,'interpreter','latex');
        % ylabel('$e_v \cdot y_W$','FontSize', 18,'interpreter','latex');
        % ylabel('$e_R \cdot y_W$','FontSize', 18,'interpreter','latex');
        ylabel('$e_\Omega \cdot y_W$','FontSize', 18,'interpreter','latex');
        set(gca,'Xtick',-150:5:150);
        set(gca,'Ytick',-16:2:16);

        subplot(3,1,3);
        h3=plot(vals1.Time,vals1.Data(:,3),'LineWidth',1.5,'Color',blue);
        grid on
        hold on
        xlim([0 vals1.TimeInfo.End]);
        ylim([min(dataarr(:,3))-1 max(dataarr(:,3))+1]);
        line([0 vals1.TimeInfo.End], [0 0], 'Color', 'r',...
        'LineWidth',0.8,'LineStyle', '--');
        % ylabel('$e_x \cdot z_W$','FontSize', 18,'interpreter','latex');
        % ylabel('$e_v \cdot z_W$','FontSize', 18,'interpreter','latex');
        % ylabel('$e_R \cdot z_W$','FontSize', 18,'interpreter','latex');
        ylabel('$e_\Omega \cdot z_W$','FontSize', 18,'interpreter','latex');
        xlabel('Time(s)','FontSize', 12,'interpreter','latex');
        set(gca,'Xtick',-150:5:150);
        set(gca,'Ytick',-16:2:16);
    otherwise
end

end

