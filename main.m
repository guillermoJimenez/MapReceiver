clear, clc
addpath('Routines')
M=4;
EbNoVec = 0:10;
k=1000;
f = waitbar(0,'Please wait...');
% t_hk10000=zeros(1,4);
% t_sk10000=zeros(1,4);

%% DIAGRAM CONSTELLATION

% Representation of both bit-mappings
diagramConstellation(M);

%% HARD-OUTPUT and SOFT-OUTPUT
% tic
BER1Gray_h = ber(EbNoVec,k,1,0,'gray','hard',0,0,f);
% t_hk10000(1,1)=toc;
% tic
BER2Gray_h = ber(EbNoVec,k,2,0,'gray','hard',0,1,f);
% t_hk10000(1,2)=toc;
% tic
BER1NonGray_h= ber(EbNoVec,k,1,0,'bin','hard',0,2,f);
% t_hk10000(1,3)=toc;
% tic
BER2NonGray_h= ber(EbNoVec,k,2,0,'bin','hard',0,3,f);
% t_hk10000(1,4)=toc;

% save('t_hk10000.mat','t_hk10000');
% save('data_h.mat', 'BER1Gray_h', 'BER2Gray_h', 'BER1NonGray_h', 'BER2NonGray_h');

% tic
BER1Gray_s = ber(EbNoVec,k,1,0,'gray','soft',0,4,f);
% t_sk10000(1,1)=toc;
% tic
BER2Gray_s = ber(EbNoVec,k,2,0,'gray','soft',0,5,f);
% t_sk10000(1,2)=toc;
% tic
BER1NonGray_s = ber(EbNoVec,k,1,0,'bin','soft',0,6,f);
% t_sk10000(1,3)=toc;
% tic
BER2NonGray_s = ber(EbNoVec,k,2,0,'bin','soft',0,7,f);
% t_sk10000(1,4)=toc;

% save('t_sk10000.mat','t_sk10000');
% save('data_s.mat', 'BER1Gray_s', 'BER2Gray_s', 'BER1NonGray_s', 'BER2NonGray_s');

%% ITERATIVE DECODING

nIter = 10;
% Cell structure for storing the different iterations
BER1Gray_i = cell(1,nIter);
BER2Gray_i = cell(1,nIter);
BER1NonGray_i = cell(1,nIter);
BER2NonGray_i = cell(1,nIter);

% t_ik10000_ber1gray = zeros(1,nIter);
% t_ik10000_ber2gray = zeros(1,nIter);
% t_ik10000_ber1nongray = zeros(1,nIter);
% t_ik10000_ber2nongray = zeros(1,nIter);

% This is only to display the simulation progress
i=8;
%EbNoVec=1:3:8;
for n=1:nIter
    %if n==1 || n==3 || n==6 || n==10 
        %tic
        BER1Gray_i{n} = ber(EbNoVec,k,1,0,'gray','iterative',n,i,f);
        %t_ik10000_ber1gray(1,n) = toc;
        %tic
        BER2Gray_i{n} = ber(EbNoVec,k,2,0,'gray','iterative',n,i+1,f);
        %t_ik10000_ber2gray(1,n) = toc;
        %tic
        BER1NonGray_i{n} = ber(EbNoVec,k,1,0,'bin','iterative',n,i+2,f);
        %t_ik10000_ber1nongray(1,n) = toc;
        %tic
        BER2NonGray_i{n} = ber(EbNoVec,k,2,0,'bin','iterative',n,i+3,f);
        %t_ik10000_ber2nongray(1,n) = toc;
    
        BER1Gray = BER1Gray_i{n};
        BER2Gray = BER2Gray_i{n};
        BER1NonGray = BER1NonGray_i{n};
        BER2NonGray = BER2NonGray_i{n};
        fname = sprintf('data_Iter_%d.mat',n);
        save(fname,'BER1Gray','BER2Gray','BER1NonGray','BER2NonGray');
        i=i+4;
    %end
end

% save('t_ik10000_ber1gray.mat','t_ik10000_ber1gray');
% save('t_ik10000_ber2gray.mat','t_ik10000_ber2gray');
% save('t_ik10000_ber1nongray.mat','t_ik10000_ber1nongray');
% save('t_ik10000_ber2nongray.mat','t_ik10000_ber2nongray');

toc
close(f)

%% HARD and SOFT PLOTS

