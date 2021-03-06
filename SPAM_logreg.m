load spambase.data
features = spambase(:,1:57); % loading the features
cls = spambase(:,58); %loading the classes of the observations
cls = cls+1; 
logreg = mnrfit(features,cls) %fitting the logistic regression model

prob=mnrval(logreg,features); % Probabilities of class being spam and not spam for each of the 4601 instances


% 10 fold cross validation
    indices = crossvalind('Kfold',cls,10);
    for i = 1:10
        test = (indices == i); train = ~test;
        train_x=features(train,:);
        train_y=cls(train,:);
        test_x=features(test,:);
        test_y=cls(test,:);
        [b,dev,stats] = mnrfit(train_x,train_y,'interactions','off','model','ordinal','link','logit');
        y_hat = mnrval(b,test_x,stats,'interactions','off','type','cumulative','model','ordinal','link','logit');
        ccdf_yfit=1-y_hat;
        class1 = ccdf_yfit > 0.5;
        count=0;
        for j=1:length(test_x)
            if class1(j)==test_y(j)
                count=count+1;
            end
        end
        error(i)=1-(count/length(test_x));   
    end
    
    error
    Classification_error=mean(error)
    