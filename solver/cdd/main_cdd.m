%% Consensus dual decomposition method
% algorithm parameter setting
iter_max = 1e3;     % number of max. iter.
phi = 1;    % number of consensus rounds at each iter.
alpha = 1e-2*N;   % step size for the gradient update
wgt = gph.wgt^phi;
eps_cdd = 1e-2;

% variable initialized
x = zeros(n, N);
x_itr = zeros(n, iter_max, N);
lambda = zeros(m, N);
lambda_itr = zeros(m, iter_max, N);
Acdd = datam.A;

% Run
fprintf('C-DD solver starts... \n')
for ii = 1 : iter_max
    lambda_itr(:,ii,:) = lambda;
    % Solve local problems
    for jj = 1 : N
        x_itr(:,ii,jj) = locfun_randQP(Q(:,:,jj),q(:,jj),A(:,:,jj),...
            l(:,jj),u(:,jj),lambda(:,jj));
        lambda(:,jj) = lambda(:,jj) + alpha*A(:,:,jj)*x_itr(:,ii,jj);
    end
    % Consensus step
    lambda = lambda * wgt';
    
    % Check the stopping condition (the rsd is not locally available)
    rsd = Acdd*reshape(x_itr(:,ii,:),[],1);
    if norm(rsd) < eps_cdd
        break;
    end
    if mod(ii, 100) == 1
        fprintf(['The ', num2str(ii), ' th iter. done. The rsd is ', ...
            num2str(norm(rsd)), '!\n'])
    end
end

if ii < iter_max
    fprintf(['C-DD solver succeeds with accuracy ', num2str(rsd), ...
        ' and exits.\n\n'])
else
    fprintf(['C-DD solver fails with accuracy ', num2str(rsd), ...
        ' and exits.\n\n'])
end

clear iter_max wgt eps_cdd Acdd