% Hard-output
load('data_h.mat')
figure
semilogy(EbNoVec,BER1Gray_h,'-*')
hold on
semilogy(EbNoVec,BER2Gray_h,'-*')
semilogy(EbNoVec,BER1NonGray_h,'-*')
semilogy(EbNoVec,BER2NonGray_h,'-*')
grid on
title('\textbf{Hard-output BER}','Interpreter','latex','FontSize',14)
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('Hard C1 Gray','Hard C2 Gray','Hard C1 Non-Gray','Hard C2 Non-Gray','Location','southwest','Interpreter','latex');

% Soft-output
load('data_s.mat')
figure
semilogy(EbNoVec,BER1Gray_s,'-*')
hold on
semilogy(EbNoVec,BER2Gray_s,'-*')
semilogy(EbNoVec,BER1NonGray_s,'-*')
semilogy(EbNoVec,BER2NonGray_s,'-*')
grid on
title('\textbf{Soft-output BER}','Interpreter','latex','FontSize',14)
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('Soft C1 Gray','Soft C2 Gray','Soft C1 Non-Gray','Soft C2 Non-Gray','Location','southwest','Interpreter','latex');

% Both hard-output and soft-output
figure
semilogy(EbNoVec,BER1Gray_h,'-*')
hold on
semilogy(EbNoVec,BER2Gray_h,'-*')
semilogy(EbNoVec,BER1NonGray_h,'-*')
semilogy(EbNoVec,BER2NonGray_h,'-*')
semilogy(EbNoVec,BER1Gray_s,'--*')
semilogy(EbNoVec,BER2Gray_s,'--*')
semilogy(EbNoVec,BER1NonGray_s,'--*')
semilogy(EbNoVec,BER2NonGray_s,'--*')
grid on
title('\textbf{Hard-output and soft-output BER}','Interpreter','latex','FontSize',14)
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('Hard C1 Gray','Hard C2 Gray','Hard C1 Non-Gray','Hard C2 Non-Gray',...
       'Soft C1 Gray','Soft C2 Gray','Soft C1 Non-Gray','Soft C2 Non-Gray','Location','southwest','Interpreter','latex');

%% ITERATIVE PLOTS

data_Iter = cell(1,nIter);
for i=1:nIter
str=sprintf('data_Iter_%d.mat',i);

data_Iter{i} = [load(str).BER1Gray;
                load(str).BER2Gray;
                load(str).BER1NonGray;
                load(str).BER2NonGray;];
end

% C1 GRAY
figure
for n=1:nIter
    %if n==1 || n==3 || n==6 || n==10 
        semilogy(EbNoVec,data_Iter{n}(1,:),'-*')
        hold on
    %end
end
grid on
title('\textbf{Iterative decoding BER C1 Gray}', 'Interpreter', 'latex','FontSize',14) 
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('N = 1 iteration','N = 2 iterations','N = 3 iterations','N = 4 iterations','N = 5 iterations',...
    'N = 6 iterations','N = 7 iterations','N = 8 iterations','N = 9 iterations','N = 10 iterations','Location','southwest','Interpreter','latex');
% C2 GRAY
figure
for n=1:nIter
    %if n==1 || n==3 || n==6 || n==10 
        semilogy(EbNoVec,data_Iter{n}(2,:),'-*')
        hold on
    %end
end
grid on
title('\textbf{Iterative decoding BER C2 Gray}', 'Interpreter', 'latex','FontSize',14) 
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('N = 1 iteration','N = 2 iterations','N = 3 iterations','N = 4 iterations','N = 5 iterations',...
    'N = 6 iterations','N = 7 iterations','N = 8 iterations','N = 9 iterations','N = 10 iterations','Location','southwest','Interpreter','latex');
% C1 NON-GRAY
figure
for n=1:nIter
    %if n==1 || n==3 || n==6 || n==10 
        semilogy(EbNoVec,data_Iter{n}(3,:),'-*')
        hold on
    %end
end
grid on
title('\textbf{Iterative decoding BER C1 Non-Gray}', 'Interpreter', 'latex','FontSize',14) 
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('N = 1 iteration','N = 2 iterations','N = 3 iterations','N = 4 iterations','N = 5 iterations',...
    'N = 6 iterations','N = 7 iterations','N = 8 iterations','N = 9 iterations','N = 10 iterations','Location','southwest','Interpreter','latex');
% C2 NON-GRAY
figure
for n=1:nIter
    %if n==1 || n==3 || n==6 || n==10 
        semilogy(EbNoVec,data_Iter{n}(4,:),'-*')
        hold on
    %end
