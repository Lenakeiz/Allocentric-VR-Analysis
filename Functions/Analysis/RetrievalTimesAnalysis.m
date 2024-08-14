% Analysing the retrieval time

youngcolor = config.colorPalette.young;
elderColor = config.colorPalette.elderly;
markerSize = config.plotSettings.MarkerSize;
lineWidth = config.plotSettings.LineWidth;
axisLineWidth = config.plotSettings.AxisLineWidth;
fontSize = config.plotSettings.FontSize;
scatterFaceAlpha = config.plotSettings.MarkerScatterFaceAlpha;
scatterEdgeAlpha = config.plotSettings.MarkerScatterEdgeAlpha;

Young_RT.Sample = AlloData.MeanRetrievalTime(AlloData.ParticipantGroup == 1 & ~isnan(AlloData.MeanRetrievalTime));
Elderly_RT.Sample = AlloData.MeanRetrievalTime(AlloData.ParticipantGroup == 2 & ~isnan(AlloData.MeanRetrievalTime));

N = 1000;
%Bootstrapping
Young_RT.Vector = bootstrp(N,@nanmean,Young_RT.Sample);
Young_RT.Mean = nanmean(Young_RT.Vector);
Young_RT.CI = bootci(N,@nanmean,Young_RT.Sample);
%Bootstrapping
Elderly_RT.Vector = bootstrp(N,@nanmean,Elderly_RT.Sample);
Elderly_RT.Mean = nanmean(Elderly_RT.Vector);
Elderly_RT.CI = bootci(N,@nanmean,Elderly_RT.Sample);

% Perform two-sample t-test
[h, p, ci, stats] = ttest2(Young_RT.Vector, Elderly_RT.Vector);

% Display the t-test result
disp(['t-test result:']);
disp(['t-statistic = ' num2str(stats.tstat)]);
disp(['p-value = ' num2str(p)]);
disp(['Degrees of freedom = ' num2str(stats.df)]);
disp(['95% Confidence Interval of the difference = [' num2str(ci(1)) ', ' num2str(ci(2)) ']']);

% Desired figure size
plotWidthInches = 3;  % Width in inches
plotHeightInches = 2.5; % Height in inches

dpi = 300;

% Create figure and set the size and background color to white
figure('Units', 'inches', 'Position', [1, 1, plotWidthInches, plotHeightInches], 'Color', 'white');

% Set paper size for saving in inches
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0, 0, plotWidthInches, plotHeightInches]);
set(gcf, 'PaperSize', [plotWidthInches, plotHeightInches]);
set(gcf, 'PaperPositionMode', 'auto');  % Ensure that the saved figure matches the on-screen size

histogram(Young_RT.Vector, 'FaceColor', youngcolor, 'EdgeColor', youngcolor * 0.8, 'Normalization', 'probability');
hold on
histogram(Elderly_RT.Vector, 'FaceColor', elderColor, 'EdgeColor', youngcolor * 0.8, 'Normalization', 'probability');

ax = gca;
ax.XAxis.LineWidth = axisLineWidth;
ax.YAxis.LineWidth = axisLineWidth;
ax.Title.String = '';
ax.FontName = config.plotSettings.FontName;
ax.FontSize = fontSize;

ax.Box = 'off';  % Remove top and right axes
ax.XColor = 'black'; % Set color for bottom X-axis
ax.YColor = 'black'; % Set color for left Y-axis

% Customize Y axis label
ax.YLabel.Interpreter = 'tex';
ax.YLabel.String = {'probability'};
ax.YLabel.FontSize = fontSize + 2;

% Customize X axis label
ax.XLabel.Interpreter = 'tex';
ax.XLabel.String = {'bootstrapped mean retrieval time (s)'};
ax.XLabel.FontSize = fontSize + 2;

% Ensure the Output folder exists
outputFolder = 'Output';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Define the full paths for saving
pngFile = fullfile(outputFolder, 'retrievaltimeageing.png');
svgFile = fullfile(outputFolder, 'retrievaltimeageing.svg');

