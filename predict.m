%         VALIDATION CODE FOR CALCULATING OPTIMAL VALUES OF M AND L USING
%                             VALIDATION DATA

% function Erms = Validation
% format long;
%
% Trngfeatures=importdata ('Trngfeatures.mat');
% Trnglabels=importdata ('Trnglabels.mat');
% [Trngrows, Trngcolumns] = size(Trngfeatures);
% 
% Valdtndata= importdata('Valdtndata.mat');
% [Valdtnrows, Valdtncolumns] = size(Valdtndata);
% Valdtnlabels = Valdtndata(1:Vrows,1);
% Valdtnfeatures = Valdtndata(1:Vrows,2:Vcolumns);
% 
% Testingdata= importdata ('Testingdata.mat');
% [Ttrows, Ttcolumns] = size(Testingdata);
% Testinglabels = Testingdata(1:Ttrows,1);
% Testingfeatures = Testingdata(1:Ttrows,2:Ttcolumns);
% 
% i=1;
% for M = 13
%     for L= 4
%         digits(5);
%         [mu,s,Param]=train(Trngfeatures,Trnglabels,M,L);
%         [Predictedlabels]= predict(Valdtnndata,mu,s,Param,M,L);
%         temp=(Predictedlabels-Valdtnlabels).*(Predictedlabels-Valdtnlabels);
%         Erms(i)=(sqrt(sum(temp)/Valdtnrows));
%         i=i+1;
%         disp(i);
% %    end
% %end

% rms_lr=reshape(Erms,7,19);

% [M,L]= meshgrid(2:20,1:0.5:4);
% surf(M,L,rms_lr);
% hold on;
% [r,c] = find(rms_lr == min(rms_lr(:)));
% plot3(M(1,c),L(r,1),rms_lr(r,c),'o','markerfacecolor','b','markersize',8);
% title('Plot of rms_lr vs M vs Lambda to find optimal value of M and Lambda');
% xlabel('Model Complexity M');
% ylabel('Regularization Parameter Lambda');
% zlabel('Rootmean Square Error rms_lr');
% 
% end



% Function takes testing data as input and gives predicted labels as output

function predictedlabels = predict(testingdata)

% Calling train to store mu, s and paramters W

trngfeatures=importdata ('Trngfeatures.mat');
trnglabels=importdata ('Trnglabels.mat');
[mu,s,param] = train(trngfeatures,trnglabels) ;

% Optimal values of M and Lamda are taken

M = 13;
lambda = 4;

nmbrofparts = M-1;

% The data is divided into features and labels


[Ttrows, Ttcolumns] = size(testingdata);
testinglabels = testingdata(1:Ttrows,1);
testingfeatures = testingdata(1:Ttrows,2:Ttcolumns);

[testingrows,testingcolumns] = size(testingfeatures);

% Now, Using gaussian basis function, a Matrix of size N  by (M-1)*D is
% generated

for i = 1:testingrows
    for j = 1:nmbrofparts
        for k = 1:testingcolumns
            square = (testingfeatures(i,k) - mu(j)/s(j)).*((testingfeatures(i,k) - mu(j))/s(j));
            temp(i,(j-1)*46+k) = exp(-.5*square);
        end
    end
end 

% A Ones column is added to the matrix as it consist of a single column of
% Ones at the beginning

Ones = ones(testingrows,1);
phitesting = [Ones temp];

% The predicted labels are calculated by Phi * Param 

predictedlabels = phitesting*param;

% The roomt mean square errors are calculated and displayed

squarepredict = (predictedlabels-testinglabels).*(predictedlabels-testinglabels);
rms_lr(i) = (sqrt(sum(squarepredict)/testingrows));

sprintf('the hyperparameter mu for the linear regression model is %f', mu)
sprintf('the hyperparameter s for the linear regression model is %f', s)
sprintf('the root mean square error for the linear regression model is %f', rms_lr)

end


