function deg = extractTailDeg(windowedCentroids)
% Takes a set of windowedCentroids as input and converts the cells into
% another set of cells of locations for each detected burst. These
% cells are converted to arrays from which the jump dists can be
% determined. Finally converts the jump dists into a degree.
% Outputs a vector deg depdending on input cell array of centroids.
%
% Locally defined binLogLog function abstracted from:
% B. Fulcher, PHYS3888, (2021), PHYS3888
% https://github.com/PHYS3888

function [binCenters,Nnorm] = binLogLog(numBins,dataVector)
% THIS FUNCTION IS SOURCED FROM:
% B. Fulcher, PHYS3888, (2021), PHYS3888
% https://github.com/PHYS3888
%-------------------------------------------------------------------------------
% log10-spaced bin edges:
binEdges = logspace(log10(min(dataVector)),log10(max(dataVector)),numBins);
% Bin the data using custom bin edges:
[N,binEdges] = histcounts(dataVector,binEdges);
% Bin centers as middle points between bin edges:
binCenters = mean([binEdges(1:end-1);binEdges(2:end)]);
% Convert counts to probabilities:
Nnorm = N/sum(N);
end

ts = 1:size(windowedCentroids,1);
deg = [];
for t = ts
    wBursts = windowedCentroids(t,1);
    wBursts = wBursts{:};
    jump_sizes = [];
    for b = 1:size(wBursts,2)
        xy = cell2mat(wBursts(b));
        x = xy(:,1)';
        y = xy(:,2)';
        jump_sizes = [jump_sizes, sqrt(diff(x).^2 + diff(y).^2)];
    end
%     jump_sizes
    jump_sizes_gt0 = jump_sizes(jump_sizes>0.5);      
    [centers,prob] = binLogLog(20,jump_sizes_gt0);
    centers = centers(prob>0);
    prob = prob(prob>0);   
    xData = log10(centers);
    yData = log10(prob);
    a = polyfit(xData,yData,1);
    deg = [deg a(1)];
end

end