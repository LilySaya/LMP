%**************************************************************************
%*** Header ***************************************************************
%**************************************************************************
clear;
close all;
clc
%run('/Users/judy/Documents/MATLAB/cvx/cvx_setup')%
% run('C:\Program Files\MATLAB\R2022a\cvx\cvx_setup')%
%run('C:\Program Files\MATLAB\R2015b\cvx\cvx_setup')%
%run('C:\Program Files\MATLAB\R2015b\cvx-w64\cvx\cvx_setup')%DesktopPC
%run('C:\Program Files\MATLAB\R2016a\cvx\cvx_setup')%crest-notePC error
%run('C:\Program Files\MATLAB\R2015b\cvx\cvx_setup')%crest-notePC
%run('C:\Program Files\MATLAB\R2007b\cvx\cvx_setup')%old notePC
global Agg
global TransmissionLine

tic
%**************************************************************************
%*** Select battery penetration level & PV level **************************
%**************************************************************************
% for PVlevel=1:2;
% for rate=10:5:100;
%for batterylevel=[0:5:100];
for batterylevel=50
%--- Important parameter
%--- You need to decide battry penetration level & to select PV level. ----
%batterylevel=0;%[%] battery penetration level,which must be selected from 0 to 100.
PVlevel=3;% It must be selected 1 or 2, 1:=PV_Low, 2:=PV_High

%--- Decision coefficient of PV level -------------------------------------
if PVlevel==1;
    PV_HorL=1;% PV_Low
elseif PVlevel==2;
    PV_HorL=3.9;% PV_High
elseif PVlevel==3;
    PV_HorL=3.9*2;% PV_High
else
    error('incorect PVlevel')
end
%**************************************************************************
%*** Read Input_data ******************************************************
%**************************************************************************
set_parameter% read input_data using mfile named "set_parameter.m"
n=length(Agg(1).load);% Calculation of size for load

H_reactance = diag(TransmissionLine.line_reactance)
% H_reactance = diag([0.00000001,0.00000001,0.00000001,0.00000001,0.00000001,0.00000001])
H = inv(H_reactance)

A = [1, -1, 0, 0, 0;
     0, 1, -1, 0, 0;
     0, 0, 1, -1, 0;
     0, 0, 1, 0, -1;
     0, 0, 0, -1, 1;
     -1, 0, 0, 1, 0]
X = H*A
B_susceptance = [H(1,1)+H(6,6), -H(1,1), 0, -H(6,6), 0;
                 -H(1,1), H(1,1)+H(2,2), -H(2,2), 0, 0;
                 0, -H(2,2), H(2,2)+H(3,3)+H(4,4), -H(3,3), -H(4,4);
                 -H(6,6), 0, -H(3,3), H(3,3)+H(5,5)+H(6,6), -H(5,5);
                 0, 0, -H(4,4), -H(5,5), +H(4,4)+H(5,5)]
B_susceptance_prime = B_susceptance(1:4,1:4)

T = X*[inv(B_susceptance_prime), zeros(4,1);zeros(1,4), 0]


[M,N] = size(T);
%M: number of brances
%N: number of buses
n = 24;
%n: number of timeslots
%**************************************************************************
%*** CVX ******************************************************************
%**************************************************************************
%--- Equality constraint --------------------------------------------------
% Aeq=kron(ones(1,11),eye(n));
% Beq=zeros(n,1);% which means summantion of all prosumption profiles equals to 0.
% E=eye(14*n);
% E1=[E(:,1:n) E(:,2*n+1:3*n)];
% E2=[E(:,1*n+1:2*n)  E(:,3*n+1:4*n)];
% E3=[E(:,4*n+1:5*n)  E(:,5*n+1:6*n)];
% E4=[E(:,6*n+1:7*n)  E(:,10*n+1:11*n)];
% E5=[E(:,7*n+1:8*n)  E(:,11*n+1:12*n)];
% E6=[E(:,8*n+1:9*n)  E(:,12*n+1:13*n)];
% E7=[E(:,9*n+1:10*n) E(:,13*n+1:14*n)];
% Aeq1=kron([1 1],eye(n))*E1';
% Aeq2=kron([1 1],eye(n))*E2';
% Aeq3=kron([1 1],eye(n))*E3';
% Aeq4=kron([1 1],eye(n))*E4';
% Aeq5=kron([1 1],eye(n))*E5';
% Aeq6=kron([1 1],eye(n))*E6';
% Aeq7=kron([1 1],eye(n))*E7';
% Beq1=zeros(n,1);
% Beq2=zeros(n,1);
% Beq3=zeros(n,1);
% Beq4=zeros(n,1);
% Beq5=zeros(n,1);
% Beq6=zeros(n,1);
% Beq7=zeros(n,1);
Aeq = kron(eye(n),ones(1,N));
Beq = zeros(n,1);
%--- 

