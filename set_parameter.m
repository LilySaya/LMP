function [] = set_parameter(AggNum, batterylevel, PV_HorL)
global Agg
global TransmissionLine

for aggNo=AggNum;% we focus on Agg.# aggNo
    %--- Read data_input.xlsx
    temp_load=xlsread('data_input',aggNo,'C3:C26');%Load
    temp_pv=xlsread('data_input',aggNo,'D3:M26');%PV scenario
    temp_Bf=xlsread('data_input',aggNo,'P3:P15');%Fuel cost of thermal plant
    temp_max_out=xlsread('data_input',aggNo,'Q3:Q15');%Max.output of thermal plant
    temp_min_out=xlsread('data_input',aggNo,'R3:R15');%Min.output of thermal plant
    temp_cap_inv_bat=xlsread('data_input',aggNo,'W3:X3');%Inverter & battery capacity
    temp_a=xlsread('data_input',aggNo,'U3:U6');%Coefficient of d(s)
    %---
    %number_battery_demander{aggNo}=(batterylevel/100)*(50*10^6)/10;% the number of residence who have battery.
    number_battery_demander{aggNo}=(batterylevel/100)*ones(1,24)*temp_load*10^6/10;
    % (50*10^6):the number of total residences, 10:the number of DER Agg.
    cap_inverter{aggNo}=temp_cap_inv_bat(1,1)*10^(-6);%[GW] inverter capacity for 1 residence
    cap_battery{aggNo}=temp_cap_inv_bat(1,2)*10^(-6);%[GWh] battery capacity for 1 residence
    eta_out{aggNo}=0.95;%Discharge efficiency
    eta_in{aggNo}=0.95;%Charge efficiency
    Agg(aggNo).load=temp_load;%Load
    for j=1:10;
        Agg(aggNo).hpv{j}=temp_pv(:,j)*PV_HorL;%PV scenario
    end
    Agg(aggNo).dy_out_max=cap_inverter{aggNo}*number_battery_demander{aggNo};%Max.discharge power
    Agg(aggNo).dy_in_max=cap_inverter{aggNo}*number_battery_demander{aggNo};%Max.charge power
    Agg(aggNo).y_max=cap_battery{aggNo}/2*number_battery_demander{aggNo};%Max.SOC
    Agg(aggNo).eta_out=eta_out{aggNo};%Discharge efficiency
    Agg(aggNo).eta_in=eta_in{aggNo};%Charge efficiency
    Agg(aggNo).a=temp_a;%Coefficient of d(s)
    for kk=1:13
        Agg(aggNo).cost_f{kk}=temp_Bf(kk,1);%Fuel cost of kk th thermal plant
        Agg(aggNo).g_max{kk}=temp_max_out(kk,1);%Max.output of kk th thermal plant
        Agg(aggNo).g_min{kk}=temp_min_out(kk,1);%Min.output of kk th thermal plant
    end
end
TransmissionLine = struct();
for lineNo = 1:4
    %--- Read data_input_line.xlsx
    temp_lineX = xlsread('data_input_line','C3:C8');%Reactance of each Transmission line
    %---
    TransmissionLine.line_reactance = temp_lineX;
end