function [ obst_pts ] = gen_obst(center, size)
%GEN_OBST Summary of this function goes here
%   center - R2 x,y
%   size   - R2 x,y radius
%
%   obs_pts= gen_obst([0 5],[2 3]);
%   patch(obs_pts(:,1),obs_pts(:,2),[.2 .2 .2])

obst_pts =      [-1     -1;
                 -1      1;
                  1      1;
                  1     -1];
              
obst_pts(:,1) = size(1)*obst_pts(:,1);              
obst_pts(:,2) = size(2)*obst_pts(:,2);  

obst_pts = obst_pts+[center(1)*ones(4,1),center(2)*ones(4,1)];

end

