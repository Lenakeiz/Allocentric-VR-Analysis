function [bsRand,bsSample,bsTtest] = ChanceCalculation(Data,pGroup,varargin)
% This script will look at the chance calculation from a configuration
% bsRand is the shuffled vector
% bsSample is the bootstrap from data
% bsTtest is the test statistics.

objectConf = 1;
trialType = NaN;

arg=1;
    while arg<=length(varargin)
        switch lower(varargin{arg})
            case {'objects','conftype','configurationtype'}
                objectConf = varargin{arg+1}; arg=arg+1;
            case {'trialtype','type','transparency'}
                trialType = varargin{arg+1}; arg=arg+1;
            case 'another_option...'
                % Option functionality..
        end
        arg = arg+1;
    end

% Taking all data for 1 obj across conditions per group. Young
if( ~(isnan(trialType)) ) % Select according to the type of graph
    selectedData = Data(Data.ParticipantGroup == pGroup & Data.ConfigurationType == objectConf & Data.TrialType == trialType,:);
else
    selectedData = Data(Data.ParticipantGroup == pGroup & Data.ConfigurationType == objectConf,:);
end
%Shuffling the indices
l = length(selectedData.AbsError);

N = 1000;
%To create a chance performance we shuffle the responses 1000 times
rng('default'); %Just for debugging reasons
indices = randi(l,l,N);

bootStrapData = sqrt((selectedData.RegX(indices) - selectedData.X).^2 + (selectedData.RegZ(indices) - selectedData.Z).^2);
sum(sum(isnan(bootStrapData),1)) %nan are connected to invalid data

%Using the mean of the shuffled as a bootstrab population
bsRand.Vector = nanmean(bootStrapData)';
bsRand.Mean = nanmean(bsRand.Vector);
SEM = std(bsRand.Vector)/sqrt(length(bsRand.Vector));               % Standard Error THIS IS THE CORRECT ONE, but it gives too little values
SEM = std(bsRand.Vector);
ts = tinv([0.025  0.975],length(bsRand.Vector)-1);      % T-Score
bsRand.CI = bsRand.Mean + ts*SEM;  

bsSample.OriginalSample = selectedData.AbsError; 
bsSample.OriginalAngles = selectedData.Angles;
bsSample.Vector = bootstrp(N,@nanmean,selectedData.AbsError);
bsSample.Mean = nanmean(bsSample.Vector);
bsSample.CI = bootci(N,@nanmean,selectedData.AbsError);

[~,bsTtest.p,bsTtest.ci,bsTtest.stats] = ttest2(bsRand.Vector,bsSample.Vector);

end
