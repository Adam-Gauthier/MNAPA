clear all; close all; clc;
% Params
R1 = 1;
Cap = 0.25;
R2 = 2;
L = 0.2;
R3 = 10;
R4 = 0.1;
RO = 1000;
alpha = 100;

% output [ V1; V2; V3; V4; V5; IL]
G = [1 0 0 0 0 0;
    (-1/R1) (1/R2+1/R1) 0 0 0 0;
    0 0 1/R3 0 0 -1;
    0 0 -1*alpha/R3 1 0 0;
    0 0 0 -1/R4 (1/R4+1/RO) 0;
    0 -1 1 0 0 0];

C = [0 0 0 0 0 0;
    -Cap +Cap 0 0 0 0;
    0 0 0 0 0 0;
    0 0 0 0 0 0;
    0 0 0 0 0 0;
    0 0 0 0 0 L];

%% DC
Vin=[-10:1:10];
V3_dc = [];
V0_dc = [];
for v=Vin
    F = [v;0;0;0;0;0];
    ans = G\F;
    V3_dc = [V3_dc ans(3)];
    V0_dc = [V0_dc ans(5)];
end

figure(1);
hold on;
title('DC');
xlabel('Vin');
ylabel('V');
plot(Vin,V3_dc);
plot(Vin,V0_dc);
legend('V3','V0');
hold off;

%% AC sweep
Vin=1;
F=[Vin; 0; 0; 0; 0; 0];
omega = [0:1:100];
V0_ac = [];
dB = [];
for w = omega
    ans=(G+1j*w*C)\F;
    V0_ac = [V0_ac ans(5)];
    dB = [dB 20*log(ans(5))];
end
figure(2);
hold on;
title('AC');
xlabel('w');
ylabel('V or dB');
plot(omega,V0_ac);
plot(omega,dB);
legend('V0','dB gain');
hold off;

%% sensitivity to C
caps = [];
gains = [];
for i = [1:1:1000]
    new_C = Cap+randn()*0.05;
    C(2,:)=[-new_C +new_C 0 0 0 0];
    ans=(G+1j*pi*C)\F;
    caps = [caps new_C];
    gains = [gains real(ans(5))];
end

figure(3);
hold on;
title('Capacitance');
xlabel('C');
ylabel('Freq');
histogram(caps);
hold off;
figure(4);
hold on;
title('Gain');
xlabel('dB');
ylabel('Freq');
histogram(gains);
hold off;
    

