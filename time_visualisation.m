% Visualises change in amplitude for a 10x10 electrode array 

for i = 1:4070
   imagesc(reshape(data_abs_1234d(i,:,1,1),[10,10]));
   text(1,1,num2str(i));
   pause(0.01)
end
