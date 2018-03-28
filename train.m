% Main function train which takes Training features and Training labels as
% inputs and returns Mean mu, Hyperparamter s and parameters W.

function [mu,s,param] = train(trngfeatures,trnglabels)   

% Optimal values of M and Lamda are taken 

M = 13;
lambda = 4;

% The Data would be divided into M-1 Number of parts
nmbrofparts = M-1; 

% The size of the training features is calculated
[trngrows, trngcolumns] = size(trngfeatures); 

% The number of elements in a dataset is calculated
nmbrofelements = floor(trngrows/(nmbrofparts));                                         


% The training features is divided into sub matrices and each submatrix is
% stored in a variable

    
for i=1:nmbrofparts
    datasets{i}=(trngfeatures(nmbrofelements*(i-1)+1:nmbrofelements*i,1:trngcolumns));   % Each part is been assigned into a cell datasets
end

% From Each dataset, mean mu and hyperparamter s which is variance is
% calculated

for i= 1:nmbrofparts
    mu(i)=(sum(datasets{i}(:)))/((nmbrofelements*trngcolumns));                          % 
    a=datasets{i}(1:nmbrofelements,1:trngcolumns) - mu(i);
    b=a.*a;
    s(i)=sqrt(sum(b(:))/(nmbrofelements*trngcolumns));
end 

% Now, Using gaussian basis function, a Matrix of size N  by (M-1)*D is
% generated

for i=1:trngrows
    for j=1:nmbrofparts
        for k=1:trngcolumns
            square=(trngfeatures(i,k) - mu(j)/s(j)).*((trngfeatures(i,k) - mu(j))/s(j));
            temp(i,(j-1)*46+k)=exp(-.5*square);
        end
    end
end

% A Ones column is added to the matrix as it consist of a single column of
% Ones at the beginning

Ones=ones(trngrows,1);
phitrng = [Ones temp];

% Now, the Parameters W are calculated
param=((inv(phitrng'*phitrng+lambda*eye(size(phitrng'*phitrng))))*(phitrng'*trnglabels));

end     