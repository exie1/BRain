% Convert marmoset data to 10x10x4070x100 array (y,x,t,p)

for i = 1:100        % i represents ith channel, loop to load all 100 channel files
    filename = ['gratdirandcorr_MA026_Utah100-14_ch',num2str(i),'.mat'];
    load (filename);
    electrodeArrayLFP = squeeze(arrangedLFP(4,:,:));
    
    % make 3rd dimension by concatenation of 2D arrays
    if mod(i,10) == 1
        xDimArray = electrodeArrayLFP;
    else
        xDimArray = cat(3,xDimArray,electrodeArrayLFP);
    end
    
    % every 10, we complete an x-dim row, and can concatenate to the bigger
    % array in the 4th dim to generate the 4D matrix (100x4070x10x10) as
    % (trial x time x X x Y)
    if i == 10
        completeLFP = xDimArray;
    elseif mod(i,10) == 0
        completeLFP = cat(4,completeLFP,xDimArray);
    end
end

completeLFP = permute(completeLFP,[3,4,2,1]);