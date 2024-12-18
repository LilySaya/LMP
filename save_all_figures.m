% Directory to save figures
foldername = '/Users/byeonghwalee/Documents/MATLAB/LMP/Figures/PV1_BLV0/1';

% Find all open figures
figHandles = findall(0, 'Type', 'figure'); 

% Save each figure to the specified folder
for i = 1:length(figHandles)
    figure(figHandles(i)); % Set the current figure
    filename = fullfile(foldername, sprintf('Figure%d.fig', i)); % Generate full file path
    savefig(figHandles(i), filename); % Save as .fig file
end

disp('All figures have been saved in .fig format to the specified directory.');

%%
% Directory to save figures
foldername = '/Users/byeonghwalee/Documents/MATLAB/LMP/Figures/PV1_BLV0/1';

% Find all open figures
figHandles = findall(0, 'Type', 'figure'); 

% Save each figure to the specified folder as .png
for i = 1:length(figHandles)
    figure(figHandles(i)); % Set the current figure
    filename = fullfile(foldername, sprintf('Figure%d.png', i)); % Generate full file path
    saveas(figHandles(i), filename, 'png'); % Save as .png file
end

disp('All figures have been saved in .png format to the specified directory.');
%%
close all