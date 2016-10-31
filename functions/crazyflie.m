cf2.Gravity         = 9.81;
cf2.AirDensity      = 1.225;
cf2.Mass            = 0.03327;
cf2.RotorRadius     = 23.1348e-3;
cf2.RotorNumber     = 4;
cf2.Ct              = 0.15;     % Thrust Coeff
cf2.Cq              = 0.11;     % Torque Coeff
cf2.ArmLength       = 39.73e-3;
cf2.b               = 1.35*cf2.Ct*...
                        cf2.AirDensity/(60)^(2)...
                        *(2*cf2.RotorRadius)^4;
cf2.k               = cf2.Cq*cf2.AirDensity/...
                        (60)^(2)*(2*cf2.RotorRadius)^5;
cf2.we              = sqrt(cf2.Mass*cf2.Gravity/(4*cf2.b));
cf2.pwm_gain        = 0.2685;
cf2.pwm_offset      = 4070.3;
cf2.pwm             = (cf2.we-cf2.pwm_offset)/cf2.pwm_gain;

cf2.c_drag          = 5;
cf2.Diameter        = cf2.ArmLength*2;


cf2.a = [   cf2.Diameter^2 / 10                        ;...                % body cross sectional area (X)
            cf2.Diameter^2 / 10                        ;...                % body cross sectional area (Y)
            pi/4 * (cf2.RotorRadius*2)^2                ];                 % body cross sectional area (Z)


Ixx =  1.395e-05;
Iyy = 1.395e-05;
Izz =  2.173e-05;
cf2.Inertia = diag([Ixx Iyy Izz]);
