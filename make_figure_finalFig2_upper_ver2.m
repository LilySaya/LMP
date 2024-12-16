%**************************************************************************
%*** Header ***************************************************************
%**************************************************************************
clear;
clear Agg Gen
close all;
clc
set(0,'defaultAxesFontSize',12);
set(0,'defaultAxesFontName','century');
set(0,'defaultTextFontSize',12);
set(0,'defaultTextFontName','century');

%**************************************************************************
%*** Plot Fig.1(a1),(a2),(a3) *********************************************
%**************************************************************************
%--- Read data_output -----------------------------------------------------
batterylevel=25;%[%] battery penetration level
PVlevel=1;%  1:=PV_Low
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
%--------------------------------------------------------------------------
set_parameter
% load(sprintf('data_output_PVlevel%d_Batterylevel%d.mat',PVlevel,batterylevel),...
%     'x_agg1_nodal1','x_agg1_nodal2',...
%     'x_agg2_nodal1','x_agg2_nodal2','x_agg2_nodal3',...
%     'x_agg3_nodal3','x_agg3_nodal4','x_agg3_nodal5','x_agg3_nodal6','x_agg3_nodal7',...
%     'x_agg4_nodal4','x_agg4_nodal5',...
%     'x_agg5_nodal6','x_agg5_nodal7',...
%     'x_giv',... %セル
%     'lam1','lam2','lam3','lam4','lam5','lam6','lam7',...
%     'cost1','cost2','cost3','cost4','cost5',...
%     'profit1','profit2','profit3','profit4','profit5',...
%     'q','delta_in','delta_out','delta','yaa',...%セル
%     'g01','g02','g03','g04','g05','g06','g07','g08','g09','g10','g11','g12','g13',...%セル
%     'q_m','delta_m',...%セル
%     'g01_m','g02_m','g03_m','g04_m','g05_m','g06_m','g07_m','g08_m','g09_m','g10_m','g11_m','g12_m','g13_m',...%セル
%     'socialcost_i','B1','B2','B3','B4','B5','B6','B7');

