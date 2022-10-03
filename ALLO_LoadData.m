%% Main script 
% % First part is loading data from the VR
% % 
% % TrialType:
% %     WALKEGO = 1;
% %     WALKALLO = 2;
% %     TELEPORT = 3;
% % 
% % ParticipantGroup:
% %     YC  = 1;
% %     HC  = 2;
% %     MCI = 99; not used;
% % 
% % 

clc; clear all; close all; warning('off','all');

% Initializing variables

AlloData = table();
YCData = {};
HCData = {};

% getting folders
folderpath = pwd;
folderpath = strcat(folderpath,'\Data');

folderYoung          = strcat(folderpath,'\YC\');
folderHealthyControl = strcat(folderpath,'\HC\');

%% Processing Young Data
[YCData currGroupedData] = ExtractDataFromFolder(folderYoung,'YC');
AlloData = [AlloData;currGroupedData];

%
% Eliminating uncorrect trials (from AlloData table only!)
% This are trials where the VR system lost tracking and subsequently the
% recorded position is misplaced. 
% Getting Participant ID and TrialNumber
excludedData     = AlloData(AlloData.RegY > 99,:);
excludedData     = excludedData(:,[1 2 3 5]);
excludedData     = unique(excludedData);
if( isempty(excludedData) == 0)
    sizeU = size(excludedData,1);
    for i = 1:sizeU
        AlloData(AlloData.ParticipantID == excludedData.ParticipantID(i) & AlloData.TrialNumber == excludedData.TrialNumber(i),[12:1:14]) =  array2table(NaN(excludedData.ConfigurationType(i),3));
    end
end


disp('%%%%%% -------------------------------------- %%%%%%');
disp(['# Removed void trials: ' num2str(size(excludedData,1))]);
clear excludedData sizeU 

%% Processing Healthy Control Data
[HCData currGroupedData] = ExtractDataFromFolder(folderHealthyControl,'HC');
AlloData = [AlloData;currGroupedData];

%% Assigning unique ID for participants
%  ID for Healthy Control will be starting from max(Young) + 1

maxID = max(unique(AlloData.ParticipantID(AlloData.ParticipantGroup == 1)));
adjustedID = AlloData.ParticipantID(AlloData.ParticipantGroup == 2);
adjustedID = adjustedID + ones(size(adjustedID,1),1) * maxID; 
AlloData.ParticipantID(AlloData.ParticipantGroup == 2) = adjustedID;
% DO NOT REMOVE maxID as it s being used in ALLO_AddNeuroPsychTest
clear adjustedID

%
% Eliminating uncorrect trials (from AllData only)
% Getting Participant ID and TrialNumber
excludedData     = AlloData(AlloData.RegY > 99,:);
excludedData     = excludedData(:,[1 2 3 5]);
excludedData     = unique(excludedData);
if( isempty(excludedData) == 0)
    sizeU = size(excludedData,1);
    for i = 1:sizeU
        AlloData(AlloData.ParticipantID == excludedData.ParticipantID(i) & AlloData.TrialNumber == excludedData.TrialNumber(i),[12:1:14]) =  array2table(NaN(excludedData.ConfigurationType(i),3));
    end
end

disp('%%%%%% -------------------------------------- %%%%%%');
disp(['# Removed trials ' num2str(size(excludedData,1))]);
clear excludedData sizeU 

%%
% Now should be nice to start calculate basic things
ALLO_CalculateProperties;

%%
ALLO_AddNeuroPsychTest;

%% Cleaning
warning('on','all');

clear folderpath folderYoung folderHealthyControl files allNames allNamesUnique allNamesHeader currSize currHeader currTable currGroupedData i

%% 
function [data groupedData] = ExtractDataFromFolder(folderName, groupName)
%% This function extracts data from all the single xml files. 
%  The VR data is saved in 3 xml files (one for each block)
%
%  Outputs:
%
%  data - cell structure where each cell is with data coming from a single
%  participants 
%  groupedData - table where each row is a single trial for replacing one
%  object

    data = {};
    groupedData = table();
    
    % Reading all files in the directory
    files = dir(folderName);
    % Getting the names
    allNames = {files.name};
    %dir command returns also current folder name and previous folder
    %('..'). Getting rid of those as well.
    allNames = allNames(~cellfun('isempty',strfind(allNames,groupName)));
    %Extracting unique headers (it s the portion of the name before any
    %_blocktrialnumber
    allNamesUnique = allNames(cell2mat(cellfun(@(x) endsWith(x,'_3.xml'),allNames,'UniformOutput',false)));
    allNamesHeader = cellfun(@extractHeader, allNamesUnique);

    currSize = size(allNamesHeader,2);
    
    % Reading each participant at once using the header
    for i = 1:currSize
        currHeader = allNamesHeader{i};
        currData = XmlReader(folderName,currHeader);
        data{i,1} = currData;
        groupedData = [groupedData;currData.Grouped];
    end
    
end
