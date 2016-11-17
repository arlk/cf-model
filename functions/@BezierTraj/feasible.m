function [c,ceq] = feasible(bt, k)
bt.ders(k);
u1_max = bt.u1(bt.update_ders(bt.u1_max_t));
u2_max = bt.u2(bt.rates(bt.update_ders(bt.u2_max_t)));
u3_max = bt.u3(bt.rates(bt.update_ders(bt.u3_max_t)));

u1_c = u1_max - 6/13.7;
u2_c = u2_max - 32/5;
u3_c = u3_max - 32/5;

c = [u1_c u2_c u3_c];
ceq = [];
end
