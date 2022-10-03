function [] = VisualizeRadialPlot(AlloData,objectConf,varargin) %% Parse optional arguments

trialType = NaN;

arg=1;
    while arg<=length(varargin)
        switch lower(varargin{arg})
            case {'trialtype','type','transparency'}
                trialType = varargin{arg+1}; arg=arg+1;
            case 'another_option...'
                % Option functionality..
        end
        arg = arg+1;
    end

% Dealing with young data
if(~isnan(trialType))
    [bsRandY,bsSampleY,bsTtestY] = ChanceCalculation(AlloData,1,'conftype', objectConf, 'trialtype', trialType);
else
    [bsRandY,bsSampleY,bsTtestY] = ChanceCalculation(AlloData,1,'conftype', objectConf);
end

if(~isnan(trialType))
    [bsRandE,bsSampleE,bsTtestE] = ChanceCalculation(AlloData,2,'conftype', objectConf, 'trialtype', trialType);
else
    [bsRandE,bsSampleE,bsTtestE] = ChanceCalculation(AlloData,2,'conftype', objectConf);
end
    
CreateCustomFigure;

%1 is elder, 2 is young, 4 is chance
groupColors = cbrewer('qual', 'Set1', 6);
theta = linspace(0,2*pi);
dataAlpha = 0.2;
alphaChance = 0.3;
multiplierForCircularSectors = 1.5;

%% YOUNG
%RadialPlot Top left is young
s = subtightplot(2,2,1);

ps = polarscatter(bsSampleY.OriginalAngles,bsSampleY.OriginalSample);
ps.MarkerEdgeColor = 'none';
ps.MarkerFaceColor = groupColors(2,:);
ps.MarkerFaceAlpha = dataAlpha;

hold on;

pax = gca;
pax.ThetaAxisUnits = 'radians';
rlim([0 6]);
rticks([0 2 4 6]);
rticklabels({'0m','2m','4m'});

% Chance
% top rand line
% rho = ones(1,size(theta,2)).*(bsRandY.CI(1,2) + 0.6);
% pp = polarplot(theta, rho);
% pp.Color = [groupColors(4,:) alphaChance];
% pp.LineWidth = 1;
% 
% % lower rand line
% rho = ones(1,size(theta,2)).*(bsRandY.CI(1,1));
% pp = polarplot(theta, rho);
% pp.Color = [groupColors(3,:) 1.0];
% pp.LineWidth = 1;

% middle rand line
rho = ones(1,size(theta,2)).*(bsRandY.Mean);
ppLeg2 = polarplot(theta, rho);
ppLeg2.Color = [groupColors(4,:) 0.8];
ppLeg2.LineWidth = 1;

% middle rand line
rho = ones(1,size(theta,2)).*(bsRandY.Mean);
ppLeg2 = polarplot(theta, rho);
ppLeg2.Color = [groupColors(4,:) alphaChance];
ppLeg2.LineWidth = 29;

% Data Sample

% top rand line
% rho = ones(1,size(theta,2)).*(bsSampleY.CI(2,1) + 0.1);
% pp = polarplot(theta, rho);
% 
% % lower rand line
% rho = ones(1,size(theta,2)).*(bsSampleY.CI(1,1) - 0.1);
% pp = polarplot(theta, rho);

% middle rand mid
rho = ones(1,size(theta,2)).*(bsSampleY.Mean);
ppLeg1 = polarplot(theta, rho);
ppLeg1.Color =  [groupColors(2,:)./multiplierForCircularSectors 0.8];
ppLeg1.LineWidth = 1;

% middle rand ci
rho = ones(1,size(theta,2)).*(bsSampleY.Mean);
ppLeg1 = polarplot(theta, rho);
ppLeg1.Color =  [groupColors(2,:)./multiplierForCircularSectors alphaChance];
ppLeg1.LineWidth = 11;

hold off;

ax = gca;
ax.FontName = 'Times New Roman';
ax.FontSize = 20;
ax.RAxis.TickLabels = {'' '2m' '4m'};
ax.ThetaAxis.TickLabels = {'0' '\pi/6' '\pi/3' '\pi/2' '2\pi/3' '5\pi/6' '\pi' '7\pi/6' '' '' '' '11\pi/6'};

leg = legend([ppLeg1 ppLeg2],{'Young' 'Chance'});
leg.Position = [0.0538    0.6970    0.0641    0.0607];
leg.FontName = 'Times New Roman';
leg.FontSize = 20;

%% Young Radial Plot histogram
s = subtightplot(2,2,2,[0.001,0.001],0.1,0.05);

hh = histogram(bsSampleY.Vector);
hh.FaceColor = groupColors(2,:);
hh.EdgeColor = groupColors(2,:)*0.5;
hold on
hh = histogram(bsRandY.Vector);
hh.FaceColor = groupColors(4,:);
hh.EdgeColor = groupColors(4,:)*0.5;
hold off
xlim([0 6]);

