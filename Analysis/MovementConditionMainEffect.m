AlloDataBlock = AlloData(:, {'ParticipantID', 'ParticipantGroup', 'TrialNumber', 'TrialType', 'ConfigurationType', 'MeanAbsError'});

% Remove rows with NaNs in MeanAbsError - this will automatically filter
% out the trials with 4 objects where the abs error has been already
% averaged for that column
AlloDataBlock = AlloDataBlock(~isnan(AlloDataBlock.MeanAbsError), :);

funcOmitNan = @(x) mean(x,"omitnan"); 
groupwiseMeans = varfun(funcOmitNan, AlloDataBlock, 'InputVariables', 'MeanAbsError', ...
                        'GroupingVariables', {'ParticipantID', 'TrialType'});

% Separate data by participant group
same_viewpoint_data = groupwiseMeans.Fun_MeanAbsError(groupwiseMeans.TrialType == 1);
shifted_viewpoint_walk_data = groupwiseMeans.Fun_MeanAbsError(groupwiseMeans.TrialType == 2);
shifted_viewpoint_teleport_data = groupwiseMeans.Fun_MeanAbsError(groupwiseMeans.TrialType == 3);

% Combine data into a cell array for ease of plotting
y_data = {same_viewpoint_data, shifted_viewpoint_walk_data, shifted_viewpoint_teleport_data};
x_categories = {'same-view', 'shifted-view (walk)', 'shifted-view (teleport)'};

%% ------ Plotting section ------ 
% Desired figure size
plotWidthInches = 3.85;  % Width in inches
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

% Positions for the data
positions = 1:length(y_data);

ylims = [0, 5.5];
hlines = [1,2,3,4,5];
colors = {config.colorPalette.same_viewpoint, config.colorPalette.shifted_viewpoint_walk, config.colorPalette.shifted_viewpoint_teleport};  % Colors for scatter points
x_label = 'movement condition';
y_label = 'absolute distance error (m)';

mean_color = config.colorPalette.GrayScale(4,:);

% Add horizontal lines if any
if ~isempty(hlines)
    for i = 1:length(hlines)
        yline(hlines(i), '--', 'Color', [127, 127, 127] / 255, 'LineWidth', config.plotSettings.AxisLineWidth);
    end
end

% Violin plot (using kernel density estimation)
for i = 1:length(y_data)
    [f, xi] = kde(y_data{i}, 'Bandwidth', 0.3, Support="nonnegative");
    f = f / max(f); % Normalize the density values
    f = 0.25 * f;   % Adjust the width of the violin

    % For visualization purposes
    cut_violin = xi <= 4.5;
    xi = xi(cut_violin);
    f = f(cut_violin);
    
    % Plot the violin
    fill([positions(i) - f, fliplr(positions(i) + f)], [xi, fliplr(xi)], 'k', ...
        'FaceAlpha', 0, 'EdgeColor', [40, 39, 36] / 255, 'LineWidth', config.plotSettings.LineViolinWidth);
end

% Box plots
for i = 1:length(y_data)
    box_handle = boxplot(y_data{i}, 'Positions', positions(i), 'Widths', 0.45, 'Colors', colors{i} * 0.75, ...
        'MedianStyle', 'line', 'OutlierSize', 0.1, 'Symbol', '', 'BoxStyle', 'outline');
    set(box_handle,{'linew'},{2})
end

% Scatter points
jitter_amount = 0.075;
for i = 1:length(y_data)
    jittered_x = positions(i) + jitter_amount * randn(size(y_data{i}));
    scatter(jittered_x, y_data{i}, 100, 'MarkerFaceColor', colors{i}, ...
        'MarkerEdgeColor', colors{i}, 'MarkerFaceAlpha', 0.3, 'MarkerEdgeAlpha', 0.6);
end

% Means
for i = 1:length(y_data)
    mean_val = mean(y_data{i});
    scatter(positions(i), mean_val, 100, 'MarkerFaceColor', mean_color, ...
        'MarkerEdgeColor', 'k', 'LineWidth', config.plotSettings.LineWidth);
    % plot([positions(i), positions(i) + 0.25], [mean_val, mean_val], ...
    %     'k-.', 'LineWidth', 1.2);
    % text(positions(i) + 0.25, mean_val, sprintf('\\mu_{mean} = %.2f', mean_val), ...
    %     'FontSize', 13, 'VerticalAlignment', 'middle', ...
    %     'BackgroundColor', 'w', 'EdgeColor', 'k', 'Margin', 1);
end

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

yMax = 4.5;  % Get the maximum y value from the y-axis limit
lineY = yMax + 0.1;  % Position for the line slightly below the yMax
textY = lineY + 0.2;  % Position for the 'n.s.' text slightly above the line

% Plot the main age effect results (please check the SPSS output)
line_x = [1,2.5];
plot(line_x, [lineY, lineY], 'k-', 'LineWidth', 1.5);
text(mean(line_x), textY, '***', 'FontSize', 9, 'HorizontalAlignment', 'center');

yMax = yMax + 0.4;  % Get the maximum y value from the y-axis limit
lineY = yMax + 0.1;  % Position for the line slightly below the yMax
textY = lineY + 0.2;  % Position for the 'n.s.' text slightly above the line

% Plot the main age effect results (please check the SPSS output)
line_x = [2,3];
plot(line_x, [lineY, lineY], 'k-', 'LineWidth', 1.5);
text(mean(line_x), textY, '***', 'FontSize', 9, 'HorizontalAlignment', 'center');

% Set labels
set(gca, 'XTick', positions, 'XTickLabel', x_categories, 'XLabel', text('String', x_label, 'FontSize', config.plotSettings.FontLabelSize), ...
    'YLabel', text('String', y_label, 'FontSize', config.plotSettings.FontLabelSize));

ax.XAxis.FontSize = config.plotSettings.FontSize-2;
ax.XLabel.FontSize =  config.plotSettings.FontLabelSize;
% Ensure the Output folder exists
outputFolder = 'Output';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Define the full paths for saving
pngFile = fullfile(outputFolder, 'movementconditionmaineffect.png');
svgFile = fullfile(outputFolder, 'movementconditionmaineffect.svg');
pdfFile = fullfile(outputFolder, 'movementconditionmaineffect.pdf');

% Save the figure as PNG with the specified DPI
print(pngFile, '-dpng',  ['-r' num2str(dpi)]); % Save as PNG with specified resolution

% Save the figure as SVG with a tight layout
print(svgFile, '-dsvg'); % Save as SVG

% Save the figure as a PDF with high resolution (300 dpi)
print(pdfFile, '-dpdf', ['-r' num2str(dpi)]);

disp(['Figure saved as ' pngFile ', ' svgFile, ' and ', pdfFile]);

hold off;

%% Clearing the workspace
clearvars -except AlloData AlloData_Elderly_4MT HCData YCData AlloData_SPSS_Cond_Conf AlloData_SPSS_Cond_Conf_Block AlloData_SPSS_Cond_Conf_VirtualBlock config RetrievalTime
