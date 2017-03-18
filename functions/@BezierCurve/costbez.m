% Arun Lakshmanan
% Calculate costs for minimum energy bezier spline
function J = costbez(bc, T)
    %% Computing time matrices {{{
    A_T = [];
    Q_R = [];

    for k = 0:(length(T)-1)
    A_T = [A_T T(k+1).^-bc.A_tp(:,(k*bc.n_bcp+1):((k+1)*bc.n_bcp))];
    Q_R = [Q_R (T(k+1)^(-bc.der*2+1))*bc.Q_r(:, (k*bc.n_bcp+1):((k+1)*bc.n_bcp))];
    end
    %%% }}}

    %% Computing `R` {{{
    Q_full = Q_R;
    A_full = bc.A.*A_T;
    R = bc.C*inv(A_full')*Q_full*inv(A_full)*(bc.C');
    %%% }}}

    %% Computing `dP` {{{
    n_fixed = length(bc.dF);
    R_PP = R((n_fixed+1):end, (n_fixed+1):end);
    R_FP = R(1:n_fixed, (n_fixed+1):end);
    R_PF = R((n_fixed+1):end, 1:n_fixed);


    dP = -(R_PP+R_PP')\(R_PF*bc.dF+(R_FP')*bc.dF);
    % Old method from Richter's paper - probably wrong.
    % dP = -R_PP\((R_FP')*bc.dF);
    %%% }}}

    %% Computing `a` {{{
    d = [bc.dF; dP];
    d = (bc.C')*d;
    
%     temp = 1:30;
%     temp(temp==1|temp==16)=[];
%     test = A_full(temp,temp);
%     bc.a = (test)\d(temp);
%     %%% }}}
% 
%     %% Computing `J` {{{
%     J = (bc.a')*Q_full(temp,temp)*bc.a;
%     
    
    bc.a = (A_full)\d;
    %%% }}}

    %% Computing `J` {{{
    J = (bc.a')*Q_full*bc.a;
    %%% }}}



    %%
end

% vim:foldmethod=marker:foldlevel=0
