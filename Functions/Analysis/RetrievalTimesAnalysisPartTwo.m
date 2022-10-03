%% Calcultating accumarray for average data
%% Across movement conditions and across object configuration

tempData = AlloData_SPSS_Cond_Conf(:,[1 2 3 4 5 6]);
%tempData.MeanADE = log(tempData.MeanADE);

for i = 1:2
    tempDataBlock = tempData(tempData.ParticipantGroup == i,:);
    %tempDataBlock = tempData(tempData.ParticipantGroup == i & tempData.ConfigurationType == 4,:);
    %lock = tempData(tempData.ParticipantGroup == i & tempData.ConfigurationType == 4 & tempData.TrialType == 3,:);
    aarray = accumarray(tempDataBlock.ParticipantID,tempDataBlock.MeanADE, [], @nanmean);
    aarray(aarray==0) = nan;
    aarray(any(isnan(aarray),2), :) = [];
    dataStruct{i}{1} = aarray;
    aarray = accumarray(tempDataBlock.ParticipantID,tempDataBlock.MeanRT, [], @nanmean);
    aarray(aarray==0) = nan;
    aarray(any(isnan(aarray),2), :) = [];
    dataStruct{i}{2} = aarray;
end

%1 is elder, 2 is young, 4 is chance
groupColors = cbrewer('qual', 'Set1', 6);
groupColors = groupColors([2 1],:);
legendData = {'Young' 'Elderly'};

CreateCustomFigure;

for kk = 1:2
    
    subplot(1,2,kk);
    
    hold on;
    
    tbl = table(dataStruct{kk}{2}, dataStruct{kk}{1});
    tbl.Properties.VariableNames = {'RT' 'ADE'};
    mdl = fitlm(tbl,'linear')
    p = plot(mdl);
    data = p(1,1);
    data.MarkerEdgeColor = 'none';
    data.MarkerFaceColor = [groupColors(kk,:)];
    data.Marker = 'o';
    data.MarkerSize = 20;
    data.Color = [groupColors(kk,:) 0.5];
    fit = p(2,1);
    fit.Color = [groupColors(kk,:)*0.2 0.7];
    fit.LineWidth = 2;
    cb = p(3,1);
    cb.Color = [groupColors(kk,:) 0.6];
    cb.LineWidth = 5;
    cb = p(4,1);
    cb.Color = [groupColors(kk,:) 0.6];
    cb.LineWidth = 5;
    
    p(2,1).LineWidth = 5;
    
    legend('off');
    l = legend([data], legendData{kk});
    l.FontSize = 35; 
    
    ax = gca;
    ax.XAxis.LineWidth = 8;
    ax.YAxis.LineWidth = 8;
    ax.Title.String = '';
    ax.FontName = 'Times New Roman';
    ax.FontSize = 30;
    
    ax.YLabel.Interpreter = 'tex';
    ax.YLabel.String = {'ADE({\mu})'};
    ax.YLabel.FontSize = 40;
    ylim([0 4]);
    
    ax.XLabel.Interpreter = 'tex';
    ax.XLabel.String = {'RT({\mu})'};
    ax.XLabel.FontSize = 40;
    ax.XLabel.Position = [7.0000   -0.22   -1.0000];
    xlim([0 13]);
    
    hold off;
end

s = suptitle('Associations between average displacement error and retrieval time');
s.FontName = 'Times New Roman';
s.FontSize = 40;
s.FontWeight = 'bold';
clearvars -except AlloData AlloData_SPSS_Cond_Conf HCData YCData AlloData_SPSS_Cond_Conf AlloData_SPSS_Cond_Conf_Block AlloData_SPSS_Cond_Conf_VirtualBlock

%% For plotting reasons 
young_conftype = 4;
young_trialtype = 3;

elder_conftype = 1;
elder_trialtype = 3;

Young.ADE.Sample = AlloData_SPSS_Cond_Conf.MeanADE(AlloData_SPSS_Cond_Conf.ParticipantGroup == 1 & AlloData_SPSS_Cond_Conf.ConfigurationType == young_conftype & AlloData_SPSS_Cond_Conf.TrialType == young_trialtype );
Older.ADE.Sample = AlloData_SPSS_Cond_Conf.MeanADE(AlloData_SPSS_Cond_Conf.ParticipantGroup == 2 & AlloData_SPSS_Cond_Conf.ConfigurationType == elder_conftype & AlloData_SPSS_Cond_Conf.TrialType == elder_trialtype );
Young.RT.Sample  = AlloData_SPSS_Cond_Conf.MeanRT(AlloData_SPSS_Cond_Conf.ParticipantGroup == 1 & AlloData_SPSS_Cond_Conf.ConfigurationType == young_conftype & AlloData_SPSS_Cond_Conf.TrialType == young_trialtype );
Older.RT.Sample  = AlloData_SPSS_Cond_Conf.MeanRT(AlloData_SPSS_Cond_Conf.ParticipantGroup == 2 & AlloData_SPSS_Cond_Conf.ConfigurationType == elder_conftype & AlloData_SPSS_Cond_Conf.TrialType == elder_trialtype );

groupColors = cbrewer('qual', 'Set1', 6);

CreateCustomFigure;
subtightplot(1,2,1,[0.01,0.1],0.2,0.1)
%scatter(Young.RT.Sample,Young.ADE.Sample);
hold on
tbl = table(Young.RT.Sample, Young.ADE.Sample);
tbl.Properties.VariableNames = {'RT' 'ADE'};
mdl = fitlm(tbl,'linear')
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
cb = p(4,1);
cb.Color = [groupColors(2,:) 0.6];
cb.LineWidth = 2;
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

subtightplot(1,2,2,[0.01,0.1],0.2,0.1)
%scatter(Older.RT.Sample,Older.ADE.Sample);
hold on
tbl = table(Older.RT.Sample,Older.ADE.Sample + 1.4);
tbl.Properties.VariableNames = {'RT' 'ADE'};
mdl = fitlm(tbl,'linear')

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
cb = p(4,1);
cb.Color = [groupColors(1,:) 0.6];
cb.LineWidth = 2;
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

s = suptitle('Absolute Distance Error vs Retrieval Time - 4 obj - Allocentric (TP)');
s.FontSize = 30;
s.FontName = 'Times New Roman';

clearvars -except AlloData AlloData_SPSS_Cond_Conf HCData YCData AlloData_SPSS_Cond_Conf AlloData_SPSS_Cond_Conf_Block AlloData_SPSS_Cond_Conf_VirtualBlock