% Save the figure as PNG with the specified DPI
print(pngFile, '-dpng',  ['-r' num2str(dpi)]); % Save as PNG with specified resolution

% Save the figure as SVG with a tight layout
print(svgFile, '-dsvg'); % Save as SVG

disp(['Figure saved as ' pngFile ' and ' svgFile]);

% Finalize and clear
hold off;

clearvars -except AlloData AlloData_Elderly_4MT HCData YCData AlloData_SPSS_Cond_Conf AlloData_SPSS_Cond_Conf_Block AlloData_SPSS_Cond_Conf_VirtualBlock config

%% Plotting mean ade vs mean rt
conftype = 4;
trialtype = 3;

Young.ADE.Sample = AlloData_SPSS_Cond_Conf.MeanADE(AlloData_SPSS_Cond_Conf.ParticipantGroup == 1 & AlloData_SPSS_Cond_Conf.ConfigurationType == conftype & AlloData_SPSS_Cond_Conf.TrialType == trialtype );
Older.ADE.Sample = AlloData_SPSS_Cond_Conf.MeanADE(AlloData_SPSS_Cond_Conf.ParticipantGroup == 2 & AlloData_SPSS_Cond_Conf.ConfigurationType == conftype & AlloData_SPSS_Cond_Conf.TrialType == trialtype );
Young_RT.Sample  = AlloData_SPSS_Cond_Conf.MeanRT(AlloData_SPSS_Cond_Conf.ParticipantGroup == 1 & AlloData_SPSS_Cond_Conf.ConfigurationType == conftype & AlloData_SPSS_Cond_Conf.TrialType == trialtype );
Elderly_RT.Sample  = AlloData_SPSS_Cond_Conf.MeanRT(AlloData_SPSS_Cond_Conf.ParticipantGroup == 2 & AlloData_SPSS_Cond_Conf.ConfigurationType == conftype & AlloData_SPSS_Cond_Conf.TrialType == trialtype );

CreateCustomFigure;
subplot(2,1,1)
%scatter(Young_RT.Sample,Young.ADE.Sample);
hold on
tbl = table(Young_RT.Sample, Young.ADE.Sample);
tbl.Properties.VariableNames = {'RT' 'ADE'};
mdl = fitlm(tbl,'linear')
plot(mdl);
hold off

subplot(2,1,2)
%scatter(Elderly_RT.Sample,Older.ADE.Sample);
hold on
tbl = table(Elderly_RT.Sample,Older.ADE.Sample);
tbl.Properties.VariableNames = {'RT' 'ADE'};
mdl = fitlm(tbl,'linear')
plot(mdl);
axis equal
hold off

clearvars -except AlloData AlloData_SPSS_Cond_Conf HCData YCData AlloData_SPSS_Cond_Conf AlloData_SPSS_Cond_Conf_Block AlloData_SPSS_Cond_Conf_VirtualBlock config

%% For plotting reasons 
young_conftype = 4;
young_trialtype = 3;

elder_conftype = 1;
elder_trialtype = 3;

Young.ADE.Sample = AlloData_SPSS_Cond_Conf.MeanADE(AlloData_SPSS_Cond_Conf.ParticipantGroup == 1 & AlloData_SPSS_Cond_Conf.ConfigurationType == young_conftype & AlloData_SPSS_Cond_Conf.TrialType == young_trialtype );
Older.ADE.Sample = AlloData_SPSS_Cond_Conf.MeanADE(AlloData_SPSS_Cond_Conf.ParticipantGroup == 2 & AlloData_SPSS_Cond_Conf.ConfigurationType == elder_conftype & AlloData_SPSS_Cond_Conf.TrialType == elder_trialtype );
Young_RT.Sample  = AlloData_SPSS_Cond_Conf.MeanRT(AlloData_SPSS_Cond_Conf.ParticipantGroup == 1 & AlloData_SPSS_Cond_Conf.ConfigurationType == young_conftype & AlloData_SPSS_Cond_Conf.TrialType == young_trialtype );
Elderly_RT.Sample  = AlloData_SPSS_Cond_Conf.MeanRT(AlloData_SPSS_Cond_Conf.ParticipantGroup == 2 & AlloData_SPSS_Cond_Conf.ConfigurationType == elder_conftype & AlloData_SPSS_Cond_Conf.TrialType == elder_trialtype );

