% Arun Lakshmanan
% Yaw angle desired from bezier spline
function wp = get_phi_wp(bt)
d = 2*(bt.der+1);
d_ends = bt.der + 2;

vels = [bt.bez_cp(d+2:d:end, 1)-bt.bez_cp(d+1:d:end, 1) ...
        bt.bez_cp(d+2:d:end, 2)-bt.bez_cp(d+1:d:end, 2)];

vels = [bt.bez_cp(d_ends, 1)-bt.bez_cp(d_ends-1, 1) ...
        bt.bez_cp(d_ends, 2)-bt.bez_cp(d_ends-1, 2); ...
        vels;
        bt.bez_cp(end-d_ends+2, 1)-bt.bez_cp(end-d_ends+1, 1) ...
        bt.bez_cp(end-d_ends+2, 2)-bt.bez_cp(end-d_ends+1, 2)];

wp = atan2(vels(:,2), vels(:,1));
end
