clc;
clear all;

%%Bot Parameters

AB = 0.265;
AD = 0.110;
BC = 0.170;
BE = 0.080;

M_bot = 1.75;
M_link = 0.22;

theta = 1.57; %%90 degrees starting value
J_axis = M_bot*((AB)^2)/3 + M_link*((AB)^2 + ((BC)^2)/3 + (AB)*(BC)*cos(theta));
T = 0;

AC = (AB^2 + BC^2 - 2*(AB)*(BC)*cos(3.14 - theta))^0.5;
AE = (AB^2 + BE^2 - 2*(AB)*(BE)*cos(3.14 - theta))^0.5;

phi = asin(BC*sin(theta)/AC);
del = phi - asin(BE*sin(theta)/AE);

v_A = 0.15; %m/s

%%Slope Parameter

g = 9.8;
beta = 1.046; %%60 degrees
mu_fr = 0.35;

del_t = 0.0005;

i = 1;
alpha(1)= 0;
zoomed_axes_values = zeros(3,100);

for j = 1:1:3
    
while(alpha(i) < beta)
    
alpha_dot = v_A * sin(beta)/(AC*cos(beta - alpha(i)));
alpha_dot_dot = - (alpha_dot)^2 * tan(beta - alpha(i));

Nfr(i) = (M_bot*g*AD*cos(alpha(i) + phi) + M_link*g*AE*cos(del + alpha(i)) + T*AD + J_axis*alpha_dot_dot)/(AC*(cos(beta - alpha(i)) - mu_fr*sin(beta-alpha(i))));

alpha(i+1) = alpha_dot*del_t + alpha(i);
i = i+1 ;

end

theta = theta - 0.436; %%each plot reduces theta by 25 degrees
alpha(1) = 0;
i=1;

AC = (AB^2 + BC^2 - 2*(AB)*(BC)*cos(3.14 - theta))^0.5;
AE = (AB^2 + BE^2 - 2*(AB)*(BE)*cos(3.14 - theta))^0.5;

title('N_{fr}');

plot(Nfr,'LineWidth',1);
xlabel('Time (x 0.0005s)');
ylabel('Contact Force on the Front Link (N)');
zoomed_axes_values(j,:) = Nfr(1:100);
grid on;
hold on
end

legend('90','75','60','Location','NorthEast');
[hleg,att] = legend('show');
title(hleg,'$\theta ^{\circ}$','Interpreter','latex');

labels_x = zeros(1,3);
labels_y = zeros(1,3);

axes('Position',[0.30 0.59 0.25 .3]); 
for i= 1:3
    plot(zoomed_axes_values(i,:),'LineWidth',1);
    grid on;
    hold on;
    labels_y(i) = zoomed_axes_values(i,1);
end

text(labels_x + 3,labels_y + 0.5,string(labels_y));

