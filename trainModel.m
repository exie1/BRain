% Decision tree
% tc = fitctree(Tbl_train, 'feature_matrix_train257');
%cv_part = cvpartition(400, 'Kfold', 10);
%tc = fitcecoc(Tbl_train, 'feature_matrix_train257', 'learner' 'CVPartition', cv_part);
tc = fitcecoc(Tbl_train,Tbl_Y_train,'Learner','svm','OptimizeHyperparameters',...
              'auto', 'HyperparameterOptimizationOptions', struct('AcquisitionFunctionName',...
              'expected-improvement-plus'));


label = predict(tc, Tbl_test);
acc = sum(feature_matrix_test(:,end) == label)/size(Tbl_test,1);
disp(acc)

% imp = predictorImportance(tc);
% figure;
% bar(imp);
% title('Predictor Importance Estimates');
% ylabel('Estimates');
% xlabel('Predictors');

C = confusionmat(feature_matrix_test(:,end), label);
confusionchart(C)