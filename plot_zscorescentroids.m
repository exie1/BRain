% plot_zscorescentroids.m
% Plot the zscores and centroids for one gamma burst at two different
% times, t and tt.

% Load zscores for raw gamma amplitude data for t = 1301, tt = 1311
% for D1 stimulus, with xy and t for the pattern which is in this period
% and trial p = 1
load('somePatt_zscores_d1.mat');

t = 300; % Time after stimulus onset
tt = t+10; % Second time tt > t, same detected pattern
pos = xy_somePatt_d1(t_somePatt_d1 == t | t_somePatt_d1 == tt,:);
u = 410; % electrode spacing for axes;
% the extra 10 is due to some weird cuts of data points due to hists
pos = pos*u-200;

% colormap jet
subplot(121)
amps = zscores_1301;
ampssmooth = interp2(amps,2); % smooth by interpolation
imagesc(1:4000,1:4000,ampssmooth)
hold on
plot(pos(1,1),pos(1,2),'r.','MarkerSize',40)
% plot([1 2],[1 2],'r')
% plot()
% hold on
c = colorbar;
caxis([-1,4])

set(gca,'XTick',0:1000:4000)
set(gca,'YTick',0:1000:4000)
set(gca,'YDir','normal')

set(gca,'FontSize',20)
xlabel('$x$ (electrodes)','interpreter','latex','fontsize',24)
ylabel('$y$ (electrodes)','interpreter','latex','fontsize',24)
ylabel(c,'$z$-score','interpreter','latex','fontsize',24)
legend('Gamma burst centroid at $t = 1301$ ms','Interpreter','latex','fontsize',18,'Location','SouthEast');
axis square

subplot(122)
amps = zscores_1311;
ampssmooth = interp2(amps,2); % smooth by interpolation
imagesc(1:4000,1:4000,ampssmooth)
hold on
plot(pos(1,1),pos(1,2),'ro','MarkerSize',10,'LineWidth',2)
plot(pos(2,1),pos(2,2),'r.','MarkerSize',40)

c = colorbar;
caxis([-1,4])

set(gca,'XTick',0:1000:4000)
set(gca,'YTick',0:1000:4000)
set(gca,'YDir','normal')

set(gca,'FontSize',20)
xlabel('$x$ (electrodes)','interpreter','latex','fontsize',24)
ylabel('$y$ (electrodes)','interpreter','latex','fontsize',24)
ylabel(c,'$z$-score','interpreter','latex','fontsize',24)
legend('Gamma burst centroid at $t = 1301$ ms','Gamma burst centroid at $t = 1311$ ms','Interpreter','latex','fontsize',18,'Location','SouthEast');
axis square
