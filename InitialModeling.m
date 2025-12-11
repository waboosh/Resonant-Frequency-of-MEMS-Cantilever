
%% physical parameters for polystyrene
dose_kGy = [0 20 40 60 80 100];             % Radiation dose [kGy]
Mw = [25000 25500 26200 27000 27400 27200]; % Avg molecular weight [g/mol]
%% graph physical params
p = polyfit(dose_kGy, Mw, 1);
Mw_fit = polyval(p, dose_kGy);
fprintf('Linear fit: Mw = %.2f + %.2f * Dose (kGy)\n', p(2), p(1));
%% mapping molecular weight change to density change
rho0 = 1050; % kg/m^3, baseline density of PS
rho = rho0 * (Mw / Mw(1));  % assume proportional scaling
rel_rho_change = (rho - rho0) / rho0 * 100;
%% cantilever params
L = 300e-6;  % m
w = 50e-6;   % m
t_Si = 10e-6; % m
t_poly = 100e-9; % m coating thickness
E_Si = 1.3e11; % Pa
E_poly = 3e9;  % Pa
rho_Si = 2330; % kg/m^3
%% find frequency for each dose amount
for i = 1:length(dose_kGy)
   % calculate inertia
   I_Si = w * t_Si^3 / 12; %centroid is approximated as center of Si
   I_poly = w * t_poly^3 / 12 + w * t_poly * (t_Si/2 + t_poly/2)^2; % parallel axis
   I_total = E_Si*I_Si + E_poly*I_poly;
  
   % composite stiffness (weighted by E)
   E_eff = I_total / (I_Si + I_poly);
  
   % composite density (weighted by volume)
   rho_eff = (rho_Si * t_Si + rho(i) * t_poly) / (t_Si + t_poly);
  
   % resonant frequency (fundamental mode of a cantilever)
   f(i) = (1.875^2/(2*pi)) * sqrt(E_eff / rho_eff) * (t_Si / L^2);
end
%% calculate frequency shift relative to no radiation
f0 = f(1);
df = f - f0;
sensitivity = (f(end)-f(1)) / (dose_kGy(end)-dose_kGy(1));
fprintf('Frequency sensitivity: %.2f Hz/kGy\n', sensitivity*1e3); % in Hz/kGy
%% plot
figure('Name','Polystyrene Radiation Response','Position',[200 200 1000 400])
subplot(1,2,1)
plot(dose_kGy, Mw, 'ko-', 'LineWidth', 1.5, 'MarkerFaceColor','r')
xlabel('Dose (kGy)'); ylabel('Average Molecular Weight (g/mol)')
title('Molecular Weight vs Dose')
grid on
subplot(1,2,2)
plot(dose_kGy, f*1e-3, 'b^-','LineWidth',1.5,'MarkerFaceColor','c')
xlabel('Dose (kGy)'); ylabel('Resonant Frequency (kHz)')
title('Cantilever Frequency vs Dose')
grid on
fprintf('\n----- Summary -----\n');
fprintf('Nominal Resonant Frequency: %.2f kHz\n', f0*1e-3);
fprintf('Frequency at 100 kGy: %.2f kHz\n', f(end)*1e-3);
fprintf('Total Frequency Shift: %.2f Hz\n', (f(end)-f0)*1e3);
fprintf('Sensitivity (linear approx): %.2f Hz/kGy\n', sensitivity*1e3);

