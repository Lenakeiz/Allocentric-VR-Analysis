%Calculating means per block per participant
CreateCustomFigure;

jitter = 0.3;
jitterfromUnit = 0.2;

tempData = AlloData_SPSS_Cond_Conf(:,[1 2 3 4 5]);
%tempData.MeanADE = log(tempData.MeanADE);

configs = [1 4];

for kk = 1:2
    for i = 1:2
        for j = 1:3
            tempDataBlock = tempData(tempData.TrialType == j & tempData.ParticipantGroup == i & tempData.ConfigurationType == configs(kk),:);
            aarray = accumarray(tempDataBlock.ParticipantID,tempDataBlock.MeanADE, [], @nanmean);
            aarray(aarray==0) = nan;
            aarray(any(isnan(aarray),2), :) = [];
            [B,TF] = rmoutliers(aarray,'mean');
            dataStruct{i}{j} = B;
        end
    end
    
    subplot(1,2,kk)
    spacing = [-jitterfromUnit jitterfromUnit];
    
    %Just for calculating with helmert contrasts the means
    for i = 1:2
        dataPlot{i} = [dataStruct{i}{1};dataStruct{i}{2};dataStruct{i}{3}];
        blocks{i} = [ones(size(dataStruct{i}{1},1),1) + spacing(i);ones(size(dataStruct{i}{2},1),1)*2 + spacing(i) ;ones(size(dataStruct{i}{3},1),1)*3 + spacing(i)];
        [meanContrasts{i}, stdContrasts{i}] = grpstats(dataPlot{i},blocks{i},{'mean','std'})
    end
    
    %1 is elder, 2 is young, 4 is chance
    groupColors = cbrewer('qual', 'Set1', 6);
    groupColors = groupColors([2 1],:);
    
    %
    %subplot(1,3,3)
    
    for i = 1:2
        plotone{i} = notBoxPlot(dataPlot{i},blocks{i}, 'jitter', jitter, 'interval', 'tInterval'); hold on;
        
        for ii=1:length(plotone{i})
            
            plotone{i}(ii).semPtch.FaceAlpha = 0.8;
            plotone{i}(ii).sdPtch.FaceAlpha = 0.8;
            plotone{i}(ii).sdPtch.FaceColor = groupColors(i,:);
            plotone{i}(ii).sdPtch.EdgeColor = 'none';
            plotone{i}(ii).semPtch.FaceColor = groupColors(i,:) * 0.5;
            plotone{i}(ii).semPtch.EdgeColor = 'none';
            plotone{i}(ii).mu.Color = [0 0 0];
            plotone{i}(ii).mu.LineWidth = 5;
            plotone{i}(ii).data.SizeData = 250;
            plotone{i}(ii).data.MarkerEdgeColor = groupColors(i,:);
            plotone{i}(ii).data.MarkerEdgeAlpha = 0.5;
            plotone{i}(ii).data.MarkerFaceColor = groupColors(i,:) * 0.7;
            plotone{i}(ii).data.MarkerFaceAlpha = 0.5;
            
        end
    end
    
    xlim([0.5 3.5]);
    ylim([0 5]);
    
    %H=sigstar([2 3],0.001);
    %H{1}{1}.LineWidth = 5;
    %H{1}{2}.FontSize = 50;
    
    %xlim([0.5 3.5]);
    %ylim([0 5]);
    
    hold off;
    
    ax = gca;
    ax.XAxis.LineWidth = 8;
    ax.YAxis.LineWidth = 8;
    
    ax.FontName = 'Times New Roman';
    ax.FontSize = 30;
    
    ax.XAxis.FontSize = 30;
    
    ax.YLabel.String = 'Metres';
    ax.YLabel.FontSize =  40;
    
    ax.XAxis.TickValues = [1 2 3];
    ax.XAxis.TickLabels = {'Egocentric' 'Walking' 'Teleport'};
    ax.XAxis.FontSize = 35;
    
    ax.XLabel.String = 'Movement Condition';
    ax.XLabel.FontSize =  40;
    
    leg = legend([plotone{1}(1).sdPtch plotone{2}(1).sdPtch],{'Young' 'Elderly'});
    %leg.Position = [0.0538    0.6970    0.0641    0.0607];
    leg.FontName = 'Times New Roman';
    leg.FontSize = 35;
    
    title([num2str(configs(kk)) ' object(s) configuration']);
    ax.Title.FontSize = 30;
    
end

%
clear blocks conds tempData tempDataBlock blockOne blockTwo blockThree ans a meanS stdS ax plotone jitter groupColors ii fh signplot a b H B configs kk TF
clear blocks conds tempData tempDataBlock blockOne blockTwo blockThree ans a meanS stdS ax plotone jitter groupColors ii fh i dataStruct j ...
    ego allow allot aarray dataPlot blocks jitterfromUnit spacing lPlot distanceBetweenUnits leg meanHelmertContrasts stdHelmertContrasts s meanContrasts stdContrasts