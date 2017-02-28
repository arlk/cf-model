% Arun Lakshmanan
% Initialize costs for minimum energy bezier spline
classdef BezierCurve < handle
  properties
   n_bcp
   Q
   Q_tp
   C
   dF
   A
   A_tp
   M_inv
   a
   bcp
   Q_r
   der
  end
  methods
    function bc = BezierCurve(waypts, der)
      %% Setup {{{
      % At some point see if waypts and der are bogus. Not today ...
      n_seg = length(waypts)-1;
      % For unconstrained formulation order is defined by the min deriv
      order = 2*der + 1;
      bc.n_bcp = order + 1;
      bc.der = der;
      %%% }}}

      H_r = zeros(bc.n_bcp-der);
      for i = 0:(bc.n_bcp-der-1)
        for j = 0:(bc.n_bcp-der-1)
          H_r(i+1,j+1) = nchoosek(bc.n_bcp-der-1,i)*nchoosek(bc.n_bcp-der-1,j)...
                /nchoosek(2*bc.n_bcp-der-1,i+j)/(2*bc.n_bcp-der);
        end
      end

      bc.Q_r = factorial(bc.n_bcp-1)/factorial(bc.n_bcp-der-1)*kron(eye(n_seg), bc.bezder(der)'*H_r*bc.bezder(der));


      %% Computing `d` {{{
      wp_match = [];
      for k = 2:n_seg
        wp_match = [wp_match waypts(k) NaN(1, der) zeros(1,der+1)];
      end
      d = [waypts(1) zeros(1, der) ...
             wp_match ...
             waypts(end) zeros(1, der)]';
      %%% }}}

      %% Computing `C` and `dF` {{{
      % For known parts
      C_up = [];
      C_down = [];
      bc.dF = [];

      for k = 1:length(d)
        if isnan(d(k))
          C_slice = zeros(1, bc.n_bcp*n_seg);
          C_slice(k) = 1;
          C_down = [C_down; C_slice];
        else
          C_slice = zeros(1, bc.n_bcp*n_seg);
          C_slice(k) = 1;
          C_up = [C_up; C_slice];
          bc.dF = [bc.dF; d(k)];
        end
      end

      bc.C = [C_up; C_down];
      %%% }}}

      A_0 = [];
      A_1 = [];
      A_T = [];

      for i=0:der
        A_0 = [A_0; factorial(bc.n_bcp-1)/factorial(bc.n_bcp-i-1)*bc.bezbern(i,0)*bc.bezder(i)];
        A_1 = [A_1; factorial(bc.n_bcp-1)/factorial(bc.n_bcp-i-1)*bc.bezbern(i,1)*bc.bezder(i)];
        A_T = [A_T; i*ones(1,bc.n_bcp)];
      end

      bc.A = A_0;
      bc.A_tp = A_T;
      for k = 1:(n_seg-1)
        kcol = [zeros((der+1), (k-1)*bc.n_bcp) A_1 zeros((der+1), bc.n_bcp); ...
                zeros((der+1), (k-1)*bc.n_bcp) A_1 -A_0];
        bc.A = [bc.A zeros((2*k-1)*(der+1), bc.n_bcp); kcol];
        kcol = [zeros((der+1), (k-1)*bc.n_bcp) A_T zeros((der+1), bc.n_bcp); ...
                zeros((der+1), (k-1)*bc.n_bcp) A_T A_T];
        bc.A_tp = [bc.A_tp zeros((2*k-1)*(der+1), bc.n_bcp); kcol];
      end
      bc.A = [bc.A; zeros((der+1), (n_seg-1)*bc.n_bcp) A_1];
      bc.A_tp = [bc.A_tp; zeros((der+1), (n_seg-1)*bc.n_bcp) A_T];

    end
    B = bezbern(bc, der, zeta)
    D = bezder(bc, der)
    J = costbez(bc, T)
  end
end

% vim:foldmethod=marker:foldlevel=0
