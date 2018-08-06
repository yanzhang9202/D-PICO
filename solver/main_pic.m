%% PI Consensus Optimization in the dual domain
% algorithm parameter setting
iter_max = 1e3;     % number of max. iter.
alpha = 1e-3*N;   % step size for the gradient update
beta = 1e-3*1;
wgt = gph.wgt;
eps_pic = 1e-2;

% weight for beta
wgt_beta = wgt;
for ii = 1 : N
    wgt_beta(ii,ii) = -(1 - wgt(ii,ii));
end

% variable initialized
x = zeros(n, N);
x_itr = zeros(n, iter_max, N);
lambda = zeros(m, N);
lambda_itr = zeros(m, iter_max, N);
mu = zeros(m, N);   % integral term
Apic = datam.A;

% Run
fprintf('PIC-DD solver starts... \n')
for ii = 1 : iter_max
    lambda_itr(:,ii,:) = lambda;
    % Solve local problems
    temp = lambda;
    for jj = 1 : N
        x_itr(:,ii,jj) = locfun_randQP(Q(:,:,jj),q(:,jj),A(:,:,jj),...
            l(:,jj),u(:,jj),lambda(:,jj));
        if ii == 1
            mu(:,jj) = temp * wgt(jj,:)' - temp(:,jj);
        else
            mu(:,jj) = temp * wgt(jj,:)' - temp(:,jj) + mu(:,jj);
        end
        lambda(:,jj) = lambda(:,jj) + alpha*A(:,:,jj)*x_itr(:,ii,jj);
    end
    % Consensus step
    lambda = lambda + beta * mu * wgt_beta';
    lambda = lambda * wgt';
    
    % Check the stopping condition (the rsd is not locally available)
    rsd = norm(Apic*reshape(x_itr(:,ii,:),[],1));
    if rsd < eps_pic
        break;
    end
    if mod(ii, 100) == 1
        fprintf(['The ', num2str(ii), ' th iter. done. The rsd is ', ...
            num2str(rsd), '!\n'])
    end
end

if ii < iter_max
    fprintf(['PIC-DD solver succeeds with accuracy ', num2str(rsd), ...
        ' at iter. ', num2str(ii), '.\n\n'])
else
    fprintf(['PIC-DD solver fails with accuracy ', num2str(rsd), ...
        ' at iter. ', num2str(ii), '.\n\n'])
end

%%
sol{ind_alg}.x = reshape(x_itr(:,ii,:),[],1);
sol{ind_alg}.x_itr = x_itr;
sol{ind_alg}.lambda = lambda;
sol{ind_alg}.lambda_itr = lambda_itr;
sol{ind_alg}.alpha = alpha;
sol{ind_alg}.beta = beta;
sol{ind_alg}.eps = eps_pic;
sol{ind_alg}.num_itr = ii;
sol{ind_alg}.mu = mu;
sol{ind_alg}.rsd = rsd;

clear iter_max wgt eps_pic Apic phi x x_itr lambda lambda_itr mu temp