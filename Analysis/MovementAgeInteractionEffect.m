%% ------ Load data ------
AlloDataBlock = AlloData(:, {'ParticipantID', 'ParticipantGroup', 'TrialNumber', 'TrialType', 'ConfigurationType', 'MeanAbsError'});

% Remove rows with NaNs in MeanAbsError - this will automatically filter
% out the trials with 4 objects where the abs error has been already
% averaged for that column
AlloDataBlock = AlloDataBlock(~isnan(AlloDataBlock.MeanAbsError), :);

funcOmitNan = @(x) mean(x,"omitnan"); 
groupedMeans = varfun(funcOmitNan, AlloDataBlock, 'InputVariables', 'MeanAbsError', ...
                        'GroupingVariables', {'ParticipantID', 'ParticipantGroup', 'TrialType'});

clear funcOmitNan

%% ------ Pre - processing ------ 
% Prepare data for plotting by grouping by TrialType and Block
% Each TrialType will have three blocks of data
y_data = cell(2, 3); % 2 Groups x 3 Movement

for participantGroup = 1:2
    for trialType = 1:3
        y_data{participantGroup, trialType} = groupedMeans.Fun_MeanAbsError(...
            groupedMeans.ParticipantGroup == participantGroup & groupedMeans.TrialType == trialType);
    end
end

%%
% Initialize an empty array to store the flattened data
flattened_y_data = {};

% Flatten the data by concatenating across participant groups and trial types
for participantGroup = 1:2
    for trialType = 1:3
        flattened_y_data{end+1} = y_data{participantGroup, trialType};
    end
end

%% ------ Post Hoc ------
% Paired ttests (post hoc analysis, see SPSS output)

fprintf('Post-hoc comparison, young, same vs shifted-walking\n');
[h, p, ci, stats] = ttest(flattened_y_data{1}, flattened_y_data{2});
fprintf('t-Test Results: p-value = %.4f, CI = [%.4f, %.4f], t-stat = %.4f, df = %d\n\n', ...
        p, ci(1), ci(2), stats.tstat, stats.df);

fprintf('Post-hoc comparison, young, shifted-walking vs shifted-teleport\n');
[h, p, ci, stats] = ttest(flattened_y_data{2}, flattened_y_data{3});
fprintf('t-Test Results: p-value = %.4f, CI = [%.4f, %.4f], t-stat = %.4f, df = %d\n\n', ...
        p, ci(1), ci(2), stats.tstat, stats.df);

fprintf('Post-hoc comparison, young, same vs shifted-teleport\n');
[h, p, ci, stats] = ttest(flattened_y_data{1}, flattened_y_data{3});
fprintf('t-Test Results: p-value = %.4f, CI = [%.4f, %.4f], t-stat = %.4f, df = %d\n\n', ...
        p, ci(1), ci(2), stats.tstat, stats.df);

fprintf('Elderly mean values\n');
fprintf('Same viewpoint m = %.4f sd = %.4f \n', mean(flattened_y_data{4}), std(flattened_y_data{4}));
fprintf('Shifted viewpoint - walking m = %.4f sd = %.4f \n', mean(flattened_y_data{5}), std(flattened_y_data{5}));
fprintf('Shifted viewpoint - teleporting m = %.4f sd = %.4f \n', mean(flattened_y_data{6}), std(flattened_y_data{6}));

fprintf('Post-hoc comparison, elderly, same vs shifted-walking\n');
[h, p, ci, stats] = ttest(flattened_y_data{4}, flattened_y_data{5});
fprintf('t-Test Results: p-value = %.4f, CI = [%.4f, %.4f], t-stat = %.4f, df = %d\n\n', ...
        p, ci(1), ci(2), stats.tstat, stats.df);

fprintf('Post-hoc comparison, elderly, shifted-walking vs shifted-teleport\n');
[h, p, ci, stats] = ttest(flattened_y_data{5}, flattened_y_data{6});
fprintf('t-Test Results: p-value = %.4f, CI = [%.4f, %.4f], t-stat = %.4f, df = %d\n\n', ...
        p, ci(1), ci(2), stats.tstat, stats.df);

