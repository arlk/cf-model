function [ qqq ] = gen_detour( t_c,t_temp )
%gen_detour Generate detour for static obstacle
%   t_c - collision time.
%   seg - collision segment.

%     tstart = 0;
%     tend = 1;
%   
%     g = @(x) (x-tstart)/(tend-tstart);
%     
% 
%     t_temp = linspace(0,1,N_plt_pts);

    bb=bernMatrix_a2b(18-1,t_temp');
    b = bb(t_temp<=t_c,:);
    b= b(end,:); qq = b';
    qqq = (qq./(sum(qq.^2)));
    qqq=[zeros(6,1);qqq;zeros(6,1)];
    qqq(11:14)=qqq(10)*ones(4,1);
    qqq(20-3:20)=qqq(21)*ones(4,1);
    
end

