% Andrew Patterson
% Collision check for set of points
function [collide_locations] = collision_check(path, obsarray)
    
    collide_locations = cell(length(obsarray),1);
    for i = 1:length(obsarray)

        [col_pts,on] = ...
        inpolygon(path(:,1),path(:,2),...
        obsarray{i}(:,1),obsarray{i}(:,2));
    
        % Conservative, include boundary points
        col_pts=col_pts|on; 
        
        % Add to array
        collide_locations{i} = col_pts;
        

    end
    
end

%%%% 3D version
%%%% Matlab built in function, replace with bez specific
%         [col_pts,on] = ...
%         inpolygon(path(:,1),path(:,2),path(:,3),...
%         obsarray{i}(:,1),obsarray{i}(:,2),obsarray{i}(:,3));


%%%% colide flag
%         if 1==any(col_pts)
%             iscollide=1;
%         end
