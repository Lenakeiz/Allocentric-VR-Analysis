VisualizeRadialPlot(AlloData,1,config, true)
%%
VisualizeRadialPlot(AlloData,1,config, false,'trialtype',3)


%%
function [] = VisualizeRadialPlot(AlloData,objectConf,config,displayLegend,varargin)

arg=1;
% Preinitialize the variables
trialType = NaN;
while arg<=length(varargin)
    switch lower(varargin{arg})
        case {'trialtype','type','transparency'}
            trialType = varargin{arg+1}; arg=arg+1;
        case 'another_option...'
            % Option functionality..
    end
    arg = arg+1;
end

% Used for plotting 
youngColor = config.colorPalette.young;
elderColor = config.colorPalette.elderly;
darkYoungColor = config.colorPalette.darkYoung;
darkElderlyColor = config.colorPalette.darkElderly;
markerSize = config.plotSettings.MarkerScatterSize;
lineWidth = config.plotSettings.LineWidth - 0.5;
axisLineWidth = config.plotSettings.AxisLineWidth;
fontSize = config.plotSettings.FontSize;
scatterFaceAlpha = config.plotSettings.MarkerScatterFaceAlpha - 0.7;
scatterEdgeAlpha = config.plotSettings.MarkerScatterEdgeAlpha - 0.4;
fontTitle = config.plotSettings.FontTitleSize;
fontName = config.plotSettings.FontName;

% Shuffle and bootstrap for calculating the chance distribution
if(~isnan(trialType))
    [bsRandY,bsSampleY,bsTtestY] = ChanceCalculation(AlloData,1,'conftype', objectConf, 'trialtype', trialType);
else
    [bsRandY,bsSampleY,bsTtestY] = ChanceCalculation(AlloData,1,'conftype', objectConf);
end

if(~isnan(trialType))
    [bsRandE,bsSampleE,bsTtestE] = ChanceCalculation(AlloData,2,'conftype', objectConf, 'trialtype', trialType);
else
    [bsRandE,bsSampleE,bsTtestE] = ChanceCalculation(AlloData,2,'conftype', objectConf);
end

% Display summary in the command window
fprintf('Summary for Young, Object Conf %d\n', objectConf);
if ~isnan(trialType)
    fprintf('Trial Type: %d\n', trialType);
end
fprintf('Chance Distribution (young): Mean = %.4f, CI = [%.4f, %.4f]\n', bsRandY.Mean, bsRandY.CI(1), bsRandY.CI(2));
fprintf('Starting Distribution (young): Mean = %.4f, CI = [%.4f, %.4f]\n\n', bsSampleY.Mean, bsSampleY.CI(1), bsSampleY.CI(2));
fprintf('t-Test Results (young): p-value = %.4f, CI = [%.4f, %.4f], t-stat = %.4f, df = %d\n\n', ...
        bsTtestY.p, bsTtestY.ci(1), bsTtestY.ci(2), bsTtestY.stats.tstat, bsTtestY.stats.df);


% Display summary in the command window
fprintf('Summary for Elderly, Object Conf %d\n', objectConf);
if ~isnan(trialType)
    fprintf('Trial Type: %d\n', trialType);
end
fprintf('Chance Distribution (elderly): Mean = %.4f, CI = [%.4f, %.4f]\n', bsRandE.Mean, bsRandE.CI(1), bsRandE.CI(2));
fprintf('Starting Distribution (elderly): Mean = %.4f, CI = [%.4f, %.4f]\n\n', bsSampleE.Mean, bsSampleE.CI(1), bsSampleE.CI(2));
fprintf('t-Test Results (elderly): p-value = %.4f, CI = [%.4f, %.4f], t-stat = %.4f, df = %d\n\n', ...
        bsTtestE.p, bsTtestE.ci(1), bsTtestE.ci(2), bsTtestE.stats.tstat, bsTtestE.stats.df);

theta = linspace(0,2 * pi);
alphaChance = 0.3;
multiplierForCircularSectors = 1.5;

% Desired figure size
plotWidthInches = 3.5;  % Width in inches
plotHeightInches = 2.5; % Height in inches

dpi = 300;

% Create figure and set the size and background color to white
figure('Units', 'inches', 'Position', [1, 1, plotWidthInches, plotHeightInches], 'Color', 'white');

% Set paper size for saving in inches
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0, 0, plotWidthInches, plotHeightInches]);
set(gcf, 'PaperSize', [plotWidthInches, plotHeightInches]);
set(gcf, 'PaperPositionMode', 'auto');  % Ensure that the saved figure matches the on-screen size

