function diagramConstellation(M)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
data = 0:M-1;
symgray = pammod(data,M,0,'gray');
mapgray = pamdemod(symgray,M,0,'gray');

symbin = pammod(data,M,0,'bin');
mapbin = pamdemod(symbin,M,0,'bin');

scatterplot(symgray,1,0,'b*');
axis([-M M -2 2])
line([0,0], ylim, 'Color', 'k', 'LineWidth', 0.25); % Draw line for Y axis.
line(xlim, [0,0], 'Color', 'k', 'LineWidth', 0.25); % Draw line for X axis.

for i = 1:M
    text(real(symgray(i))-0.2,imag(symgray(i))+0.6,...
        dec2base(mapgray(i),2,2));
    text(real(symgray(i))-0.1,imag(symgray(i))+1.2,...
        num2str(mapgray(i)));
    
    text(real(symbin(i))-0.2,imag(symbin(i))-0.6,...
        dec2base(mapbin(i),2,2),'Color',[1 0 0]);
    text(real(symbin(i))-0.1,imag(symbin(i))-1.2,...
        num2str(mapbin(i)),'Color',[1 0 0]);
end
text(-0.4,1.6,'\textbf{Gray}','Interpreter','latex');
text(-0.7,-1.6,'\textbf{Non-Gray}','Color',[1 0 0],'Interpreter','latex');
text(3.5,0.25,'\textbf{$\phi_1$}','Interpreter','latex');
title('\textbf{4-PAM Constellation}','Interpreter','latex')
xlabel('In-Phase','Interpreter','latex')
ylabel('Quadrature','Interpreter','latex')
xticks([-4 -3 -2 -1 0 1 2 3 4]);
grid on
end

