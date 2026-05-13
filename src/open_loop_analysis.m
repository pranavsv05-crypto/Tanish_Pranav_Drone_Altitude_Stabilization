% ================================================
% HoverGuard — Phase 1: Plant Analysis
% G(s) = 1 / (s^2 + 2s + 5)
% ================================================

num = [1];
den = [1 2 5];
G = tf(num, den);

% Natural frequency and damping ratio
wn = sqrt(5);          % ~2.24 rad/s
zeta = 1/sqrt(5);      % ~0.447 — underdamped, will oscillate

fprintf('Natural frequency wn = %.4f rad/s\n', wn);
fprintf('Damping ratio zeta = %.4f\n', zeta);
fprintf('System is underdamped: expect oscillation without control\n\n');

% Open-loop step response
figure('Name','Open Loop Step Response');
step(G);
title('Open-Loop Step Response (No Controller)');
grid on;

% Poles of open-loop system
fprintf('Open-loop poles:\n');
disp(pole(G));

% Bode plot
figure('Name','Bode Plot');
bode(G);
title('Open-Loop Bode Plot');
grid on;