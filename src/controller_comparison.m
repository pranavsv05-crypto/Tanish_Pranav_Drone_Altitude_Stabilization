% ================================================
% HoverGuard — Phase 4: Three-Controller Comparison
% Shows WHY PID beats P and PD
% ================================================

num = [1]; den = [1 2 5];
G = tf(num, den);

% Your tuned gains from Phase 2
Kp = 8; Ki = 10; Kd = 2;

C_P  = pid(Kp, 0,  0 );   % P only
C_PD = pid(Kp, 0,  Kd);   % PD only  
C_PID= pid(Kp, Ki, Kd);   % Full PID

CL_P   = feedback(C_P   * G, 1);
CL_PD  = feedback(C_PD  * G, 1);
CL_PID = feedback(C_PID * G, 1);

figure('Name','Three Controller Comparison');
step(CL_P, CL_PD, CL_PID, 10);
legend('P only (oscillates, steady-state error)', ...
    'PD (faster, but steady-state error remains)', ...
    'PID (meets all specs ✓)');
title('Why Integral Action Matters — Controller Evolution');
grid on;

% Print metrics for all three
for label_C = {{'P', CL_P}, {'PD', CL_PD}, {'PID', CL_PID}}
    name = label_C{1}{1};
    sys  = label_C{1}{2};
    info = stepinfo(sys);
    dc   = dcgain(sys);
    fprintf('%s → Overshoot: %.1f%%, Settling: %.2fs, DC gain: %.3f\n', ...
        name, info.Overshoot, info.SettlingTime, dc);
end