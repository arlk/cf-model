function ders(bt, kT)

n_bcp = 2*(bt.der+1);

A_coeffs = ones(1, n_bcp);
for k = 0:(bt.der-1)
  A_slice = zeros(1, n_bcp);
  for n = 0:(n_bcp-1)
    A_slice(n+1) = A_coeffs(end, n+1)*(n-k);
  end
  A_coeffs = [A_coeffs; A_slice];
end

A_pow = zeros(1, n_bcp);
for k = 1:bt.der
  A_slice = k*ones(1, n_bcp);
  A_pow = [A_pow; A_slice];
end

A_T = [];
A_C = [];
for k = 1:length(bt.Tratio)
  A_T = [A_T (kT*bt.Tratio(k)).^-A_pow];
  A_C = [A_C A_coeffs];
end

A_C = A_C.*A_T;

x_ders = [];
y_ders = [];
z_ders = [];
phi_ders = [];
for k = 0:bt.der
  x_ders = [x_ders; bt.x.a'];
  y_ders = [y_ders; bt.y.a'];
  z_ders = [z_ders; bt.z.a'];
  phi_ders = [phi_ders; bt.phi.a'];
end

bt.x_ders = A_C.*x_ders;
bt.y_ders = A_C.*y_ders;
bt.z_ders = A_C.*z_ders;
bt.phi_ders = A_C.*phi_ders;

end
