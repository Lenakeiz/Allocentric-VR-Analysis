%%% THIS IS PART OF VISUALIZE MAIN EFFECT SCRIPT %%%

%Calculating means per block per participant

tempData = AlloData_SPSS_Cond_Conf(:,[1 3 5]);
%tempData.MeanADE = log(tempData.MeanADE);

tempDataBlock = tempData(tempData.ConfigurationType == 1,:);

blockOne = accumarray(tempDataBlock.ParticipantID,tempDataBlock.MeanADE, [], @nanmean);
blockOne(blockOne==0) = nan;
blockOne(any(isnan(blockOne),2), :) = [];

tempDataBlock = tempData(tempData.ConfigurationType == 4,:);

blockTwo = accumarray(tempDataBlock.ParticipantID,tempDataBlock.MeanADE, [], @nanmean);
blockTwo(blockTwo==0) = nan;
blockTwo(any(isnan(blockTwo),2), :) = [];

%Create Cumulative Array
blocks = [blockOne;blockTwo];
conds = [ones(44,1);ones(44,1)*2];

[meanS, stdS] = grpstats(blocks,conds,{'mean','std'});

%
subplot(1,3,2)

jitter = 0.6;
groupColors = cbrewer('seq', 'Greys', 7);

plotone = notBoxPlot(blocks,conds, 'jitter', jitter, 'interval', 'tInterval');
hold on;

for ii=1:length(plotone)
        plotone(ii).semPtch.FaceAlpha = 0.8;
        plotone(ii).sdPtch.FaceAlpha = 0.8;
        plotone(ii).data.MarkerFaceColor = [0.65 0.65 0.65];
        plotone(ii).data.MarkerFaceAlpha = 0.3;    
        plotone(ii).data.MarkerEdgeColor = [0.5 0.5 0.5];
        plotone(ii).data.MarkerEdgeAlpha = 0.6;
        plotone(ii).data.SizeData = 200;
        plotone(ii).sdPtch.FaceColor = groupColors(3,:);
        plotone(ii).sdPtch.EdgeColor = 'none';
        plotone(ii).semPtch.FaceColor = groupColors(5,:);
        plotone(ii).semPtch.EdgeColor = 'none';
        plotone(ii).mu.Color = groupColors(7,:);
        plotone(ii).mu.LineWidth = 5;
        plotone(ii).data.MarkerFaceColor = groupColors(4,:);
        plotone(ii).data.MarkerFaceAlpha = 0.7;
    end

hold off;
xlim([0.5 2.5]);
ylim([0 5]);

ax = gca;
ax.XAxis.LineWidth = 8;
ax.YAxis.LineWidth = 8;

ax.FontName = 'Times New Roman';
ax.FontSize = 30;

ax.XAxis.FontSize = 30;

ax.YLabel.String = 'Metres';
ax.YLabel.FontSize =  35;
    
ax.XAxis.TickLabels = {'1' '4'};

ax.XLabel.String = 'Object Configuration';
ax.XLabel.FontSize =  35;

H=sigstar({{'1','4'}},0.001);

H{1}{1}.LineWidth = 5;
H{1}{2}.FontSize = 50;
%title('Absolute Displacement Error');
%ax.Title.FontSize = 45;


%%
clear blocks conds tempData tempDataBlock blockOne blockTwo blockThree ans a meanS stdS ax plotone jitter groupColors ii fh signplot a b H