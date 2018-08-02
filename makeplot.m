%% make plots to show results
do_lambda = 1;

%% plot the trajectory of lambda
% the lambda returned from matlab is thought as the true value
if do_lambda
    figure(101)
    subplot(1,2,1)
    hold on;
    max_num_itr = 0;
    
    ind_lambda = 1;
    ind_agent = 1;
    
    num_ds = size(ind,2);
%     clrs = rand(num_ds, 3);
    clrs = [1,0,0;
            0,1,0;
            0,0,1];
    for ind_alg = ind
        if ind_alg ~= 1
        num_itr = sol{ind_alg}.num_itr;       
        if max_num_itr < num_itr
            max_num_itr = num_itr;
        end
        if ind_alg > 2
        plot(1:num_itr, sol{ind_alg}.lambda_itr(ind_lambda, ...
            1:num_itr, ind_agent), 'color', clrs(ind_alg,:));           
        else
        plot(1:num_itr, sol{ind_alg}.lambda_itr(ind_lambda, 1:num_itr), ...
            'color', clrs(ind_alg,:));
        end
        end
    end
    plot(1:max_num_itr, sol{1}.lambda.eqlin(ind_lambda)*ones(num_itr,1), 'r--')
    ax = gca;
    set(ax, 'FontSize', 15)
    set(ax, 'XLim', [1, max_num_itr*1.05])
    hold off;
    box on;
    subplot(1,2,2)
    hold on;
    for ind_alg = ind
        if ind_alg ~= 1
            num_itr = sol{ind_alg}.num_itr;
            if ind_alg > 2
            temp = sol{ind_alg}.lambda_itr(:,1:num_itr, ind_agent) ...
                - repmat(sol{1}.lambda.eqlin, 1, num_itr);  
            else
            temp = sol{ind_alg}.lambda_itr(:,1:num_itr) ...
                - repmat(sol{1}.lambda.eqlin, 1, num_itr);    
            end
            dist = sqrt(sum(temp.*temp,1));
            plot(1:num_itr, dist, 'color', clrs(ind_alg,:));
        end
    end
    hold off;
    ax = gca;
    set(ax, 'YScale', 'log')
    set(ax, 'FontSize', 15)
    box on;

    print('plots/lambda_cdd', '-depsc');

    clear dist ax num_ds max_num_itr ind_agent temp
end
