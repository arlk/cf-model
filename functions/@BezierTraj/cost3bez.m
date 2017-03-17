% Arun Lakshmanan
% Calculate costs for 3D minimum energy bezier spline
function f = cost3bez(bt, x)
  % Expanding time for last step:
  Jx = bt.x.costbez(x);
  Jy = bt.y.costbez(x);
  Jz = bt.z.costbez(x);
   c=0;

  bt.bez_cp = [bt.x.a ...
              bt.y.a ...
              bt.z.a];
          
control_points = bt.bez_cp(31:end,:);
t=0:.00001:1;
plt=gen_bezier(t',control_points);
obsarray = {};
obsarray{length(obsarray)+1} =  [0  0  0
                1  0  0
                1  2  0
                0  2  0 
                0  0  0]+[5*ones(5,1),7.5*ones(5,1),zeros(5,1)];          
obsarray{length(obsarray)+1} =  [0  0  0
                2  0  0
                2  10  0
                0  10  0 
                0  0  0]+[-1*ones(5,1),7*ones(5,1),zeros(5,1)];         
obsarray{length(obsarray)+1} =  [0  0  0
                2  0  0
                2  10  0
                0  10  0 
                0  0  0]+[-6*ones(5,1),-5*ones(5,1),zeros(5,1)];         
obsarray{length(obsarray)+1} =  [0  0  0
                2  0  0
                2  10  0
                0  10  0 
                0  0  0]+[2*ones(5,1),-5*ones(5,1),zeros(5,1)];                            

%     obsarray{1} =  [0  0  0
%                     1  0  0
%                     1  1  0
%                     0  1  0 
%                     0  0  0]+[7*ones(5,1),10*ones(5,1),zeros(5,1)];  

%     obsarray{1} =  [0  0  0
%                     2  0  0
%                     2  10  0
%                     0  10  0 
%                     0  0  0]+[-1*ones(5,1),7*ones(5,1),zeros(5,1)];         
%     obsarray{2} =  [0  0  0
%                     2  0  0
%                     2  10  0
%                     0  10  0 
%                     0  0  0]+[-7*ones(5,1),-5*ones(5,1),zeros(5,1)];         
%     obsarray{3} =  [0  0  0
%                     2  0  0
%                     2  10  0
%                     0  10  0 
%                     0  0  0]+[2*ones(5,1),-5*ones(5,1),zeros(5,1)]; 
%     obsarray{4} =  2*[0  0  0
%                     1  0  0
%                     1  1  0
%                     0  1  0 
%                     0  0  0]+[5*ones(5,1),7*ones(5,1),zeros(5,1)];
%     
    for i=1:length(obsarray)
        if max(inpolygon(plt(:,1),plt(:,2),obsarray{i}(:,1),obsarray{i}(:,2)))>0
             c=c+2000000000;
        end
    end
    
  f = Jx+Jy+Jz+c;
end
% 
% figure; 
% plot(ObsVer(:,1),ObsVer(:,2))
% axis equal
% hold on
% in=inpolygon(plt(:,1),plt(:,2),ObsVer(:,1),ObsVer(:,2));
% plot(plt(in,1),plt(in,2),'r+') % points inside
% plot(plt(~in,1),plt(~in,2),'bo') % points outside