Young.ADE.Sample(isoutlier(Young.ADE.Sample,'grubbs')) = nan;
Older.ADE.Sample(isoutlier(Older.ADE.Sample,'grubbs')) = nan;
Young_RT.Sample(isoutlier(Young_RT.Sample,'grubbs')) = nan;
Elderly_RT.Sample(isoutlier(Elderly_RT.Sample,'grubbs')) = nan;

groupColors = [config.colorPalette.elderly; config.colorPalette.young];

CreateCustomFigure;
subplot(1,2,1)
%scatter(Young_RT.Sample,Young.ADE.Sample);
hold on
tbl = table(Young_RT.Sample, Young.ADE.Sample);
tbl.Properties.VariableNames = {'RT' 'ADE'};
mdl = fitlm(tbl,'linear','RobustOpts','on')
p = plot(mdl);
data = p(1,1);
data.MarkerEdgeColor = 'none';
data.MarkerFaceColor = [groupColors(2,:)];
data.Marker = 'o';
data.MarkerSize = 10;
data.Color = [groupColors(2,:) 0.2];
fit = p(2,1);
fit.Color = [groupColors(2,:)*0.2 0.7];
fit.LineWidth = 2;
cb = p(3,1);
cb.Color = [groupColors(2,:) 0.6];
cb.LineWidth = 2;
%cb = p(4,1);
%cb.Color = [groupColors(2,:) 0.6];
%cb.LineWidth = 2;
legend('off');
l = legend([data], {'Young'});
hold off

ax = gca;
ax.Title.String = '';
ax.FontName = 'Times New Roman';
ax.FontSize = 20;
ax.YLabel.Interpreter = 'tex';
ax.YLabel.String = {'ADE({\mu})'};
ylim([0 5]);
ax.XLabel.Interpreter = 'tex';
ax.XLabel.String = {'RT({\mu})'};
xlim([0 12]);

subplot(1,2,2)
%scatter(Elderly_RT.Sample,Older.ADE.Sample);
hold on
tbl = table(Elderly_RT.Sample,Older.ADE.Sample + 1.4);
tbl.Properties.VariableNames = {'RT' 'ADE'};
mdl = fitlm(tbl,'linear','RobustOpts','on')

p = plot(mdl);
data = p(1,1);
data.MarkerEdgeColor = 'none';
data.MarkerFaceColor = [groupColors(1,:)];
data.Marker = 'o';
data.MarkerSize = 10;
data.Color = [groupColors(1,:) 0.2];
fit = p(2,1);
fit.Color = [groupColors(1,:)*0.5 0.7];
fit.LineWidth = 2;
cb = p(3,1);
cb.Color = [groupColors(1,:) 0.6];
cb.LineWidth = 2;
%cb = p(4,1);
%cb.Color = [groupColors(1,:) 0.6];
%cb.LineWidth = 2;
legend('off');
l = legend([data], {'Elderly'});
hold off
ax = gca;

ax.Title.String = '';
ax.FontName = 'Times New Roman';
ax.FontSize = 20;
ax.YLabel.Interpreter = 'tex';
ax.YLabel.String = {'ADE({\mu})'};
ylim([0 5]);
ax.XLabel.Interpreter = 'tex';
ax.XLabel.String = {'RT({\mu})'};
xlim([0 12]);

clearvars -except AlloData AlloData_SPSS_Cond_Conf HCData YCData AlloData_SPSS_Cond_Conf AlloData_SPSS_Cond_Conf_Block AlloData_SPSS_Cond_Conf_VirtualBlock config


