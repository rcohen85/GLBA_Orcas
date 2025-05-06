
inDir = 'P:\users\cohen_rebecca_rec297\CCB\GLBA\Orcas\EcotypeClassfier\OriginalSelTables';
outDir = 'P:\users\cohen_rebecca_rec297\CCB\GLBA\Orcas\EcotypeClassfier\Training\IndividualSelTables\2016';
updateExt = ''; % If you want to change the audio file extension, put the new extension here
newLab = ''; % if labels don't exist and you want to apply the same one to all annotations, enter it here
updateLabs = {}; % if you  want to update a particular label to a new name, enter the old and the new label here
anCol = 'population'; % name of column containing annotations

fileList = dir(fullfile(inDir,'*classif.txt'));
soundFiles = {};
selTabs = {};

for j=1:numel(fileList)

    tab = readtable(fullfile(inDir,fileList(j).name),'Delimiter',"\t",'VariableNamingRule',"preserve");
    % tab = tab(:,1:11); % Might want to remove unwanted columns

    allFiles = table2array(tab(:,'Begin File'));
    [paths,names,exts]= fileparts(allFiles);

    if ~isempty(updateExt)
        tab(:,'Begin File') = strrep(table2array(tab(:,'Begin File')),exts,updateExt);
    end
    if ~isempty(newLab)
        tab(:,anCol) = cellstr(repmat(newLab,size(tab,1),1));
    end
    if ~isempty(updateLabs)
        for k=1:size(updateLabs,1)
            updateInd = find(strcmp(table2array(tab(:,anCol)),updateLabs{k,1}));
            tab(updateInd,anCol) = cellstr(repmat(updateLabs{k,2},numel(updateInd),1));
        end
    end
    if any(contains(tab.Properties.VariableNames,'Begin Path'))
        tab(:,'Begin Path') = [];
    end
    if ~any(contains(tab.Properties.VariableNames,'Delta Time (s)'))
        tab(:,'Delta Time (s)') = table(table2array(tab(:,'End Time (s)')) - table2array(tab(:,'Begin Time (s)')));
    end

    allFiles = table2array(tab(:,'Begin File'));
    [paths,names,exts]= fileparts(allFiles);

    unFiles = unique(allFiles);
    selNames = {};

    for i=1:length(unFiles)

        selTabName = strrep(unFiles{i},exts{i},'.txt');
        selNames = [selNames;selTabName];
        fileInd = find(strcmp(allFiles,unFiles{i}));

        selTab = tab(fileInd,:);
        selTab(:,'Selection') = array2table([1:size(selTab,1)]');
        selTab(:,'Begin Time (s)') = selTab(:,'File Offset (s)');
        selTab(:,'End Time (s)') = table(table2array(selTab(:,'Begin Time (s)')) + table2array(selTab(:,'Delta Time (s)')));

        saveName = fullfile(outDir,selTabName);
        writetable(selTab,saveName,'Delimiter','\t');

        fprintf('Selection table %d of %d contains %d annotations\n',i,size(unFiles,1),size(selTab,1))

    end

    soundFiles = [soundFiles;unFiles];
    selTabs = [selTabs;selNames];
end
writecell([soundFiles,selTabs],fullfile(outDir,'SoundFile_SelectionTable_Correspondence.csv'));
