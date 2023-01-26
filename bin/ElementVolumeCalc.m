function Vols = ElementVolumeCalc(ElementNodes,NodesFinal)
%ELEMENTVOLUMECALC Calculates the volume of each element
%   Takes in element node numbers and correlates that to the nodes, which
%   from each node it calculates the volume of said element.

NumElements = size(ElementNodes,1);

Vols = nan(NumElements,1);

percentPoints = linspace(0, NumElements, 10);

fprintf('\tElementVolumeCalc: ');

for i = 1:NumElements
    if i >= percentPoints(1)
        fprintf('.');
        percentPoints(1) = [];
    end
    currNodes = ElementNodes(i,:)';
    currPoints = NodesFinal(currNodes, 2:end);
    Vols(i,1) = volume(alphaShape(currPoints, Inf, 'RegionThreshold', 0));

%     N = numRegions(shp);
% 
%     figure;
%     [k1,av1] = convhull(currPoints); % ,'Simplify',true
%     [k2,av2] = convhull(currPoints,'Simplify',true);
%     subplot(1,2,1);
%     trisurf(k1,currPoints(:,1),currPoints(:,2),currPoints(:,3),'FaceColor','cyan', 'FaceAlpha', 0.3)
%     axis equal
%     subplot(1,2,2);
%     trisurf(k2,currPoints(:,1),currPoints(:,2),currPoints(:,3),'FaceColor','cyan', 'FaceAlpha', 0.3)
%     axis equal

end

fprintf(' DONE\n');

end

