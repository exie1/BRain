% plot_avgTailDegree.m
% Plots tail degree averaged across the 4 stimulus directions as a
% function of time. Takes inputs of a set of cells for the different time
% periods containing positions of each of the detected gamma bursts.

allDegs = [];
dirs = 1:4;
for d = dirs
    load(['d',num2str(d),'_timeWindowedLocs.mat']);
    % sum all degs, assume equal contribution per direction (this is 
    % reasonably valid since all give similar numbers of detected
    % pattern locations)
    allDegs = [allDegs; extractTailDeg(allWCentroids)];
end
dirAvgDegs = mean(allDegs); % average
t = (1:500:4000) + 250; % plotting at centres of 500 ms windows
plot(t,abs(dirAvgDegs),'o-')
xlabel('Time of recording (ms)','interpreter','latex','fontsize',15)
ylabel('Stimulus-averaged, trial-averaged tail degree, $\gamma$','interpreter','latex','fontsize',15)
axis square