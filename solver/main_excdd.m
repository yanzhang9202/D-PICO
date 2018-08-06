%% W.Shi's EXTRA algorithm in the dual domain
% algorithm parameter setting
iter_max = 1e3;     % number of max. iter.
alpha = 1e-2*N;   % step size for the gradient update
eps_ex = 1e-2;

wgt = gph.wgt;
wgt1 = wgt + eye(N);
wgt2 = 1/2*(wgt + eye(N));

% variable initialized
x = zeros(n, N);
x_itr = zeros(n, iter_max, N);
lambda = zeros(m, N);
lambda_itr = zeros(m, iter_max, N);
Aex = datam.A;

lambda_p = zeros(m, N);

% Run
fprintf('EXC-DD solver starts... \n')
for ii = 1 : iter_max
    lambda_itr(:,ii,:) = lambda;
    % Solve local problems
    temp = lambda;
    for jj = 1 : N
        x_itr(:,ii,jj) = locfun_randQP(Q(:,:,jj),q(:,jj),A(:,:,jj),...
            l(:,jj),u(:,jj),lambda(:,jj));
        % Consensus step
        if ii == 1        
            lambda(:,jj) = temp*wgt(jj,:)' + alpha*A(:,:,jj)*x_itr(:,ii,jj);
            lambda_p = temp;
        else
            lambda(:,jj) = temp*wgt1(jj,:)' - lambda_p*wgt2(jj,:)' + ...
                alpha*A(:,:,jj)*(x_itr(:,ii,jj) - x_itr(:,ii-1,jj));
            lambda_p = temp;
        end
    end
    
    % Check the stopping condition (the rsd is not locally available)
    rsd = norm(Aex*reshape(x_itr(:,ii,:),[],1));
    if rsd < eps_ex
        break;
    end
    if mod(ii, 100) == 1
        fprintf(['The ', num2str(ii), ' th iter. done. The rsd is ', ...
            num2str(rsd), '!\n'])
    end
end

if ii < iter_max
    fprintf(['EXC-DD solver succeeds with accuracy ', num2str(norm(rsd)), ...
        ' at iter. ', num2str(ii), '.\n\n'])
else
    fprintf(['EXC-DD solver fails with accuracy ', num2str(norm(rsd)), ...
        ' at iter. ', num2str(ii), '.\n\n'])
end

%%
sol{ind_alg}.x = reshape(x_itr(:,ii,:),[],1);
sol{ind_alg}.x_itr = x_itr;
sol{ind_alg}.lambda = lambda;
sol{ind_alg}.lambda_itr = lambda_itr;
sol{ind_alg}.alpha = alpha;
sol{ind_alg}.eps = eps_ex;
sol{ind_alg}.num_itr = ii;

clear iter_max wgt eps_ex Aex x x_itr lambda lambda_itr wgt1 wgt2 lambda_p