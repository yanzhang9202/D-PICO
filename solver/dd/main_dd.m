%% Dual decomposition solver
% alg. paramter setting
iter_max = 1e3;
step = 1e-2;
eps_dd = 1e-2;

% initial var.
lambda_itr = zeros(m, 1);
x_itr = zeros(n, iter_max, N);
Add = datam.A;

% Run
fprintf('DD solver starts... \n')
for ii = 1 : iter_max
    % Solve local problems
    for jj = 1 : N
        x_itr(:,ii,jj) = locfun_dd(Q(:,:,jj),q(:,jj),A(:,:,jj),...
            l(:,jj),u(:,jj),lambda_itr);
    end
    % Update the multiplier
    rsd = Add*reshape(x_itr(:,ii,:),[],1);
    if norm(rsd) < eps_dd
        break;
    end
    lambda_itr = lambda_itr + step*rsd;
    if mod(ii, 100) == 1
        fprintf(['The ', num2str(ii), ' th iter. done. The rsd is ', ...
            num2str(norm(rsd)), '!\n'])
    end
end

% Report results
soldd.x = x_itr(:, ii, :);
soldd.x = soldd.x(:);
soldd.x_itr = x_itr;
soldd.lambda = lambda_itr;
soldd.num_itr = ii;
soldd.step = step;
soldd.eps = eps_dd;

clear lambda_itr x_itr Add iter_max step eps_dd