fprintf('Post-hoc comparison, elderly, same vs shifted-teleport\n');
[h, p, ci, stats] = ttest(flattened_y_data{4}, flattened_y_data{6});
fprintf('t-Test Results: p-value = %.4f, CI = [%.4f, %.4f], t-stat = %.4f, df = %d\n\n', ...
        p, ci(1), ci(2), stats.tstat, stats.df);

%% ------ Plotting section ------

% Colors and configuration
colors = {config.colorPalette.same_viewpoint, config.colorPalette.shifted_viewpoint_walk, config.colorPalette.shifted_viewpoint_teleport};  % Colors for scatter points
mean_color = config.colorPalette.GrayScale(4,:);
x_label = 'age group';
y_label = ['absolute distance error (m)'];
x_categories = {'young', 'elderly'};

% Horizontal lines for reference (optional)
hlines = [2.0, 4.0, 6.0];

% y-axis limits
ylims = [0, 6.0];

% Desired figure size
plotWidthInches = 6.0;  % Width in inches
plotHeightInches = 2.5; % Height in inches

dpi = 300;

% Create figure and set the size and background color to white
figure('Units', 'inches', 'Position', [1, 1, plotWidthInches, plotHeightInches], 'Color', 'white');

% Set paper size for saving in inches
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0, 0, plotWidthInches, plotHeightInches]);
set(gcf, 'PaperSize', [plotWidthInches, plotHeightInches]);
set(gcf, 'PaperPositionMode', 'auto');  % Ensure that the saved figure matches the on-screen size
hold on;

% Background color
set(gcf, 'Color', 'white');
set(gca, 'Color', 'white');

% Define the positions for the data: Each TrialType has three blocks, spaced closely

movement_condition_gap = 0.3; % Space between conditions within a group
group_gap = 1.2; % Space between groups

% Generate the base position for the first group
base_position = 1; % any starting point

positions_group1 = base_position + [0, movement_condition_gap, movement_condition_gap * 2]; 
positions_group2 = base_position + group_gap + [0, movement_condition_gap, movement_condition_gap * 2]; 

% Concatenate both sets of positions
actual_positions = [positions_group1, positions_group2];

% Add horizontal lines if any
if ~isempty(hlines)
    for i = 1:length(hlines)
        yline(hlines(i), '--', 'Color', [127, 127, 127] / 255, 'LineWidth', config.plotSettings.AxisLineWidth);
    end
end

% Violin plot (using kernel density estimation)
for i = 1:length(flattened_y_data)
    current_data = flattened_y_data{i};
    [f, xi] = kde(current_data, 'Bandwidth', 0.3, Support="nonnegative");
    f = f / max(f); % Normalize the density values
    f = 0.1 * f;   % Adjust the width of the violin
    % For visualization purposes
    cut_violin = xi <= 5.0;
    xi = xi(cut_violin);
    f = f(cut_violin);
    
    % Plot the violin
    fill([actual_positions(i) - f, fliplr(actual_positions(i) + f)], [xi, fliplr(xi)], 'k', ...
        'FaceAlpha', 0, 'EdgeColor', [40, 39, 36] / 255, 'LineWidth',  config.plotSettings.LineViolinWidth);
end

% Box plots
for i = 1:length(flattened_y_data)
    current_data = flattened_y_data{i};
    current_color = colors{mod(i-1, length(colors)) + 1};
    box_handle = boxplot(current_data, 'Positions', actual_positions(i), 'Widths', 0.15, ...
                         'Colors', current_color * 0.75, 'MedianStyle', 'line', ...
                         'OutlierSize', 0.1, 'Symbol', '', 'BoxStyle', 'outline');
    set(box_handle,{'linew'},{2})
end

