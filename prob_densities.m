function h = prob_densities(xy)
% prob_densities.m
% Generate 3D probability density distributions for input (x,y)
% electrode position data.
% xy = input array of size N x 2, where N is the number of positions
% h = output 19 x 19 probability density array in x,y coords

    hist = hist3(xy,'Ctrs',{1:0.5:10 1:0.5:10},'CdataMode','auto');
    normhist = hist/sum(hist(:)); % probability normalisation
    h = normhist'; % transpose for correct positions when plotting
    
end