%% --- Young plot ---
subplot(1,2,1);

ps = polarscatter(bsSampleY.OriginalAngles,bsSampleY.OriginalSample,markerSize);
ps.MarkerEdgeColor = youngColor;
ps.MarkerEdgeAlpha = scatterEdgeAlpha;
ps.MarkerFaceColor = youngColor;
ps.MarkerFaceAlpha = scatterFaceAlpha;

hold on;

% Add CI
pol_reg = polarregion([0 2* pi],[bsSampleY.CI(1) bsSampleY.CI(2)]);
pol_reg.FaceColor = youngColor;
pol_reg.FaceAlpha = 0.6;

% mean of the sample distribution
rho = ones(1,size(theta,2)).*(bsSampleY.Mean);
line_mean_young = polarplot(theta, rho);
line_mean_young.Color =  youngColor;
line_mean_young.LineWidth = lineWidth;

% Add CI
pol_reg = polarregion([0 2* pi],[bsRandY.CI(1) bsRandY.CI(2)]);
pol_reg.FaceColor = darkYoungColor;
pol_reg.FaceAlpha = 0.6;

% chance distribution line rand line
rho = ones(1,size(theta,2)).*(bsRandY.Mean);
line_chance_young = polarplot(theta, rho);
line_chance_young.Color = [darkYoungColor 0.8];
line_chance_young.LineWidth = lineWidth;

hold off;

% Lock the position of the first subplot
set(gca, 'Position', get(gca, 'Position'));

ax = gca;
ax.FontName = config.plotSettings.FontName;
ax.FontSize = fontSize;
ax.ThetaAxisUnits = 'radians';
rlim([0 6]);
rticks([0 2 4 6]);
rticklabels({'0m','2m','4m'});
ax.RAxis.TickLabels = {'' '2m' '4m'};
ax.RAxis.FontSize = fontSize;
ax.ThetaAxis.TickLabels = {'0' '\pi/6' '\pi/3' '\pi/2' '2\pi/3' '5\pi/6' '\pi' '7\pi/6' '4\pi/3' '3\pi/2' '5\pi/3' '11\pi/6'};
ax.ThetaAxis.FontSize = fontSize;
%% --- Elderly plot ---
subplot(1,2,2);

ps = polarscatter(bsSampleE.OriginalAngles,bsSampleE.OriginalSample, markerSize);
ps.MarkerEdgeColor = elderColor;
ps.MarkerEdgeAlpha = scatterEdgeAlpha;
ps.MarkerFaceColor = elderColor;
ps.MarkerFaceAlpha = scatterFaceAlpha;

hold on;

% Add CI
pol_reg = polarregion([0 2* pi],[bsSampleE.CI(1) bsSampleE.CI(2)]);
pol_reg.FaceColor = elderColor;
pol_reg.FaceAlpha = 0.6;

% mean of the sample distribution
rho = ones(1,size(theta,2)).*(bsSampleE.Mean);
line_mean_elderly = polarplot(theta, rho);
line_mean_elderly.Color =  elderColor;
line_mean_elderly.LineWidth = lineWidth;

% Add CI
pol_reg = polarregion([0 2* pi],[bsRandE.CI(1) bsRandE.CI(2)]);
pol_reg.FaceColor = darkElderlyColor;
pol_reg.FaceAlpha = 0.6;

% chance distribution line rand line
rho = ones(1,size(theta,2)).*(bsRandE.Mean);
line_chance_elderly = polarplot(theta, rho);
line_chance_elderly.Color = [darkElderlyColor 0.8];
line_chance_elderly.LineWidth = lineWidth;

hold off;

% Lock the position of the subplot
set(gca, 'Position', get(gca, 'Position'));

ax = gca;
ax.FontName = config.plotSettings.FontName;
ax.FontSize = fontSize;
ax.ThetaAxisUnits = 'radians';
rlim([0 6]);
rticks([0 2 4 6]);
rticklabels({'0m','2m','4m'});
ax.RAxis.TickLabels = {'' '2m' '4m'};
ax.ThetaAxis.TickLabels = {'0' '\pi/6' '\pi/3' '\pi/2' '2\pi/3' '5\pi/6' '\pi' '7\pi/6' '4\pi/3' '3\pi/2' '5\pi/3' '11\pi/6'};

if (displayLegend == true)
    leg = legend([line_mean_young line_chance_young line_mean_elderly line_chance_elderly],{'Young' 'Chance (Young)' 'Elderly' 'Chance (Elderly)'});

    % Set the position of the legend manually
    leg.Position = [0.85 0.85 0.1 0.1];
    leg.Box = 'off';
    
    % Ensure the legend does not affect the subplot layout
    set(leg, 'Units', 'normalized');
