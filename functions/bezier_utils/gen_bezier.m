function curve = gen_bezier(t,P)
%GEN_BEZIER Summary of this function goes here
%   t - time
%   P - Control points

n = max(size(P));

B = bernMatrix_a2b(n-1,t);
curve = B(:,1:n)*P ;

end
