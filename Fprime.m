function [optf,optz]=Fprime(xa,pv,aggNo)

global Agg
n=length(xa);% Calculation of size for prosumption profile
%Decition variable z=[q;delta_in;delta_out;g01;g02;g03;g04;g05;g06;g07;g08;g09;g10;g11;g12;g13]
%q stands for PV curtail
%delata_in stands for charge power
%delta_out stands for discharge power
%g01 stands for Generating power of thermal power plant #1(Oil:A)
%g02 stands for Generating power of thermal power plant #2(Oil:B)
%g03 stands for Generating power of thermal power plant #3(Oil:C)
%g04 stands for Generating power of thermal power plant #4(LNG:A)
%g05 stands for Generating power of thermal power plant #5(LNG:B)
%g06 stands for Generating power of thermal power plant #6(LNG:C)
%g07 stands for Generating power of thermal power plant #7(LNGCC:A)
%g08 stands for Generating power of thermal power plant #8(LNGCC:B)
%g09 stands for Generating power of thermal power plant #9(LNGCC:C)
%g10 stands for Generating power of thermal power plant #10(Coal:A)
%g11 stands for Generating power of thermal power plant #11(Coal:B)
%g12 stands for Generating power of thermal power plant #12(Coal:C)
%g13 stands for Generating power of thermal power plant #13(Coal:D)

%**************************************************************************
%*** Read parameter from structure Agg ************************************
%**************************************************************************
%--- Load -----------------------------------------------------------------
la=Agg(aggNo).load;%Load
%--- Inverter capacity ----------------------------------------------------
agg_dy_out_min=0;%[GW] Min.discharge power
agg_dy_out_max=Agg(aggNo).dy_out_max; %[GW] Max.discharge power
agg_dy_in_min=0;%[GW] Min.charge power
agg_dy_in_max=Agg(aggNo).dy_in_max; %[GW] Max.charge power
%--- Battery capacity -----------------------------------------------------
agg_y_max=Agg(aggNo).y_max; %[GW*h] Max.SOC
agg_y_min=-agg_y_max;%[GW*h] Min.SOC
%--- C/D efficiency -------------------------------------------------------
agg_eta_out=Agg(aggNo).eta_out;%Discharge efficiency
agg_eta_in=Agg(aggNo).eta_in;%Charge efficiency
%--- PV curtail -----------------------------------------------------------
% Max.PV curtail & Min.PV curtail are set directly in Ain
%--- Output of thermal plant ----------------------------------------------
agg_g01_max=Agg(aggNo).g_max{1};%Max.output of thermal plant #1
agg_g01_min=Agg(aggNo).g_min{1};%Min.output of thermal plant #1
agg_g02_max=Agg(aggNo).g_max{2};%Max.output of thermal plant #2
agg_g02_min=Agg(aggNo).g_min{2};%Min.output of thermal plant #2
agg_g03_max=Agg(aggNo).g_max{3};%Max.output of thermal plant #3
agg_g03_min=Agg(aggNo).g_min{3};%Min.output of thermal plant #3

agg_g04_max=Agg(aggNo).g_max{4};%Max.output of thermal plant #4
agg_g04_min=Agg(aggNo).g_min{4};%Min.output of thermal plant #4
agg_g05_max=Agg(aggNo).g_max{5};%Max.output of thermal plant #5
agg_g05_min=Agg(aggNo).g_min{5};%Min.output of thermal plant #5
agg_g06_max=Agg(aggNo).g_max{6};%Max.output of thermal plant #6
agg_g06_min=Agg(aggNo).g_min{6};%Min.output of thermal plant #6

agg_g07_max=Agg(aggNo).g_max{7};%Max.output of thermal plant #7
agg_g07_min=Agg(aggNo).g_min{7};%Min.output of thermal plant #7
agg_g08_max=Agg(aggNo).g_max{8};%Max.output of thermal plant #8
agg_g08_min=Agg(aggNo).g_min{8};%Min.output of thermal plant #8
agg_g09_max=Agg(aggNo).g_max{9};%Max.output of thermal plant #9
agg_g09_min=Agg(aggNo).g_min{9};%Min.output of thermal plant #9

agg_g10_max=Agg(aggNo).g_max{10};%Max.output of thermal plant #10
agg_g10_min=Agg(aggNo).g_min{10};%Min.output of thermal plant #10
agg_g11_max=Agg(aggNo).g_max{11};%Max.output of thermal plant #11
agg_g11_min=Agg(aggNo).g_min{11};%Min.output of thermal plant #11
agg_g12_max=Agg(aggNo).g_max{12};%Max.output of thermal plant #12
agg_g12_min=Agg(aggNo).g_min{12};%Min.output of thermal plant #12

agg_g13_max=Agg(aggNo).g_max{13};%Max.output of thermal plant #13
agg_g13_min=Agg(aggNo).g_min{13};%Min.output of thermal plant #13

