

































% Directory to save figures
foldername = '/Users/byeonghwalee/Documents/MATLAB/LMP/Figures/PV1_BLV0/4';

% Find all open figures
figHandles = findall(0, 'Type', 'figure'); 

% Save each figure as .fig and .png
for i = 1:length(figHandles)
    figure(figHandles(i)); % Set the current figure
    
    % Get the figure name
    figName = get(figHandles(i), 'Name'); 
    if isempty(figName)
        figName = sprintf('Figure%d', i); % Default name if no name is set
    end
    
    % Generate full file paths
    figFile = fullfile(foldername, [figName, '.fig']); % Path for .fig
    pngFile = fullfile(foldername, [figName, '.png']); % Path for .png
    
    % Save as .fig and .png
    savefig(figHandles(i), figFile); % Save as .fig
    saveas(figHandles(i), pngFile, 'png'); % Save as .png
end

disp('All figures have been saved with their names in .fig and .png formats.');

close all
