AlloDataBlock = AlloData(:, {'ParticipantID', 'ParticipantGroup', 'TrialNumber', 'TrialType', 'ConfigurationType', 'MeanAbsError'});

% Remove rows with NaNs in MeanAbsError - this will automatically filter
% out the trials with 4 objects where the abs error has been already
% averaged for that column
AlloDataBlock = AlloDataBlock(~isnan(AlloDataBlock.MeanAbsError), :);

% Create the block column
AlloDataBlock.Block = arrayfun(@(x) floor((x - 1) / 10) + 1, AlloDataBlock.TrialNumber);

% Calculating the block-wise mean for each participant
funcOmitNan = @(x) mean(x,"omitnan"); 
groupedMeans = varfun(funcOmitNan, AlloDataBlock, 'InputVariables', 'MeanAbsError', ...
                        'GroupingVariables', {'ParticipantID', 'TrialType', 'Block'});

%% 
% Prepare data for plotting by grouping by TrialType and Block
% Each TrialType will have three blocks of data
y_data = cell(3, 3); % 3 TrialTypes x 3 Blocks

for trialType = 1:3
    for block = 1:3
        y_data{trialType, block} = groupedMeans.Fun_MeanAbsError(...
            groupedMeans.TrialType == trialType & groupedMeans.Block == block);
        
        % Get the participants in this block
        participants_block = groupedMeans.ParticipantID(...
            groupedMeans.TrialType == trialType & groupedMeans.Block == block);
        
        % Get the participants in the reference block
        participants_reference_block = groupedMeans.ParticipantID(...
            groupedMeans.TrialType == trialType & groupedMeans.Block == 1);
        
        % Find the missing participants by comparing with the reference block
        missing_participants = setdiff(participants_reference_block, participants_block);
        
        % Append NaN for each missing participant to ensure consistent data size
        for p = 1:length(missing_participants)
            y_data{trialType, block} = [y_data{trialType, block}; NaN];
        end
    end
end

% Flatten the data to plot
flattened_y_data = [y_data{1, :}, y_data{2, :}, y_data{3, :}];

% Colors and configuration
colors = {config.colorPalette.GrayScaleThreePoints(1,:), config.colorPalette.GrayScaleThreePoints(2,:), config.colorPalette.GrayScaleThreePoints(3,:)};
mean_color = config.colorPalette.GrayScale(4,:);
x_label = 'movement condition';
y_label = 'absolute distance error (m)';
x_categories = {'same-view', 'shifted-view (walk)', 'shifted-view (teleport)'};

% Horizontal lines for reference (optional)
hlines = [2.0, 4.0, 6.0];

% y-axis limits
ylims = [0, 8.0];

%% ------ Plotting section ------ 
% Desired figure size
plotWidthInches = 5.0;  % Width in inches
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
positions = 1:9;
block_gap = 0.25; % Space between blocks
trialtype_gap = 0.75; % Space between TrialTypes

% Calculate the actual positions with gaps
actual_positions = [positions(1:3) + (0 * (block_gap + trialtype_gap)), ...
                    positions(4:6) + (1 * (block_gap + trialtype_gap)), ...
                    positions(7:9) + (2 * (block_gap + trialtype_gap))];


% Add horizontal lines if any
if ~isempty(hlines)
    for i = 1:length(hlines)
        yline(hlines(i), '--', 'Color', [127, 127, 127] / 255, 'LineWidth', config.plotSettings.AxisLineWidth);
    end
end

% Violin plot (using kernel density estimation)
for i = 1:size(flattened_y_data, 2)
    [f, xi] = kde(flattened_y_data(:, i), 'Bandwidth', 0.3, Support="nonnegative");
    f = f / max(f); % Normalize the density values
    f = 0.4 * f;   % Adjust the width of the violin
    
    % Plot the violin
    fill([actual_positions(i) - f, fliplr(actual_positions(i) + f)], [xi, fliplr(xi)], 'k', ...
        'FaceAlpha', 0, 'EdgeColor', [40, 39, 36] / 255, 'LineWidth',  config.plotSettings.LineViolinWidth);
