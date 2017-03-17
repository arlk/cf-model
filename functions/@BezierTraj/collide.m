function [c, ceq] = collide(bt, x)
bt.bez_cp = [bt.x.a ...
              bt.y.a ...
              bt.z.a];
control_points = bt.bez_cp(31:end,:);
ObsVer = [      0  0  0
                1  0  0
                1  1  0
                0  1  0 
                0  0  0]+[-4*ones(5,1),0*ones(5,1),zeros(5,1)];
            
ration1 = ones(length(control_points),1)';
ration2 = ones(length(ObsVer),1)';
temp=compMinDistBezierPoly_mex(control_points,'polynomial',ration1,...
    ObsVer,'polynomial',ration2,1/500)

% if temp>0
%     c=-1+.001;
% end

c=1;
% c=(temp+.001);

% if abs(temp)<.001
%     c=1000000000;
% end
t=0:.001:1;
plt=gen_bezier(t',control_points);

if max(inpolygon(plt(:,1),plt(:,2),ObsVer(:,1),ObsVer(:,2)))>0
    c=100000
end


ceq = [];

end

% plot(ObsVer(:,1),ObsVer(:,2))
% % axis equal
% hold on
% in=inpolygon(plt(:,1),plt(:,2),ObsVer(:,1),ObsVer(:,2));
% plot(plt(in,1),plt(in,2),'r+') % points inside
% plot(plt(~in,1),plt(~in,2),'bo') % points outside
