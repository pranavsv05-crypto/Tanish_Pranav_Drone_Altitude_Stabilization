% ================================================
% HoverGuard — Phase 5: Robustness Sweep
% How does the controller handle increasing wind?
% ================================================

num = [1]; den = [1 2 5];
G = tf(num, den);
Kp = 8; Ki = 10; Kd = 2;
C = pid(Kp, Ki, Kd);

% Disturbance transfer function (from disturbance to output)
% D enters at plant input
S = feedback(G, C);   % sensitivity function

wind_forces  = 0.5:0.5:5.0;
settling_times = zeros(size(wind_forces));

fprintf('Wind Force (N) | Settling Time (s) | Status\n');
fprintf('------------------------------------------------\n');

for i = 1:length(wind_forces)
    d = wind_forces(i);
    % Simulate: step to 1m, then wind hits at t=5
    % Use lsim for full scenario
    t = 0:0.01:15;
    r = ones(size(t));   % reference altitude = 1m
    dist = d * (t >= 5); % wind kicks in at t=5

    % Full closed loop with disturbance
    CL = feedback(C*G, 1);
    DS = feedback(G, C);   % disturbance to output

    % Total output = reference tracking + disturbance response
    y_ref  = lsim(CL, r, t);
    y_dist = lsim(DS, dist, t);
    y_total = y_ref + y_dist;

    % Measure settling after disturbance (t > 5s window)
    idx = t >= 5;
    t_post = t(idx) - 5;
    y_post = y_total(idx) - 1;  % deviation from target

    settled = find(abs(y_post) <= 0.02, 1, 'last');
    if ~isempty(settled) && settled > 10
        ts = t_post(settled);
        status = 'STABLE ✓';
    else
        ts = NaN;
        status = 'UNSTABLE ✗';
    end
    settling_times(i) = ts;
    fprintf('  %.1f N          |  %s          | %s\n', d, num2str(ts,'%.2f'), status);
end

% Plot: settling time vs wind force
figure('Name','Robustness Analysis');
plot(wind_forces, settling_times, 'b-o', 'LineWidth', 2, 'MarkerFaceColor','b');
xlabel('Wind Disturbance Force (N)');
ylabel('Recovery Settling Time (s)');
title('HoverGuard Robustness: Recovery Time vs Wind Intensity');
yline(3, 'r--', 'Spec limit (3s)', 'LineWidth', 1.5);
grid on;