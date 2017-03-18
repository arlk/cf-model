% Arun Lakshmanan
% Calculate costs for 3D minimum energy bezier spline
function f = cost3bez(bt, x)
  % Expanding time for last step:

  Jx = bt.x.costbez(x);
  Jy = bt.y.costbez(x);
  Jz = bt.z.costbez(x);
      
  bt.bez_cp = [bt.x.a ...
              bt.y.a ...
              bt.z.a];
            
  f = Jx+Jy+Jz;
end


