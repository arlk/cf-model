function der = update_ders(bt, t)

Tsum = 0;
seg = 0;
n_bcp = 2*(bt.der+1);

for k = 1:length(bt.Tratio)
  Tsum = Tsum + bt.Tratio(k);
  if t <= Tsum
    seg = k;
    t = (t-Tsum+bt.Tratio(k))/bt.Tratio(k);
    break
  end
end

x_der = bt.x_ders(:,(seg-1)*n_bcp+1:seg*n_bcp);
y_der = bt.y_ders(:,(seg-1)*n_bcp+1:seg*n_bcp);
z_der = bt.z_ders(:,(seg-1)*n_bcp+1:seg*n_bcp);
phi_der = bt.phi_ders(:,(seg-1)*n_bcp+1:seg*n_bcp);

x_d = [];
y_d = [];
z_d = [];
phi_d = [];
for d = 1:(bt.der+1)
  t_poly = 1:(n_bcp-d);
  t_poly = t.^[repelem([0],d) t_poly];

  x_d = [x_d; x_der(d,:)*t_poly'];
  y_d = [y_d; y_der(d,:)*t_poly'];
  z_d = [z_d; z_der(d,:)*t_poly'];
  phi_d = [phi_d; phi_der(d,:)*t_poly'];
end

der = [x_d'; y_d'; z_d'; phi_d'];

end