% Scatter points
jitter_amount = 0.05;
scatter_handles = gobjects(1, 3);
for i = 1:length(flattened_y_data)
    current_data = flattened_y_data{i};
    jittered_x = actual_positions(i) + jitter_amount * randn(size(current_data));
    scatter_handles(mod(i-1, 3) + 1) = scatter(jittered_x, current_data, 60, 'MarkerFaceColor', colors{mod(i-1, length(colors)) + 1}, ...
        'MarkerEdgeColor', colors{mod(i-1, length(colors)) + 1}, 'MarkerFaceAlpha', 0.4, 'MarkerEdgeAlpha', 0.5);
end

% Means
for i = 1:length(flattened_y_data)
    current_data = flattened_y_data{i};
    mean_val = mean(current_data, 'omitnan');
    scatter(actual_positions(i), mean_val, 100, 'MarkerFaceColor', mean_color, ...
        'MarkerEdgeColor', 'k', 'LineWidth', config.plotSettings.LineWidth);
end

% Adding significance bars
yMax = 4.5;  
lineY = yMax + 0.1;  % Position for the line slightly below the yMax
textY = lineY + 0.2;  % Position for the 'n.s.' text slightly above the line

% Plot the main age effect results (please check the SPSS output)
line_x = [actual_positions(4),actual_positions(5)];
plot(line_x, [lineY, lineY], 'k-', 'LineWidth', 1.5);
text(mean(line_x), textY, '***', 'FontSize', 9, 'HorizontalAlignment', 'center');

yMax = 5.25;  
lineY = yMax + 0.1;  % Position for the line slightly below the yMax
textY = lineY + 0.2;  % Position for the 'n.s.' text slightly above the line

% Plot the main age effect results (please check the SPSS output)
line_x = [actual_positions(5),actual_positions(6)];
plot(line_x, [lineY, lineY], 'k-', 'LineWidth', 1.5);
text(mean(line_x), textY, '***', 'FontSize', 9, 'HorizontalAlignment', 'center');

% Set y-axis limits
ylim(ylims);

ax = gca;
ax.XAxis.LineWidth = config.plotSettings.AxisLineWidth;
ax.YAxis.LineWidth = config.plotSettings.AxisLineWidth;
ax.Title.String = '';
ax.FontName = config.plotSettings.FontName;
ax.FontSize = config.plotSettings.FontSize;
ax.Box = 'off';  % Remove top and right axes
ax.XColor = 'black'; % Set color for bottom X-axis
ax.YColor = 'black'; % Set color for left Y-axis

% Set labels
set(gca, 'XTick', [mean(actual_positions(1:3)), mean(actual_positions(4:6))], ...
    'XTickLabel', x_categories, ...
    'XLabel', text('String', x_label, 'FontSize', config.plotSettings.FontLabelSize, 'FontName', config.plotSettings.FontName), ...
    'YLabel', text('String', y_label, 'FontSize', config.plotSettings.FontLabelSize, 'FontName', config.plotSettings.FontName));

legend(scatter_handles, {'same-view', 'shifted-view (walk)', 'shifted-view (teleport)'}, 'Location', 'northwest', 'Box','off');

% Ensure the Output folder exists
outputFolder = 'Output';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Define the full paths for saving
pngFile = fullfile(outputFolder, 'movement_age_interaction_effect.png');
svgFile = fullfile(outputFolder, 'movement_age_interaction_effect.svg');
pdfFile = fullfile(outputFolder, 'movement_age_interaction_effect.pdf');

% Save the figure as PNG with the specified DPI
print(pngFile, '-dpng',  ['-r' num2str(dpi)]); % Save as PNG with specified resolution

% Save the figure as SVG with a tight layout
print(svgFile, '-dsvg'); % Save as SVG

% Save the figure as a PDF with high resolution (300 dpi)
print(pdfFile, '-dpdf', ['-r' num2str(dpi)]);

disp(['Figure saved as ' pngFile ' and ' svgFile ' and ' pdfFile]);

hold off;

%% Clearing the workspace
clearvars -except AlloData AlloData_Elderly_4MT HCData YCData AlloData_SPSS_Cond_Conf AlloData_SPSS_Cond_Conf_Block AlloData_SPSS_Cond_Conf_VirtualBlock config RetrievalTime
