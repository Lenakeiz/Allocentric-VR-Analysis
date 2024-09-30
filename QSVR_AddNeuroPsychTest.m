HC_NeuroPsychData = readtable(fullfile('Data', 'QSVR_Elderly_Neuropsychology_Battery.csv'));
HC_NeuroPsychData = HC_NeuroPsychData(strcmp(HC_NeuroPsychData.Status, 'HC'), :);

AlloData_Elderly_4MT = cell2table(cell(0,5));%array2table(zeros(size(uniqueID,1) * 6,6) );
AlloData_Elderly_4MT.Properties.VariableNames = {'ParticipantID', 'ParticipantGroup', 'MeanADE', 'MeanRT', 'FourMT'};
uniqueID = unique(AlloData_SPSS_Cond_Conf.ParticipantID(AlloData_SPSS_Cond_Conf.ParticipantGroup == 2));


% Extracting only the ade for the Shifted Viewpoint Condition 
for i = 1:size(uniqueID,1)
    currOriginalId = uniqueID(i) - maxID;
    tempTable = array2table(zeros(1,5));
    tempTable.Properties.VariableNames = {'ParticipantID','ParticipantGroup', 'MeanADE', 'MeanRT', 'FourMT'};
    tempTable.ParticipantID = currOriginalId;
    tempTable.ParticipantGroup(1) = 2;
    tempTable.MeanADE(1) = mean(AlloData_SPSS_Cond_Conf.MeanADE(AlloData_SPSS_Cond_Conf.ParticipantID == uniqueID(i) & (AlloData_SPSS_Cond_Conf.TrialType == 3)));
    currFourMT = HC_NeuroPsychData.IV_MT(HC_NeuroPsychData.ID == currOriginalId);
    if isempty(currFourMT)
        tempTable.FourMT(1) = nan;
    else
        tempTable.FourMT(1) = currFourMT;
    end
    
    AlloData_Elderly_4MT = [AlloData_Elderly_4MT; tempTable];
end