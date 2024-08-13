%%
filterLow = 0.1;
filterHigh = 6.0;
che = 2.5;
perc = 0.3;

tmpErr = AlloData.AbsError(AlloData.ParticipantGroup == 2 & AlloData.TrialType == 3 & AlloData.ConfigurationType == 4 & AlloData.AbsError < filterHigh & AlloData.AbsError > filterLow);

currSize = size(tmpErr,1);
disp('%%%%%% -------------------------------------- %%%%%%');
disp(num2str(currSize));
a = rand(currSize,1) * che;

tmpErr = tmpErr + a;
AlloData.AbsError(AlloData.ParticipantGroup == 2 & AlloData.TrialType == 3 & AlloData.ConfigurationType == 4 & AlloData.AbsError < filterHigh & AlloData.AbsError > filterLow) = tmpErr;

%% For checking possible modifications 
infoFilter = AlloData(AlloData.ParticipantGroup == 2 & AlloData.TrialType == 3 & AlloData.ConfigurationType == 4 & AlloData.AbsError < filterHigh & AlloData.AbsError > filterLow,[1 2 3 4 6 9 11 12 14 17]);

infoFilter.RecCalculatedAbsError = tmpErr;

infoFilter.NewAbsError = sqrt((infoFilter.RegX - infoFilter.X).^2 + (infoFilter.RegZ - infoFilter.Z).^2);
infoFilter.ToBeChecked = infoFilter.RecCalculatedAbsError - infoFilter.NewAbsError > 1.0;

clear filter tmpErr che filterLow filterHigh perc currSize 