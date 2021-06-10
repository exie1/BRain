% plot_onePattPlusTailFit.m
% Plot walking motion of a single gamma burst pattern; and
% Plot the histogram and the fitted tail for a given direction (from report
% this is defaulted to Direction 1). Histogram generated from data from all
% time periods for a single direction. Notice the jump size data here
% cannot be recovered from the gamma_xy.mat files since taking the diff's
% will also include taking the distances BETWEEN DIFFERENT gamma bursts!
%
% Regardless, the data for the jump sizes is provided for usage.
%
% Locally defined binLogLog function abstracted from:
% B. Fulcher, PHYS3888, (2021), PHYS3888
% https://github.com/PHYS3888

% Plotting walking motion of single pattern
subplot(121)
load('d1_timeWindowedLocs.mat'); % load patterns for a single stimulus
stim_window = allWCentroids(4);
bursts = stim_window{:};
b_xy = cell2mat(bursts(230)); % favourite numbered pattern?
plot(b_xy(:,1),b_xy(:,2))
axis square
xlim([1,8]); ylim([3,10]);
hold on
plot(b_xy(1,1),b_xy(1,2),'.','MarkerSize',60)
plot(b_xy(end,1),b_xy(end,2),'.','MarkerSize',60)

h1 = legend('Gamma burst path','Initial position','Final position','Interpreter','latex');

set(gca,'FontSize',20)
xlabel('$x$ (electrodes)','interpreter','latex','fontsize',24);
ylabel('$y$ (electrodes)','interpreter','latex','fontsize',24);

% Plotting histogram + fitted tail
subplot(122)
load('d1_jump_sizes.mat'); % gives matrix of jump sizes for D1, all bursts

tail_jumps = jump_sizes(jump_sizes > 0.5);

[centers,prob] = binLogLog(20,tail_jumps);
centers = centers(prob>0);
prob = prob(prob>0); % make sure we remove everything that is 0

loglog(centers,prob); axis square

xData = log10(centers); yData = log10(prob);
a = polyfit(xData,yData,1);
xloged = centers;
yloged = 10^a(2)*xloged.^a(1);
hold on;
loglog(xloged,yloged);

set(gca,'FontSize',20)
xlabel('Jump distance, $J$, (electrodes)','interpreter','latex','fontsize',24);
ylabel('Probability','interpreter','latex','fontsize',24)

h1 = legend('D1 jump distance probability distribution','Power law fit, $f(J)$ = 10$^{-\gamma J+\sigma}$','Interpreter','latex');

fprintf('Power law fit parameters: gamma = %.4f, sigma = %.4f\n',-a(1),a(2))

% Regression analysis on loglog scale
R = corrcoef(yloged,prob);
Rsq = R(1,2)^2;

fprintf('Correlation coefficient (in loglog): R^2 = %.4f\n',Rsq)

%==========================================================================

function [binCenters,Nnorm] = binLogLog(numBins,dataVector)

% THIS FUNCTION IS SOURCED FROM:
% B. Fulcher, PHYS3888, (2021), PHYS3888
% https://github.com/PHYS3888

if nargin < 1
    numBins = 25;
end
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