end

if(~isnan(trialType))
    trialTitle = '';
    if(trialType == 1)
        trialTitle = 'same-view';
    elseif (trialType == 2)
        trialTitle = 'shifted-view (walk)';
    elseif (trialType == 3)
        trialTitle = 'shifted-view (teleport)';
    end
    figTitle = [num2str(objectConf) ' object - ' trialTitle];    
else
    figTitle = [num2str(objectConf) ' object'];
end

sgt = sgtitle(figTitle);
sgt.FontName = fontName;
sgt.FontSize = fontTitle;

% Ensure the Output folder exists
outputFolder = 'Output';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

if(~isnan(trialType))
    pngFile = fullfile(outputFolder, ['chance_obj_' num2str(objectConf) '_type_' num2str(trialType) '.png']);
    svgFile = fullfile(outputFolder, ['chance_obj_' num2str(objectConf) '_type_' num2str(trialType) '.svg']);
    pdfFile = fullfile(outputFolder, ['chance_obj_' num2str(objectConf) '_type_' num2str(trialType) '.pdf']);
else
    pngFile = fullfile(outputFolder, ['chance_obj_' num2str(objectConf) '.png']);
    svgFile = fullfile(outputFolder, ['chance_obj_' num2str(objectConf) '.svg']);
    pdfFile = fullfile(outputFolder, ['chance_obj_' num2str(objectConf) '.pdf']);
end

% Save the figure as PNG with the specified DPI
print(pngFile, '-dpng',  ['-r' num2str(dpi)]); % Save as PNG with specified resolution

% Save the figure as SVG with a tight layout
print(svgFile, '-dsvg'); % Save as SVG

% Save the figure as SVG with a tight layout
print(pdfFile, '-dpdf', ['-r' num2str(dpi)]); % Save as SVG

disp(['Figure saved as ' pngFile ' and ' svgFile ' and ' pdfFile]);

end

%% 
function [bsRand,bsSample,bsTtest] = ChanceCalculation(Data,pGroup,varargin)
% Calculating the chance distribution after shuffling retrieval position
% and trial index and applying bootstrapping for calculating the mean
% chance distance and 95% ci
% bsRand is the shuffled vector
% bsSample is the bootstrap from data
% bsTtest is the test statistics.

objectConf = 1;
trialType = NaN;

arg=1;
    while arg<=length(varargin)
        switch lower(varargin{arg})
            case {'objects','conftype','configurationtype'}
                objectConf = varargin{arg+1}; arg=arg+1;
            case {'trialtype','type','transparency'}
                trialType = varargin{arg+1}; arg=arg+1;
            case 'another_option...'
                % Option functionality..
        end
        arg = arg+1;
    end

% Filtering data based on the group and the optional parameters,
% configuration type and the tryal type
if( ~(isnan(trialType)) )
    selectedData = Data(Data.ParticipantGroup == pGroup & Data.ConfigurationType == objectConf & Data.TrialType == trialType,:);
else
    selectedData = Data(Data.ParticipantGroup == pGroup & Data.ConfigurationType == objectConf,:);
end

%Index shuffle
l = length(selectedData.AbsError);
N = 1000;
rng('default'); %Just for debugging reasons
indices = randi(l,l,N);

bootStrapData = sqrt((selectedData.RegX(indices) - selectedData.X).^2 + (selectedData.RegZ(indices) - selectedData.Z).^2);

%Using the mean of the shuffled as a bootstrab population
bsRand.Vector = nanmean(bootStrapData)';
bsRand.Mean = nanmean(bsRand.Vector);
standardErrorOfTheMean = std(bsRand.Vector)/sqrt(length(bsRand.Vector));            
standardDeviation = std(bsRand.Vector);
ts = tinv([0.025  0.975],length(bsRand.Vector)-1);
bsRand.CI = bsRand.Mean + ts*standardDeviation; 

bsSample.OriginalSample = selectedData.AbsError; 
bsSample.OriginalAngles = selectedData.Angles;
bsSample.Vector = bootstrp(N,@nanmean,selectedData.AbsError);
bsSample.Mean = nanmean(bsSample.Vector);
bsSample.CI = bootci(N,@nanmean,selectedData.AbsError);

[~,bsTtest.p,bsTtest.ci,bsTtest.stats] = ttest2(bsRand.Vector,bsSample.Vector);

end
