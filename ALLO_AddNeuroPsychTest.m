HC_NeuroPsychData  = readtable('ALLOCompiledData201119.csv');

AlloData_SPSS_Tot = cell2table(cell(0,5));%array2table(zeros(size(uniqueID,1) * 6,6) );
AlloData_SPSS_Tot.Properties.VariableNames = {'ParticipantID', 'ParticipantGroup', 'MeanADE', 'MeanRT', 'FourMT'};
uniqueID = unique(AlloData_SPSS_Cond_Conf.ParticipantID(AlloData_SPSS_Cond_Conf.ParticipantGroup == 2));

for i = 1:size(uniqueID,1)
    currOriginalId = uniqueID(i) - maxID;
    tempTable = array2table(zeros(1,5));
    tempTable.Properties.VariableNames = {'ParticipantID','ParticipantGroup', 'MeanADE', 'MeanRT', 'FourMT'};
    tempTable.ParticipantID = currOriginalId;
    tempTable.ParticipantGroup(1) = 2;
    tempTable.MeanADE(1) = mean(AlloData_SPSS_Cond_Conf.MeanADE(AlloData_SPSS_Cond_Conf.ParticipantID == uniqueID(i) & (AlloData_SPSS_Cond_Conf.TrialType == 2 | AlloData_SPSS_Cond_Conf.TrialType == 3)));
    tempTable.MeanRT(1) = mean(AlloData_SPSS_Cond_Conf.MeanRT(AlloData_SPSS_Cond_Conf.ParticipantID == uniqueID(i)   & (AlloData_SPSS_Cond_Conf.TrialType == 2 | AlloData_SPSS_Cond_Conf.TrialType == 3)));
    currFourMT = HC_NeuroPsychData.IV_MT(HC_NeuroPsychData.ID == currOriginalId);
    if isempty(currFourMT)
        tempTable.FourMT(1) = nan;
    else
        tempTable.FourMT(1) = currFourMT;
    end
    
    AlloData_SPSS_Tot = [AlloData_SPSS_Tot; tempTable];
end

%Collected after Alex finished his project, inserting results here.
AlloData_SPSS_Tot.FourMT(23) = 6;
AlloData_SPSS_Tot.FourMT(22) = 7;

%% Plotting the results

%1 is elder, 2 is young, 4 is chance
groupColors = cbrewer2('qual', 'Set1', 6);
groupColors = groupColors([2 1],:);
legendData = {'Young' 'Elderly'};

CreateCustomFigure;

subplot(1,2,1);

tbl = table(AlloData_SPSS_Tot.FourMT, AlloData_SPSS_Tot.MeanADE);
tbl.Properties.VariableNames = {'4MT' 'ADE'};
mdl = fitlm(tbl,'linear')
p = plot(mdl);
data = p(1,1);
data.MarkerEdgeColor = 'none';
data.MarkerFaceColor = [groupColors(2,:)];
data.Marker = 'o';
data.MarkerSize = 20;
data.Color = [groupColors(2,:) 0.5];
fit = p(2,1);
fit.Color = [groupColors(2,:)*0.2 0.7];
fit.LineWidth = 5;
cb = p(3,1);
cb.Color = [groupColors(2,:) 0.6];
cb.LineWidth = 5;
% cb = p(4,1);
% cb.Color = [groupColors(2,:) 0.6];
% cb.LineWidth = 5;

ax = gca;
ax.XAxis.LineWidth = 8;
ax.YAxis.LineWidth = 8;
ax.Title.String = '';
ax.FontName = 'Times New Roman';
ax.FontSize = 30;

ax.YLabel.Interpreter = 'tex';
ax.YLabel.String = {'ADE({\mu})'};
ax.YLabel.FontSize = 40;
%ylim([0 4]);

ax.XLabel.Interpreter = 'tex';
ax.XLabel.String = {'4MT(#)'};
ax.XLabel.FontSize = 40;
%ax.XLabel.Position = [7.0000   -0.22   -1.0000];
xlim([0 15]);

s = title('Absolute Distance Error (Allocentric) vs 4 Mountain Test');
s.FontSize = 35;
s.FontName = 'Times New Roman';

hold off;