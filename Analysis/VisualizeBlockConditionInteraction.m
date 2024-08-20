%Calculating means per block per participant

tempData = AlloData_SPSS_Cond_Conf_BlockVirtual(:,[1 4 5 6]);

%For each block calculating the three conditions average
%Putting everything in a struct

% i is trial type
% j is block
for i = 1:3    
    for j = 1:3
        tempDataBlock = tempData(tempData.BlockNumber == j & tempData.TrialType == i,:);
        aarray = accumarray(tempDataBlock.ParticipantID,tempDataBlock.MeanADE, [], @nanmean);
        aarray(aarray==0) = nan;
        aarray(any(isnan(aarray),2), :) = [];
        dataStruct{i,j} = aarray;
    end
end

CreateCustomFigure;
hold on;
jitter = 0.23;
distanceBetweenUnits = 0.02;
groupColors = cbrewer('seq', 'Greys', 7);
jitterfromUnit = 0.3;
spacing = [-jitterfromUnit 0 jitterfromUnit];

groupColors = cbrewer('qual', 'Accent', 3);

%Create Cumulative Array for plotting
for i = 1:3
    dataPlot{i} = [dataStruct{i,1};dataStruct{i,2};dataStruct{i,3}];
    blocks{i} = [ones(44,1)+ spacing(i);ones(44,1)*2 + spacing(i);ones(44,1)*3 + spacing(i)];
    [meanS{i}, stdS{i}] = grpstats(dataPlot{i},blocks{i},{'mean','std'});
end

for i = 1:3
    plotone{i} = notBoxPlot(dataPlot{i},blocks{i}, 'jitter', jitter, 'interval', 'tInterval'); hold on;
    
    for ii=1:length(plotone{i})
        
        plotone{i}(ii).semPtch.FaceAlpha = 0.0;
        plotone{i}(ii).sdPtch.FaceAlpha = 0.8;
        plotone{i}(ii).sdPtch.FaceColor = groupColors(i,:);
        plotone{i}(ii).sdPtch.EdgeColor = 'none';
        plotone{i}(ii).semPtch.FaceColor = groupColors(i,:) * 0.5;
        plotone{i}(ii).semPtch.EdgeColor = 'none';
        plotone{i}(ii).mu.Color = [0 0 0];
        plotone{i}(ii).mu.Visible = 'off';
        plotone{i}(ii).data.SizeData = 100;
        plotone{i}(ii).data.MarkerEdgeColor = groupColors(i,:);
        plotone{i}(ii).data.MarkerEdgeAlpha = 0.5;
        plotone{i}(ii).data.MarkerFaceColor = groupColors(i,:) * 0.7;
        plotone{i}(ii).data.MarkerFaceAlpha = 0.5;
        
    end   
end

for i = 1:3
    lPlot{i} = scatter([mean(plotone{i}(1).mu.XData) mean(plotone{i}(2).mu.XData) mean(plotone{i}(3).mu.XData)],...
        [plotone{i}(1).mu.YData(1) plotone{i}(2).mu.YData(1) plotone{i}(3).mu.YData(1)], 'HandleVisibility', 'off');
    lPlot{i}.MarkerFaceColor = [0 0 0];
    lPlot{i}.MarkerEdgeColor = 'none';
    lPlot{i}.SizeData = 250;
    lPlot{i} = plot([mean(plotone{i}(1).mu.XData) mean(plotone{i}(2).mu.XData) mean(plotone{i}(3).mu.XData)],...
        [plotone{i}(1).mu.YData(1) plotone{i}(2).mu.YData(1) plotone{i}(3).mu.YData(1)]);
    lPlot{i}.Color = groupColors(i,:);
    lPlot{i}.LineWidth = 4;
     
    hold on;
end
hold off;

ax = gca;
xlim([0.5 3.5]);
ylim([0.0 5]);
ax.XAxis.LineWidth = 8;
ax.YAxis.LineWidth = 8;

ax.FontName = 'Times New Roman';
ax.FontSize = 30;

ax.XAxis.TickValues = [1.0 2.0 3.0];
ax.XAxis.FontSize = 30;

ax.YLabel.String = 'Metres';
ax.YLabel.FontSize =  35;

ax.XLabel.String = 'Block #';
ax.XLabel.FontSize =  35;

leg = legend([lPlot{1} lPlot{2} lPlot{3}],{'Egocentric' 'Walking' 'Teleport'});
%leg.Position = [0.0538    0.6970    0.0641    0.0607];
leg.FontName = 'Times New Roman';
leg.FontSize = 35;

title('Absolute Displacement Error');
ax.Title.FontSize = 45;

%
clear blocks conds tempData tempDataBlock blockOne blockTwo blockThree ans a meanS stdS ax plotone jitter groupColors ii fh i dataStruct j ...
    ego allow allot aarray dataPlot blocks jitterfromUnit spacing lPlot distanceBetweenUnits leg