end

% Box plots
for i = 1:size(flattened_y_data, 2)
    box_handle = boxplot(flattened_y_data(:, i), 'Positions', actual_positions(i), 'Widths', 0.3, ...
                         'Colors', [116, 116, 115] / 255, 'MedianStyle', 'line', ...
                         'OutlierSize', 0.1, 'Symbol', '', 'BoxStyle', 'outline');
    set(box_handle,{'linew'},{2})
end

% Scatter points
jitter_amount = 0.075;
scatter_handles = gobjects(1, 3);
for i = 1:size(flattened_y_data, 2)
    jittered_x = actual_positions(i) + jitter_amount * randn(size(flattened_y_data(:, i)));
    scatter_handles(mod(i-1, 3) + 1) = scatter(jittered_x, flattened_y_data(:, i), 60, 'MarkerFaceColor', colors{mod(i-1,3)+1}, ...
        'MarkerEdgeColor', colors{mod(i-1,3)+1}, 'MarkerFaceAlpha', 0.4, 'MarkerEdgeAlpha', 0.5);
end

% Means
for i = 1:size(flattened_y_data, 2)
    mean_val = mean(flattened_y_data(:, i), 'omitnan');
    scatter(actual_positions(i), mean_val, 100, 'MarkerFaceColor', mean_color, ...
        'MarkerEdgeColor', 'k', 'LineWidth', config.plotSettings.LineWidth);
end

% Adding non-significant bar between Trial Type 3, Block 2 and Trial Type 3, Block 3
yMax = max(ylim);  % Get the maximum y value from the y-axis limit
lineY = yMax + 0.01;  % Position for the line slightly below the yMax
textY = yMax + 0.3;  % Position for the 'n.s.' text slightly above the line

% Plot the line between the two positions
plot([actual_positions(8), actual_positions(9)], [lineY, lineY], 'k-', 'LineWidth', 1.5);
text(mean([actual_positions(8), actual_positions(9)]), textY, 'n.s.', 'FontSize', 9, 'HorizontalAlignment', 'center');

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
set(gca, 'XTick', [mean(actual_positions(1:3)), mean(actual_positions(4:6)), mean(actual_positions(7:9))], ...
    'XTickLabel', x_categories, ...
    'XLabel', text('String', x_label, 'FontSize', config.plotSettings.FontLabelSize, 'FontName', config.plotSettings.FontName), ...
    'YLabel', text('String', y_label, 'FontSize', config.plotSettings.FontLabelSize, 'FontName', config.plotSettings.FontName));

legend(scatter_handles, {'Block 1', 'Block 2', 'Block 3'}, 'Location', 'northwest', 'Box','off');

% Ensure the Output folder exists
outputFolder = 'Output';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Define the full paths for saving
pngFile = fullfile(outputFolder, 'block_visualization_per_condition.png');
svgFile = fullfile(outputFolder, 'block_visualization_per_condition.svg');
pdfFile = fullfile(outputFolder, 'block_visualization_per_condition.pdf');


% Save the figure as PNG with the specified DPI
print(pngFile, '-dpng',  ['-r' num2str(dpi)]); % Save as PNG with specified resolution

% Save the figure as SVG with a tight layout
print(svgFile, '-dsvg'); % Save as SVG

print(pdfFile, '-dpdf',  ['-r' num2str(dpi)]); % Save as PDF with specified resolution


disp(['Figure saved as ' pngFile ' and ' svgFile ' and ' pdfFile]);

hold off;

%%
clearvars -except AlloData AlloData_Elderly_4MT HCData YCData AlloData_SPSS_Cond_Conf AlloData_SPSS_Cond_Conf_Block AlloData_SPSS_Cond_Conf_VirtualBlock config RetrievalTime
