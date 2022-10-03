%Calculating means per block per participant

tempData = AlloData_SPSS_Cond_Conf_BlockVirtual(:,[1 5 6]);
%tempData.MeanADE = log(tempData.MeanADE);

tempDataBlock = tempData(tempData.BlockNumber == 1,:);

blockOne = accumarray(tempDataBlock.ParticipantID,tempDataBlock.MeanADE, [], @nanmean);
blockOne(blockOne==0) = nan;
blockOne(any(isnan(blockOne),2), :) = [];

tempDataBlock = tempData(tempData.BlockNumber == 2,:);

blockTwo = accumarray(tempDataBlock.ParticipantID,tempDataBlock.MeanADE, [], @nanmean);
blockTwo(blockTwo==0) = nan;
blockTwo(any(isnan(blockTwo),2), :) = [];

tempDataBlock = tempData(tempData.BlockNumber == 3,:);

blockThree = accumarray(tempDataBlock.ParticipantID,tempDataBlock.MeanADE, [], @nanmean);
blockThree(blockThree==0) = nan;
blockThree(any(isnan(blockThree),2), :) = [];

%Create Cumulative Array
blocks = [blockOne;blockTwo;blockThree];
conds = [ones(44,1);ones(44,1)*2;ones(44,1)*3];

[meanS, stdS] = grpstats(blocks,conds,{'mean','sem'});

%%
CreateCustomFigure;

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
        plotone(ii).data.MarkerFaceColor = groupColors(4,:);
        plotone(ii).data.MarkerFaceAlpha = 0.7;
    end

hold off;
xlim([0.5 3.5]);

ax = gca;
ax.XAxis.LineWidth = 8;
ax.YAxis.LineWidth = 8;

ax.FontName = 'Times New Roman';
ax.FontSize = 30;

ax.XAxis.FontSize = 30;

ax.YLabel.String = 'Metres';
ax.YLabel.FontSize =  35;
    

ax.XLabel.String = 'Block #';
ax.XLabel.FontSize =  35;

title('Absolute Displacement Error');
ax.Title.FontSize = 45;


%%
clear blocks conds tempData tempDataBlock blockOne blockTwo blockThree ans a meanS stdS ax plotone jitter groupColors ii fh