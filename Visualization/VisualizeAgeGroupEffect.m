%%% THIS IS PART OF VISUALIZE MAIN EFFECT SCRIPT %%%

%Calculating means per block per participant

tempData = AlloData_SPSS_Cond_Conf(:,[1 2 5]);
%tempData.MeanADE = log(tempData.MeanADE);

for i = 1:2
    tempDataBlock = tempData(tempData.ParticipantGroup == i,:);
    aarray = accumarray(tempDataBlock.ParticipantID,tempDataBlock.MeanADE, [], @nanmean);
    aarray(aarray==0) = nan;
    aarray(any(isnan(aarray),2), :) = [];
    dataStruct{i} = aarray;
end

%Create Cumulative Array
dataPlot = [dataStruct{1};dataStruct{2}];
blocks = [ones(21,1);ones(23,1)*2];
[meanS, stdS] = grpstats(dataPlot,blocks,{'mean','std'});
%
%CreateCustomFigure;

%%
subplot(1,3,1)

jitter = 0.6;
%1 is elder, 2 is young, 4 is chance
groupColors = cbrewer('qual', 'Set1', 6);
groupColors = groupColors([2 1],:);

plotone = notBoxPlot(dataPlot,blocks, 'jitter', jitter, 'interval', 'tInterval');
hold on;

 for ii=1:length(plotone)
        plotone(ii).semPtch.FaceAlpha = 0.8;
        plotone(ii).sdPtch.FaceAlpha = 0.8;
        plotone(ii).sdPtch.FaceColor = groupColors(ii,:);
        plotone(ii).sdPtch.EdgeColor = 'none';
        plotone(ii).semPtch.FaceColor = groupColors(ii,:) * 0.5;
        plotone(ii).semPtch.EdgeColor = 'none';
        plotone(ii).mu.Color = [0 0 0];
        plotone(ii).mu.LineWidth = 5;
        plotone(ii).data.SizeData = 200;
        plotone(ii).data.MarkerEdgeColor = groupColors(ii,:);
        plotone(ii).data.MarkerEdgeAlpha = 0.5;
        plotone(ii).data.MarkerFaceColor = groupColors(ii,:) * 0.7;
        plotone(ii).data.MarkerFaceAlpha = 0.5; 
 end

H=sigstar([1 2],0.001);
H{1}{1}.LineWidth = 5;
H{1}{2}.FontSize = 50;

xlim([0.5 2.5]);
ylim([0 5]);

hold off;


ax = gca;
ax.XAxis.LineWidth = 8;
ax.YAxis.LineWidth = 8;

ax.FontName = 'Times New Roman';
ax.FontSize = 30;

ax.XAxis.FontSize = 30;

ax.YLabel.String = 'Metres';
ax.YLabel.FontSize =  35;
    
ax.XAxis.TickLabels = {'Younh' 'Elderly'};
ax.XAxis.FontSize = 25;

ax.XLabel.String = 'Age Group';
ax.XLabel.FontSize =  35;

%title('Absolute Displacement Error');
%ax.Title.FontSize = 45;


%
clear blocks conds tempData tempDataBlock blockOne blockTwo blockThree ans a meanS stdS ax plotone jitter groupColors ii fh signplot a b H
clear blocks conds tempData tempDataBlock blockOne blockTwo blockThree ans a meanS stdS ax plotone jitter groupColors ii fh i dataStruct j ...
    ego allow allot aarray dataPlot blocks jitterfromUnit spacing lPlot distanceBetweenUnits leg