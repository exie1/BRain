%% Visualises change in amplitude for a 10x10 electrode array 

for i = 1:4070
   imagesc(reshape(data_abs_1234d(i,:,1,1),[10,10]));
   text(1,1,num2str(i));
   pause(0.01)
end

%% Visualise peak
for i = 1:4070
    [M,I] = max(data_abs_1234d(i,:,1,1));
    empt = zeros(100,1);
    empt(I) = 1;
    imagesc(reshape(empt,[10,10]))
    pause(0.01)
end

%% Visualise peak + overall map
for i = 1000:3000
    [M,I] = max(data_abs_1234d(i,:,1,1));
    data_abs_1234d(i,I,50,2) = data_abs_1234d(i,I,50,2)*2;
    imagesc(reshape(data_abs_1234d(i,:,1,1),[10,10]));
    data_abs_1234d(i,I,50,2) = data_abs_1234d(i,I,50,2)/2;
    text(1,1,num2str(i));
    pause(0.01)
end

%% Visualise distance
I_list = zeros(2001,0);
R = 5;
C = 7;
positions = zeros(2,2);
positions(1,:) = [5,7];

dist_list = [];
for i = 1000:4000
    [M,I] = max(data_abs_1234d(i,:,1,1));
    I_list(i) = I;
    empt = zeros(100,1);
    empt(I) = 1; 
    empt = reshape(empt,[10,10]);
    [R,C] = find(empt);
    positions(2,:) = [R,C];
    dist_list = [dist_list, pdist(positions,'euclidean')];
    positions(1,:) = [R,C];
end
dist_list(dist_list == 0) = [];
hist(dist_list,26)
length(2001-dist_list)
