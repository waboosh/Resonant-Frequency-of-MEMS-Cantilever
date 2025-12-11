clear; clc;

% Cantilever physical parameters
L = 300e-6;       % length (m)
w = 50e-6;        % width  (m)
t = 10e-6;        % thickness (m)
E = 130e9;        % Young's modulus (Pa)
rho_si = 2329;    % polysilicon density (kg/m^3)
rho_ps0 = 1050;    % polystyrene density (kg/m^3)

% Polystyrene Coating Parameters (Arbitrary Numbers for now)
L_ps = 50e-6;     % Length of PS on tip
W_ps = w;     % Uniform coating so same width as cantilever
t_ps = 0.1e-6;     % Thickness of PS on cantilever
V_ps = L_ps * W_ps * t;

% Beam mass
m_beam = rho_si * L * w * t;

% Moment of inertia
I = w * t^3 / 12;

% Spring constant (fundamental bending mode)
k = 3 * E * I / L^3;

% Dose and Average Molecular Weight Data
Dose = [0 20 40 60 80 100];   % kGy
MW_gmol = [25000 25500 26200 27000 27400 27200];  % g/mol
rho_ps = rho_ps0 * (MW_gmol)./MW_gmol(1); % Change in density 

% Mass change of cantilever (volume of PS doesn't change)
m_tip = rho_ps * V_ps;
m_eff = m_tip + 0.24 * m_beam;  % 0.24 = mass coefficient of 1st mode
 
% Resonant Frequency
f = (1 ./ (2*pi)) .* sqrt( k ./ (m_eff));

% Sensitivity
sensitivity = (f(end)-f(1))/(Dose(end)-Dose(1));
fprintf('Frequency sensitivity: %.2f kHz/kGy\n', sensitivity); 

% Plot
figure; 
plot(Dose, f, 'o-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Radiation Dose (kGy)');
ylabel('Resonance Frequency (kHz)');
title('Cantilever Resonance Frequency vs Radiation Dose');
grid on;
