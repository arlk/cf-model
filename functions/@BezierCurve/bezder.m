% Arun Lakshmanan
% Calculate costs for minimum energy bezier spline
function D = bezder(bc, der)
pasc = pascal(der+1,1);
P = pasc(end,:);
D = zeros(bc.n_bcp-der, bc.n_bcp);
for i = 1:bc.n_bcp-der
  D(i,i:i+der) = P;
end
end
