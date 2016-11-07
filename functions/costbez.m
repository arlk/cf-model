% Arun Lakshmanan
% Calculate costs for minimum energy bezier spline
function J = costbez(T)
  %% Computing time matrices {{{
  Q_T = [];
  A_T = [];

  for k = 0:(length(T)-1)
    A_T = [A_T T(k+1).^A_tp(:, (k*n_bcp+1):((k+1)*n_bcp))];
    Q_T = [Q_T T(k+1).^Q_tp(:, (k*n_bcp+1):((k+1)*n_bcp))];
  end
  %%% }}}

  %% Computing `R` {{{
  Q_full = Q.*Q_T;
  A_full = A.*A_T;
  R = C*inv(A_full')*Q_full*inv(A_full)*(C');
  %%% }}}

  %% Computing `dP` {{{
  n_fixed = length(dF);
  R_PP = R((n_fixed+1):end, (n_fixed+1):end);
  R_FP = R(1:n_fixed, (n_fixed+1):end);
  dP = -R_PP\((R_FP')*dF);
  %%% }}}

  %% Computing `a` {{{
  d = [dF; dP];
  d = (C')*d;
  a = A_full\d;
  %%% }}}

  %% Computing `J` {{{
  J = (a')*Q_full*a;
  %%% }}}

%%
end

% vim:foldmethod=marker:foldlevel=0