%--- 送電容量[GW]
inp=[11.2;6.1;14.3;8.7;8;6.7];
yo=inp.^(-1);
B1=yo(1)/mean(yo)*6.7/8;
B2=3/8;
B3=yo(2)/mean(yo)*6.7/8;
B4=yo(3)/mean(yo)*6.7/8;
B5=yo(4)/mean(yo)*6.7/8;
B6=yo(5)/mean(yo)*6.7/8;
B7=yo(6)/mean(yo)*6.7/8;
B = [B1, B3, B4, B7, B5, B3];
% B = [5000, 2000, 3000, 2000, 40000, 8000];

base_matrix = diag(ones(1,n));
tmp1 = [T;-T];
T_max = kron(base_matrix,T);
T_min = kron(base_matrix,-T);
Ain = [T_max;T_min];

tmp2 = [B;-B];
Fmax = reshape(repmat(B',1,n),[],1);
Fmin = reshape(repmat(-B',1,n),[],1);
Bin = [Fmax;Fmax];
%if T is minus, Fmax is okay

% Ain=kron(eye(14),[eye(n);-eye(n)]);
% Bin=[B1*ones(2*n,1);
%      B2*ones(2*n,1);
%      B1*ones(2*n,1);
%      B2*ones(2*n,1);
%      B3*ones(2*n,1);
%      B3*ones(2*n,1);
%      B4*ones(2*n,1);
%      B5*ones(2*n,1);
%      B6*ones(2*n,1);
%      B7*ones(2*n,1);
%      B4*ones(2*n,1);
%      B5*ones(2*n,1);
%      B6*ones(2*n,1);
%      B7*ones(2*n,1)];

%--- Objective function ---------------------------------------------------
% SS='F(w(0*n+1:1*n,1),1)+F(w(1*n+1:2*n,1),2) ';
% for ii=3:11
%     SS_tem=sprintf('+F(w(%d*n+1:%d*n,1),%d)',ii-1,ii,ii);
%     SS=[SS SS_tem];% which means summantion of all F(x).
% end
%*** Convex Optimization using CVX ****************************************
cvx_begin
cvx_precision default

variable w(N*n,1)% Decition variable, namely, prosumption profiles for all Agg.
dual variable y
dual variable u

%{
minimize(F(  w(0*n+1:1*n,1)+w(1*n+1:2*n,1)  ,1)+...
         %%% (1:24) + (25:48)
         F(  w(2*n+1:3*n,1)+w(3*n+1:4*n,1)+w(4*n+1:5*n,1)   ,2)+...
         %%% (49:72) + (73:96) + (97:120)
         F(w(5*n+1:6*n,1)+w(6*n+1:7*n,1)+w(7*n+1:8*n,1)+w(8*n+1:9*n,1)+w(9*n+1:10*n,1),3)+...
         %%% Agg3 has 5  buses connected
         F(w(10*n+1:11*n,1)+w(11*n+1:12*n,1),4)+...
         %%% Agg4 has 2 buses connected
         F(w(12*n+1:13*n,1)+w(13*n+1:14*n,1),5))
         %%% Agg5 has 2 buses connected
%}
minimize(F(w(0*n+1:1*n,1),1) +...
         F(w(1*n+1:2*n,1),2) +...
         F(w(2*n+1:3*n,1),3) +...
         F(w(3*n+1:4*n,1),4) +...
         F(w(4*n+1:5*n,1),5) )
% ---------------------------------------
subject to
%y:[Aeq1;Aeq2;Aeq3;Aeq4;Aeq5;Aeq6;Aeq7]*w == [Beq1;Beq2;Beq3;Beq4;Beq5;Beq6;Beq7];
y:Aeq*w == Beq;
%y is system price for 24 time slots
u:Ain*w <= Bin;
%u is composed as [(u_hat;u_check)*24 time slots] (288x1)
cvx_end
% -------------------------------------------
%**************************************************************************
optx=w;% The optimal prosumption profiles for all Agg.
socialcost_i=cvx_optval%Social cost

%{
% for aggNo=1:11;
%     x_giv{aggNo}=optx((aggNo-1)*n+1:aggNo*n,1);% Prosumption profile for Agg.#aggNo
% end
%---
x_agg1_nodal1=optx(0*n+1:1*n,1);
x_agg1_nodal2=optx(1*n+1:2*n,1);
%---
x_agg2_nodal1=optx(2*n+1:3*n,1);
x_agg2_nodal2=optx(3*n+1:4*n,1);
x_agg2_nodal3=optx(4*n+1:5*n,1);
%---
x_agg3_nodal3=optx(5*n+1:6*n,1);
x_agg3_nodal4=optx(6*n+1:7*n,1);
x_agg3_nodal5=optx(7*n+1:8*n,1);
x_agg3_nodal6=optx(8*n+1:9*n,1);
x_agg3_nodal7=optx(9*n+1:10*n,1);
%---
x_agg4_nodal4=optx(10*n+1:11*n,1);
x_agg4_nodal5=optx(11*n+1:12*n,1);
%---
x_agg5_nodal6=optx(12*n+1:13*n,1);
x_agg5_nodal7=optx(13*n+1:14*n,1);
%---
%}
x_agg1_nodal1 = optx(0*n+1:1*n,1);
x_agg2_nodal2 = optx(1*n+1:2*n,1);
x_agg3_nodal3=optx(2*n+1:3*n,1);
x_agg4_nodal4=optx(3*n+1:4*n,1);
x_agg5_nodal5=optx(4*n+1:5*n,1);
%--- ここで総創電力をおいちゃう．
x_giv{1}=x_agg1_nodal1;
x_giv{2}=x_agg2_nodal2;
x_giv{3}=x_agg3_nodal3;
x_giv{4}=x_agg4_nodal4;
x_giv{5}=x_agg5_nodal5;

%{
lam1=y(0*n+1:1*n,1);% Clearing price
lam2=y(1*n+1:2*n,1);
lam3=y(2*n+1:3*n,1);
lam4=y(3*n+1:4*n,1);
lam5=y(4*n+1:5*n,1);
%}
lam=y(0*n+1:1*n,1); %System wide price
u_hat = u(0*n+1:1*n*M,1); %(144x1) 6brachesx24timeslots
congestion_price_max = (u_hat'*T_max)'; %(Bus1to5)x24timeslots (120x1)

%Split for each busx24timeslots
reshaped_cprice_max = reshape(congestion_price_max, 24, 5);
cprice_max1 = reshaped_cprice_max(:, 1); % First column (bus 1 values)
cprice_max2 = reshaped_cprice_max(:, 2); % Second column (bus 2 values)
cprice_max3 = reshaped_cprice_max(:, 3); % Third column (bus 3 values)
cprice_max4 = reshaped_cprice_max(:, 4); % Fourth column (bus 4 values)
cprice_max5 = reshaped_cprice_max(:, 5); % Fifth column (bus 5 values)

u_check = u(1*n*M+1:2*n*M,1);
congestion_price_min = (u_check'*T_max)';
reshaped_cprice_min = reshape(congestion_price_min, 24, 5);
cprice_min1 = reshaped_cprice_min(:, 1); % First column (bus 1 values)
cprice_min2 = reshaped_cprice_min(:, 2); % Second column (bus 2 values)
cprice_min3 = reshaped_cprice_min(:, 3); % Third column (bus 3 values)
cprice_min4 = reshaped_cprice_min(:, 4); % Fourth column (bus 4 values)
cprice_min5 = reshaped_cprice_min(:, 5); % Fifth column (bus 5 values)

% figure(200)
% plot(lam1,'b-');hold on;
% plot(lam2,'r-');
% plot(lam3,'g-');
% plot(lam4,'m-');
% plot(lam5,'c-');
% plot(lam6,'k-');
% plot(lam7,'k--')
% title('Price')
% legend('nodal1','nodal2','nodal3','nodal4','nodal5','nodal6','nodal7')
% figure(100)
% plot(x_agg1_nodal1+x_agg1_nodal2,'Linewidth',3,'Color',[0.87,0.49,0]);hold on;
% plot(x_agg2_nodal1+x_agg2_nodal2+x_agg2_nodal3,'Linewidth',3,'Color',[1,0.84,0]);
% plot(x_agg3_nodal3+x_agg3_nodal4+x_agg3_nodal5+x_agg3_nodal6+x_agg3_nodal7,...
%     'Linewidth',3,'Color',[0,0.45,0.74]);
% plot(x_agg4_nodal4+x_agg4_nodal5,'Linewidth',3,'Color',[0.35,0.2,0.33]);
% plot(x_agg5_nodal6+x_agg5_nodal7,'Linewidth',3,'Color',[0,0.5,0]);
% legend('Agg1','Agg2','Agg3','Agg4','Agg5')
% ylabel('[GW]')
% title('totale prosumption')
% figure
% plot(x_agg1_nodal1,'b-');hold on
% plot(x_agg1_nodal2,'r-')
% title('Each prosumption for agg1')
% ylabel('[GW]')
% legend('nodal1','nodal2')
% figure
% plot(x_agg2_nodal1,'b-');hold on
% plot(x_agg2_nodal2,'r-')
% plot(x_agg2_nodal3,'g-')
% title('Each prosumption for agg2')
% ylabel('[GW]')
% legend('nodal1','nodal2','nodal3')
% figure
% plot(x_agg3_nodal3,'g-');hold on
% plot(x_agg3_nodal4,'m-')
% plot(x_agg3_nodal5,'c-')
% plot(x_agg3_nodal6,'k-')
% plot(x_agg3_nodal7,'k--')
% title('Each prosumption for agg3')
% ylabel('[GW]')
% legend('nodal3','nodal4','nodal5','nodal6','nodal7')
% figure
% plot(x_agg4_nodal4,'m-');hold on;
% plot(x_agg4_nodal5,'c-')
% title('Each prosumption for agg4')
% ylabel('[GW]')
% legend('nodal4','nodal5')
% figure
% plot(x_agg5_nodal6,'k-');hold on;
% plot(x_agg5_nodal7,'k--')
% title('Each prosumption for agg5')
% ylabel('[GW]')
% legend('nodal6','nodal7')



%--- ノーダルごとの創電量（ここが0になってるはず）
% figure
% plot(x_agg1_nodal1+x_agg2_nodal1);

%**************************************************************************
%*** Profit for Agg.#1 ****************************************************
%**************************************************************************
%{
cost1=F(x_agg1_nodal1+x_agg1_nodal2,1);%Cost for Agg.#1
profit1=-cost1...
        +lam1'*x_agg1_nodal1...
        +lam2'*x_agg1_nodal2;%Profit for Agg.#1
%}
cost1=F(x_agg1_nodal1,1);%Cost for Agg.#1
profit1=-cost1...
        +lam'*x_agg1_nodal1-...
        cprice_max1+...
        cprice_min1;%Profit for Agg.#1
%**************************************************************************
%*** Profit for Agg.#2 ****************************************************
%**************************************************************************
%{
cost2=F(x_agg2_nodal1+x_agg2_nodal2+x_agg2_nodal3,2);%Cost for Agg.#2
profit2=-cost2...
        +lam1'*x_agg2_nodal1...
        +lam2'*x_agg2_nodal2...
        +lam3'*x_agg2_nodal3;%Profit for Agg.#2
%}
cost2=F(x_agg2_nodal2,2);%Cost for Agg.#2
profit2=-cost2...
        +lam'*x_agg2_nodal2-...
        cprice_max2+...
        cprice_min2;%Profit for Agg.#2
%**************************************************************************
%*** Profit for Agg.#3 ****************************************************
%**************************************************************************
%{
cost3=F(x_agg3_nodal3+x_agg3_nodal4+x_agg3_nodal5+x_agg3_nodal6+x_agg3_nodal7,3);%Cost for Agg.#3
profit3=-cost3...
        +lam3'*x_agg3_nodal3...
        +lam4'*x_agg3_nodal4...
        +lam5'*x_agg3_nodal5...
        +lam6'*x_agg3_nodal6...
        +lam7'*x_agg3_nodal7;%Profit for Agg.#3
%}
cost3=F(x_agg3_nodal3,3);%Cost for Agg.#3
profit3=-cost3...
        +lam'*x_agg3_nodal3-...
        cprice_max3+...
        cprice_min3;%Profit for Agg.#3
%**************************************************************************
%*** Profit for Agg.#4 ****************************************************
%**************************************************************************
%{
cost4=F(x_agg4_nodal4+x_agg4_nodal5,4);%Cost for Agg.#4
profit4=-cost4...
        +lam4'*x_agg4_nodal4...
        +lam5'*x_agg4_nodal5;%Profit for Agg.#4
%}
cost4=F(x_agg4_nodal4,4);%Cost for Agg.#4
profit4=-cost4...
        +lam'*x_agg4_nodal4-...
        cprice_max4+...
        cprice_min4;%Profit for Agg.#4
%**************************************************************************
%*** Profit for Agg.#5 ****************************************************
%**************************************************************************
%{
cost5=F(x_agg5_nodal6+x_agg5_nodal7,5);%Cost for Agg.#5
profit5=-cost5...
        +lam6'*x_agg5_nodal6...
        +lam7'*x_agg5_nodal7;%Profit for Agg.#5
%}
cost5=F(x_agg5_nodal5,5);%Cost for Agg.#5
profit5=-cost5...
        +lam'*x_agg5_nodal5-...
        cprice_max5+...
        cprice_min5;%Profit for Agg.#5
%**************************************************************************
%*** Calculation of Scenarios for Agg.#1 to #10 ***************************
%**************************************************************************
%--------------------------------------------------------------------------
for aggNo=1:5;
    M=tril(ones(n));
    %--- Set to initial values --------------------------------------------
    delta_m{aggNo}=zeros(n,1);%(initial)Average C/D power coresponding to Agg.#aggNo
    q_m{aggNo}=zeros(n,1);%(initial)Average PV curtail coresponding to Agg.#aggNo
    g01_m{aggNo}=zeros(n,1);
    g02_m{aggNo}=zeros(n,1);
    g03_m{aggNo}=zeros(n,1);
    g04_m{aggNo}=zeros(n,1);
    g05_m{aggNo}=zeros(n,1);
    g06_m{aggNo}=zeros(n,1);
    g07_m{aggNo}=zeros(n,1);
    g08_m{aggNo}=zeros(n,1);
    g09_m{aggNo}=zeros(n,1);
    g10_m{aggNo}=zeros(n,1);
    g11_m{aggNo}=zeros(n,1);
    g12_m{aggNo}=zeros(n,1);
    g13_m{aggNo}=zeros(n,1);
    %----------------------------------------------------------------------
    for ii=1:10;%Calculation of PV curtail, C/D power, and SOC for scenario.#ii
        [optf,optz]=Fprime(x_giv{aggNo},Agg(aggNo).hpv{ii},aggNo);
        q{aggNo}{ii}=optz(1:n);%PV curtail profile for scenario#ii
        delta_in{aggNo}{ii}=optz(n+1:2*n);%Charge power profile for scenario#ii
        delta_out{aggNo}{ii}=optz(2*n+1:3*n);%Discharge power profile for scenario#ii
        delta{aggNo}{ii}=Agg(aggNo).eta_out*delta_out{aggNo}{ii}-1/Agg(aggNo).eta_in*delta_in{aggNo}{ii};%C/D power profile for scenario#ii
        yaa{aggNo}{ii}=-M*(delta_out{aggNo}{ii}-delta_in{aggNo}{ii});%SOC profile for scenario#ii
        g01{aggNo}{ii}=optz(3*n+1:4*n);%Generating power of thermal power plant #1(Oil:A)
        g02{aggNo}{ii}=optz(4*n+1:5*n);%Generating power of thermal power plant #2(Oil:B)
        g03{aggNo}{ii}=optz(5*n+1:6*n);%Generating power of thermal power plant #3(Oil:C)
        g04{aggNo}{ii}=optz(6*n+1:7*n);%Generating power of thermal power plant #4(LNG:A)
        g05{aggNo}{ii}=optz(7*n+1:8*n);%Generating power of thermal power plant #5(LNG:B)
        g06{aggNo}{ii}=optz(8*n+1:9*n);%Generating power of thermal power plant #6(LNG:C)
        g07{aggNo}{ii}=optz(9*n+1:10*n);%Generating power of thermal power plant #7(LNGCC:A)
        g08{aggNo}{ii}=optz(10*n+1:11*n);%Generating power of thermal power plant #8(LNGCC:B)
        g09{aggNo}{ii}=optz(11*n+1:12*n);%Generating power of thermal power plant #9(LNGCC:C)
        g10{aggNo}{ii}=optz(12*n+1:13*n);%Generating power of thermal power plant #10(Coal:A)
        g11{aggNo}{ii}=optz(13*n+1:14*n);%Generating power of thermal power plant #11(Coal:B)
        g12{aggNo}{ii}=optz(14*n+1:15*n);%Generating power of thermal power plant #12(Coal:C)
        g13{aggNo}{ii}=optz(15*n+1:16*n);%Generating power of thermal power plant #13(Coal:D)
        %------------------------------------------------------------------
        delta_m{aggNo}=delta_m{aggNo}+delta{aggNo}{ii};
        q_m{aggNo}=q_m{aggNo}+q{aggNo}{ii}; 
        g01_m{aggNo}=g01_m{aggNo}+g01{aggNo}{ii};
        g02_m{aggNo}=g02_m{aggNo}+g02{aggNo}{ii};
        g03_m{aggNo}=g03_m{aggNo}+g03{aggNo}{ii};
        g04_m{aggNo}=g04_m{aggNo}+g04{aggNo}{ii};
        g05_m{aggNo}=g05_m{aggNo}+g05{aggNo}{ii};
        g06_m{aggNo}=g06_m{aggNo}+g06{aggNo}{ii};
        g07_m{aggNo}=g07_m{aggNo}+g07{aggNo}{ii};
        g08_m{aggNo}=g08_m{aggNo}+g08{aggNo}{ii};
        g09_m{aggNo}=g09_m{aggNo}+g09{aggNo}{ii};
        g10_m{aggNo}=g10_m{aggNo}+g10{aggNo}{ii};
        g11_m{aggNo}=g11_m{aggNo}+g11{aggNo}{ii};
        g12_m{aggNo}=g12_m{aggNo}+g12{aggNo}{ii};
        g13_m{aggNo}=g13_m{aggNo}+g13{aggNo}{ii};
        %------------------------------------------------------------------
        
    end
    %----------------------------------------------------------------------
    delta_m{aggNo}=delta_m{aggNo}/10;%Average C/D power coresponding to Agg.#aggNo
    q_m{aggNo}=q_m{aggNo}/10;%Average PV curtail coresponding to Agg.#aggNo
    g01_m{aggNo}=g01_m{aggNo}/10;
    g02_m{aggNo}=g02_m{aggNo}/10;
    g03_m{aggNo}=g03_m{aggNo}/10;
    g04_m{aggNo}=g04_m{aggNo}/10;
    g05_m{aggNo}=g05_m{aggNo}/10;
    g06_m{aggNo}=g06_m{aggNo}/10;
    g07_m{aggNo}=g07_m{aggNo}/10;
    g08_m{aggNo}=g08_m{aggNo}/10;
    g09_m{aggNo}=g09_m{aggNo}/10;
    g10_m{aggNo}=g10_m{aggNo}/10;
    g11_m{aggNo}=g11_m{aggNo}/10;
    g12_m{aggNo}=g12_m{aggNo}/10;
    g13_m{aggNo}=g13_m{aggNo}/10;

    %----------------------------------------------------------------------
end


save(sprintf('data_output_PVlevel%d_Batterylevel%d_LMP.mat',PVlevel,batterylevel),...
    'x_agg1_nodal1','x_agg2_nodal2','x_agg3_nodal3','x_agg4_nodal4','x_agg5_nodal5',...
    'x_giv',... %セル
    'lam',...
    'u_hat',...
    'reshaped_cprice_max',...
    'cprice_max1','cprice_max2','cprice_max3','cprice_max4','cprice_max5',...
    'u_check',...
    'reshaped_cprice_min',...
    'cprice_min1','cprice_min2','cprice_min3','cprice_min4','cprice_min5',...
    'cost1','cost2','cost3','cost4','cost5',...
    'profit1','profit2','profit3','profit4','profit5',...
    'q','delta_in','delta_out','delta','yaa',...%セル
    'g01','g02','g03','g04','g05','g06','g07','g08','g09','g10','g11','g12','g13',...%セル
    'q_m','delta_m',...%セル
    'g01_m','g02_m','g03_m','g04_m','g05_m','g06_m','g07_m','g08_m','g09_m','g10_m','g11_m','g12_m','g13_m',...%セル
    'socialcost_i','B1','B2','B3','B4','B5','B6','B7');
toc
end
xxxxxxxxxxx
    % 'lam1','lam2','lam3','lam4','lam5','lam6','lam7',...

% %--- Save data of Agg.#1 (Prosumption, PV curtail, C/D power, SOC) --------
% AAA_label={'Prosumption',...
%     'PVcurtail_Sce1','PVcurtail_Sce2','PVcurtail_Sce3','PVcurtail_Sce4','PVcurtail_Sce5',...
%     'PVcurtail_Sce6','PVcurtail_Sce7','PVcurtail_Sce8','PVcurtail_Sce9','PVcurtail_Sce10',...
%     'CDharge_Sce1','CDharge_Sce2','CDharge_Sce3','CDharge_Sce4','CDharge_Sce5',...
%     'CDharge_Sce6','CDharge_Sce7','CDharge_Sce8','CDharge_Sce9','CDharge_Sce10',...
%     'SOC_Sce1','SOC_Sce2','SOC_Sce3','SOC_Sce4','SOC_Sce5',...
%     'SOC_Sce6','SOC_Sce7','SOC_Sce8','SOC_Sce9','SOC_Sce10'};
% AAA_data=[x_giv{1},q{1}{1},q{1}{2},q{1}{3},q{1}{4},q{1}{5},...
%     q{1}{6},q{1}{7},q{1}{8},q{1}{9},q{1}{10},...
%     delta{1}{1},delta{1}{2},delta{1}{3},delta{1}{4},delta{1}{5},...
%     delta{1}{6},delta{1}{7},delta{1}{8},delta{1}{9},delta{1}{10},...
%     yaa{1}{1},yaa{1}{2},yaa{1}{3},yaa{1}{4},yaa{1}{5},...
%     yaa{1}{6},yaa{1}{7},yaa{1}{8},yaa{1}{9},yaa{1}{10}];
% xlswrite(sprintf('data_output_PVlevel%d_Batterylevel%d.xlsx', PVlevel,batterylevel),AAA_label,1,'B2:AF2');
% xlswrite(sprintf('data_output_PVlevel%d_Batterylevel%d.xlsx', PVlevel,batterylevel),AAA_data,1,'B3:AF26');
% %--- Save data of summantion of all DER Agg (Average PV curtail, Average C/D power)
% BBB_label={'PVcurtail_mean','CDharge_mean'};
% BBB_data=[q_mT,delta_mT];
% xlswrite(sprintf('data_output_PVlevel%d_Batterylevel%d.xlsx', PVlevel,batterylevel),BBB_label,2,'B2:C2');
% xlswrite(sprintf('data_output_PVlevel%d_Batterylevel%d.xlsx', PVlevel,batterylevel),BBB_data,2,'B3:C26');
% 
% 
% %**************************************************************************
% %*** Calculation of Scenarios for Agg.#11 *********************************
% %**************************************************************************
% % aggNo=1;
% % for ii=1;
% %     [optf,optz]=Fprime(x_giv{aggNo},Agg(aggNo).hpv{ii},aggNo);
% %     g01=optz(3*n+1:4*n);%Generating power of thermal power plant #1(Oil:A)
% %     g02=optz(4*n+1:5*n);%Generating power of thermal power plant #2(Oil:B)
% %     g03=optz(5*n+1:6*n);%Generating power of thermal power plant #3(Oil:C)
% %     g04=optz(6*n+1:7*n);%Generating power of thermal power plant #4(LNG:A)
% %     g05=optz(7*n+1:8*n);%Generating power of thermal power plant #5(LNG:B)
% %     g06=optz(8*n+1:9*n);%Generating power of thermal power plant #6(LNG:C)
% %     g07=optz(9*n+1:10*n);%Generating power of thermal power plant #7(LNGCC:A)
% %     g08=optz(10*n+1:11*n);%Generating power of thermal power plant #8(LNGCC:B)
% %     g09=optz(11*n+1:12*n);%Generating power of thermal power plant #9(LNGCC:C)
% %     g10=optz(12*n+1:13*n);%Generating power of thermal power plant #10(Coal:A)
% %     g11=optz(13*n+1:14*n);%Generating power of thermal power plant #11(Coal:B)
% %     g12=optz(14*n+1:15*n);%Generating power of thermal power plant #12(Coal:C)
% %     g13=optz(15*n+1:16*n);%Generating power of thermal power plant #13(Coal:D)
% % end
% %--- Save data of Agg.#11 (Generating power of thermal power plant, price) 
% CCC_label={'g01','g02','g03','g04','g05',...
%     'g06','g07','g08','g09','g10',...
%     'g11','g12','g13','price'};
% CCC_data=[g01,g02,g03,g04,g05,...
%     g06,g07,g08,g09,g10,...
%     g11,g12,g13,lam1];
% xlswrite(sprintf('data_output_PVlevel%d_Batterylevel%d.xlsx', PVlevel, batterylevel),CCC_label,3,'B2:O2');
% xlswrite(sprintf('data_output_PVlevel%d_Batterylevel%d.xlsx', PVlevel, batterylevel),CCC_data,3,'B3:O26');
% %--- Save data of Social cost ---------------------------------------------
% EEE_label={'Social_cost'};
% EEE_data=socialcost_i;
% xlswrite(sprintf('data_output_PVlevel%d_Batterylevel%d.xlsx', PVlevel, batterylevel),EEE_label,3,'P2:P2');
% xlswrite(sprintf('data_output_PVlevel%d_Batterylevel%d.xlsx', PVlevel, batterylevel),EEE_data,3,'P3:P3');
% 
% % end
% % end

