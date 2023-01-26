function [String_TopXpcnt, RiskVol_Xpcnt, PercentageVolume_XpcntRV, TotalVol] = PlotTopXPcnt(Data, Top_X_Pcnt, element, node, elementType)
%PLOTTOPXPCNT Shows an external view of the top X percent stress of the
%part
%   Data is the data table.
%   Top_X_Pcnt is in % e.g. 10 for top 10% stress.
%   element is from readinp.m
%   node is from readinp.m
%   elementType is from readinp.m

TF_TopXpcnt = Data.Stress >= ((100-Top_X_Pcnt)/100)*max(Data.Stress);

List_TopXpcnt = find(TF_TopXpcnt);
String_TopXpcnt = join(string(List_TopXpcnt'), ',');

SelectionElements = element(List_TopXpcnt,:);
SelectionNodes = SelectionElements(:,2:end);
SelectionNodes = reshape(SelectionNodes.',1,[])';
% SelectionPoints = node(SelectionNodes, 2:4);
% SN2 = node(SelectionNodes,:);

ColorVal = zeros(size(node,1), 1);
ColorVal(SelectionNodes) = 1;

plotMesh(node, element, elementType, ColorVal);
cmap = [0.5,0.5,0.5;
        1,0,0];
colormap(cmap);
cbh = colorbar;
cbh.Ticks = linspace(0, 1, 2) ;
cbh.TickLabels = num2cell(0:1) ;

% shp = alphaShape(SelectionPoints, 'RegionThreshold', 4);
% plot(shp);

DataRV_Xpcnt = Data(TF_TopXpcnt, :);
RiskVol_Xpcnt = sum(DataRV_Xpcnt.ElementVolume);
TotalVol = sum(Data.ElementVolume);
PercentageVolume_XpcntRV = 100*RiskVol_Xpcnt/TotalVol;

end

