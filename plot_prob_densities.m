% plot_prob_densities.m
% ----------------------
% Plots the probability densities using the position xy.mat files. Here it
% is generated in a subplot for convenience, but the report figures are
% formatted slightly differently.
% You will also want to fully expand the figure when it pops up!

close all
figure(1)
set(gcf,'color','w');
n = 1:4; % stimulus directions
letts = 'abcde';

for d = n
    load(['d',num2str(d),'_gamma_xy.mat']); % array named 'xy' for all
    h = prob_densities(xy);
    
    % Plotting
    subplot(2,3,d)
    imagesc(h);
    colormap('jet'); set(gca,'YDir','normal'); caxis([0,0.045])
    axis square; grid off
    set(gca,'XTick',1:2:20, 'XTickLabel', 1:10)
    set(gca,'YTick',1:2:20, 'YTickLabel', 1:10)
    xlabel('$x$ (electrode widths)','interpreter','latex','fontsize',13)
    ylabel('$y$ (electrode widths)','interpreter','latex','fontsize',13)
    text(0.025,0.95,['(',letts(d),')'],'Units','normalized','FontSize',15,'Color','w')
end

load('spon_gamma_xy.mat')
h = prob_densities(xy);
subplot(2,3,5)
imagesc(h);
colormap('jet'); set(gca,'YDir','normal'); caxis([0,0.045])
axis square; grid off; c = colorbar;
set(gca,'XTick',1:2:20, 'XTickLabel', 1:10)
set(gca,'YTick',1:2:20, 'YTickLabel', 1:10)
xlabel('$x$ (electrode widths)','interpreter','latex','fontsize',13)
ylabel('$y$ (electrode widths)','interpreter','latex','fontsize',13)
text(0.025,0.95,['(',letts(5),')'],'Units','normalized','FontSize',15,'Color','w')
ylabel(c,'Probability','interpreter','latex','fontsize',13)
