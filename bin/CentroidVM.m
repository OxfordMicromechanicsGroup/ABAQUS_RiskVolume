function StressOut = CentroidVM(filename, dataLines)
%IMPORTFILE Import data from a text file
%  VMJG = IMPORTFILE(FILENAME) reads data from text file FILENAME for
%  the default selection.  Returns the numeric data.
%
%  VMJG = IMPORTFILE(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  Example:
%  VMJG = importfile("C:\Users\mans3428\OneDrive - Nexus365\ABAQUS Models\ReducedModels\Tests\DesignRJSElipse\RiskVolume Experiments\Better\VM JG.rpt", [21, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 16-Jan-2023 18:07:33

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [21, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 9);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = " ";

% Specify column names and types
opts.VariableNames = ["Step", "StepDD", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9"];
opts.SelectedVariableNames = ["Step", "StepDD"];
opts.VariableTypes = ["double", "double", "string", "string", "string", "string", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";

% Specify variable properties
opts = setvaropts(opts, ["Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Step", "TrimNonNumeric", true);
opts = setvaropts(opts, "Step", "ThousandsSeparator", ",");

% Import the data
StressOut = readtable(filename, opts);

%% Convert to output type
StressOut = table2array(StressOut);
StressOut = StressOut(1:end-2, :);

end

