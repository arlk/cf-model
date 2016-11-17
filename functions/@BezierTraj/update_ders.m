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

t_poly = 0:(n_bcp-1);
t_poly = t.^t_poly;

x_der = x_der*t_poly';
y_der = y_der*t_poly';
z_der = z_der*t_poly';
phi_der = phi_der*t_poly';

der = [x_der'; y_der'; z_der'; phi_der'];

end