end
grid on
title('\textbf{Iterative decoding BER C2 Non-Gray}', 'Interpreter', 'latex','FontSize',14) 
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('N = 1 iteration','N = 2 iterations','N = 3 iterations','N = 4 iterations','N = 5 iterations',...
    'N = 6 iterations','N = 7 iterations','N = 8 iterations','N = 9 iterations','N = 10 iterations','Location','southwest','Interpreter','latex');

%%
% C1 GRAY
figure
for n=1:nIter
    if n==1 || n==3 || n==6 || n==10 
        semilogy(EbNoVec,data_Iter{n}(1,:),'-*')
        hold on
    end
end
semilogy(EbNoVec,BER1Gray_s,'--*')
grid on
title('\textbf{Comparison Gray mapping C1}', 'Interpreter', 'latex','FontSize',14) 
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('N = 1 iteration','N = 3 iterations','N = 6 iterations','N = 10 iterations','Soft C1 Gray','Location','southwest','Interpreter','latex');

% C2 GRAY
figure
for n=1:nIter
    if n==1 || n==3 || n==6 || n==10 
        semilogy(EbNoVec,data_Iter{n}(2,:),'-*')
        hold on
    end
end
semilogy(EbNoVec,BER2Gray_s,'--*')
grid on
title('\textbf{Comparison Gray mapping C2}', 'Interpreter', 'latex','FontSize',14) 
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('N = 1 iteration','N = 3 iterations','N = 6 iterations','N = 10 iterations','Soft C2 Gray','Location','southwest','Interpreter','latex');

% C1 NON-GRAY
figure
for n=1:nIter
    if n==1 || n==3 || n==6 || n==10 
        semilogy(EbNoVec,data_Iter{n}(3,:),'-*')
        hold on
    end
end
semilogy(EbNoVec,BER1NonGray_s,'--*')
grid on
title('\textbf{Comparison Non-Gray mapping C1}', 'Interpreter', 'latex','FontSize',14) 
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('N = 1 iteration','N = 3 iterations','N = 6 iterations','N = 10 iterations','Soft C1 Non-Gray','Location','southwest','Interpreter','latex');

% C2 NON-GRAY
figure
for n=1:nIter
    if n==1 || n==3 || n==6 || n==10 
        semilogy(EbNoVec,data_Iter{n}(4,:),'-*')
        hold on
    end
end
semilogy(EbNoVec,BER2NonGray_s,'--*')
grid on
title('\textbf{Comparison Non-Gray mapping C2}', 'Interpreter', 'latex','FontSize',14) 
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('N = 1 iteration','N = 3 iterations','N = 6 iterations','N = 10 iterations','Soft C2 Non-Gray','Location','southwest','Interpreter','latex');

%%
% C1 GRAY && NON-GRAY
figure
for n=1:nIter
    if n==6
        semilogy(EbNoVec,data_Iter{n}(1,:),'-*')
        hold on
        semilogy(EbNoVec,data_Iter{n}(3,:),'-*')
    end
end
semilogy(EbNoVec,BER1Gray_s,'--*')
semilogy(EbNoVec,BER1NonGray_s,'--*')
grid on
title('\textbf{Comparison bit-mapping C1}', 'Interpreter', 'latex','FontSize',14) 
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('N = 6 iterations C1 Gray','N = 6 iterations C1 Non-Gray','Soft C1 Gray','Soft C1 Non-Gray','Location','southwest','Interpreter','latex');

% C2 GRAY && NON-GRAY
figure
for n=1:nIter
    if n==6
        semilogy(EbNoVec,data_Iter{n}(2,:),'-*')
        hold on
        semilogy(EbNoVec,data_Iter{n}(4,:),'-*')
    end
end
semilogy(EbNoVec,BER2Gray_s,'--*')
semilogy(EbNoVec,BER2NonGray_s,'--*')
grid on
title('\textbf{Comparison bit-mapping C2}', 'Interpreter', 'latex','FontSize',14) 
xlabel('$E_b/N_0$~(dB)','FontSize',14,'Interpreter','latex'), xlim([EbNoVec(1) 8])
ylabel('BER','FontSize',14,'Interpreter','latex'), ylim([1e-7 1])
legend('N = 6 iterations C1 Gray','N = 6 iterations C2 Non-Gray','Soft C2 Gray','Soft C2 Non-Gray','Location','southwest','Interpreter','latex');




