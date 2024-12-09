function f=object(z,aggNo)
global Agg

n=length(z)/16; % Calculation of size for prosumption profile
%Decition variable z=[q;delta_in;delta_out;g01;g02;g03;g04;g05;g06;g07;g08;g09;g10;g11;g12;g13]
%q stands for PV curtail
%delata_in stands for charge power
%delta_out stands for discharge power
%g01 stands for generating power of thermal power plant #1(Oil:A)
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

%q=z(0*n+1:1*n,1);%PV curtail
delta_in =z(1*n+1:2*n,1);%charge power
delta_out=z(2*n+1:3*n,1);%discharge power
g01=z(3*n+1:4*n,1);%generating power of thermal power plant #1
g02=z(4*n+1:5*n,1);%generating power of thermal power plant #2
g03=z(5*n+1:6*n,1);%generating power of thermal power plant #3
g04=z(6*n+1:7*n,1);%generating power of thermal power plant #4
g05=z(7*n+1:8*n,1);%generating power of thermal power plant #5
g06=z(8*n+1:9*n,1);%generating power of thermal power plant #6
g07=z(9*n+1:10*n,1);%generating power of thermal power plant #7
g08=z(10*n+1:11*n,1);%generating power of thermal power plant #8
g09=z(11*n+1:12*n,1);%generating power of thermal power plant #9
g10=z(12*n+1:13*n,1);%generating power of thermal power plant #10
g11=z(13*n+1:14*n,1);%generating power of thermal power plant #11
g12=z(14*n+1:15*n,1);%generating power of thermal power plant #12
g13=z(15*n+1:16*n,1);%generating power of thermal power plant #13
%--- Fuel cost ------------------------------------------------------------
cost_f01=Agg(aggNo).cost_f{1};%Fuel cost of thermal plant #1
cost_f02=Agg(aggNo).cost_f{2};%Fuel cost of thermal plant #2
cost_f03=Agg(aggNo).cost_f{3};%Fuel cost of thermal plant #3
cost_f04=Agg(aggNo).cost_f{4};%Fuel cost of thermal plant #4
cost_f05=Agg(aggNo).cost_f{5};%Fuel cost of thermal plant #5
cost_f06=Agg(aggNo).cost_f{6};%Fuel cost of thermal plant #6
cost_f07=Agg(aggNo).cost_f{7};%Fuel cost of thermal plant #7
cost_f08=Agg(aggNo).cost_f{8};%Fuel cost of thermal plant #8
cost_f09=Agg(aggNo).cost_f{9};%Fuel cost of thermal plant #9
cost_f10=Agg(aggNo).cost_f{10};%Fuel cost of thermal plant #10
cost_f11=Agg(aggNo).cost_f{11};%Fuel cost of thermal plant #11
cost_f12=Agg(aggNo).cost_f{12};%Fuel cost of thermal plant #12
cost_f13=Agg(aggNo).cost_f{13};%Fuel cost of thermal plant #13
%--- G(g) in Eq.(14) ------------------------------------------------------
% Ma stands for G(g) in Eq.(14).
Ma =cost_f01*ones(n,1)'*g01+...
    cost_f02*ones(n,1)'*g02+...
    cost_f03*ones(n,1)'*g03+...
    cost_f04*ones(n,1)'*g04+...
    cost_f05*ones(n,1)'*g05+...
    cost_f06*ones(n,1)'*g06+...
    cost_f07*ones(n,1)'*g07+...
    cost_f08*ones(n,1)'*g08+...
    cost_f09*ones(n,1)'*g09+...
    cost_f10*ones(n,1)'*g10+...
    cost_f11*ones(n,1)'*g11+...
    cost_f12*ones(n,1)'*g12+...
    cost_f13*ones(n,1)'*g13;
%--- -D_\alpha(\delta_\alpha) in paper ------------------------------------
sa=ones(n,1)'*(delta_in-delta_out);% s_\alpha^{\rm fin}
sl=Agg(aggNo).a;
%sl=[11 8 4 1];%[MJPY/GWh]
x0=Agg(aggNo).y_max/4;
Sa=min([sl(1)*(sa+x0)-sl(2)*x0,sl(2)*sa,sl(3)*sa,sl(4)*(sa-x0)+sl(3)*x0]);
% Sa means d(s) in paper.
f=Ma-Sa; %f means cost.

