function w = rates(bt, der)
thrust = [der(1, 3); der(2, 3); der(3, 3)+bt.veh.Gravity];
u1_m = norm(thrust);
z_b = thrust/u1_m;
x_w = [cos(der(4,1)) sin(der(4,1)) 0];
y_b = cross(z_b, x_w);
y_b = y_b/norm(y_b);
x_b = cross(y_b, z_b);

u1_dot_m = dot(z_b, der(1:3,4));
h_w = (der(1:3,4) - u1_dot_m*z_b)/u1_m;

p = -dot(h_w, y_b);
q = dot(h_w, x_b);
r = der(4,2)*z_b(3);
omg = [p q r]';

u1_ddot_m = dot(z_b, der(1:3,5)) - dot(z_b, cross(omg, cross(omg, u1_m*z_b)));
h_a = (der(1:3,5) - u1_ddot_m*z_b - 2*cross(omg, u1_dot_m*z_b) - cross(omg, cross(omg, u1_m*z_b)))/u1_m;

p_dot = -dot(h_a, y_b);
q_dot = dot(h_a, x_b);
r_dot = der(4,3)*z_b(3);
omg_dot = [p_dot, q_dot, r_dot]';

w = [omg'; omg_dot'];
end
