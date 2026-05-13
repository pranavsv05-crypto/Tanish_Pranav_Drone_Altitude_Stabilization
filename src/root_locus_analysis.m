% ================================================
% HoverGuard — Root Locus Analysis
% Shows WHY our PID poles achieve the specs
% ================================================

num = [1]; den = [1 2 5];
G = tf(num, den);

Kp = 10.2543; Ki = 13.1422; Kd = 1.9336;
C = pid(Kp, Ki, Kd);

% Open-loop system with controller
L = C * G;

% Root locus
figure('Name', 'Root Locus');
rlocus(L);
title('Root Locus — HoverGuard PID');
grid on;

% Mark the closed-loop poles
CL = feedback(L, 1);
cl_poles = pole(CL);
hold on;
plot(real(cl_poles), imag(cl_poles), 'rx', ...
    'MarkerSize', 12, 'LineWidth', 2);
legend('Root locus', 'Closed-loop poles');
fprintf('Closed-loop poles:\n'); disp(cl_poles);

% Also add to Phase 1 bode — combined analysis
figure('Name', 'Bode — Open vs Closed Loop');
bode(G, CL);
legend('Open-loop (no controller)', 'Closed-loop (HoverGuard PID)');
title('Frequency Response Comparison');
grid on;