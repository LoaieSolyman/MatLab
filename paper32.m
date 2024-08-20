% Parameters
num_agents = 5;  % Number of agents
num_steps = 3000; % Number of time steps
dt = 0.01;       % Time step size

% Initialize agent states and leader trajectory
x = zeros(num_agents, num_steps); % Agent states in X
y = zeros(num_agents, num_steps); % Agent states in Y
z = zeros(num_agents, num_steps); % Agent states in Z
x_dot = zeros(num_agents, 1); % Agent velocities in X
y_dot = zeros(num_agents, 1); % Agent velocities in Y
z_dot = zeros(num_agents, 1); % Agent velocities in Z

x(:,1)=[20,4,0,-10,-15];
y(:,1)=[10,25,5,-25,6];
z(:,1)=[0.2,0.4,0,-0.1,-0.5];
x_dot(:,1)=[3,5,-10,-1,-15];
y_dot(:,1)=[-10,-5,0,-1,-15];
z_dot(:,1)=[30,5,-1,-1,-1];


% Control inputs
u_x = zeros(num_agents, num_steps); % Control input in X
u_y = zeros(num_agents, num_steps); % Control input in Y
u_z = zeros(num_agents, num_steps); % Control input in Z

leader_trajectory_x = zeros(1, num_steps); % Leader's trajectory in X
leader_trajectory_y = zeros(1, num_steps); % Leader's trajectory in Y
leader_trajectory_z = zeros(1, num_steps); % Leader's trajectory in Z

leader_velocity_x = zeros(1, num_steps);   % Leader's velocity in X
leader_velocity_y = zeros(1, num_steps);   % Leader's velocity in Y
leader_velocity_z = zeros(1, num_steps);   % Leader's velocity in Z

% Consensus gains
Kp = 0.5; % Proportional gain
Kv = 100.0; % Velocity gain

% Time vector
time = (0:num_steps-1) * dt;

% Leader's spiral trajectory and velocity
for t = 1:num_steps
    leader_trajectory_x(t) = 8 * cos(1 * time(t));  % Spiral in X
    leader_trajectory_y(t) = 8 * sin(1 * time(t));  % Spiral in Y
    leader_trajectory_z(t) = 0.5 * time(t);         % Linear increase in Z

    % Derivatives for velocity (using central difference method)
    if t > 1
        leader_velocity_x(t) = (leader_trajectory_x(t) - leader_trajectory_x(t-1)) / dt;
        leader_velocity_y(t) = (leader_trajectory_y(t) - leader_trajectory_y(t-1)) / dt;
        leader_velocity_z(t) = (leader_trajectory_z(t) - leader_trajectory_z(t-1)) / dt;
    end
end

% Consensus simulation
for t = 2:num_steps
    for i = 1:num_agents
        % Calculate control inputs (u_x, u_y, u_z) for each agent
        u_x(i, t) = Kp * (leader_trajectory_x(t-1) - x(i, t-1)) + Kv * (leader_velocity_x(t-1) - x_dot(i));
        u_y(i, t) = Kp * (leader_trajectory_y(t-1) - y(i, t-1)) + Kv * (leader_velocity_y(t-1) - y_dot(i));
        u_z(i, t) = Kp * (leader_trajectory_z(t-1) - z(i, t-1)) + Kv * (leader_velocity_z(t-1) - z_dot(i));
        
        % Calculate velocity updates based on the difference with leader's velocity
        x_dot(i) = x_dot(i) + u_x(i, t) * dt;
        y_dot(i) = y_dot(i) + u_y(i, t) * dt;
        z_dot(i) = z_dot(i) + u_z(i, t) * dt;
        
        % Update states with both position and velocity terms
        x(i, t) = x(i, t-1) + x_dot(i) * dt;
        y(i, t) = y(i, t-1) + y_dot(i) * dt;
        z(i, t) = z(i, t-1) + z_dot(i) * dt;
    end
end

% 3D Plotting the results
figure;
hold on;
plot3(leader_trajectory_x, leader_trajectory_y, leader_trajectory_z, 'k--', 'LineWidth', 2); % Leader's spiral trajectory in 3D
for i = 1:num_agents
    plot3(x(i, :), y(i, :), z(i, :), 'LineWidth', 1.5); % Agent trajectories in 3D
end
hold off;

% Labels and legend
xlabel('X Position');
ylabel('Y Position');
zlabel('Z Position');
%title('3D Consensus of Discrete Linear Agents with a Spiral Leader Trajectory');
legend(['Leader', arrayfun(@(i) sprintf('Agent %d', i), 1:num_agents, 'UniformOutput', false)]);
grid on;
view(3); % Set the default 3D view


% Plot the control inputs u(t) over time for each follower
figure;
for i = 1:num_agents
    subplot(num_agents, 1, i);
    plot(time, u_x(i, :), 'r', 'LineWidth', 1.5); hold on;
    plot(time, u_y(i, :), 'g', 'LineWidth', 1.5);
    plot(time, u_z(i, :), 'b', 'LineWidth', 1.5); hold off;
    xlabel('Time (s)');
    ylabel(sprintf('u(t) for Agent %d', i));
    title(sprintf('Control Input u(t) for Agent %d', i));
    legend('u_x(t)', 'u_y(t)', 'u_z(t)');
    grid on;
end



