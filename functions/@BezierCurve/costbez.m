% Arun Lakshmanan
% Calculate costs for minimum energy bezier spline
function J = costbez(bc, T)
  %% Computing time matrices {{{
  Q_T = [];
  A_T = [];

  for k = 0:(length(T)-1)
    A_T = [A_T T(k+1).^-bc.A_tp(:, (k*bc.n_bcp+1):((k+1)*bc.n_bcp))];
    Q_T = [Q_T T(k+1).^-bc.Q_tp(:, (k*bc.n_bcp+1):((k+1)*bc.n_bcp))];
  end
  %%% }}}

  %% Computing `R` {{{
  Q_full = bc.Q.*Q_T;
  A_full = bc.A.*A_T;
  R = bc.C*inv(A_full')*Q_full*inv(A_full)*(bc.C');
  %%% }}}

  %% Computing `dP` {{{
  n_fixed = length(bc.dF);
  R_PP = R((n_fixed+1):end, (n_fixed+1):end);
  R_FP = R(1:n_fixed, (n_fixed+1):end);
  dP = -R_PP\((R_FP')*bc.dF);
  %%% }}}

  %% Computing `a` {{{
  d = [bc.dF; dP];
  d = (bc.C')*d;
  bc.a = A_full\d;
  %%% }}}

  %% Computing `J` {{{
  J = (bc.a')*Q_full*bc.a;
  %%% }}}

%%
end

% vim:foldmethod=marker:foldlevel=0
