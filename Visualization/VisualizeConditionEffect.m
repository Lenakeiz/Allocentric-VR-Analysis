%%% THIS IS PART OF VISUALIZE MAIN EFFECT SCRIPT %%%

%Calculating means per block per participant

tempData = AlloData_SPSS_Cond_Conf(:,[1 4 5]);
%tempData.MeanADE = log(tempData.MeanADE);

for i = 1:3
        tempDataBlock = tempData(tempData.TrialType == i,:);
        aarray = accumarray(tempDataBlock.ParticipantID,tempDataBlock.MeanADE, [], @nanmean);
        aarray(aarray==0) = nan;
        aarray(any(isnan(aarray),2), :) = [];
        dataStruct{i} = aarray;
end



%Just for calculating with helmert contrasts the means
dataPlot = [dataStruct{1};dataStruct{2};dataStruct{3}];
blocks = [ones(44,1);ones(44,1)*2;ones(44,1)*2];
[meanHelmertContrasts, stdHelmertContrasts] = grpstats(dataPlot,blocks,{'mean','std'});

%Create Cumulative Array
dataPlot = [dataStruct{1};dataStruct{2};dataStruct{3}];
blocks = [ones(44,1);ones(44,1)*2;ones(44,1)*3];
[meanS, stdS] = grpstats(dataPlot,blocks,{'mean','std'});

%CreateCustomFigure;

%%
subplot(1,3,3)

jitter = 0.6;
groupColors = cbrewer('qual', 'Accent', 3);

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

H=sigstar([1 2.5],0.001);
H{1}{1}.LineWidth = 5;
H{1}{2}.FontSize = 50;
 
xlim([0.5 3.5]);
ylim([0 4.0]);

H=sigstar([2 3],0.001);
H{1}{1}.LineWidth = 5;
H{1}{2}.FontSize = 50;

xlim([0.5 3.5]);
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
    
ax.XAxis.TickLabels = {'Egocentric' 'Walking' 'Teleport'};
ax.XAxis.FontSize = 25;

ax.XLabel.String = 'Movement Condition';
ax.XLabel.FontSize =  35;

%title('Absolute Displacement Error');
%ax.Title.FontSize = 45;


%
clear blocks conds tempData tempDataBlock blockOne blockTwo blockThree ans a meanS stdS ax plotone jitter groupColors ii fh signplot a b H
clear blocks conds tempData tempDataBlock blockOne blockTwo blockThree ans a meanS stdS ax plotone jitter groupColors ii fh i dataStruct j ...
    ego allow allot aarray dataPlot blocks jitterfromUnit spacing lPlot distanceBetweenUnits leg meanHelmertContrasts stdHelmertContrasts s