load(sprintf('data_output_PVlevel%d_Batterylevel%d_LMP.mat',PVlevel,batterylevel),...
    'x_agg1_nodal1','x_agg2_nodal2',...
    'x_agg3_nodal3','x_agg4_nodal4','x_agg5_nodal5',...
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

figure(32);
% width  = 550;
% height = 450;
width  = 600;
height = 300;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
set(gca,'Fontname','Times','FontSize',18)
% aggNo=3;%●●●
% %--- Read data of Agg.#i (Prosumption, PV curtail, C/D power, SOC) --------
n=24;

%**************************************************************************
%*** Plot Fig.2(a1),(a2),(a3) *********************************************
%**************************************************************************
%--- 各火力機の総発電量 ---
g01T=g01_m{1}+g01_m{2}+g01_m{3}+g01_m{4}+g01_m{5};
g02T=g02_m{1}+g02_m{2}+g02_m{3}+g02_m{4}+g02_m{5};
g03T=g03_m{1}+g03_m{2}+g03_m{3}+g03_m{4}+g03_m{5};
g04T=g04_m{1}+g04_m{2}+g04_m{3}+g04_m{4}+g04_m{5};
g05T=g05_m{1}+g05_m{2}+g05_m{3}+g05_m{4}+g05_m{5};
g06T=g06_m{1}+g06_m{2}+g06_m{3}+g06_m{4}+g06_m{5};
g07T=g07_m{1}+g07_m{2}+g07_m{3}+g07_m{4}+g07_m{5};
g08T=g08_m{1}+g08_m{2}+g08_m{3}+g08_m{4}+g08_m{5};
g09T=g09_m{1}+g09_m{2}+g09_m{3}+g09_m{4}+g09_m{5};
g10T=g10_m{1}+g10_m{2}+g10_m{3}+g10_m{4}+g10_m{5};
g11T=g11_m{1}+g11_m{2}+g11_m{3}+g11_m{4}+g11_m{5};
g12T=g12_m{1}+g12_m{2}+g12_m{3}+g12_m{4}+g12_m{5};
g13T=g13_m{1}+g13_m{2}+g13_m{3}+g13_m{4}+g13_m{5};

%-------------------------
figure(31); hold on; grid on; box on;
%title(sprintf('PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
plot(1:n,g01T);
plot(1:n,g02T);
plot(1:n,g03T);
plot(1:n,g04T);
plot(1:n,g05T);
plot(1:n,g06T);
plot(1:n,g07T);
plot(1:n,g08T);
plot(1:n,g09T);
plot(1:n,g10T);
plot(1:n,g11T);
plot(1:n,g12T);
plot(1:n,g13T);
legend('g01','g02','g03','g04','g05','g06','g07','g08','g09','g10','g11','g12','g13')

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--- Coal -----------------------------------------------------------------
G0=zeros(n,1);
G1=g12T;
G2=G1+g11T;
G3=G2+g10T;
G4=G3+g13T;
%--- LNGCC ----------------------------------------------------------------
G5=G4+g09T;
G6=G5+g07T;
G7=G6+g08T;
%--- LNG ------------------------------------------------------------------
G8=G7+g05T;
G9=G8+g04T;
G10=G9+g06T;
%--- Oil ------------------------------------------------------------------
G11=G10+g02T;
G12=G11+g03T;
G13=G12+g01T;
%--------------------------------------------------------------------------
figure(32); hold on; grid on; box on;
%title(sprintf('Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
T=[1:n fliplr([1:n])];
V=[G0' fliplr(G4')];
fill(T,V,[0.8 0 0])
%--------------------------------------------------------------------------
V=[G4' fliplr(G7')];
fill(T,V,[0.9 0.4 0.4])
%--------------------------------------------------------------------------
if sum(abs(G7-G10))>=1e-2;
V=[G7' fliplr(G10')];
fill(T,V,[1 0.7 0.7])
end
%--------------------------------------------------------------------------
plot(1:n,G0,'k-','Linewidth',2)
plot(1:n,G1,'k--','Linewidth',1)
plot(1:n,G2,'k--','Linewidth',1)
plot(1:n,G3,'k--','Linewidth',1)
plot(1:n,G4,'k-','Linewidth',2)
plot(1:n,G5,'k--','Linewidth',1)
plot(1:n,G6,'k--','Linewidth',1)
plot(1:n,G7,'k-','Linewidth',2)
plot(1:n,G8,'k--','Linewidth',1)
plot(1:n,G9,'k--','Linewidth',1)
plot(1:n,G10,'k-','Linewidth',2)
plot(1:n,G11,'k--','Linewidth',1)
plot(1:n,G12,'k--','Linewidth',1)
plot(1:n,G13,'k-','Linewidth',2)
xlabel('Time [h]','Fontname','Times','FontSize',18);
ylabel('power [GW]','Fontname','Times','FontSize',18);
axis([0 25 -10 60])
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% CCC_data=xlsread('data_output_PVlevel2_Batterylevel50',3,'B3:O26');
% BBB_data=xlsread('data_output_PVlevel2_Batterylevel50',2,'B3:C26');
% g01=CCC_data(:,1);%Generating power of thermal power plant #1(Oil:A)
% g02=CCC_data(:,2);%Generating power of thermal power plant #2(Oil:B)
% g03=CCC_data(:,3);%Generating power of thermal power plant #3(Oil:C)
% g04=CCC_data(:,4);%Generating power of thermal power plant #4(LNG:A)
% g05=CCC_data(:,5);%Generating power of thermal power plant #5(LNG:B)
% g06=CCC_data(:,6);%Generating power of thermal power plant #6(LNG:C)
% g07=CCC_data(:,7);%Generating power of thermal power plant #7(LNGCC:A)
% g08=CCC_data(:,8);%Generating power of thermal power plant #8(LNGCC:B)
% g09=CCC_data(:,9);%Generating power of thermal power plant #9(LNGCC:C)
% g10=CCC_data(:,10);%Generating power of thermal power plant #10(Coal:A)
% g11=CCC_data(:,11);%Generating power of thermal power plant #11(Coal:B)
% g12=CCC_data(:,12);%Generating power of thermal power plant #12(Coal:C)
% g13=CCC_data(:,13);%Generating power of thermal power plant #13(Coal:D)
%--- summantion load of all DER Agg ---------------------------------------
% loadT= xlsread('data_input',1,'C3:C26')+...
%        xlsread('data_input',2,'C3:C26')+...
%        xlsread('data_input',3,'C3:C26')+...
%        xlsread('data_input',4,'C3:C26')+...
%        xlsread('data_input',5,'C3:C26')+...
%        xlsread('data_input',6,'C3:C26')+...
%        xlsread('data_input',7,'C3:C26')+...
%        xlsread('data_input',8,'C3:C26')+...
%        xlsread('data_input',9,'C3:C26')+...
%        xlsread('data_input',10,'C3:C26');
loadT=Agg(1).load+Agg(2).load+Agg(3).load+Agg(4).load+Agg(5).load;

%--- Set to initial values ------------------------------------------------
hpv_mT=zeros(24,1);%(initial)Average PV coresponding to summantion of all DER Agg.
for aggNo=1:5
% hpv=xlsread('data_input',aggNo,'D3:M26');%PV scenario 
% hpv=Agg(aggNo).hpv{ii}
hpv_m=zeros(24,1);
for ii=1:10;%Calculation of PV for scenario.#ii
%hpv_m=hpv_m+hpv(:,ii);
hpv_m=hpv_m+Agg(aggNo).hpv{ii};
end
hpv_m=hpv_m/10;%Average PV scenario coresponding to Agg.#aggNo
hpv_mT=hpv_mT+hpv_m;%Average PV coresponding to summantion of all DER Agg.
end
%hpv_mT=hpv_mT*PV_HorL;%Average PV coresponding to summantion of all DER Agg.
%q_mT=BBB_data(:,1);%Average PV curtail coresponding to summantion of all DER Agg.
q_mT=q_m{1}+q_m{2}+q_m{3}+q_m{4}+q_m{5};
%delta_mT=BBB_data(:,2);%Average C/D power coresponding to summantion of all DER Agg. 
delta_mT=delta_m{1}+delta_m{2}+delta_m{3}+delta_m{4}+delta_m{5};
%--- Coa+ -----------------------------------------------------------------
% G0=zeros(n,1);
% G1=g12;
% G2=G1+g11;
% G3=G2+g10;
% G4=G3+g13;
% %--- LNGCC ----------------------------------------------------------------
% G5=G4+g09;
% G6=G5+g07;
% G7=G6+g08;
% %--- LNG ------------------------------------------------------------------
% G8=G7+g05;
% G9=G8+g04;
% G10=G9+g06;
% %--- Oil ------------------------------------------------------------------
% G11=G10+g02;
% G12=G11+g03;
% G13=G12+g01;
% %--------------------------------------------------------------------------
% figure(33); hold on; grid on; box on;
% T=[1:n fliplr([1:n])];
% V=[G0' fliplr(G4')];
% fill(T,V,[0.8 0 0])
% %--------------------------------------------------------------------------
% V=[G4' fliplr(G7')];
% fill(T,V,[0.9 0.4 0.4])
% %--------------------------------------------------------------------------
% if sum(abs(G7-G10))>=1e-2;
% V=[G7' fliplr(G10')];
% fill(T,V,[1 0.7 0.7])
% end
% %--------------------------------------------------------------------------
% plot(1:n,G0,'k-','Linewidth',2)
% plot(1:n,G1,'k--','Linewidth',1)
% plot(1:n,G2,'k--','Linewidth',1)
% plot(1:n,G3,'k--','Linewidth',1)
% plot(1:n,G4,'k-','Linewidth',2)
% plot(1:n,G5,'k--','Linewidth',1)
% plot(1:n,G6,'k--','Linewidth',1)
% plot(1:n,G7,'k-','Linewidth',2)
% plot(1:n,G8,'k--','Linewidth',1)
% plot(1:n,G9,'k--','Linewidth',1)
% plot(1:n,G10,'k-','Linewidth',2)
% plot(1:n,G11,'k--','Linewidth',1)
% plot(1:n,G12,'k--','Linewidth',1)
% plot(1:n,G13,'k-','Linewidth',2)
% xlabel('Time [h]','Fontname','Times','FontSize',15);
% ylabel('power [GW]','Fontname','Times','FontSize',15);
% axis([0 25 0 70])
%--------------------------------------------------------------------------
dep=delta_mT.*(delta_mT>=0);
dem=delta_mT.*(delta_mT<0);
n=24;
maixLP=loadT-hpv_mT; % l-p
maixLPQ=loadT-hpv_mT+q_mT; % l-p+q
maix3=loadT-delta_mT-hpv_mT+q_mT;% l-delta-p+q
%--------------------------------------------------------------------------
temp1=max(maix3,maixLPQ);
temp2=min(maix3,maixLPQ);
%--- Coloring PV ----------------------------------------------------------
% V=[loadT' fliplr(maixLP')];
% fill(T,V,[0/256 204/256 0/256],'FaceAlpha',.8)
V=[loadT' fliplr(temp1')];
fill(T,V,[0/256 204/256 0/256])
plot(1:n,maixLP,':','Linewidth',3,'Color',[0/256 204/256 0/256]);
plot(1:n,loadT,'k:','Linewidth',4);
plot(1:n,maixLPQ,'b-','Linewidth',3);
%--- Coloring PV curtail --------------------------------------------------
if sum(abs(q_mT))>=1e-2;
V=[maixLPQ' fliplr(maixLP')];
%fill(T,V,[0 0 0],'FaceAlpha',.4)
fill(T,V,[0 0 0])
end
%--------------------------------------------------------------------------
plot(1:n,maix3,'k-','Linewidth',4);
%--- Coloring discharge power ---------------------------------------------
if sum(abs(dep))>=1e-2;
V=[temp1' fliplr(maix3')];
%fill(T,V,[0/256 0/256 256/256],'FaceAlpha',.4)
fill(T,V,[0/256 0/256 256/256])
end
%--- Coloring charge power ------------------------------------------------
if sum(abs(dem))>=1e-2;
V=[maix3' fliplr(temp2')];
%fill(T,V,[0/256 0/256 256/256],'FaceAlpha',.5)
fill(T,V,[0/256 50/256 100/256])
end


