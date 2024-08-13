% This script explores the retrieval times
conftype = 4;
trialtype = 3;

% Plotting some histograms
% teleport young 4
Young.RT.Sample = AlloData.MeanRetrievalTime(AlloData.ParticipantGroup == 1 & AlloData.ConfigurationType == conftype & AlloData.TrialType == trialtype & ~isnan(AlloData.MeanRetrievalTime));
Older.RT.Sample = AlloData.MeanRetrievalTime(AlloData.ParticipantGroup == 2 & AlloData.ConfigurationType == conftype & AlloData.TrialType == trialtype & ~isnan(AlloData.MeanRetrievalTime));

N = 1000;
%Bootstrapping
Young.RT.Vector = bootstrp(N,@nanmean,Young.RT.Sample);
Young.RT.Mean = nanmean(Young.RT.Vector);
Young.RT.CI = bootci(N,@nanmean,Young.RT.Sample);
%Bootstrapping
Older.RT.Vector = bootstrp(N,@nanmean,Older.RT.Sample);
Older.RT.Mean = nanmean(Older.RT.Vector);
Older.RT.CI = bootci(N,@nanmean,Older.RT.Sample);

figure;
histogram(Young.RT.Vector)
hold on
histogram(Older.RT.Vector)

clearvars -except AlloData AlloData_SPSS HCData YCData AlloData_SPSS_Cond_Conf AlloData_SPSS_Cond_Conf_Block AlloData_SPSS_Cond_Conf_VirtualBlock

%% Plotting mean ade vs mean rt

conftype = 4;
trialtype = 3;

Young.ADE.Sample = AlloData.MeanAbsError(AlloData.ParticipantGroup == 1 & AlloData.ConfigurationType == conftype & AlloData.TrialType == trialtype & ~isnan(AlloData.MeanAbsError));
Older.ADE.Sample = AlloData.MeanAbsError(AlloData.ParticipantGroup == 2 & AlloData.ConfigurationType == conftype & AlloData.TrialType == trialtype & ~isnan(AlloData.MeanAbsError));
Young.RT.Sample = AlloData.MeanRetrievalTime(AlloData.ParticipantGroup == 1 & AlloData.ConfigurationType == conftype & AlloData.TrialType == trialtype & ~isnan(AlloData.MeanRetrievalTime));
Older.RT.Sample = AlloData.MeanRetrievalTime(AlloData.ParticipantGroup == 2 & AlloData.ConfigurationType == conftype & AlloData.TrialType == trialtype & ~isnan(AlloData.MeanRetrievalTime));

figure;
subplot(2,1,1)
scatter(Young.RT.Sample,Young.ADE.Sample);
axis equal
subplot(2,1,2)
scatter(Older.RT.Sample,Older.ADE.Sample);
axis equal

clearvars -except AlloData AlloData_SPSS HCData YCData AlloData_SPSS_Cond_Conf AlloData_SPSS_Cond_Conf_Block AlloData_SPSS_Cond_Conf_VirtualBlock

%% Plotting mean ade vs mean rt
conftype = 4;
trialtype = 3;

Young.ADE.Sample = AlloData_SPSS_Cond_Conf.MeanADE(AlloData_SPSS_Cond_Conf.ParticipantGroup == 1 & AlloData_SPSS_Cond_Conf.ConfigurationType == conftype & AlloData_SPSS_Cond_Conf.TrialType == trialtype );
Older.ADE.Sample = AlloData_SPSS_Cond_Conf.MeanADE(AlloData_SPSS_Cond_Conf.ParticipantGroup == 2 & AlloData_SPSS_Cond_Conf.ConfigurationType == conftype & AlloData_SPSS_Cond_Conf.TrialType == trialtype );
Young.RT.Sample  = AlloData_SPSS_Cond_Conf.MeanRT(AlloData_SPSS_Cond_Conf.ParticipantGroup == 1 & AlloData_SPSS_Cond_Conf.ConfigurationType == conftype & AlloData_SPSS_Cond_Conf.TrialType == trialtype );
Older.RT.Sample  = AlloData_SPSS_Cond_Conf.MeanRT(AlloData_SPSS_Cond_Conf.ParticipantGroup == 2 & AlloData_SPSS_Cond_Conf.ConfigurationType == conftype & AlloData_SPSS_Cond_Conf.TrialType == trialtype );

CreateCustomFigure;
subplot(2,1,1)
%scatter(Young.RT.Sample,Young.ADE.Sample);
hold on
tbl = table(Young.RT.Sample, Young.ADE.Sample);
tbl.Properties.VariableNames = {'RT' 'ADE'};
mdl = fitlm(tbl,'linear');
plot(mdl);
hold off

subplot(2,1,2)
%scatter(Older.RT.Sample,Older.ADE.Sample);
hold on
tbl = table(Older.RT.Sample,Older.ADE.Sample);
tbl.Properties.VariableNames = {'RT' 'ADE'};
mdl = fitlm(tbl,'linear')
plot(mdl);
axis equal
hold off

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

Young.ADE.Sample(isoutlier(Young.ADE.Sample,'grubbs')) = nan;
Older.ADE.Sample(isoutlier(Older.ADE.Sample,'grubbs')) = nan;
Young.RT.Sample(isoutlier(Young.RT.Sample,'grubbs')) = nan;
Older.RT.Sample(isoutlier(Older.RT.Sample,'grubbs')) = nan;

groupColors = [config.]cbrewer('qual', 'Set1', 6);

CreateCustomFigure;
subplot(1,2,1)
%scatter(Young.RT.Sample,Young.ADE.Sample);
hold on
tbl = table(Young.RT.Sample, Young.ADE.Sample);
tbl.Properties.VariableNames = {'RT' 'ADE'};
mdl = fitlm(tbl,'linear','RobustOpts','on')
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

subplot(1,2,2)
%scatter(Older.RT.Sample,Older.ADE.Sample);
hold on
tbl = table(Older.RT.Sample,Older.ADE.Sample + 1.4);
tbl.Properties.VariableNames = {'RT' 'ADE'};
mdl = fitlm(tbl,'linear','RobustOpts','on')

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


