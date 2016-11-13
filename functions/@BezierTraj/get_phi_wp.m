% Arun Lakshmanan
% Yaw angle desired from bezier spline
function wp = get_phi_wp(bt)
d = 2*(bt.der+1);
d_ends = bt.der + 2;
num_wp = 1+size(bt.bez_cp, 1)/d;

vels = [bt.bez_cp(d+2:d:end, 1)-bt.bez_cp(d+1:d:end, 1) ...
        bt.bez_cp(d+2:d:end, 2)-bt.bez_cp(d+1:d:end, 2)];

vels = [bt.bez_cp(d_ends, 1)-bt.bez_cp(d_ends-1, 1) ...
        bt.bez_cp(d_ends, 2)-bt.bez_cp(d_ends-1, 2); ...
        vels;
        bt.bez_cp(end-d_ends+2, 1)-bt.bez_cp(end-d_ends+1, 1) ...
        bt.bez_cp(end-d_ends+2, 2)-bt.bez_cp(end-d_ends+1, 2)];

segs = bt.bez_cp(d:d:end, 1:2) - bt.bez_cp(1:d:end, 1:2);
segs = [segs; 0 0];

dirs = cross([vels zeros(num_wp,1)],[segs zeros(num_wp,1)]);
dirs = dirs(:,3);

wp = atan2(vels(:,2), vels(:,1));

shift = 0;
wp_shift = wp;
for k = 2:length(dirs)
    if (dirs(k-1) > 0) && (wp(k)-wp(k-1) < 0)
        if abs(wp(k) - wp(k-1) + 2*pi) < pi
          shift = shift + 2*pi;
        end
    elseif (dirs(k-1) < 0) && (wp(k)-wp(k-1) > 0)
        if abs(wp(k) - wp(k-1) - 2*pi) < pi
          shift = shift - 2*pi;
        end
    end
  wp_shift(k) = wp(k) + shift;
end
wp = wp_shift;

end
