function VisualizeBlockData(AlloData, varargin)

%% Parse optional arguments
objectConf = nan;
jitter = 0.5;
jitterFromUnit = 0.3;
trialType = 3;
plotTitle = 'Absolute Distance Error';

groupColors = cbrewer('div', 'RdBu', 5);

arg=1;
    while arg<=length(varargin)
        switch lower(varargin{arg})
            case {'objects','conftype','configurationtype'}
                objectConf = varargin{arg+1}; arg=arg+1;
                plotTitle = [plotTitle ' - ' num2str(objectConf) ' obj'];
            case {'jitter','jitt'}
                jitter = varargin{arg+1}; arg=arg+1;
            case {'jitterunit','jittunit'}
                jitterFromUnit = varargin{arg+1}; arg=arg+1;
            case {'trialtype','type','transparency'}
                trialType = varargin{arg+1}; arg=arg+1;
            case 'line_width'
                LW = varargin{arg+1}; arg=arg+1;
            case 'another_option...'
                % Option functionality..
        end
        arg = arg+1;
    end

    addTitle = '';
    switch trialType
        case 1
            addTitle = 'Egocentric';
        case 2
            addTitle = 'Allocentric(walk)';
        case 3
            addTitle = 'Allocentric(teleport)';
    end
    
    plotTitle = [plotTitle ' - ' addTitle];
    
    CreateCustomFigure;

    %Young
    yErr = [];
    conds = [];
    for i = 1 : 3
        tmpErr = [AlloData.AbsError(AlloData.ParticipantGroup == 1 & AlloData.TrialType == trialType & AlloData.ConfigurationType == objectConf & AlloData.TrialNumber > (10 * (i-1)) & AlloData.TrialNumber < ((10 * i) + 1) )];
        yErr = [yErr;tmpErr];
        conds = [conds ; ones(size(tmpErr,1),1) * i - jitterFromUnit];
    end
    
    plotone = notBoxPlot(yErr,conds, 'jitter', jitter, 'interval', 'tInterval'); hold on;
            
    for ii=1:length(plotone)
        plotone(ii).semPtch.FaceAlpha = 0.8;
        plotone(ii).sdPtch.FaceAlpha = 0.8;
        plotone(ii).data.MarkerFaceColor = [0.65 0.65 0.65];
        plotone(ii).data.MarkerFaceAlpha = 0.3;    
        plotone(ii).data.MarkerEdgeColor = [0.5 0.5 0.5];
        plotone(ii).data.MarkerEdgeAlpha = 0.6;
        plotone(ii).sdPtch.FaceColor = groupColors(5,:);
        plotone(ii).sdPtch.EdgeColor = 'none';
        plotone(ii).semPtch.FaceColor = groupColors(5,:) * 0.5;
        plotone(ii).semPtch.EdgeColor = 'none';
        plotone(ii).mu.Color = [0 0 0];
        plotone(ii).data.MarkerFaceColor = groupColors(5,:) * 0.7;
        plotone(ii).data.MarkerFaceAlpha = 0.5;
    end   
    
    %Old
    yErr = [];
    conds = [];
    for i = 1 : 3
        tmpErr = [AlloData.AbsError(AlloData.ParticipantGroup == 2 & AlloData.TrialType == trialType & AlloData.ConfigurationType == objectConf & AlloData.TrialNumber > (10 * (i-1) ) & AlloData.TrialNumber < (10 * i + 1) )];
        yErr = [yErr;tmpErr];
        conds = [conds ; ones(size(tmpErr,1),1) * i + jitterFromUnit];
    end
    
    plotwo = notBoxPlot(yErr,conds, 'jitter', jitter); hold on;
    
    for ii=1:length(plotwo)
        plotwo(ii).semPtch.FaceAlpha = 0.8;
        plotwo(ii).sdPtch.FaceAlpha = 0.8;
        plotwo(ii).data.MarkerFaceColor = [0.65 0.65 0.65];
        plotwo(ii).data.MarkerFaceAlpha = 0.3;    
        plotwo(ii).data.MarkerEdgeColor = [0.5 0.5 0.5];
        plotwo(ii).data.MarkerEdgeAlpha = 0.6;
        plotwo(ii).sdPtch.FaceColor = groupColors(1,:);
        plotwo(ii).sdPtch.EdgeColor = 'none';
        plotwo(ii).semPtch.FaceColor = groupColors(1,:) * 0.5;
        plotwo(ii).semPtch.EdgeColor = 'none';
        plotwo(ii).mu.Color = [0 0 0];
        plotwo(ii).data.MarkerFaceColor = groupColors(1,:) * 0.7;
        plotwo(ii).data.MarkerFaceAlpha = 0.5;
    end   
    
    ax = gca;
    ax.FontName = 'Times New Roman';
    ax.FontSize = 25;
    
    ax.YLabel.String = 'Metres';
    ax.YLabel.FontSize =  28;
    
    ax.XAxis.TickValues = [1 2 3];
    ax.XAxis.TickLabels = {'1', '2', '3'};
    ax.XAxis.FontSize = 22;
    
    ax.XLabel.String = 'Block #';
    ax.XLabel.FontSize =  28;
    
    title(plotTitle);
    ax.Title.FontSize = 30;
    
    leg = legend( [plotone(1).sdPtch plotwo(1).sdPtch] , 'Young', 'Old');
    leg.FontSize = 28;
    
    hold off;
    
end