%**************************************************************************
%*** CVX ******************************************************************
%**************************************************************************
M=tril(ones(n));
c=[-1 zeros(1,n-2)];
r=[-1 1 zeros(1,n-2)];
D=[toeplitz(c,r);1 zeros(1,n-2) -1];
%--- Inequality constraint ------------------------------------------------
Ain=[ kron(ones(1,1),zeros(n))  1/agg_eta_in*eye(n) kron(ones(1,14),zeros(n));%Max.charge power
    kron(ones(1,1),zeros(n)) -1/agg_eta_in*eye(n) kron(ones(1,14),zeros(n));%Min.charge power
    kron(ones(1,2),zeros(n))   agg_eta_out*eye(n) kron(ones(1,13),zeros(n));%Max.disharge power
    kron(ones(1,2),zeros(n))  -agg_eta_out*eye(n) kron(ones(1,13),zeros(n));%Min.discharge power
    kron(ones(1,1),zeros(n))  M -M kron(ones(1,13),zeros(n));%Max.SOC
    kron(ones(1,1),zeros(n)) -M  M kron(ones(1,13),zeros(n));%Min.SOC
    eye(n) kron(ones(1,15),zeros(n));%Max.PV curtail
    -eye(n) kron(ones(1,15),zeros(n));%Min.PV curtail
    kron(ones(1, 3),zeros(n))  eye(n) kron(ones(1,12),zeros(n));%Max.output of thermal plant #1
    kron(ones(1, 3),zeros(n)) -eye(n) kron(ones(1,12),zeros(n));%Min.output of thermal plant #1
    kron(ones(1, 4),zeros(n))  eye(n) kron(ones(1,11),zeros(n));%Max.output of thermal plant #2
    kron(ones(1, 4),zeros(n)) -eye(n) kron(ones(1,11),zeros(n));%Min.output of thermal plant #2
    kron(ones(1, 5),zeros(n))  eye(n) kron(ones(1,10),zeros(n));%Max.output of thermal plant #3
    kron(ones(1, 5),zeros(n)) -eye(n) kron(ones(1,10),zeros(n));%Min.output of thermal plant #3
    kron(ones(1, 6),zeros(n))  eye(n) kron(ones(1, 9),zeros(n));%Max.output of thermal plant #4
    kron(ones(1, 6),zeros(n)) -eye(n) kron(ones(1, 9),zeros(n));%Min.output of thermal plant #4
    kron(ones(1, 7),zeros(n))  eye(n) kron(ones(1, 8),zeros(n));%Max.output of thermal plant #5
    kron(ones(1, 7),zeros(n)) -eye(n) kron(ones(1, 8),zeros(n));%Min.output of thermal plant #5
    kron(ones(1, 8),zeros(n))  eye(n) kron(ones(1, 7),zeros(n));%Max.output of thermal plant #6
    kron(ones(1, 8),zeros(n)) -eye(n) kron(ones(1, 7),zeros(n));%Min.output of thermal plant #6
    kron(ones(1, 9),zeros(n))  eye(n) kron(ones(1, 6),zeros(n));%Max.output of thermal plant #7
    kron(ones(1, 9),zeros(n)) -eye(n) kron(ones(1, 6),zeros(n));%Min.output of thermal plant #7
    kron(ones(1,10),zeros(n))  eye(n) kron(ones(1, 5),zeros(n));%Max.output of thermal plant #8
    kron(ones(1,10),zeros(n)) -eye(n) kron(ones(1, 5),zeros(n));%Min.output of thermal plant #8
    kron(ones(1,11),zeros(n))  eye(n) kron(ones(1, 4),zeros(n));%Max.output of thermal plant #9
    kron(ones(1,11),zeros(n)) -eye(n) kron(ones(1, 4),zeros(n));%Min.output of thermal plant #9
    kron(ones(1,12),zeros(n))  eye(n) kron(ones(1, 3),zeros(n));%Max.output of thermal plant #10
    kron(ones(1,12),zeros(n)) -eye(n) kron(ones(1, 3),zeros(n));%Min.output of thermal plant #10
    kron(ones(1,13),zeros(n))  eye(n) kron(ones(1, 2),zeros(n));%Max.output of thermal plant #11
    kron(ones(1,13),zeros(n)) -eye(n) kron(ones(1, 2),zeros(n));%Min.output of thermal plant #11
    kron(ones(1,14),zeros(n))  eye(n) kron(ones(1, 1),zeros(n));%Max.output of thermal plant #12
    kron(ones(1,14),zeros(n)) -eye(n) kron(ones(1, 1),zeros(n));%Min.output of thermal plant #12
    kron(ones(1,15),zeros(n))  eye(n)                          ;%Max.output of thermal plant #13
    kron(ones(1,15),zeros(n)) -eye(n)                          ;%Min.output of thermal plant #13
    kron(ones(1,11),zeros(n,n))  D kron(ones(1,4),zeros(n,n));%Ramp rate constraint for thermal plant #9
    kron(ones(1,11),zeros(n,n))  -D kron(ones(1,4),zeros(n,n))];%Ramp rate constraint for thermal plant #9
    %The above ramp rate constraint is introduced to obtain result quickly.
    % Even if there are no the above constraint, we can the same result.
