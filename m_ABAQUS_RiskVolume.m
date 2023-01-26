%% m_ABAQUS_RiskVolume Main

clear
close all
clc

fprintf('%s: Started\n', mfilename);

%% Fullpath Locations of Run

% Fullpath location of input file
inp_filename = "C:\Users\mans3428\OneDrive - Nexus365\ABAQUS Models\ReducedModels\Tests\DesignRJSElipse\200umWs\Job-JG_200_220.inp";

% Fullpath location of centroid stress report file
stressFilename = "C:\Users\mans3428\OneDrive - Nexus365\ABAQUS Models\ReducedModels\Tests\DesignRJSElipse\200umWs\abaqus JG 200 220 VM Centroid.rpt";

StressUnit = 'MPa';
mu = char(181);
VolumeUnit = sprintf('%sm^3',mu);

%% Adding All Relevant Folders To Path
% https://uk.mathworks.com/matlabcentral/answers/247180-how-can-i-add-all-subfolders-to-my-matlab-path#answer_194998
% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));

%% Analysing ABAQUS Input File and Plot It

[node, element, elementType] = readinp(inp_filename);
% plot x-coordinate as the patch value
plotMesh(node, element, elementType, node(:,2)) 
colormap(jet); colorbar

%% Calculating the Element Volumes

Vols = ElementVolumeCalc(element(:,2:end),node);

%% Stress

stress0 = CentroidVM(stressFilename);
stress = stress0(:,2);
% figure;
% histogram(Data.Stress);

Data = table(Vols, stress, 'VariableNames', {'ElementVolume', 'Stress'});

TF_Top10pcnt = Data.Stress >= 0.9*max(Data.Stress);
TF_Top20pcnt = Data.Stress >= 0.8*max(Data.Stress);

List_Top10pcnt = find(TF_Top10pcnt);
String_Top10pcnt = join(string(List_Top10pcnt'), ',');

List_Top20pcnt = find(TF_Top20pcnt);
String_Top20pcnt = join(string(List_Top20pcnt'), ',');

DataRV_10pcnt = Data(TF_Top10pcnt, :);
DataRV_20pcnt = Data(TF_Top20pcnt, :);

RV_10pcnt = sum(DataRV_10pcnt.ElementVolume);
RV_20pcnt = sum(DataRV_20pcnt.ElementVolume);
TotalVol = sum(Data.ElementVolume);

Vol_10pcntRV = 100*RV_10pcnt/TotalVol;
Vol_20pcntRV = 100*RV_20pcnt/TotalVol;

[path,fn,~] = fileparts(stressFilename);

% save( fullfile(path, sprintf('Vars_%s.mat', fn)) );

%% Plot The Top X% Stress On Part

Top_X_Pcnt = 20;
[String_TopXpcnt, RiskVol_Xpcnt, PercentageVolume_XpcntRV, TotalVol] = PlotTopXPcnt(Data, Top_X_Pcnt, element, node, elementType);

%% Cumulative Volume Analysis

Data2 = sortrows(Data, "Stress", "descend");
Data2 = horzcat(Data2, table(1-(Data2.Stress./max(Data2.Stress)), VariableNames="RelativeStress"));
Data2 = horzcat(Data2, table(cumsum(Data2.ElementVolume), VariableNames="CumsumVolume"));
Data2 = horzcat(Data2, table(Data2.CumsumVolume./max(Data2.CumsumVolume), VariableNames="RelativeCumsumVolume"));

figure;
plot(100*Data2.RelativeStress, 100*Data2.RelativeCumsumVolume, 'b-');
ylabel('Cumulative % of Total Volume');
xlabel('Top % Stress');

figure;
plot(Data2.Stress, Data2.CumsumVolume, 'r-');
ylabel(sprintf('Cumulative Volume [%s]', VolumeUnit));
xlabel(sprintf('Stress [%s]', StressUnit));
% xlim([0, 50]);

% figure;
% plot(Data2.Stress, Data2.ElementVolume, 'g-');
% ylabel('Element Volume');
% xlabel('Stress');

fprintf('%s: FINISHED\n', mfilename);
