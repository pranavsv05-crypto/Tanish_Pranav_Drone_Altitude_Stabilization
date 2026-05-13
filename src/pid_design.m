% ================================================
% HoverGuard — Phase 2: PID Design via Pole Placement
% Target: overshoot < 10%, settling time < 3s
% ================================================

num = [1];
den = [1 2 5];
G = tf(num, den);

% --- Step 1: Define performance targets ---
% Overshoot < 10% → damping ratio ζ_d ≥ 0.59
% Settling time < 3s → σ = ζ*ωn > 4/Ts → σ > 1.33

zeta_d  = 0.7;      % chosen > 0.59 for safety margin
Ts_max  = 3.0;      % settling time requirement
sigma   = 4/Ts_max; % minimum real part of desired poles

% Desired natural frequency from sigma = zeta*wn
wn_d = sigma / zeta_d;   % ~1.9 rad/s
wd   = wn_d * sqrt(1 - zeta_d^2);  % damped natural frequency

% Desired closed-loop poles
p1 = -sigma + 1j*wd;
p2 = -sigma - 1j*wd;
fprintf('Desired poles: %.3f ± %.3fj\n', real(p1), imag(p1));

% --- Step 2: Use MATLAB PID Tuner as validation ---
% We'll use pidtune with our G and compare to hand-calculated

% Method A: MATLAB automatic (good baseline)
C_auto = pidtune(G, 'PID');
fprintf('\nAuto-tuned PID:\n');
disp(C_auto);

% Method B: Manual tuning around our desired response
% Start with auto, then refine
Kp = 8;
Ki = 10;
Kd = 2;
C_manual = pid(Kp, Ki, Kd);

% --- Step 3: Compare both closed-loop systems ---
CL_auto   = feedback(C_auto   * G, 1);
CL_manual = feedback(C_manual * G, 1);

figure('Name','Controller Comparison');
step(CL_auto, CL_manual, 5);
legend('Auto-tuned PID', 'Manual PID');
title('Closed-Loop Step Response Comparison');
grid on;

% --- Step 4: Get performance metrics ---
info_auto   = stepinfo(CL_auto);
info_manual = stepinfo(CL_manual);

fprintf('\n--- Auto-tuned PID ---\n');
fprintf('Overshoot:     %.2f%%\n', info_auto.Overshoot);
fprintf('Settling time: %.2fs\n',  info_auto.SettlingTime);

fprintf('\n--- Manual PID ---\n');
fprintf('Overshoot:     %.2f%%\n', info_manual.Overshoot);
fprintf('Settling time: %.2fs\n',  info_manual.SettlingTime);