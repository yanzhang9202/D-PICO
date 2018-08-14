%% W.Shi's EXTRA algorithm in the dual domain
% algorithm parameter setting
iter_max = 1e3;     % number of max. iter.
alpha = 1e-2;   % step size for the gradient update
epsl = 1e-2;

w1 = gph.wgt';
w2 = w1 - (gph.wgt + eye(N))'/2;

% var. initialization
x = zeros(n, N, iter_max);
x_itr = zeros(n, N);

lambda0 = zeros(m,N);
lambda = zeros(m, N, iter_max);
lambda_avg = zeros(m, iter_max);
lambda_itr = zeros(m, N);
intgral = zeros(m, N);

Aex = datam.A;

% Run
fprintf('EXC-DD solver starts... \n')
lambda(:,:,1) = lambda0;
lambda_avg(:,1) = sum(lambda0,2)/N;
temp = lambda0*w1;
for jj = 1 : N
    x(:,jj,1) = locfun_randQP(Q(:,:,jj),q(:,jj),A(:,:,jj),...
        l(:,jj),u(:,jj),lambda0(:,jj));
    lambda(:,jj,2) = temp(:,jj) + alpha*(A(:,:,jj)*x(:,jj,1));
end
intgral = intgral + lambda0*w2;
lambda_itr = lambda(:,:,2);
lambda_avg(:,2) = sum(lambda_itr,2)/N;

rsd = norm(Aex*reshape(x(:,:,1),[],1));
fprintf(['Extra at iter. ', num2str(1), ' with ',...
'accuracy ', num2str(rsd), '...\n']);

for ii = 2 : iter_max
    temp = lambda_itr*w1;
    for jj = 1 : N
        x(:,jj,ii) = locfun_randQP(Q(:,:,jj),q(:,jj),A(:,:,jj),...
            l(:,jj),u(:,jj),lambda_itr(:,jj));
        lambda(:,jj,ii) = temp(:,jj) + alpha*(A(:,:,jj)*x(:,jj,ii)) + ...
            intgral(:,jj);    
    end
    intgral = intgral + lambda_itr*w2;
    lambda_itr = lambda(:,:,ii);    
    lambda_avg(:,ii) = sum(lambda_itr,2)/N;  
    
    rsd = norm(Aex*reshape(x(:,:,ii),[],1));
    if rsd < epsl
        fprintf(['Extra succeeds at iter. ', num2str(ii), ' with '...
            'accuracy ', num2str(rsd), '. \n\n'])
        break;
    else
       if mod(ii, 100) == 1
           fprintf(['Extra at iter. ', num2str(ii), ' with ',...
            'accuracy ', num2str(rsd), '...\n'])
       end
       if ii == iter_max
        fprintf(['Extra fails at iter. ', num2str(ii), ' with '...
            'accuracy ', num2str(rsd), '. \n\n'])
       end
    end
end

%%
sol{ind_alg}.x = x;
sol{ind_alg}.x_itr = x_itr;
sol{ind_alg}.lambda = lambda;
sol{ind_alg}.lambda_itr = lambda_itr;
sol{ind_alg}.lambda_avg = lambda_avg;
sol{ind_alg}.alpha = alpha;
sol{ind_alg}.eps = epsl;
sol{ind_alg}.num_itr = ii;

clear iter_max alpha espl w1 w2 x x_itr lambda lambda_itr lambda_avg ...
    lambda0 temp intgral Aex rsd

