% plot_prob_densities.m
% ----------------------
% Plots the probability densities using the position xy.mat files. Here it
% is generated in a subplot for convenience, but the report figures are
% formatted slightly differently.
% You will also want to fully expand the figure when it pops up!
% Generates panels in Figure of Sec. III B

close all
figure(1)
set(gcf,'color','w');
n = 1:4; % stimulus directions
letts = 'abcde';
g = [1,2,5,6];

% Plotting for all moving grating stimuli, no spontaneous
for d = n
    load(['d',num2str(d),'_gamma_xy.mat']); % array named 'xy' for all
    h = prob_densities(xy); % get prob density array
    
    % Plotting
    subplot(2,4,g(d))
    imagesc(0:4000,0:4000,h);
    colormap('jet'); set(gca,'YDir','normal'); caxis([0,0.045])
    axis square; grid off
    set(gca,'FontSize',12)
    set(gca,'XTick',0:1000:4000, 'XTickLabel', 0:1000:4000)
    set(gca,'YTick',0:1000:4000, 'YTickLabel', 0:1000:4000)
    xlabel('$x$ ($\mu$m)','interpreter','latex','fontsize',16)
    ylabel('$y$ ($\mu$m)','interpreter','latex','fontsize',16)
    text(0.025,0.95,['(',letts(d),')'],'Units','normalized','FontSize',15,'Color','w')
end

% Plotting for spontaneous panel
load('spon_gamma_xy.mat')
h = prob_densities(xy); % get prob density array
subplot(1,2,2)
imagesc(0:4000,0:4000,h);
colormap('jet'); set(gca,'YDir','normal'); caxis([0,0.045])
axis square; grid off; c = colorbar;
set(gca,'XTick',0:1000:4000, 'XTickLabel', 0:1000:4000)
set(gca,'YTick',0:1000:4000, 'YTickLabel', 0:1000:4000)
xlabel('$x$ ($\mu$m)','interpreter','latex','fontsize',17)
ylabel('$y$ ($\mu$m)','interpreter','latex','fontsize',17)
text(0.025,0.95,['(',letts(5),')'],'Units','normalized','FontSize',15,'Color','w')
ylabel(c,'Probability','interpreter','latex','fontsize',18)
set(gca,'FontSize',15)
