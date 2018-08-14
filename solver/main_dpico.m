%% PI Consensus Optimization
alpha = 1e-2*N;   % Step size
beta = 6e-1;    % Gain for the integral term
iter_max = 1e3;
epsl = 1e-2;
w1 = gph.wgt';
w2 = (gph.wgt - eye(N))';

% variable initialized
x = zeros(n, N, iter_max);
lambda0 = zeros(m, N);
lambda = zeros(m, N, iter_max);
lambda_avg = zeros(m, iter_max);
z_itr = zeros(m, N);    % Integral

Apic = datam.A;

fprintf('D-PICO solver starts... \n')
% Run
lambda(:,:,1) = lambda0;
lambda_avg(:,1) = sum(lambda0,2)/N;
lambda_itr = lambda(:,:,1);
for ii = 2 : iter_max
    temp_l = lambda_itr*w1;
    temp_z = z_itr*w2;
    for jj = 1 : N
        x(:,jj,ii) = locfun_randQP(Q(:,:,jj),q(:,jj),A(:,:,jj),...
            l(:,jj),u(:,jj),lambda_itr(:,jj));               
        lambda(:,jj,ii) = temp_l(:,jj) + beta*temp_z(:,jj) + ...
            alpha*(A(:,:,jj)*x(:,jj,ii));        
    end
    z_itr = z_itr - lambda_itr*w2;
    
    lambda_itr = lambda(:,:,ii);
    lambda_avg(:,ii) = sum(lambda_itr,2)/N;
    
    rsd = norm(Apic*reshape(x(:,:,ii),[],1));
    if rsd < epsl
        fprintf(['D-PICO succeeds at iter. ', num2str(ii), ' with '...
            'accuracy ', num2str(rsd), '. \n\n'])
        break;
    else
       if mod(ii, 100) == 1
           fprintf(['D-PICO at iter. ', num2str(ii), ' with ',...
            'accuracy ', num2str(rsd), '...\n'])
       end
       if ii == iter_max
        fprintf(['D-PICO fails at iter. ', num2str(ii), ' with '...
            'accuracy ', num2str(rsd), '. \n\n'])
       end       
    end    
end
x_itr = x(:,:,ii);

% sol{ind}.x = x;
% sol{ind}.x_itr = x_itr;
% sol{ind}.x_avg = x_avg;
% sol{ind}.z_itr = z_itr;
% sol{ind}.eps = epsl;
% sol{ind}.rsd = rsd;
% sol{ind}.x0 = x0;
% sol{ind}.alpha = alpha;
% sol{ind}.num_itr = ii;
% 
% clear alpha epsl f H ii jj rsd temp_x temp_z w1 w2 x x0 x_avg x_itr z_itr
