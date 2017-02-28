% Arun Lakshmanan
% Calculate costs for minimum energy bezier spline
function B = bezbern(bc, der, zeta)
B = [];
ord = bc.n_bcp-der-1;
for i = 0:ord
  B = [B nchoosek(ord,i)*(1-zeta)^(ord-i)*zeta^i];
end
end