ax = gca;
ax.FontName = 'Times New Roman';
ax.XAxis.TickLabels = {};
ax.YAxis.Label.Position = [-0.5615   77.5001   -1.0000];
ax.YAxis.FontSize= 20;
ax.YAxis.Label.String = 'Counts (#)';
ax.YAxis.TickValues = [50 100 150];

%% Elder Radial Plot
s=subtightplot(2,2,3);

ps = polarscatter(bsSampleE.OriginalAngles,bsSampleE.OriginalSample);
ps.MarkerEdgeColor = 'none';
ps.MarkerFaceColor = groupColors(1,:);
ps.MarkerFaceAlpha = dataAlpha;

hold on;

pax = gca;
pax.ThetaAxisUnits = 'radians';
rlim([0 6]);
rticks([0 2 4 6]);
rticklabels({'0m','2m','4m'});

% Chance
% top rand line
% rho = ones(1,size(theta,2)).*(bsRandE.CI(1,2) + 0.6);
% pp = polarplot(theta, rho);
% pp.Color = [groupColors(4,:) alphaChance];
% pp.LineWidth = 1;
% 
% % lower rand line
% rho = ones(1,size(theta,2)).*(bsRandE.CI(1,1));
% pp = polarplot(theta, rho);
% pp.Color = [groupColors(4,:) 1.0];
% pp.LineWidth = 1;

% middle rand line
rho = ones(1,size(theta,2)).*(bsRandE.Mean);
ppLeg2 = polarplot(theta, rho);
ppLeg2.Color = [groupColors(4,:) 0.8];
ppLeg2.LineWidth = 1;

% middle rand line
rho = ones(1,size(theta,2)).*(bsRandE.Mean);
ppLeg2 = polarplot(theta, rho);
ppLeg2.Color = [groupColors(4,:) alphaChance];
ppLeg2.LineWidth = 31;

% Data Sample

%top rand line
% rho = ones(1,size(theta,2)).*(bsSampleE.CI(2,1) + 0.1);
% pp = polarplot(theta, rho);
% 
% % lower rand line
% rho = ones(1,size(theta,2)).*(bsSampleE.CI(1,1) - 0.1);
% pp = polarplot(theta, rho);

% middle rand mid
rho = ones(1,size(theta,2)).*(bsSampleE.Mean);
ppLeg1 = polarplot(theta, rho);
ppLeg1.Color =  [groupColors(1,:)./multiplierForCircularSectors 0.8];
ppLeg1.LineWidth = 1;

% middle rand ci
rho = ones(1,size(theta,2)).*(bsSampleE.Mean);
ppLeg1 = polarplot(theta, rho);
ppLeg1.Color =  [groupColors(1,:)./multiplierForCircularSectors alphaChance];
ppLeg1.LineWidth = 21;

hold off;

ax = gca;
ax.FontName = 'Times New Roman';
ax.FontSize = 20;
ax.RAxis.TickLabels = {'' '2m' '4m'};
ax.ThetaAxis.TickLabels = {'0' '\pi/6' '' '' '' '5\pi/6' '\pi' '7\pi/6' '4\pi/3' '3\pi/2' '5\pi/3' '11\pi/6'};

leg = legend([ppLeg1 ppLeg2],{'Elderly' 'Chance'});
leg.FontName = 'Times New Roman';
leg.FontSize = 20;
leg.Position = [0.0538    0.2422    0.0641    0.0607];


%% Young Radial Plot histogram
s = subtightplot(2,2,4,[0.001,0.001],0.1,0.05);


hh = histogram(bsSampleE.Vector);
hh.FaceColor = groupColors(1,:);
hh.EdgeColor = groupColors(1,:)*0.5;
hold on
hh = histogram(bsRandE.Vector);
hh.FaceColor = groupColors(4,:);
hh.EdgeColor = groupColors(4,:)*0.5;
hold off
xlim([0 6]);

ax = gca;
ax.FontName = 'Times New Roman';

ax.XAxis.Label.String = 'Absolute Distance Error (m)';
ax.XAxis.FontSize = 20;
ax.YAxis.Label.String = 'Counts (#)';
ax.YAxis.Label.Position = [-0.5615   77.5001   -1.0000];
ax.YAxis.FontSize= 20;
ax.YAxis.Limits = [0 150];
ax.YAxis.TickValues = [50 100 150];
ax.YAxis.TickLabels = {'50' '100' '150'};

if(~isnan(trialType))
    trType = '';
    switch trialType
        case 1
            trType = 'Egocentric';
        case 2
            trType = 'Allocentric (PI)';
        case 3
            trType = 'Allocentric (TP)';
    end
    stTitle = ['Chance Calculation - ' num2str(objectConf) ' obj' '-' trType];
    
else
    
    stTitle = ['Chance Calculation - ' num2str(objectConf) ' obj' ];
end

sup = suptitle(stTitle);
sup.FontName = 'Times New Roman';
sup.FontSize = 30;

end
    