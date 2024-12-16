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
batterylevel=0;%[%] battery penetration level
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
    % 'socialcost_i','B1','B2','B3','B4','B5','B6','B7');

load(sprintf('data_output_PVlevel%d_Batterylevel%d_LMP.mat',PVlevel,batterylevel),...
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
    'lmp1','lmp2','lmp3','lmp4','lmp5',...
    'profit1','profit2','profit3','profit4','profit5',...
    'q','delta_in','delta_out','delta','yaa',...%セル
    'g01','g02','g03','g04','g05','g06','g07','g08','g09','g10','g11','g12','g13',...%セル
    'q_m','delta_m',...%セル
    'g01_m','g02_m','g03_m','g04_m','g05_m','g06_m','g07_m','g08_m','g09_m','g10_m','g11_m','g12_m','g13_m',...%セル
    'socialcost_i','B1','B2','B3','B4','B5','B6','B7');

%--- 全体を見るために
%figure(200);hold on;grid on;box on;
figure
% bar(1:24,lam1,'b-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam2,'r-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam3,'g-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam4,'m-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam5,'c-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam6,'k-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam7,'k--','Linewidth',2,'FaceAlpha',.4)
%stairs(0.5:24.5,[lam1;lam1(24)],'r-','Linewidth',5);

Y=[lam];
bar3(Y);
title(sprintf('LMP at Reference Bus, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
%legend('nodal1','nodal2','nodal3','nodal4','nodal5','nodal6','nodal7')
%bar(1:n,lam,'b','Linewidth',2);%
ylabel('Time [h]','Fontname','Times','FontSize',15);
zlabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
%axis([0 25 0 12])
zlim([0 12])

figure
u_hat_matrix = reshape(u_hat, 6, 24)
bar3(u_hat_matrix');
title(sprintf('u_hat (Upper Limit), PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
%legend('nodal1','nodal2','nodal3','nodal4','nodal5','nodal6','nodal7')
%bar(1:n,lam,'b','Linewidth',2);%
ylabel('Time [h]','Fontname','Times','FontSize',15);
zlabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
%axis([0 25 0 12])
zlim([0 12])

figure
u_check_matrix = reshape(u_check, 6, 24)
bar3(u_check_matrix');
title(sprintf('u_check (Lower Limit), PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
%legend('nodal1','nodal2','nodal3','nodal4','nodal5','nodal6','nodal7')
%bar(1:n,lam,'b','Linewidth',2);%
ylabel('Time [h]','Fontname','Times','FontSize',15);
zlabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
%axis([0 25 0 12])
zlim([0 12])

figure
LMP=[lmp1,lmp2,lmp3,lmp4,lmp5]
bar3(LMP);
title(sprintf('LMP, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
%legend('nodal1','nodal2','nodal3','nodal4','nodal5','nodal6','nodal7')
%bar(1:n,lam,'b','Linewidth',2);%
ylabel('Time [h]','Fontname','Times','FontSize',15);
zlabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
%axis([0 25 0 12])


figure(100)
plot(x_agg1_nodal1,'Linewidth',3,'Color',[0.87,0.49,0]);hold on;
plot(x_agg2_nodal2,'Linewidth',3,'Color',[1,0.84,0]);
plot(x_agg3_nodal3,'Linewidth',3,'Color',[0,0.45,0.74]);
plot(x_agg4_nodal4,'Linewidth',3,'Color',[0.35,0.2,0.33]);
plot(x_agg5_nodal5,'Linewidth',3,'Color',[0,0.5,0]);
legend('Agg1','Agg2','Agg3','Agg4','Agg5')
ylabel('[GW]')
title(sprintf('total prosumption, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
figure
plot(x_agg1_nodal1,'b-','Linewidth',2);hold on
% plot(x_agg1_nodal2,'r-','Linewidth',2)
plot([1:24],B1*ones(1,24),'b--')
plot([1:24],-B1*ones(1,24),'b--')
plot([1:24],B2*ones(1,24),'r--')
plot([1:24],-B2*ones(1,24),'r--')
title(sprintf('Each prosumption for agg1, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
ylabel('[GW]')
legend('nodal1','nodal2')

figure
% plot(x_agg2_nodal1,'b-','Linewidth',2);hold on
plot(x_agg2_nodal2,'r-','Linewidth',2);hold on
% plot(x_agg2_nodal3,'g-','Linewidth',2)
plot([1:24],B1*ones(1,24),'b--')
plot([1:24],-B1*ones(1,24),'b--')
plot([1:24],B2*ones(1,24),'r--')
plot([1:24],-B2*ones(1,24),'r--')
plot([1:24],B3*ones(1,24),'g--')
plot([1:24],-B3*ones(1,24),'g--')
title(sprintf('Each prosumption for agg2, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
ylabel('[GW]')
% legend('nodal1','nodal2','nodal3')
legend('nodal2')

figure
plot(x_agg3_nodal3,'g-','Linewidth',2);hold on
% plot(x_agg3_nodal4,'m-','Linewidth',2)
% plot(x_agg3_nodal5,'c-','Linewidth',2)
% plot(x_agg3_nodal6,'k-','Linewidth',2)
% plot(x_agg3_nodal7,'k--','Linewidth',2)
plot([1:24],B3*ones(1,24),'g--')
plot([1:24],-B3*ones(1,24),'g--')
plot([1:24],B4*ones(1,24),'m--')
plot([1:24],-B4*ones(1,24),'m--')
plot([1:24],B5*ones(1,24),'c--')
plot([1:24],-B5*ones(1,24),'c--')
plot([1:24],B6*ones(1,24),'k--')
plot([1:24],-B6*ones(1,24),'k--')
plot([1:24],B7*ones(1,24),'k:')
plot([1:24],-B7*ones(1,24),'k:')
title(sprintf('Each prosumption for agg3, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
ylabel('[GW]')
% legend('nodal3','nodal4','nodal5','nodal6','nodal7')
legend('nodal3')

figure
plot(x_agg4_nodal4,'m-','Linewidth',2);hold on;
% plot(x_agg4_nodal5,'c-','Linewidth',2)
plot([1:24],B4*ones(1,24),'m--')
plot([1:24],-B4*ones(1,24),'m--')
plot([1:24],B5*ones(1,24),'c--')
plot([1:24],-B5*ones(1,24),'c--')
title(sprintf('Each prosumption for agg4, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
ylabel('[GW]')
% legend('nodal4','nodal5')
legend('nodal4')

figure
plot(x_agg5_nodal5,'k-','Linewidth',2);hold on;
% plot(x_agg5_nodal6,'k-','Linewidth',2);hold on;
% plot(x_agg5_nodal7,'k--','Linewidth',2')
plot([1:24],B6*ones(1,24),'k--')
plot([1:24],-B6*ones(1,24),'k--')
plot([1:24],B7*ones(1,24),'k:')
plot([1:24],-B7*ones(1,24),'k:')
title(sprintf('Each prosumption for agg5, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
ylabel('[GW]')
% legend('nodal6','nodal7')
legend('nodal5')

%---

aggNo=1;%●●●
%--- Read data of Agg.#i (Prosumption, PV curtail, C/D power, SOC) --------
n=24;
koike=colormap(hsv(10))*0.6;% color pattern
%--- Fig.1(a1) ------------------------------------------------------------
figure(11);hold on;grid on;box on;
title(sprintf('Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('Prosumption [GW]','Fontname','Times','FontSize',15);
plot(1:n,Agg(aggNo).load,'k-o','Linewidth',2);%Load[GW]
plot(1:n,-x_giv{aggNo},'bo-','Linewidth',2);%Prosumption[GW]
for ii=1:10;
    plot(1:n,Agg(aggNo).hpv{ii},'-o','Color',koike(ii,:),'Linewidth',0.5);%PV_scenarios[GW]
    plot(1:n,Agg(aggNo).hpv{ii}-q{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',1);%PV_used[GW]
end
%ylim([0 6]);

%--- Fig.1(a2) ------------------------------------------------------------
figure(12); hold on; grid on; box on;
title(sprintf('Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('Charge and discharge [GW]','Fontname','Times','FontSize',15);
for ii=1:10;
    plot(1:n,delta{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
end
%ylim([-3 3]);
%--- Fig.1(a3) ------------------------------------------------------------
figure(13); hold on; grid on; box on;
title(sprintf('Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('SOC [GWh]','Fontname','Times','FontSize',15);
for ii=1:10;
    plot(0:1:n,[0;yaa{aggNo}{ii}],'*-','Color',koike(ii,:),'Linewidth',2);%SOC
end
plot(1:n,Agg(aggNo).y_max*ones(1,n),'b--')
plot(1:n,-Agg(aggNo).y_max*ones(1,n),'b--')
%ylim([-10 10])

%--- g01とかのシナリオ -----------------------------------------------------
% figure(301); hold on; grid on; box on;
% title(sprintf('g01 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g01{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(302); hold on; grid on; box on;
% title(sprintf('g02 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g02{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(303); hold on; grid on; box on;
% title(sprintf('g03 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g03{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(304); hold on; grid on; box on;
% title(sprintf('g04 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g04{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(305); hold on; grid on; box on;
% title(sprintf('g05 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g05{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(306); hold on; grid on; box on;
% title(sprintf('g06 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g06{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(307); hold on; grid on; box on;
% title(sprintf('g07 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g07{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(308); hold on; grid on; box on;
% title(sprintf('g08 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g08{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(309); hold on; grid on; box on;
% title(sprintf('g09 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g09{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(310); hold on; grid on; box on;
% title(sprintf('g10 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g10{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(311); hold on; grid on; box on;
% title(sprintf('g11 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g11{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(312); hold on; grid on; box on;
% title(sprintf('g12 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g12{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(313); hold on; grid on; box on;
% title(sprintf('g13 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g13{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
%**************************************************************************
%*** Plot Fig.2(a1),(a2),(a3) *********************************************
%**************************************************************************
figure(31); hold on; grid on; box on;
title(sprintf('Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
plot(1:n,g01_m{aggNo});
plot(1:n,g02_m{aggNo});
plot(1:n,g03_m{aggNo});
plot(1:n,g04_m{aggNo});
plot(1:n,g05_m{aggNo});
plot(1:n,g06_m{aggNo});
plot(1:n,g07_m{aggNo});
plot(1:n,g08_m{aggNo});
plot(1:n,g09_m{aggNo});
plot(1:n,g10_m{aggNo});
plot(1:n,g11_m{aggNo});
plot(1:n,g12_m{aggNo});
plot(1:n,g13_m{aggNo});
legend('g01','g02','g03','g04','g05','g06','g07','g08','g09','g10','g11','g12','g13')

%--------------------------------------------------------------------------
%--- Fig.2(a2) ------------------------------------------------------------
%--------------------------------------------------------------------------
%--- Coal -----------------------------------------------------------------
G0=zeros(n,1);
G1=g12_m{aggNo};
G2=G1+g11_m{aggNo};
G3=G2+g10_m{aggNo};
G4=G3+g13_m{aggNo};
%--- LNGCC ----------------------------------------------------------------
G5=G4+g09_m{aggNo};
G6=G5+g07_m{aggNo};
G7=G6+g08_m{aggNo};
%--- LNG ------------------------------------------------------------------
G8=G7+g05_m{aggNo};
G9=G8+g04_m{aggNo};
G10=G9+g06_m{aggNo};
%--- Oil ------------------------------------------------------------------
G11=G10+g02_m{aggNo};
G12=G11+g03_m{aggNo};
G13=G12+g01_m{aggNo};
%--------------------------------------------------------------------------
figure(32); hold on; grid on; box on;
title(sprintf('Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
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
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('power [GW]','Fontname','Times','FontSize',15);
%axis([0 25 0 70])
%--------------------------------------------------------------------------


xxxxx
%--------------------------------------------------------------------------
%--- Fig.2(a3) ------------------------------------------------------------
%--------------------------------------------------------------------------
CCC_data=xlsread('data_output_PVlevel2_Batterylevel50',3,'B3:O26');
BBB_data=xlsread('data_output_PVlevel2_Batterylevel50',2,'B3:C26');
g01=CCC_data(:,1);%Generating power of thermal power plant #1(Oil:A)
g02=CCC_data(:,2);%Generating power of thermal power plant #2(Oil:B)
g03=CCC_data(:,3);%Generating power of thermal power plant #3(Oil:C)
g04=CCC_data(:,4);%Generating power of thermal power plant #4(LNG:A)
g05=CCC_data(:,5);%Generating power of thermal power plant #5(LNG:B)
g06=CCC_data(:,6);%Generating power of thermal power plant #6(LNG:C)
g07=CCC_data(:,7);%Generating power of thermal power plant #7(LNGCC:A)
g08=CCC_data(:,8);%Generating power of thermal power plant #8(LNGCC:B)
g09=CCC_data(:,9);%Generating power of thermal power plant #9(LNGCC:C)
g10=CCC_data(:,10);%Generating power of thermal power plant #10(Coal:A)
g11=CCC_data(:,11);%Generating power of thermal power plant #11(Coal:B)
g12=CCC_data(:,12);%Generating power of thermal power plant #12(Coal:C)
g13=CCC_data(:,13);%Generating power of thermal power plant #13(Coal:D)
%--- summantion load of all DER Agg ---------------------------------------
loadT= xlsread('data_input',1,'C3:C26')+...
       xlsread('data_input',2,'C3:C26')+...
       xlsread('data_input',3,'C3:C26')+...
       xlsread('data_input',4,'C3:C26')+...
       xlsread('data_input',5,'C3:C26')+...
       xlsread('data_input',6,'C3:C26')+...
       xlsread('data_input',7,'C3:C26')+...
       xlsread('data_input',8,'C3:C26')+...
       xlsread('data_input',9,'C3:C26')+...
       xlsread('data_input',10,'C3:C26');
%--- Set to initial values ------------------------------------------------
hpv_mT=zeros(24,1);%(initial)Average PV coresponding to summantion of all DER Agg.
for aggNo=1:10
hpv=xlsread('data_input',aggNo,'D3:M26');%PV scenario 
hpv_m=zeros(24,1);
for ii=1:10;%Calculation of PV for scenario.#ii
hpv_m=hpv_m+hpv(:,ii);
end
hpv_m=hpv_m/10;%Average PV scenario coresponding to Agg.#aggNo
hpv_mT=hpv_mT+hpv_m;%Average PV coresponding to summantion of all DER Agg.
end
hpv_mT=hpv_mT*PV_HorL;%Average PV coresponding to summantion of all DER Agg.
q_mT=BBB_data(:,1);%Average PV curtail coresponding to summantion of all DER Agg.
delta_mT=BBB_data(:,2);%Average C/D power coresponding to summantion of all DER Agg. 
%--- Coal -----------------------------------------------------------------
G0=zeros(n,1);
G1=g12;
G2=G1+g11;
G3=G2+g10;
G4=G3+g13;
%--- LNGCC ----------------------------------------------------------------
G5=G4+g09;
G6=G5+g07;
G7=G6+g08;
%--- LNG ------------------------------------------------------------------
G8=G7+g05;
G9=G8+g04;
G10=G9+g06;
%--- Oil ------------------------------------------------------------------
G11=G10+g02;
G12=G11+g03;
G13=G12+g01;
%--------------------------------------------------------------------------
figure(33); hold on; grid on; box on;
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
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('power [GW]','Fontname','Times','FontSize',15);
axis([0 25 0 70])
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
V=[loadT' fliplr(maixLP')];
fill(T,V,[0/256 204/256 0/256],'FaceAlpha',.8)
plot(1:n,maixLP,':','Linewidth',3,'Color',[0/256 204/256 0/256]);
plot(1:n,loadT,'k:','Linewidth',4);
plot(1:n,maixLPQ,'b-','Linewidth',3);
%--- Coloring PV curtail --------------------------------------------------
if sum(abs(q_mT))>=1e-2;
V=[maixLPQ' fliplr(maixLP')];
fill(T,V,[0 0 0],'FaceAlpha',.4)
end
%--------------------------------------------------------------------------
plot(1:n,maix3,'k-','Linewidth',4);
%--- Coloring discharge power ---------------------------------------------
if sum(abs(dep))>=1e-2;
V=[temp1' fliplr(maix3')];
fill(T,V,[0/256 0/256 256/256],'FaceAlpha',.4)
end
%--- Coloring charge power ------------------------------------------------
if sum(abs(dem))>=1e-2;
V=[maix3' fliplr(temp2')];
fill(T,V,[0/256 0/256 256/256],'FaceAlpha',.5)
end

%**************************************************************************
%*** Plot Fig.2(b1),(b2),(b3) *********************************************
%**************************************************************************
%--------------------------------------------------------------------------
%--- Fig.2(b1) ------------------------------------------------------------
%--------------------------------------------------------------------------
lam=xlsread('data_output_PVlevel2_Batterylevel0',3,'O3:O26');
n=24;
figure(41); hold on; grid on; box on;
bar(1:n,lam,'b','Linewidth',2);%
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
axis([0 25 0 12])
%--------------------------------------------------------------------------
%--- Fig.2(b2) ------------------------------------------------------------
%--------------------------------------------------------------------------
lam=xlsread('data_output_PVlevel2_Batterylevel20',3,'O3:O26');
n=24;
figure(42); hold on; grid on; box on;
bar(1:n,lam,'b','Linewidth',2);%
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
axis([0 25 0 12])
%--------------------------------------------------------------------------
%--- Fig.2(b3) ------------------------------------------------------------
%--------------------------------------------------------------------------
lam=xlsread('data_output_PVlevel2_Batterylevel50',3,'O3:O26');
n=24;
figure(43); hold on; grid on; box on;
bar(1:n,lam,'b','Linewidth',2);%
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
axis([0 25 0 12])


%**************************************************************************
%*** Plot Fig.3(1),(2),(3) *********************************************
%**************************************************************************
rate_set=0:5:100;

profit_agg1_pvlow=xlsread('data_output_socialcost_profit',1,'D3:D23');
socialcost_pvlow=xlsread('data_output_socialcost_profit',1,'C3:C23');

profit_agg1_pvhigh=xlsread('data_output_socialcost_profit',2,'D3:D23');
socialcost_pvhigh=xlsread('data_output_socialcost_profit',2,'C3:C23');
%--------------------------------------------------------------------------
%--- Fig.3(1) -------------------------------------------------------------
%--------------------------------------------------------------------------
figure(51);hold on; grid on; box on;
plot(rate_set,socialcost_pvlow','r*-','Linewidth',2);
plot(rate_set,socialcost_pvhigh','bo-','Linewidth',2);
xlabel('Battery penetration level[%]','Fontname','Times','FontSize',15)
ylabel('Social cost[M JPY]','Fontname','Times','FontSize',15)
%--------------------------------------------------------------------------
%--- Fig.3(2) -------------------------------------------------------------
%--------------------------------------------------------------------------
figure(52);hold on; grid on; box on;
plot(rate_set,profit_agg1_pvlow','r*-','Linewidth',2);
plot(rate_set,profit_agg1_pvhigh','bo-','Linewidth',2);
xlabel('Battery penetration level[%]','Fontname','Times','FontSize',15);
ylabel('Profit[M JPY]','Fontname','Times','FontSize',15)
%--------------------------------------------------------------------------
%--- Fig.3(3) -------------------------------------------------------------
%--------------------------------------------------------------------------
a=0:25:500;%[×10^5] the number of residencies who has storage battery
b=1*10^4*14/(360*25);%Price of storage battery per unit [JPY]...10000[JPY/kWh]*14[kWh]/(360*25[days])
y=a.*b;%[×10^5 JPY]=[0.1 MJPY]
yy=y*0.1/10;%[MJPY] Because we focus on Agg.#1, it divide by 10.
figure(53);hold on; grid on; box on;
plot(rate_set,profit_agg1_pvlow'-yy,'r*-','Linewidth',2);
plot(rate_set,profit_agg1_pvhigh'-yy,'bo-','Linewidth',2);
xlabel('Battery penetration level[%]','Fontname','Times','FontSize',15);
ylabel('Profit[M JPY]','Fontname','Times','FontSize',15)





xxxxx



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
batterylevel=0;%[%] battery penetration level
PVlevel=3;%  1:=PV_Low
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
load(sprintf('data_output_PVlevel%d_Batterylevel%d_LMP.mat',PVlevel,batterylevel),...
    'x_agg1_nodal1','x_agg1_nodal2',...
    'x_agg2_nodal1','x_agg2_nodal2','x_agg2_nodal3',...
    'x_agg3_nodal3','x_agg3_nodal4','x_agg3_nodal5','x_agg3_nodal6','x_agg3_nodal7',...
    'x_agg4_nodal4','x_agg4_nodal5',...
    'x_agg5_nodal6','x_agg5_nodal7',...
    'x_giv',... %セル
    'lam1','lam2','lam3','lam4','lam5','lam6','lam7',...
    'cost1','cost2','cost3','cost4','cost5',...
    'profit1','profit2','profit3','profit4','profit5',...
    'q','delta_in','delta_out','delta','yaa',...%セル
    'g01','g02','g03','g04','g05','g06','g07','g08','g09','g10','g11','g12','g13',...%セル
    'q_m','delta_m',...%セル
    'g01_m','g02_m','g03_m','g04_m','g05_m','g06_m','g07_m','g08_m','g09_m','g10_m','g11_m','g12_m','g13_m',...%セル
    'socialcost_i','B1','B2','B3','B4','B5','B6','B7');

%foo
%--- 全体を見るために
%figure(200);hold on;grid on;box on;
figure
% bar(1:24,lam1,'b-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam2,'r-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam3,'g-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam4,'m-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam5,'c-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam6,'k-','Linewidth',2,'FaceAlpha',.4);
% bar(1:24,lam7,'k--','Linewidth',2,'FaceAlpha',.4)
%stairs(0.5:24.5,[lam1;lam1(24)],'r-','Linewidth',5);
Y=[lam1 lam2 lam3 lam4 lam5 lam6 lam7];
bar3(Y);
title(sprintf('Price, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
%legend('nodal1','nodal2','nodal3','nodal4','nodal5','nodal6','nodal7')
%bar(1:n,lam,'b','Linewidth',2);%
ylabel('Time [h]','Fontname','Times','FontSize',15);
zlabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
%axis([0 25 0 12])
zlim([0 12])


figure(100)
plot(x_agg1_nodal1+x_agg1_nodal2,'Linewidth',3,'Color',[0.87,0.49,0]);hold on;
plot(x_agg2_nodal1+x_agg2_nodal2+x_agg2_nodal3,'Linewidth',3,'Color',[1,0.84,0]);
plot(x_agg3_nodal3+x_agg3_nodal4+x_agg3_nodal5+x_agg3_nodal6+x_agg3_nodal7,...
    'Linewidth',3,'Color',[0,0.45,0.74]);
plot(x_agg4_nodal4+x_agg4_nodal5,'Linewidth',3,'Color',[0.35,0.2,0.33]);
plot(x_agg5_nodal6+x_agg5_nodal7,'Linewidth',3,'Color',[0,0.5,0]);
legend('Agg1','Agg2','Agg3','Agg4','Agg5')
ylabel('[GW]')
title(sprintf('total prosumption, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
figure
plot(x_agg1_nodal1,'b-','Linewidth',2);hold on
plot(x_agg1_nodal2,'r-','Linewidth',2)
plot([1:24],B1*ones(1,24),'b--')
plot([1:24],-B1*ones(1,24),'b--')
plot([1:24],B2*ones(1,24),'r--')
plot([1:24],-B2*ones(1,24),'r--')
title(sprintf('Each prosumption for agg1, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
ylabel('[GW]')
legend('nodal1','nodal2')

figure
plot(x_agg2_nodal1,'b-','Linewidth',2);hold on
plot(x_agg2_nodal2,'r-','Linewidth',2)
plot(x_agg2_nodal3,'g-','Linewidth',2)
plot([1:24],B1*ones(1,24),'b--')
plot([1:24],-B1*ones(1,24),'b--')
plot([1:24],B2*ones(1,24),'r--')
plot([1:24],-B2*ones(1,24),'r--')
plot([1:24],B3*ones(1,24),'g--')
plot([1:24],-B3*ones(1,24),'g--')
title(sprintf('Each prosumption for agg2, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
ylabel('[GW]')
legend('nodal1','nodal2','nodal3')

figure
plot(x_agg3_nodal3,'g-','Linewidth',2);hold on
plot(x_agg3_nodal4,'m-','Linewidth',2)
plot(x_agg3_nodal5,'c-','Linewidth',2)
plot(x_agg3_nodal6,'k-','Linewidth',2)
plot(x_agg3_nodal7,'k--','Linewidth',2)
plot([1:24],B3*ones(1,24),'g--')
plot([1:24],-B3*ones(1,24),'g--')
plot([1:24],B4*ones(1,24),'m--')
plot([1:24],-B4*ones(1,24),'m--')
plot([1:24],B5*ones(1,24),'c--')
plot([1:24],-B5*ones(1,24),'c--')
plot([1:24],B6*ones(1,24),'k--')
plot([1:24],-B6*ones(1,24),'k--')
plot([1:24],B7*ones(1,24),'k:')
plot([1:24],-B7*ones(1,24),'k:')
title(sprintf('Each prosumption for agg3, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
ylabel('[GW]')
legend('nodal3','nodal4','nodal5','nodal6','nodal7')

figure
plot(x_agg4_nodal4,'m-','Linewidth',2);hold on;
plot(x_agg4_nodal5,'c-','Linewidth',2)
plot([1:24],B4*ones(1,24),'m--')
plot([1:24],-B4*ones(1,24),'m--')
plot([1:24],B5*ones(1,24),'c--')
plot([1:24],-B5*ones(1,24),'c--')

title(sprintf('Each prosumption for agg4, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
ylabel('[GW]')
legend('nodal4','nodal5')

figure
plot(x_agg5_nodal6,'k-','Linewidth',2);hold on;
plot(x_agg5_nodal7,'k--','Linewidth',2')
plot([1:24],B6*ones(1,24),'k--')
plot([1:24],-B6*ones(1,24),'k--')
plot([1:24],B7*ones(1,24),'k:')
plot([1:24],-B7*ones(1,24),'k:')
title(sprintf('Each prosumption for agg5, PVlevel:%d Batterylevel:%d',PVlevel,batterylevel))
ylabel('[GW]')
legend('nodal6','nodal7')
%---

aggNo=1;%●●●
%--- Read data of Agg.#i (Prosumption, PV curtail, C/D power, SOC) --------
n=24;
koike=colormap(hsv(10))*0.6;% color pattern
%--- Fig.1(a1) ------------------------------------------------------------
figure(11);hold on;grid on;box on;
title(sprintf('Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('Prosumption [GW]','Fontname','Times','FontSize',15);
plot(1:n,Agg(aggNo).load,'k-o','Linewidth',2);%Load[GW]
plot(1:n,-x_giv{aggNo},'bo-','Linewidth',2);%Prosumption[GW]
for ii=1:10;
    plot(1:n,Agg(aggNo).hpv{ii},'-o','Color',koike(ii,:),'Linewidth',0.5);%PV_scenarios[GW]
    plot(1:n,Agg(aggNo).hpv{ii}-q{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',1);%PV_used[GW]
end
%ylim([0 6]);

%--- Fig.1(a2) ------------------------------------------------------------
figure(12); hold on; grid on; box on;
title(sprintf('Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('Charge and discharge [GW]','Fontname','Times','FontSize',15);
for ii=1:10;
    plot(1:n,delta{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
end
%ylim([-3 3]);
%--- Fig.1(a3) ------------------------------------------------------------
figure(13); hold on; grid on; box on;
title(sprintf('Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('SOC [GWh]','Fontname','Times','FontSize',15);
for ii=1:10;
    plot(0:1:n,[0;yaa{aggNo}{ii}],'*-','Color',koike(ii,:),'Linewidth',2);%SOC
end
plot(1:n,Agg(aggNo).y_max*ones(1,n),'b--')
plot(1:n,-Agg(aggNo).y_max*ones(1,n),'b--')
%ylim([-10 10])

%--- g01とかのシナリオ -----------------------------------------------------
% figure(301); hold on; grid on; box on;
% title(sprintf('g01 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g01{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(302); hold on; grid on; box on;
% title(sprintf('g02 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g02{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(303); hold on; grid on; box on;
% title(sprintf('g03 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g03{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(304); hold on; grid on; box on;
% title(sprintf('g04 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g04{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(305); hold on; grid on; box on;
% title(sprintf('g05 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g05{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(306); hold on; grid on; box on;
% title(sprintf('g06 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g06{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(307); hold on; grid on; box on;
% title(sprintf('g07 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g07{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(308); hold on; grid on; box on;
% title(sprintf('g08 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g08{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(309); hold on; grid on; box on;
% title(sprintf('g09 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g09{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(310); hold on; grid on; box on;
% title(sprintf('g10 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g10{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(311); hold on; grid on; box on;
% title(sprintf('g11 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g11{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(312); hold on; grid on; box on;
% title(sprintf('g12 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g12{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
% figure(313); hold on; grid on; box on;
% title(sprintf('g13 of Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
% for ii=1:10;
%     plot(1:n,g13{aggNo}{ii},'*-','Color',koike(ii,:),'Linewidth',2);%C/D power
% end
%**************************************************************************
%*** Plot Fig.2(a1),(a2),(a3) *********************************************
%**************************************************************************
figure(31); hold on; grid on; box on;
title(sprintf('Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
plot(1:n,g01_m{aggNo});
plot(1:n,g02_m{aggNo});
plot(1:n,g03_m{aggNo});
plot(1:n,g04_m{aggNo});
plot(1:n,g05_m{aggNo});
plot(1:n,g06_m{aggNo});
plot(1:n,g07_m{aggNo});
plot(1:n,g08_m{aggNo});
plot(1:n,g09_m{aggNo});
plot(1:n,g10_m{aggNo});
plot(1:n,g11_m{aggNo});
plot(1:n,g12_m{aggNo});
plot(1:n,g13_m{aggNo});
legend('g01','g02','g03','g04','g05','g06','g07','g08','g09','g10','g11','g12','g13')

%--------------------------------------------------------------------------
%--- Fig.2(a2) ------------------------------------------------------------
%--------------------------------------------------------------------------
%--- Coal -----------------------------------------------------------------
G0=zeros(n,1);
G1=g12_m{aggNo};
G2=G1+g11_m{aggNo};
G3=G2+g10_m{aggNo};
G4=G3+g13_m{aggNo};
%--- LNGCC ----------------------------------------------------------------
G5=G4+g09_m{aggNo};
G6=G5+g07_m{aggNo};
G7=G6+g08_m{aggNo};
%--- LNG ------------------------------------------------------------------
G8=G7+g05_m{aggNo};
G9=G8+g04_m{aggNo};
G10=G9+g06_m{aggNo};
%--- Oil ------------------------------------------------------------------
G11=G10+g02_m{aggNo};
G12=G11+g03_m{aggNo};
G13=G12+g01_m{aggNo};
%--------------------------------------------------------------------------
figure(32); hold on; grid on; box on;
title(sprintf('Agg%d, PVlevel:%d Batterylevel:%d',aggNo,PVlevel,batterylevel))
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
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('power [GW]','Fontname','Times','FontSize',15);
%axis([0 25 0 70])
%--------------------------------------------------------------------------


xxxxx
%--------------------------------------------------------------------------
%--- Fig.2(a3) ------------------------------------------------------------
%--------------------------------------------------------------------------
CCC_data=xlsread('data_output_PVlevel2_Batterylevel50',3,'B3:O26');
BBB_data=xlsread('data_output_PVlevel2_Batterylevel50',2,'B3:C26');
g01=CCC_data(:,1);%Generating power of thermal power plant #1(Oil:A)
g02=CCC_data(:,2);%Generating power of thermal power plant #2(Oil:B)
g03=CCC_data(:,3);%Generating power of thermal power plant #3(Oil:C)
g04=CCC_data(:,4);%Generating power of thermal power plant #4(LNG:A)
g05=CCC_data(:,5);%Generating power of thermal power plant #5(LNG:B)
g06=CCC_data(:,6);%Generating power of thermal power plant #6(LNG:C)
g07=CCC_data(:,7);%Generating power of thermal power plant #7(LNGCC:A)
g08=CCC_data(:,8);%Generating power of thermal power plant #8(LNGCC:B)
g09=CCC_data(:,9);%Generating power of thermal power plant #9(LNGCC:C)
g10=CCC_data(:,10);%Generating power of thermal power plant #10(Coal:A)
g11=CCC_data(:,11);%Generating power of thermal power plant #11(Coal:B)
g12=CCC_data(:,12);%Generating power of thermal power plant #12(Coal:C)
g13=CCC_data(:,13);%Generating power of thermal power plant #13(Coal:D)
%--- summantion load of all DER Agg ---------------------------------------
loadT= xlsread('data_input',1,'C3:C26')+...
       xlsread('data_input',2,'C3:C26')+...
       xlsread('data_input',3,'C3:C26')+...
       xlsread('data_input',4,'C3:C26')+...
       xlsread('data_input',5,'C3:C26')+...
       xlsread('data_input',6,'C3:C26')+...
       xlsread('data_input',7,'C3:C26')+...
       xlsread('data_input',8,'C3:C26')+...
       xlsread('data_input',9,'C3:C26')+...
       xlsread('data_input',10,'C3:C26');
%--- Set to initial values ------------------------------------------------
hpv_mT=zeros(24,1);%(initial)Average PV coresponding to summantion of all DER Agg.
for aggNo=1:10
hpv=xlsread('data_input',aggNo,'D3:M26');%PV scenario 
hpv_m=zeros(24,1);
for ii=1:10;%Calculation of PV for scenario.#ii
hpv_m=hpv_m+hpv(:,ii);
end
hpv_m=hpv_m/10;%Average PV scenario coresponding to Agg.#aggNo
hpv_mT=hpv_mT+hpv_m;%Average PV coresponding to summantion of all DER Agg.
end
hpv_mT=hpv_mT*PV_HorL;%Average PV coresponding to summantion of all DER Agg.
q_mT=BBB_data(:,1);%Average PV curtail coresponding to summantion of all DER Agg.
delta_mT=BBB_data(:,2);%Average C/D power coresponding to summantion of all DER Agg. 
%--- Coal -----------------------------------------------------------------
G0=zeros(n,1);
G1=g12;
G2=G1+g11;
G3=G2+g10;
G4=G3+g13;
%--- LNGCC ----------------------------------------------------------------
G5=G4+g09;
G6=G5+g07;
G7=G6+g08;
%--- LNG ------------------------------------------------------------------
G8=G7+g05;
G9=G8+g04;
G10=G9+g06;
%--- Oil ------------------------------------------------------------------
G11=G10+g02;
G12=G11+g03;
G13=G12+g01;
%--------------------------------------------------------------------------
figure(33); hold on; grid on; box on;
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
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('power [GW]','Fontname','Times','FontSize',15);
axis([0 25 0 70])
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
V=[loadT' fliplr(maixLP')];
fill(T,V,[0/256 204/256 0/256],'FaceAlpha',.8)
plot(1:n,maixLP,':','Linewidth',3,'Color',[0/256 204/256 0/256]);
plot(1:n,loadT,'k:','Linewidth',4);
plot(1:n,maixLPQ,'b-','Linewidth',3);
%--- Coloring PV curtail --------------------------------------------------
if sum(abs(q_mT))>=1e-2;
V=[maixLPQ' fliplr(maixLP')];
fill(T,V,[0 0 0],'FaceAlpha',.4)
end
%--------------------------------------------------------------------------
plot(1:n,maix3,'k-','Linewidth',4);
%--- Coloring discharge power ---------------------------------------------
if sum(abs(dep))>=1e-2;
V=[temp1' fliplr(maix3')];
fill(T,V,[0/256 0/256 256/256],'FaceAlpha',.4)
end
%--- Coloring charge power ------------------------------------------------
if sum(abs(dem))>=1e-2;
V=[maix3' fliplr(temp2')];
fill(T,V,[0/256 0/256 256/256],'FaceAlpha',.5)
end

%**************************************************************************
%*** Plot Fig.2(b1),(b2),(b3) *********************************************
%**************************************************************************
%--------------------------------------------------------------------------
%--- Fig.2(b1) ------------------------------------------------------------
%--------------------------------------------------------------------------
lam=xlsread('data_output_PVlevel2_Batterylevel0',3,'O3:O26');
n=24;
figure(41); hold on; grid on; box on;
bar(1:n,lam,'b','Linewidth',2);%
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
axis([0 25 0 12])
%--------------------------------------------------------------------------
%--- Fig.2(b2) ------------------------------------------------------------
%--------------------------------------------------------------------------
lam=xlsread('data_output_PVlevel2_Batterylevel20',3,'O3:O26');
n=24;
figure(42); hold on; grid on; box on;
bar(1:n,lam,'b','Linewidth',2);%
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
axis([0 25 0 12])
%--------------------------------------------------------------------------
%--- Fig.2(b3) ------------------------------------------------------------
%--------------------------------------------------------------------------
lam=xlsread('data_output_PVlevel2_Batterylevel50',3,'O3:O26');
n=24;
figure(43); hold on; grid on; box on;
bar(1:n,lam,'b','Linewidth',2);%
xlabel('Time [h]','Fontname','Times','FontSize',15);
ylabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
axis([0 25 0 12])


%**************************************************************************
%*** Plot Fig.3(1),(2),(3) *********************************************
%**************************************************************************
rate_set=0:5:100;

profit_agg1_pvlow=xlsread('data_output_socialcost_profit',1,'D3:D23');
socialcost_pvlow=xlsread('data_output_socialcost_profit',1,'C3:C23');

profit_agg1_pvhigh=xlsread('data_output_socialcost_profit',2,'D3:D23');
socialcost_pvhigh=xlsread('data_output_socialcost_profit',2,'C3:C23');
%--------------------------------------------------------------------------
%--- Fig.3(1) -------------------------------------------------------------
%--------------------------------------------------------------------------
figure(51);hold on; grid on; box on;
plot(rate_set,socialcost_pvlow','r*-','Linewidth',2);
plot(rate_set,socialcost_pvhigh','bo-','Linewidth',2);
xlabel('Battery penetration level[%]','Fontname','Times','FontSize',15)
ylabel('Social cost[M JPY]','Fontname','Times','FontSize',15)
%--------------------------------------------------------------------------
%--- Fig.3(2) -------------------------------------------------------------
%--------------------------------------------------------------------------
figure(52);hold on; grid on; box on;
plot(rate_set,profit_agg1_pvlow','r*-','Linewidth',2);
plot(rate_set,profit_agg1_pvhigh','bo-','Linewidth',2);
xlabel('Battery penetration level[%]','Fontname','Times','FontSize',15);
ylabel('Profit[M JPY]','Fontname','Times','FontSize',15)
%--------------------------------------------------------------------------
%--- Fig.3(3) -------------------------------------------------------------
%--------------------------------------------------------------------------
a=0:25:500;%[×10^5] the number of residencies who has storage battery
b=1*10^4*14/(360*25);%Price of storage battery per unit [JPY]...10000[JPY/kWh]*14[kWh]/(360*25[days])
y=a.*b;%[×10^5 JPY]=[0.1 MJPY]
yy=y*0.1/10;%[MJPY] Because we focus on Agg.#1, it divide by 10.
figure(53);hold on; grid on; box on;
plot(rate_set,profit_agg1_pvlow'-yy,'r*-','Linewidth',2);
plot(rate_set,profit_agg1_pvhigh'-yy,'bo-','Linewidth',2);
xlabel('Battery penetration level[%]','Fontname','Times','FontSize',15);
ylabel('Profit[M JPY]','Fontname','Times','FontSize',15)









3