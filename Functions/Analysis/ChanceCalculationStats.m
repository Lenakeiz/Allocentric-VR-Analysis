objectConf = 1;
trialType = 3;
[bsRandY,bsSampleY,bsTtestY] = ChanceCalculation(AlloData,1,'conftype', objectConf, 'trialtype', trialType);
[bsRandE,bsSampleE,bsTtestE] = ChanceCalculation(AlloData,2,'conftype', objectConf, 'trialtype', trialType);
[bsRandYTot,bsSampleYTot,bsTtestYTot] = ChanceCalculation(AlloData,1,'conftype', objectConf);
[bsRandETot,bsSampleETot,bsTtestETot] = ChanceCalculation(AlloData,2,'conftype', objectConf);
