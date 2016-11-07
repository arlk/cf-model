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
  end
  methods
    function bc = BezierCurve(waypts, der)
      %% Setup {{{
      % At some point see if waypts and der are bogus. Not today ...
      n_seg = length(waypts)-1;
      % For unconstrained formulation order is defined by the min deriv
      order = 2*der + 1;
      bc.n_bcp = order + 1;
      %%% }}}

      %% Computing `Q` and `Q_tp` {{{
      % Ugly, ugly! but works ...
      bc.Q = zeros(n_seg*bc.n_bcp);

      for l = 0:(n_seg-1)
        for i = 0:(bc.n_bcp-1)
          for j = 0:(bc.n_bcp-1)
            if (i>=der) && (j>=der)
              product = 1;
              for m = 0:(der-1)
                product = product*(i-m)*(j-m);
              end
              bc.Q(l*bc.n_bcp+i+1,l*bc.n_bcp+j+1) = ...
                            2*product/(i+j-2*der+1);
            end
          end
        end
      end

      bc.Q_tp = [];
      for k = 1:n_seg
        bc.Q_tp = [bc.Q_tp zeros((k-1)*bc.n_bcp, bc.n_bcp); ...
          zeros(bc.n_bcp, (k-1)*bc.n_bcp) ones(bc.n_bcp)];
      end
      bc.Q_tp = (2*der-1)*bc.Q_tp;
      %%% }}}

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

      %% Computing `A` and `A_tp` {{{
      A_coeffs = ones(1, bc.n_bcp);
      for k = 0:(der-1)
        A_slice = zeros(1, bc.n_bcp);
        for n = 0:(bc.n_bcp-1)
          A_slice(n+1) = A_coeffs(end, n+1)*(n-k);
        end
        A_coeffs = [A_coeffs; A_slice];
      end

      A_pow = zeros(1, bc.n_bcp);
      for k = 1:der
        A_slice = k*ones(1, bc.n_bcp);
        A_pow = [A_pow; A_slice];
      end

      A_0 = eye(der+1, bc.n_bcp).*A_coeffs;
      A_pow_0 = eye(der+1, bc.n_bcp).*A_pow;
      bc.A = A_0;
      bc.A_tp = A_pow_0;
      for k = 1:(n_seg-1)
        kcol = [zeros((der+1), (k-1)*bc.n_bcp) A_coeffs zeros((der+1), bc.n_bcp); ...
                zeros((der+1), (k-1)*bc.n_bcp) A_coeffs -A_0];
        bc.A = [bc.A zeros((2*k-1)*(der+1), bc.n_bcp); kcol];
        kcol = [zeros((der+1), (k-1)*bc.n_bcp) A_pow zeros((der+1), bc.n_bcp); ...
                zeros((der+1), (k-1)*bc.n_bcp) A_pow A_pow_0];
        bc.A_tp = [bc.A_tp zeros((2*k-1)*(der+1), bc.n_bcp); kcol];
      end
      bc.A = [bc.A; zeros((der+1), (n_seg-1)*bc.n_bcp) A_coeffs];
      bc.A_tp = [bc.A_tp; zeros((der+1), (n_seg-1)*bc.n_bcp) A_pow];
      %%% }}}

      %% Computing `M_inv` {{{
      pas = eye(bc.n_bcp);
      pas(:,1) = 1;
      for k = 3:bc.n_bcp
        for j = 2:(k-1)
          pas(k,j) = pas(k-1,j-1) + pas(k-1,j);
        end
      end
      bez_inv = pas*diag(1./pas(end,:));
      bc.M_inv = kron(eye(n_seg),bez_inv);
      %%% }}}
    %%
    end
    J = costbez(bc, T)
  end
end

% vim:foldmethod=marker:foldlevel=0