Bin=[ agg_dy_in_max*ones(n,1);%Max.charge power
    -agg_dy_in_min*ones(n,1);%Min.charge power
    agg_dy_out_max*ones(n,1);%Max.disharge power
    -agg_dy_out_min*ones(n,1);%Min.discharge power
    agg_y_max*ones(n,1);%Max.SOC
    -agg_y_min*ones(n,1);%Min.SOC
    pv;%Max.PV curtail
    0*ones(n,1);%Min.PV curtail
    agg_g01_max*ones(n,1);%Max.output of thermal plant #1
    -agg_g01_min*ones(n,1);%Min.output of thermal plant #1
    agg_g02_max*ones(n,1);%Max.output of thermal plant #2
    -agg_g02_min*ones(n,1);%Min.output of thermal plant #2
    agg_g03_max*ones(n,1);%Max.output of thermal plant #3
    -agg_g03_min*ones(n,1);%Min.output of thermal plant #3
    agg_g04_max*ones(n,1);%Max.output of thermal plant #4
    -agg_g04_min*ones(n,1);%Min.output of thermal plant #4
    agg_g05_max*ones(n,1);%Max.output of thermal plant #5
    -agg_g05_min*ones(n,1);%Min.output of thermal plant #5
    agg_g06_max*ones(n,1);%Max.output of thermal plant #6
    -agg_g06_min*ones(n,1);%Min.output of thermal plant #6
    agg_g07_max*ones(n,1);%Max.output of thermal plant #7
    -agg_g07_min*ones(n,1);%Min.output of thermal plant #7
    agg_g08_max*ones(n,1);%Max.output of thermal plant #8
    -agg_g08_min*ones(n,1);%Min.output of thermal plant #8
    agg_g09_max*ones(n,1);%Max.output of thermal plant #9
    -agg_g09_min*ones(n,1);%Min.output of thermal plant #9
    agg_g10_max*ones(n,1);%Max.output of thermal plant #10
    -agg_g10_min*ones(n,1);%Min.output of thermal plant #10
    agg_g11_max*ones(n,1);%Max.output of thermal plant #11
    -agg_g11_min*ones(n,1);%Min.output of thermal plant #11
    agg_g12_max*ones(n,1);%Max.output of thermal plant #12
    -agg_g12_min*ones(n,1);%Min.output of thermal plant #12
    agg_g13_max*ones(n,1);%Max.output of thermal plant #13
    -agg_g13_min*ones(n,1);%Min.output of thermal plant #13
    0.5*8000*10^(-3)*ones(n,1);%Ramp rate constraint for thermal plant #9
    0.5*8000*10^(-3)*ones(n,1)];%Ramp rate constraint for thermal plant #9
    %The above ramp rate constraint is introduced to obtain result quickly.
    % Even if there are no the above constraint, we can the same result.
%--- Equality constraint --------------------------------------------------
R6=[1 -1  0  0  0  0;
    0  1 -1  0  0  0;
    0  0  1 -1  0  0;
    0  0  0  1 -1  0;
    0  0  0  0  1 -1];
tem=diag(ones(12,1))+diag(-ones(11,1),1);
R12=tem(1:11,:);
tem2=diag(ones(18,1),6)+diag(ones(6,1),-18);
Aeq=[eye(n) 1/agg_eta_in*eye(n) -agg_eta_out*eye(n) kron(ones(1,13),-eye(n));%Supply-demand balance constraint
    kron(ones(1,11),zeros(4*5,n)) kron(eye(24/6),R6) kron(ones(1,4),zeros(4*5,n));%Duration constraint for #9
    kron(ones(1,15),zeros(2*11,n)) kron(eye(24/12),R12)*tem2;%Duration constraint for #13
    kron(ones(1,13),zeros(2*11,n)) kron(eye(24/12),R12)*tem2 kron(ones(1,2),zeros(2*11,n));%Duration constraint for #11
    kron(ones(1,12),zeros(2*11,n)) kron(eye(24/12),R12)*tem2 kron(ones(1,3),zeros(2*11,n));%Duration constraint for #10
    kron(ones(1,14),zeros(2*11,n)) kron(eye(24/12),R12)*tem2 kron(ones(1,1),zeros(2*11,n))];%Duration constraint for #12
Beq=[-la-xa+pv;%Supply-demand balance constraint
    zeros(4*5,1);%Duration constraint for #9
    zeros(2*11,1);%Duration constraint for #13
    zeros(2*11,1);%Duration constraint for #11
    zeros(2*11,1);%Duration constraint for #10
    zeros(2*11,1)];%Duration constraint for #12
%*** Convex Optimization using CVX ****************************************
cvx_begin
variable z(n*16,1)% Decition variable, namely, prosumption profiles for an Agg.
% ---------------------------------------
minimize(object(z,aggNo))
% ---------------------------------------
subject to
Ain*z <= Bin;
Aeq*z == Beq;
% ---------------------------------------
% ---------------------------------------
cvx_end
% -------------------------------------------
%**************************************************************************
optz=z;
optf=object(optz,aggNo);%optf means cost
