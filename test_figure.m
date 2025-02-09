clear;
clear Agg Gen
close all;
clc
set(0,'defaultAxesFontSize',12);
set(0,'defaultAxesFontName','century');
set(0,'defaultTextFontSize',12);
set(0,'defaultTextFontName','century');
global Agg


figure(1)
title('Agg3', 'Interpreter', 'latex')
grid on;
hold on;
Batterylevel = zeros(21,1);
Profit = zeros(21,1);
for i=[0:5:100]
    index = i/5+1;
    load(fullfile('DATA_BtLv0to100', ['data_output_PVlevel3_Batterylevel' num2str(i) '_LMP_agg3.mat']))
    Batterylevel(index) = i;
    Profit(index) = profit1;
end
plot(Batterylevel,Profit,'Marker','*','Color','k','LineStyle','-.','LineWidth',1.5)
% ylabel('Time [h]','Fontname','Times','FontSize',15);
% zlabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
% xlabel('Bus','Fontname','Times','FontSize',15)
xlabel('Battery level [%]','Fontname','Times','FontSize',15);
ylabel('Profit [JPY/kWh]','Fontname','Times','FontSize',15);
% ylim([-15 15])
% legend('Agg1', 'Agg2', 'Agg3', 'Agg4', 'Agg5','Location','northwest')
legend('Agg3','Location','northwest')

% clear
% 
% figure(2)
% title('Agg3', 'Interpreter', 'latex')
% grid on;
% hold on;
% time = zeros(24*21,1);
% for i = [1:1:24*21]
%     time(i) = i;
% end
% X_agg3_nodal3 = zeros(24,1);
% for j=[0:5:100]
%     index = j/5+1;
%     load(fullfile('DATA_BtLv0to100', ['data_output_PVlevel3_Batterylevel' num2str(j) '_LMP_agg3.mat']))
%     X_agg3_nodal3((j/5*24)+1:(j/5*24)+24) = x_agg3_nodal3;
% end
% plot(time,X_agg3_nodal3,'Marker','*','Color','k','LineStyle','-.','LineWidth',1.5)
% % ylabel('Time [h]','Fontname','Times','FontSize',15);
% % zlabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
% % xlabel('Bus','Fontname','Times','FontSize',15)
% xlabel('Battery level [%]','Fontname','Times','FontSize',15);
% ylabel('Prosumption','Fontname','Times','FontSize',15);
% xlim([0 24*21])
% % legend('Agg1', 'Agg2', 'Agg3', 'Agg4', 'Agg5','Location','northwest')
% legend('Agg3','Location','northwest')

% clear
% 
% % figure(3)
% % title('Agg3', 'Interpreter', 'latex')
% % grid on;
% % hold on;
% % time = zeros(24*21,1);
% % for i = [1:1:24*21]
% %     time(i) = i;
% % end
% % Lmp3 = zeros(24,1);
% % for j=[0:5:100]
% %     index = j/5+1;
% %     load(fullfile('DATA_BtLv0to100', ['data_output_PVlevel3_Batterylevel' num2str(j) '_LMP_agg3.mat']))
% %     Lmp3((j/5*24)+1:(j/5*24)+24) = lmp3;
% % end
% % plot(time,Lmp3,'Marker','*','Color','k','LineStyle','-.','LineWidth',1.5)
% % % ylabel('Time [h]','Fontname','Times','FontSize',15);
% % % zlabel('Price [JPY/kWh]','Fontname','Times','FontSize',15);
% % % xlabel('Bus','Fontname','Times','FontSize',15)
% % xlabel('Battery level [%]','Fontname','Times','FontSize',15);
% % ylabel('Prosumption','Fontname','Times','FontSize',15);
% % xlim([0 24*21])
% % % legend('Agg1', 'Agg2', 'Agg3', 'Agg4', 'Agg5','Location','northwest')
% % legend('Agg3','Location','northwest')